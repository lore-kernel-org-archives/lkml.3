Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893Ab3CXJSL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 05:18:11 -0400
Received: from mail.active-venture.com ([67.228.131.205]:62307 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742Ab3CXJR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 05:17:56 -0400
X-Originating-IP: 108.223.40.66
Date: Sat, 23 Mar 2013 20:19:26 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Ian Lartey <ian@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-leds@vger.kernel.org,
        linux-watchdog@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        swarren@wwwdotorg.org, grant.likely@secretlab.ca,
        broonie@opensource.wolfsonmicro.com, rob.h@jasper.es
Subject: Re: [PATCH v10 04/12] watchdog: add Palmas Watchdog support
Message-ID: <20130324031926.GA26545@roeck-us.net>
References: <1363964122-19201-1-git-send-email-ian@slimlogic.co.uk>
 <1363964122-19201-5-git-send-email-ian@slimlogic.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363964122-19201-5-git-send-email-ian@slimlogic.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 22, 2013 at 02:55:14PM +0000, Ian Lartey wrote:
> From: Graeme Gregory <gg@slimlogic.co.uk>
> 
> Add support for the Palmas watchdog timer which has a timeout configurable
> from 1s to 128s.
> 
> Signed-off-by: Graeme Gregory <gg@slimlogic.co.uk>
> Signed-off-by: Ian Lartey <ian@slimlogic.co.uk>
> ---
>  drivers/watchdog/palmas_wdt.c |  169 +++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 169 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/watchdog/palmas_wdt.c
> 
> diff --git a/drivers/watchdog/palmas_wdt.c b/drivers/watchdog/palmas_wdt.c
> new file mode 100644
> index 0000000..da7e379
> --- /dev/null
> +++ b/drivers/watchdog/palmas_wdt.c
> @@ -0,0 +1,169 @@
> +/*
> + * Driver for Watchdog part of Palmas PMIC Chips
> + *
> + * Copyright 2011-2013 Texas Instruments Inc.
> + *
> + * Author: Graeme Gregory <gg@slimlogic.co.uk>
> + * Author: Ian Lartey <ian@slimlogic.co.uk>
> + *
> + * Based on twl4030_wdt.c
> + *
> + * Author: Timo Kokkonen <timo.t.kokkonen at nokia.com>
> + *
> + *  This program is free software; you can redistribute it and/or modify it
> + *  under  the terms of the GNU General  Public License as published by the
> + *  Free Software Foundation;  either version 2 of the License, or (at your
> + *  option) any later version.
> + *
> + */
> +
> +#include <linux/module.h>
> +#include <linux/types.h>
> +#include <linux/slab.h>
> +#include <linux/kernel.h>
> +#include <linux/fs.h>
> +#include <linux/watchdog.h>
> +#include <linux/platform_device.h>
> +#include <linux/watchdog.h>
> +#include <linux/mfd/palmas.h>
> +
> +struct palmas_wdt {
> +	struct palmas *palmas;
> +	struct watchdog_device wdt;
> +	struct device *dev;
> +
> +	int timer_margin;
> +};
> +
> +
One empty line would be sufficient.

> +static int nowayout = WATCHDOG_NOWAYOUT;
> +module_param(nowayout, int, 0);
> +MODULE_PARM_DESC(nowayout, "Watchdog cannot be stopped once started "
> +	"(default=" __MODULE_STRING(WATCHDOG_NOWAYOUT) ")");
> +
> +static int palmas_wdt_write(struct palmas *palmas, unsigned int data)
> +{
> +	unsigned int addr;
> +
> +	addr = PALMAS_BASE_TO_REG(PALMAS_PMU_CONTROL_BASE, PALMAS_WATCHDOG);
> +
> +	return palmas_write(palmas, PALMAS_PMU_CONTROL_BASE, addr, addr);

2 x addr ? Should the second one (last parameter) be data ?

> +}
> +
> +static int palmas_wdt_enable(struct watchdog_device *wdt)
> +{
> +	struct palmas_wdt *driver_data = watchdog_get_drvdata(wdt);
> +	struct palmas *palmas = driver_data->palmas;
> +
> +	return palmas_wdt_write(palmas, driver_data->timer_margin |
> +				PALMAS_WATCHDOG_ENABLE);
> +}
> +
> +static int palmas_wdt_disable(struct watchdog_device *wdt)
> +{
> +	struct palmas_wdt *driver_data = watchdog_get_drvdata(wdt);
> +	struct palmas *palmas = driver_data->palmas;
> +
> +	return palmas_wdt_write(palmas, driver_data->timer_margin);

Just wondering - why not just write 0 ?

> +}
> +
> +static int palmas_wdt_set_timeout(struct watchdog_device *wdt, unsigned timeout)
> +{
> +	struct palmas_wdt *driver_data = watchdog_get_drvdata(wdt);
> +
> +	if (timeout < 1 || timeout > 128) {
> +		dev_warn(driver_data->dev,
> +			"Timeout can only be in the range [1-128] seconds");
> +		return -EINVAL;
> +	}
The watchdog core supports limit checking. Might as well use it.

On a side note, it might be an interesting experience if you try setting
a value of 0 or larger than 128. Unless I am missing something,
driver_data->dev is never initialized.

> +	driver_data->timer_margin = fls(timeout) - 1;
> +	return 0;
> +}
> +
> +static const struct watchdog_info palmas_wdt_info = {
> +	.options = WDIOF_SETTIMEOUT | WDIOF_KEEPALIVEPING | WDIOF_MAGICCLOSE,
> +	.identity = "Palmas Watchdog",
> +	.firmware_version = 0,
> +};
> +
> +static const struct watchdog_ops palmas_wdt_ops = {
> +	.owner = THIS_MODULE,
> +	.start = palmas_wdt_enable,
> +	.stop = palmas_wdt_disable,
> +	.ping = palmas_wdt_enable,
> +	.set_timeout = palmas_wdt_set_timeout,
> +};
> +
> +static int palmas_wdt_probe(struct platform_device *pdev)
> +{
> +	struct palmas *palmas = dev_get_drvdata(pdev->dev.parent);
> +	struct palmas_wdt *driver_data;
> +	struct watchdog_device *palmas_wdt;
> +	int ret = 0;
> +
> +	driver_data = devm_kzalloc(&pdev->dev, sizeof(*driver_data),
> +				   GFP_KERNEL);
> +	if (!driver_data) {
> +		dev_err(&pdev->dev, "Unable to alloacate watchdog device\n");

AFAIK devm_ functions already issue a message on errors, so it is unnecessary
to issue another one here.

> +		ret = -ENOMEM;
> +		goto err;
> +	}
> +
> +	driver_data->palmas = palmas;
> +
> +	palmas_wdt = &driver_data->wdt;
> +
> +	palmas_wdt->info = &palmas_wdt_info;
> +	palmas_wdt->ops = &palmas_wdt_ops;
> +	watchdog_set_nowayout(palmas_wdt, nowayout);
> +	watchdog_set_drvdata(palmas_wdt, driver_data);
> +

There is no call to watchdog_init_timeout, and the timeout value is not initialized
in palmas_wdt. So the driver depends on the limit being set from user space
with WDIOC_SETTIMEOUT. But that can not happen until after it was opened
and started, meaning it is initially 0 when the watchdog is started.
Is that on purpose ? A more common default would be 60 seconds.

Also, if user space does not explicitly set the timeout but requests it
with WDIOC_GETTIMEOUT, it will get a value of 0.

> +	ret = watchdog_register_device(&driver_data->wdt);
> +	if (ret) {
> +		platform_set_drvdata(pdev, NULL);

It is unnecessary to set the platform data to NULL. Besides, it isn't
even set yet (you only set it with dev_set_drvdata below).

> +		goto err;
> +	}
> +
> +	dev_set_drvdata(&pdev->dev, driver_data);

Might use platform_set_drvdata.

> +
> +	return 0;
> +err:
> +	return ret;

Personal style, but I think this is unnecessary. Coding style examples suggest
to return directly in such cases (ie if there is no cleanup to do).

> +}
> +
> +static int palmas_wdt_remove(struct platform_device *pdev)
> +{
> +	struct palmas_wdt *driver_data = dev_get_drvdata(&pdev->dev);
> +
platform_get_drvdata ?

> +	watchdog_unregister_device(&driver_data->wdt);
> +
> +	return 0;
> +}
> +
> +static struct of_device_id of_palmas_match_tbl[] = {
> +	{ .compatible = "ti,palmas-wdt", },
> +	{ .compatible = "ti,twl6035-wdt", },
> +	{ .compatible = "ti,twl6036-wdt", },
> +	{ .compatible = "ti,twl6037-wdt", },
> +	{ .compatible = "ti,tps65913-wdt", },
> +	{ .compatible = "ti,tps65914-wdt", },
> +	{ .compatible = "ti,tps80036-wdt", },
> +	{ /* end */ }
> +};
> +
> +static struct platform_driver palmas_wdt_driver = {
> +	.probe = palmas_wdt_probe,
> +	.remove = palmas_wdt_remove,
> +	.driver = {
> +		.owner = THIS_MODULE,
> +		.of_match_table = of_palmas_match_tbl,
> +		.name = "palmas-wdt",
> +	},
> +};
> +
> +module_platform_driver(palmas_wdt_driver);
> +
> +MODULE_AUTHOR("Graeme Gregory <gg@slimlogic.co.uk>");
> +MODULE_LICENSE("GPL");
> +MODULE_ALIAS("platform:palmas-wdt");
> +MODULE_DEVICE_TABLE(of, of_palmas_match_tbl);
> -- 
> 1.7.0.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 
> 
