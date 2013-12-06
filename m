Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757348Ab3LFOiU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 09:38:20 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:59365 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756819Ab3LFOiR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 09:38:17 -0500
Message-ID: <52A1E0A7.80901@ti.com>
Date: Fri, 6 Dec 2013 16:35:19 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>, <bcousson@baylibre.com>,
        <balbi@ti.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>
CC: <rob.herring@calxeda.com>, <pawel.moll@arm.com>, <mark.rutland@arm.com>,
        <swarren@wwwdotorg.org>, <ijc+devicetree@hellion.org.uk>,
        <rob@landley.net>, <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <gregkh@linuxfoundation.org>, <grant.likely@linaro.org>,
        <s.nawrocki@samsung.com>, <galak@codeaurora.org>
Subject: Re: [PATCH v3 07/10] drivers: phy: usb3/pipe3: Adapt pipe3 driver
 to Generic PHY Framework
References: <1385373690-12170-1-git-send-email-kishon@ti.com> <1385373690-12170-8-git-send-email-kishon@ti.com>
In-Reply-To: <1385373690-12170-8-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kishon,

On 11/25/2013 12:01 PM, Kishon Vijay Abraham I wrote:
> Adapted omap-usb3 PHY driver to Generic PHY Framework and moved phy-omap-usb3
> driver in drivers/usb/phy to drivers/phy and also renamed the file to
> phy-ti-pipe3 since this same driver will be used for SATA PHY and
> PCIE PHY.
> 
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  drivers/phy/Kconfig                                |   11 +
>  drivers/phy/Makefile                               |    1 +
>  .../phy/phy-omap-usb3.c => phy/phy-ti-pipe3.c}     |  232 ++++++++++++--------
>  drivers/usb/phy/Kconfig                            |   11 -
>  drivers/usb/phy/Makefile                           |    1 -
>  5 files changed, 149 insertions(+), 107 deletions(-)
>  rename drivers/{usb/phy/phy-omap-usb3.c => phy/phy-ti-pipe3.c} (55%)
> 
> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
> index a344f3d..1abbfcc 100644
> --- a/drivers/phy/Kconfig
> +++ b/drivers/phy/Kconfig
> @@ -33,6 +33,17 @@ config OMAP_USB2
>  	  The USB OTG controller communicates with the comparator using this
>  	  driver.
>  
> +config TI_PIPE3
> +	tristate "TI PIPE3 PHY Driver"
> +	depends on ARCH_OMAP2PLUS || COMPILE_TEST
> +	select GENERIC_PHY
> +	select OMAP_CONTROL_USB
> +	help
> +	  Enable this to support the PIPE3 PHY that is part of TI SOCs. This
> +	  driver takes care of all the PHY functionality apart from comparator.
> +	  This driver interacts with the "OMAP Control PHY Driver" to power
> +	  on/off the PHY.
> +
>  config TWL4030_USB
>  	tristate "TWL4030 USB Transceiver Driver"
>  	depends on TWL4030_CORE && REGULATOR_TWL4030 && USB_MUSB_OMAP2PLUS
> diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
> index d0caae9..94a1a79 100644
> --- a/drivers/phy/Makefile
> +++ b/drivers/phy/Makefile
> @@ -6,4 +6,5 @@ obj-$(CONFIG_GENERIC_PHY)		+= phy-core.o
>  obj-$(CONFIG_PHY_EXYNOS_DP_VIDEO)	+= phy-exynos-dp-video.o
>  obj-$(CONFIG_PHY_EXYNOS_MIPI_VIDEO)	+= phy-exynos-mipi-video.o
>  obj-$(CONFIG_OMAP_USB2)			+= phy-omap-usb2.o
> +obj-$(CONFIG_TI_PIPE3)			+= phy-ti-pipe3.o
>  obj-$(CONFIG_TWL4030_USB)		+= phy-twl4030-usb.o
> diff --git a/drivers/usb/phy/phy-omap-usb3.c b/drivers/phy/phy-ti-pipe3.c
> similarity index 55%
> rename from drivers/usb/phy/phy-omap-usb3.c
> rename to drivers/phy/phy-ti-pipe3.c
> index 0c6ba29..410b286 100644
> --- a/drivers/usb/phy/phy-omap-usb3.c
> +++ b/drivers/phy/phy-ti-pipe3.c
> @@ -1,5 +1,5 @@
>  /*
> - * omap-usb3 - USB PHY, talking to dwc3 controller in OMAP.
> + * phy-ti-pipe3 - PIPE3 PHY driver.
>   *
>   * Copyright (C) 2013 Texas Instruments Incorporated - http://www.ti.com
>   * This program is free software; you can redistribute it and/or modify
> @@ -19,10 +19,11 @@
>  #include <linux/module.h>
>  #include <linux/platform_device.h>
>  #include <linux/slab.h>
> -#include <linux/usb/omap_usb.h>
> +#include <linux/phy/phy.h>
>  #include <linux/of.h>
>  #include <linux/clk.h>
>  #include <linux/err.h>
> +#include <linux/io.h>
>  #include <linux/pm_runtime.h>
>  #include <linux/delay.h>
>  #include <linux/usb/omap_control_usb.h>
> @@ -52,17 +53,34 @@
>  
>  /*
>   * This is an Empirical value that works, need to confirm the actual
> - * value required for the USB3PHY_PLL_CONFIGURATION2.PLL_IDLE status
> - * to be correctly reflected in the USB3PHY_PLL_STATUS register.
> + * value required for the PIPE3PHY_PLL_CONFIGURATION2.PLL_IDLE status
> + * to be correctly reflected in the PIPE3PHY_PLL_STATUS register.
>   */
>  # define PLL_IDLE_TIME  100;
>  
> -struct usb_dpll_map {
> +struct pipe3_dpll_params {
> +	u16	m;
> +	u8	n;
> +	u8	freq:3;
> +	u8	sd;
> +	u32	mf;
> +};
> +
> +struct ti_pipe3 {
> +	void __iomem		*pll_ctrl_base;
> +	struct device		*dev;
> +	struct device		*control_dev;
> +	struct clk		*wkupclk;
> +	struct clk		*sys_clk;
> +	struct clk		*optclk;
> +};
> +
> +struct pipe3_dpll_map {
>  	unsigned long rate;
> -	struct usb_dpll_params params;
> +	struct pipe3_dpll_params params;
>  };
>  
> -static struct usb_dpll_map dpll_map[] = {
> +static struct pipe3_dpll_map dpll_map[] = {
>  	{12000000, {1250, 5, 4, 20, 0} },	/* 12 MHz */
>  	{16800000, {3125, 20, 4, 20, 0} },	/* 16.8 MHz */
>  	{19200000, {1172, 8, 4, 20, 65537} },	/* 19.2 MHz */
> @@ -71,7 +89,18 @@ static struct usb_dpll_map dpll_map[] = {
>  	{38400000, {3125, 47, 4, 20, 92843} },	/* 38.4 MHz */
>  };
>  
> -static struct usb_dpll_params *omap_usb3_get_dpll_params(unsigned long rate)
> +static inline u32 ti_pipe3_readl(void __iomem *addr, unsigned offset)
> +{
> +	return __raw_readl(addr + offset);
> +}
> +
> +static inline void ti_pipe3_writel(void __iomem *addr, unsigned offset,
> +	u32 data)
> +{
> +	__raw_writel(data, addr + offset);
> +}
> +
> +static struct pipe3_dpll_params *ti_pipe3_get_dpll_params(unsigned long rate)
>  {
>  	int i;
>  
> @@ -83,110 +112,113 @@ static struct usb_dpll_params *omap_usb3_get_dpll_params(unsigned long rate)
>  	return NULL;
>  }
>  
> -static int omap_usb3_suspend(struct usb_phy *x, int suspend)
> +static int ti_pipe3_power_off(struct phy *x)
>  {
> -	struct omap_usb *phy = phy_to_omapusb(x);
> -	int	val;
> +	struct ti_pipe3 *phy = phy_get_drvdata(x);
> +	int val;
>  	int timeout = PLL_IDLE_TIME;
>  
> -	if (suspend && !phy->is_suspended) {
> -		val = omap_usb_readl(phy->pll_ctrl_base, PLL_CONFIGURATION2);
> -		val |= PLL_IDLE;
> -		omap_usb_writel(phy->pll_ctrl_base, PLL_CONFIGURATION2, val);
> -
> -		do {
> -			val = omap_usb_readl(phy->pll_ctrl_base, PLL_STATUS);
> -			if (val & PLL_TICOPWDN)
> -				break;
> -			udelay(1);
> -		} while (--timeout);
> -
> -		omap_control_usb_phy_power(phy->control_dev, 0);
> -
> -		phy->is_suspended	= 1;
> -	} else if (!suspend && phy->is_suspended) {
> -		phy->is_suspended	= 0;
> -
> -		val = omap_usb_readl(phy->pll_ctrl_base, PLL_CONFIGURATION2);
> -		val &= ~PLL_IDLE;
> -		omap_usb_writel(phy->pll_ctrl_base, PLL_CONFIGURATION2, val);
> -
> -		do {
> -			val = omap_usb_readl(phy->pll_ctrl_base, PLL_STATUS);
> -			if (!(val & PLL_TICOPWDN))
> -				break;
> -			udelay(1);
> -		} while (--timeout);
> -	}
> +	val = ti_pipe3_readl(phy->pll_ctrl_base, PLL_CONFIGURATION2);
> +	val |= PLL_IDLE;
> +	ti_pipe3_writel(phy->pll_ctrl_base, PLL_CONFIGURATION2, val);
> +
> +	do {
> +		val = ti_pipe3_readl(phy->pll_ctrl_base, PLL_STATUS);
> +		if (val & PLL_TICOPWDN)
> +			break;
> +		usleep_range(1, 5);

I had suggested to use sleep instead of udelay here but usleep for < 10 us might not be not optimal.
see Documentation/timers/timers-howto.txt

Why can't we just use msleep(1)?

Do we know approximately how much time it takes for the block to power down?

> +	} while (--timeout);
> +

what if there was a timeout? you need to exit with return code and preferably print an error message.

> +	omap_control_usb_phy_power(phy->control_dev, 0);
> +
> +	return 0;
> +}
> +
> +static int ti_pipe3_power_on(struct phy *x)
> +{
> +	struct ti_pipe3 *phy = phy_get_drvdata(x);
> +	int val;
> +	int timeout = PLL_IDLE_TIME;
> +
> +	val = ti_pipe3_readl(phy->pll_ctrl_base, PLL_CONFIGURATION2);
> +	val &= ~PLL_IDLE;
> +	ti_pipe3_writel(phy->pll_ctrl_base, PLL_CONFIGURATION2, val);
> +
> +	do {
> +		val = ti_pipe3_readl(phy->pll_ctrl_base, PLL_STATUS);
> +		if (!(val & PLL_TICOPWDN))
> +			break;
> +		usleep_range(1, 5);
> +	} while (--timeout);

here as well.
>  
>  	return 0;
>  }
>  
> -static void omap_usb_dpll_relock(struct omap_usb *phy)
> +static void ti_pipe3_dpll_relock(struct ti_pipe3 *phy)
>  {
>  	u32		val;
>  	unsigned long	timeout;
>  
> -	omap_usb_writel(phy->pll_ctrl_base, PLL_GO, SET_PLL_GO);
> +	ti_pipe3_writel(phy->pll_ctrl_base, PLL_GO, SET_PLL_GO);
>  
>  	timeout = jiffies + msecs_to_jiffies(20);
>  	do {
> -		val = omap_usb_readl(phy->pll_ctrl_base, PLL_STATUS);
> +		val = ti_pipe3_readl(phy->pll_ctrl_base, PLL_STATUS);
>  		if (val & PLL_LOCK)
>  			break;
>  	} while (!WARN_ON(time_after(jiffies, timeout)));
>  }

cheers,
-roger

