Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933496AbaDVRVC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 13:21:02 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:53218 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932902AbaDVRU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 13:20:57 -0400
Message-ID: <5356A4F4.6090107@gmail.com>
Date: Tue, 22 Apr 2014 19:20:52 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
To: =?UTF-8?B?QW50b2luZSBUw6luYXJ0?= 
	<antoine.tenart@free-electrons.com>,
        tj@kernel.org
CC: alexandre.belloni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, linux-arm-kernel@lists.infradead.org,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] ata: ahci: add AHCI support for Berlin SoCs
References: <1398181105-19714-1-git-send-email-antoine.tenart@free-electrons.com> <1398181105-19714-2-git-send-email-antoine.tenart@free-electrons.com>
In-Reply-To: <1398181105-19714-2-git-send-email-antoine.tenart@free-electrons.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/22/2014 05:38 PM, Antoine Ténart wrote:
> Add support for the Berlin SoCs AHCI SATA controller allowing to
> interface with devices like external hard drives.
> 
> Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
> ---
>  drivers/ata/Kconfig       |   9 +++
>  drivers/ata/Makefile      |   1 +
>  drivers/ata/ahci_berlin.c | 175 ++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 185 insertions(+)
>  create mode 100644 drivers/ata/ahci_berlin.c
> 
> diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
> index 20e03a7eb8b4..c985dfcd5a6c 100644
> --- a/drivers/ata/Kconfig
> +++ b/drivers/ata/Kconfig
> @@ -97,6 +97,15 @@ config SATA_AHCI_PLATFORM
>  
>  	  If unsure, say N.
>  
> +config AHCI_BERLIN
> +	tristate "Marvell Berlin AHCI SATA support"
> +	depends on ARCH_BERLIN
> +	help
> +	  This option enables support for the Marvell Berlin SoC's
> +	  onboard AHCI SATA.
> +
> +	  If unsure, say N.
> +
>  config AHCI_DA850
>  	tristate "DaVinci DA850 AHCI SATA support"
>  	depends on ARCH_DAVINCI_DA850
> diff --git a/drivers/ata/Makefile b/drivers/ata/Makefile
> index 44c8016e565c..7fb78d1e0a44 100644
> --- a/drivers/ata/Makefile
> +++ b/drivers/ata/Makefile
> @@ -10,6 +10,7 @@ obj-$(CONFIG_SATA_INIC162X)	+= sata_inic162x.o
>  obj-$(CONFIG_SATA_SIL24)	+= sata_sil24.o
>  obj-$(CONFIG_SATA_DWC)		+= sata_dwc_460ex.o
>  obj-$(CONFIG_SATA_HIGHBANK)	+= sata_highbank.o libahci.o
> +obj-$(CONFIG_AHCI_BERLIN)	+= ahci_berlin.o libahci.o libahci_platform.o
>  obj-$(CONFIG_AHCI_DA850)	+= ahci_da850.o libahci.o libahci_platform.o
>  obj-$(CONFIG_AHCI_IMX)		+= ahci_imx.o libahci.o libahci_platform.o
>  obj-$(CONFIG_AHCI_SUNXI)	+= ahci_sunxi.o libahci.o libahci_platform.o
> diff --git a/drivers/ata/ahci_berlin.c b/drivers/ata/ahci_berlin.c
> new file mode 100644
> index 000000000000..cf1c9d3b9d18
> --- /dev/null
> +++ b/drivers/ata/ahci_berlin.c
> @@ -0,0 +1,175 @@
> +/*
> + * Marvell Berlin AHCI SATA platform driver
> + *
> + * Copyright (C) 2014 Marvell Technology Group Ltd.
> + *
> + * Antoine Ténart <antoine.tenart@free-electrons.com>
> + *
> + * This file is licensed under the terms of the GNU General Public
> + * License version 2. This program is licensed "as is" without any
> + * warranty of any kind, whether express or implied.
> + */
> +
> +#include <linux/ahci_platform.h>
> +#include <linux/module.h>
> +#include <linux/of_device.h>
> +#include <linux/platform_device.h>
> +
> +#include "ahci.h"
> +
> +#define PORT_VSR_ADDR		0x78
> +#define PORT_VSR_DATA		0x7C
> +#define HOST_VSA_ADDR		0xA0
> +#define HOST_VSA_DATA		0xA4
> +
> +static inline void ahci_berlin_reg_setbits(void __iomem *reg, u32 val)
> +{
> +	u32 regval;
> +
> +	regval = readl(reg);
> +	regval |= val;
> +	writel(regval, reg);
> +}
> +
> +static inline void ahci_berlin_reg_set(void __iomem *reg, u32 val)
> +{
> +	writel(val, reg);
> +}

Antoine,

if you really need to rename writel, the above function name should
end with _write.

> +static inline void ahci_berlin_reg_clear_set(void __iomem *reg, u32 clear_val,
> +					     u32 set_val)
> +{
> +	u32 regval;
> +
> +	regval = readl(reg);
> +	regval &= ~(clear_val);
> +	regval |= set_val;
> +	writel(regval, reg);
> +}

ahci_berlin_reg_setbits(reg, val) == ahci_berlin_reg_clear_set(reg, 0, val);

Maybe get rid of the latter?

> +static void ahci_berlin_init(void __iomem *mmio)
> +{
> +	/* interface select */
> +	ahci_berlin_reg_set(mmio + HOST_VSA_ADDR, BIT(2));
> +	ahci_berlin_reg_set(mmio + HOST_VSA_ADDR,
> +			    BIT(21) | BIT(18) | BIT(5) | BIT(4) | BIT(2));

Any chance we get named #defines for the BIT()s above and below?

> +
> +}
> +
> +static void ahci_berlin_port_init(void __iomem *mmio, unsigned int ports)
> +{
> +	int p;
> +
> +	/* power down pll */
> +	ahci_berlin_reg_set(mmio + HOST_VSA_ADDR, 0x0);
> +	ahci_berlin_reg_setbits(mmio + HOST_VSA_DATA, BIT(6));
> +
> +	for (p = 0; p < ports; p++) {
> +		/* port control register */
> +		void __iomem *ctrl_reg = mmio + 0x100 + (p * 0x80);
> +
> +		/* set PHY mode to SATA, ref freq to 25 MHz */
> +		ahci_berlin_reg_set(ctrl_reg + PORT_VSR_ADDR, 0x201);
> +		ahci_berlin_reg_clear_set(ctrl_reg + PORT_VSR_DATA,
> +					  0xff, BIT(0));
> +
> +		/* set PHY up to 6 Gbps */
> +		ahci_berlin_reg_set(ctrl_reg + PORT_VSR_ADDR, 0x225);
> +		ahci_berlin_reg_clear_set(ctrl_reg + PORT_VSR_DATA,
> +					  BIT(11) | BIT(10), BIT(11));
> +
> +		/* set SEL_BITS to 40 bit */
> +		ahci_berlin_reg_set(ctrl_reg + PORT_VSR_ADDR, 0x223);
> +		ahci_berlin_reg_clear_set(ctrl_reg + PORT_VSR_DATA,
> +					  BIT(11) | BIT(10), BIT(11));
> +
> +		/* use max pll rate */
> +		ahci_berlin_reg_set(ctrl_reg + PORT_VSR_ADDR, 0x202);
> +		ahci_berlin_reg_setbits(ctrl_reg + PORT_VSR_DATA, BIT(12));
> +
> +		/* CT timing fix */
> +		ahci_berlin_reg_set(ctrl_reg + PORT_VSR_ADDR, BIT(6) | BIT(1));
> +		ahci_berlin_reg_set(ctrl_reg + PORT_VSR_ADDR,
> +				    BIT(15) | BIT(13) | BIT(12) | BIT(11) |
> +				    BIT(10) | BIT(2) | BIT(1));
> +
> +		/* set the controller speed */
> +		ahci_berlin_reg_set(ctrl_reg + PORT_SCR_CTL,
> +				    BIT(6) | BIT(5) | BIT(0));
> +	}
> +
> +	/* power up pll */
> +	ahci_berlin_reg_set(mmio + HOST_VSA_ADDR, 0x0);
> +	ahci_berlin_reg_clear_set(mmio + HOST_VSA_DATA, BIT(6), 0x0);
> +}
> +
> +static const struct ata_port_info ahci_berlin_port_info = {
> +	.flags		= AHCI_FLAG_COMMON | ATA_FLAG_NCQ,
> +	.pio_mask	= ATA_PIO4,
> +	.udma_mask	= ATA_UDMA6,
> +	.port_ops	= &ahci_platform_ops,
> +};
> +
> +static int ahci_berlin_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct device_node *np = dev->of_node;
> +	struct ahci_host_priv *hpriv;
> +	int ret, nports, force_map = 0;
> +
> +	hpriv = ahci_platform_get_resources(pdev);
> +	if (IS_ERR(hpriv)) {
> +		dev_err(dev, "cannot get AHCI resources\n");
> +		return PTR_ERR(hpriv);
> +	}
> +
> +	ret = ahci_platform_enable_resources(hpriv);
> +	if (ret) {
> +		dev_err(dev, "cannot enable resources: %d\n", ret);
> +		return ret;
> +	}
> +
> +	nports = readl(hpriv->mmio + HOST_PORTS_IMPL);
> +
> +	/* force_map is modified only if the property is found */
> +	of_property_read_u32(np, "marvell,force-port-map", &force_map);
> +	if (force_map)
> +		nports = force_map;

marvell,force-port-map is undocumented and its name does not reflect
what it is about. Before you just rename it to marvell,nr-ports or
something, how about having one sub-node per port:

sata_phy0: sata-phy@e90100 {
	compatible = "marvell,berlin-sata-phy";
	reg = <0xe90100 0x80>;
	status = "disabled";
};

sata_phy1: sata-phy@e90180 {
	compatible = "marvell,berlin-sata-phy";
	reg = <0xe90180 0x80>;
	status = "disabled";
};

ahci: sata@e90000 {
	compatible = "marvell,berlin-ahci";
	reg = <0xe90000 0x100>;
	interrupts = <GIC_SPI 7 IRQ_TYPE_LEVEL_HIGH>;
	#address-cells = <1>;
	#size-cells = <0>;
	status = "disabled";

	sata-port@0 {
		reg = <0>;
		sata-phy = <&sata_phy0>;
		status = "disabled";
	};

	sata-port@1 {
		reg = <1>;
		sata-phy = <&sata_phy1>;
		status = "okay";
	};
};

That way you can
(a) separate a PHY driver that has little code but is able to power-down
    the PHY even if there is no AHCI driver loaded.
(b) enable/disable each port individually.
(c) enable port1 while port0 is disabled.
(d) disable the PLL if there is no port enabled at all.

Sebastian

> +
> +	ahci_berlin_init(hpriv->mmio);
> +	ahci_berlin_port_init(hpriv->mmio, nports);
> +
> +	ret = ahci_platform_init_host(pdev, hpriv, &ahci_berlin_port_info,
> +				      force_map, 0);
> +	if (ret) {
> +		dev_err(dev, "host init failed: %d\n", ret);
> +		goto disable_resources;
> +	}
> +
> +	return 0;
> +
> +disable_resources:
> +	ahci_platform_disable_resources(hpriv);
> +	return ret;
> +}
> +
> +static const struct of_device_id ahci_berlin_of_match[] = {
> +	{ .compatible = "marvell,berlin-ahci" },
> +	{ },
> +};
> +MODULE_DEVICE_TABLE(of, ahci_berlin_of_match);
> +
> +static struct platform_driver ahci_berlin_driver = {
> +	.probe	= ahci_berlin_probe,
> +	.remove	= ata_platform_remove_one,
> +	.driver	= {
> +		.name		= "ahci-berlin",
> +		.owner		= THIS_MODULE,
> +		.of_match_table = ahci_berlin_of_match,
> +	},
> +};
> +module_platform_driver(ahci_berlin_driver);
> +
> +MODULE_DESCRIPTION("Marvell Berlin AHCI SATA driver");
> +MODULE_AUTHOR("Antoine Ténart <antoine.tenart@free-electrons.com>");
> +MODULE_LICENSE("GPL");
> 

