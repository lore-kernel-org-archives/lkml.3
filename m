Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932123Ab3KFISd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 03:18:33 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:37563 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750803Ab3KFISa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 03:18:30 -0500
Message-ID: <5279FB45.3010808@ti.com>
Date: Wed, 6 Nov 2013 13:48:13 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Kamil Debski <k.debski@samsung.com>
CC: <linux-kernel@vger.kernel.org>, <linux-samsung-soc@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm@vger.kernel.org>, <kyungmin.park@samsung.com>,
        <t.figa@samsung.com>, <s.nawrocki@samsung.com>,
        <m.szyprowski@samsung.com>, <gautam.vivek@samsung.com>,
        <mat.krawczuk@gmail.com>, <yulgon.kim@samsung.com>,
        <p.paneri@samsung.com>, <av.tikhomirov@samsung.com>,
        <jg1.han@samsung.com>, <galak@codeaurora.org>
Subject: Re: [PATCH v3 1/3] phy: Add new Exynos USB PHY driver
References: <1383668001-19141-1-git-send-email-k.debski@samsung.com> <1383668001-19141-2-git-send-email-k.debski@samsung.com>
In-Reply-To: <1383668001-19141-2-git-send-email-k.debski@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tuesday 05 November 2013 09:43 PM, Kamil Debski wrote:
> Add a new driver for the Exynos USB PHY. The new driver uses the generic
> PHY framework. The driver includes support for the Exynos 4x10 and 4x12
> SoC families.
>
> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>   .../devicetree/bindings/phy/samsung-usbphy.txt     |   52 ++++
>   drivers/phy/Kconfig                                |   23 +-
>   drivers/phy/Makefile                               |    4 +
>   drivers/phy/phy-exynos-usb2.c                      |  234 ++++++++++++++
>   drivers/phy/phy-exynos-usb2.h                      |   87 ++++++
>   drivers/phy/phy-exynos4210-usb2.c                  |  272 ++++++++++++++++
>   drivers/phy/phy-exynos4212-usb2.c                  |  324 ++++++++++++++++++++
>   7 files changed, 995 insertions(+), 1 deletion(-)
>   create mode 100644 Documentation/devicetree/bindings/phy/samsung-usbphy.txt
>   create mode 100644 drivers/phy/phy-exynos-usb2.c
>   create mode 100644 drivers/phy/phy-exynos-usb2.h
>   create mode 100644 drivers/phy/phy-exynos4210-usb2.c
>   create mode 100644 drivers/phy/phy-exynos4212-usb2.c
>
> diff --git a/Documentation/devicetree/bindings/phy/samsung-usbphy.txt b/Documentation/devicetree/bindings/phy/samsung-usbphy.txt
> new file mode 100644
> index 0000000..c8fbc70
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/phy/samsung-usbphy.txt
> @@ -0,0 +1,52 @@
> +Samsung S5P/EXYNOS SoC series USB PHY
> +-------------------------------------------------
> +
> +Required properties:
> +- compatible : should be one of the listed compatibles:
> +	- "samsung,exynos4210-usbphy"
> +	- "samsung,exynos4212-usbphy"
> +- reg : a list of registers used by phy driver
> +	- first and obligatory is the location of phy modules registers
> +	- second and also required is the location of isolation registers
> +	  (isolation registers control the physical connection between the in
> +	  SoC modules and outside of the SoC, this also can be called enable
> +	  control in the documentation of the SoC)
> +	- third is the location of the mode switch register, this only applies
> +	  to SoCs that have such a feature; mode switching enables to have
> +	  both host and device used the same SoC pins and is commonly used
> +	  when OTG is supported
> +- #phy-cells : from the generic phy bindings, must be 1;
> +- clocks and clock-names:
> +	- the "phy" clocks is required by the phy module
> +	- other clocks are associated by name with their respective phys and
> +	  are used to determine the value of the clock settings register
> +
> +The second cell in the PHY specifier identifies the PHY, its  meaning is
> +compatible dependent. For the currently supported SoCs (Exynos 4210 and
> +Exynos 4212) it is as follows:
> +  0 - USB device,
> +  1 - USB host,
> +  2 - HSIC0,
> +  3 - HSIC1,
> +
> +Example:
> +
> +For Exynos 4412 (compatible with Exynos 4212):
> +
> +exynos_usbphy: exynos-usbphy@125B0000 {
> +	compatible = "samsung,exynos4212-usbphy";
> +	reg = <0x125B0000 0x100 0x10020704 0x0c 0x1001021c 0x4>;
> +	clocks = <&clock 305>, <&clock 2>, <&clock 2>, <&clock 2>,
> +							<&clock 2>;
> +	clock-names = "phy", "device", "host", "hsic0", "hsic1";
> +	status = "okay";
> +	#phy-cells = <1>;
> +};
> +
> +Then the PHY can be used in other nodes such as:
> +
> +ehci@12580000 {
> +	status = "okay";
> +	phys = <&exynos_usbphy 2>;
> +	phy-names = "hsic0";
> +};
> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
> index a344f3d..bdf0fab 100644
> --- a/drivers/phy/Kconfig
> +++ b/drivers/phy/Kconfig
> @@ -14,7 +14,7 @@ config GENERIC_PHY
>   	  API by which phy drivers can create PHY using the phy framework and
>   	  phy users can obtain reference to the PHY. All the users of this
>   	  framework should select this config.
> -
> +	
spurious change
>   config PHY_EXYNOS_MIPI_VIDEO
>   	tristate "S5P/EXYNOS SoC series MIPI CSI-2/DSI PHY driver"
>   	help
> @@ -51,4 +51,25 @@ config PHY_EXYNOS_DP_VIDEO
>   	help
>   	  Support for Display Port PHY found on Samsung EXYNOS SoCs.
>
> +config PHY_EXYNOS_USB2
> +	tristate "Samsung USB 2.0 PHY driver"
> +	help
> +	  Enable this to support Samsung USB phy helper driver for Samsung SoCs.
> +	  This driver provides common interface to interact, for Samsung
> +	  USB 2.0 PHY driver.

I still think we can get rid of this helper driver and have a single 
driver for both PHY_EXYNOS4210_USB2 and PHY_EXYNOS4212_USB2.
> +
> +config PHY_EXYNOS4210_USB2
> +	bool "Support for Exynos 4210"
> +	depends on PHY_EXYNOS_USB2
> +	depends on CPU_EXYNOS4210
> +	help
> +	  Enable USB PHY support for Exynos 4210
> +
> +config PHY_EXYNOS4212_USB2
> +	bool "Support for Exynos 4212"
> +	depends on PHY_EXYNOS_USB2
> +	depends on (SOC_EXYNOS4212 || SOC_EXYNOS4412)
> +	help
> +	  Enable USB PHY support for Exynos 4212
> +
>   endmenu
> diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
> index d0caae9..c87bc65 100644
> --- a/drivers/phy/Makefile
> +++ b/drivers/phy/Makefile
> @@ -7,3 +7,7 @@ obj-$(CONFIG_PHY_EXYNOS_DP_VIDEO)	+= phy-exynos-dp-video.o
>   obj-$(CONFIG_PHY_EXYNOS_MIPI_VIDEO)	+= phy-exynos-mipi-video.o
>   obj-$(CONFIG_OMAP_USB2)			+= phy-omap-usb2.o
>   obj-$(CONFIG_TWL4030_USB)		+= phy-twl4030-usb.o
> +obj-$(CONFIG_PHY_EXYNOS5250_USB)	+= phy-exynos5250-usb.o
> +obj-$(CONFIG_PHY_EXYNOS_USB2)		+= phy-exynos-usb2.o
> +obj-$(CONFIG_PHY_EXYNOS4210_USB2)	+= phy-exynos4210-usb2.o
> +obj-$(CONFIG_PHY_EXYNOS4212_USB2)	+= phy-exynos4212-usb2.o
> diff --git a/drivers/phy/phy-exynos-usb2.c b/drivers/phy/phy-exynos-usb2.c
> new file mode 100644
> index 0000000..3e9d525
> --- /dev/null
> +++ b/drivers/phy/phy-exynos-usb2.c
> @@ -0,0 +1,234 @@
> +/*
> + * Samsung S5P/EXYNOS SoC series USB PHY driver
> + *
> + * Copyright (C) 2013 Samsung Electronics Co., Ltd.
> + * Author: Kamil Debski <k.debski@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/delay.h>
> +#include <linux/io.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_address.h>
> +#include <linux/phy/phy.h>
> +#include <linux/platform_device.h>
> +#include <linux/spinlock.h>
> +#include "phy-exynos-usb2.h"
> +
> +static int exynos_usb2_phy_power_on(struct phy *phy)
> +{
> +	struct usb2_phy_instance *inst = phy_get_drvdata(phy);
> +	struct usb2_phy_driver *drv = inst->drv;
> +	int ret;
> +
> +	dev_dbg(drv->dev, "Request to power_on \"%s\" usb phy\n",
> +							inst->cfg->label);
> +	ret = clk_prepare_enable(drv->clk);
> +	if (ret)
> +		return ret;
> +	if (inst->cfg->power_on) {
> +		spin_lock(&drv->lock);
> +		ret = inst->cfg->power_on(inst);
> +		spin_unlock(&drv->lock);
> +	}
> +	clk_disable_unprepare(drv->clk);
> +	return ret;
> +}
> +
> +static int exynos_usb2_phy_power_off(struct phy *phy)
> +{
> +	struct usb2_phy_instance *inst = phy_get_drvdata(phy);
> +	struct usb2_phy_driver *drv = inst->drv;
> +	int ret;
> +
> +	dev_dbg(drv->dev, "Request to power_off \"%s\" usb phy\n",
> +							inst->cfg->label);
> +	ret = clk_prepare_enable(drv->clk);
> +	if (ret)
> +		return ret;
> +	if (inst->cfg->power_off) {
> +		spin_lock(&drv->lock);
> +		ret = inst->cfg->power_off(inst);
> +		spin_unlock(&drv->lock);
> +	}
> +	clk_disable_unprepare(drv->clk);
> +	return ret;
> +}
> +
> +static struct phy_ops exynos_usb2_phy_ops = {
> +	.power_on	= exynos_usb2_phy_power_on,
> +	.power_off	= exynos_usb2_phy_power_off,
> +	.owner		= THIS_MODULE,
> +};
> +
> +static struct phy *exynos_usb2_phy_xlate(struct device *dev,
> +					struct of_phandle_args *args)
> +{
> +	struct usb2_phy_driver *drv;
> +
> +	drv = dev_get_drvdata(dev);
> +	if (!drv)
> +		return ERR_PTR(-EINVAL);
> +
> +	if (WARN_ON(args->args[0] >= drv->cfg->num_phys))
> +		return ERR_PTR(-ENODEV);
> +
> +	return drv->usb2_phy_instances[args->args[0]].phy;
> +}
> +
> +static const struct of_device_id exynos_usb2_phy_of_match[];
> +
> +static int exynos_usb2_phy_probe(struct platform_device *pdev)
> +{
> +	struct usb2_phy_driver *drv;
> +	struct device *dev = &pdev->dev;
> +	struct resource *mem;
> +	struct phy_provider *phy_provider;
> +
> +	const struct of_device_id *match;
> +	const struct usb2_phy_config *cfg;
> +	struct clk *clk;
> +
> +	int i;
> +
> +	match = of_match_node(exynos_usb2_phy_of_match, pdev->dev.of_node);
> +	if (!match) {
> +		dev_err(dev, "of_match_node() failed\n");
> +		return -EINVAL;
> +	}
> +	cfg = match->data;
> +	if (!cfg) {
> +		dev_err(dev, "Failed to get configuration\n");
> +		return -EINVAL;
> +	}
> +
> +	drv = devm_kzalloc(dev, sizeof(struct usb2_phy_driver) +
> +		cfg->num_phys * sizeof(struct usb2_phy_instance), GFP_KERNEL);
> +
> +	if (!drv) {
> +		dev_err(dev, "Failed to allocate memory\n");
> +		return -ENOMEM;
> +	}
> +
> +	dev_set_drvdata(dev, drv);
> +	spin_lock_init(&drv->lock);
> +
> +	drv->cfg = cfg;
> +	drv->dev = dev;
> +
> +	mem = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	drv->reg_phy = devm_ioremap_resource(dev, mem);
> +	if (IS_ERR(drv->reg_phy)) {
> +		dev_err(dev, "Failed to map register memory (phy)\n");
> +		return PTR_ERR(drv->reg_phy);
> +	}
> +
> +	mem = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> +	drv->reg_isol = devm_ioremap_resource(dev, mem);
> +	if (IS_ERR(drv->reg_isol)) {
> +		dev_err(dev, "Failed to map register memory (isolation)\n");
> +		return PTR_ERR(drv->reg_isol);
> +	}
> +
> +	if (drv->cfg->has_mode_switch) {
> +		mem = platform_get_resource(pdev, IORESOURCE_MEM, 2);
> +		drv->reg_mode = devm_ioremap_resource(dev, mem);
> +		if (IS_ERR(drv->reg_mode)) {
> +			dev_err(dev, "Failed to map register memory (mode switch)\n");
> +			return PTR_ERR(drv->reg_mode);
> +		}
> +	}
> +
> +	phy_provider = devm_of_phy_provider_register(dev,
> +							exynos_usb2_phy_xlate);
> +	if (IS_ERR(phy_provider)) {
> +		dev_err(drv->dev, "Failed to register phy provider\n");
> +		return PTR_ERR(phy_provider);
> +	}
> +
> +	drv->clk = devm_clk_get(dev, "phy");
> +	if (IS_ERR(drv->clk)) {
> +		dev_err(dev, "Failed to get clock of phy controller\n");
> +		return PTR_ERR(drv->clk);
> +	}
> +
> +	for (i = 0; i < drv->cfg->num_phys; i++) {
> +		char *label = drv->cfg->phys[i].label;
> +		struct usb2_phy_instance *p = &drv->usb2_phy_instances[i];
> +
> +		dev_dbg(dev, "Creating phy \"%s\"\n", label);
> +		p->phy = devm_phy_create(dev, &exynos_usb2_phy_ops, NULL);
> +		if (IS_ERR(p->phy)) {
> +			dev_err(drv->dev, "Failed to create usb2_phy \"%s\"\n",
> +						label);
> +			return PTR_ERR(p->phy);
> +		}
> +
> +		p->cfg = &drv->cfg->phys[i];
> +		p->drv = drv;
> +		phy_set_drvdata(p->phy, p);
> +
> +		clk = clk_get(dev, p->cfg->label);
> +		if (IS_ERR(clk)) {
> +			dev_err(dev, "Failed to get clock of \"%s\" phy\n",
> +								p->cfg->label);
> +			return PTR_ERR(clk);
> +		}
> +
> +		p->rate = clk_get_rate(clk);
> +
> +		if (p->cfg->rate_to_clk) {
> +			p->clk = p->cfg->rate_to_clk(p->rate);
> +			if (p->clk == CLKSEL_ERROR) {
> +				dev_err(dev, "Clock rate (%ld) not supported\n",
> +								p->rate);
> +				clk_put(clk);
> +				return -EINVAL;
> +			}
> +		}
> +		clk_put(clk);
> +	}
> +
> +	return 0;
> +}
> +
> +extern const struct usb2_phy_config exynos4210_usb2_phy_config;
> +extern const struct usb2_phy_config exynos4212_usb2_phy_config;
> +
> +static const struct of_device_id exynos_usb2_phy_of_match[] = {
> +#ifdef CONFIG_PHY_EXYNOS4210_USB2

I don't think you'll need #ifdef here. Anyways the driver data can be 
obtained using the appropriate compatible value in dt data no?

Thanks
Kishon
