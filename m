Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933649AbaGWUtd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 16:49:33 -0400
Received: from mail.kernel.org ([198.145.19.201]:34933 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932847AbaGWUt3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 16:49:29 -0400
Message-ID: <53D02064.2000207@kernel.org>
Date: Wed, 23 Jul 2014 21:51:48 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Josef Gajdusek <atx@atalax.net>, linux-iio@vger.kernel.org
CC: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, pmeerw@pmeerw.net,
        dan.carpenter@oracle.com, lars@metafoo.de
Subject: Re: [PATCH v5 (staging-next) 5/5] staging:iio:hmc5843: Add support
 for spi hmc5983
References: <20140722150009.GA7845@dashie> <20140722150310.GF7845@dashie>
In-Reply-To: <20140722150310.GF7845@dashie>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/07/14 16:03, Josef Gajdusek wrote:
> This patch adds support for the hmc5983 spi interface.
> This chip is almost identical to the hmc5883. The difference being added
> temperature compensation, additional available sample rate (220Hz) and an SPI
> interface.
>
> Signed-off-by: Josef Gajdusek <atx@atx.name>
Applied to the togreg branch of iio.git - initially pushed out as testing.
> ---
>   drivers/staging/iio/magnetometer/Kconfig       |  15 ++++
>   drivers/staging/iio/magnetometer/Makefile      |   1 +
>   drivers/staging/iio/magnetometer/hmc5843_spi.c | 100 +++++++++++++++++++++++++
>   3 files changed, 116 insertions(+)
>   create mode 100644 drivers/staging/iio/magnetometer/hmc5843_spi.c
>
> diff --git a/drivers/staging/iio/magnetometer/Kconfig b/drivers/staging/iio/magnetometer/Kconfig
> index c086f33..dec814a 100644
> --- a/drivers/staging/iio/magnetometer/Kconfig
> +++ b/drivers/staging/iio/magnetometer/Kconfig
> @@ -22,4 +22,19 @@ config SENSORS_HMC5843_I2C
>   	  - hmc5843_core (core functions)
>   	  - hmc5843_i2c (support for HMC5843, HMC5883, HMC5883L and HMC5983)
>
> +config SENSORS_HMC5843_SPI
> +	tristate "Honeywell HMC5983 3-Axis Magnetometer (SPI)"
> +	depends on SPI_MASTER
> +	select SENSORS_HMC5843
> +	select REGMAP_SPI
> +	help
> +	  Say Y here to add support for the Honeywell HMC5983 3-Axis Magnetometer
> +	  (digital compass).
> +
> +	  This driver can also be compiled as a set of modules.
> +	  If so, these modules will be created:
> +	  - hmc5843_core (core functions)
> +	  - hmc5843_spi (support for HMC5983)
> +
> +
>   endmenu
> diff --git a/drivers/staging/iio/magnetometer/Makefile b/drivers/staging/iio/magnetometer/Makefile
> index 65baf1c..33761a1 100644
> --- a/drivers/staging/iio/magnetometer/Makefile
> +++ b/drivers/staging/iio/magnetometer/Makefile
> @@ -4,3 +4,4 @@
>
>   obj-$(CONFIG_SENSORS_HMC5843)		+= hmc5843_core.o
>   obj-$(CONFIG_SENSORS_HMC5843_I2C)	+= hmc5843_i2c.o
> +obj-$(CONFIG_SENSORS_HMC5843_SPI)	+= hmc5843_spi.o
> diff --git a/drivers/staging/iio/magnetometer/hmc5843_spi.c b/drivers/staging/iio/magnetometer/hmc5843_spi.c
> new file mode 100644
> index 0000000..98c4b57
> --- /dev/null
> +++ b/drivers/staging/iio/magnetometer/hmc5843_spi.c
> @@ -0,0 +1,100 @@
> +/*
> + * SPI driver for hmc5983
> + *
> + * Copyright (C) Josef Gajdusek <atx@atx.name>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License version 2 as
> + * published by the Free Software Foundation.
> + *
> + * */
> +
> +#include <linux/module.h>
> +#include <linux/spi/spi.h>
> +#include <linux/iio/iio.h>
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
> +static struct regmap_config hmc5843_spi_regmap_config = {
> +		.reg_bits = 8,
> +		.val_bits = 8,
> +
> +		.rd_table = &hmc5843_readable_table,
> +		.wr_table = &hmc5843_writable_table,
> +		.volatile_table = &hmc5843_volatile_table,
> +
> +		/* Autoincrement address pointer */
> +		.read_flag_mask = 0xc0,
> +
> +		.cache_type = REGCACHE_RBTREE,
> +};
> +
> +static int hmc5843_spi_probe(struct spi_device *spi)
> +{
> +	int ret;
> +
> +	spi->mode = SPI_MODE_3;
> +	spi->max_speed_hz = 8000000;
> +	spi->bits_per_word = 8;
> +	ret = spi_setup(spi);
> +	if (ret)
> +		return ret;
> +
> +	return hmc5843_common_probe(&spi->dev,
> +			devm_regmap_init_spi(spi, &hmc5843_spi_regmap_config),
> +			HMC5983_ID);
> +}
> +
> +static int hmc5843_spi_remove(struct spi_device *spi)
> +{
> +	return hmc5843_common_remove(&spi->dev);
> +}
> +
> +static const struct spi_device_id hmc5843_id[] = {
> +	{ "hmc5983", HMC5983_ID },
> +	{ }
> +};
> +
> +static struct spi_driver hmc5843_driver = {
> +		.driver = {
> +				.name = "hmc5843",
> +				.pm = HMC5843_PM_OPS,
> +				.owner = THIS_MODULE,
> +		},
> +		.id_table = hmc5843_id,
> +		.probe = hmc5843_spi_probe,
> +		.remove = hmc5843_spi_remove,
> +};
> +
> +module_spi_driver(hmc5843_driver);
> +
> +MODULE_AUTHOR("Josef Gajdusek <atx@atx.name>");
> +MODULE_DESCRIPTION("HMC5983 SPI driver");
> +MODULE_LICENSE("GPL");
>

