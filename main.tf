provider "aws" {
  region = var.region
}

module "vpc" {
  source  = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
  vpc_name = "${var.prefix}-vpc"
}

module "public_subnets" {
  source             = "./modules/public_subnets"
  vpc_id             = module.vpc.vpc_id
  subnet_cidrs       = var.public_subnet_cidrs
  subnet_names       = [for i in range(length(var.public_subnet_cidrs)) : "${var.prefix}-public-subnet-${i+1}"]
  availability_zones = var.availability_zones
}

module "private_subnets" {
  source             = "./modules/private_subnets"
  vpc_id             = module.vpc.vpc_id
  subnet_cidrs       = var.private_subnet_cidrs
  subnet_names       = [for i in range(length(var.private_subnet_cidrs)) : "${var.prefix}-private-subnet-${i+1}"]
  availability_zones = var.availability_zones
}

module "security_group" {
  source               = "./modules/security_group"
  vpc_id               = module.vpc.vpc_id
  security_group_name  = "${var.prefix}-sg"
}
