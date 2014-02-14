Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752564AbaBNRYj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 12:24:39 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:46683 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751385AbaBNRYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 12:24:38 -0500
Date: Fri, 14 Feb 2014 09:24:34 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Laszlo Papp <lpapp@kde.org>
Cc: jdelvare@suse.de, lm-sensors@lm-sensors.org, lee.jones@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mfd: MAX6650/6651 support
Message-ID: <20140214172434.GA23195@roeck-us.net>
References: <1392369342-11472-1-git-send-email-lpapp@kde.org>
 <1392369342-11472-2-git-send-email-lpapp@kde.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392369342-11472-2-git-send-email-lpapp@kde.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 14, 2014 at 09:15:41AM +0000, Laszlo Papp wrote:
> MAX6650/MAX6651 chip is a multi-function device with I2C busses. The
> chip includes fan-speed regulators and monitors, GPIO, and alarm.
> 
> This patch is an initial release of a MAX6650/6651 MFD driver that
> supports to enable the chip with its primary I2C bus that will connect
> the hwmon, and then the gpio devices for now.
> 
> Signed-off-by: Laszlo Papp <lpapp@kde.org>
> ---
>  drivers/mfd/Kconfig                 | 11 +++++
>  drivers/mfd/Makefile                |  1 +
>  drivers/mfd/max665x.c               | 94 +++++++++++++++++++++++++++++++++++++
>  include/linux/mfd/max665x-private.h | 34 ++++++++++++++
>  4 files changed, 140 insertions(+)
>  create mode 100644 drivers/mfd/max665x.c
>  create mode 100644 include/linux/mfd/max665x-private.h
> 
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index 49bb445..a6c3152 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -368,6 +368,17 @@ config MFD_MAX8907
>  	  accessing the device; additional drivers must be enabled in order
>  	  to use the functionality of the device.
>  
> +config MFD_MAX665X
> +	bool "Maxim Semiconductor MAX6650/MAX6651 Support"
> +	depends on I2C
> +	select MFD_CORE
> +	select REGMAP_I2C
> +	help
> +	  Say yes here to add support for Maxim Semiconductor MAX6650/MAX6651. This
> +	  is a fan speed regulator and monitor IC. This driver provides common
> +	  support for accessing the device, additional drivers must be enabled in
> +	  order to use the functionality of the device.
> +
>  config MFD_MAX8925
>  	bool "Maxim Semiconductor MAX8925 PMIC Support"
>  	depends on I2C=y
> diff --git a/drivers/mfd/Makefile b/drivers/mfd/Makefile
> index 5aea5ef..63668c5 100644
> --- a/drivers/mfd/Makefile
> +++ b/drivers/mfd/Makefile
> @@ -111,6 +111,7 @@ obj-$(CONFIG_MFD_DA9055)	+= da9055.o
>  da9063-objs			:= da9063-core.o da9063-irq.o da9063-i2c.o
>  obj-$(CONFIG_MFD_DA9063)	+= da9063.o
>  
> +obj-$(CONFIG_MFD_MAX665X)	+= max665x.o
>  obj-$(CONFIG_MFD_MAX14577)	+= max14577.o
>  obj-$(CONFIG_MFD_MAX77686)	+= max77686.o max77686-irq.o
>  obj-$(CONFIG_MFD_MAX77693)	+= max77693.o max77693-irq.o
> diff --git a/drivers/mfd/max665x.c b/drivers/mfd/max665x.c
> new file mode 100644
> index 0000000..80672d7
> --- /dev/null
> +++ b/drivers/mfd/max665x.c
> @@ -0,0 +1,94 @@
> +/*
> + * Device access for MAX6650-MAX6651
> + *
> + * Copyright(c) 2013 Polatis Ltd.
> + *
> + * Author: Laszlo Papp <laszlo.papp@polatis.com>
> + *
> + *  This program is free software; you can redistribute  it and/or modify it
> + *  under  the terms of  the GNU General  Public License as published by the
> + *  Free Software Foundation;  either version 2 of the  License, or (at your
> + *  option) any later version.
> + */
> +
> +#include <linux/device.h>
> +#include <linux/mfd/core.h>
> +#include <linux/module.h>
> +#include <linux/i2c.h>
> +
> +#include <linux/mfd/max665x-private.h>
> +
> +static struct mfd_cell max665x_devs[] = {
> +	{ .name = "max6651-gpio", },
> +	{ .name = "max6650", }, /* hwmon driver */
> +	{},
> +};
> +
> +static const struct regmap_config max665x_regmap_config = {
> +	.reg_bits = 8,
> +	.val_bits = 8,
> +};
> +
> +static int max665x_probe(struct i2c_client *i2c,
> +			    const struct i2c_device_id *id)
> +{
> +	struct max665x_dev *max665x;
> +	int ret;
> +
> +	max665x = devm_kzalloc(&i2c->dev, sizeof(*max665x), GFP_KERNEL);
> +	if (!max665x)
> +		return -ENOMEM;
> +
> +	i2c_set_clientdata(i2c, max665x);
> +	max665x->dev = &i2c->dev;
> +	max665x->i2c = i2c;
> +	max665x->map = devm_regmap_init_i2c(i2c, &max665x_regmap_config);
> +	if (IS_ERR(max665x->map)) {
> +		ret = PTR_ERR(max665x->map);
> +		dev_err(max665x->dev, "Failed to allocate register map: %d\n",
> +			ret);
> +		return ret;
> +	}
> +
> +	mutex_init(&max665x->iolock);
> +
> +	ret = mfd_add_devices(max665x->dev, -1, max665x_devs,
> +			ARRAY_SIZE(max665x_devs),
> +			NULL, 0, NULL);
> +
> +	if (ret < 0)
> +		dev_err(max665x->dev, "failed to register child devices\n");
> +
> +	return ret;
> +}
> +
> +static int max665x_remove(struct i2c_client *i2c)
> +{
> +	struct max665x_dev *max665x = i2c_get_clientdata(i2c);
> +
> +	mfd_remove_devices(max665x->dev);
> +
> +	return 0;
> +}
> +
> +static struct of_device_id max665x_dt_match[] = {
> +	{ .compatible = "maxim,max665x" },

There was a separate patch to provide actual device types, which I would
suggest to merge with this one.

> +	{},
> +};
> +MODULE_DEVICE_TABLE(of, max665x_dt_match);
> +
> +static struct i2c_driver max665x_driver = {
> +	.driver = {
> +		.name = "max665x",
> +		.owner = THIS_MODULE,
> +		.of_match_table = max665x_dt_match,
> +	},

The 'legacy' means to instantiate i2c devices will need to be supported
for non-DT systems.

> +	.probe = max665x_probe,
> +	.remove = max665x_remove,
> +};
> +
> +module_i2c_driver(max665x_driver);
> +
> +MODULE_AUTHOR("Laszlo Papp <laszlo.papp@polatis.com>");
> +MODULE_DESCRIPTION("MAX6650-MAX6651 MFD");
> +MODULE_LICENSE("GPL");
> diff --git a/include/linux/mfd/max665x-private.h b/include/linux/mfd/max665x-private.h
> new file mode 100644
> index 0000000..293db4b
> --- /dev/null
> +++ b/include/linux/mfd/max665x-private.h
> @@ -0,0 +1,34 @@
> +/*
> + * max665x-private.h - Driver for the Maxim 6650/6651
> + *
> + * Copyright 2013 Polatis Ltd.
> + *
> + * Author: Laszlo Papp <laszlo.papp@polatis.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + */
> +
> +#ifndef __LINUX_MFD_MAX665X_PRIVATE_H
> +#define __LINUX_MFD_MAX665X_PRIVATE_H
> +
> +#include <linux/i2c.h>
> +#include <linux/regmap.h>
> +
> +struct max665x_dev {
> +	struct device *dev;
> +	struct mutex iolock;
> +	struct i2c_client *i2c;
> +	struct regmap     *map;
> +	int type;

Unless I am missing something, only map is really used in practice.

Clients should not need anything else except possibly type, which is currently
not initialized or used. dev == &i2c->dev and thus redundant even if one is used.

You'll have to decide for a means to pass the device type (max6650 or max6651)
to the client, either through type, the client driver name, or some other means.

Guenter
