Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018AbaIPV4B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 17:56:01 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:63323 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851AbaIPVz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 17:55:58 -0400
Date: Tue, 16 Sep 2014 15:55:54 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Murali Karicheri <m-karicheri2@ti.com>
Cc: robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, arnd@arndb.de,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3 1/2] PCI: keystone: remove handle of PCI mode
 configuration
Message-ID: <20140916215554.GC5050@google.com>
References: <1410369159-11564-1-git-send-email-m-karicheri2@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410369159-11564-1-git-send-email-m-karicheri2@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 10, 2014 at 01:12:38PM -0400, Murali Karicheri wrote:
> Keystone PCI hardware supports both RC and EP modes and devcfg
> register has bits to boot strap the device to either of these modes.
> It seems proper to add this functionality to the boot loader rather
> than in the driver as device will be operating in either mode, not
> both any time. Currently the driver supports only RC mode and hence
> register configuration in the driver is not needed and driver can
> assume this is a RC hardware.
> 
> Also update the DT documentation accordingly.
> 
> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>
> Acked-by: Arnd Bergmann <arnd@arndb.de>

Both applied to pci/host-keystone for v3.18, thanks!

> ---
> 	v3 - No change
> 	v2 - Added this separate patch to remove pci mode handling
>  .../devicetree/bindings/pci/pci-keystone.txt       |    4 +---
>  drivers/pci/host/pci-keystone.c                    |   21 ++------------------
>  2 files changed, 3 insertions(+), 22 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/pci/pci-keystone.txt b/Documentation/devicetree/bindings/pci/pci-keystone.txt
> index ceb3e24..bedacf0 100644
> --- a/Documentation/devicetree/bindings/pci/pci-keystone.txt
> +++ b/Documentation/devicetree/bindings/pci/pci-keystone.txt
> @@ -13,9 +13,7 @@ Required Properties:-
>  
>  compatibility: "ti,keystone-pcie"
>  reg:	index 1 is the base address and length of DW application registers.
> -	index 2 is the base address and length of PCI mode configuration
> -	register.
> -	index 3 is the base address and length of PCI device ID register.
> +	index 2 is the base address and length of PCI device ID register.
>  
>  pcie_msi_intc : Interrupt controller device node for MSI IRQ chip
>  	interrupt-cells: should be set to 1
> diff --git a/drivers/pci/host/pci-keystone.c b/drivers/pci/host/pci-keystone.c
> index ff8ed25..f1119eb 100644
> --- a/drivers/pci/host/pci-keystone.c
> +++ b/drivers/pci/host/pci-keystone.c
> @@ -35,10 +35,6 @@
>  #define MAX_MSI_HOST_IRQS		8
>  #define MAX_LEGACY_HOST_IRQS		4
>  
> -/* RC mode settings masks */
> -#define PCIE_RC_MODE		BIT(2)
> -#define PCIE_MODE_MASK		(BIT(1) | BIT(2))
> -
>  /* DEV_STAT_CTRL */
>  #define PCIE_CAP_BASE		0x70
>  
> @@ -355,7 +351,6 @@ static int __init ks_pcie_probe(struct platform_device *pdev)
>  	void __iomem *reg_p;
>  	struct phy *phy;
>  	int ret = 0;
> -	u32 val;
>  
>  	ks_pcie = devm_kzalloc(&pdev->dev, sizeof(*ks_pcie),
>  				GFP_KERNEL);
> @@ -365,18 +360,6 @@ static int __init ks_pcie_probe(struct platform_device *pdev)
>  	}
>  	pp = &ks_pcie->pp;
>  
> -	/* index 2 is the devcfg register for RC mode settings */
> -	res = platform_get_resource(pdev, IORESOURCE_MEM, 2);
> -	reg_p = devm_ioremap_resource(dev, res);
> -	if (IS_ERR(reg_p))
> -		return PTR_ERR(reg_p);
> -
> -	/* enable RC mode in devcfg */
> -	val = readl(reg_p);
> -	val &= ~PCIE_MODE_MASK;
> -	val |= PCIE_RC_MODE;
> -	writel(val, reg_p);
> -
>  	/* initialize SerDes Phy if present */
>  	phy = devm_phy_get(dev, "pcie-phy");
>  	if (!IS_ERR_OR_NULL(phy)) {
> @@ -385,8 +368,8 @@ static int __init ks_pcie_probe(struct platform_device *pdev)
>  			return ret;
>  	}
>  
> -	/* index 3 is to read PCI DEVICE_ID */
> -	res = platform_get_resource(pdev, IORESOURCE_MEM, 3);
> +	/* index 2 is to read PCI DEVICE_ID */
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 2);
>  	reg_p = devm_ioremap_resource(dev, res);
>  	if (IS_ERR(reg_p))
>  		return PTR_ERR(reg_p);
> -- 
> 1.7.9.5
> 
