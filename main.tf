provider "aws" {
  region = "eu-west-3" # Paris
}


# ---------------------------------------------------------
# Data source que obtiene ultma version AMI Amazon Linux 2
# ---------------------------------------------------------
data "aws_ami" "amazon_linux_2" {
    owners      = ["amazon"]
    most_recent = true
  
    filter {
        name   = "name"
        values = ["amzn2-ami-hvm-*-x86_64-ebs"]
    }
    
    filter {
        name   = "root-device-type"
        values = ["ebs"]
    }
    
    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }
    
    filter {
        name   = "architecture"
        values = ["x86_64"]
    }
}

# ---------------------------------------------------------
# Estado remoto
# ---------------------------------------------------------
data "terraform_remote_state" "base" {
  backend = "local"

  config = {
    path = var.path
  }
}

resource "aws_instance" "web" {
    ami           = data.aws_ami.amazon_linux_2.id
    instance_type = "t3a.micro"
    subnet_id     = data.terraform_remote_state.base.outputs.public_subnets[0]

    tags = {
        Name = "instancia-tonta"
    }
}
