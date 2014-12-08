Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054AbaLHJ7t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 04:59:49 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:35695 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755033AbaLHJ7q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 04:59:46 -0500
Message-ID: <548575F0.4090909@ti.com>
Date: Mon, 8 Dec 2014 15:27:04 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Yunzhi Li <lyz@rock-chips.com>, <heiko@sntech.de>, <dianders@chromium.org>,
        <romain.perier@gmail.com>
CC: <olof@lixom.net>, <huangtao@rock-chips.com>, <zyw@rock-chips.com>,
        <cf@rock-chips.com>, <linux-rockchip@lists.infradead.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH v3 1/5] phy: add a driver for the Rockchip SoC internal
 USB2.0 PHY
References: <1418031988-2700-1-git-send-email-lyz@rock-chips.com> <1418031988-2700-2-git-send-email-lyz@rock-chips.com>
In-Reply-To: <1418031988-2700-2-git-send-email-lyz@rock-chips.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday 08 December 2014 03:16 PM, Yunzhi Li wrote:
> This patche to add a generic PHY driver for ROCKCHIP usb PHYs,

%s/patche/patch
> currently this driver can support RK3288. The RK3288 SoC have
> three independent USB PHY IPs which are all configured through a
> set of registers located in the GRF (general register files)
> module.
> 
> Signed-off-by: Yunzhi Li <lyz@rock-chips.com>
> 
> ---
> 
> Changes in v3:
> - Use BIT macro instead of bit shift ops.
> - Rename the config entry to PHY_ROCKCHIP_USB.
> 
>  drivers/phy/Kconfig            |   7 ++
>  drivers/phy/Makefile           |   1 +
>  drivers/phy/phy-rockchip-usb.c | 179 +++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 187 insertions(+)
>  create mode 100644 drivers/phy/phy-rockchip-usb.c
> 
> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
> index ccad880..8a39d2a 100644
> --- a/drivers/phy/Kconfig
> +++ b/drivers/phy/Kconfig
> @@ -239,6 +239,13 @@ config PHY_QCOM_IPQ806X_SATA
>  	depends on OF
>  	select GENERIC_PHY
>  
> +config PHY_ROCKCHIP_USB2
> +	tristate "Rockchip USB2 PHY Driver"
> +	depends on ARCH_ROCKCHIP && OF
> +	select GENERIC_PHY
> +	help
> +	  Enable this to support the Rockchip USB 2.0 PHY.
> +
>  config PHY_ST_SPEAR1310_MIPHY
>  	tristate "ST SPEAR1310-MIPHY driver"
>  	select GENERIC_PHY
> diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
> index aa74f96..8a13f72 100644
> --- a/drivers/phy/Makefile
> +++ b/drivers/phy/Makefile
> @@ -28,6 +28,7 @@ phy-exynos-usb2-$(CONFIG_PHY_EXYNOS5250_USB2)	+= phy-exynos5250-usb2.o
>  phy-exynos-usb2-$(CONFIG_PHY_S5PV210_USB2)	+= phy-s5pv210-usb2.o
>  obj-$(CONFIG_PHY_EXYNOS5_USBDRD)	+= phy-exynos5-usbdrd.o
>  obj-$(CONFIG_PHY_QCOM_APQ8064_SATA)	+= phy-qcom-apq8064-sata.o
> +obj-$(CONFIG_PHY_ROCKCHIP_USB2) += phy-rockchip-usb.o
>  obj-$(CONFIG_PHY_QCOM_IPQ806X_SATA)	+= phy-qcom-ipq806x-sata.o
>  obj-$(CONFIG_PHY_ST_SPEAR1310_MIPHY)	+= phy-spear1310-miphy.o
>  obj-$(CONFIG_PHY_ST_SPEAR1340_MIPHY)	+= phy-spear1340-miphy.o
> diff --git a/drivers/phy/phy-rockchip-usb.c b/drivers/phy/phy-rockchip-usb.c
> new file mode 100644
> index 0000000..98af043
> --- /dev/null
> +++ b/drivers/phy/phy-rockchip-usb.c
> @@ -0,0 +1,179 @@
> +/*
> + * Rockchip usb PHY driver
> + *
> + * Copyright (C) 2014 Yunzhi Li <lyz@rock-chips.com>
> + * Copyright (C) 2014 ROCKCHIP, Inc.
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/io.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/mutex.h>
> +#include <linux/of.h>
> +#include <linux/of_address.h>
> +#include <linux/phy/phy.h>
> +#include <linux/platform_device.h>
> +#include <linux/regulator/consumer.h>
> +#include <linux/reset.h>
> +#include <linux/regmap.h>
> +#include <linux/mfd/syscon.h>
> +
> +#define ROCKCHIP_RK3288_UOC(n)	(0x320 + n * 0x14)
> +
> +#define SIDDQ_MSK		BIT(13 + 16)

This doesn't look correct. Won't this mask bit no:29?
> +#define SIDDQ_ON		BIT(13)
> +#define SIDDQ_OFF		(0 << 13)
> +
> +enum rk3288_phy_id {

rockchip_usb_phy_id?
> +	RK3288_OTG,
> +	RK3288_HOST0,
> +	RK3288_HOST1,
> +	RK3288_NUM_PHYS,
> +};
> +
> +struct rockchip_usb_phy {
> +	struct regmap *reg_base;
> +	unsigned int reg_offset;
> +	struct clk *clk;
> +	struct phy *phy;
> +};
> +
> +static int rockchip_usb_phy_power(struct rockchip_usb_phy *phy,
> +					   bool siddq)
> +{
> +	return regmap_write(phy->reg_base, phy->reg_offset,
> +			    SIDDQ_MSK | (siddq ? SIDDQ_ON : SIDDQ_OFF));
> +}
> +
> +static int rockchip_usb_phy_power_off(struct phy *_phy)
> +{
> +	struct rockchip_usb_phy *phy = phy_get_drvdata(_phy);
> +	int ret = 0;
> +
> +	/* Power down usb phy analog blocks by set siddq 1*/
> +	ret = rockchip_usb_phy_power(phy, 1);
> +	if (ret)
> +		return ret;
> +
> +	clk_disable_unprepare(phy->clk);
> +	if (ret)
> +		return ret;
> +
> +	return 0;
> +}
> +
> +static int rockchip_usb_phy_power_on(struct phy *_phy)
> +{
> +	struct rockchip_usb_phy *phy = phy_get_drvdata(_phy);
> +	int ret = 0;
> +
> +	ret = clk_prepare_enable(phy->clk);
> +	if (ret)
> +		return ret;
> +
> +	/* Power up usb phy analog blocks by set siddq 0*/
> +	ret = rockchip_usb_phy_power(phy, 0);
> +	if (ret)
> +		return ret;
> +
> +	return 0;
> +}
> +
> +static struct phy *rockchip_usb_phy_xlate(struct device *dev,
> +					struct of_phandle_args *args)
> +{
> +	struct rockchip_usb_phy *phy_array = dev_get_drvdata(dev);
> +
> +	if (WARN_ON(args->args[0] == 0 || args->args[0] >= RK3288_NUM_PHYS))
> +		return ERR_PTR(-ENODEV);
> +
> +	return (phy_array + args->args[0])->phy;
> +}
> +
> +static struct phy_ops ops = {
> +	.power_on	= rockchip_usb_phy_power_on,
> +	.power_off	= rockchip_usb_phy_power_off,
> +	.owner		= THIS_MODULE,
> +};
> +
> +static int rockchip_usb_phy_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct rockchip_usb_phy *rk_phy;
> +	struct rockchip_usb_phy *phy_array;
> +	struct phy_provider *phy_provider;
> +	struct regmap *grf;
> +	char clk_name[16];
> +	int i;
> +
> +	grf = syscon_regmap_lookup_by_phandle(dev->of_node, "rockchip,grf");
> +	if (IS_ERR(grf)) {
> +		dev_err(&pdev->dev, "Missing rockchip,grf property\n");
> +		return PTR_ERR(grf);
> +	}
> +
> +	phy_array = devm_kzalloc(dev, RK3288_NUM_PHYS * sizeof(*rk_phy),
> +				 GFP_KERNEL);
> +	if (!phy_array)
> +		return -ENOMEM;
> +
> +	for (i = 0; i < RK3288_NUM_PHYS; i++) {

Don't hardcode NUM_PHYS. All this has to come from dt. Model each PHYs as
subnode of the phy provider node and use it here.

Thanks
Kishon
