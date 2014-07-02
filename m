Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932119AbaGBKUb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 06:20:31 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58245 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751991AbaGBKU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 06:20:29 -0400
Message-ID: <53B3DCBC.8000105@ti.com>
Date: Wed, 2 Jul 2014 15:49:40 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC: <kernel@stlinux.com>, Alexandre Torgue <alexandre.torgue@st.com>
Subject: Re: [PATCH 3/5] phy: miphy365x: Provide support for the MiPHY356x
 Generic PHY
References: <1404133317-25953-1-git-send-email-lee.jones@linaro.org> <1404133317-25953-4-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1404133317-25953-4-git-send-email-lee.jones@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday 30 June 2014 06:31 PM, Lee Jones wrote:
> The MiPHY365x is a Generic PHY which can serve various SATA or PCIe
> devices. It has 2 ports which it can use for either; both SATA, both
> PCIe or one of each in any configuration.
> 
> Acked-by: Kishon Vijay Abraham I <kishon@ti.com>

Not yet..
> Acked-by: Mark Rutland <mark.rutland@arm.com>
> Signed-off-by: Alexandre Torgue <alexandre.torgue@st.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/phy/Kconfig         |  10 +
>  drivers/phy/Makefile        |   1 +
>  drivers/phy/phy-miphy365x.c | 630 ++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 641 insertions(+)
>  create mode 100644 drivers/phy/phy-miphy365x.c
> 
> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
> index 16a2f06..5d54dcf 100644
> --- a/drivers/phy/Kconfig
> +++ b/drivers/phy/Kconfig
> @@ -31,6 +31,16 @@ config PHY_MVEBU_SATA
>  	depends on OF
>  	select GENERIC_PHY
>  
> +config PHY_MIPHY365X
> +	tristate "STMicroelectronics MIPHY365X PHY driver for STiH41x series"
> +	depends on ARCH_STI
> +	depends on GENERIC_PHY
> +	depends on HAS_IOMEM
> +	depends on OF
> +	help
> +	  Enable this to support the miphy transceiver (for SATA/PCIE)
> +	  that is part of STMicroelectronics STiH41x SoC series.
> +
>  config OMAP_CONTROL_PHY
>  	tristate "OMAP CONTROL PHY Driver"
>  	depends on ARCH_OMAP2PLUS || COMPILE_TEST
> diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
> index b4f1d57..4602f67 100644
> --- a/drivers/phy/Makefile
> +++ b/drivers/phy/Makefile
> @@ -7,6 +7,7 @@ obj-$(CONFIG_BCM_KONA_USB2_PHY)		+= phy-bcm-kona-usb2.o
>  obj-$(CONFIG_PHY_EXYNOS_DP_VIDEO)	+= phy-exynos-dp-video.o
>  obj-$(CONFIG_PHY_EXYNOS_MIPI_VIDEO)	+= phy-exynos-mipi-video.o
>  obj-$(CONFIG_PHY_MVEBU_SATA)		+= phy-mvebu-sata.o
> +obj-$(CONFIG_PHY_MIPHY365X)		+= phy-miphy365x.o
>  obj-$(CONFIG_OMAP_CONTROL_PHY)		+= phy-omap-control.o
>  obj-$(CONFIG_OMAP_USB2)			+= phy-omap-usb2.o
>  obj-$(CONFIG_TI_PIPE3)			+= phy-ti-pipe3.o
> diff --git a/drivers/phy/phy-miphy365x.c b/drivers/phy/phy-miphy365x.c
> new file mode 100644
> index 0000000..1109f42
> --- /dev/null
> +++ b/drivers/phy/phy-miphy365x.c
> @@ -0,0 +1,630 @@
> +/*
> + * Copyright (C) 2014 STMicroelectronics
> + *
> + * STMicroelectronics PHY driver MiPHY365 (for SoC STiH416).
> + *
> + * Author: Alexandre Torgue <alexandre.torgue@st.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2, as
> + * published by the Free Software Foundation.
> + *
> + */
> +
> +#include <linux/platform_device.h>
> +#include <linux/io.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_platform.h>
> +#include <linux/clk.h>
> +#include <linux/phy/phy.h>
> +#include <linux/delay.h>
> +#include <linux/mfd/syscon.h>
> +#include <linux/regmap.h>
> +
> +#include <dt-bindings/phy/phy-miphy365x.h>
> +
> +#define HFC_TIMEOUT		50
> +
> +#define SYSCFG_2521		0x824
> +#define SYSCFG_2522		0x828
> +#define SYSCFG_PCIE_SATA_MASK	BIT(1)
> +#define SYSCFG_PCIE_SATA_POS	1
> +
.
.
<snip>
.
.
> +
> +static u8 ports[] = { MIPHY_PORT_0, MIPHY_PORT_1 };
> +
> +struct miphy365x {
> +	struct phy *phy;
> +	void __iomem *base;
> +	void __iomem *sata;
> +	void __iomem *pcie;
> +	u8 type;
> +	u8 port;
> +};
> +
> +struct miphy365x_dev {
> +	struct device *dev;
> +	struct mutex miphy_mutex;
> +	struct miphy365x phys[ARRAY_SIZE(ports)];

Avoid using fixed array sizes for ports or channels. Refer [1].

> +	bool pcie_tx_pol_inv;
> +	bool sata_tx_pol_inv;
> +	u32 sata_gen;
> +	struct regmap *regmap;
> +};
> +
> +/*
> + * These values are represented in Device tree. They are considered to be ABI
> + * and although they can be extended any existing values must not change.
> + */
> +enum miphy_sata_gen {
> +	SATA_GEN1 = 1,
> +	SATA_GEN2,
> +	SATA_GEN3
> +};
> +
> +static u8 rx_tx_spd[] = {
> +	TX_SPDSEL_GEN1_VAL | RX_SPDSEL_GEN1_VAL,
> +	TX_SPDSEL_GEN2_VAL | RX_SPDSEL_GEN2_VAL,
> +	TX_SPDSEL_GEN3_VAL | RX_SPDSEL_GEN3_VAL
> +};
> +
> +#define miphy365x_phy_to_dev(inst) \
> +	container_of((inst), struct miphy365x_dev, phys[(inst)->port]);

You can also get rid of this and use dev_get_drvdata(phy->dev->parent);
> +
> +/*
> + * This function selects the system configuration,
> + * either two SATA, one SATA and one PCIe, or two PCIe lanes.
> + */
> +static int miphy365x_set_path(struct miphy365x *miphy_phy,
> +			      struct miphy365x_dev *miphy_dev)
> +{
> +	u8 config = miphy_phy->type | miphy_phy->port;
> +	u32 mask  = SYSCFG_PCIE_SATA_MASK;
> +	u32 reg;
> +	bool sata;
> +
> +	switch (config) {
> +	case MIPHY_SATA_PORT0:
> +		reg = SYSCFG_2521;
> +		sata = true;
> +		break;
> +	case MIPHY_PCIE_PORT1:
> +		reg = SYSCFG_2522;
> +		sata = false;
> +		break;
> +	default:
> +		dev_err(miphy_dev->dev, "Configuration not supported\n");
> +		return -EINVAL;
> +	}
> +
> +	return regmap_update_bits(miphy_dev->regmap, reg, mask,
> +				  sata << SYSCFG_PCIE_SATA_POS);
> +}
> +
> +static void miphy365x_init_pcie_port(struct miphy365x *miphy_phy,
> +				     struct miphy365x_dev *miphy_dev)

I would have this return int so that it's API is similar to that of sata.
> +{
> +	u8 val;
> +
> +	if (!miphy_dev->pcie_tx_pol_inv)
> +		return;
> +
> +	/* Invert Tx polarity and clear pci_txdetect_pol bit */
> +	val = TERM_EN | PCI_EN | DES_BIT_LOCK_EN | TX_POL;
> +	writeb_relaxed(val, miphy_phy->base + CTRL_REG);
> +	writeb_relaxed(0x00, miphy_phy->base + PCIE_REG);
> +}
> +
> +static inline int miphy365x_hfc_not_rdy(struct miphy365x *miphy_phy,
> +					struct miphy365x_dev *miphy_dev)
> +{
> +	int timeout = HFC_TIMEOUT;
> +	u8 mask = IDLL_RDY | PLL_RDY;
> +	u8 regval;
> +
> +	do {
> +		regval = readb_relaxed(miphy_phy->base + STATUS_REG);
> +		usleep_range(2000, 2500);

msleep(2)?
> +	} while (timeout-- && (regval & mask));

Instead use timeout using jiffies?
> +
> +	if (timeout < 0) {
> +		dev_err(miphy_dev->dev, "HFC ready timeout!\n");
> +		return -EBUSY;
> +	}
> +
> +	return 0;
> +}
> +
> +static inline int miphy365x_rdy(struct miphy365x *miphy_phy,
> +				struct miphy365x_dev *miphy_dev)
> +{
> +	int timeout = HFC_TIMEOUT;
> +	u8 mask = IDLL_RDY | PLL_RDY;
> +	u8 regval;
> +
> +	do {
> +		regval = readb_relaxed(miphy_phy->base + STATUS_REG);
> +		usleep_range(2000, 2500);
> +	} while (timeout-- && ((regval & mask) != mask));

same here.
> +
> +	if (timeout < 0) {
> +		dev_err(miphy_dev->dev, "PHY not ready timeout!\n");
> +		return -EBUSY;
> +	}
> +
> +	return 0;
> +}
> +
> +static inline void miphy365x_set_comp(struct miphy365x *miphy_phy,
> +				      struct miphy365x_dev *miphy_dev)
> +{
> +	u8 val, mask;
> +
> +	if (miphy_dev->sata_gen == SATA_GEN1)
> +		writeb_relaxed(COMP_2MHZ_RAT_GEN1,
> +			       miphy_phy->base + COMP_CTRL2_REG);
> +	else
> +		writeb_relaxed(COMP_2MHZ_RAT,
> +			       miphy_phy->base + COMP_CTRL2_REG);

Btw don't you think it will be safe to use readb/writeb instead of
readb_relaxed/writeb_relaxed here and everywhere else?
> +
> +	if (miphy_dev->sata_gen != SATA_GEN3) {
> +		writeb_relaxed(COMSR_COMP_REF,
> +			       miphy_phy->base + COMP_CTRL3_REG);
> +		/*
> +		 * Force VCO current to value defined by address 0x5A
> +		 * and disable PCIe100Mref bit
> +		 * Enable auto load compensation for pll_i_bias
> +		 */
> +		writeb_relaxed(BYPASS_PLL_CAL, miphy_phy->base + PLL_CTRL2_REG);
> +		writeb_relaxed(COMZC_IDLL, miphy_phy->base + COMP_IDLL_REG);
> +	}
> +
.
.
<snip>
.
.

> +
> +static int miphy365x_init(struct phy *phy)
> +{
> +	int ret = 0;
> +	struct miphy365x *miphy_phy = phy_get_drvdata(phy);
> +	struct miphy365x_dev *miphy_dev = miphy365x_phy_to_dev(miphy_phy);
> +
> +	mutex_lock(&miphy_dev->miphy_mutex);
> +
> +	ret = miphy365x_set_path(miphy_phy, miphy_dev);
> +	if (ret) {
> +		mutex_unlock(&miphy_dev->miphy_mutex);
> +		return ret;
> +	}
> +
> +	/* Initialise Miphy for PCIe or SATA */
> +	if (miphy_phy->type == MIPHY_TYPE_PCIE)
> +		miphy365x_init_pcie_port(miphy_phy, miphy_dev);
> +	else
> +		ret = miphy365x_init_sata_port(miphy_phy, miphy_dev);
> +
> +	mutex_unlock(&miphy_dev->miphy_mutex);
> +
> +	return ret;
> +}
> +
> +static struct phy *miphy365x_xlate(struct device *dev,
> +				   struct of_phandle_args *args)
> +{
> +	struct miphy365x_dev *state = dev_get_drvdata(dev);
> +	u8 port, type;
> +
> +	if (args->count != 2) {
> +		dev_err(dev, "Invalid number of cells in 'phy' property\n");
> +		return ERR_PTR(-EINVAL);
> +	}
> +
> +	if (args->args[0] & 0xFFFFFF00 || args->args[1] & 0xFFFFFF00) {
> +		dev_err(dev, "Unsupported flags set in 'phy' property\n");
> +		return ERR_PTR(-EINVAL);
> +	}
> +
> +	port = args->args[0];
> +	type = args->args[1];
> +
> +	if (WARN_ON(port >= ARRAY_SIZE(ports)))
> +		return ERR_PTR(-EINVAL);
> +
> +	if (type == MIPHY_TYPE_SATA)
> +		state->phys[port].base = state->phys[port].sata;
> +	else if (type == MIPHY_TYPE_PCIE)
> +		state->phys[port].base = state->phys[port].pcie;

Sergei made an important point about overriding the PHY mode (like here) that
might create problem for the first driver that got the PHY. This might need
both the phy-core and the phy driver to maintain state to handle this properly.
> +	else {
> +		WARN(1, "Invalid type specified in DT");
> +		return ERR_PTR(-EINVAL);
> +	}
> +
> +	state->phys[port].type = type;
> +
> +	return state->phys[port].phy;
> +}
> +
> +static struct phy_ops miphy365x_ops = {
> +	.init		= miphy365x_init,
> +	.owner		= THIS_MODULE,
> +};
> +
> +static int miphy365x_get_base_addr(struct platform_device *pdev,
> +				    struct miphy365x_phy *phy, u8 port)
> +{
> +	struct resource *res;
> +	char type[6];
> +
> +	sprintf(type, "sata%d", port);
> +
> +	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, type);
> +	if (!res)
> +		return -ENODEV;
> +
> +	phy->sata = devm_ioremap(&pdev->dev, res->start, resource_size(res));
> +	if (!phy->sata)
> +		return -ENOMEM;

use devm_ioremap_resource?
> +
> +	sprintf(type, "pcie%d", port);
> +
> +	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, type);
> +	if (!res)
> +		return -ENODEV;
> +
> +	phy->pcie = devm_ioremap(&pdev->dev, res->start, resource_size(res));
> +	if (!phy->pcie)
> +		return -ENOMEM;

here too..
> +
> +	return 0;
> +}
> +
> +static int miphy365x_of_probe(struct device_node *np,
> +			      struct miphy365x_dev *phy_dev)
> +{
> +	phy_dev->regmap = syscon_regmap_lookup_by_phandle(np, "st,syscfg");
> +	if (IS_ERR(phy_dev->regmap)) {
> +		dev_err(phy_dev->dev, "No syscfg phandle specified\n");
> +		return PTR_ERR(phy_dev->regmap);
> +	}
> +
> +	of_property_read_u32(np, "st,sata-gen", &phy_dev->sata_gen);
> +	if (!phy_dev->sata_gen)
> +		phy_dev->sata_gen = SATA_GEN1;
> +
> +	phy_dev->pcie_tx_pol_inv =
> +		of_property_read_bool(np, "st,pcie-tx-pol-inv");
> +
> +	phy_dev->sata_tx_pol_inv =
> +		of_property_read_bool(np, "st,sata-tx-pol-inv");
> +
> +	return 0;
> +}
> +
> +static int miphy365x_probe(struct platform_device *pdev)
> +{
> +	struct device_node *np = pdev->dev.of_node;
> +	struct miphy365x_dev *phy_dev;
> +	struct device *dev = &pdev->dev;
> +	struct phy_provider *provider;
> +	u8 port;
> +	int ret;
> +
> +	if (!np) {
> +		dev_err(dev, "No DT node found\n");
> +		return -EINVAL;
> +	}

This check is not needed as you have depends of OF.
> +
> +	phy_dev = devm_kzalloc(dev, sizeof(*phy_dev), GFP_KERNEL);
> +	if (!phy_dev)
> +		return -ENOMEM;
> +
> +	ret = miphy365x_of_probe(np, phy_dev);
> +	if (ret)
> +		return ret;
> +
> +	phy_dev->dev = dev;
> +
> +	dev_set_drvdata(dev, phy_dev);
> +
> +	mutex_init(&phy_dev->miphy_mutex);
> +
> +	for (port = 0; port < ARRAY_SIZE(ports); port++) {
Pls refer [1]. I feel it's better to do it that way.
[1] -> http://www.spinics.net/lists/linux-sh/msg33350.html

Cheers
Kishon
