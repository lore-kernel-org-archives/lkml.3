Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757927Ab3LFLO5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 06:14:57 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:44483 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757898Ab3LFLOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 06:14:52 -0500
Message-ID: <52A1B19F.70501@ti.com>
Date: Fri, 6 Dec 2013 16:44:39 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Kamil Debski <k.debski@samsung.com>, <linux-kernel@vger.kernel.org>,
        <linux-samsung-soc@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <devicetree@vger.kernel.org>
CC: <kyungmin.park@samsung.com>, <t.figa@samsung.com>,
        <s.nawrocki@samsung.com>, <m.szyprowski@samsung.com>,
        <gautam.vivek@samsung.com>, <mat.krawczuk@gmail.com>,
        <yulgon.kim@samsung.com>, <p.paneri@samsung.com>,
        <av.tikhomirov@samsung.com>, <jg1.han@samsung.com>,
        <galak@codeaurora.org>, <matt.porter@linaro.org>
Subject: Re: [PATCH v4 6/9] phy: Add support for S5PV210 to the Exynos USB
 PHY driver
References: <1386246579-25141-1-git-send-email-k.debski@samsung.com> <1386325897-27260-1-git-send-email-k.debski@samsung.com>
In-Reply-To: <1386325897-27260-1-git-send-email-k.debski@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Friday 06 December 2013 04:01 PM, Kamil Debski wrote:
> From: Mateusz Krawczuk <mat.krawczuk@gmail.com>
> 
> Add support for the Samsung's S5PV210 SoC to the Exynos USB PHY driver.
> 
> Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
> [k.debski@samsung.com: cleanup and commit description]
> [k.debski@samsung.com: make changes accordingly to the mailing list
> comments]
> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  .../devicetree/bindings/phy/samsung-usbphy.txt     |    1 +
>  drivers/phy/Kconfig                                |    7 +
>  drivers/phy/Makefile                               |    1 +
>  drivers/phy/phy-s5pv210-usb2.c                     |  206 ++++++++++++++++++++
>  drivers/phy/phy-samsung-usb2.c                     |    6 +
>  drivers/phy/phy-samsung-usb2.h                     |    1 +
>  6 files changed, 222 insertions(+)
>  create mode 100644 drivers/phy/phy-s5pv210-usb2.c
> 
> diff --git a/Documentation/devicetree/bindings/phy/samsung-usbphy.txt b/Documentation/devicetree/bindings/phy/samsung-usbphy.txt
> index cadbf70..77a8e9c 100644
> --- a/Documentation/devicetree/bindings/phy/samsung-usbphy.txt
> +++ b/Documentation/devicetree/bindings/phy/samsung-usbphy.txt
> @@ -3,6 +3,7 @@ Samsung S5P/EXYNOS SoC series USB PHY
>  
>  Required properties:
>  - compatible : should be one of the listed compatibles:
> +	- "samsung,s5pv210-usb2-phy"
>  	- "samsung,exynos4210-usb2-phy"
>  	- "samsung,exynos4212-usb2-phy"
>  - reg : a list of registers used by phy driver
> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
> index b29018f..2e433cd 100644
> --- a/drivers/phy/Kconfig
> +++ b/drivers/phy/Kconfig
> @@ -58,6 +58,13 @@ config PHY_SAMSUNG_USB2
>  	  This driver provides common interface to interact, for Samsung
>  	  USB 2.0 PHY driver.
>  
> +config PHY_S5PV210_USB2
> +	bool "Support for S5PV210"
> +	depends on PHY_SAMSUNG_USB2
> +	depends on ARCH_S5PV210
> +	help
> +	  Enable USB PHY support for S5PV210

more description here..
> +
>  config PHY_EXYNOS4210_USB2
>  	bool "Support for Exynos 4210"
>  	depends on PHY_SAMSUNG_USB2
> diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
> index 9f4befd..fefc6c2 100644
> --- a/drivers/phy/Makefile
> +++ b/drivers/phy/Makefile
> @@ -8,5 +8,6 @@ obj-$(CONFIG_PHY_EXYNOS_MIPI_VIDEO)	+= phy-exynos-mipi-video.o
>  obj-$(CONFIG_OMAP_USB2)			+= phy-omap-usb2.o
>  obj-$(CONFIG_TWL4030_USB)		+= phy-twl4030-usb.o
>  obj-$(CONFIG_PHY_SAMSUNG_USB2)		+= phy-samsung-usb2.o
> +obj-$(CONFIG_PHY_S5PV210_USB2)		+= phy-s5pv210-usb2.o
>  obj-$(CONFIG_PHY_EXYNOS4210_USB2)	+= phy-exynos4210-usb2.o
>  obj-$(CONFIG_PHY_EXYNOS4212_USB2)	+= phy-exynos4212-usb2.o
> diff --git a/drivers/phy/phy-s5pv210-usb2.c b/drivers/phy/phy-s5pv210-usb2.c
> new file mode 100644
> index 0000000..528a114
> --- /dev/null
> +++ b/drivers/phy/phy-s5pv210-usb2.c
> @@ -0,0 +1,206 @@
> +/*
> + * Samsung SoC USB 1.1/2.0 PHY driver - S5PV210 support
> + *
> + * Copyright (C) 2013 Samsung Electronics Co., Ltd.
> + * Authors: Kamil Debski <k.debski@samsung.com>
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

I think my comments for the previous patch with a similar driver
(phy-exynos4210-usb2.c) is applicable here also.

Thanks
Kishon

> +#include "phy-samsung-usb2.h"
> +
> +/* Exynos USB PHY registers */
> +
> +/* PHY power control */
> +#define S5PV210_UPHYPWR			0x0
> +
> +#define S5PV210_UPHYPWR_PHY0_SUSPEND	(1 << 0)
> +#define S5PV210_UPHYPWR_PHY0_PWR		(1 << 3)
> +#define S5PV210_UPHYPWR_PHY0_OTG_PWR	(1 << 4)
> +#define S5PV210_UPHYPWR_PHY0	( \
> +	S5PV210_UPHYPWR_PHY0_SUSPEND | \
> +	S5PV210_UPHYPWR_PHY0_PWR | \
> +	S5PV210_UPHYPWR_PHY0_OTG_PWR)
> +
> +#define S5PV210_UPHYPWR_PHY1_SUSPEND	(1 << 6)
> +#define S5PV210_UPHYPWR_PHY1_PWR		(1 << 7)
> +#define S5PV210_UPHYPWR_PHY1 ( \
> +	S5PV210_UPHYPWR_PHY1_SUSPEND | \
> +	S5PV210_UPHYPWR_PHY1_PWR)
> +
> +/* PHY clock control */
> +#define S5PV210_UPHYCLK			0x4
> +
> +#define S5PV210_UPHYCLK_PHYFSEL_MASK	(0x3 << 0)
> +#define S5PV210_UPHYCLK_PHYFSEL_48MHZ	(0x0 << 0)
> +#define S5PV210_UPHYCLK_PHYFSEL_24MHZ	(0x3 << 0)
> +#define S5PV210_UPHYCLK_PHYFSEL_12MHZ	(0x2 << 0)
> +
> +#define S5PV210_UPHYCLK_PHY0_ID_PULLUP	(0x1 << 2)
> +#define S5PV210_UPHYCLK_PHY0_COMMON_ON	(0x1 << 4)
> +#define S5PV210_UPHYCLK_PHY1_COMMON_ON	(0x1 << 7)
> +
> +/* PHY reset control */
> +#define S5PV210_UPHYRST			0x8
> +
> +#define S5PV210_URSTCON_PHY0		(1 << 0)
> +#define S5PV210_URSTCON_OTG_HLINK		(1 << 1)
> +#define S5PV210_URSTCON_OTG_PHYLINK		(1 << 2)
> +#define S5PV210_URSTCON_PHY1_ALL		(1 << 3)
> +#define S5PV210_URSTCON_HOST_LINK_ALL	(1 << 4)
> +
> +/* Isolation, configured in the power management unit */
> +#define S5PV210_USB_ISOL_DEVICE_OFFSET	0x704
> +#define S5PV210_USB_ISOL_DEVICE		(1 << 0)
> +#define S5PV210_USB_ISOL_HOST_OFFSET	0x708
> +#define S5PV210_USB_ISOL_HOST		(1 << 1)
> +
> +
> +enum s5pv210_phy_id {
> +	S5PV210_DEVICE,
> +	S5PV210_HOST,
> +	S5PV210_NUM_PHYS,
> +};
> +
> +/*
> + * s5pv210_rate_to_clk() converts the supplied clock rate to the value that
> + * can be written to the phy register.
> + */
> +static int s5pv210_rate_to_clk(unsigned long rate, u32 *reg)
> +{
> +	pr_info("%lu\n", rate);
> +	switch (rate) {
> +	case 12 * MHZ:
> +		*reg = S5PV210_UPHYCLK_PHYFSEL_12MHZ;
> +		break;
> +	case 24 * MHZ:
> +		*reg = S5PV210_UPHYCLK_PHYFSEL_24MHZ;
> +		break;
> +	case 48 * MHZ:
> +		*reg = S5PV210_UPHYCLK_PHYFSEL_48MHZ;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +}
> +
> +static void s5pv210_isol(struct samsung_usb2_phy_instance *inst, bool on)
> +{
> +	struct samsung_usb2_phy_driver *drv = inst->drv;
> +	u32 mask;
> +	u32 tmp;
> +
> +	if (!drv->reg_isol)
> +		return;
> +
> +	switch (inst->cfg->id) {
> +	case S5PV210_DEVICE:
> +		mask = S5PV210_USB_ISOL_DEVICE;
> +		break;
> +	case S5PV210_HOST:
> +		mask = S5PV210_USB_ISOL_HOST;
> +		break;
> +	default:
> +		return;
> +	};
> +
> +	regmap_update_bits(drv->reg_pmu, offset, mask, on ? 0 : mask);
> +}
> +
> +static void s5pv210_phy_pwr(struct samsung_usb2_phy_instance *inst, bool on)
> +{
> +	struct samsung_usb2_phy_driver *drv = inst->drv;
> +	u32 rstbits = 0;
> +	u32 phypwr = 0;
> +	u32 rst;
> +	u32 pwr;
> +
> +	switch (inst->cfg->id) {
> +	case S5PV210_DEVICE:
> +		phypwr =	S5PV210_UPHYPWR_PHY0;
> +		rstbits =	S5PV210_URSTCON_PHY0;
> +		break;
> +	case S5PV210_HOST:
> +		phypwr =	S5PV210_UPHYPWR_PHY1;
> +		rstbits =	S5PV210_URSTCON_PHY1_ALL |
> +				S5PV210_URSTCON_HOST_LINK_ALL;
> +		break;
> +	};
> +
> +	if (on) {
> +		writel(inst->clk, drv->reg_phy + S5PV210_UPHYCLK);
> +
> +		pwr = readl(drv->reg_phy + S5PV210_UPHYPWR);
> +		pwr &= ~phypwr;
> +		writel(pwr, drv->reg_phy + S5PV210_UPHYPWR);
> +
> +		rst = readl(drv->reg_phy + S5PV210_UPHYRST);
> +		rst |= rstbits;
> +		writel(rst, drv->reg_phy + S5PV210_UPHYRST);
> +		udelay(10);
> +		rst &= ~rstbits;
> +		writel(rst, drv->reg_phy + S5PV210_UPHYRST);
> +	} else {
> +		pwr = readl(drv->reg_phy + S5PV210_UPHYPWR);
> +		pwr |= phypwr;
> +		writel(pwr, drv->reg_phy + S5PV210_UPHYPWR);
> +	}
> +}
> +
> +static int s5pv210_power_on(struct samsung_usb2_phy_instance *inst)
> +{
> +	struct samsung_usb2_phy_driver *drv = inst->drv;
> +
> +	s5pv210_isol(inst, 0);
> +	s5pv210_phy_pwr(inst, 1);
> +
> +	return 0;
> +}
> +
> +static int s5pv210_power_off(struct samsung_usb2_phy_instance *inst)
> +{
> +	struct samsung_usb2_phy_driver *drv = inst->drv;
> +
> +	s5pv210_phy_pwr(inst, 0);
> +	s5pv210_isol(inst, 1);
> +
> +	return 0;
> +}
> +
> +
> +static const struct samsung_usb2_common_phy s5pv210_phys[] = {
> +	{
> +		.label		= "device",
> +		.id		= S5PV210_DEVICE,
> +		.rate_to_clk	= s5pv210_rate_to_clk,
> +		.power_on	= s5pv210_power_on,
> +		.power_off	= s5pv210_power_off,
> +	},
> +	{
> +		.label		= "host",
> +		.id		= S5PV210_HOST,
> +		.rate_to_clk	= s5pv210_rate_to_clk,
> +		.power_on	= s5pv210_power_on,
> +		.power_off	= s5pv210_power_off,
> +	},
> +	{},
> +};
> +
> +const struct samsung_usb2_phy_config s5pv210_usb2_phy_config = {
> +	.cpu		= TYPE_S5PV210,
> +	.num_phys	= S5PV210_NUM_PHYS,
> +	.phys		= s5pv210_phys,
> +};
> +
> diff --git a/drivers/phy/phy-samsung-usb2.c b/drivers/phy/phy-samsung-usb2.c
> index 804ec77..ef93fd3 100644
> --- a/drivers/phy/phy-samsung-usb2.c
> +++ b/drivers/phy/phy-samsung-usb2.c
> @@ -98,6 +98,12 @@ static struct phy *samsung_usb2_phy_xlate(struct device *dev,
>  }
>  
>  static const struct of_device_id samsung_usb2_phy_of_match[] = {
> +#ifdef CONFIG_PHY_S5PV210_USB2
> +	{
> +		.compatible = "samsung,s5pv210-usb2-phy",
> +		.data = &s5pv210_usb2_phy_config,
> +	},
> +#endif
>  #ifdef CONFIG_PHY_EXYNOS4210_USB2
>  	{
>  		.compatible = "samsung,exynos4210-usb2-phy",
> diff --git a/drivers/phy/phy-samsung-usb2.h b/drivers/phy/phy-samsung-usb2.h
> index cd12477..0f51dbb 100644
> --- a/drivers/phy/phy-samsung-usb2.h
> +++ b/drivers/phy/phy-samsung-usb2.h
> @@ -66,6 +66,7 @@ struct samsung_usb2_phy_config {
>  	char has_mode_switch;
>  };
>  
> +extern const struct samsung_usb2_phy_config s5pv210_usb2_phy_config;
>  extern const struct samsung_usb2_phy_config exynos4210_usb2_phy_config;
>  extern const struct samsung_usb2_phy_config exynos4212_usb2_phy_config;
>  #endif
> 

