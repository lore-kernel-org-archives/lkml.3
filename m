Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757920AbaE2QdQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 12:33:16 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:55147 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757135AbaE2QdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 12:33:12 -0400
Message-ID: <53876116.90504@ti.com>
Date: Thu, 29 May 2014 12:32:22 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: "ABRAHAM, KISHON VIJAY" <kishon@ti.com>
CC: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>, "tony@atomide.com" <tony@atomide.com>,
        "jg1.han@samsung.com" <jg1.han@samsung.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Mohit Kumar <mohit.kumar@st.com>,
        Marek Vasut <marex@denx.de>
Subject: Re: [PATCH v2 03/18] PCI: designware: Configuration space should
 be specified in 'reg'
References: <1401345500-20188-1-git-send-email-kishon@ti.com> <1401345500-20188-4-git-send-email-kishon@ti.com>
In-Reply-To: <1401345500-20188-4-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/29/2014 2:38 AM, ABRAHAM, KISHON VIJAY wrote:
> The configuration address space has so far been specified in *ranges*,
> however it should be specified in *reg* making it a platform MEM resource.
> Hence used 'platform_get_resource_*' API to get configuration address
> space in the designware driver.
>
> Cc: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Mohit Kumar <mohit.kumar@st.com>
> Cc: Jingoo Han <jg1.han@samsung.com>
> Cc: Marek Vasut <marex@denx.de>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>   .../devicetree/bindings/pci/designware-pcie.txt    |    1 +
>   drivers/pci/host/pcie-designware.c                 |   17 +++++++++++++++--
>   2 files changed, 16 insertions(+), 2 deletions(-)
>
> diff --git a/Documentation/devicetree/bindings/pci/designware-pcie.txt b/Documentation/devicetree/bindings/pci/designware-pcie.txt
> index d6fae13..8314360 100644
> --- a/Documentation/devicetree/bindings/pci/designware-pcie.txt
> +++ b/Documentation/devicetree/bindings/pci/designware-pcie.txt
> @@ -6,6 +6,7 @@ Required properties:
>   	as "samsung,exynos5440-pcie" or "fsl,imx6q-pcie".
>   - reg: base addresses and lengths of the pcie controller,
>   	the phy controller, additional register for the phy controller.
> +	The configuration address space should also be specified here.
Kishon,

I am working on the Keystone PCI driver for which v1 is already posted. 
Want to clarify
following.
1. Original text for reg states "base addresses and lengths of the pcie 
controller,
         the phy controller, additional register for the phy controller" 
and you added
         "The configuration address space should also be specified here"

    and the code below added resource name "config"

Does PCI designware follow some convention? Does it mean after applying 
this patch
config name is mandatory or optional? Below code you are not returning 
error. Can you
or author of PCI designware clarify what is expected to be present as 
mandatory and
what is optional.

Does config refers to RC's config space or EP's config space or both? 
The code below divide
the size by 2. So it appears to be RC's + EP's config space. Please clarify.

>   - interrupts: interrupt values for level interrupt,
>   	pulse interrupt, special interrupt.
>   - clocks: from common clock binding: handle to pci clock.
> diff --git a/drivers/pci/host/pcie-designware.c b/drivers/pci/host/pcie-designware.c
> index c4e3732..603b386 100644
> --- a/drivers/pci/host/pcie-designware.c
> +++ b/drivers/pci/host/pcie-designware.c
> @@ -20,6 +20,7 @@
>   #include <linux/of_pci.h>
>   #include <linux/pci.h>
>   #include <linux/pci_regs.h>
> +#include <linux/platform_device.h>
>   #include <linux/types.h>
>   
>   #include "pcie-designware.h"
> @@ -392,11 +393,23 @@ static const struct irq_domain_ops msi_domain_ops = {
>   int __init dw_pcie_host_init(struct pcie_port *pp)
>   {
>   	struct device_node *np = pp->dev->of_node;
> +	struct platform_device *pdev = to_platform_device(pp->dev);
>   	struct of_pci_range range;
>   	struct of_pci_range_parser parser;
> +	struct resource *cfg_res;
>   	u32 val;
>   	int i;
>   
> +	cfg_res = platform_get_resource_byname(pdev, IORESOURCE_MEM, "config");
> +	if (cfg_res) {
> +		pp->config.cfg0_size = resource_size(cfg_res)/2;
> +		pp->config.cfg1_size = resource_size(cfg_res)/2;
> +		pp->cfg0_base = cfg_res->start;
> +		pp->cfg1_base = cfg_res->start + pp->config.cfg0_size;
> +	} else {
> +		dev_err(pp->dev, "missing *config* reg space\n");
This should return error -EINVAL.

> +	}
> +
>   	if (of_pci_range_parser_init(&parser, np)) {
>   		dev_err(pp->dev, "missing ranges property\n");
>   		return -EINVAL;
> @@ -429,6 +442,8 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
>   			of_pci_range_to_resource(&range, np, &pp->cfg);
>   			pp->config.cfg0_size = resource_size(&pp->cfg)/2;
>   			pp->config.cfg1_size = resource_size(&pp->cfg)/2;
> +			pp->cfg0_base = pp->cfg.start;
> +			pp->cfg1_base = pp->cfg.start + pp->config.cfg0_size;
>   		}
>   	}
>   
> @@ -441,8 +456,6 @@ int __init dw_pcie_host_init(struct pcie_port *pp)
>   		}
>   	}
>   
> -	pp->cfg0_base = pp->cfg.start;
> -	pp->cfg1_base = pp->cfg.start + pp->config.cfg0_size;
>   	pp->mem_base = pp->mem.start;
>   
>   	pp->va_cfg0_base = devm_ioremap(pp->dev, pp->cfg0_base,
BTW, Please also review my Keystone series so that we could discuss this 
topic in that context
as well.

