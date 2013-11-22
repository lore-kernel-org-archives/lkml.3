Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061Ab3KVD7t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 22:59:49 -0500
Received: from mail.active-venture.com ([67.228.131.205]:52414 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752020Ab3KVD7r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 22:59:47 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <528ED1C8.9050609@roeck-us.net>
Date: Thu, 21 Nov 2013 19:38:48 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Bibek Basu <bbasu@nvidia.com>, wim@iguana.be,
        linux-watchdog@vger.kernel.org, lee.jones@linaro.org
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] watchdog: as3722_wdt: support for AMS AS3722
References: <1384986810-10952-1-git-send-email-bbasu@nvidia.com> <1384986810-10952-2-git-send-email-bbasu@nvidia.com>
In-Reply-To: <1384986810-10952-2-git-send-email-bbasu@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2013 02:33 PM, Bibek Basu wrote:
> Add watchdog timer driver for as3722 device.
> The timer can be start/stop and set timing through
> watchdog subsystem callbacks.
>
> Change-Id: I5e252fd762764afaa1598cd98fed91864dc23d8d

Is this a new standard tag ? If not it should go.

> Signed-off-by: Bibek Basu <bbasu@nvidia.com>
> ---
>   drivers/watchdog/Kconfig      |   9 ++
>   drivers/watchdog/Makefile     |   1 +
>   drivers/watchdog/as3722_wdt.c | 300 ++++++++++++++++++++++++++++++++++++++++++
>   include/linux/mfd/as3722.h    |   1 +

There is no bindings document.

>   4 files changed, 311 insertions(+)
>   create mode 100644 drivers/watchdog/as3722_wdt.c
>
> diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
> index 74f29a2..15a5c08 100644
> --- a/drivers/watchdog/Kconfig
> +++ b/drivers/watchdog/Kconfig
> @@ -53,6 +53,15 @@ comment "Watchdog Device Drivers"
>
>   # Architecture Independent
>
> +config AS3722_WATCHDOG
> +	tristate "AS3722 watchdog"
> +	depends on MFD_AS3722
> +	select WATCHDOG_CORE
> +	help
> +	  Support for the watchdog in the AMS AS3722 PMIC.  When
> +	  the watchdog triggers the system will be reset/Off based on

	triggers,
	reset/Off -> reset / turned off ?

Which configuration ?

> +	  configuration.
> +
Unlikely that this watchdog is architecture independent.

>   config SOFT_WATCHDOG
>   	tristate "Software watchdog"
>   	select WATCHDOG_CORE
> diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
> index 91bd95a..dab02f8 100644
> --- a/drivers/watchdog/Makefile
> +++ b/drivers/watchdog/Makefile
> @@ -169,6 +169,7 @@ obj-$(CONFIG_WATCHDOG_CP1XXX)		+= cpwd.o
>   obj-$(CONFIG_XEN_WDT) += xen_wdt.o
>
>   # Architecture Independent
> +obj-$(CONFIG_AS3722_WATCHDOG) += as3722_wdt.o
>   obj-$(CONFIG_DA9052_WATCHDOG) += da9052_wdt.o
>   obj-$(CONFIG_DA9055_WATCHDOG) += da9055_wdt.o
>   obj-$(CONFIG_WM831X_WATCHDOG) += wm831x_wdt.o
> diff --git a/drivers/watchdog/as3722_wdt.c b/drivers/watchdog/as3722_wdt.c
> new file mode 100644
> index 0000000..0ce0866
> --- /dev/null
> +++ b/drivers/watchdog/as3722_wdt.c
> @@ -0,0 +1,300 @@
> +/*
> + * as3722_wdt.c -- AS3722 Watchdog Timer.
> + *
> + * Watchdog timer for AS3722 PMIC.
> + *
> + * Copyright (c) 2013, NVIDIA Corporation. All rights reserved.
> + *
> + * Author: Bibek Basu <bbasu@nvidia.com>
> + * based on Palmas_wdt driver (c) Laxman Dewangan , 2013
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License as
> + * published by the Free Software Foundation version 2.
> + *
> + * This program is distributed "as is" WITHOUT ANY WARRANTY of any kind,
> + * whether express or implied; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> + * General Public License for more details.
> + *
> + */
> +#include <linux/device.h>
> +#include <linux/err.h>
> +#include <linux/init.h>
> +#include <linux/interrupt.h>
> +#include <linux/irq.h>
> +#include <linux/kernel.h>
> +#include <linux/module.h>
> +#include <linux/mfd/as3722.h>
> +#include <linux/platform_device.h>
> +#include <linux/pm.h>
> +#include <linux/slab.h>
> +#include <linux/watchdog.h>
> +#include <linux/of.h>
> +
> +static bool nowayout = WATCHDOG_NOWAYOUT;
> +
> +struct as3722_wdt {
> +	struct watchdog_device wdt_dev;
> +	struct device *dev;
> +	struct as3722 *as3722;
> +	int timeout;
> +	int irq;
> +	int timer_initial_period;
> +	int timer_mode;
> +};
> +
> +static irqreturn_t as3722_wdt_irq(int irq, void *data)
> +{
> +	struct as3722_wdt *wdt = data;
> +	int ret;
> +
> +	ret = as3722_update_bits(wdt->as3722,
> +			AS3722_WATCHDOG_SOFTWARE_SIGNAL_REG,
> +			AS3722_WATCHDOG_SW_SIG, AS3722_WATCHDOG_SW_SIG);
> +	if (ret < 0)
> +		dev_err(wdt->dev, "WATCHDOG kick failed: %d\n", ret);
> +	dev_info(wdt->dev, "WDT interrupt occur\n");

I don't see any value in all this noisiness. In my opinion, the driver should only
create error messages during initialization. In all other instances, errors should
be passed back to userspace. And error messages in interrupt code just ask for trouble.

I am curious - what is this function doing anyway ?
I think a brief explanation might be in order.

> +	return IRQ_HANDLED;
> +}
> +
> +static int as3722_wdt_start(struct watchdog_device *wdt_dev)
> +{
> +	struct as3722_wdt *wdt = watchdog_get_drvdata(wdt_dev);
> +	int ret;
> +
> +	ret = as3722_update_bits(wdt->as3722, AS3722_WATCHDOG_CONTROL_REG,
> +			AS3722_WATCHDOG_ON, AS3722_WATCHDOG_ON);
> +	if (ret < 0) {
> +		dev_err(wdt->dev, "WATCHDOG update failed: %d\n", ret);
> +		return ret;
> +	}
> +	return 0;
> +}
> +
> +static int as3722_wdt_stop(struct watchdog_device *wdt_dev)
> +{
> +	struct as3722_wdt *wdt = watchdog_get_drvdata(wdt_dev);
> +	int ret;
> +
> +	ret = as3722_update_bits(wdt->as3722, AS3722_WATCHDOG_CONTROL_REG,
> +			AS3722_WATCHDOG_ON, 0);
> +	if (ret < 0) {
> +		dev_err(wdt->dev, "WATCHDOG update failed: %d\n", ret);
> +		return ret;
> +	}
> +	return 0;
> +}
> +
> +static int as3722_wdt_set_timeout(struct watchdog_device *wdt_dev,
> +		unsigned int timeout)
> +{
> +	struct as3722_wdt *wdt = watchdog_get_drvdata(wdt_dev);
> +	int ret;
> +	unsigned int val = timeout - 1;
> +
> +	ret = as3722_update_bits(wdt->as3722, AS3722_WATCHDOG_TIMER_REG,
> +			AS3722_WATCHDOG_TIMER_MAX, val);
> +	if (ret < 0) {
> +		dev_err(wdt->dev, "WATCHDOG update failed: %d\n", ret);
> +		return ret;
> +	}
> +	wdt->timeout = timeout;
> +	return 0;
> +}
> +
> +static const struct watchdog_info as3722_wdt_info = {
> +	.options = WDIOF_SETTIMEOUT | WDIOF_MAGICCLOSE,
> +	.identity = "AS3722 Watchdog",
> +};
> +
> +static const struct watchdog_ops as3722_wdt_ops = {
> +	.owner = THIS_MODULE,
> +	.start = as3722_wdt_start,
> +	.stop = as3722_wdt_stop,
> +	.set_timeout = as3722_wdt_set_timeout,
> +};
> +
> +#ifdef CONFIG_OF
> +static int as3722_parse_dt_wdt_data(
> +		struct platform_device *pdev,
> +		struct as3722_wdt *wdt)

Continuation lines should be aligned with (, and there should be
no unnecessary ones.

> +{
> +	struct device_node *np = pdev->dev.of_node;
> +	const __be32 *prop;
> +
> +	prop = of_get_property(np, "ams,timer_initial_period", NULL);

Any reason for not using of_property_read_u32 ?

> +	if (prop)
> +		wdt->timer_initial_period = be32_to_cpu(*prop);
> +
Seems to me that such a property (and the related code)
should be made generic, to apply to all watchdog drivers.

Also, I think the driver should support the standard timeout property.

> +	prop = of_get_property(np, "ams,timer_mode", NULL);
> +	if (prop)
> +		wdt->timer_mode =  be32_to_cpu(*prop);

Extra space after =.

Also, you might want to do some value checking.

> +	else
> +		wdt->timer_mode = -1;
> +	return 0;
> +}
> +#else
> +static inline int as3722_parse_dt_wdt_data(
> +		struct platform_device *pdev,
> +		struct as3722_wdt *wdt)
> +{
> +	return 0;
> +}
> +#endif
> +
> +static int as3722_wdt_probe(struct platform_device *pdev)
> +{
> +	struct as3722 *as3722 = dev_get_drvdata(pdev->dev.parent);
> +	struct as3722_wdt *wdt;
> +	struct watchdog_device *wdt_dev;
> +	int ret;
> +
> +	wdt = devm_kzalloc(&pdev->dev, sizeof(*wdt), GFP_KERNEL);
> +	if (!wdt)
> +		return -ENOMEM;
> +
> +	as3722_parse_dt_wdt_data(pdev, wdt);
> +	wdt->dev = &pdev->dev;
> +	wdt->as3722 = as3722;
> +	wdt->irq = as3722_irq_get_virq(wdt->as3722, AS3722_IRQ_WATCHDOG);
> +	wdt_dev = &wdt->wdt_dev;
> +
> +	wdt_dev->info = &as3722_wdt_info;
> +	wdt_dev->ops = &as3722_wdt_ops;
> +	wdt_dev->timeout = 128;
> +	wdt_dev->min_timeout = 8;
> +	wdt_dev->max_timeout = 128;
> +	watchdog_set_nowayout(wdt_dev, nowayout);
> +	watchdog_set_drvdata(wdt_dev, wdt);
> +	platform_set_drvdata(pdev, wdt);
> +
> +	ret = request_threaded_irq(wdt->irq, NULL, as3722_wdt_irq,
> +			IRQF_ONESHOT | IRQF_EARLY_RESUME,
> +			dev_name(&pdev->dev), wdt);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "request IRQ:%d failed, err = %d\n",
> +			 wdt->irq, ret);
> +		return ret;
> +	}
> +
> +	ret = watchdog_register_device(wdt_dev);
> +	if (ret < 0) {
> +		dev_err(&pdev->dev, "watchdog registration failed: %d\n", ret);

you might want to release the interrupt here.

> +		return ret;
> +	}
> +
> +	/* set mode */
> +	if (wdt->timer_mode >= 0) {
> +		ret = as3722_update_bits(wdt->as3722,
> +			AS3722_WATCHDOG_CONTROL_REG,
> +			AS3722_WATCHDOG_MODE_MASK, wdt->timer_mode);
> +		if (ret < 0) {
> +			dev_err(wdt->dev, "WATCHDOG update mode failed: %d\n",
> +					ret);
> +			goto scrub;
> +		}
> +	}
> +
> +	/* configure timer */
> +	if (wdt->timer_initial_period > 0) {
> +		ret = as3722_wdt_set_timeout(wdt_dev,
> +				wdt->timer_initial_period);
> +		if (ret < 0) {
> +			dev_err(wdt->dev, "wdt set timeout failed: %d\n", ret);
> +			goto scrub;
> +		}
> +		ret = as3722_wdt_start(wdt_dev);
> +		if (ret < 0) {
> +			dev_err(wdt->dev,
> +					"wdt start failed: %d\n", ret);

This continuation line seems quite unnecessary.
> +			goto scrub;
> +		}
> +	}
> +
> +	device_set_wakeup_capable(&pdev->dev, 1);
> +	return 0;
> +scrub:
> +	free_irq(wdt->irq, wdt);

If you free the interrupt before unregistering the hwmon device,
you might want to request it after registering the hwmon device.

> +	watchdog_unregister_device(&wdt->wdt_dev);
> +	return ret;
> +}
> +
> +static int as3722_wdt_remove(struct platform_device *pdev)
> +{
> +	struct as3722_wdt *wdt = platform_get_drvdata(pdev);
> +
> +	as3722_wdt_stop(&wdt->wdt_dev);
> +	watchdog_unregister_device(&wdt->wdt_dev);
> +	free_irq(wdt->irq, wdt);
> +	return 0;
> +}
> +
> +#ifdef CONFIG_PM_SLEEP
> +static int as3722_wdt_suspend(struct device *dev)
> +{
> +	struct as3722_wdt *wdt = dev_get_drvdata(dev);
> +	int ret;
> +
> +	if (device_may_wakeup(dev)) {
> +		enable_irq_wake(wdt->irq);
> +	} else if (wdt->timeout > 0) {

Shouldn't you check if the watchdog is running instead ?

I understand that is the idea, but that isn't what it does. This value is 0
if and only if the watchdog timer was never updated, which is unrelated
to its current status.

> +		ret = as3722_wdt_stop(&wdt->wdt_dev);
> +		if (ret < 0)
> +			dev_err(wdt->dev, "wdt stop failed: %d\n", ret);

Shouldn't this return the error ?

> +	}
> +	return 0;
> +}
> +
> +static int as3722_wdt_resume(struct device *dev)
> +{
> +	struct as3722_wdt *wdt = dev_get_drvdata(dev);
> +	int ret;
> +
> +	if (device_may_wakeup(dev)) {
> +		disable_irq_wake(wdt->irq);
> +	} else if (wdt->timeout > 0) {
> +		ret = as3722_wdt_start(&wdt->wdt_dev);
> +		if (ret < 0)
> +			dev_err(wdt->dev, "wdt start failed: %d\n", ret);

Same here.

> +	}
> +	return 0;
> +}
> +#endif
> +
> +static const struct dev_pm_ops as3722_wdt_pm_ops = {
> +	SET_SYSTEM_SLEEP_PM_OPS(as3722_wdt_suspend, as3722_wdt_resume)
> +};
> +
> +static const struct of_device_id as3722_wdt_of_match[] = {
> +	{ .compatible = "ams,as3722-wdt", },
> +	{ /* end */ }
> +};
> +
> +static struct platform_driver as3722_wdt_driver = {
> +	.driver	= {
> +		.name	= "as3722-wdt",
> +		.owner	= THIS_MODULE,

Inconsistent spacing. I would suggest to drop all the extra spaces.

> +		.pm = &as3722_wdt_pm_ops,
> +		.of_match_table = as3722_wdt_of_match,
> +	},
> +	.probe	= as3722_wdt_probe,
> +	.remove	= as3722_wdt_remove,
> +};
> +
> +static int __init as3722_wdt_init(void)
> +{
> +	return platform_driver_register(&as3722_wdt_driver);
> +}
> +subsys_initcall(as3722_wdt_init);
> +
> +static void __exit as3722_wdt_exit(void)
> +{
> +	platform_driver_unregister(&as3722_wdt_driver);
> +}
> +module_exit(as3722_wdt_exit);
> +
> +MODULE_ALIAS("platform:as3722-wdt");
> +MODULE_DESCRIPTION("AMS AS3722 watchdog timer driver");
> +MODULE_AUTHOR("Bibek Basu <bbasu@nvidia.com>");
> +MODULE_LICENSE("GPL v2");
> diff --git a/include/linux/mfd/as3722.h b/include/linux/mfd/as3722.h
> index 16bf8a0..9290fd6 100644
> --- a/include/linux/mfd/as3722.h
> +++ b/include/linux/mfd/as3722.h
> @@ -336,6 +336,7 @@
>   #define AS3722_WATCHDOG_TIMER_MAX			0x7F
>   #define AS3722_WATCHDOG_ON				BIT(0)
>   #define AS3722_WATCHDOG_SW_SIG				BIT(0)
> +#define AS3722_WATCHDOG_MODE_MASK                       0x06
>
>   #define AS3722_EXT_CONTROL_ENABLE1			0x1
>   #define AS3722_EXT_CONTROL_ENABLE2			0x2
>

