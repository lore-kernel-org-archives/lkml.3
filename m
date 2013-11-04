Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618Ab3KDGz0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 01:55:26 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:54198 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752438Ab3KDGzV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 01:55:21 -0500
Message-ID: <527744B2.4090303@ti.com>
Date: Mon, 4 Nov 2013 12:24:42 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Vivek Gautam <gautam.vivek@samsung.com>
CC: <linux-usb@vger.kernel.org>, <linux-samsung-soc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-doc@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <kgene.kim@samsung.com>,
        <k.debski@samsung.com>, <s.nawrocki@samsung.com>, <t.figa@samsung.com>,
        <balbi@ti.com>, <jwerner@chromium.org>, <jg1.han@samsung.com>
Subject: Re: [PATCH RFC 1/4] phy: Add new Exynos5 USB 3.0 PHY driver
References: <1383205544-32244-1-git-send-email-gautam.vivek@samsung.com> <1383205544-32244-2-git-send-email-gautam.vivek@samsung.com>
In-Reply-To: <1383205544-32244-2-git-send-email-gautam.vivek@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,

On Thursday 31 October 2013 01:15 PM, Vivek Gautam wrote:
> Add a new driver for the USB 3.0 PHY on Exynos5 series of SoCs.
> The new driver uses the generic PHY framework and will interact
> with DWC3 controller present on Exynos5 series of SoCs.

In Exynos, you have a single IP that supports both USB3 and USB2 PHY 
right? I think that needs to be mentioned here.

Do you have separate registers that should be used for 
initializing/powerin_on/powering_off etc.. for usb2 phy and usb3 phy? If 
so, then you should model this driver as a single driver that supports 
two PHYs similar to what Sylwester has done before?

Cheers
Kishon

>
> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> ---
>   .../devicetree/bindings/phy/samsung-phy.txt        |   20 +
>   drivers/phy/Kconfig                                |    7 +
>   drivers/phy/Makefile                               |    1 +
>   drivers/phy/phy-exynos5-usb3.c                     |  562 ++++++++++++++++++++
>   4 files changed, 590 insertions(+), 0 deletions(-)
>   create mode 100644 drivers/phy/phy-exynos5-usb3.c
>
> diff --git a/Documentation/devicetree/bindings/phy/samsung-phy.txt b/Documentation/devicetree/bindings/phy/samsung-phy.txt
> index c0fccaa..9b5c111 100644
> --- a/Documentation/devicetree/bindings/phy/samsung-phy.txt
> +++ b/Documentation/devicetree/bindings/phy/samsung-phy.txt
> @@ -20,3 +20,23 @@ Required properties:
>   - compatible : should be "samsung,exynos5250-dp-video-phy";
>   - reg : offset and length of the Display Port PHY register set;
>   - #phy-cells : from the generic PHY bindings, must be 0;
> +
> +Samsung Exynos5 SoC seiries USB 3.0 PHY controller
> +--------------------------------------------------
> +
> +Required properties:
> +- compatible :
> +	should be "samsung,exynos5250-usb3phy" for exynos5250 SoC
> +	should be "samsung,exynos5420-usb3phy" for exynos5420 SoC
> +- reg : Register offset and length array
> +	- first field corresponds to USB 3.0 PHY register set;
> +	- second field corresponds to PHY power isolation register
> +	  present in PMU;
> +- clocks: Clock IDs array as required by the controller
> +- clock-names: names of clocks correseponding to IDs in the clock property;
> +	Required clocks:
> +	- first clock is main PHY clock (same as USB 3.0 controller IP clock)
> +	- second clock is reference clock (usually crystal clock)
> +	optional clock:
> +	- third clock is special clock used by PHY for operation
> +- #phy-cells : from the generic PHY bindings, must be 0;
> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
> index a344f3d..9a100c6 100644
> --- a/drivers/phy/Kconfig
> +++ b/drivers/phy/Kconfig
> @@ -51,4 +51,11 @@ config PHY_EXYNOS_DP_VIDEO
>   	help
>   	  Support for Display Port PHY found on Samsung EXYNOS SoCs.
>
> +config PHY_EXYNOS5_USB3
> +	tristate "Exynos5 SoC series USB 3.0 PHY driver"
> +	depends on ARCH_EXYNOS5
> +	select GENERIC_PHY
> +	help
> +	  Enable USB 3.0 PHY support for Exynos 5 SoC series
> +
>   endmenu
> diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
> index d0caae9..9c06a61 100644
> --- a/drivers/phy/Makefile
> +++ b/drivers/phy/Makefile
> @@ -7,3 +7,4 @@ obj-$(CONFIG_PHY_EXYNOS_DP_VIDEO)	+= phy-exynos-dp-video.o
>   obj-$(CONFIG_PHY_EXYNOS_MIPI_VIDEO)	+= phy-exynos-mipi-video.o
>   obj-$(CONFIG_OMAP_USB2)			+= phy-omap-usb2.o
>   obj-$(CONFIG_TWL4030_USB)		+= phy-twl4030-usb.o
> +obj-$(CONFIG_PHY_EXYNOS5_USB3)		+= phy-exynos5-usb3.o
> diff --git a/drivers/phy/phy-exynos5-usb3.c b/drivers/phy/phy-exynos5-usb3.c
> new file mode 100644
> index 0000000..b9a2674
> --- /dev/null
> +++ b/drivers/phy/phy-exynos5-usb3.c
> @@ -0,0 +1,562 @@
> +/*
> + * Samsung EXYNOS5 SoC series USB 3.0 PHY driver
> + *
> + * Copyright (C) 2013 Samsung Electronics Co., Ltd.
> + * Author: Vivek Gautam <gautam.vivek@samsung.com>
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
> +#include <linux/mutex.h>
> +
> +/* Exynos USB PHY registers */
> +#define EXYNOS5_FSEL_9MHZ6		0x0
> +#define EXYNOS5_FSEL_10MHZ		0x1
> +#define EXYNOS5_FSEL_12MHZ		0x2
> +#define EXYNOS5_FSEL_19MHZ2		0x3
> +#define EXYNOS5_FSEL_20MHZ		0x4
> +#define EXYNOS5_FSEL_24MHZ		0x5
> +#define EXYNOS5_FSEL_50MHZ		0x7
> +
> +/* EXYNOS5: USB 3.0 DRD PHY registers */
> +#define EXYNOS5_DRD_LINKSYSTEM			(0x04)
> +
> +#define LINKSYSTEM_FLADJ_MASK			(0x3f << 1)
> +#define LINKSYSTEM_FLADJ(_x)			((_x) << 1)
> +#define LINKSYSTEM_XHCI_VERSION_CONTROL		(0x1 << 27)
> +
> +#define EXYNOS5_DRD_PHYUTMI			(0x08)
> +
> +#define PHYUTMI_OTGDISABLE			(0x1 << 6)
> +#define PHYUTMI_FORCESUSPEND			(0x1 << 1)
> +#define PHYUTMI_FORCESLEEP			(0x1 << 0)
> +
> +#define EXYNOS5_DRD_PHYPIPE			(0x0c)
> +
> +#define EXYNOS5_DRD_PHYCLKRST			(0x10)
> +
> +#define PHYCLKRST_SSC_REFCLKSEL_MASK		(0xff << 23)
> +#define PHYCLKRST_SSC_REFCLKSEL(_x)		((_x) << 23)
> +
> +#define PHYCLKRST_SSC_RANGE_MASK		(0x03 << 21)
> +#define PHYCLKRST_SSC_RANGE(_x)			((_x) << 21)
> +
> +#define PHYCLKRST_SSC_EN			(0x1 << 20)
> +#define PHYCLKRST_REF_SSP_EN			(0x1 << 19)
> +#define PHYCLKRST_REF_CLKDIV2			(0x1 << 18)
> +
> +#define PHYCLKRST_MPLL_MULTIPLIER_MASK		(0x7f << 11)
> +#define PHYCLKRST_MPLL_MULTIPLIER_100MHZ_REF	(0x19 << 11)
> +#define PHYCLKRST_MPLL_MULTIPLIER_50M_REF	(0x02 << 11)
> +#define PHYCLKRST_MPLL_MULTIPLIER_24MHZ_REF	(0x68 << 11)
> +#define PHYCLKRST_MPLL_MULTIPLIER_20MHZ_REF	(0x7d << 11)
> +#define PHYCLKRST_MPLL_MULTIPLIER_19200KHZ_REF	(0x02 << 11)
> +
> +#define PHYCLKRST_FSEL_MASK			(0x3f << 5)
> +#define PHYCLKRST_FSEL(_x)			((_x) << 5)
> +#define PHYCLKRST_FSEL_PAD_100MHZ		(0x27 << 5)
> +#define PHYCLKRST_FSEL_PAD_24MHZ		(0x2a << 5)
> +#define PHYCLKRST_FSEL_PAD_20MHZ		(0x31 << 5)
> +#define PHYCLKRST_FSEL_PAD_19_2MHZ		(0x38 << 5)
> +
> +#define PHYCLKRST_RETENABLEN			(0x1 << 4)
> +
> +#define PHYCLKRST_REFCLKSEL_MASK		(0x03 << 2)
> +#define PHYCLKRST_REFCLKSEL_PAD_REFCLK		(0x2 << 2)
> +#define PHYCLKRST_REFCLKSEL_EXT_REFCLK		(0x3 << 2)
> +
> +#define PHYCLKRST_PORTRESET			(0x1 << 1)
> +#define PHYCLKRST_COMMONONN			(0x1 << 0)
> +
> +#define EXYNOS5_DRD_PHYREG0			(0x14)
> +#define EXYNOS5_DRD_PHYREG1			(0x18)
> +
> +#define EXYNOS5_DRD_PHYPARAM0			(0x1c)
> +
> +#define PHYPARAM0_REF_USE_PAD			(0x1 << 31)
> +#define PHYPARAM0_REF_LOSLEVEL_MASK		(0x1f << 26)
> +#define PHYPARAM0_REF_LOSLEVEL			(0x9 << 26)
> +
> +#define EXYNOS5_DRD_PHYPARAM1			(0x20)
> +
> +#define PHYPARAM1_PCS_TXDEEMPH_MASK		(0x1f << 0)
> +#define PHYPARAM1_PCS_TXDEEMPH			(0x1c)
> +
> +#define EXYNOS5_DRD_PHYTERM			(0x24)
> +
> +#define EXYNOS5_DRD_PHYTEST			(0x28)
> +
> +#define PHYTEST_POWERDOWN_SSP			(0x1 << 3)
> +#define PHYTEST_POWERDOWN_HSP			(0x1 << 2)
> +
> +#define EXYNOS5_DRD_PHYADP			(0x2c)
> +
> +#define EXYNOS5_DRD_PHYBATCHG			(0x30)
> +
> +#define PHYBATCHG_UTMI_CLKSEL			(0x1 << 2)
> +
> +#define EXYNOS5_DRD_PHYRESUME			(0x34)
> +#define EXYNOS5_DRD_LINKPORT			(0x44)
> +
> +
> +/* Isolation, configured in the power management unit */
> +#define EXYNOS5_USB_ISOL_DRD		(1 << 0)
> +
> +#define CLKSEL_ERROR                       -1
> +
> +#ifndef KHZ
> +#define KHZ 1000
> +#endif
> +
> +#ifndef MHZ
> +#define MHZ (KHZ * KHZ)
> +#endif
> +
> +enum samsung_cpu_type {
> +	TYPE_EXYNOS5250,
> +	TYPE_EXYNOS5420,
> +};
> +
> +enum usb3phy_state {
> +	STATE_OFF,
> +	STATE_ON,
> +};
> +
> +struct usb3phy_config {
> +	enum samsung_cpu_type cpu;
> +	bool has_sclk_usbphy30;
> +};
> +
> +struct usb3phy_instance {
> +	char *label;
> +	struct usb3phy_driver *drv;
> +	struct phy *phy;
> +	enum usb3phy_state state;
> +	u32 clk;
> +	unsigned long rate;
> +};
> +
> +struct usb3phy_driver {
> +	struct device *dev;
> +	void __iomem *reg_phy;
> +	void __iomem *reg_isol;
> +	struct clk *clk;
> +	struct clk *sclk_usbphy30;
> +	struct usb3phy_instance instance;
> +};
> +
> +/*
> + * exynos5_rate_to_clk() converts the supplied clock rate to the value that
> + * can be written to the phy register.
> + */
> +static u32 exynos5_rate_to_clk(unsigned long rate)
> +{
> +	unsigned int clksel;
> +
> +	/* EXYNOS5_FSEL_MASK */
> +
> +	switch (rate) {
> +	case 9600 * KHZ:
> +		clksel = EXYNOS5_FSEL_9MHZ6;
> +		break;
> +	case 10 * MHZ:
> +		clksel = EXYNOS5_FSEL_10MHZ;
> +		break;
> +	case 12 * MHZ:
> +		clksel = EXYNOS5_FSEL_12MHZ;
> +		break;
> +	case 19200 * KHZ:
> +		clksel = EXYNOS5_FSEL_19MHZ2;
> +		break;
> +	case 20 * MHZ:
> +		clksel = EXYNOS5_FSEL_20MHZ;
> +		break;
> +	case 24 * MHZ:
> +		clksel = EXYNOS5_FSEL_24MHZ;
> +		break;
> +	case 50 * MHZ:
> +		clksel = EXYNOS5_FSEL_50MHZ;
> +		break;
> +	default:
> +		clksel = CLKSEL_ERROR;
> +	}
> +
> +	return clksel;
> +}
> +
> +static void exynos5_usb3phy_isol(struct usb3phy_instance *inst, bool on)
> +{
> +	struct usb3phy_driver *drv = inst->drv;
> +	u32 tmp;
> +
> +	if (!drv->reg_isol)
> +		return;
> +
> +	tmp = readl(drv->reg_isol);
> +	if (on)
> +		tmp &= ~EXYNOS5_USB_ISOL_DRD;
> +	else
> +		tmp |= EXYNOS5_USB_ISOL_DRD;
> +	writel(tmp, drv->reg_isol);
> +}
> +
> +/*
> + * Sets the phy clk as EXTREFCLK (XXTI) which is internal clock from clock core.
> + */
> +static u32 exynos5_usb3phy_set_refclk(struct usb3phy_instance *inst)
> +{
> +	u32 reg;
> +	u32 refclk;
> +
> +	refclk = inst->clk;
> +
> +	reg = PHYCLKRST_REFCLKSEL_EXT_REFCLK |
> +		PHYCLKRST_FSEL(refclk);
> +
> +	switch (refclk) {
> +	case EXYNOS5_FSEL_50MHZ:
> +		reg |= (PHYCLKRST_MPLL_MULTIPLIER_50M_REF |
> +			PHYCLKRST_SSC_REFCLKSEL(0x00));
> +		break;
> +	case EXYNOS5_FSEL_20MHZ:
> +		reg |= (PHYCLKRST_MPLL_MULTIPLIER_20MHZ_REF |
> +			PHYCLKRST_SSC_REFCLKSEL(0x00));
> +		break;
> +	case EXYNOS5_FSEL_19MHZ2:
> +		reg |= (PHYCLKRST_MPLL_MULTIPLIER_19200KHZ_REF |
> +			PHYCLKRST_SSC_REFCLKSEL(0x88));
> +		break;
> +	case EXYNOS5_FSEL_24MHZ:
> +	default:
> +		reg |= (PHYCLKRST_MPLL_MULTIPLIER_24MHZ_REF |
> +			PHYCLKRST_SSC_REFCLKSEL(0x88));
> +		break;
> +	}
> +
> +	return reg;
> +}
> +
> +static void exynos5_usb3phy_init(struct usb3phy_instance *inst)
> +{
> +	struct usb3phy_driver *drv = inst->drv;
> +	u32 phyparam0;
> +	u32 phyparam1;
> +	u32 linksystem;
> +	u32 phybatchg;
> +	u32 phytest;
> +	u32 phyclkrst;
> +
> +	/* Reset USB 3.0 PHY */
> +	writel(0x0, drv->reg_phy + EXYNOS5_DRD_PHYREG0);
> +
> +	phyparam0 = readl(drv->reg_phy + EXYNOS5_DRD_PHYPARAM0);
> +	/* Select PHY CLK source */
> +	phyparam0 &= ~PHYPARAM0_REF_USE_PAD;
> +	/* Set Loss-of-Signal Detector sensitivity */
> +	phyparam0 &= ~PHYPARAM0_REF_LOSLEVEL_MASK;
> +	phyparam0 |= PHYPARAM0_REF_LOSLEVEL;
> +	writel(phyparam0, drv->reg_phy + EXYNOS5_DRD_PHYPARAM0);
> +
> +	writel(0x0, drv->reg_phy + EXYNOS5_DRD_PHYRESUME);
> +
> +	/*
> +	 * Setting the Frame length Adj value[6:1] to default 0x20
> +	 * See xHCI 1.0 spec, 5.2.4
> +	 */
> +	linksystem = LINKSYSTEM_XHCI_VERSION_CONTROL |
> +		     LINKSYSTEM_FLADJ(0x20);
> +	writel(linksystem, drv->reg_phy + EXYNOS5_DRD_LINKSYSTEM);
> +
> +	phyparam1 = readl(drv->reg_phy + EXYNOS5_DRD_PHYPARAM1);
> +	/* Set Tx De-Emphasis level */
> +	phyparam1 &= ~PHYPARAM1_PCS_TXDEEMPH_MASK;
> +	phyparam1 |= PHYPARAM1_PCS_TXDEEMPH;
> +	writel(phyparam1, drv->reg_phy + EXYNOS5_DRD_PHYPARAM1);
> +
> +	phybatchg = readl(drv->reg_phy + EXYNOS5_DRD_PHYBATCHG);
> +	phybatchg |= PHYBATCHG_UTMI_CLKSEL;
> +	writel(phybatchg, drv->reg_phy + EXYNOS5_DRD_PHYBATCHG);
> +
> +	/* PHYTEST POWERDOWN Control */
> +	phytest = readl(drv->reg_phy + EXYNOS5_DRD_PHYTEST);
> +	phytest &= ~(PHYTEST_POWERDOWN_SSP |
> +		     PHYTEST_POWERDOWN_HSP);
> +	writel(phytest, drv->reg_phy + EXYNOS5_DRD_PHYTEST);
> +
> +	/* UTMI Power Control */
> +	writel(PHYUTMI_OTGDISABLE, drv->reg_phy + EXYNOS5_DRD_PHYUTMI);
> +
> +	phyclkrst = exynos5_usb3phy_set_refclk(inst);
> +
> +	phyclkrst |= PHYCLKRST_PORTRESET |
> +		     /* Digital power supply in normal operating mode */
> +		     PHYCLKRST_RETENABLEN |
> +		     /* Enable ref clock for SS function */
> +		     PHYCLKRST_REF_SSP_EN |
> +		     /* Enable spread spectrum */
> +		     PHYCLKRST_SSC_EN |
> +		     /* Power down HS Bias and PLL blocks in suspend mode */
> +		     PHYCLKRST_COMMONONN;
> +
> +	writel(phyclkrst, drv->reg_phy + EXYNOS5_DRD_PHYCLKRST);
> +
> +	udelay(10);
> +
> +	phyclkrst &= ~PHYCLKRST_PORTRESET;
> +	writel(phyclkrst, drv->reg_phy + EXYNOS5_DRD_PHYCLKRST);
> +
> +}
> +
> +static void exynos5_usb3phy_exit(struct usb3phy_instance *inst)
> +{
> +	struct usb3phy_driver *drv = inst->drv;
> +	u32 phyutmi;
> +	u32 phyclkrst;
> +	u32 phytest;
> +
> +	phyutmi = PHYUTMI_OTGDISABLE |
> +		  PHYUTMI_FORCESUSPEND |
> +		  PHYUTMI_FORCESLEEP;
> +	writel(phyutmi, drv->reg_phy + EXYNOS5_DRD_PHYUTMI);
> +
> +	/* Resetting the PHYCLKRST enable bits to reduce leakage current */
> +	phyclkrst = readl(drv->reg_phy + EXYNOS5_DRD_PHYCLKRST);
> +	phyclkrst &= ~(PHYCLKRST_REF_SSP_EN |
> +		       PHYCLKRST_SSC_EN |
> +		       PHYCLKRST_COMMONONN);
> +	writel(phyclkrst, drv->reg_phy + EXYNOS5_DRD_PHYCLKRST);
> +
> +	/* Control PHYTEST to remove leakage current */
> +	phytest = readl(drv->reg_phy + EXYNOS5_DRD_PHYTEST);
> +	phytest |= PHYTEST_POWERDOWN_SSP |
> +		   PHYTEST_POWERDOWN_HSP;
> +	writel(phytest, drv->reg_phy + EXYNOS5_DRD_PHYTEST);
> +}
> +
> +static int exynos5_usb3phy_power_on(struct phy *phy)
> +{
> +	struct usb3phy_instance *inst = phy_get_drvdata(phy);
> +	struct usb3phy_driver *drv = inst->drv;
> +	int ret;
> +
> +	dev_info(drv->dev, "Request to power_on \"%s\" usb phy\n",
> +							inst->label);
> +
> +	if (drv->sclk_usbphy30)
> +		clk_prepare_enable(drv->sclk_usbphy30);
> +
> +	ret = clk_prepare_enable(drv->clk);
> +	if (ret)
> +		return ret;
> +
> +	if (inst->state == STATE_ON) {
> +		dev_err(drv->dev, "usb phy \"%s\" already on",
> +							inst->label);
> +		ret = -ENODEV;
> +		goto err0;
> +	}
> +
> +	inst->state = STATE_ON;
> +
> +	/* Initialize the PHY and power it ON */
> +	exynos5_usb3phy_init(inst);
> +	exynos5_usb3phy_isol(inst, 0);
> +
> +err0:
> +	clk_disable_unprepare(drv->clk);
> +
> +	return ret;
> +}
> +
> +static int exynos5_usb3phy_power_off(struct phy *phy)
> +{
> +	struct usb3phy_instance *inst = phy_get_drvdata(phy);
> +	struct usb3phy_driver *drv = inst->drv;
> +	int ret;
> +
> +	dev_info(drv->dev, "Request to power_off \"%s\" usb phy\n",
> +							inst->label);
> +	ret = clk_prepare_enable(drv->clk);
> +	if (ret)
> +		return ret;
> +
> +	if (inst->state == STATE_OFF) {
> +		dev_err(drv->dev, "usb phy \"%s\" already off",
> +							inst->label);
> +		ret = -ENODEV;
> +		goto err0;
> +	}
> +
> +	inst->state = STATE_OFF;
> +
> +	/* Power-off the PHY and de-initialize it */
> +	exynos5_usb3phy_isol(inst, 1);
> +	exynos5_usb3phy_exit(inst);
> +
> +err0:
> +	clk_disable_unprepare(drv->clk);
> +	if (drv->sclk_usbphy30)
> +		clk_disable_unprepare(drv->sclk_usbphy30);
> +
> +	return ret;
> +}
> +
> +static struct phy_ops exynos5_usb3phy_ops = {
> +	.power_on	= exynos5_usb3phy_power_on,
> +	.power_off	= exynos5_usb3phy_power_off,
> +	.owner		= THIS_MODULE,
> +};
> +
> +static const struct of_device_id exynos5_usb3phy_of_match[];
> +
> +static int exynos5_usb3phy_probe(struct platform_device *pdev)
> +{
> +	struct device *dev = &pdev->dev;
> +	struct usb3phy_driver *drv;
> +	struct usb3phy_instance *inst;
> +	struct phy_provider *phy_provider;
> +	struct resource *res;
> +	struct clk *clk;
> +	const struct of_device_id *match;
> +	const struct usb3phy_config *cfg;
> +
> +	match = of_match_node(exynos5_usb3phy_of_match, pdev->dev.of_node);
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
> +	drv = devm_kzalloc(dev, sizeof(struct usb3phy_driver), GFP_KERNEL);
> +	if (!drv) {
> +		dev_err(dev, "Failed to allocate memory\n");
> +		return -ENOMEM;
> +	}
> +
> +	dev_set_drvdata(dev, drv);
> +	drv->dev = dev;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	drv->reg_phy = devm_ioremap_resource(dev, res);
> +	if (IS_ERR(drv->reg_phy)) {
> +		dev_err(dev, "Failed to map register memory (phy)\n");
> +		return PTR_ERR(drv->reg_phy);
> +	}
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 1);
> +	drv->reg_isol = devm_ioremap_resource(dev, res);
> +	if (IS_ERR(drv->reg_isol)) {
> +		dev_err(dev, "Failed to map register memory (isolation)\n");
> +		return PTR_ERR(drv->reg_isol);
> +	}
> +
> +	phy_provider = devm_of_phy_provider_register(dev, of_phy_simple_xlate);
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
> +	/*
> +	 * Exysno5420 SoC has an additional special clock, used for
> +	 * for USB 3.0 PHY operation, this clock goes to the PHY block
> +	 * as a reference clock to clock generation block of the controller.
> +	 */
> +	if (cfg->has_sclk_usbphy30) {
> +		drv->sclk_usbphy30 = devm_clk_get(dev, "sclk_usbphy30");
> +		if (IS_ERR(drv->clk)) {
> +			dev_err(dev, "Failed to get phy reference clock\n");
> +			return PTR_ERR(drv->clk);
> +		}
> +	}
> +
> +	inst		= &drv->instance;
> +	inst->drv	= drv;
> +	inst->label	= "usb3drd";
> +
> +	dev_info(dev, "Creating phy \"%s\"\n", inst->label);
> +	inst->phy = devm_phy_create(dev, &exynos5_usb3phy_ops, NULL);
> +	if (IS_ERR(inst->phy)) {
> +		dev_err(drv->dev, "Failed to create usb3phy \"%s\"\n",
> +					inst->label);
> +		return PTR_ERR(inst->phy);
> +	}
> +
> +	phy_set_drvdata(inst->phy, inst);
> +
> +	clk = clk_get(dev, inst->label);
> +	if (IS_ERR(clk)) {
> +		dev_err(dev, "Failed to get clock of \"%s\" phy\n",
> +							inst->label);
> +		return PTR_ERR(clk);
> +	}
> +
> +	inst->rate = clk_get_rate(clk);
> +
> +	inst->clk = exynos5_rate_to_clk(inst->rate);
> +	if (inst->clk == CLKSEL_ERROR) {
> +		dev_err(dev, "Clock rate (%ld) not supported\n",
> +						inst->rate);
> +		clk_put(clk);
> +		return -EINVAL;
> +	}
> +	clk_put(clk);
> +
> +	return 0;
> +}
> +
> +const struct usb3phy_config exynos5420_usb3phy_cfg = {
> +	.cpu		   = TYPE_EXYNOS5420,
> +	.has_sclk_usbphy30 = true,
> +};
> +
> +const struct usb3phy_config exynos5250_usb3phy_cfg = {
> +	.cpu		   = TYPE_EXYNOS5250,
> +	.has_sclk_usbphy30 = false,
> +};
> +
> +static const struct of_device_id exynos5_usb3phy_of_match[] = {
> +	{
> +		.compatible = "samsung,exynos5250-usb3phy",
> +		.data = &exynos5250_usb3phy_cfg
> +	}, {
> +		.compatible = "samsung,exynos5420-usb3phy",
> +		.data = &exynos5420_usb3phy_cfg
> +	},
> +	{ },
> +};
> +
> +static struct platform_driver exynos5_usb3phy_driver = {
> +	.probe	= exynos5_usb3phy_probe,
> +	.driver = {
> +		.of_match_table	= exynos5_usb3phy_of_match,
> +		.name		= "exynos5-usb3phy",
> +		.owner		= THIS_MODULE,
> +	}
> +};
> +
> +module_platform_driver(exynos5_usb3phy_driver);
> +MODULE_DESCRIPTION("Samsung EXYNOS5 series SoC USB 3.0 PHY driver");
> +MODULE_AUTHOR("Vivek Gautam <gautam.vivek@samsung.com>");
> +MODULE_LICENSE("GPL v2");
> +MODULE_ALIAS("platform:exynos5-usb3phy");
>

