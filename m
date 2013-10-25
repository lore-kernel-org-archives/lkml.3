Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753086Ab3JYPuc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 11:50:32 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:40522 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284Ab3JYPua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 11:50:30 -0400
Message-ID: <526A933C.4020904@ti.com>
Date: Fri, 25 Oct 2013 21:20:20 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Kamil Debski <k.debski@samsung.com>
CC: <linux-kernel@vger.kernel.org>, <linux-samsung-soc@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm@vger.kernel.org>, <kyungmin.park@samsung.com>,
        <t.figa@samsung.com>, <s.nawrocki@samsung.com>,
        <m.szyprowski@samsung.com>, <gautam.vivek@samsung.com>,
        <mat.krawczuk@gmail.com>,
        Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
Subject: Re: [PATCH 3/5] phy: Add support for S5PV210 to the Exynos USB PHY
 driver
References: <1382710529-12082-1-git-send-email-k.debski@samsung.com> <1382710529-12082-4-git-send-email-k.debski@samsung.com>
In-Reply-To: <1382710529-12082-4-git-send-email-k.debski@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Friday 25 October 2013 07:45 PM, Kamil Debski wrote:
> From: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
> 
> Add support for the Samsung's S5PV210 SoC to the Exynos USB PHY driver.
> 
> Signed-off-by: Mateusz Krawczuk <m.krawczuk@partner.samsung.com>
> [k.debski@samsung.com: whitespace cleanup and commit description]
> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> ---
>  drivers/phy/Kconfig           |    7 ++
>  drivers/phy/phy-exynos-usb.c  |   10 ++
>  drivers/phy/phy-exynos-usb.h  |    1 +
>  drivers/phy/phy-s5pv210-usb.c |  236 +++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 254 insertions(+)
>  create mode 100644 drivers/phy/phy-s5pv210-usb.c
> 
> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
> index 0f598d0..d3517f9 100644
> --- a/drivers/phy/Kconfig
> +++ b/drivers/phy/Kconfig
> @@ -22,6 +22,13 @@ config PHY_EXYNOS_USB
>  	  This driver provides common interface to interact, for Samsung
>  	  USB 2.0 PHY driver.
>  
> +config PHY_S5PV210_USB
> +	bool "Support for S5PV210"
> +	depends on PHY_EXYNOS_USB
> +	depends on ARCH_S5PV210
> +	help
> +	  Enable USB PHY support for S5PV210
> +
>  config PHY_EXYNOS4210_USB
>  	bool "Support for Exynos 4210"
>  	depends on PHY_EXYNOS_USB
> diff --git a/drivers/phy/phy-exynos-usb.c b/drivers/phy/phy-exynos-usb.c
> index 172b774..01fb12a 100644
> --- a/drivers/phy/phy-exynos-usb.c
> +++ b/drivers/phy/phy-exynos-usb.c
> @@ -216,7 +216,17 @@ extern const struct uphy_config exynos4212_uphy_config;
>  extern const struct uphy_config exynos5250_uphy_config;
>  #endif
>  
> +#ifdef CONFIG_PHY_S5PV210_USB
> +extern const struct uphy_config s5pv210_uphy_config;
> +#endif
> +
>  static const struct of_device_id exynos_uphy_of_match[] = {
> +#ifdef CONFIG_PHY_S5PV210_USB
> +	{
> +		.compatible = "samsung,s5pv210-usbphy",
> +		.data = &s5pv210_uphy_config,
> +	},
> +#endif
>  #ifdef CONFIG_PHY_EXYNOS4210_USB
>  	{
>  		.compatible = "samsung,exynos4210-usbphy",
> diff --git a/drivers/phy/phy-exynos-usb.h b/drivers/phy/phy-exynos-usb.h
> index a9febfa..0f385ca 100644
> --- a/drivers/phy/phy-exynos-usb.h
> +++ b/drivers/phy/phy-exynos-usb.h
> @@ -40,6 +40,7 @@ enum phy_type {
>  
>  enum samsung_cpu_type {
>  	TYPE_S3C64XX,
> +	TYPE_S5PV210,
>  	TYPE_EXYNOS4210,
>  	TYPE_EXYNOS4212,
>  	TYPE_EXYNOS5250,
> diff --git a/drivers/phy/phy-s5pv210-usb.c b/drivers/phy/phy-s5pv210-usb.c
> new file mode 100644
> index 0000000..575275d
> --- /dev/null
> +++ b/drivers/phy/phy-s5pv210-usb.c

how different is this IP different from the previous ones? Does it deserve a
separate driver or the previous drivers can be re-used?
> @@ -0,0 +1,236 @@
> +/*
> + * Samsung S5P/EXYNOS SoC series USB PHY driver
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
> +#include "phy-exynos-usb.h"
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
> +#define S5PV210_USB_ISOL_DEVICE_OFFSET	0x0
> +#define S5PV210_USB_ISOL_DEVICE		(1 << 0)
> +#define S5PV210_USB_ISOL_HOST_OFFSET	0x4
> +#define S5PV210_USB_ISOL_HOST		(1 << 1)
> +
> +
> +enum s5pv210_phy_id {
> +	S5PV210_DEVICE,
> +	S5PV210_HOST,
> +	S5PV210_NUM_PHYS,
> +};
> +
> +/* s5pv210_rate_to_clk() converts the supplied clock rate to the value that
> + * can be written to the phy register. */
> +static u32 s5pv210_rate_to_clk(unsigned long rate)
> +{
> +	unsigned int clksel;
> +
> +	pr_info("%lu \n",rate);
> +	switch (rate) {
> +	case 12 * MHZ:
> +		clksel = S5PV210_UPHYCLK_PHYFSEL_12MHZ;
> +		break;
> +	case 24 * MHZ:
> +		clksel = S5PV210_UPHYCLK_PHYFSEL_24MHZ;
> +		break;
> +	case 48 * MHZ:
> +		clksel = S5PV210_UPHYCLK_PHYFSEL_48MHZ;
> +		break;
> +	default:
> +		clksel = CLKSEL_ERROR;
> +	}
> +
> +	return clksel;
> +}
> +
> +static void s5pv210_isol(struct uphy_instance *inst, bool on)
> +{
> +	struct uphy_driver *drv = inst->drv;
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
> +	tmp = readl(drv->reg_isol);
> +	if (on)
> +		tmp &= ~mask;
> +	else
> +		tmp |= mask;
> +	writel(tmp, drv->reg_isol);
> +}
> +
> +static void s5pv210_phy_pwr(struct uphy_instance *inst, bool on)
> +{
> +	struct uphy_driver *drv = inst->drv;
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
> +static int s5pv210_power_on(struct uphy_instance *inst)
> +{
> +	struct uphy_driver *drv = inst->drv;
> +
> +	if (inst->state == STATE_ON) {
> +		dev_err(drv->dev, "usb phy \"%s\" already on",
> +							inst->cfg->label);
> +		return -ENODEV;
> +	}
> +	inst->state = STATE_ON;
> +	inst->ref_cnt++;
> +	if (inst->ref_cnt > 1)
> +		return 0;
> +
> +	s5pv210_isol(inst, 0);
> +	s5pv210_phy_pwr(inst, 1);
> +
> +	return 0;
> +}
> +
> +static int s5pv210_power_off(struct uphy_instance *inst)
> +{
> +	struct uphy_driver *drv = inst->drv;
> +
> +	if (inst->state == STATE_OFF) {
> +		dev_err(drv->dev, "usb phy \"%s\" already off",
> +							inst->cfg->label);
> +		return -EINVAL;
> +	}
> +
> +	inst->state = STATE_OFF;
> +	inst->ref_cnt++;
> +	if (inst->ref_cnt > 0)
> +		return 0;
> +
> +	s5pv210_phy_pwr(inst, 0);
> +	s5pv210_isol(inst, 1);
> +
> +	return 0;
> +}
> +
> +
> +static const struct common_phy s5pv210_phys[] = {
> +	{
> +		.label		= "device",
> +		.type		= PHY_DEVICE,
> +		.id		= S5PV210_DEVICE,
> +		.rate_to_clk	= s5pv210_rate_to_clk,
> +		.power_on	= s5pv210_power_on,
> +		.power_off	= s5pv210_power_off,
> +	},
> +	{
> +		.label		= "host",
> +		.type		= PHY_HOST,
> +		.id		= S5PV210_HOST,
> +		.rate_to_clk	= s5pv210_rate_to_clk,
> +		.power_on	= s5pv210_power_on,
> +		.power_off	= s5pv210_power_off,
> +	},
> +	{},
> +};
> +
> +const struct uphy_config s5pv210_uphy_config = {
> +	.cpu		= TYPE_S5PV210,
> +	.num_phys	= S5PV210_NUM_PHYS,
> +	.phys		= s5pv210_phys,
> +};

IMO this looks similar to the other drivers. Please re-use the drivers wherever
possible.

Thanks
Kishon
