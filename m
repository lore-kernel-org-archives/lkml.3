Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017Ab3JYPoH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 11:44:07 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:36910 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751502Ab3JYPoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 11:44:04 -0400
Message-ID: <526A91B9.1060901@ti.com>
Date: Fri, 25 Oct 2013 21:13:53 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Kamil Debski <k.debski@samsung.com>
CC: <linux-kernel@vger.kernel.org>, <linux-samsung-soc@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm@vger.kernel.org>, <kyungmin.park@samsung.com>,
        <t.figa@samsung.com>, <s.nawrocki@samsung.com>,
        <m.szyprowski@samsung.com>, <gautam.vivek@samsung.com>,
        <mat.krawczuk@gmail.com>
Subject: Re: [RFC PATCH 2/5] phy: Add WIP Exynos 5250 support to the Exynos
 USB PHY driver
References: <1382710529-12082-1-git-send-email-k.debski@samsung.com> <1382710529-12082-3-git-send-email-k.debski@samsung.com>
In-Reply-To: <1382710529-12082-3-git-send-email-k.debski@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Friday 25 October 2013 07:45 PM, Kamil Debski wrote:
> Add support for Exynos 5250. This is work-in-progress commit. Not
> for merging.
> 
> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  drivers/phy/Kconfig              |    7 +
>  drivers/phy/Makefile             |    1 +
>  drivers/phy/phy-exynos-usb.c     |   10 +
>  drivers/phy/phy-exynos-usb.h     |    1 +
>  drivers/phy/phy-exynos5250-usb.c |  411 ++++++++++++++++++++++++++++++++++++++
>  5 files changed, 430 insertions(+)
>  create mode 100644 drivers/phy/phy-exynos5250-usb.c
> 
> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
> index 2f7ac0a..0f598d0 100644
> --- a/drivers/phy/Kconfig
> +++ b/drivers/phy/Kconfig
> @@ -36,4 +36,11 @@ config PHY_EXYNOS4212_USB
>  	help
>  	  Enable USB PHY support for Exynos 4212
>  
> +config PHY_EXYNOS5250_USB
> +	bool "Support for Exynos 5250"
> +	depends on PHY_EXYNOS_USB

This should be a separate driver. Not necessary to use PHY_EXYNOS_USB.
> +	depends on SOC_EXYNOS5250
> +	help
> +	  Enable USB PHY support for Exynos 5250
> +
>  endmenu
> diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
> index ca3dc82..0dff0dd 100644
> --- a/drivers/phy/Makefile
> +++ b/drivers/phy/Makefile
> @@ -6,3 +6,4 @@ obj-$(CONFIG_GENERIC_PHY)	+= phy-core.o
>  obj-$(CONFIG_PHY_EXYNOS_USB)		+= phy-exynos-usb.o
>  obj-$(CONFIG_PHY_EXYNOS4210_USB)	+= phy-exynos4210-usb.o
>  obj-$(CONFIG_PHY_EXYNOS4212_USB)	+= phy-exynos4212-usb.o
> +obj-$(CONFIG_PHY_EXYNOS5250_USB)	+= phy-exynos5250-usb.o
> diff --git a/drivers/phy/phy-exynos-usb.c b/drivers/phy/phy-exynos-usb.c
> index d4a26df..172b774 100644
> --- a/drivers/phy/phy-exynos-usb.c
> +++ b/drivers/phy/phy-exynos-usb.c
> @@ -212,6 +212,10 @@ extern const struct uphy_config exynos4210_uphy_config;
>  extern const struct uphy_config exynos4212_uphy_config;
>  #endif
>  
> +#ifdef CONFIG_PHY_EXYNOS5250_USB
> +extern const struct uphy_config exynos5250_uphy_config;
> +#endif
> +
>  static const struct of_device_id exynos_uphy_of_match[] = {
>  #ifdef CONFIG_PHY_EXYNOS4210_USB
>  	{
> @@ -225,6 +229,12 @@ static const struct of_device_id exynos_uphy_of_match[] = {
>  		.data = &exynos4212_uphy_config,
>  	},
>  #endif
> +#ifdef CONFIG_PHY_EXYNOS5250_USB
> +	{
> +		.compatible = "samsung,exynos5250-usbphy",
> +		.data = &exynos5250_uphy_config,
> +	},
> +#endif
>  	{ },
>  };
>  
> diff --git a/drivers/phy/phy-exynos-usb.h b/drivers/phy/phy-exynos-usb.h
> index f45cb3c..a9febfa 100644
> --- a/drivers/phy/phy-exynos-usb.h
> +++ b/drivers/phy/phy-exynos-usb.h
> @@ -42,6 +42,7 @@ enum samsung_cpu_type {
>  	TYPE_S3C64XX,
>  	TYPE_EXYNOS4210,
>  	TYPE_EXYNOS4212,
> +	TYPE_EXYNOS5250,

No cpu types here.
>  };
>  
>  enum uphy_state {
> diff --git a/drivers/phy/phy-exynos5250-usb.c b/drivers/phy/phy-exynos5250-usb.c
> new file mode 100644
> index 0000000..156093b
> --- /dev/null
> +++ b/drivers/phy/phy-exynos5250-usb.c
> @@ -0,0 +1,411 @@
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
> +#include "phy-exynos-usb.h"
> +
> +/* Exynos USB PHY registers */
> +#define EXYNOS_5250_REFCLKSEL_CRYSTAL	0x0
> +#define EXYNOS_5250_REFCLKSEL_XO	0x1
> +#define EXYNOS_5250_REFCLKSEL_CLKCORE	0x2
> +
> +#define EXYNOS_5250_FSEL_9MHZ6		0x0
> +#define EXYNOS_5250_FSEL_10MHZ		0x1
> +#define EXYNOS_5250_FSEL_12MHZ		0x2
> +#define EXYNOS_5250_FSEL_19MHZ2		0x3
> +#define EXYNOS_5250_FSEL_20MHZ		0x4
> +#define EXYNOS_5250_FSEL_24MHZ		0x5
> +#define EXYNOS_5250_FSEL_50MHZ		0x7
> +
> +/* Normal host */
> +#define EXYNOS_5250_HOSTPHYCTRL0			0x0
> +
> +#define EXYNOS_5250_HOSTPHYCTRL0_PHYSWRSTALL		(0x1 << 31)
> +#define EXYNOS_5250_HOSTPHYCTRL0_REFCLKSEL_SHIFT	19
> +#define EXYNOS_5250_HOSTPHYCTRL0_REFCLKSEL_MASK	\
> +		(0x3 << EXYNOS_5250_HOSTPHYCTRL0_REFCLKSEL_SHIFT)
> +#define EXYNOS_5250_HOSTPHYCTRL0_FSEL_SHIFT		16
> +#define EXYNOS_5250_HOSTPHYCTRL0_FSEL_MASK \
> +		(0x7 << EXYNOS_5250_HOSTPHYCTRL0_FSEL_SHIFT)
> +#define EXYNOS_5250_HOSTPHYCTRL0_TESTBURNIN		(0x1 << 11)
> +#define EXYNOS_5250_HOSTPHYCTRL0_RETENABLE		(0x1 << 10)
> +#define EXYNOS_5250_HOSTPHYCTRL0_COMMON_ON_N		(0x1 << 9)
> +#define EXYNOS_5250_HOSTPHYCTRL0_VATESTENB_MASK		(0x3 << 7)
> +#define EXYNOS_5250_HOSTPHYCTRL0_VATESTENB_DUAL		(0x0 << 7)
> +#define EXYNOS_5250_HOSTPHYCTRL0_VATESTENB_ID0		(0x1 << 7)
> +#define EXYNOS_5250_HOSTPHYCTRL0_VATESTENB_ANALOGTEST	(0x2 << 7)
> +#define EXYNOS_5250_HOSTPHYCTRL0_SIDDQ			(0x1 << 6)
> +#define EXYNOS_5250_HOSTPHYCTRL0_FORCESLEEP		(0x1 << 5)
> +#define EXYNOS_5250_HOSTPHYCTRL0_FORCESUSPEND		(0x1 << 4)
> +#define EXYNOS_5250_HOSTPHYCTRL0_WORDINTERFACE		(0x1 << 3)
> +#define EXYNOS_5250_HOSTPHYCTRL0_UTMISWRST		(0x1 << 2)
> +#define EXYNOS_5250_HOSTPHYCTRL0_LINKSWRST		(0x1 << 1)
> +#define EXYNOS_5250_HOSTPHYCTRL0_PHYSWRST		(0x1 << 0)
> +
> +/* HSIC0 & HSCI1 */
> +#define EXYNOS_5250_HOSTPHYCTRL1			0x10
> +#define EXYNOS_5250_HOSTPHYCTRL2			0x20
> +
> +#define EXYNOS_5250_HOSTPHYCTRLX_REFCLKSEL_MASK		(0x3 << 23)
> +#define EXYNOS_5250_HOSTPHYCTRLX_REFCLKDIV_MASK		(0x7f << 16)
> +#define EXYNOS_5250_HOSTPHYCTRLX_SIDDQ			(0x1 << 6)
> +#define EXYNOS_5250_HOSTPHYCTRLX_FORCESLEEP		(0x1 << 5)
> +#define EXYNOS_5250_HOSTPHYCTRLX_FORCESUSPEND		(0x1 << 4)
> +#define EXYNOS_5250_HOSTPHYCTRLX_WORDINTERFACE		(0x1 << 3)
> +#define EXYNOS_5250_HOSTPHYCTRLX_UTMISWRST		(0x1 << 2)
> +#define EXYNOS_5250_HOSTPHYCTRLX_PHYSWRST		(0x1 << 0)
> +
> +/* EHCI control */
> +#define EXYNOS_5250_HOSTEHCICTRL			0x30
> +#define EXYNOS_5250_HOSTEHCICTRL_ENAINCRXALIGN		(0x1 << 29)
> +#define EXYNOS_5250_HOSTEHCICTRL_ENAINCR4		(0x1 << 28)
> +#define EXYNOS_5250_HOSTEHCICTRL_ENAINCR8		(0x1 << 27)
> +#define EXYNOS_5250_HOSTEHCICTRL_ENAINCR16		(0x1 << 26)
> +#define EXYNOS_5250_HOSTEHCICTRL_AUTOPPDONOVRCUREN	(0x1 << 25)
> +#define EXYNOS_5250_HOSTEHCICTRL_FLADJVAL0_SHIFT	19
> +#define EXYNOS_5250_HOSTEHCICTRL_FLADJVAL0_MASK	\
> +		(0x3f << EXYNOS_5250_HOSTEHCICTRL_FLADJVAL0_SHIFT)
> +#define EXYNOS_5250_HOSTEHCICTRL_FLADJVAL1_SHIFT	13
> +#define EXYNOS_5250_HOSTEHCICTRL_FLADJVAL1_MASK	\
> +		(0x3f << EXYNOS_5250_HOSTEHCICTRL_FLADJVAL1_SHIFT)
> +#define EXYNOS_5250_HOSTEHCICTRL_FLADJVAL2_SHIFT	7
> +#define EXYNOS_5250_HOSTEHCICTRL_FLADJVAL0_MASK	\
> +		(0x3f << EXYNOS_5250_HOSTEHCICTRL_FLADJVAL0_SHIFT)
> +#define EXYNOS_5250_HOSTEHCICTRL_FLADJVALHOST_SHIFT	1
> +#define EXYNOS_5250_HOSTEHCICTRL_FLADJVALHOST_MASK \
> +		(0x1 << EXYNOS_5250_HOSTEHCICTRL_FLADJVALHOST_SHIFT)
> +#define EXYNOS_5250_HOSTEHCICTRL_SIMULATIONMODE		(0x1 << 0)
> +
> +/* OHCI control */
> +#define EXYNOS_5250_HOSTOHCICTRL                        0x34
> +#define EXYNOS_5250_HOSTOHCICTRL_FRAMELENVAL_SHIFT	1
> +#define EXYNOS_5250_HOSTOHCICTRL_FRAMELENVAL_MASK \
> +		(0x3ff << EXYNOS_5250_HOSTOHCICTRL_FRAMELENVAL_SHIFT)
> +#define EXYNOS_5250_HOSTOHCICTRL_FRAMELENVALEN		(0x1 << 0)
> +
> +/* USBOTG */
> +#define EXYNOS_5250_USBOTGSYS				0x38
> +#define EXYNOS_5250_USBOTGSYS_PHYLINK_SW_RESET		(0x1 << 14)
> +#define EXYNOS_5250_USBOTGSYS_LINK_SW_RST_UOTG		(0x1 << 13)
> +#define EXYNOS_5250_USBOTGSYS_PHY_SW_RST		(0x1 << 12)
> +#define EXYNOS_5250_USBOTGSYS_REFCLKSEL_SHIFT		9
> +#define EXYNOS_5250_USBOTGSYS_REFCLKSEL_MASK \
> +		(0x3 << EXYNOS_5250_USBOTGSYS_REFCLKSEL_SHIFT)
> +#define EXYNOS_5250_USBOTGSYS_ID_PULLUP			(0x1 << 8)
> +#define EXYNOS_5250_USBOTGSYS_COMMON_ON			(0x1 << 7)
> +#define EXYNOS_5250_USBOTGSYS_FSEL_SHIFT		4
> +#define EXYNOS_5250_USBOTGSYS_FSEL_MASK \
> +		(0x3 << EXYNOS_5250_USBOTGSYS_FSEL_SHIFT)
> +#define EXYNOS_5250_USBOTGSYS_FORCE_SLEEP		(0x1 << 3)
> +#define EXYNOS_5250_USBOTGSYS_OTGDISABLE		(0x1 << 2)
> +#define EXYNOS_5250_USBOTGSYS_SIDDQ_UOTG		(0x1 << 1)
> +#define EXYNOS_5250_USBOTGSYS_FORCE_SUSPEND		(0x1 << 0)
> +
> +/* Isolation, configured in the power management unit */
> +#define EXYNOS_5250_USB_ISOL_OTG_OFFSET		0x0
> +#define EXYNOS_5250_USB_ISOL_OTG		(1 << 0)
> +#define EXYNOS_5250_USB_ISOL_HOST_OFFSET	0x4
> +#define EXYNOS_5250_USB_ISOL_HOST		(1 << 0)
> +
> +enum exynos4x12_phy_id {
> +	EXYNOS5250_DEVICE,
> +	EXYNOS5250_HOST,
> +	EXYNOS5250_HSIC0,
> +	EXYNOS5250_HSIC1,
> +	EXYNOS5250_NUM_PHYS,
> +};
> +
> +/* exynos5250_rate_to_clk() converts the supplied clock rate to the value that
> + * can be written to the phy register. */

Follow coding guidelines ;-)
> +static u32 exynos5250_rate_to_clk(unsigned long rate)
> +{
> +	unsigned int clksel;
> +
> +	/* EXYNOS_5250_FSEL_MASK */
> +
> +	switch (rate) {
> +	case 9600 * KHZ:
> +		clksel = EXYNOS_5250_FSEL_9MHZ6;
> +		break;
> +	case 10 * MHZ:
> +		clksel = EXYNOS_5250_FSEL_10MHZ;
> +		break;
> +	case 12 * MHZ:
> +		clksel = EXYNOS_5250_FSEL_12MHZ;
> +		break;
> +	case 19200 * KHZ:
> +		clksel = EXYNOS_5250_FSEL_19MHZ2;
> +		break;
> +	case 20 * MHZ:
> +		clksel = EXYNOS_5250_FSEL_20MHZ;
> +		break;
> +	case 24 * MHZ:
> +		clksel = EXYNOS_5250_FSEL_24MHZ;
> +		break;
> +	case 50 * MHZ:
> +		clksel = EXYNOS_5250_FSEL_50MHZ;
> +		break;
> +	default:
> +		clksel = CLKSEL_ERROR;
> +	}
> +
> +	return clksel;
> +}
> +
> +static void exynos5250_isol(struct uphy_instance *inst, bool on)
> +{
> +	struct uphy_driver *drv = inst->drv;
> +	u32 offset;
> +	u32 mask;
> +	u32 tmp;
> +
> +	if (!drv->reg_isol)
> +		return;
> +
> +	switch (inst->cfg->id) {
> +	case EXYNOS5250_DEVICE:
> +		offset = EXYNOS_5250_USB_ISOL_OTG_OFFSET;
> +		mask = EXYNOS_5250_USB_ISOL_OTG;
> +		break;
> +	case EXYNOS5250_HOST:
> +		offset = EXYNOS_5250_USB_ISOL_HOST_OFFSET;
> +		mask = EXYNOS_5250_USB_ISOL_HOST;
> +		break;
> +	default:
> +		return;
> +	};
> +
> +	tmp = readl(drv->reg_isol + offset);
> +	if (on)
> +		tmp &= ~mask;
> +	else
> +		tmp |= mask;
> +	writel(tmp, drv->reg_isol + offset);
> +}
> +
> +static void exynos5250_phy_pwr(struct uphy_instance *inst, bool on)
> +{
> +	struct uphy_driver *drv = inst->drv;
> +	u32 ctrl0;
> +	u32 otg;
> +	u32 ehci;
> +	u32 ohci;
> +
> +	switch (inst->cfg->id) {
> +	case EXYNOS5250_DEVICE:
> +		writel(0, drv->reg_mode);
> +
> +		/* OTG configuration */
> +		otg = readl(drv->reg_phy + EXYNOS_5250_USBOTGSYS);
> +		/* The clock */
> +		otg &= ~EXYNOS_5250_USBOTGSYS_FSEL_MASK;
> +		otg |= inst->clk << EXYNOS_5250_USBOTGSYS_FSEL_SHIFT;
> +		/* Reset */
> +		otg &= ~(EXYNOS_5250_USBOTGSYS_FORCE_SUSPEND |
> +			EXYNOS_5250_USBOTGSYS_FORCE_SLEEP |
> +			EXYNOS_5250_USBOTGSYS_SIDDQ_UOTG);
> +		/* TODO: Clear 4 bits as the old driver does. */
> +		otg |=	EXYNOS_5250_USBOTGSYS_PHY_SW_RST |
> +			EXYNOS_5250_USBOTGSYS_PHYLINK_SW_RESET |
> +			EXYNOS_5250_USBOTGSYS_LINK_SW_RST_UOTG |
> +			EXYNOS_5250_USBOTGSYS_OTGDISABLE;
> +		/* Ref clock */
> +		otg &=	EXYNOS_5250_USBOTGSYS_REFCLKSEL_MASK;
> +		otg |=  EXYNOS_5250_REFCLKSEL_CLKCORE <<
> +					EXYNOS_5250_USBOTGSYS_REFCLKSEL_SHIFT;
> +		writel(otg, drv->reg_phy + EXYNOS_5250_USBOTGSYS);
> +		udelay(10);
> +		otg &= ~(EXYNOS_5250_USBOTGSYS_PHY_SW_RST |
> +			EXYNOS_5250_USBOTGSYS_LINK_SW_RST_UOTG |
> +			EXYNOS_5250_USBOTGSYS_PHYLINK_SW_RESET);
> +
> +
> +		break;
> +	case EXYNOS5250_HOST:
> +		/* Host registers configuration */
> +		ctrl0 = readl(drv->reg_phy + EXYNOS_5250_HOSTPHYCTRL0);
> +		/* The clock */
> +		ctrl0 &= ~EXYNOS_5250_HOSTPHYCTRL0_FSEL_MASK;
> +		ctrl0 |= inst->clk << EXYNOS_5250_HOSTPHYCTRL0_FSEL_SHIFT;
> +
> +		/* Reset */
> +		ctrl0 &= ~(	EXYNOS_5250_HOSTPHYCTRL0_PHYSWRST |
> +				EXYNOS_5250_HOSTPHYCTRL0_PHYSWRSTALL |
> +				EXYNOS_5250_HOSTPHYCTRL0_SIDDQ |
> +				EXYNOS_5250_HOSTPHYCTRL0_FORCESUSPEND |
> +				EXYNOS_5250_HOSTPHYCTRL0_FORCESLEEP);
> +		ctrl0 |=	EXYNOS_5250_HOSTPHYCTRL0_LINKSWRST |
> +				EXYNOS_5250_HOSTPHYCTRL0_UTMISWRST |
> +				EXYNOS_5250_HOSTPHYCTRL0_COMMON_ON_N;
> +		writel(ctrl0, drv->reg_phy + EXYNOS_5250_HOSTPHYCTRL0);
> +		udelay(10);
> +		ctrl0 &= ~(	EXYNOS_5250_HOSTPHYCTRL0_LINKSWRST |
> +				EXYNOS_5250_HOSTPHYCTRL0_UTMISWRST);
> +		writel(ctrl0, drv->reg_phy + EXYNOS_5250_HOSTPHYCTRL0);
> +
> +		/* OTG configuration */
> +		otg = readl(drv->reg_phy + EXYNOS_5250_USBOTGSYS);
> +		/* The clock */
> +		otg &= ~EXYNOS_5250_USBOTGSYS_FSEL_MASK;
> +		otg |= inst->clk << EXYNOS_5250_USBOTGSYS_FSEL_SHIFT;
> +		/* Reset */
> +		otg &= ~(EXYNOS_5250_USBOTGSYS_FORCE_SUSPEND |
> +			EXYNOS_5250_USBOTGSYS_FORCE_SLEEP |
> +			EXYNOS_5250_USBOTGSYS_SIDDQ_UOTG);
> +		/* TODO: Clear 4 bits as the old driver does. */
> +		otg |=	EXYNOS_5250_USBOTGSYS_PHY_SW_RST |
> +			EXYNOS_5250_USBOTGSYS_PHYLINK_SW_RESET |
> +			EXYNOS_5250_USBOTGSYS_LINK_SW_RST_UOTG |
> +			EXYNOS_5250_USBOTGSYS_OTGDISABLE;
> +		/* Ref clock */
> +		otg &=	EXYNOS_5250_USBOTGSYS_REFCLKSEL_MASK;
> +		otg |=  EXYNOS_5250_REFCLKSEL_CLKCORE <<
> +					EXYNOS_5250_USBOTGSYS_REFCLKSEL_SHIFT;
> +		writel(otg, drv->reg_phy + EXYNOS_5250_USBOTGSYS);
> +		udelay(10);
> +		otg &= ~(EXYNOS_5250_USBOTGSYS_PHY_SW_RST |
> +			EXYNOS_5250_USBOTGSYS_LINK_SW_RST_UOTG |
> +			EXYNOS_5250_USBOTGSYS_PHYLINK_SW_RESET);
> +
> +		/* Enable EHCI DMA burst */
> +		ehci = readl(drv->reg_phy + EXYNOS_5250_HOSTEHCICTRL);
> +		ehci |=	EXYNOS_5250_HOSTEHCICTRL_ENAINCRXALIGN |
> +			EXYNOS_5250_HOSTEHCICTRL_ENAINCR4 |
> +			EXYNOS_5250_HOSTEHCICTRL_ENAINCR8 |
> +			EXYNOS_5250_HOSTEHCICTRL_ENAINCR16;
> +		writel(ehci, drv->reg_phy + EXYNOS_5250_HOSTEHCICTRL);
> +
> +		/* OHCI settings */
> +		ohci = readl(drv->reg_phy + EXYNOS_5250_HOSTOHCICTRL);
> +		/* Let's do some undocumented magic (based on the old driver) */
> +		ohci |=	0x1 << 3;
> +		writel(ohci, drv->reg_phy + EXYNOS_5250_HOSTOHCICTRL);
> +
> +		break;
> +	}
> +}
> +
> +static int exynos5250_power_on(struct uphy_instance *inst)
> +{
> +	struct uphy_driver *drv = inst->drv;
> +
> +	if (inst->state == STATE_ON) {
> +		dev_err(drv->dev, "usb phy \"%s\" already on",
> +							inst->cfg->label);
> +		return -ENODEV;
> +	}
> +
> +	inst->state = STATE_ON;
> +	inst->ref_cnt++;
> +	if (inst->ref_cnt > 1)
> +		return 0;
> +
> +	exynos5250_phy_pwr(inst, 1);
> +	exynos5250_isol(inst, 0);
> +
> +	/* Power on the device, as it is necessary for HSIC to work */
> +	if (inst->cfg->id == EXYNOS5250_HSIC0) {
> +		struct uphy_instance *device =
> +					&drv->uphy_instances[EXYNOS5250_DEVICE];
> +		device->ref_cnt++;
> +		if (device->ref_cnt > 1)
> +			return 0;
> +		exynos5250_phy_pwr(device, 1);
> +		exynos5250_isol(device, 0);
> +	}
> +
> +	return 0;
> +}
> +
> +static int exynos5250_power_off(struct uphy_instance *inst)
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
> +	inst->ref_cnt--;
> +
> +	if (inst->ref_cnt > 0)
> +		return 0;
> +
> +	exynos5250_isol(inst, 1);
> +	exynos5250_phy_pwr(inst, 0);
> +
> +	if (inst->cfg->id == EXYNOS5250_HSIC0) {
> +		struct uphy_instance *device =
> +					&drv->uphy_instances[EXYNOS5250_DEVICE];
> +		device->ref_cnt--;
> +		if (device->ref_cnt > 0)
> +			return 0;
> +		exynos5250_isol(device, 1);
> +		exynos5250_phy_pwr(device, 0);
> +	}
> +
> +	return 0;
> +}
> +
> +
> +static const struct common_phy exynos5250_phys[] = {
> +	{
> +		.label		= "device",
> +		.type		= PHY_DEVICE,
> +		.id		= EXYNOS5250_DEVICE,
> +		.rate_to_clk	= exynos5250_rate_to_clk,
> +		.power_on	= exynos5250_power_on,
> +		.power_off	= exynos5250_power_off,
> +	},
> +	{
> +		.label		= "host",
> +		.type		= PHY_HOST,
> +		.id		= EXYNOS5250_HOST,
> +		.rate_to_clk	= exynos5250_rate_to_clk,
> +		.power_on	= exynos5250_power_on,
> +		.power_off	= exynos5250_power_off,
> +	},
> +	{
> +		.label		= "hsic0",
> +		.type		= PHY_HOST,
> +		.id		= EXYNOS5250_HSIC0,
> +		.rate_to_clk	= exynos5250_rate_to_clk,
> +		.power_on	= exynos5250_power_on,
> +		.power_off	= exynos5250_power_off,
> +	},
> +	{
> +		.label		= "hsic1",
> +		.type		= PHY_HOST,
> +		.id		= EXYNOS5250_HSIC1,
> +		.rate_to_clk	= exynos5250_rate_to_clk,
> +		.power_on	= exynos5250_power_on,
> +		.power_off	= exynos5250_power_off,
> +	},
> +	{},
> +};

All this can be removed if you don't use exynos common PHY.

Thanks
Kishon
