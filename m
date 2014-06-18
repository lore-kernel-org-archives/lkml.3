Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932959AbaFRHGp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 03:06:45 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:58484 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751498AbaFRHGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 03:06:43 -0400
Date: Wed, 18 Jun 2014 12:35:01 +0530
From: Pratyush Anand <pratyush.anand@st.com>
To: Murali Karicheri <m-karicheri2@ti.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Mohit KUMAR DCG <Mohit.KUMAR@st.com>,
        Jingoo Han <jg1.han@samsung.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Richard Zhu <r65037@freescale.com>,
        Kishon Vijay Abraham I <kishon@ti.com>, Marek Vasut <marex@denx.de>,
        Arnd Bergmann <arnd@arndb.de>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH v2 2/8] PCI: designware: refactor host init code to
 re-use on v3.65 DW pci hw
Message-ID: <20140618070500.GB6098@pratyush-vbox>
References: <1402426287-31157-1-git-send-email-m-karicheri2@ti.com>
 <1402426287-31157-3-git-send-email-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1402426287-31157-3-git-send-email-m-karicheri2@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-18_03:2014-06-17,2014-06-18,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Murali,

On Wed, Jun 11, 2014 at 02:51:21AM +0800, Murali Karicheri wrote:
> Current DW PCI host init code has code specific to newer hw such as
> ATU port specific resource parsing and map. v3.65 DW PCI host has

OK, Older version did not had standard viewport implementation, so patch 1
of this series will help you to take care for that.

> MSI controller in application space and requires different controller

Since MSI controller is implemented in application space, so this may
not be same for different older version dw controller users.

Therefore, I would suggest to implement all application specific code
in your keystone driver only.

> initialization code. So refactor the msi host controller code into a
> separate function. Other common functions across both hw versions
> are moved to dw_pcie_common_host_init() and called from the newer and
> v3.65 hw host initialization code.
> 
> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
> 
> CC: Santosh Shilimkar <santosh.shilimkar@ti.com>
> CC: Russell King <linux@arm.linux.org.uk>
> CC: Grant Likely <grant.likely@linaro.org>
> CC: Rob Herring <robh+dt@kernel.org>
> CC: Mohit Kumar <mohit.kumar@st.com>
> CC: Jingoo Han <jg1.han@samsung.com>
> CC: Bjorn Helgaas <bhelgaas@google.com>
> CC: Pratyush Anand <pratyush.anand@st.com>
> CC: Richard Zhu <r65037@freescale.com>
> CC: Kishon Vijay Abraham I <kishon@ti.com>
> CC: Marek Vasut <marex@denx.de>
> CC: Arnd Bergmann <arnd@arndb.de>
> CC: Pawel Moll <pawel.moll@arm.com>
> CC: Mark Rutland <mark.rutland@arm.com>
> CC: Ian Campbell <ijc+devicetree@hellion.org.uk>
> CC: Kumar Gala <galak@codeaurora.org>
> CC: Randy Dunlap <rdunlap@infradead.org>
> CC: Grant Likely <grant.likely@linaro.org> 
> 
> ---
>  drivers/pci/host/pcie-designware.c |  136 ++++++++++++++++++++++++++----------
>  1 file changed, 101 insertions(+), 35 deletions(-)
> 
> diff --git a/drivers/pci/host/pcie-designware.c b/drivers/pci/host/pcie-designware.c
> index e8f5d8d..e4bd19a 100644
> --- a/drivers/pci/host/pcie-designware.c
> +++ b/drivers/pci/host/pcie-designware.c
> @@ -389,13 +389,19 @@ static const struct irq_domain_ops msi_domain_ops = {
>  	.map = dw_pcie_msi_map,
>  };
>  
> -int __init dw_pcie_host_init(struct pcie_port *pp)
> +/*
> + * dw_pcie_parse_resource() - Function to parse common resources
> + *
> + * @pp: ptr to pcie port
> + *
> + * Parse the range property for MEM, IO and cfg resources, and map
> + * the cfg register space.
> + */

Why do you need this function? If you have some extra resource, you
can ioremap that before you call dw_pcie_host_init.


> +int __init dw_pcie_parse_resource(struct pcie_port *pp)
>  {
>  	struct device_node *np = pp->dev->of_node;
>  	struct of_pci_range range;
>  	struct of_pci_range_parser parser;
> -	u32 val;
> -	int i;
>  
>  	if (of_pci_range_parser_init(&parser, np)) {
>  		dev_err(pp->dev, "missing ranges property\n");
> @@ -431,41 +437,29 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
>  			pp->config.cfg1_size = resource_size(&pp->cfg)/2;
>  		}
>  	}
> -
> -	if (!pp->dbi_base) {
> -		pp->dbi_base = devm_ioremap(pp->dev, pp->cfg.start,
> -					resource_size(&pp->cfg));
> -		if (!pp->dbi_base) {
> -			dev_err(pp->dev, "error with ioremap\n");
> -			return -ENOMEM;
> -		}
> -	}
> -
> -	pp->cfg0_base = pp->cfg.start;
> -	pp->cfg1_base = pp->cfg.start + pp->config.cfg0_size;
>  	pp->mem_base = pp->mem.start;
>  
> -	pp->va_cfg0_base = devm_ioremap(pp->dev, pp->cfg0_base,
> -					pp->config.cfg0_size);
> -	if (!pp->va_cfg0_base) {
> -		dev_err(pp->dev, "error with ioremap in function\n");
> -		return -ENOMEM;
> -	}
> -	pp->va_cfg1_base = devm_ioremap(pp->dev, pp->cfg1_base,
> -					pp->config.cfg1_size);
> -	if (!pp->va_cfg1_base) {
> -		dev_err(pp->dev, "error with ioremap\n");
> -		return -ENOMEM;
> -	}
> +	return 0;
> +}
>  
> -	if (of_property_read_u32(np, "num-lanes", &pp->lanes)) {
> -		dev_err(pp->dev, "Failed to parse the number of lanes\n");
> -		return -EINVAL;
> -	}
> +/*
> + * dw_pcie_msi_host_init() - Function to initialize msi host controller
> + *
> + * @pp: ptr to pcie port
> + * @np: device node ptr to msi irq controller
> + * @irq_msi_ops: ptr to MSI irq_domain_ops struct
> + *
> + * Function register irq domain for msi irq controller and create mappings
> + * for MSI irqs.
> + */


May be you can only do following to support your MSI chip:

Initialize pp->irq_domain into your add_pcie_port function before you
call dw_pcie_host_init.

In dw_pcie_host_init, 

if (IS_ENABLED(CONFIG_PCI_MSI) && !pp->irq_domain)


> +int dw_pcie_msi_host_init(struct pcie_port *pp, struct device_node *np,
> +				const struct irq_domain_ops *irq_msi_ops)
> +{
> +	int i;
>  
>  	if (IS_ENABLED(CONFIG_PCI_MSI)) {
>  		pp->irq_domain = irq_domain_add_linear(pp->dev->of_node,
> -					MAX_MSI_IRQS, &msi_domain_ops,
> +					MAX_MSI_IRQS, irq_msi_ops,
>  					&dw_pcie_msi_chip);
>  		if (!pp->irq_domain) {
>  			dev_err(pp->dev, "irq domain init failed\n");
> @@ -476,6 +470,29 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
>  			irq_create_mapping(pp->irq_domain, i);
>  	}
>  
> +	return 0;
> +}
> +
> +/*
> + * dw_pcie_common_host_init() - common host init function across different
> + *				versions of the designware PCI controller.
> + * @pp: ptr to pcie port
> + * @hw: ptr to hw_pci structure
> + *
> + * This functions parses common DT properties, call host_init() callback
> + * of the PCI controller driver. Also initialize the common RC configurations
> + * and call common pci core function to intialize the controller driver.
> + */
> +int __init dw_pcie_common_host_init(struct pcie_port *pp, struct hw_pci *hw)
> +{
> +	struct device_node *np = pp->dev->of_node;
> +	u32 val;
> +
> +	if (of_property_read_u32(np, "num-lanes", &pp->lanes)) {
> +		dev_err(pp->dev, "Failed to parse the number of lanes\n");
> +		return -EINVAL;
> +	}
> +
>  	if (pp->ops->host_init)
>  		pp->ops->host_init(pp);
>  
> @@ -488,10 +505,10 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
>  	val |= PORT_LOGIC_SPEED_CHANGE;
>  	dw_pcie_wr_own_conf(pp, PCIE_LINK_WIDTH_SPEED_CONTROL, 4, val);
>  
> -	dw_pci.nr_controllers = 1;
> -	dw_pci.private_data = (void **)&pp;
> +	hw->nr_controllers = 1;
> +	hw->private_data = (void **)&pp;
>  
> -	pci_common_init_dev(pp->dev, &dw_pci);
> +	pci_common_init_dev(pp->dev, hw);
>  	pci_assign_unassigned_resources();
>  #ifdef CONFIG_PCI_DOMAINS
>  	dw_pci.domain++;
> @@ -500,6 +517,55 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
>  	return 0;
>  }
>  
> +/*
> + * dw_pcie_host_init() - Host init function for new designware h/w
> + *
> + * @pp: ptr to pcie port
> + *
> + * The function parse the PCI resurces for IO, Memory and map the config
> + * space addresses. Also initliaze the MSI irq controller and call
> + * dw_pcie_common_host_init() to initialize the PCI controller.
> + */
> +int __init dw_pcie_host_init(struct pcie_port *pp)
> +{
> +	int ret;
> +
> +	ret = dw_pcie_parse_resource(pp);
> +	if (ret)
> +		return ret;
> +
> +	if (!pp->dbi_base) {
> +		pp->dbi_base = devm_ioremap(pp->dev, pp->cfg.start,
> +					resource_size(&pp->cfg));
> +		if (!pp->dbi_base) {
> +			dev_err(pp->dev, "error with ioremap\n");
> +			return -ENOMEM;
> +		}
> +	}
> +
> +	pp->cfg0_base = pp->cfg.start;
> +	pp->cfg1_base = pp->cfg.start + pp->config.cfg0_size;
> +
> +	pp->va_cfg0_base = devm_ioremap(pp->dev, pp->cfg0_base,
> +					pp->config.cfg0_size);
> +	if (!pp->va_cfg0_base) {
> +		dev_err(pp->dev, "error with ioremap in function\n");
> +		return -ENOMEM;
> +	}
> +	pp->va_cfg1_base = devm_ioremap(pp->dev, pp->cfg1_base,
> +					pp->config.cfg1_size);
> +	if (!pp->va_cfg1_base) {
> +		dev_err(pp->dev, "error with ioremap\n");
> +		return -ENOMEM;
> +	}
> +
> +	ret = dw_pcie_msi_host_init(pp, pp->dev->of_node, &msi_domain_ops);
> +	if (ret < 0)
> +		return ret;
> +
> +	return dw_pcie_common_host_init(pp, &dw_pci);
> +}
> +
>  static void dw_pcie_prog_viewport_cfg0(struct pcie_port *pp, u32 busdev)
>  {
>  	/* Program viewport 0 : OUTBOUND : CFG0 */

Regards
Pratyush

> -- 
> 1.7.9.5
