Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469Ab3EMWoa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 18:44:30 -0400
Received: from mail.active-venture.com ([67.228.131.205]:59950 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338Ab3EMWo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 18:44:29 -0400
X-Originating-IP: 108.223.40.66
Date: Mon, 13 May 2013 15:44:40 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: johannes.thumshirn@men.de
Cc: wim@iguana.be, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] watchdog: New watchdog driver for MEN A21 watchdogs
Message-ID: <20130513224440.GA13891@roeck-us.net>
References: <1368478709-2889-1-git-send-email-johannes.thumshirn@men.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368478709-2889-1-git-send-email-johannes.thumshirn@men.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 13, 2013 at 10:58:29PM +0200, johannes.thumshirn@men.de wrote:
> From: Johannes Thumshirn <johannes.thumshirn@men.de>
> 
> This patch adds the driver for the watchdog devices found on MEN Mikro
> Elektronik A21 VMEbus CPU Carrier Boards. It has DT-support and uses the
> watchdog framework.
> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@men.de>

Besides all of its problems, seems to me that could (or should) be a generic gpio
watchdog driver, possibly with device tree bindings describing how the various 
gpio pins are used.

> ---
>  MAINTAINERS                   |    6 +
>  drivers/watchdog/Kconfig      |    8 +
>  drivers/watchdog/Makefile     |    1 +
>  drivers/watchdog/mena21_wdt.c |  351 +++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 366 insertions(+)
>  create mode 100644 drivers/watchdog/mena21_wdt.c
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 3d7782b..3e5b3f1 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5291,6 +5291,12 @@ F:	drivers/mtd/
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
> index 0000000..d534f81
> --- /dev/null
> +++ b/drivers/watchdog/mena21_wdt.c
> @@ -0,0 +1,351 @@
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
> +#include <linux/reboot.h>
> +#include <linux/bitops.h>
> +
> +static char *reset_causes[] = {
> +	"Power On Reset",
> +	"CPU Reset Request",
> +	"Push Button",
> +	"FPGA Reset Request",
> +	"Watchdog",
> +	"Local Power Bad",
> +	"Invalid",
> +	"BDI",
> +};
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
> +	bool open;
> +};
> +
> +static bool nowayout = WATCHDOG_NOWAYOUT;
> +module_param(nowayout, bool, 0);
> +MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started (default="
> +			    __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
> +
> +static ssize_t rebootcause_show(struct device *dev,
> +				struct device_attribute *attr,
> +				char *buf)
> +{
> +	unsigned int reset = 0;
> +	int i;
> +
> +	for (i = 0; i < 3; i++)
> +		reset |= !!gpio_get_value(GPIO_RST_CAUSE_BASE + i);

	The result of !! is 0 or 1, so reset will never be larger than 1.

	Not sure if using fixed numbers for gpio pins is a good idea or even
	correct. You might want to pass that by the gpio maintainers.

> +
> +	if (reset >= 8)
> +		return -EIO;
> +
	Meaning this will never happen.

> +	return sprintf(buf, "%s\n", reset_causes[reset]);
> +}
> +static DEVICE_ATTR(rebootcause, S_IRUGO, rebootcause_show, NULL);
> +
> +static ssize_t active_show(struct device *dev, struct device_attribute *attr,
> +			   char *buf)
> +{
> +	return sprintf(buf, "%d\n", !!gpio_get_value(GPIO_WD_ENAB));
> +}
> +static DEVICE_ATTR(active, S_IRUGO, active_show, NULL);
> +
> +static ssize_t allow_disable_show(struct device *dev,
> +				  struct device_attribute *attr,
> +				  char *buf)
> +{
> +	return sprintf(buf, "%d\n", !nowayout);
> +}
> +static DEVICE_ATTR(allow_disable, S_IRUGO, allow_disable_show, NULL);
> +
> +static ssize_t fastmode_show(struct device *dev, struct device_attribute *attr,
> +			     char *buf)
> +{
> +	return sprintf(buf, "%d\n", !!gpio_get_value(GPIO_WD_FAST));
> +}
> +static DEVICE_ATTR(fastmode, S_IRUGO, fastmode_show, NULL);
> +
> +static int a21_wdt_create_files(struct device *dev)
> +{
> +	int ret;
> +
> +	ret = device_create_file(dev, &dev_attr_rebootcause);
> +	if (ret)
> +		return ret;
> +	ret = device_create_file(dev, &dev_attr_active);
> +	if (ret)
> +		return ret;
> +	ret = device_create_file(dev, &dev_attr_allow_disable);
> +	if (ret)
> +		return ret;
> +	ret = device_create_file(dev, &dev_attr_fastmode);


Wonder if the maintainer will let you bypass the infrastructure with those
attributes. I wouldn't.

> +	if (ret)
> +		return ret;
> +
> +	return 0;
> +}
> +
> +static void a21_wdt_remove_files(struct device *dev)
> +{
> +	device_remove_file(dev, &dev_attr_rebootcause);
> +	device_remove_file(dev, &dev_attr_active);
> +	device_remove_file(dev, &dev_attr_allow_disable);
> +	device_remove_file(dev, &dev_attr_fastmode);
> +}
> +
> +static int a21_wdt_start(struct watchdog_device *wdt)
> +{
> +	struct a21_wdt_drv *drv = watchdog_get_drvdata(wdt);
> +
> +	mutex_lock(&drv->lock);
> +
> +	drv->open = true;

What is this flag for ?

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
> +	drv->open = false;
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
> +	msleep(400);

Pretty long sleep. You really want to put applications to sleep for that long
when pinging the watchdog ? I'd be more than a bit concerned that this might be
problematic for applications expecting to do something else besides sleeping in
a watchdog ping call.

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
> +	if (timeout != 1 || timeout != 30) {

Hmmm ... did you ever try to set the timeout ?

> +		pr_err("Only 1 and 30 allowed as timeout\n");

dev_err is preferred for messages, but I wonder what value you expect
from this message (and other similar messages) in the error log.

> +		return -EINVAL;
> +	}
> +
> +	mutex_lock(&drv->lock);
> +
> +	if (timeout == 30)
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
> +static long a21_wdt_ioctl(struct watchdog_device *wdt, unsigned int cmd,
> +			 unsigned long arg)
> +{
> +	unsigned int timeout;
> +	int ret;
> +	int __user *argp = (void __user *) arg;
> +
> +	switch (cmd) {
> +	case WDIOC_GETSUPPORT:
> +		return copy_to_user(argp,
> +				     wdt->info, sizeof(struct watchdog_info));
> +	case WDIOC_KEEPALIVE:
> +		return a21_wdt_ping(wdt);
> +	case WDIOC_SETTIMEOUT:
> +		ret = get_user(timeout, argp);
> +		if (ret)
> +			return ret;
> +		a21_wdt_set_timeout(wdt, timeout);
> +		/* Fallthrough */
> +	case WDIOC_GETTIMEOUT:
> +		return put_user(wdt->timeout, argp);
> +	case WDIOC_SETOPTIONS: {
> +		int options;
> +
> +		ret = get_user(options, argp);
> +		if (ret)
> +			return ret;
> +		if (options & WDIOS_DISABLECARD)
> +			a21_wdt_stop(wdt);
> +		if (options & WDIOS_ENABLECARD)
> +			a21_wdt_start(wdt);
> +		break;
> +	}
> +	default:
> +		pr_err("IOCTL 0x%x not understood\n", cmd);
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
What does this function offer that is not in the infrastructure ?

> +
> +static int a21_wdt_notify_sys(struct notifier_block *notify, unsigned long code,
> +			void *unused)
> +{
> +	if (code == SYS_DOWN || code == SYS_HALT)
> +		gpio_set_value(GPIO_WD_ENAB, 0);
> +
> +	return NOTIFY_DONE;
> +}
> +
> +static struct notifier_block a21_wdt_notifier = {
> +	.notifier_call = a21_wdt_notify_sys,
> +};
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
> +	.ioctl = a21_wdt_ioctl,
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
> +	int ret;
> +
> +	pr_info("MEN A21 watchdog timer driver enabled\n");
> +
pr_ -> dev_ 

> +	drv = devm_kzalloc(&pdev->dev, sizeof(struct a21_wdt_drv), GFP_KERNEL);
> +	if (!drv) {
> +		dev_err(&pdev->dev,
> +			"Unable to allocate memory for watchdog device\n");
> +		return -ENOMEM;
> +	}
> +
> +	mutex_init(&drv->lock);
> +	watchdog_set_nowayout(&a21_wdt, nowayout);
> +	watchdog_set_drvdata(&a21_wdt, drv);
> +
> +	ret = watchdog_register_device(&a21_wdt);
> +	if (ret) {
> +		pr_err("Cannot register watchdog device\n");
> +		goto err_register_wd;
> +	}
> +
> +	ret = register_reboot_notifier(&a21_wdt_notifier);
> +	if (ret) {
> +		pr_err("Cannot register reboot notifier\n");
> +		goto err_register_notif;
> +	}
> +
> +	ret = a21_wdt_create_files(&pdev->dev);
> +	if (ret) {
> +		dev_err(&pdev->dev, "Cannot create sysfs entries\n");
> +		goto err_create_sysfs;
> +	}
> +
> +	dev_set_drvdata(&pdev->dev, drv);
> +
> +	return 0;
> +
> +err_create_sysfs:
> +	unregister_reboot_notifier(&a21_wdt_notifier);
> +err_register_notif:
> +	watchdog_unregister_device(&drv->wdt);
> +err_register_wd:
> +	mutex_destroy(&drv->lock);
> +	devm_kfree(&pdev->dev, drv);

You might want to look into the reasons for using devm_ functions.

> +
> +	return ret;
> +}
> +
> +static int a21_wdt_remove(struct platform_device *pdev)
> +{
> +	struct a21_wdt_drv *drv = dev_get_drvdata(&pdev->dev);
> +
> +	pr_warn("Unregistering A21 watchdog driver, board may reboot\n");
> +
> +	a21_wdt_remove_files(&pdev->dev);
> +
> +	watchdog_unregister_device(&drv->wdt);
> +	unregister_reboot_notifier(&a21_wdt_notifier);
> +	
> +	mutex_destroy(&drv->lock);
> +	devm_kfree(&pdev->dev, drv);
> +
> +	return 0;
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
