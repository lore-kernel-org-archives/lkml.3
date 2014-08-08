Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534AbaHHLOF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 07:14:05 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:37511 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752889AbaHHLOB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 07:14:01 -0400
Message-ID: <53E4B0CB.5050802@ti.com>
Date: Fri, 8 Aug 2014 16:43:15 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Peter Griffin <peter.griffin@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <srinivas.kandagatla@gmail.com>, <maxime.coquelin@st.com>,
        <patrice.chotard@st.com>
CC: <lee.jones@linaro.org>, <devicetree@vger.kernel.org>,
        Peter Griffin <peter.griffin@st.com>
Subject: Re: [PATCH 1/3] phy: phy-stih41x-usb: Add usb phy support for STiH41x
 SoCs.
References: <1407493175-2611-1-git-send-email-peter.griffin@linaro.org> <1407493175-2611-2-git-send-email-peter.griffin@linaro.org>
In-Reply-To: <1407493175-2611-2-git-send-email-peter.griffin@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Friday 08 August 2014 03:49 PM, Peter Griffin wrote:
> This driver adds support for USB (1.1 and 2.0) phy for STiH415 and
> STiH416 System-On-Chips from STMicroelectronics.
> 
> Signed-off-by: Maxime Coquelin <maxime.coquelin@st.com>
> Signed-off-by: Peter Griffin <peter.griffin@st.com>
> ---
>  drivers/phy/Kconfig           |   8 ++
>  drivers/phy/Makefile          |   1 +
>  drivers/phy/phy-stih41x-usb.c | 187 ++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 196 insertions(+)
>  create mode 100644 drivers/phy/phy-stih41x-usb.c
> 
> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
> index 64b98d2..a4e8dec 100644
> --- a/drivers/phy/Kconfig
> +++ b/drivers/phy/Kconfig
> @@ -180,4 +180,12 @@ config PHY_XGENE
>  	help
>  	  This option enables support for APM X-Gene SoC multi-purpose PHY.
>  
> +config PHY_STIH41X_USB
> +	tristate "STMicroelectronics USB2 PHY driver for STiH41x series"
> +	depends on ARCH_STI
> +	depends on GENERIC_PHY

Lets keep it uniform with other PHY drivers. Make it _select_.
> +	help
> +	  Enable this to support the USB transceiver that is part of
> +	  STMicroelectronics STiH41x SoC series.
> +
>  endmenu
> diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
> index b4f1d57..69d1702 100644
> --- a/drivers/phy/Makefile
> +++ b/drivers/phy/Makefile
> @@ -20,3 +20,4 @@ phy-exynos-usb2-$(CONFIG_PHY_EXYNOS4X12_USB2)	+= phy-exynos4x12-usb2.o
>  phy-exynos-usb2-$(CONFIG_PHY_EXYNOS5250_USB2)	+= phy-exynos5250-usb2.o
>  obj-$(CONFIG_PHY_EXYNOS5_USBDRD)	+= phy-exynos5-usbdrd.o
>  obj-$(CONFIG_PHY_XGENE)			+= phy-xgene.o
> +obj-$(CONFIG_PHY_STIH41X_USB)		+= phy-stih41x-usb.o
> diff --git a/drivers/phy/phy-stih41x-usb.c b/drivers/phy/phy-stih41x-usb.c
> new file mode 100644
> index 0000000..8060ebb6
> --- /dev/null
> +++ b/drivers/phy/phy-stih41x-usb.c
> @@ -0,0 +1,187 @@
> +/*
> + * Copyright (C) 2014 STMicroelectronics
> + *
> + * STMicroelectronics PHY driver for STiH41x USB.
> + *
> + * Author: Maxime Coquelin <maxime.coquelin@st.com>
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
> +#include <linux/regmap.h>
> +#include <linux/mfd/syscon.h>
> +
> +#define SYSCFG332  0x80
> +#define SYSCFG2520 0x820
> +
> +/**
> + * struct stih41x_usb_cfg - SoC specific PHY register mapping
> + * @syscfg: Offset in syscfg registers bank
> + * @cfg_mask: Bits mask for PHY configuration
> + * @cfg: Static configuration value for PHY
> + * @oscok: Notify the PHY oscillator clock is ready
> + *	   Setting this bit enable the PHY
> + */
> +struct stih41x_usb_cfg {
> +	u32 syscfg;
> +	u32 cfg_mask;
> +	u32 cfg;
> +	u32 oscok;
> +};
> +
> +/**
> + * struct stih41x_usb_phy - Private data for the PHY
> + * @dev: device for this controller
> + * @regmap: Syscfg registers bank in which PHY is configured
> + * @cfg: SoC specific PHY register mapping
> + * @clk: Oscillator used by the PHY
> + */
> +struct stih41x_usb_phy {
> +	struct device *dev;
> +	struct regmap *regmap;
> +	const struct stih41x_usb_cfg *cfg;
> +	struct clk *clk;
> +};
> +
> +static struct stih41x_usb_cfg stih415_usb_phy_cfg = {
> +	.syscfg = SYSCFG332,
> +	.cfg_mask = 0x3f,
> +	.cfg = 0x38,
> +	.oscok = BIT(6),
> +};
> +
> +static struct stih41x_usb_cfg stih416_usb_phy_cfg = {
> +	.syscfg = SYSCFG2520,
> +	.cfg_mask = 0x33f,
> +	.cfg = 0x238,
> +	.oscok = BIT(6),
> +};
> +
> +static int stih41x_usb_phy_init(struct phy *phy)
> +{
> +	struct stih41x_usb_phy *phy_dev = phy_get_drvdata(phy);
> +
> +	return regmap_update_bits(phy_dev->regmap, phy_dev->cfg->syscfg,
> +			   phy_dev->cfg->cfg_mask, phy_dev->cfg->cfg);
> +}
> +
> +static int stih41x_usb_phy_power_on(struct phy *phy)
> +{
> +	struct stih41x_usb_phy *phy_dev = phy_get_drvdata(phy);
> +	int ret;
> +
> +	ret = clk_prepare_enable(phy_dev->clk);
> +	if (ret) {
> +		dev_err(phy_dev->dev, "Failed to enable osc_phy clock\n");
> +		return ret;
> +	}
> +
> +	return regmap_update_bits(phy_dev->regmap, phy_dev->cfg->syscfg,
> +			phy_dev->cfg->oscok, phy_dev->cfg->oscok);
> +}
> +
> +static int stih41x_usb_phy_power_off(struct phy *phy)
> +{
> +	struct stih41x_usb_phy *phy_dev = phy_get_drvdata(phy);
> +	int ret;
> +
> +	ret = regmap_update_bits(phy_dev->regmap, phy_dev->cfg->syscfg,
> +			phy_dev->cfg->oscok, 0);
> +	if (ret) {
> +		dev_err(phy_dev->dev, "Failed to clear oscok bit\n");
> +		return ret;
> +	}
> +
> +	clk_disable_unprepare(phy_dev->clk);
> +
> +	return 0;
> +}
> +
> +static struct phy_ops stih41x_usb_phy_ops = {
> +	.init		= stih41x_usb_phy_init,
> +	.power_on	= stih41x_usb_phy_power_on,
> +	.power_off	= stih41x_usb_phy_power_off,
> +	.owner		= THIS_MODULE,
> +};
> +
> +static const struct of_device_id stih41x_usb_phy_of_match[];
> +
> +static int stih41x_usb_phy_probe(struct platform_device *pdev)
> +{
> +	struct device_node *np = pdev->dev.of_node;
> +	const struct of_device_id *match;
> +	struct stih41x_usb_phy *phy_dev;
> +	struct device *dev = &pdev->dev;
> +	struct phy_provider *phy_provider;
> +	struct phy *phy;
> +
> +	phy_dev = devm_kzalloc(dev, sizeof(*phy_dev), GFP_KERNEL);
> +	if (!phy_dev)
> +		return -ENOMEM;
> +
> +	match = of_match_device(stih41x_usb_phy_of_match, &pdev->dev);
> +	if (!match)
> +		return -ENODEV;
> +
> +	phy_dev->cfg = match->data;
> +
> +	phy_dev->regmap = syscon_regmap_lookup_by_phandle(np, "st,syscfg");
> +	if (IS_ERR(phy_dev->regmap)) {
> +		dev_err(dev, "No syscfg phandle specified\n");
> +		return PTR_ERR(phy_dev->regmap);
> +	}
> +
> +	phy_dev->clk = devm_clk_get(dev, "osc_phy");
> +	if (IS_ERR(phy_dev->clk)) {
> +		dev_err(dev, "osc_phy clk not found\n");
> +		return PTR_ERR(phy_dev->clk);
> +	}
> +
> +	phy_provider = devm_of_phy_provider_register(dev, of_phy_simple_xlate);
> +	if (IS_ERR(phy_provider))
> +		return PTR_ERR(phy_provider);

phy provider should be registered after phy is created and phy data is set.

Thanks
Kishon
