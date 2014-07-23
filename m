Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933570AbaGWUsd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 16:48:33 -0400
Received: from mail.kernel.org ([198.145.19.201]:34786 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932847AbaGWUsb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 16:48:31 -0400
Message-ID: <53D0202A.60800@kernel.org>
Date: Wed, 23 Jul 2014 21:50:50 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Josef Gajdusek <atx@atalax.net>, linux-iio@vger.kernel.org
CC: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, pmeerw@pmeerw.net,
        dan.carpenter@oracle.com, lars@metafoo.de
Subject: Re: [PATCH v5 (staging-next) 2/5] staging:iio:hmc5843: Split hmc5843.c
 to multiple files
References: <20140722150009.GA7845@dashie> <20140722150153.GC7845@dashie>
In-Reply-To: <20140722150153.GC7845@dashie>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/07/14 16:01, Josef Gajdusek wrote:
> This patch splits hmc5843.c to multiple files - the interface-agnostic
> hmc5843_core.c, i2c specific hmc5843_i2c.c and header file hmc5843.h. This is
> another step to add support of SPI-enabled hmc5983.
>
> Signed-off-by: Josef Gajdusek <atx@atx.name>
Applied to the togreg branch of iio.git - initially pushed out as testing.
> ---
>   drivers/staging/iio/magnetometer/Kconfig           |  14 +-
>   drivers/staging/iio/magnetometer/Makefile          |   3 +-
>   drivers/staging/iio/magnetometer/hmc5843.h         |  58 ++++++++
>   .../iio/magnetometer/{hmc5843.c => hmc5843_core.c} | 154 +++++----------------
>   drivers/staging/iio/magnetometer/hmc5843_i2c.c     | 102 ++++++++++++++
>   5 files changed, 203 insertions(+), 128 deletions(-)
>   create mode 100644 drivers/staging/iio/magnetometer/hmc5843.h
>   rename drivers/staging/iio/magnetometer/{hmc5843.c => hmc5843_core.c} (79%)
>   create mode 100644 drivers/staging/iio/magnetometer/hmc5843_i2c.c
>
> diff --git a/drivers/staging/iio/magnetometer/Kconfig b/drivers/staging/iio/magnetometer/Kconfig
> index ad88d61..0a27f98 100644
> --- a/drivers/staging/iio/magnetometer/Kconfig
> +++ b/drivers/staging/iio/magnetometer/Kconfig
> @@ -4,16 +4,22 @@
>   menu "Magnetometer sensors"
>
>   config SENSORS_HMC5843
> -	tristate "Honeywell HMC5843/5883/5883L 3-Axis Magnetometer"
> -	depends on I2C
> +	tristate
>   	select IIO_BUFFER
>   	select IIO_TRIGGERED_BUFFER
> +
> +config SENSORS_HMC5843_I2C
> +	tristate "Honeywell HMC5843/5883/5883L 3-Axis Magnetometer (I2C)"
> +	depends on I2C
> +	select SENSORS_HMC5843
>   	select REGMAP_I2C
>   	help
>   	  Say Y here to add support for the Honeywell HMC5843, HMC5883 and
>   	  HMC5883L 3-Axis Magnetometer (digital compass).
>
> -	  To compile this driver as a module, choose M here: the module
> -	  will be called hmc5843.
> +	  This driver can also be compiled as a set of modules.
> +	  If so, these modules will be created:
> +	  - hmc5843_core (core functions)
> +	  - hmc5843_i2c (support for HMC5843, HMC5883 and HMC5883L)
>
>   endmenu
> diff --git a/drivers/staging/iio/magnetometer/Makefile b/drivers/staging/iio/magnetometer/Makefile
> index f9bfb2e..65baf1c 100644
> --- a/drivers/staging/iio/magnetometer/Makefile
> +++ b/drivers/staging/iio/magnetometer/Makefile
> @@ -2,4 +2,5 @@
>   # Makefile for industrial I/O Magnetometer sensors
>   #
>
> -obj-$(CONFIG_SENSORS_HMC5843)	+= hmc5843.o
> +obj-$(CONFIG_SENSORS_HMC5843)		+= hmc5843_core.o
> +obj-$(CONFIG_SENSORS_HMC5843_I2C)	+= hmc5843_i2c.o
> diff --git a/drivers/staging/iio/magnetometer/hmc5843.h b/drivers/staging/iio/magnetometer/hmc5843.h
> new file mode 100644
> index 0000000..06b2712
> --- /dev/null
> +++ b/drivers/staging/iio/magnetometer/hmc5843.h
> @@ -0,0 +1,58 @@
> +/*
> + * Header file for hmc5843 driver
> + *
> + * Split from hmc5843.c
> + * Copyright (C) Josef Gajdusek <atx@atx.name>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * */
> +
> +
> +#ifndef HMC5843_CORE_H
> +#define HMC5843_CORE_H
> +
> +#include <linux/regmap.h>
> +#include <linux/iio/iio.h>
> +
> +#define HMC5843_CONFIG_REG_A			0x00
> +#define HMC5843_CONFIG_REG_B			0x01
> +#define HMC5843_MODE_REG			0x02
> +#define HMC5843_DATA_OUT_MSB_REGS		0x03
> +#define HMC5843_STATUS_REG			0x09
> +#define HMC5843_ID_REG				0x0a
> +#define HMC5843_ID_END				0x0c
> +
> +enum hmc5843_ids {
> +	HMC5843_ID,
> +	HMC5883_ID,
> +	HMC5883L_ID,
> +};
> +
> +struct hmc5843_data {
> +	struct device *dev;
> +	struct mutex lock;
> +	struct regmap *regmap;
> +	const struct hmc5843_chip_info *variant;
> +	__be16 buffer[8]; /* 3x 16-bit channels + padding + 64-bit timestamp */
> +};
> +
> +int hmc5843_common_probe(struct device *dev, struct regmap *regmap,
> +		enum hmc5843_ids id);
> +int hmc5843_common_remove(struct device *dev);
> +
> +int hmc5843_common_suspend(struct device *dev);
> +int hmc5843_common_resume(struct device *dev);
> +
> +#ifdef CONFIG_PM_SLEEP
> +static SIMPLE_DEV_PM_OPS(hmc5843_pm_ops,
> +		hmc5843_common_suspend,
> +		hmc5843_common_resume);
> +#define HMC5843_PM_OPS (&hmc5843_pm_ops)
> +#else
> +#define HMC5843_PM_OPS NULL
> +#endif
> +
> +#endif /* HMC5843_CORE_H */
> diff --git a/drivers/staging/iio/magnetometer/hmc5843.c b/drivers/staging/iio/magnetometer/hmc5843_core.c
> similarity index 79%
> rename from drivers/staging/iio/magnetometer/hmc5843.c
> rename to drivers/staging/iio/magnetometer/hmc5843_core.c
> index 6f06f98..bdeaf43 100644
> --- a/drivers/staging/iio/magnetometer/hmc5843.c
> +++ b/drivers/staging/iio/magnetometer/hmc5843_core.c
> @@ -4,6 +4,8 @@
>
>       Support for HMC5883 and HMC5883L by Peter Meerwald <pmeerw@pmeerw.net>.
>
> +    Split to multiple files by Josef Gajdusek <atx@atx.name> - 2014
> +
>       This program is free software; you can redistribute it and/or modify
>       it under the terms of the GNU General Public License as published by
>       the Free Software Foundation; either version 2 of the License, or
> @@ -20,7 +22,6 @@
>   */
>
>   #include <linux/module.h>
> -#include <linux/i2c.h>
>   #include <linux/regmap.h>
>   #include <linux/iio/iio.h>
>   #include <linux/iio/sysfs.h>
> @@ -29,19 +30,7 @@
>   #include <linux/iio/triggered_buffer.h>
>   #include <linux/delay.h>
>
> -#define HMC5843_CONFIG_REG_A			0x00
> -#define HMC5843_CONFIG_REG_B			0x01
> -#define HMC5843_MODE_REG			0x02
> -#define HMC5843_DATA_OUT_MSB_REGS		0x03
> -#define HMC5843_STATUS_REG			0x09
> -#define HMC5843_ID_REG				0x0a
> -#define HMC5843_ID_END				0x0c
> -
> -enum hmc5843_ids {
> -	HMC5843_ID,
> -	HMC5883_ID,
> -	HMC5883L_ID,
> -};
> +#include "hmc5843.h"
>
>   /*
>    * Range gain settings in (+-)Ga
> @@ -121,15 +110,6 @@ struct hmc5843_chip_info {
>   	const int *regval_to_nanoscale;
>   };
>
> -/* Each client has this additional data */
> -struct hmc5843_data {
> -	struct i2c_client *client;
> -	struct mutex lock;
> -	struct regmap *regmap;
> -	const struct hmc5843_chip_info *variant;
> -	__be16 buffer[8]; /* 3x 16-bit channels + padding + 64-bit timestamp */
> -};
> -
>   /* The lower two bits contain the current conversion mode */
>   static s32 hmc5843_set_mode(struct hmc5843_data *data, u8 operating_mode)
>   {
> @@ -159,7 +139,7 @@ static int hmc5843_wait_measurement(struct hmc5843_data *data)
>   	}
>
>   	if (tries < 0) {
> -		dev_err(&data->client->dev, "data not ready\n");
> +		dev_err(data->dev, "data not ready\n");
>   		return -EIO;
>   	}
>
> @@ -524,7 +504,7 @@ static int hmc5843_init(struct hmc5843_data *data)
>   	if (ret < 0)
>   		return ret;
>   	if (id[0] != 'H' || id[1] != '4' || id[2] != '3') {
> -		dev_err(&data->client->dev, "no HMC5843/5883/5883L sensor\n");
> +		dev_err(data->dev, "no HMC5843/5883/5883L sensor\n");
>   		return -ENODEV;
>   	}
>
> @@ -550,66 +530,43 @@ static const struct iio_info hmc5843_info = {
>
>   static const unsigned long hmc5843_scan_masks[] = {0x7, 0};
>
> -static const struct regmap_range hmc5843_readable_ranges[] = {
> -		regmap_reg_range(0, HMC5843_ID_END),
> -};
> -
> -static struct regmap_access_table hmc5843_readable_table = {
> -		.yes_ranges = hmc5843_readable_ranges,
> -		.n_yes_ranges = ARRAY_SIZE(hmc5843_readable_ranges),
> -};
>
> -static const struct regmap_range hmc5843_writable_ranges[] = {
> -		regmap_reg_range(0, HMC5843_MODE_REG),
> -};
> -
> -static struct regmap_access_table hmc5843_writable_table = {
> -		.yes_ranges = hmc5843_writable_ranges,
> -		.n_yes_ranges = ARRAY_SIZE(hmc5843_writable_ranges),
> -};
> -
> -static const struct regmap_range hmc5843_volatile_ranges[] = {
> -		regmap_reg_range(HMC5843_DATA_OUT_MSB_REGS, HMC5843_STATUS_REG),
> -};
> -
> -static struct regmap_access_table hmc5843_volatile_table = {
> -		.yes_ranges = hmc5843_volatile_ranges,
> -		.n_yes_ranges = ARRAY_SIZE(hmc5843_volatile_ranges),
> -};
> -
> -static struct regmap_config hmc5843_regmap_config = {
> -		.reg_bits = 8,
> -		.val_bits = 8,
> -
> -		.rd_table = &hmc5843_readable_table,
> -		.wr_table = &hmc5843_writable_table,
> -		.volatile_table = &hmc5843_volatile_table,
> +int hmc5843_common_suspend(struct device *dev)
> +{
> +	return hmc5843_set_mode(iio_priv(dev_get_drvdata(dev)),
> +			HMC5843_MODE_CONVERSION_CONTINUOUS);
> +}
> +EXPORT_SYMBOL(hmc5843_common_suspend);
>
> -		.cache_type = REGCACHE_RBTREE,
> -};
> +int hmc5843_common_resume(struct device *dev)
> +{
> +	return hmc5843_set_mode(iio_priv(dev_get_drvdata(dev)),
> +			HMC5843_MODE_SLEEP);
> +}
> +EXPORT_SYMBOL(hmc5843_common_resume);
>
> -static int hmc5843_probe(struct i2c_client *client,
> -			 const struct i2c_device_id *id)
> +int hmc5843_common_probe(struct device *dev, struct regmap *regmap,
> +		enum hmc5843_ids id)
>   {
>   	struct hmc5843_data *data;
>   	struct iio_dev *indio_dev;
>   	int ret;
>
> -	indio_dev = devm_iio_device_alloc(&client->dev, sizeof(*data));
> +	indio_dev = devm_iio_device_alloc(dev, sizeof(*data));
>   	if (indio_dev == NULL)
>   		return -ENOMEM;
>
> +	dev_set_drvdata(dev, indio_dev);
> +
>   	/* default settings at probe */
>   	data = iio_priv(indio_dev);
> -	data->client = client;
> -	data->variant = &hmc5843_chip_info_tbl[id->driver_data];
> -	data->regmap = devm_regmap_init_i2c(client, &hmc5843_regmap_config);
> +	data->dev = dev;
> +	data->regmap = regmap;
> +	data->variant = &hmc5843_chip_info_tbl[id];
>   	mutex_init(&data->lock);
>
> -	i2c_set_clientdata(client, indio_dev);
> +	indio_dev->dev.parent = dev;
>   	indio_dev->info = &hmc5843_info;
> -	indio_dev->name = id->name;
> -	indio_dev->dev.parent = &client->dev;
>   	indio_dev->modes = INDIO_DIRECT_MODE;
>   	indio_dev->channels = data->variant->channels;
>   	indio_dev->num_channels = 4;
> @@ -634,10 +591,11 @@ buffer_cleanup:
>   	iio_triggered_buffer_cleanup(indio_dev);
>   	return ret;
>   }
> +EXPORT_SYMBOL(hmc5843_common_probe);
>
> -static int hmc5843_remove(struct i2c_client *client)
> +int hmc5843_common_remove(struct device *dev)
>   {
> -	struct iio_dev *indio_dev = i2c_get_clientdata(client);
> +	struct iio_dev *indio_dev = dev_get_drvdata(dev);
>
>   	iio_device_unregister(indio_dev);
>   	iio_triggered_buffer_cleanup(indio_dev);
> @@ -647,58 +605,8 @@ static int hmc5843_remove(struct i2c_client *client)
>
>   	return 0;
>   }
> -
> -#ifdef CONFIG_PM_SLEEP
> -static int hmc5843_suspend(struct device *dev)
> -{
> -	struct hmc5843_data *data = iio_priv(i2c_get_clientdata(
> -		to_i2c_client(dev)));
> -
> -	return hmc5843_set_mode(data, HMC5843_MODE_SLEEP);
> -}
> -
> -static int hmc5843_resume(struct device *dev)
> -{
> -	struct hmc5843_data *data = iio_priv(i2c_get_clientdata(
> -		to_i2c_client(dev)));
> -
> -	return hmc5843_set_mode(data, HMC5843_MODE_CONVERSION_CONTINUOUS);
> -}
> -
> -static SIMPLE_DEV_PM_OPS(hmc5843_pm_ops, hmc5843_suspend, hmc5843_resume);
> -#define HMC5843_PM_OPS (&hmc5843_pm_ops)
> -#else
> -#define HMC5843_PM_OPS NULL
> -#endif
> -
> -static const struct i2c_device_id hmc5843_id[] = {
> -	{ "hmc5843", HMC5843_ID },
> -	{ "hmc5883", HMC5883_ID },
> -	{ "hmc5883l", HMC5883L_ID },
> -	{ }
> -};
> -MODULE_DEVICE_TABLE(i2c, hmc5843_id);
> -
> -static const struct of_device_id hmc5843_of_match[] = {
> -	{ .compatible = "honeywell,hmc5843", .data = (void *)HMC5843_ID },
> -	{ .compatible = "honeywell,hmc5883", .data = (void *)HMC5883_ID },
> -	{ .compatible = "honeywell,hmc5883l", .data = (void *)HMC5883L_ID },
> -	{}
> -};
> -MODULE_DEVICE_TABLE(of, hmc5843_of_match);
> -
> -static struct i2c_driver hmc5843_driver = {
> -	.driver = {
> -		.name	= "hmc5843",
> -		.pm	= HMC5843_PM_OPS,
> -		.of_match_table = hmc5843_of_match,
> -	},
> -	.id_table	= hmc5843_id,
> -	.probe		= hmc5843_probe,
> -	.remove		= hmc5843_remove,
> -};
> -module_i2c_driver(hmc5843_driver);
> +EXPORT_SYMBOL(hmc5843_common_remove);
>
>   MODULE_AUTHOR("Shubhrajyoti Datta <shubhrajyoti@ti.com>");
> -MODULE_DESCRIPTION("HMC5843/5883/5883L driver");
> +MODULE_DESCRIPTION("HMC5843/5883/5883L core driver");
>   MODULE_LICENSE("GPL");
> diff --git a/drivers/staging/iio/magnetometer/hmc5843_i2c.c b/drivers/staging/iio/magnetometer/hmc5843_i2c.c
> new file mode 100644
> index 0000000..5593a7d
> --- /dev/null
> +++ b/drivers/staging/iio/magnetometer/hmc5843_i2c.c
> @@ -0,0 +1,102 @@
> +/*
> + * i2c driver for hmc5843/5843/5883/5883l
> + *
> + * Split from hmc5843.c
> + * Copyright (C) Josef Gajdusek <atx@atx.name>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * */
> +
> +#include <linux/module.h>
> +#include <linux/i2c.h>
> +#include <linux/regmap.h>
> +#include <linux/iio/iio.h>
> +#include <linux/iio/triggered_buffer.h>
> +
> +#include "hmc5843.h"
> +
> +static const struct regmap_range hmc5843_readable_ranges[] = {
> +		regmap_reg_range(0, HMC5843_ID_END),
> +};
> +
> +static struct regmap_access_table hmc5843_readable_table = {
> +		.yes_ranges = hmc5843_readable_ranges,
> +		.n_yes_ranges = ARRAY_SIZE(hmc5843_readable_ranges),
> +};
> +
> +static const struct regmap_range hmc5843_writable_ranges[] = {
> +		regmap_reg_range(0, HMC5843_MODE_REG),
> +};
> +
> +static struct regmap_access_table hmc5843_writable_table = {
> +		.yes_ranges = hmc5843_writable_ranges,
> +		.n_yes_ranges = ARRAY_SIZE(hmc5843_writable_ranges),
> +};
> +
> +static const struct regmap_range hmc5843_volatile_ranges[] = {
> +		regmap_reg_range(HMC5843_DATA_OUT_MSB_REGS, HMC5843_STATUS_REG),
> +};
> +
> +static struct regmap_access_table hmc5843_volatile_table = {
> +		.yes_ranges = hmc5843_volatile_ranges,
> +		.n_yes_ranges = ARRAY_SIZE(hmc5843_volatile_ranges),
> +};
> +
> +static struct regmap_config hmc5843_i2c_regmap_config = {
> +		.reg_bits = 8,
> +		.val_bits = 8,
> +
> +		.rd_table = &hmc5843_readable_table,
> +		.wr_table = &hmc5843_writable_table,
> +		.volatile_table = &hmc5843_volatile_table,
> +
> +		.cache_type = REGCACHE_RBTREE,
> +};
> +
> +static int hmc5843_i2c_probe(struct i2c_client *client,
> +			 const struct i2c_device_id *id)
> +{
> +	return hmc5843_common_probe(&client->dev,
> +			devm_regmap_init_i2c(client, &hmc5843_i2c_regmap_config),
> +			id->driver_data);
> +}
> +
> +static int hmc5843_i2c_remove(struct i2c_client *client)
> +{
> +	return hmc5843_common_remove(&client->dev);
> +}
> +
> +static const struct i2c_device_id hmc5843_id[] = {
> +	{ "hmc5843", HMC5843_ID },
> +	{ "hmc5883", HMC5883_ID },
> +	{ "hmc5883l", HMC5883L_ID },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(i2c, hmc5843_id);
> +
> +static const struct of_device_id hmc5843_of_match[] = {
> +	{ .compatible = "honeywell,hmc5843", .data = (void *)HMC5843_ID },
> +	{ .compatible = "honeywell,hmc5883", .data = (void *)HMC5883_ID },
> +	{ .compatible = "honeywell,hmc5883l", .data = (void *)HMC5883L_ID },
> +	{}
> +};
> +MODULE_DEVICE_TABLE(of, hmc5843_of_match);
> +
> +static struct i2c_driver hmc5843_driver = {
> +	.driver = {
> +		.name	= "hmc5843",
> +		.pm	= HMC5843_PM_OPS,
> +		.of_match_table = hmc5843_of_match,
> +	},
> +	.id_table	= hmc5843_id,
> +	.probe		= hmc5843_i2c_probe,
> +	.remove		= hmc5843_i2c_remove,
> +};
> +module_i2c_driver(hmc5843_driver);
> +
> +MODULE_AUTHOR("Josef Gajdusek <atx@atx.name>");
> +MODULE_DESCRIPTION("HMC5843/5883/5883L i2c driver");
> +MODULE_LICENSE("GPL");
>

