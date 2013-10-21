Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548Ab3JUMy5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 08:54:57 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:53813 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753331Ab3JUMyy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 08:54:54 -0400
Message-ID: <526523D8.2060807@ti.com>
Date: Mon, 21 Oct 2013 18:23:44 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Roger Quadros <rogerq@ti.com>
CC: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <rob.herring@calxeda.com>,
        <pawel.moll@arm.com>, <mark.rutland@arm.com>, <swarren@wwwdotorg.org>,
        <ijc+devicetree@hellion.org.uk>, <rob@landley.net>,
        <bcousson@baylibre.com>, <tony@atomide.com>, <linux@arm.linux.org.uk>,
        <grant.likely@linaro.org>, <s.nawrocki@samsung.com>,
        <galak@codeaurora.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH v2 4/7] drivers: phy: usb3/pipe3: Adapt pipe3 driver to
 Generic PHY Framework
References: <1381866857-3861-1-git-send-email-kishon@ti.com> <1381866857-3861-5-git-send-email-kishon@ti.com> <525E9763.6040803@ti.com>
In-Reply-To: <525E9763.6040803@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wednesday 16 October 2013 07:10 PM, Roger Quadros wrote:
> Hi,
> 
> On 10/15/2013 10:54 PM, Kishon Vijay Abraham I wrote:
>> Adapted omap-usb3 PHY driver to Generic PHY Framework and moved phy-omap-usb3
>> driver in drivers/usb/phy to drivers/phy and also renamed the file to
>> phy-ti-pipe3 since this same driver will be used for SATA PHY and
>> PCIE PHY.
>>
>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>> ---
>>  drivers/phy/Kconfig                                |   10 +
>>  drivers/phy/Makefile                               |    1 +
>>  .../phy/phy-omap-usb3.c => phy/phy-ti-pipe3.c}     |  206 +++++++++++---------
>>  drivers/usb/phy/Kconfig                            |   11 --
>>  drivers/usb/phy/Makefile                           |    1 -
>>  include/linux/phy/ti_pipe3.h                       |   52 +++++
>>  6 files changed, 174 insertions(+), 107 deletions(-)
>>  rename drivers/{usb/phy/phy-omap-usb3.c => phy/phy-ti-pipe3.c} (57%)
>>  create mode 100644 include/linux/phy/ti_pipe3.h
>>
>> diff --git a/drivers/phy/Kconfig b/drivers/phy/Kconfig
>> index ac239ac..1158943 100644
>> --- a/drivers/phy/Kconfig
>> +++ b/drivers/phy/Kconfig
>> @@ -27,6 +27,16 @@ config OMAP_USB2
>>  	  The USB OTG controller communicates with the comparator using this
>>  	  driver.
>>  
>> +config TI_PIPE3
>> +	tristate "TI PIPE3 PHY Driver"
>> +	select GENERIC_PHY
>> +	select OMAP_CONTROL_USB
> 
> The original OMAP_USB3 config had this
> 	depends on ARCH_OMAP2PLUS || COMPILE_TEST
> 
> You need the 'depends on ARCH_OMAP2PLUS' else you'll risk build failure on non OMAP
> platforms, because OMAP_CONTROL_USB depends on ARCH_OMAP2PLUS.

huh missed that. Thanks for spotting this.
> 
>> +	help
>> +	  Enable this to support the PIPE3 PHY that is part of TI SOCs. This
>> +	  driver takes care of all the PHY functionality apart from comparator.
>> +	  This driver interacts with the "OMAP Control PHY Driver" to power
>> +	  on/off the PHY.
>> +
>>  config TWL4030_USB
>>  	tristate "TWL4030 USB Transceiver Driver"
>>  	depends on TWL4030_CORE && REGULATOR_TWL4030 && USB_MUSB_OMAP2PLUS
>> diff --git a/drivers/phy/Makefile b/drivers/phy/Makefile
>> index 0dd8a98..42ccab4 100644
>> --- a/drivers/phy/Makefile
>> +++ b/drivers/phy/Makefile
>> @@ -4,4 +4,5 @@
>>  
>>  obj-$(CONFIG_GENERIC_PHY)	+= phy-core.o
>>  obj-$(CONFIG_OMAP_USB2)		+= phy-omap-usb2.o
>> +obj-$(CONFIG_TI_PIPE3)		+= phy-ti-pipe3.o
>>  obj-$(CONFIG_TWL4030_USB)	+= phy-twl4030-usb.o
>> diff --git a/drivers/usb/phy/phy-omap-usb3.c b/drivers/phy/phy-ti-pipe3.c
>> similarity index 57%
>> rename from drivers/usb/phy/phy-omap-usb3.c
>> rename to drivers/phy/phy-ti-pipe3.c
>> index 0c6ba29..31e8397 100644
>> --- a/drivers/usb/phy/phy-omap-usb3.c
>> +++ b/drivers/phy/phy-ti-pipe3.c
>> @@ -1,5 +1,5 @@
>>  /*
>> - * omap-usb3 - USB PHY, talking to dwc3 controller in OMAP.
>> + * phy-ti-pipe3 - PIPE3 PHY driver for SATA, USB and PCIE.
> 
> SATA and PCIe is not yet supported so no need to mention about it now.

hmm Ok.
> 
>>   *
>>   * Copyright (C) 2013 Texas Instruments Incorporated - http://www.ti.com
>>   * This program is free software; you can redistribute it and/or modify
>> @@ -19,7 +19,8 @@
>>  #include <linux/module.h>
>>  #include <linux/platform_device.h>
>>  #include <linux/slab.h>
>> -#include <linux/usb/omap_usb.h>
>> +#include <linux/phy/ti_pipe3.h>
>> +#include <linux/phy/phy.h>
>>  #include <linux/of.h>
>>  #include <linux/clk.h>
>>  #include <linux/err.h>
>> @@ -52,17 +53,17 @@
>>  
>>  /*
>>   * This is an Empirical value that works, need to confirm the actual
>> - * value required for the USB3PHY_PLL_CONFIGURATION2.PLL_IDLE status
>> - * to be correctly reflected in the USB3PHY_PLL_STATUS register.
>> + * value required for the PIPE3PHY_PLL_CONFIGURATION2.PLL_IDLE status
>> + * to be correctly reflected in the PIPE3PHY_PLL_STATUS register.
>>   */
>>  # define PLL_IDLE_TIME  100;
>>  
>> -struct usb_dpll_map {
>> +struct pipe3_dpll_map {
>>  	unsigned long rate;
>> -	struct usb_dpll_params params;
>> +	struct pipe3_dpll_params params;
>>  };
>>  
>> -static struct usb_dpll_map dpll_map[] = {
>> +static struct pipe3_dpll_map dpll_map[] = {
>>  	{12000000, {1250, 5, 4, 20, 0} },	/* 12 MHz */
>>  	{16800000, {3125, 20, 4, 20, 0} },	/* 16.8 MHz */
>>  	{19200000, {1172, 8, 4, 20, 65537} },	/* 19.2 MHz */
>> @@ -71,7 +72,7 @@ static struct usb_dpll_map dpll_map[] = {
>>  	{38400000, {3125, 47, 4, 20, 92843} },	/* 38.4 MHz */
>>  };
>>  
>> -static struct usb_dpll_params *omap_usb3_get_dpll_params(unsigned long rate)
>> +static struct pipe3_dpll_params *ti_pipe3_get_dpll_params(unsigned long rate)
>>  {
>>  	int i;
>>  
>> @@ -83,110 +84,113 @@ static struct usb_dpll_params *omap_usb3_get_dpll_params(unsigned long rate)
>>  	return NULL;
>>  }
>>  
>> -static int omap_usb3_suspend(struct usb_phy *x, int suspend)
>> +static int ti_pipe3_power_off(struct phy *x)
>>  {
>> -	struct omap_usb *phy = phy_to_omapusb(x);
>> -	int	val;
>> +	struct ti_pipe3 *phy = phy_get_drvdata(x);
>> +	int val;
>>  	int timeout = PLL_IDLE_TIME;
>>  
>> -	if (suspend && !phy->is_suspended) {
>> -		val = omap_usb_readl(phy->pll_ctrl_base, PLL_CONFIGURATION2);
>> -		val |= PLL_IDLE;
>> -		omap_usb_writel(phy->pll_ctrl_base, PLL_CONFIGURATION2, val);
>> -
>> -		do {
>> -			val = omap_usb_readl(phy->pll_ctrl_base, PLL_STATUS);
>> -			if (val & PLL_TICOPWDN)
>> -				break;
>> -			udelay(1);
>> -		} while (--timeout);
>> -
>> -		omap_control_usb_phy_power(phy->control_dev, 0);
>> -
>> -		phy->is_suspended	= 1;
>> -	} else if (!suspend && phy->is_suspended) {
>> -		phy->is_suspended	= 0;
>> -
>> -		val = omap_usb_readl(phy->pll_ctrl_base, PLL_CONFIGURATION2);
>> -		val &= ~PLL_IDLE;
>> -		omap_usb_writel(phy->pll_ctrl_base, PLL_CONFIGURATION2, val);
>> -
>> -		do {
>> -			val = omap_usb_readl(phy->pll_ctrl_base, PLL_STATUS);
>> -			if (!(val & PLL_TICOPWDN))
>> -				break;
>> -			udelay(1);
>> -		} while (--timeout);
>> -	}
>> +	val = ti_pipe3_readl(phy->pll_ctrl_base, PLL_CONFIGURATION2);
>> +	val |= PLL_IDLE;
>> +	ti_pipe3_writel(phy->pll_ctrl_base, PLL_CONFIGURATION2, val);
>> +
>> +	do {
>> +		val = ti_pipe3_readl(phy->pll_ctrl_base, PLL_STATUS);
>> +		if (val & PLL_TICOPWDN)
>> +			break;
>> +		usleep_range(1, 5);
>> +	} while (--timeout);
>> +
>> +	omap_control_usb_phy_power(phy->control_dev, 0);
>> +
>> +	return 0;
>> +}
>> +
>> +static int ti_pipe3_power_on(struct phy *x)
>> +{
>> +	struct ti_pipe3 *phy = phy_get_drvdata(x);
>> +	int val;
>> +	int timeout = PLL_IDLE_TIME;
>> +
>> +	val = ti_pipe3_readl(phy->pll_ctrl_base, PLL_CONFIGURATION2);
>> +	val &= ~PLL_IDLE;
>> +	ti_pipe3_writel(phy->pll_ctrl_base, PLL_CONFIGURATION2, val);
>> +
>> +	do {
>> +		val = ti_pipe3_readl(phy->pll_ctrl_base, PLL_STATUS);
>> +		if (!(val & PLL_TICOPWDN))
>> +			break;
>> +		usleep_range(1, 5);
>> +	} while (--timeout);
>>  
>>  	return 0;
>>  }
>>  
>> -static void omap_usb_dpll_relock(struct omap_usb *phy)
>> +static void ti_pipe3_dpll_relock(struct ti_pipe3 *phy)
>>  {
>>  	u32		val;
>>  	unsigned long	timeout;
>>  
>> -	omap_usb_writel(phy->pll_ctrl_base, PLL_GO, SET_PLL_GO);
>> +	ti_pipe3_writel(phy->pll_ctrl_base, PLL_GO, SET_PLL_GO);
>>  
>>  	timeout = jiffies + msecs_to_jiffies(20);
>>  	do {
>> -		val = omap_usb_readl(phy->pll_ctrl_base, PLL_STATUS);
>> +		val = ti_pipe3_readl(phy->pll_ctrl_base, PLL_STATUS);
>>  		if (val & PLL_LOCK)
>>  			break;
>>  	} while (!WARN_ON(time_after(jiffies, timeout)));
>>  }
>>  
>> -static int omap_usb_dpll_lock(struct omap_usb *phy)
>> +static int ti_pipe3_dpll_lock(struct ti_pipe3 *phy)
>>  {
>>  	u32			val;
>>  	unsigned long		rate;
>> -	struct usb_dpll_params *dpll_params;
>> +	struct pipe3_dpll_params *dpll_params;
>>  
>>  	rate = clk_get_rate(phy->sys_clk);
>> -	dpll_params = omap_usb3_get_dpll_params(rate);
>> +	dpll_params = ti_pipe3_get_dpll_params(rate);
>>  	if (!dpll_params) {
>>  		dev_err(phy->dev,
>>  			  "No DPLL configuration for %lu Hz SYS CLK\n", rate);
>>  		return -EINVAL;
>>  	}
>>  
>> -	val = omap_usb_readl(phy->pll_ctrl_base, PLL_CONFIGURATION1);
>> +	val = ti_pipe3_readl(phy->pll_ctrl_base, PLL_CONFIGURATION1);
>>  	val &= ~PLL_REGN_MASK;
>>  	val |= dpll_params->n << PLL_REGN_SHIFT;
>> -	omap_usb_writel(phy->pll_ctrl_base, PLL_CONFIGURATION1, val);
>> +	ti_pipe3_writel(phy->pll_ctrl_base, PLL_CONFIGURATION1, val);
>>  
>> -	val = omap_usb_readl(phy->pll_ctrl_base, PLL_CONFIGURATION2);
>> +	val = ti_pipe3_readl(phy->pll_ctrl_base, PLL_CONFIGURATION2);
>>  	val &= ~PLL_SELFREQDCO_MASK;
>>  	val |= dpll_params->freq << PLL_SELFREQDCO_SHIFT;
>> -	omap_usb_writel(phy->pll_ctrl_base, PLL_CONFIGURATION2, val);
>> +	ti_pipe3_writel(phy->pll_ctrl_base, PLL_CONFIGURATION2, val);
>>  
>> -	val = omap_usb_readl(phy->pll_ctrl_base, PLL_CONFIGURATION1);
>> +	val = ti_pipe3_readl(phy->pll_ctrl_base, PLL_CONFIGURATION1);
>>  	val &= ~PLL_REGM_MASK;
>>  	val |= dpll_params->m << PLL_REGM_SHIFT;
>> -	omap_usb_writel(phy->pll_ctrl_base, PLL_CONFIGURATION1, val);
>> +	ti_pipe3_writel(phy->pll_ctrl_base, PLL_CONFIGURATION1, val);
>>  
>> -	val = omap_usb_readl(phy->pll_ctrl_base, PLL_CONFIGURATION4);
>> +	val = ti_pipe3_readl(phy->pll_ctrl_base, PLL_CONFIGURATION4);
>>  	val &= ~PLL_REGM_F_MASK;
>>  	val |= dpll_params->mf << PLL_REGM_F_SHIFT;
>> -	omap_usb_writel(phy->pll_ctrl_base, PLL_CONFIGURATION4, val);
>> +	ti_pipe3_writel(phy->pll_ctrl_base, PLL_CONFIGURATION4, val);
>>  
>> -	val = omap_usb_readl(phy->pll_ctrl_base, PLL_CONFIGURATION3);
>> +	val = ti_pipe3_readl(phy->pll_ctrl_base, PLL_CONFIGURATION3);
>>  	val &= ~PLL_SD_MASK;
>>  	val |= dpll_params->sd << PLL_SD_SHIFT;
>> -	omap_usb_writel(phy->pll_ctrl_base, PLL_CONFIGURATION3, val);
>> +	ti_pipe3_writel(phy->pll_ctrl_base, PLL_CONFIGURATION3, val);
>>  
>> -	omap_usb_dpll_relock(phy);
>> +	ti_pipe3_dpll_relock(phy);
>>  
>>  	return 0;
>>  }
>>  
>> -static int omap_usb3_init(struct usb_phy *x)
>> +static int ti_pipe3_init(struct phy *x)
>>  {
>> -	struct omap_usb	*phy = phy_to_omapusb(x);
>> +	struct ti_pipe3 *phy = phy_get_drvdata(x);
>>  	int ret;
>>  
>> -	ret = omap_usb_dpll_lock(phy);
>> +	ret = ti_pipe3_dpll_lock(phy);
>>  	if (ret)
>>  		return ret;
>>  
>> @@ -195,9 +199,18 @@ static int omap_usb3_init(struct usb_phy *x)
>>  	return 0;
>>  }
>>  
>> -static int omap_usb3_probe(struct platform_device *pdev)
>> +static struct phy_ops ops = {
>> +	.init		= ti_pipe3_init,
>> +	.power_on	= ti_pipe3_power_on,
>> +	.power_off	= ti_pipe3_power_off,
>> +	.owner		= THIS_MODULE,
>> +};
>> +
>> +static int ti_pipe3_probe(struct platform_device *pdev)
>>  {
>> -	struct omap_usb *phy;
>> +	struct ti_pipe3 *phy;
>> +	struct phy *generic_phy;
>> +	struct phy_provider *phy_provider;
>>  	struct resource *res;
>>  	struct device_node *node = pdev->dev.of_node;
>>  	struct device_node *control_node;
>> @@ -208,7 +221,7 @@ static int omap_usb3_probe(struct platform_device *pdev)
>>  
>>  	phy = devm_kzalloc(&pdev->dev, sizeof(*phy), GFP_KERNEL);
>>  	if (!phy) {
>> -		dev_err(&pdev->dev, "unable to alloc mem for OMAP USB3 PHY\n");
>> +		dev_err(&pdev->dev, "unable to alloc mem for TI PIPE3 PHY\n");
>>  		return -ENOMEM;
>>  	}
>>  
>> @@ -219,13 +232,6 @@ static int omap_usb3_probe(struct platform_device *pdev)
>>  
>>  	phy->dev		= &pdev->dev;
>>  
>> -	phy->phy.dev		= phy->dev;
>> -	phy->phy.label		= "omap-usb3";
>> -	phy->phy.init		= omap_usb3_init;
>> -	phy->phy.set_suspend	= omap_usb3_suspend;
>> -	phy->phy.type		= USB_PHY_TYPE_USB3;
>> -
>> -	phy->is_suspended	= 1;
>>  	phy->wkupclk = devm_clk_get(phy->dev, "usb_phy_cm_clk32k");
>>  	if (IS_ERR(phy->wkupclk)) {
>>  		dev_err(&pdev->dev, "unable to get usb_phy_cm_clk32k\n");
>> @@ -251,6 +257,11 @@ static int omap_usb3_probe(struct platform_device *pdev)
>>  		dev_err(&pdev->dev, "Failed to get control device phandle\n");
>>  		return -EINVAL;
>>  	}
>> +	phy_provider = devm_of_phy_provider_register(phy->dev,
>> +			of_phy_simple_xlate);
>> +	if (IS_ERR(phy_provider))
>> +		return PTR_ERR(phy_provider);
>> +
>>  	control_pdev = of_find_device_by_node(control_node);
>>  	if (!control_pdev) {
>>  		dev_err(&pdev->dev, "Failed to get control device\n");
>> @@ -260,23 +271,27 @@ static int omap_usb3_probe(struct platform_device *pdev)
>>  	phy->control_dev = &control_pdev->dev;
>>  
>>  	omap_control_usb_phy_power(phy->control_dev, 0);
>> -	usb_add_phy_dev(&phy->phy);
>>  
>>  	platform_set_drvdata(pdev, phy);
>> -
>>  	pm_runtime_enable(phy->dev);
>> +
>> +	generic_phy = devm_phy_create(phy->dev, &ops, NULL);
>> +	if (IS_ERR(generic_phy))
>> +		return PTR_ERR(generic_phy);
>> +
>> +	phy_set_drvdata(generic_phy, phy);
>> +
>>  	pm_runtime_get(&pdev->dev);
>>  
>>  	return 0;
>>  }
>>  
>> -static int omap_usb3_remove(struct platform_device *pdev)
>> +static int ti_pipe3_remove(struct platform_device *pdev)
>>  {
>> -	struct omap_usb *phy = platform_get_drvdata(pdev);
>> +	struct ti_pipe3 *phy = platform_get_drvdata(pdev);
>>  
>>  	clk_unprepare(phy->wkupclk);
>>  	clk_unprepare(phy->optclk);
>> -	usb_remove_phy(&phy->phy);
>>  	if (!pm_runtime_suspended(&pdev->dev))
>>  		pm_runtime_put(&pdev->dev);
>>  	pm_runtime_disable(&pdev->dev);
>> @@ -286,10 +301,9 @@ static int omap_usb3_remove(struct platform_device *pdev)
>>  
>>  #ifdef CONFIG_PM_RUNTIME
>>  
>> -static int omap_usb3_runtime_suspend(struct device *dev)
>> +static int ti_pipe3_runtime_suspend(struct device *dev)
>>  {
>> -	struct platform_device	*pdev = to_platform_device(dev);
>> -	struct omap_usb	*phy = platform_get_drvdata(pdev);
>> +	struct ti_pipe3	*phy = dev_get_drvdata(dev);
>>  
>>  	clk_disable(phy->wkupclk);
>>  	clk_disable(phy->optclk);
>> @@ -297,11 +311,10 @@ static int omap_usb3_runtime_suspend(struct device *dev)
>>  	return 0;
>>  }
>>  
>> -static int omap_usb3_runtime_resume(struct device *dev)
>> +static int ti_pipe3_runtime_resume(struct device *dev)
>>  {
>>  	u32 ret = 0;
>> -	struct platform_device	*pdev = to_platform_device(dev);
>> -	struct omap_usb	*phy = platform_get_drvdata(pdev);
>> +	struct ti_pipe3	*phy = dev_get_drvdata(dev);
>>  
>>  	ret = clk_enable(phy->optclk);
>>  	if (ret) {
>> @@ -324,38 +337,41 @@ err1:
>>  	return ret;
>>  }
>>  
>> -static const struct dev_pm_ops omap_usb3_pm_ops = {
>> -	SET_RUNTIME_PM_OPS(omap_usb3_runtime_suspend, omap_usb3_runtime_resume,
>> -		NULL)
>> +static const struct dev_pm_ops ti_pipe3_pm_ops = {
>> +	SET_RUNTIME_PM_OPS(ti_pipe3_runtime_suspend,
>> +		ti_pipe3_runtime_resume, NULL)
>>  };
>>  
>> -#define DEV_PM_OPS     (&omap_usb3_pm_ops)
>> +#define DEV_PM_OPS     (&ti_pipe3_pm_ops)
>>  #else
>>  #define DEV_PM_OPS     NULL
>>  #endif
>>  
>>  #ifdef CONFIG_OF
>> -static const struct of_device_id omap_usb3_id_table[] = {
>> +static const struct of_device_id ti_pipe3_id_table[] = {
>> +	{ .compatible = "ti,phy-sata" },
>> +	{ .compatible = "ti,phy-pcie" },
> 
> sata and pcie are not yet supported by this driver so better avoid adding
> the compatible strings now.

Ok.
> 
>> +	{ .compatible = "ti,phy-usb3" },
>>  	{ .compatible = "ti,omap-usb3" },
>>  	{}
>>  };
>> -MODULE_DEVICE_TABLE(of, omap_usb3_id_table);
>> +MODULE_DEVICE_TABLE(of, ti_pipe3_id_table);
>>  #endif
>>  
>> -static struct platform_driver omap_usb3_driver = {
>> -	.probe		= omap_usb3_probe,
>> -	.remove		= omap_usb3_remove,
>> +static struct platform_driver ti_pipe3_driver = {
>> +	.probe		= ti_pipe3_probe,
>> +	.remove		= ti_pipe3_remove,
>>  	.driver		= {
>> -		.name	= "omap-usb3",
>> +		.name	= "ti-pipe3",
>>  		.owner	= THIS_MODULE,
>>  		.pm	= DEV_PM_OPS,
>> -		.of_match_table = of_match_ptr(omap_usb3_id_table),
>> +		.of_match_table = of_match_ptr(ti_pipe3_id_table),
>>  	},
>>  };
>>  
>> -module_platform_driver(omap_usb3_driver);
>> +module_platform_driver(ti_pipe3_driver);
>>  
>> -MODULE_ALIAS("platform: omap_usb3");
>> +MODULE_ALIAS("platform: ti_pipe3");
>>  MODULE_AUTHOR("Texas Instruments Inc.");
>> -MODULE_DESCRIPTION("OMAP USB3 phy driver");
>> +MODULE_DESCRIPTION("TI PIPE3 phy driver");
>>  MODULE_LICENSE("GPL v2");
>> diff --git a/drivers/usb/phy/Kconfig b/drivers/usb/phy/Kconfig
>> index 64b8bef..1d4916a 100644
>> --- a/drivers/usb/phy/Kconfig
>> +++ b/drivers/usb/phy/Kconfig
>> @@ -66,17 +66,6 @@ config OMAP_CONTROL_USB
>>  	  power on the USB2 PHY is present in OMAP4 and OMAP5. OMAP5 has an
>>  	  additional register to power on USB3 PHY.
>>  
>> -config OMAP_USB3
>> -	tristate "OMAP USB3 PHY Driver"
>> -	depends on ARCH_OMAP2PLUS || COMPILE_TEST
>> -	select OMAP_CONTROL_USB
>> -	select USB_PHY
>> -	help
>> -	  Enable this to support the USB3 PHY that is part of SOC. This
>> -	  driver takes care of all the PHY functionality apart from comparator.
>> -	  This driver interacts with the "OMAP Control USB Driver" to power
>> -	  on/off the PHY.
>> -
>>  config AM335X_CONTROL_USB
>>  	tristate
>>  
>> diff --git a/drivers/usb/phy/Makefile b/drivers/usb/phy/Makefile
>> index 9c37361..fa80661 100644
>> --- a/drivers/usb/phy/Makefile
>> +++ b/drivers/usb/phy/Makefile
>> @@ -15,7 +15,6 @@ obj-$(CONFIG_NOP_USB_XCEIV)		+= phy-generic.o
>>  obj-$(CONFIG_OMAP_CONTROL_USB)		+= phy-omap-control.o
>>  obj-$(CONFIG_AM335X_CONTROL_USB)	+= phy-am335x-control.o
>>  obj-$(CONFIG_AM335X_PHY_USB)		+= phy-am335x.o
>> -obj-$(CONFIG_OMAP_USB3)			+= phy-omap-usb3.o
>>  obj-$(CONFIG_SAMSUNG_USBPHY)		+= phy-samsung-usb.o
>>  obj-$(CONFIG_SAMSUNG_USB2PHY)		+= phy-samsung-usb2.o
>>  obj-$(CONFIG_SAMSUNG_USB3PHY)		+= phy-samsung-usb3.o
>> diff --git a/include/linux/phy/ti_pipe3.h b/include/linux/phy/ti_pipe3.h
>> new file mode 100644
>> index 0000000..4d42b04
>> --- /dev/null
>> +++ b/include/linux/phy/ti_pipe3.h
>> @@ -0,0 +1,52 @@
>> +/*
>> + * ti_pipe3.h -- ti pipe3 phy header file
> 
> why do you need this file to sit in include/linux/phy/ ?
> 
> I don't think there are any external users so better to just merge
> it with drivers/phy/phy-ti-pipe3.c

yeah. Makes sense.

Thanks
Kishon
