Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756545AbaGNQbt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 12:31:49 -0400
Received: from smtp-out-084.synserver.de ([212.40.185.84]:1066 "EHLO
	smtp-out-084.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756233AbaGNQbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 12:31:41 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 22093
Message-ID: <53C405EB.8080108@metafoo.de>
Date: Mon, 14 Jul 2014 18:31:39 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.6.0
MIME-Version: 1.0
To: Josef Gajdusek <atx@atalax.net>, linux-iio@vger.kernel.org
CC: devel@driverdev.osuosl.org, gregkh@linuxfoundation.org, jic23@kernel.org,
        linux-kernel@vger.kernel.org, pmeerw@pmeerw.net,
        dan.carpenter@oracle.com
Subject: Re: [PATCH v3 2/5] staging:iio:hmc5843: Split hmc5843.c to multiple
 files
References: <20140708133711.GB14393@dashie> <20140708133913.GD14393@dashie>
In-Reply-To: <20140708133913.GD14393@dashie>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/2014 03:39 PM, Josef Gajdusek wrote:
[...]
> diff --git a/drivers/staging/iio/magnetometer/Kconfig b/drivers/staging/iio/magnetometer/Kconfig
> index ad88d61..28c2612 100644
> --- a/drivers/staging/iio/magnetometer/Kconfig
> +++ b/drivers/staging/iio/magnetometer/Kconfig
> @@ -5,15 +5,23 @@ menu "Magnetometer sensors"
>
>   config SENSORS_HMC5843
>   	tristate "Honeywell HMC5843/5883/5883L 3-Axis Magnetometer"
> -	depends on I2C
> +	depends on (I2C || SPI_MASTER)
>   	select IIO_BUFFER
>   	select IIO_TRIGGERED_BUFFER
> -	select REGMAP_I2C
> +	select SENSORS_HMC5843_I2C if (I2C)

This approach doesn't work to well and will cause randconfig build failures. 
If SPI_MASTER is 'y' and I2C is 'm' you'll be able to select this driver as 
built-in, which in turn will also select SENSORS_HMC5843_I2C as built-in, 
which means you'll get unresolved symbols during linking since core I2C 
support is built as a module. A better approach is to have a user-selectable 
symbol per bus and a non-user-selectable symbol for the core infrastructure 
of the driver. e.g.

config SENSORS_HMC5843
	tristate
	select IIO_BUFFER
	...

config SENSORS_HMC5843_I2C
	tristate "Honeywell HMC5843/5883/5883L 3-Axis Magnetometer (I2C)"
	select SENSORS_HMC5843
	select REGMAP_I2C

config SENSORS_HMC5843_SPI
	tristate "Honeywell HMC5843/5883/5883L 3-Axis Magnetometer (SPI)"
	select SENSORS_HMC5843
	select REGMAP_SPI



 > +struct regmap_config hmc5843_i2c_regmap_config = {

static

 > +		.reg_bits = 8,
 > +		.val_bits = 8,
 > +
 > +		.rd_table = &hmc5843_readable_table,
 > +		.wr_table = &hmc5843_writable_table,
 > +		.volatile_table = &hmc5843_volatile_table,
 > +
 > +		.cache_type = REGCACHE_RBTREE,
 > +};


 > +static int hmc5843_i2c_probe(struct i2c_client *client,
 > +			 const struct i2c_device_id *id)
 > +{
 > +	struct hmc5843_data *data;
 > +	struct iio_dev *indio_dev;
 > +
 > +	indio_dev = devm_iio_device_alloc(&client->dev, sizeof(*data));
 > +	if (indio_dev == NULL)
 > +		return -ENOMEM;
 > +
 > +	i2c_set_clientdata(client, indio_dev);
 > +
 > +	data = iio_priv(indio_dev);
 > +	data->dev = &client->dev;
 > +	data->regmap = devm_regmap_init_i2c(client, &hmc5843_i2c_regmap_config);
 > +
 > +	indio_dev->name = id->name;
 > +	indio_dev->dev.parent = &client->dev;
 > +
 > +	return hmc5843_common_probe(indio_dev, id->driver_data);
 > +}

If you do the allocation of the IIO device in the common function this can 
be simplified a bit. E.g.

static int hmc5843_i2c_probe(struct i2c_client *client,
			 const struct i2c_device_id *id)
{
	return hmc5853_common_probe(&client->dev,
		devm_regmap_init_i2c(client, &mc5843_i2c_regmap_config),
		id->driver_data);
}


 > +#ifdef CONFIG_PM_SLEEP
 > +static int hmc5843_i2c_suspend(struct device *dev)
 > +{
 > +	return hmc5843_common_suspend(i2c_get_clientdata(to_i2c_client(dev)));
 > +}
 > +
 > +static int hmc5843_i2c_resume(struct device *dev)
 > +{
 > +	return hmc5843_common_resume(i2c_get_clientdata(to_i2c_client(dev)));
 > +}
 > +
 > +static SIMPLE_DEV_PM_OPS(hmc5843_pm_ops,
 > +		hmc5843_i2c_suspend, hmc5843_i2c_resume);
 > +#define HMC5843_PM_OPS (&hmc5843_pm_ops)
 > +#else
 > +#define HMC5843_PM_OPS NULL
 > +#endif

Those ops will be the same for both SPI and I2C. 
i2c_get_clientdata(to_i2c_client(dev)) is the same as dev_get_drvdata(dev), 
so this can go into the core driver.


Also as a hint for future patches, if you rename a file use 
'git-format-patch -M', this will make the patch a bit more legible.

- Lars
