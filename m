Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751945AbaLOMxg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 07:53:36 -0500
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:36959 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751905AbaLOMxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 07:53:34 -0500
Message-ID: <548ED9A2.5060403@st.com>
Date: Mon, 15 Dec 2014 13:52:50 +0100
From: David Paris <david.paris@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Cc: <kernel@stlinux.com>, <a.zummo@towertech.it>, <rtc-linux@googlegroups.com>,
        <wim@iguana.be>, <linux-watchdog@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH 6/8] watchdog: st_wdt: Add new driver for ST's LPC Watchdog
References: <1418642738-17407-1-git-send-email-lee.jones@linaro.org> <1418642738-17407-7-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1418642738-17407-7-git-send-email-lee.jones@linaro.org>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.83]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-15_01:2014-12-15,2014-12-14,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

     Something I didn't pointed out before, this driver is only supposed 
to support LPC_0 for stih407. The enable mask is only coded for LPC_0. 
Is it a wanted behavior ?

     In our current implementation here in ST is that LPC_0 is for A9 
Watchdog and LPC_1 for A9 global timer. This has been translated in the 
driver by hardcoding enable mask of LPC watchdog to only support LPC_0. 
But do we want to have a more generic driver to be applicable both for 
LPC_0 and LPC_1 ?

     David

On 12/15/2014 12:25 PM, Lee Jones wrote:
> Signed-off-by: David Paris <david.paris@st.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>   drivers/watchdog/Kconfig  |  13 ++
>   drivers/watchdog/Makefile |   1 +
>   drivers/watchdog/st_wdt.c | 312 ++++++++++++++++++++++++++++++++++++++++++++++
>   3 files changed, 326 insertions(+)
>   create mode 100644 drivers/watchdog/st_wdt.c
>
> diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
> index f57312f..5a538af 100644
> --- a/drivers/watchdog/Kconfig
> +++ b/drivers/watchdog/Kconfig
> @@ -432,6 +432,19 @@ config SIRFSOC_WATCHDOG
>   	  Support for CSR SiRFprimaII and SiRFatlasVI watchdog. When
>   	  the watchdog triggers the system will be reset.
>   
> +config ST_WATCHDOG
> +	tristate "STMicroelectronics LPC Watchdog"
> +	depends on ARCH_STI
> +	depends on OF
> +	select WATCHDOG_CORE
> +	select MFD_ST_LPC
> +	help
> +	  Say Y here to include STMicroelectronics Low Power Controller
> +	  (LPC) based Watchdog timer support.
> +
> +	  To compile this driver as a module, choose M here: the
> +	  module will be called st_wdt.
> +
>   config TEGRA_WATCHDOG
>   	tristate "Tegra watchdog"
>   	depends on ARCH_TEGRA || COMPILE_TEST
> diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
> index 468c320..eb19937 100644
> --- a/drivers/watchdog/Makefile
> +++ b/drivers/watchdog/Makefile
> @@ -57,6 +57,7 @@ obj-$(CONFIG_RETU_WATCHDOG) += retu_wdt.o
>   obj-$(CONFIG_BCM2835_WDT) += bcm2835_wdt.o
>   obj-$(CONFIG_MOXART_WDT) += moxart_wdt.o
>   obj-$(CONFIG_SIRFSOC_WATCHDOG) += sirfsoc_wdt.o
> +obj-$(CONFIG_ST_WATCHDOG) += st_wdt.o
>   obj-$(CONFIG_BCM_KONA_WDT) += bcm_kona_wdt.o
>   obj-$(CONFIG_TEGRA_WATCHDOG) += tegra_wdt.o
>   
> diff --git a/drivers/watchdog/st_wdt.c b/drivers/watchdog/st_wdt.c
> new file mode 100644
> index 0000000..7e06f15
> --- /dev/null
> +++ b/drivers/watchdog/st_wdt.c
> @@ -0,0 +1,312 @@
> +/*
> + * st-wdt.c - ST's LPC Watchdog
> + *
> + * Copyright (C) 2014 STMicroelectronics -- All Rights Reserved
> + *
> + * Author: David Paris <david.paris@st.com> for STMicroelectronics
> + *         Lee Jones <lee.jones@linaro.org> for STMicroelectronics
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public Licence
> + * as published by the Free Software Foundation; either version
> + * 2 of the Licence, or (at your option) any later version.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/init.h>
> +#include <linux/io.h>
> +#include <linux/kernel.h>
> +#include <linux/mfd/syscon.h>
> +#include <linux/module.h>
> +#include <linux/of.h>
> +#include <linux/of_platform.h>
> +#include <linux/platform_device.h>
> +#include <linux/regmap.h>
> +#include <linux/watchdog.h>
> +
> +/* Low Power Alarm */
> +#define LPC_LPA_LSB_OFF			0x410
> +#define LPC_LPA_START_OFF		0x418
> +
> +/* LPC as WDT */
> +#define LPC_WDT_OFF			0x510
> +
> +struct st_wdog_syscfg {
> +	struct regmap *regmap;
> +	unsigned int reset_type_reg;
> +	unsigned int reset_type_mask;
> +	unsigned int enable_reg;
> +	unsigned int enable_mask;
> +};
> +
> +struct st_wdog {
> +	void __iomem *base;
> +	struct device *dev;
> +	struct st_wdog_syscfg *syscfg;
> +	struct clk *clk;
> +	int warm_reset;
> +};
> +
> +static struct st_wdog_syscfg stid127_syscfg = {
> +	.reset_type_reg		= 0x004,
> +	.reset_type_mask	= BIT(2),
> +	.enable_reg		= 0x000,
> +	.enable_mask		= BIT(2),
> +};
> +
> +static struct st_wdog_syscfg stih415_syscfg = {
> +	.reset_type_reg		= 0x0B8,
> +	.reset_type_mask	= BIT(6),
> +	.enable_reg		= 0x0B4,
> +	.enable_mask		= BIT(7),
> +};
> +
> +static struct st_wdog_syscfg stih416_syscfg = {
> +	.reset_type_reg		= 0x88C,
> +	.reset_type_mask	= BIT(6),
> +	.enable_reg		= 0x888,
> +	.enable_mask		= BIT(7),
> +};
> +
> +static struct st_wdog_syscfg stih407_syscfg = {
> +	.enable_reg		= 0x204,
> +	.enable_mask		= BIT(19),
> +};
> +
> +static struct of_device_id st_wdog_match[] = {
> +	{
> +		.compatible = "st,stih407-lpc",
> +		.data = (void *)&stih407_syscfg,
> +	},
> +	{
> +		.compatible = "st,stih416-lpc",
> +		.data = (void *)&stih416_syscfg,
> +	},
> +	{
> +		.compatible = "st,stih415-lpc",
> +		.data = (void *)&stih415_syscfg,
> +	},
> +	{
> +		.compatible = "st,stid127-lpc",
> +		.data = (void *)&stid127_syscfg,
> +	},
> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, st_wdog_match);
> +
> +static void st_wdog_setup(struct st_wdog *st_wdog, bool enable)
> +{
> +	/* Type of watchdog reset - 0: Cold 1: Warm */
> +	if (st_wdog->syscfg->reset_type_reg)
> +		regmap_update_bits(st_wdog->syscfg->regmap,
> +				   st_wdog->syscfg->reset_type_reg,
> +				   st_wdog->syscfg->reset_type_mask,
> +				   st_wdog->warm_reset);
> +
> +	/* Mask/unmask watchdog reset */
> +	regmap_update_bits(st_wdog->syscfg->regmap,
> +			   st_wdog->syscfg->enable_reg,
> +			   st_wdog->syscfg->enable_mask,
> +			   enable ? 0 : st_wdog->syscfg->enable_mask);
> +}
> +
> +static void st_wdog_load_timer(struct st_wdog *st_wdog, unsigned int timeout)
> +{
> +	unsigned long clkrate = clk_get_rate(st_wdog->clk);
> +	unsigned int maxtimeout = 0xFFFFFFFF / clkrate;
> +
> +	if (timeout > maxtimeout) {
> +		dev_warn(st_wdog->dev,
> +			 "timer overrun detected at current freq (%luHz)\n"
> +			 "wdog timeout set for %ds instead of requested %uis",
> +			 clkrate, maxtimeout, timeout);
> +		timeout = maxtimeout;
> +	}
> +	timeout *= clkrate;
> +
> +	writel_relaxed(timeout, st_wdog->base + LPC_LPA_LSB_OFF);
> +	writel_relaxed(1, st_wdog->base + LPC_LPA_START_OFF);
> +}
> +
> +static int st_wdog_start(struct watchdog_device *wdd)
> +{
> +	struct st_wdog *st_wdog = watchdog_get_drvdata(wdd);
> +
> +	writel_relaxed(1, st_wdog->base + LPC_WDT_OFF);
> +
> +	return 0;
> +}
> +
> +static int st_wdog_stop(struct watchdog_device *wdd)
> +{
> +	struct st_wdog *st_wdog = watchdog_get_drvdata(wdd);
> +
> +	writel_relaxed(0, st_wdog->base + LPC_WDT_OFF);
> +
> +	return 0;
> +}
> +
> +static int st_wdog_set_timeout(struct watchdog_device *wdd,
> +			       unsigned int timeout)
> +{
> +	struct st_wdog *st_wdog = watchdog_get_drvdata(wdd);
> +
> +	wdd->timeout = timeout;
> +	st_wdog_load_timer(st_wdog, timeout);
> +
> +	return 0;
> +}
> +
> +static int st_wdog_keepalive(struct watchdog_device *wdd)
> +{
> +	struct st_wdog *st_wdog = watchdog_get_drvdata(wdd);
> +
> +	st_wdog_load_timer(st_wdog, wdd->timeout);
> +
> +	return 0;
> +}
> +
> +static const struct watchdog_info st_wdog_info = {
> +	.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING | WDIOF_MAGICCLOSE,
> +	.identity = "ST LPC WDT",
> +};
> +
> +static const struct watchdog_ops st_wdog_ops = {
> +	.owner		= THIS_MODULE,
> +	.start		= st_wdog_start,
> +	.stop		= st_wdog_stop,
> +	.ping		= st_wdog_keepalive,
> +	.set_timeout	= st_wdog_set_timeout,
> +};
> +
> +static struct watchdog_device st_wdog_dev = {
> +	.info		= &st_wdog_info,
> +	.ops		= &st_wdog_ops,
> +};
> +
> +static int st_wdog_probe(struct platform_device *pdev)
> +{
> +	const struct of_device_id *match;
> +	struct device_node *np;
> +	struct st_wdog *st_wdog;
> +	struct regmap *regmap;
> +	struct resource *res;
> +	struct clk *clk;
> +	void __iomem *base;
> +	int ret;
> +
> +	/* This is a single node MFD device. */
> +	np = pdev->dev.of_node = pdev->dev.parent->of_node;
> +
> +	st_wdog = devm_kzalloc(&pdev->dev, sizeof(*st_wdog), GFP_KERNEL);
> +	if (!st_wdog)
> +		return -ENOMEM;
> +
> +	match = of_match_device(st_wdog_match, &pdev->dev);
> +	if (!match) {
> +		dev_err(&pdev->dev, "Couldn't match device\n");
> +		return -ENODEV;
> +	}
> +	st_wdog->syscfg	= (struct st_wdog_syscfg *)match->data;
> +
> +	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
> +	base = devm_ioremap_resource(&pdev->dev, res);
> +	if (IS_ERR(base)) {
> +		dev_err(&pdev->dev, "Failed to ioremap base\n");
> +		return PTR_ERR(base);
> +	}
> +
> +	regmap = syscon_regmap_lookup_by_phandle(np, "st,syscfg");
> +	if (IS_ERR(regmap)) {
> +		dev_err(&pdev->dev, "No syscfg phandle specified\n");
> +		return PTR_ERR(regmap);
> +	}
> +
> +	clk = clk_get(&pdev->dev, NULL);
> +	if (IS_ERR(clk)) {
> +		dev_err(&pdev->dev, "Unable to request clock\n");
> +		return PTR_ERR(clk);
> +	}
> +	clk_prepare_enable(st_wdog->clk);
> +
> +	st_wdog->dev		= &pdev->dev;
> +	st_wdog->base		= base;
> +	st_wdog->clk		= clk;
> +	st_wdog->syscfg->regmap = regmap;
> +	st_wdog->warm_reset	= of_property_read_bool(np, "st,warm_reset");
> +
> +	watchdog_set_drvdata(&st_wdog_dev, st_wdog);
> +	watchdog_set_nowayout(&st_wdog_dev, WATCHDOG_NOWAYOUT);
> +
> +	/* Init Watchdog timeout with value in DT */
> +	ret = watchdog_init_timeout(&st_wdog_dev, 0, &pdev->dev);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Unable to initialise watchdog timeout\n");
> +		return ret;
> +	}
> +
> +	ret = watchdog_register_device(&st_wdog_dev);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Unable to register watchdog\n");
> +		clk_disable_unprepare(clk);
> +		return ret;
> +	}
> +
> +	st_wdog_setup(st_wdog, true);
> +
> +	dev_info(&pdev->dev, "LPC Watchdog driver registered, reset type is %s",
> +		 st_wdog->warm_reset ? "warm" : "cold");
> +
> +	return ret;
> +}
> +
> +static int st_wdog_remove(struct platform_device *pdev)
> +{
> +	struct st_wdog *st_wdog = watchdog_get_drvdata(&st_wdog_dev);
> +
> +	st_wdog_setup(st_wdog, false);
> +	watchdog_unregister_device(&st_wdog_dev);
> +	clk_disable_unprepare(st_wdog->clk);
> +
> +	return 0;
> +}
> +
> +#ifdef CONFIG_PM
> +static int st_wdog_suspend(struct device *dev)
> +{
> +	if (watchdog_active(&st_wdog_dev))
> +		st_wdog_stop(&st_wdog_dev);
> +
> +	return 0;
> +}
> +
> +static int st_wdog_resume(struct device *dev)
> +{
> +	struct st_wdog *st_wdog = watchdog_get_drvdata(&st_wdog_dev);
> +
> +	if (watchdog_active(&st_wdog_dev)) {
> +		st_wdog_load_timer(st_wdog, st_wdog_dev.timeout);
> +		st_wdog_start(&st_wdog_dev);
> +	}
> +
> +	return 0;
> +}
> +#endif
> +
> +static SIMPLE_DEV_PM_OPS(st_wdog_pm_ops,
> +			 st_wdog_suspend,
> +			 st_wdog_resume);
> +
> +static struct platform_driver st_wdog_driver = {
> +	.driver	= {
> +		.name = "st-lpc-wdt",
> +		.pm = &st_wdog_pm_ops,
> +	},
> +	.probe = st_wdog_probe,
> +	.remove = st_wdog_remove,
> +};
> +module_platform_driver(st_wdog_driver);
> +
> +MODULE_AUTHOR("David Paris <david.paris@st.com>");
> +MODULE_DESCRIPTION("ST LPC Watchdog Driver");
> +MODULE_LICENSE("GPL v2");

