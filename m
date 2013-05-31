Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501Ab3EaKgc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 06:36:32 -0400
Received: from mail.active-venture.com ([67.228.131.205]:55201 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879Ab3EaKgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 06:36:25 -0400
X-Originating-IP: 108.223.40.66
Date: Fri, 31 May 2013 03:36:54 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Johannes Thumshirn <johannes.thumshirn@men.de>
Cc: wim@iguana.be, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 1/2] watchdog: New watchdog driver for MEN A21
 watchdogs
Message-ID: <20130531103654.GB5619@roeck-us.net>
References: <20130531085842.GA8572@jtlinux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130531085842.GA8572@jtlinux>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 10:58:48AM +0200, Johannes Thumshirn wrote:
> This patch adds the driver for the watchdog devices found on MEN Mikro
> Elektronik A21 VMEbus CPU Carrier Boards. It has DT-support and uses the
> watchdog framework.
> 
> Revision 2:
> * Removed unneeded open flag in struct a21_wdt_drv
> * Corrected 3bit reason code from gpio
> * Additional sysfs files are now part of watchdog sysfs
> * Changed OFF/ON delay in ping from 400ms to 10ns
> * Reworked timeout setting
> * Removed a21_wdt_ioctl(...)
> 
> Revision 3:
> * Changed pr_{err,info} to dev_{err,info}
> * Removed out of memory error print
> * Transition from "fast" to "slow" mode not allowed by chip
> 
> Revision 4:
> * Remove reboot_notifier and place disable code into platform_device's shutdown function
> * Removed sysfs interface
> 
> Revision 5:
> 
> * Added setting of .bootstatus on driver init
> * Added initial timeout on driver init
> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@men.de>
> ---
>  MAINTAINERS                   |    6 ++
>  drivers/watchdog/Kconfig      |    8 ++
>  drivers/watchdog/Makefile     |    1 +
>  drivers/watchdog/mena21_wdt.c |  234 +++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 249 insertions(+)
>  create mode 100644 drivers/watchdog/mena21_wdt.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 7714c3c..023945a 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5307,6 +5307,12 @@ F:	drivers/mtd/
>  F:	include/linux/mtd/
>  F:	include/uapi/mtd/
> 
> +MEN A21 WATCHDOG DRIVER
> +M:  	Johannes Thumshirn <johannes.thumshirn@men.de>
> +L:	linux-watchdog@vger.kernel.org
> +S:	Supported
> +F:	drivers/watchdog/mena21_wdt.c
> +
>  METAG ARCHITECTURE
>  M:	James Hogan <james.hogan@imgtec.com>
>  S:	Supported
> diff --git a/drivers/watchdog/Kconfig b/drivers/watchdog/Kconfig
> index e89fc31..192b84d 100644
> --- a/drivers/watchdog/Kconfig
> +++ b/drivers/watchdog/Kconfig
> @@ -1172,6 +1172,14 @@ config BOOKE_WDT_DEFAULT_TIMEOUT
> 
>  	  The value can be overridden by the wdt_period command-line parameter.
> 
> +config MEN_A21_WDT
> +       tristate "MEN A21 VME CPU Carrier Board Watchdog Timer"
> +       select WATCHDOG_CORE
> +       help
> +        Watchdog driver for MEN A21 VMEbus CPU Carrier Boards.
> +
> +	If unsure select N here.
> +
>  # PPC64 Architecture
> 
>  config WATCHDOG_RTAS
> diff --git a/drivers/watchdog/Makefile b/drivers/watchdog/Makefile
> index a300b94..bffdcb1 100644
> --- a/drivers/watchdog/Makefile
> +++ b/drivers/watchdog/Makefile
> @@ -143,6 +143,7 @@ obj-$(CONFIG_8xxx_WDT) += mpc8xxx_wdt.o
>  obj-$(CONFIG_MV64X60_WDT) += mv64x60_wdt.o
>  obj-$(CONFIG_PIKA_WDT) += pika_wdt.o
>  obj-$(CONFIG_BOOKE_WDT) += booke_wdt.o
> +obj-$(CONFIG_MEN_A21_WDT) += mena21_wdt.o
> 
>  # PPC64 Architecture
>  obj-$(CONFIG_WATCHDOG_RTAS) += wdrtas.o
> diff --git a/drivers/watchdog/mena21_wdt.c b/drivers/watchdog/mena21_wdt.c
> new file mode 100644
> index 0000000..e586c2e
> --- /dev/null
> +++ b/drivers/watchdog/mena21_wdt.c
> @@ -0,0 +1,234 @@
> +/*
> + * Watchdog driver for the A21 VME CPU Boards
> + *
> + * Copyright (C) 2013 MEN Mikro Elektronik Nuernberg GmbH
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation
> + */
> +#include <linux/module.h>
> +#include <linux/moduleparam.h>
> +#include <linux/types.h>
> +#include <linux/kernel.h>
> +#include <linux/slab.h>
> +#include <linux/platform_device.h>
> +#include <linux/watchdog.h>
> +#include <linux/uaccess.h>
> +#include <linux/gpio.h>
> +#include <linux/delay.h>
> +#include <linux/bitops.h>
> +
> +#define GPIO_WD_ENAB	169
> +#define GPIO_WD_FAST	170
> +#define GPIO_WD_TRIG	171
> +
> +#define GPIO_RST_CAUSE_BASE 166
> +
> +struct a21_wdt_drv {
> +	struct watchdog_device wdt;
> +	struct mutex lock;
> +};
> +
> +static bool nowayout = WATCHDOG_NOWAYOUT;
> +module_param(nowayout, bool, 0);
> +MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default="
> +			    __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
> +
> +static int a21_wdt_get_bootstatus(unsigned int *reset)
> +{
> +	int i;
> +
> +	for (i = 0; i < 3; i++)
> +		*reset |= gpio_get_value(GPIO_RST_CAUSE_BASE + i)
> +			? (1 << i) : 0;
> +
> +	if (*reset >= 8)
> +		return -EINVAL;
> +
> +	return 0;
> +}
> +
> +static int a21_wdt_start(struct watchdog_device *wdt)
> +{
> +	struct a21_wdt_drv *drv = watchdog_get_drvdata(wdt);
> +
> +	mutex_lock(&drv->lock);
> +
> +	gpio_set_value(GPIO_WD_ENAB, 1);
> +
> +	mutex_unlock(&drv->lock);
> +
> +	return 0;
> +}
> +
> +static int a21_wdt_stop(struct watchdog_device *wdt)
> +{
> +	struct a21_wdt_drv *drv = watchdog_get_drvdata(wdt);
> +
> +	/* We don't stop if WDOG_NO_WAY_OUT is set */
> +	if (test_bit(WDOG_NO_WAY_OUT, &wdt->status))
> +		return -EINVAL;
> +
> +	mutex_lock(&drv->lock);
> +
> +	gpio_set_value(GPIO_WD_ENAB, 0);
> +
> +	mutex_unlock(&drv->lock);
> +
> +	return 0;
> +}
> +
> +static int a21_wdt_ping(struct watchdog_device *wdt)
> +{
> +	struct a21_wdt_drv *drv = watchdog_get_drvdata(wdt);
> +
> +	mutex_lock(&drv->lock);
> +
> +	gpio_set_value(GPIO_WD_TRIG, 0);
> +	ndelay(10);
> +	gpio_set_value(GPIO_WD_TRIG, 1);
> +
> +	mutex_unlock(&drv->lock);
> +
> +	return 0;
> +}
> +
> +static int a21_wdt_set_timeout(struct watchdog_device *wdt,
> +			       unsigned int timeout)
> +{
> +	struct a21_wdt_drv *drv = watchdog_get_drvdata(wdt);
> +
> +	if (timeout != 1 && timeout != 30) {
> +		dev_err(wdt->dev, "Only 1 and 30 allowed as timeout\n");
> +		return -EINVAL;
> +	}
> +
> +	if (timeout == 30 && wdt->timeout == 1) {
> +		dev_err(wdt->dev,
> +			"Transition from fast to slow mode not allowed\n");
> +		return -EINVAL;
> +	}
> +
> +	mutex_lock(&drv->lock);
> +
> +	if (timeout == 1)
> +		gpio_set_value(GPIO_WD_FAST, 1);
> +	else
> +		gpio_set_value(GPIO_WD_FAST, 0);
> +
> +	wdt->timeout = timeout;
> +
> +	mutex_unlock(&drv->lock);
> +
> +	return 0;
> +}
> +
> +static const struct watchdog_info a21_wdt_info = {
> +	.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING | WDIOF_MAGICCLOSE,
> +	.identity = "MEN A21 Watchdog",
> +};
> +
> +static const struct watchdog_ops a21_wdt_ops = {
> +	.owner = THIS_MODULE,
> +	.start = a21_wdt_start,
> +	.stop = a21_wdt_stop,
> +	.ping = a21_wdt_ping,
> +	.set_timeout = a21_wdt_set_timeout,
> +};
> +
> +static struct watchdog_device a21_wdt = {
> +	.info = &a21_wdt_info,
> +	.ops = &a21_wdt_ops,
> +	.min_timeout = 1,
> +	.max_timeout = 30,
> +};
> +
> +static int a21_wdt_probe(struct platform_device *pdev)
> +{
> +	struct a21_wdt_drv *drv;
> +	unsigned int reset = 0;
> +	int ret;
> +
> +	dev_info(&pdev->dev, "MEN A21 watchdog timer driver enabled\n");
> +
> +	drv = devm_kzalloc(&pdev->dev, sizeof(struct a21_wdt_drv), GFP_KERNEL);
> +	if (!drv)
> +		return -ENOMEM;
> +
> +	mutex_init(&drv->lock);
> +	watchdog_set_nowayout(&a21_wdt, nowayout);
> +	watchdog_set_drvdata(&a21_wdt, drv);
> +
> +	ret = watchdog_register_device(&a21_wdt);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Cannot register watchdog device\n");
> +		goto err_register_wd;
> +	}
> +
> +	a21_wdt.timeout = 30;

It would be better to use watchdog_init_timeout(), as it automatically
supports setting the timeout through an fdt property. It should be set
before registering the device with the watchdog subsystem.

Thanks,
Guenter

> +	ret = a21_wdt_get_bootstatus(&reset);
> +	if (ret)
> +		dev_warn(&pdev->dev, "Reset Cause contains invalid data\n");
> +	else {
> +		if (reset == 2)
> +			a21_wdt.bootstatus |= WDIOF_EXTERN1;
> +		else if (reset == 4)
> +			a21_wdt.bootstatus |= WDIOF_CARDRESET;
> +		else if (reset == 5)
> +			a21_wdt.bootstatus |= WDIOF_POWERUNDER;
> +		else if (reset == 7)
> +			a21_wdt.bootstatus |= WDIOF_EXTERN2;
> +	}
> +
> +	dev_set_drvdata(&pdev->dev, drv);
> +
> +	return 0;
> +
> +err_register_wd:
> +	mutex_destroy(&drv->lock);
> +
> +	return ret;
> +}
> +
> +static int a21_wdt_remove(struct platform_device *pdev)
> +{
> +	struct a21_wdt_drv *drv = dev_get_drvdata(&pdev->dev);
> +
> +	dev_warn(&pdev->dev,
> +		"Unregistering A21 watchdog driver, board may reboot\n");
> +
> +
> +	watchdog_unregister_device(&drv->wdt);
> +
> +	mutex_destroy(&drv->lock);
> +
> +	return 0;
> +}
> +
> +static void a21_wdt_shutdown(struct platform_device *pdev)
> +{
> +	gpio_set_value(GPIO_WD_ENAB, 0);
> +}
> +
> +static const struct of_device_id a21_wdt_ids[] = {
> +	{ .compatible = "men,a021-wdt" },
> +	{ },
> +};
> +
> +static struct platform_driver a21_wdt_driver = {
> +	.probe = a21_wdt_probe,
> +	.remove = a21_wdt_remove,
> +	.shutdown = a21_wdt_shutdown,
> +	.driver = {
> +		.name = "a21-watchdog",
> +		.of_match_table = a21_wdt_ids,
> +	},
> +};
> +
> +module_platform_driver(a21_wdt_driver);
> +
> +MODULE_AUTHOR("MEN Mikro Elektronik");
> +MODULE_DESCRIPTION("MEN A21 Watchdog");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS("platform:a21-watchdog");
> --
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-watchdog" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
