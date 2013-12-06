Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757732Ab3LFLQN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 06:16:13 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:56496 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753799Ab3LFLQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 06:16:11 -0500
Message-ID: <52A1B1EE.8050201@ti.com>
Date: Fri, 6 Dec 2013 16:45:58 +0530
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
Subject: Re: [PATCH v4 7/9] phy: Add Exynos 5250 support to the Exynos USB
 2.0 PHY driver
References: <1386246579-25141-1-git-send-email-k.debski@samsung.com> <1386325955-27322-1-git-send-email-k.debski@samsung.com>
In-Reply-To: <1386325955-27322-1-git-send-email-k.debski@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 06 December 2013 04:02 PM, Kamil Debski wrote:
> Add support for Exynos 5250. This driver is to replace the old
> USB 2.0 PHY driver.
> 
> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  .../devicetree/bindings/phy/samsung-usbphy.txt     |    1 +
>  drivers/phy/Kconfig                                |    8 +
>  drivers/phy/Makefile                               |    1 +
>  drivers/phy/phy-exynos5250-usb2.c                  |  363 ++++++++++++++++++++
>  drivers/phy/phy-samsung-usb2.c                     |    6 +
>  drivers/phy/phy-samsung-usb2.h                     |    1 +
>  6 files changed, 380 insertions(+)
>  create mode 100644 drivers/phy/phy-exynos5250-usb2.c
> 
> diff --git a/Documentation/devicetree/bindings/phy/samsung-usbphy.txt b/Documentation/devicetree/bindings/phy/samsung-usbphy.txt
> index 77a8e9c..94096fc 100644
> --- a/Documentation/devicetree/bindings/phy/samsung-usbphy.txt
> +++ b/Documentation/devicetree/bindings/phy/samsung-usbphy.txt
> @@ -6,6 +6,7 @@ Required properties:
>  	- "samsung,s5pv210-usb2-phy"
>  	- "samsung,exynos4210-usb2-phy"
>  	- "samsung,exynos4212-usb2-phy"
> +	- "samsung,exynos5250-usb2-phy"
>  - reg : a list of registers used by phy driver
>  	- first and obligatory is the location of phy modules registers
>  - samsung,sysreg-phandle - handle to syscon used to control the system registers
> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
> index 2e433cd..74e9064 100644
> --- a/drivers/phy/Kconfig
> +++ b/drivers/phy/Kconfig
> @@ -78,4 +78,12 @@ config PHY_EXYNOS4212_USB2
>  	depends on (SOC_EXYNOS4212 || SOC_EXYNOS4412)
>  	help
>  	  Enable USB PHY support for Exynos 4212
> +
> +config PHY_EXYNOS5250_USB2
> +	bool "Support for Exynos 5250"
> +	depends on PHY_SAMSUNG_USB2
> +	depends on SOC_EXYNOS5250
> +	help
> +	  Enable USB PHY support for Exynos 5250

My comments for the previous patch is applicable here too..

Thanks
Kishon

> +
>  endmenu
> diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
> index fefc6c2..33c3ac1 100644
> --- a/drivers/phy/Makefile
> +++ b/drivers/phy/Makefile
> @@ -11,3 +11,4 @@ obj-$(CONFIG_PHY_SAMSUNG_USB2)		+= phy-samsung-usb2.o
>  obj-$(CONFIG_PHY_S5PV210_USB2)		+= phy-s5pv210-usb2.o
>  obj-$(CONFIG_PHY_EXYNOS4210_USB2)	+= phy-exynos4210-usb2.o
>  obj-$(CONFIG_PHY_EXYNOS4212_USB2)	+= phy-exynos4212-usb2.o
> +obj-$(CONFIG_PHY_EXYNOS5250_USB2)	+= phy-exynos5250-usb2.o
> diff --git a/drivers/phy/phy-exynos5250-usb2.c b/drivers/phy/phy-exynos5250-usb2.c
> new file mode 100644
> index 0000000..7aeebc8
> --- /dev/null
> +++ b/drivers/phy/phy-exynos5250-usb2.c
> @@ -0,0 +1,363 @@
> +/*
> + * Samsung SoC USB 1.1/2.0 PHY driver - Exynos 5250 support
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
> +#include <linux/regmap.h>
> +#include <linux/spinlock.h>
> +#include "phy-samsung-usb2.h"
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
> +#define EXYNOS_5250_USB_ISOL_OTG_OFFSET		0x704
> +#define EXYNOS_5250_USB_ISOL_OTG		(1 << 0)
> +#define EXYNOS_5250_USB_ISOL_HOST_OFFSET	0x708
> +#define EXYNOS_5250_USB_ISOL_HOST		(1 << 0)
> +
> +/* Mode swtich register */
> +#define EXYNOS_5250_MODE_SWITCH_OFFSET		0x230
> +#define EXYNOS_5250_MODE_SWITCH_MASK		1
> +#define EXYNOS_5250_MODE_SWITCH_DEVICE		0
> +#define EXYNOS_5250_MODE_SWITCH_HOST		1
> +
> +enum exynos4x12_phy_id {
> +	EXYNOS5250_DEVICE,
> +	EXYNOS5250_HOST,
> +	EXYNOS5250_HSIC0,
> +	EXYNOS5250_HSIC1,
> +	EXYNOS5250_NUM_PHYS,
> +};
> +
> +/*
> + * exynos5250_rate_to_clk() converts the supplied clock rate to the value that
> + * can be written to the phy register.
> + */
> +static int exynos5250_rate_to_clk(unsigned long rate, u32 *reg)
> +{
> +	/* EXYNOS_5250_FSEL_MASK */
> +
> +	switch (rate) {
> +	case 9600 * KHZ:
> +		*reg = EXYNOS_5250_FSEL_9MHZ6;
> +		break;
> +	case 10 * MHZ:
> +		*reg = EXYNOS_5250_FSEL_10MHZ;
> +		break;
> +	case 12 * MHZ:
> +		*reg = EXYNOS_5250_FSEL_12MHZ;
> +		break;
> +	case 19200 * KHZ:
> +		*reg = EXYNOS_5250_FSEL_19MHZ2;
> +		break;
> +	case 20 * MHZ:
> +		*reg = EXYNOS_5250_FSEL_20MHZ;
> +		break;
> +	case 24 * MHZ:
> +		*reg = EXYNOS_5250_FSEL_24MHZ;
> +		break;
> +	case 50 * MHZ:
> +		*reg = EXYNOS_5250_FSEL_50MHZ;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +static void exynos5250_isol(struct samsung_usb2_phy_instance *inst, bool on)
> +{
> +	struct samsung_usb2_phy_driver *drv = inst->drv;
> +	u32 offset;
> +	u32 mask;
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
> +	regmap_update_bits(drv->reg_pmu, offset, mask, on ? 0 : mask);
> +}
> +
> +static void exynos5250_phy_pwr(struct samsung_usb2_phy_instance *inst, bool on)
> +{
> +	struct samsung_usb2_phy_driver *drv = inst->drv;
> +	u32 ctrl0;
> +	u32 otg;
> +	u32 ehci;
> +	u32 ohci;
> +
> +	switch (inst->cfg->id) {
> +	case EXYNOS5250_DEVICE:
> +		regmap_update_bits(drv->reg_sys,
> +			EXYNOS_5250_MODE_SWITCH_OFFSET,
> +			EXYNOS_5250_MODE_SWITCH_MASK,
> +			EXYNOS_5250_MODE_SWITCH_DEVICE);
> +
> +		/* OTG configuration */
> +		otg = readl(drv->reg_phy + EXYNOS_5250_USBOTGSYS);
> +		/* The clock */
> +		otg &= ~EXYNOS_5250_USBOTGSYS_FSEL_MASK;
> +		otg |= inst->clk_reg_val << EXYNOS_5250_USBOTGSYS_FSEL_SHIFT;
> +		/* Reset */
> +		otg &= ~(EXYNOS_5250_USBOTGSYS_FORCE_SUSPEND |
> +			EXYNOS_5250_USBOTGSYS_FORCE_SLEEP |
> +			EXYNOS_5250_USBOTGSYS_SIDDQ_UOTG);
> +		otg |=	EXYNOS_5250_USBOTGSYS_PHY_SW_RST |
> +			EXYNOS_5250_USBOTGSYS_PHYLINK_SW_RESET |
> +			EXYNOS_5250_USBOTGSYS_LINK_SW_RST_UOTG |
> +			EXYNOS_5250_USBOTGSYS_OTGDISABLE;
> +		/* Ref clock */
> +		otg &=	~EXYNOS_5250_USBOTGSYS_REFCLKSEL_MASK;
> +		otg |=  EXYNOS_5250_REFCLKSEL_CLKCORE <<
> +					EXYNOS_5250_USBOTGSYS_REFCLKSEL_SHIFT;
> +		writel(otg, drv->reg_phy + EXYNOS_5250_USBOTGSYS);
> +		udelay(100);
> +		otg &= ~(EXYNOS_5250_USBOTGSYS_PHY_SW_RST |
> +			EXYNOS_5250_USBOTGSYS_LINK_SW_RST_UOTG |
> +			EXYNOS_5250_USBOTGSYS_PHYLINK_SW_RESET |
> +			EXYNOS_5250_USBOTGSYS_OTGDISABLE);
> +		writel(otg, drv->reg_phy + EXYNOS_5250_USBOTGSYS);
> +
> +
> +		break;
> +	case EXYNOS5250_HOST:
> +		/* Host registers configuration */
> +		ctrl0 = readl(drv->reg_phy + EXYNOS_5250_HOSTPHYCTRL0);
> +		/* The clock */
> +		ctrl0 &= ~EXYNOS_5250_HOSTPHYCTRL0_FSEL_MASK;
> +		ctrl0 |= inst->clk_reg_val <<
> +					EXYNOS_5250_HOSTPHYCTRL0_FSEL_SHIFT;
> +
> +		/* Reset */
> +		ctrl0 &=	~(EXYNOS_5250_HOSTPHYCTRL0_PHYSWRST |
> +				EXYNOS_5250_HOSTPHYCTRL0_PHYSWRSTALL |
> +				EXYNOS_5250_HOSTPHYCTRL0_SIDDQ |
> +				EXYNOS_5250_HOSTPHYCTRL0_FORCESUSPEND |
> +				EXYNOS_5250_HOSTPHYCTRL0_FORCESLEEP);
> +		ctrl0 |=	EXYNOS_5250_HOSTPHYCTRL0_LINKSWRST |
> +				EXYNOS_5250_HOSTPHYCTRL0_UTMISWRST |
> +				EXYNOS_5250_HOSTPHYCTRL0_COMMON_ON_N;
> +		writel(ctrl0, drv->reg_phy + EXYNOS_5250_HOSTPHYCTRL0);
> +		udelay(10);
> +		ctrl0 &=	~(EXYNOS_5250_HOSTPHYCTRL0_LINKSWRST |
> +				EXYNOS_5250_HOSTPHYCTRL0_UTMISWRST);
> +		writel(ctrl0, drv->reg_phy + EXYNOS_5250_HOSTPHYCTRL0);
> +
> +		/* OTG configuration */
> +		otg = readl(drv->reg_phy + EXYNOS_5250_USBOTGSYS);
> +		/* The clock */
> +		otg &= ~EXYNOS_5250_USBOTGSYS_FSEL_MASK;
> +		otg |= inst->clk_reg_val << EXYNOS_5250_USBOTGSYS_FSEL_SHIFT;
> +		/* Reset */
> +		otg &= ~(EXYNOS_5250_USBOTGSYS_FORCE_SUSPEND |
> +			EXYNOS_5250_USBOTGSYS_FORCE_SLEEP |
> +			EXYNOS_5250_USBOTGSYS_SIDDQ_UOTG);
> +		otg |=	EXYNOS_5250_USBOTGSYS_PHY_SW_RST |
> +			EXYNOS_5250_USBOTGSYS_PHYLINK_SW_RESET |
> +			EXYNOS_5250_USBOTGSYS_LINK_SW_RST_UOTG |
> +			EXYNOS_5250_USBOTGSYS_OTGDISABLE;
> +		/* Ref clock */
> +		otg &=	~EXYNOS_5250_USBOTGSYS_REFCLKSEL_MASK;
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
> +		/* Following code is based on the old driver */
> +		ohci |=	0x1 << 3;
> +		writel(ohci, drv->reg_phy + EXYNOS_5250_HOSTOHCICTRL);
> +
> +		break;
> +	}
> +}
> +
> +static int exynos5250_power_on(struct samsung_usb2_phy_instance *inst)
> +{
> +	inst->enabled = 1;
> +	exynos5250_phy_pwr(inst, 1);
> +	exynos5250_isol(inst, 0);
> +
> +	return 0;
> +}
> +
> +static int exynos5250_power_off(struct samsung_usb2_phy_instance *inst)
> +{
> +	inst->enabled = 0;
> +	exynos5250_isol(inst, 1);
> +	exynos5250_phy_pwr(inst, 0);
> +
> +	return 0;
> +}
> +
> +
> +static const struct samsung_usb2_common_phy exynos5250_phys[] = {
> +	{
> +		.label		= "device",
> +		.id		= EXYNOS5250_DEVICE,
> +		.rate_to_clk	= exynos5250_rate_to_clk,
> +		.power_on	= exynos5250_power_on,
> +		.power_off	= exynos5250_power_off,
> +	},
> +	{
> +		.label		= "host",
> +		.id		= EXYNOS5250_HOST,
> +		.rate_to_clk	= exynos5250_rate_to_clk,
> +		.power_on	= exynos5250_power_on,
> +		.power_off	= exynos5250_power_off,
> +	},
> +	{
> +		.label		= "hsic0",
> +		.id		= EXYNOS5250_HSIC0,
> +		.rate_to_clk	= exynos5250_rate_to_clk,
> +		.power_on	= exynos5250_power_on,
> +		.power_off	= exynos5250_power_off,
> +	},
> +	{
> +		.label		= "hsic1",
> +		.id		= EXYNOS5250_HSIC1,
> +		.rate_to_clk	= exynos5250_rate_to_clk,
> +		.power_on	= exynos5250_power_on,
> +		.power_off	= exynos5250_power_off,
> +	},
> +	{},
> +};
> +
> +const struct samsung_usb2_phy_config exynos5250_usb2_phy_config = {
> +	.num_phys		= EXYNOS5250_NUM_PHYS,
> +	.phys			= exynos5250_phys,
> +	.has_mode_switch	= 1,
> +};
> +
> diff --git a/drivers/phy/phy-samsung-usb2.c b/drivers/phy/phy-samsung-usb2.c
> index ef93fd3..d62e847 100644
> --- a/drivers/phy/phy-samsung-usb2.c
> +++ b/drivers/phy/phy-samsung-usb2.c
> @@ -116,6 +116,12 @@ static const struct of_device_id samsung_usb2_phy_of_match[] = {
>  		.data = &exynos4212_usb2_phy_config,
>  	},
>  #endif
> +#ifdef CONFIG_PHY_EXYNOS5250_USB2
> +	{
> +		.compatible = "samsung,exynos5250-usb2-phy",
> +		.data = &exynos5250_usb2_phy_config,
> +	},
> +#endif
>  	{ },
>  };
>  
> diff --git a/drivers/phy/phy-samsung-usb2.h b/drivers/phy/phy-samsung-usb2.h
> index 0f51dbb..0049e8a 100644
> --- a/drivers/phy/phy-samsung-usb2.h
> +++ b/drivers/phy/phy-samsung-usb2.h
> @@ -69,5 +69,6 @@ struct samsung_usb2_phy_config {
>  extern const struct samsung_usb2_phy_config s5pv210_usb2_phy_config;
>  extern const struct samsung_usb2_phy_config exynos4210_usb2_phy_config;
>  extern const struct samsung_usb2_phy_config exynos4212_usb2_phy_config;
> +extern const struct samsung_usb2_phy_config exynos5250_usb2_phy_config;
>  #endif
>  
> 

