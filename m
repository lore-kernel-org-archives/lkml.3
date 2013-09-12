Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042Ab3ILLU7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 07:20:59 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:36607 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751533Ab3ILLU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 07:20:57 -0400
Message-ID: <5231A35D.7060006@ti.com>
Date: Thu, 12 Sep 2013 14:19:57 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>
CC: <balbi@ti.com>, <bcousson@baylibre.com>, <tony@atomide.com>,
        <rob.herring@calxeda.com>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <linux@arm.linux.org.uk>,
        <grant.likely@linaro.org>, <s.nawrocki@samsung.com>,
        <galak@codeaurora.org>, <swarren@wwwdotorg.org>,
        <ian.campbell@citrix.com>, <rob@landley.net>, <george.cherian@ti.com>,
        <gregkh@linuxfoundation.org>, <linux-doc@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/7] drivers: phy: usb3/pipe3: Adapt pipe3 driver to Generic
 PHY Framework
References: <1378136591-7463-1-git-send-email-kishon@ti.com> <1378136591-7463-4-git-send-email-kishon@ti.com>
In-Reply-To: <1378136591-7463-4-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kishon,

On 09/02/2013 06:43 PM, Kishon Vijay Abraham I wrote:
> Adapted omap-usb3 PHY driver to Generic PHY Framework and moved phy-omap-usb3
> driver in drivers/usb/phy to drivers/phy and also renamed the file to
> phy-omap-pipe3 since this same driver will be used for SATA PHY and
> PCIE PHY.

I would suggest to split the renaming and PHY adaptation into 2 separate patches.

> 
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> ---
>  Documentation/devicetree/bindings/usb/usb-phy.txt  |    5 +-
>  drivers/phy/Kconfig                                |   10 +
>  drivers/phy/Makefile                               |    1 +
>  .../phy/phy-omap-usb3.c => phy/phy-omap-pipe3.c}   |  206 +++++++++++---------

how about naming it to phy-ti-pipe3.c as it is used on OMAP as well as non-OMAP e.g. DRA7.

>  drivers/usb/phy/Kconfig                            |   11 --
>  drivers/usb/phy/Makefile                           |    1 -
>  include/linux/phy/omap_pipe3.h                     |   52 +++++
>  7 files changed, 177 insertions(+), 109 deletions(-)
>  rename drivers/{usb/phy/phy-omap-usb3.c => phy/phy-omap-pipe3.c} (57%)
>  create mode 100644 include/linux/phy/omap_pipe3.h
> 
> diff --git a/Documentation/devicetree/bindings/usb/usb-phy.txt b/Documentation/devicetree/bindings/usb/usb-phy.txt
> index c0245c8..36bdb17 100644
> --- a/Documentation/devicetree/bindings/usb/usb-phy.txt
> +++ b/Documentation/devicetree/bindings/usb/usb-phy.txt
> @@ -21,10 +21,11 @@ usb2phy@4a0ad080 {
>  	#phy-cells = <0>;
>  };
>  
> -OMAP USB3 PHY
> +OMAP PIPE3 PHY
>  
>  Required properties:
> - - compatible: Should be "ti,omap-usb3"
> + - compatible: Should be "ti,omap-usb3", "ti,omap-pipe3", "ti,omap-sata"
> +   or "ti,omap-pcie"
>   - reg : Address and length of the register set for the device.
>   - reg-names: The names of the register addresses corresponding to the registers
>     filled in "reg".
> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
> index ac239ac..5c2e7a0 100644
> --- a/drivers/phy/Kconfig
> +++ b/drivers/phy/Kconfig
> @@ -27,6 +27,16 @@ config OMAP_USB2
>  	  The USB OTG controller communicates with the comparator using this
>  	  driver.
>  
> +config OMAP_PIPE3
> +	tristate "OMAP PIPE3 PHY Driver"
> +	select GENERIC_PHY
> +	select OMAP_CONTROL_USB
how about
	depends on OMAP_CONTROL_USB

Also, if this is TI/OMAP it might as well depend on ARCH_OMAP.

> +	help
> +	  Enable this to support the PIPE3 PHY that is part of SOC. This

worth mentioning TI OMAP/DRA SoCs.

> +	  driver takes care of all the PHY functionality apart from comparator.
> +	  This driver interacts with the "OMAP Control PHY Driver" to power
> +	  on/off the PHY.
> +
>  config TWL4030_USB
>  	tristate "TWL4030 USB Transceiver Driver"
>  	depends on TWL4030_CORE && REGULATOR_TWL4030 && USB_MUSB_OMAP2PLUS
> diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
> index 0dd8a98..48bf9f2 100644
> --- a/drivers/phy/Makefile
> +++ b/drivers/phy/Makefile
> @@ -4,4 +4,5 @@
>  
>  obj-$(CONFIG_GENERIC_PHY)	+= phy-core.o
>  obj-$(CONFIG_OMAP_USB2)		+= phy-omap-usb2.o
> +obj-$(CONFIG_OMAP_PIPE3)	+= phy-omap-pipe3.o
>  obj-$(CONFIG_TWL4030_USB)	+= phy-twl4030-usb.o
> diff --git a/drivers/usb/phy/phy-omap-usb3.c b/drivers/phy/phy-omap-pipe3.c
> similarity index 57%
> rename from drivers/usb/phy/phy-omap-usb3.c
> rename to drivers/phy/phy-omap-pipe3.c
> index 4004f82..ee9a901 100644
> --- a/drivers/usb/phy/phy-omap-usb3.c
> +++ b/drivers/phy/phy-omap-pipe3.c
> @@ -1,5 +1,5 @@
>  /*
> - * omap-usb3 - USB PHY, talking to dwc3 controller in OMAP.
> + * omap-pipe3 - PHY driver for SATA, USB and PCIE in OMAP platforms
>   *
>   * Copyright (C) 2013 Texas Instruments Incorporated - http://www.ti.com
>   * This program is free software; you can redistribute it and/or modify
> @@ -19,7 +19,8 @@
>  #include <linux/module.h>
>  #include <linux/platform_device.h>
>  #include <linux/slab.h>
> -#include <linux/usb/omap_usb.h>
> +#include <linux/phy/omap_pipe3.h>
> +#include <linux/phy/phy.h>
>  #include <linux/of.h>
>  #include <linux/clk.h>
>  #include <linux/err.h>
> @@ -52,17 +53,17 @@
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
> @@ -71,7 +72,7 @@ static struct usb_dpll_map dpll_map[] = {
>  	{38400000, {3125, 47, 4, 20, 92843} },	/* 38.4 MHz */
>  };
>  
> -static struct usb_dpll_params *omap_usb3_get_dpll_params(unsigned long rate)
> +static struct pipe3_dpll_params *omap_pipe3_get_dpll_params(unsigned long rate)
>  {
>  	int i;
>  
> @@ -83,110 +84,113 @@ static struct usb_dpll_params *omap_usb3_get_dpll_params(unsigned long rate)
>  	return 0;
>  }
>  
> -static int omap_usb3_suspend(struct usb_phy *x, int suspend)
> +static int omap_pipe3_power_off(struct phy *x)
>  {
> -	struct omap_usb *phy = phy_to_omapusb(x);
> -	int	val;
> +	struct omap_pipe3 *phy = phy_get_drvdata(x);
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
> +	val = omap_pipe3_readl(phy->pll_ctrl_base, PLL_CONFIGURATION2);
> +	val |= PLL_IDLE;
> +	omap_pipe3_writel(phy->pll_ctrl_base, PLL_CONFIGURATION2, val);
> +
> +	do {
> +		val = omap_pipe3_readl(phy->pll_ctrl_base, PLL_STATUS);
> +		if (val & PLL_TICOPWDN)
> +			break;
> +		udelay(1);

Is it better to sleep instead of udelay?

> +	} while (--timeout);
> +
> +	omap_control_usb_phy_power(phy->control_dev, 0);
> +
> +	return 0;
> +}
> +
> +static int omap_pipe3_power_on(struct phy *x)
> +{
> +	struct omap_pipe3 *phy = phy_get_drvdata(x);
> +	int val;
> +	int timeout = PLL_IDLE_TIME;
> +
> +	val = omap_pipe3_readl(phy->pll_ctrl_base, PLL_CONFIGURATION2);
> +	val &= ~PLL_IDLE;
> +	omap_pipe3_writel(phy->pll_ctrl_base, PLL_CONFIGURATION2, val);
> +
> +	do {
> +		val = omap_pipe3_readl(phy->pll_ctrl_base, PLL_STATUS);
> +		if (!(val & PLL_TICOPWDN))
> +			break;
> +		udelay(1);

here too.

> +	} while (--timeout);
>  
>  	return 0;
>  }
>  
> -static void omap_usb_dpll_relock(struct omap_usb *phy)
> +static void omap_pipe3_dpll_relock(struct omap_pipe3 *phy)
>  {
>  	u32		val;
>  	unsigned long	timeout;
>  
> -	omap_usb_writel(phy->pll_ctrl_base, PLL_GO, SET_PLL_GO);
> +	omap_pipe3_writel(phy->pll_ctrl_base, PLL_GO, SET_PLL_GO);
>  
>  	timeout = jiffies + msecs_to_jiffies(20);
>  	do {
> -		val = omap_usb_readl(phy->pll_ctrl_base, PLL_STATUS);
> +		val = omap_pipe3_readl(phy->pll_ctrl_base, PLL_STATUS);
>  		if (val & PLL_LOCK)
>  			break;
>  	} while (!WARN_ON(time_after(jiffies, timeout)));
>  }
>  
> -static int omap_usb_dpll_lock(struct omap_usb *phy)
> +static int omap_pipe3_dpll_lock(struct omap_pipe3 *phy)
>  {
>  	u32			val;
>  	unsigned long		rate;
> -	struct usb_dpll_params *dpll_params;
> +	struct pipe3_dpll_params *dpll_params;
>  
>  	rate = clk_get_rate(phy->sys_clk);
> -	dpll_params = omap_usb3_get_dpll_params(rate);
> +	dpll_params = omap_pipe3_get_dpll_params(rate);
>  	if (!dpll_params) {
>  		dev_err(phy->dev,
>  			  "No DPLL configuration for %lu Hz SYS CLK\n", rate);
>  		return -EINVAL;
>  	}
>  
> -	val = omap_usb_readl(phy->pll_ctrl_base, PLL_CONFIGURATION1);
> +	val = omap_pipe3_readl(phy->pll_ctrl_base, PLL_CONFIGURATION1);
>  	val &= ~PLL_REGN_MASK;
>  	val |= dpll_params->n << PLL_REGN_SHIFT;
> -	omap_usb_writel(phy->pll_ctrl_base, PLL_CONFIGURATION1, val);
> +	omap_pipe3_writel(phy->pll_ctrl_base, PLL_CONFIGURATION1, val);
>  
> -	val = omap_usb_readl(phy->pll_ctrl_base, PLL_CONFIGURATION2);
> +	val = omap_pipe3_readl(phy->pll_ctrl_base, PLL_CONFIGURATION2);
>  	val &= ~PLL_SELFREQDCO_MASK;
>  	val |= dpll_params->freq << PLL_SELFREQDCO_SHIFT;
> -	omap_usb_writel(phy->pll_ctrl_base, PLL_CONFIGURATION2, val);
> +	omap_pipe3_writel(phy->pll_ctrl_base, PLL_CONFIGURATION2, val);
>  
> -	val = omap_usb_readl(phy->pll_ctrl_base, PLL_CONFIGURATION1);
> +	val = omap_pipe3_readl(phy->pll_ctrl_base, PLL_CONFIGURATION1);
>  	val &= ~PLL_REGM_MASK;
>  	val |= dpll_params->m << PLL_REGM_SHIFT;
> -	omap_usb_writel(phy->pll_ctrl_base, PLL_CONFIGURATION1, val);
> +	omap_pipe3_writel(phy->pll_ctrl_base, PLL_CONFIGURATION1, val);
>  
> -	val = omap_usb_readl(phy->pll_ctrl_base, PLL_CONFIGURATION4);
> +	val = omap_pipe3_readl(phy->pll_ctrl_base, PLL_CONFIGURATION4);
>  	val &= ~PLL_REGM_F_MASK;
>  	val |= dpll_params->mf << PLL_REGM_F_SHIFT;
> -	omap_usb_writel(phy->pll_ctrl_base, PLL_CONFIGURATION4, val);
> +	omap_pipe3_writel(phy->pll_ctrl_base, PLL_CONFIGURATION4, val);
>  
> -	val = omap_usb_readl(phy->pll_ctrl_base, PLL_CONFIGURATION3);
> +	val = omap_pipe3_readl(phy->pll_ctrl_base, PLL_CONFIGURATION3);
>  	val &= ~PLL_SD_MASK;
>  	val |= dpll_params->sd << PLL_SD_SHIFT;
> -	omap_usb_writel(phy->pll_ctrl_base, PLL_CONFIGURATION3, val);
> +	omap_pipe3_writel(phy->pll_ctrl_base, PLL_CONFIGURATION3, val);
>  
> -	omap_usb_dpll_relock(phy);
> +	omap_pipe3_dpll_relock(phy);
>  
>  	return 0;
>  }
>  
> -static int omap_usb3_init(struct usb_phy *x)
> +static int omap_pipe3_init(struct phy *x)
>  {
> -	struct omap_usb	*phy = phy_to_omapusb(x);
> +	struct omap_pipe3 *phy = phy_get_drvdata(x);
>  	int ret;
>  
> -	ret = omap_usb_dpll_lock(phy);
> +	ret = omap_pipe3_dpll_lock(phy);
>  	if (ret)
>  		return ret;
>  
> @@ -195,9 +199,18 @@ static int omap_usb3_init(struct usb_phy *x)
>  	return 0;
>  }
>  
> -static int omap_usb3_probe(struct platform_device *pdev)
> +static struct phy_ops ops = {
> +	.init		= omap_pipe3_init,
> +	.power_on	= omap_pipe3_power_on,
> +	.power_off	= omap_pipe3_power_off,
> +	.owner		= THIS_MODULE,
> +};
> +
> +static int omap_pipe3_probe(struct platform_device *pdev)
>  {
> -	struct omap_usb *phy;
> +	struct omap_pipe3 *phy;
> +	struct phy *generic_phy;
> +	struct phy_provider *phy_provider;
>  	struct resource *res;
>  	struct device_node *node = pdev->dev.of_node;
>  	struct device_node *control_node;
> @@ -208,7 +221,7 @@ static int omap_usb3_probe(struct platform_device *pdev)
>  
>  	phy = devm_kzalloc(&pdev->dev, sizeof(*phy), GFP_KERNEL);
>  	if (!phy) {
> -		dev_err(&pdev->dev, "unable to alloc mem for OMAP USB3 PHY\n");
> +		dev_err(&pdev->dev, "unable to alloc mem for OMAP PIPE3 PHY\n");
>  		return -ENOMEM;
>  	}
>  
> @@ -219,13 +232,6 @@ static int omap_usb3_probe(struct platform_device *pdev)
>  
>  	phy->dev		= &pdev->dev;
>  
> -	phy->phy.dev		= phy->dev;
> -	phy->phy.label		= "omap-usb3";
> -	phy->phy.init		= omap_usb3_init;
> -	phy->phy.set_suspend	= omap_usb3_suspend;
> -	phy->phy.type		= USB_PHY_TYPE_USB3;
> -
> -	phy->is_suspended	= 1;
>  	phy->wkupclk = devm_clk_get(phy->dev, "usb_phy_cm_clk32k");

As this is no longer USB specific, we need to make the clock binding generic as well.

>  	if (IS_ERR(phy->wkupclk)) {
>  		dev_err(&pdev->dev, "unable to get usb_phy_cm_clk32k\n");
> @@ -251,6 +257,11 @@ static int omap_usb3_probe(struct platform_device *pdev)
>  		dev_err(&pdev->dev, "Failed to get control device phandle\n");
>  		return -EINVAL;
>  	}
> +	phy_provider = devm_of_phy_provider_register(phy->dev,
> +			of_phy_simple_xlate);
> +	if (IS_ERR(phy_provider))
> +		return PTR_ERR(phy_provider);
> +
>  	control_pdev = of_find_device_by_node(control_node);
>  	if (!control_pdev) {
>  		dev_err(&pdev->dev, "Failed to get control device\n");
> @@ -260,23 +271,27 @@ static int omap_usb3_probe(struct platform_device *pdev)
>  	phy->control_dev = &control_pdev->dev;
>  
>  	omap_control_usb_phy_power(phy->control_dev, 0);
> -	usb_add_phy_dev(&phy->phy);
>  
>  	platform_set_drvdata(pdev, phy);
> -
>  	pm_runtime_enable(phy->dev);
> +
> +	generic_phy = devm_phy_create(phy->dev, &ops, NULL);
> +	if (IS_ERR(generic_phy))
> +		return PTR_ERR(generic_phy);
> +
> +	phy_set_drvdata(generic_phy, phy);
> +
>  	pm_runtime_get(&pdev->dev);
>  
>  	return 0;
>  }
>  
> -static int omap_usb3_remove(struct platform_device *pdev)
> +static int omap_pipe3_remove(struct platform_device *pdev)
>  {
> -	struct omap_usb *phy = platform_get_drvdata(pdev);
> +	struct omap_pipe3 *phy = platform_get_drvdata(pdev);
>  
>  	clk_unprepare(phy->wkupclk);
>  	clk_unprepare(phy->optclk);
> -	usb_remove_phy(&phy->phy);
>  	if (!pm_runtime_suspended(&pdev->dev))
>  		pm_runtime_put(&pdev->dev);
>  	pm_runtime_disable(&pdev->dev);
> @@ -286,10 +301,9 @@ static int omap_usb3_remove(struct platform_device *pdev)
>  
>  #ifdef CONFIG_PM_RUNTIME
>  
> -static int omap_usb3_runtime_suspend(struct device *dev)
> +static int omap_pipe3_runtime_suspend(struct device *dev)
>  {
> -	struct platform_device	*pdev = to_platform_device(dev);
> -	struct omap_usb	*phy = platform_get_drvdata(pdev);
> +	struct omap_pipe3	*phy = dev_get_drvdata(dev);
>  
>  	clk_disable(phy->wkupclk);
>  	clk_disable(phy->optclk);
> @@ -297,11 +311,10 @@ static int omap_usb3_runtime_suspend(struct device *dev)
>  	return 0;
>  }
>  
> -static int omap_usb3_runtime_resume(struct device *dev)
> +static int omap_pipe3_runtime_resume(struct device *dev)
>  {
>  	u32 ret = 0;
> -	struct platform_device	*pdev = to_platform_device(dev);
> -	struct omap_usb	*phy = platform_get_drvdata(pdev);
> +	struct omap_pipe3	*phy = dev_get_drvdata(dev);
>  
>  	ret = clk_enable(phy->optclk);
>  	if (ret) {
> @@ -324,38 +337,41 @@ err1:
>  	return ret;
>  }
>  
> -static const struct dev_pm_ops omap_usb3_pm_ops = {
> -	SET_RUNTIME_PM_OPS(omap_usb3_runtime_suspend, omap_usb3_runtime_resume,
> -		NULL)
> +static const struct dev_pm_ops omap_pipe3_pm_ops = {
> +	SET_RUNTIME_PM_OPS(omap_pipe3_runtime_suspend,
> +		omap_pipe3_runtime_resume, NULL)
>  };
>  
> -#define DEV_PM_OPS     (&omap_usb3_pm_ops)
> +#define DEV_PM_OPS     (&omap_pipe3_pm_ops)
>  #else
>  #define DEV_PM_OPS     NULL
>  #endif
>  
>  #ifdef CONFIG_OF
> -static const struct of_device_id omap_usb3_id_table[] = {
> +static const struct of_device_id omap_pipe3_id_table[] = {
> +	{ .compatible = "ti,omap-pipe3" },

why do you need "omap-pipe3", isn't sata, pcie and usb3 sufficient?

> +	{ .compatible = "ti,omap-sata" },
> +	{ .compatible = "ti,omap-pcie" },
>  	{ .compatible = "ti,omap-usb3" },
>  	{}
>  };
> -MODULE_DEVICE_TABLE(of, omap_usb3_id_table);
> +MODULE_DEVICE_TABLE(of, omap_pipe3_id_table);
>  #endif
>  
> -static struct platform_driver omap_usb3_driver = {
> -	.probe		= omap_usb3_probe,
> -	.remove		= omap_usb3_remove,
> +static struct platform_driver omap_pipe3_driver = {
> +	.probe		= omap_pipe3_probe,
> +	.remove		= omap_pipe3_remove,
>  	.driver		= {
> -		.name	= "omap-usb3",
> +		.name	= "omap-pipe3",
>  		.owner	= THIS_MODULE,
>  		.pm	= DEV_PM_OPS,
> -		.of_match_table = of_match_ptr(omap_usb3_id_table),
> +		.of_match_table = of_match_ptr(omap_pipe3_id_table),
>  	},
>  };
>  
> -module_platform_driver(omap_usb3_driver);
> +module_platform_driver(omap_pipe3_driver);
>  
> -MODULE_ALIAS("platform: omap_usb3");
> +MODULE_ALIAS("platform: omap_pipe3");
>  MODULE_AUTHOR("Texas Instruments Inc.");
> -MODULE_DESCRIPTION("OMAP USB3 phy driver");
> +MODULE_DESCRIPTION("OMAP PIPE3 phy driver");
>  MODULE_LICENSE("GPL v2");
> diff --git a/drivers/usb/phy/Kconfig b/drivers/usb/phy/Kconfig
> index d69cdad..0210e03 100644
> --- a/drivers/usb/phy/Kconfig
> +++ b/drivers/usb/phy/Kconfig
> @@ -66,17 +66,6 @@ config OMAP_CONTROL_USB
>  	  power on the USB2 PHY is present in OMAP4 and OMAP5. OMAP5 has an
>  	  additional register to power on USB3 PHY.
>  
> -config OMAP_USB3
> -	tristate "OMAP USB3 PHY Driver"
> -	depends on ARCH_OMAP2PLUS || COMPILE_TEST
> -	select OMAP_CONTROL_USB
> -	select USB_PHY
> -	help
> -	  Enable this to support the USB3 PHY that is part of SOC. This
> -	  driver takes care of all the PHY functionality apart from comparator.
> -	  This driver interacts with the "OMAP Control USB Driver" to power
> -	  on/off the PHY.
> -
>  config AM335X_CONTROL_USB
>  	tristate
>  
> diff --git a/drivers/usb/phy/Makefile b/drivers/usb/phy/Makefile
> index 51968d7..d1c9683 100644
> --- a/drivers/usb/phy/Makefile
> +++ b/drivers/usb/phy/Makefile
> @@ -13,7 +13,6 @@ obj-$(CONFIG_ISP1301_OMAP)		+= phy-isp1301-omap.o
>  obj-$(CONFIG_MV_U3D_PHY)		+= phy-mv-u3d-usb.o
>  obj-$(CONFIG_NOP_USB_XCEIV)		+= phy-generic.o
>  obj-$(CONFIG_OMAP_CONTROL_USB)		+= phy-omap-control.o
> -obj-$(CONFIG_OMAP_USB3)			+= phy-omap-usb3.o
>  obj-$(CONFIG_SAMSUNG_USBPHY)		+= phy-samsung-usb.o
>  obj-$(CONFIG_SAMSUNG_USB2PHY)		+= phy-samsung-usb2.o
>  obj-$(CONFIG_SAMSUNG_USB3PHY)		+= phy-samsung-usb3.o
> diff --git a/include/linux/phy/omap_pipe3.h b/include/linux/phy/omap_pipe3.h
> new file mode 100644
> index 0000000..7329056
> --- /dev/null
> +++ b/include/linux/phy/omap_pipe3.h

ti_pipe3.h ?

> @@ -0,0 +1,52 @@
> +/*
> + * omap_pipe3.h -- omap pipe3 phy header file
> + *
> + * Copyright (C) 2013 Texas Instruments Incorporated - http://www.ti.com
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * Author: Kishon Vijay Abraham I <kishon@ti.com>
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + */
> +
> +#ifndef __DRIVERS_OMAP_PIPE3_H
> +#define __DRIVERS_OMAP_PIPE3_H
> +
> +#include <linux/io.h>
> +
> +struct pipe3_dpll_params {
> +	u16	m;
> +	u8	n;
> +	u8	freq:3;
> +	u8	sd;
> +	u32	mf;
> +};
> +
> +struct omap_pipe3 {
> +	void __iomem		*pll_ctrl_base;
> +	struct device		*dev;
> +	struct device		*control_dev;
> +	struct clk		*wkupclk;
> +	struct clk		*sys_clk;

sysclk. To be consistent with others?

> +	struct clk		*optclk;
> +};
> +
> +static inline u32 omap_pipe3_readl(void __iomem *addr, unsigned offset)
> +{
> +	return __raw_readl(addr + offset);
> +}
> +
> +static inline void omap_pipe3_writel(void __iomem *addr, unsigned offset,
> +	u32 data)
> +{
> +	__raw_writel(data, addr + offset);
> +}
> +
> +#endif /* __DRIVERS_OMAP_PIPE3_H */
> 

cheers,
-roger

