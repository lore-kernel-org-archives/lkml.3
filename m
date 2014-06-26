Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415AbaFZF4K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 01:56:10 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:35726 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752109AbaFZF4I convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 01:56:08 -0400
From: Mohit KUMAR DCG <Mohit.KUMAR@st.com>
To: Kishon Vijay Abraham I <kishon@ti.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "jg1.han@samsung.com" <jg1.han@samsung.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "grant.likely@linaro.org" <grant.likely@linaro.org>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Marek Vasut <marex@denx.de>, Arnd Bergmann <arnd@arndb.de>
Date: Thu, 26 Jun 2014 13:55:34 +0800
Subject: RE: [PATCH 1/3] PCI: designware: Configuration space should be
 specified in 'reg'
Thread-Topic: [PATCH 1/3] PCI: designware: Configuration space should be
 specified in 'reg'
Thread-Index: Ac+QnvC9I2p6n7FJTmWBZBOX2C+CIwAYzYdQ
Message-ID: <2CC2A0A4A178534D93D5159BF3BCB6619C5F94EFC8@EAPEX1MAIL1.st.com>
References: <1403719007-9352-1-git-send-email-kishon@ti.com>
 <1403719007-9352-2-git-send-email-kishon@ti.com>
In-Reply-To: <1403719007-9352-2-git-send-email-kishon@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-26_03:2014-06-25,2014-06-26,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Kishon,

> -----Original Message-----
> From: Kishon Vijay Abraham I [mailto:kishon@ti.com]
> Sent: Wednesday, June 25, 2014 11:27 PM
> To: devicetree@vger.kernel.org; linux-doc@vger.kernel.org; linux-
> pci@vger.kernel.org; jg1.han@samsung.com; bhelgaas@google.com; Mohit
> KUMAR DCG; linux-kernel@vger.kernel.org
> Cc: kishon@ti.com; grant.likely@linaro.org; Jason Gunthorpe; Marek Vasut;
> Arnd Bergmann
> Subject: [PATCH 1/3] PCI: designware: Configuration space should be
> specified in 'reg'
> 
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
>  .../devicetree/bindings/pci/designware-pcie.txt    |    4 ++++
>  drivers/pci/host/pcie-designware.c                 |   17 +++++++++++++++--
>  2 files changed, 19 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/pci/designware-pcie.txt
> b/Documentation/devicetree/bindings/pci/designware-pcie.txt
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
>  - #address-cells: set to <3>
>  - #size-cells: set to <2>
>  - device_type: set to "pci"
> diff --git a/drivers/pci/host/pcie-designware.c b/drivers/pci/host/pcie-
> designware.c
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
> @@ -396,11 +397,23 @@ static const struct irq_domain_ops
> msi_domain_ops = {  int __init dw_pcie_host_init(struct pcie_port *pp)  {
>  	struct device_node *np = pp->dev->of_node;
> +	struct platform_device *pdev = to_platform_device(pp->dev);
>  	struct of_pci_range range;
>  	struct of_pci_range_parser parser;
> +	struct resource *cfg_res;
>  	u32 val;
>  	int i;
> 
> +	cfg_res = platform_get_resource_byname(pdev,
> IORESOURCE_MEM, "config");
> +	if (cfg_res) {
> +		pp->config.cfg0_size = resource_size(cfg_res)/2;
> +		pp->config.cfg1_size = resource_size(cfg_res)/2;
> +		pp->cfg0_base = cfg_res->start;
> +		pp->cfg1_base = cfg_res->start + pp->config.cfg0_size;
> +	} else {
> +		dev_err(pp->dev, "missing *config* reg space\n");

- so this message will remind other platform to comply and specify configuration space
 in *reg* property. 

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
> +			pp->cfg1_base = pp->cfg.start + pp-
> >config.cfg0_size;
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

Reviewed and Acked-by: Mohit Kumar <mohit.kumar@st.com>

Regards
Mohit

> --
> 1.7.9.5

