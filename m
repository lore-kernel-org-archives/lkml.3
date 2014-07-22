Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890AbaGVUxe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 16:53:34 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:57598 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756857AbaGVUxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 16:53:32 -0400
Date: Tue, 22 Jul 2014 14:53:26 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-pci@vger.kernel.org, jg1.han@samsung.com, mohit.kumar@st.com,
        linux-kernel@vger.kernel.org, grant.likely@linaro.org,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Marek Vasut <marex@denx.de>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v3 1/4] PCI: designware: Configuration space should be
 specified in 'reg'
Message-ID: <20140722205326.GA25432@google.com>
References: <1405587643-13808-1-git-send-email-kishon@ti.com>
 <1405587643-13808-2-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405587643-13808-2-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 02:30:40PM +0530, Kishon Vijay Abraham I wrote:
> The configuration address space has so far been specified in *ranges*,
> however it should be specified in *reg* making it a platform MEM resource.
> Hence used 'platform_get_resource_*' API to get configuration address
> space in the designware driver.
> 
> Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Marek Vasut <marex@denx.de>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> Acked-by: Mohit Kumar <mohit.kumar@st.com>
> Acked-by: Jingoo Han <jg1.han@samsung.com>
> ---
>  .../devicetree/bindings/pci/designware-pcie.txt    |    4 ++++
>  drivers/pci/host/pcie-designware.c                 |   17 +++++++++++++++--
>  2 files changed, 19 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/pci/designware-pcie.txt b/Documentation/devicetree/bindings/pci/designware-pcie.txt
> index d0d15ee..ed0d9b9 100644
> --- a/Documentation/devicetree/bindings/pci/designware-pcie.txt
> +++ b/Documentation/devicetree/bindings/pci/designware-pcie.txt
> @@ -2,6 +2,10 @@
>  
>  Required properties:
>  - compatible: should contain "snps,dw-pcie" to identify the core.
> +- reg: Should contain the configuration address space.
> +- reg-names: Must be "config" for the PCIe configuration space.
> +    (The old way of getting the configuration address space from "ranges"
> +    is deprecated and should be avoided.)

I'm not a devicetree person, so please excuse my floundering here.
There doesn't seem to be consistent usage of "reg" or "reg-names".
Here's what I found in the existing Documentation/devicetree/bindings/pci
stuff:

  83xx-512x-pci.txt
    - reg: should contain two address length tuples
	The first is for the internal pci bridge registers
	The second is for the pci config space access registers

  fsl,imx6q-pcie.txt
    - reg: base addresse and length of the pcie controller

  host-generic-pci.txt
    - reg            : The Configuration Space base address and size, as accessed
		       from the parent bus.

  nvidia,tegra20-pcie.txt
    - reg: A list of physical base address and length for each set of controller
      registers. Must contain an entry for each entry in the reg-names property.
    - reg-names: Must include the following entries:
      "pads": PADS registers
      "afi": AFI registers
      "cs": configuration space region

  pci-rcar-gen2.txt
    - reg:  A list of physical regions to access the device: the first is
	    the operational registers for the OHCI/EHCI controllers and the
	    second is for the bridge configuration and control registers.

  ralink,rt3883-pci.txt
     - reg: specifies the physical base address of the controller and
       the length of the memory mapped region.

  rcar-pci.txt
    - reg: base address and length of the pcie controller registers.

  samsung,exynos5440-pcie.txt
    - reg: base addresses and lengths of the pcie controller,
	  the phy controller, additional register for the phy controller.

  v3-v360epc-pci.txt
    - reg: should contain the base address of the V3 adapter.

So my questions are:

1) Is "reg" the right place for configuration space?  I assume this is
CAM or ECAM.  Only 83xx-512x-pci.txt, host-generic-pci.txt, and
nvidia,tegra20-pcie.txt mention using "reg" for config space; all the
others use "reg" for register space for the PCIe controller itself.

2) Is "config" the correct value for "reg-names"?  Only
nvidia,tegra20-pcie.txt has something similar, and it wants "cs".
Should these be the same?

3) Doesn't this add a revlock (kernels with this patch require a new
device tree that adds "reg" and "reg-names"?  I know both Mohit and
Jingoo acked this [1,2], so I'm just double-checking that this is
expected and desired.

Bjorn

[1] http://lkml.kernel.org/r/2CC2A0A4A178534D93D5159BF3BCB6619C5F94EFC8@EAPEX1MAIL1.st.com
[2] http://marc.info/?l=linux-pci&m=140482389231290&w=2


>  - #address-cells: set to <3>
>  - #size-cells: set to <2>
>  - device_type: set to "pci"
> diff --git a/drivers/pci/host/pcie-designware.c b/drivers/pci/host/pcie-designware.c
> index 1eaf4df..0b7b455 100644
> --- a/drivers/pci/host/pcie-designware.c
> +++ b/drivers/pci/host/pcie-designware.c
> @@ -20,6 +20,7 @@
>  #include <linux/of_pci.h>
>  #include <linux/pci.h>
>  #include <linux/pci_regs.h>
> +#include <linux/platform_device.h>
>  #include <linux/types.h>
>  
>  #include "pcie-designware.h"
> @@ -396,11 +397,23 @@ static const struct irq_domain_ops msi_domain_ops = {
>  int __init dw_pcie_host_init(struct pcie_port *pp)
>  {
>  	struct device_node *np = pp->dev->of_node;
> +	struct platform_device *pdev = to_platform_device(pp->dev);
>  	struct of_pci_range range;
>  	struct of_pci_range_parser parser;
> +	struct resource *cfg_res;
>  	u32 val;
>  	int i;
>  
> +	cfg_res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "config");
> +	if (cfg_res) {
> +		pp->config.cfg0_size = resource_size(cfg_res)/2;
> +		pp->config.cfg1_size = resource_size(cfg_res)/2;
> +		pp->cfg0_base = cfg_res->start;
> +		pp->cfg1_base = cfg_res->start + pp->config.cfg0_size;
> +	} else {
> +		dev_err(pp->dev, "missing *config* reg space\n");
> +	}
> +
>  	if (of_pci_range_parser_init(&parser, np)) {
>  		dev_err(pp->dev, "missing ranges property\n");
>  		return -EINVAL;
> @@ -433,6 +446,8 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
>  			of_pci_range_to_resource(&range, np, &pp->cfg);
>  			pp->config.cfg0_size = resource_size(&pp->cfg)/2;
>  			pp->config.cfg1_size = resource_size(&pp->cfg)/2;
> +			pp->cfg0_base = pp->cfg.start;
> +			pp->cfg1_base = pp->cfg.start + pp->config.cfg0_size;
>  		}
>  	}
>  
> @@ -445,8 +460,6 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
>  		}
>  	}
>  
> -	pp->cfg0_base = pp->cfg.start;
> -	pp->cfg1_base = pp->cfg.start + pp->config.cfg0_size;
>  	pp->mem_base = pp->mem.start;
>  
>  	pp->va_cfg0_base = devm_ioremap(pp->dev, pp->cfg0_base,
> -- 
> 1.7.9.5
> 
