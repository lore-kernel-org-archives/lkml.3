Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752413Ab3IJPUt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 11:20:49 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:64684 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081Ab3IJPUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 11:20:47 -0400
Date: Tue, 10 Sep 2013 08:20:43 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: "Markezana, William" <William.Markezana@meas-spec.com>
Cc: khali@linux-fr.org, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwmon: (ms5637) Add Measurement Specialties MS5637
 support
Message-ID: <20130910152043.GA9165@roeck-us.net>
References: <E7458771276B644AB8F21A92079F7D6C53C593@tlse-mail1.europe.msiusa.com>
 <20130828161804.GB5278@roeck-us.net>
 <E7458771276B644AB8F21A92079F7D6C0E6D03@tlse-mail1.europe.msiusa.com>
 <20130829094052.GA19239@roeck-us.net>
 <E7458771276B644AB8F21A92079F7D6C0E6D04@tlse-mail1.europe.msiusa.com>
 <E7458771276B644AB8F21A92079F7D6C0E6D06@tlse-mail1.europe.msiusa.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E7458771276B644AB8F21A92079F7D6C0E6D06@tlse-mail1.europe.msiusa.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 10, 2013 at 05:09:57PM +0200, Markezana, William wrote:
> From: William Markezana <william.markezana@meas-spec.com>
> 
> hwmon: (ms5637) Add Measurement Specialties MS5637support
> Signed-off-by: William Markezana <william.markezana@meas-spec.com>

Hi William,

"pressure" is hardly a hardware monitoring attribute. It might make more sense
to add your driver to the iio subsystem, which already supports at least one
other pressure sensor.

Thanks,
Guenter

> ---
> diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
> index 55973cd..c4f1c8e 100644
> --- a/drivers/hwmon/Kconfig
> +++ b/drivers/hwmon/Kconfig
> @@ -954,6 +954,16 @@ config SENSORS_MCP3021
>  	  This driver can also be built as a module.  If so, the module
>  	  will be called mcp3021.
>  
> +config SENSORS_MS5637
> +	tristate "Measurement Specialties MS5637 pressure sensors"
> +	depends on I2C
> +	help
> +	  If you say yes here you get support for the Measurement Specialties
> +	  MS5637 pressure sensors.
> +
> +	  This driver can also be built as a module.  If so, the module
> +	  will be called ms5637.
> +
>  config SENSORS_NCT6775
>  	tristate "Nuvoton NCT6775F and compatibles"
>  	depends on !PPC
> diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
> index ec7cde0..5d8f699 100644
> --- a/drivers/hwmon/Makefile
> +++ b/drivers/hwmon/Makefile
> @@ -110,6 +110,7 @@ obj-$(CONFIG_SENSORS_MAX6650)	+= max6650.o
>  obj-$(CONFIG_SENSORS_MAX6697)	+= max6697.o
>  obj-$(CONFIG_SENSORS_MC13783_ADC)+= mc13783-adc.o
>  obj-$(CONFIG_SENSORS_MCP3021)	+= mcp3021.o
> +obj-$(CONFIG_SENSORS_MS5637)	+= ms5637.o
>  obj-$(CONFIG_SENSORS_NCT6775)	+= nct6775.o
>  obj-$(CONFIG_SENSORS_NTC_THERMISTOR)	+= ntc_thermistor.o
>  obj-$(CONFIG_SENSORS_PC87360)	+= pc87360.o
> diff --git a/drivers/hwmon/ms5637.c b/drivers/hwmon/ms5637.c
> new file mode 100644
> index 0000000..fe2c2df
> --- /dev/null
> +++ b/drivers/hwmon/ms5637.c
> @@ -0,0 +1,302 @@
> +/*
> + * Measurement Specialties MS5637 pressure and temperature sensor driver
> + *
> + * Copyright (C) 2013 William Markezana <william.markezana@meas-spec.com>
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
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/slab.h>
> +#include <linux/i2c.h>
> +#include <linux/hwmon.h>
> +#include <linux/hwmon-sysfs.h>
> +#include <linux/err.h>
> +#include <linux/mutex.h>
> +#include <linux/device.h>
> +#include <linux/jiffies.h>
> +#include <linux/delay.h>
> +
> +/* MS5637 Commands */
> +#define MS5637_CONVERT_D1_OSR_4096	(0x48)
> +#define MS5637_CONVERT_D2_OSR_4096	(0x58)
> +#define MS5637_ADC_READ				(0x00)
> +#define MS5637_PROM_READ			(0xA0)
> +
> +struct ms5637 {
> +	struct device *hwmon_dev;
> +	struct mutex lock;
> +	bool valid;
> +	unsigned long last_update;
> +	int temperature;
> +	int pressure;
> +	unsigned short calibration_words[6];
> +	bool got_calibration_words;
> +};
> +
> +static int ms5637_get_calibration_word(struct i2c_client *client,
> +	unsigned char address, unsigned short *word)
> +{
> +	int ret = 0;
> +	ret = i2c_smbus_read_word_swapped(client,
> +		MS5637_PROM_READ + (address << 1));
> +	if (ret < 0)
> +		return ret;
> +	*word = (unsigned short)ret & 0xFFFF;
> +	return 0;
> +}
> +
> +static int ms5637_fill_calibration_words(struct i2c_client *client)
> +{
> +	int i, ret = 0;
> +	struct ms5637 *ms5637 = i2c_get_clientdata(client);
> +
> +	for (i = 0; i < 6; i++) {
> +		ret = ms5637_get_calibration_word(client, i+1,
> +			&ms5637->calibration_words[i]);
> +		if (ret < 0) {
> +			dev_err(&client->dev,
> +				"unable to get calibration word at address %d\n",
> +				i+1);
> +			return ret;
> +		}
> +	}
> +	return 0;
> +}
> +
> +static int ms5637_get_adc_value(struct i2c_client *client,
> +	unsigned int *adc_value)
> +{
> +	int ret = 0;
> +	unsigned char buf[3];
> +	ret = i2c_smbus_read_i2c_block_data(client, MS5637_ADC_READ, 3, buf);
> +	if (ret < 0)
> +		return ret;
> +	*adc_value = (buf[0] << 16) + (buf[1] << 8) + buf[2];
> +	return 0;
> +}
> +
> +static int ms5637_get_conversion_result(struct i2c_client *client,
> +	unsigned char command, unsigned int *adc_value)
> +{
> +	int ret;
> +
> +	ret = i2c_smbus_write_byte(client, command);
> +	if (ret < 0)
> +		return ret;
> +	msleep(9);
> +	ret = ms5637_get_adc_value(client, adc_value);
> +	if (ret < 0)
> +		return ret;
> +	return 0;
> +}
> +
> +static int ms5637_update_measurements(struct i2c_client *client)
> +{
> +	int ret = 0;
> +	unsigned int d1, d2;
> +	int dt, temp, p;
> +	long long int off, sens;
> +	struct ms5637 *ms5637 = i2c_get_clientdata(client);
> +
> +	mutex_lock(&ms5637->lock);
> +
> +	if (time_after(jiffies, ms5637->last_update + HZ / 2) ||
> +	    !ms5637->valid) {
> +
> +		if (!ms5637->got_calibration_words)	{
> +			ret = ms5637_fill_calibration_words(client);
> +			if (ret < 0) {
> +				dev_err(&client->dev,
> +					"unable to get calibration words\n");
> +				goto out;
> +			}
> +
> +			ms5637->got_calibration_words = true;
> +		}
> +
> +		ret = ms5637_get_conversion_result(client,
> +			MS5637_CONVERT_D1_OSR_4096, &d1);
> +		if (ret < 0) {
> +			dev_err(&client->dev,
> +				"unable to get adc conversion of D1_OSR_4096\n");
> +			goto out;
> +		}
> +
> +		ret = ms5637_get_conversion_result(client,
> +			MS5637_CONVERT_D2_OSR_4096, &d2);
> +		if (ret < 0) {
> +			dev_err(&client->dev,
> +				"unable to get adc conversion of D2_OSR_4096\n");
> +			goto out;
> +		}
> +
> +		dt = d2 - (int)ms5637->calibration_words[4] * 256;
> +		temp = 20000 + div_s64((long long int)dt *
> +			(long long int)ms5637->calibration_words[5], 838861);
> +
> +		off = (long long int)ms5637->calibration_words[1] * 131072 +
> +			div_s64((long long int)ms5637->calibration_words[3] *
> +			(long long int)dt, 64);
> +		sens = (long long int)ms5637->calibration_words[0] * 65536 +
> +			div_s64((long long int)ms5637->calibration_words[2] *
> +			(long long int)dt, 128);
> +		p = (int)div_s64((div_s64((long long int)d1 * sens, 2097152) -
> +			off), 3277);
> +
> +		ms5637->temperature = temp;
> +		ms5637->pressure = p;
> +		ms5637->last_update = jiffies;
> +		ms5637->valid = true;
> +	}
> +out:
> +	mutex_unlock(&ms5637->lock);
> +
> +	return ret >= 0 ? 0 : ret;
> +}
> +
> +static ssize_t ms5637_show_temperature(struct device *dev,
> +				      struct device_attribute *attr, char *buf)
> +{
> +	struct i2c_client *client = to_i2c_client(dev);
> +	struct ms5637 *ms5637 = i2c_get_clientdata(client);
> +	int ret = ms5637_update_measurements(client);
> +	if (ret < 0)
> +		return ret;
> +	return sprintf(buf, "%d\n", ms5637->temperature);
> +}
> +
> +static ssize_t ms5637_show_pressure(struct device *dev,
> +				   struct device_attribute *attr, char *buf)
> +{
> +	struct i2c_client *client = to_i2c_client(dev);
> +	struct ms5637 *ms5637 = i2c_get_clientdata(client);
> +	int ret = ms5637_update_measurements(client);
> +	if (ret < 0)
> +		return ret;
> +	return sprintf(buf, "%d\n", ms5637->pressure);
> +}
> +
> +static SENSOR_DEVICE_ATTR(temp1_input, S_IRUGO,
> +			  ms5637_show_temperature, NULL, 0);
> +static SENSOR_DEVICE_ATTR(pressure1_input, S_IRUGO,
> +			  ms5637_show_pressure, NULL, 0);
> +
> +static struct attribute *ms5637_attributes[] = {
> +	&sensor_dev_attr_temp1_input.dev_attr.attr,
> +	&sensor_dev_attr_pressure1_input.dev_attr.attr,
> +	NULL
> +};
> +
> +static const struct attribute_group ms5637_group = {
> +	.attrs = ms5637_attributes,
> +};
> +
> +static int ms5637_probe(struct i2c_client *client,
> +		       const struct i2c_device_id *id)
> +{
> +	struct ms5637 *ms5637;
> +	int err;
> +
> +	if (!i2c_check_functionality(client->adapter,
> +					I2C_FUNC_SMBUS_READ_WORD_DATA)) {
> +		dev_err(&client->dev,
> +			"adapter does not support SMBus word transactions\n");
> +		return -ENODEV;
> +	}
> +
> +	if (!i2c_check_functionality(client->adapter,
> +				    I2C_FUNC_SMBUS_WRITE_BYTE)) {
> +		dev_err(&client->dev,
> +			"adapter does not support SMBus byte transactions\n");
> +		return -ENODEV;
> +	}
> +
> +	if (!i2c_check_functionality(client->adapter,
> +				    I2C_FUNC_SMBUS_READ_I2C_BLOCK)) {
> +		dev_err(&client->dev,
> +			"adapter does not support SMBus block transactions\n");
> +		return -ENODEV;
> +	}
> +
> +	ms5637 = devm_kzalloc(&client->dev, sizeof(*ms5637), GFP_KERNEL);
> +	if (!ms5637)
> +		return -ENOMEM;
> +
> +	i2c_set_clientdata(client, ms5637);
> +
> +	mutex_init(&ms5637->lock);
> +
> +	err = sysfs_create_group(&client->dev.kobj, &ms5637_group);
> +	if (err) {
> +		dev_dbg(&client->dev, "could not create sysfs files\n");
> +		return err;
> +	}
> +	ms5637->hwmon_dev = hwmon_device_register(&client->dev);
> +	if (IS_ERR(ms5637->hwmon_dev)) {
> +		dev_dbg(&client->dev, "unable to register hwmon device\n");
> +		err = PTR_ERR(ms5637->hwmon_dev);
> +		goto error;
> +	}
> +
> +	mutex_lock(&ms5637->lock);
> +	err = ms5637_fill_calibration_words(client);
> +	if (err >= 0)
> +		ms5637->got_calibration_words = true;
> +	mutex_unlock(&ms5637->lock);
> +
> +	dev_info(&client->dev, "initialized\n");
> +
> +	return 0;
> +
> +error:
> +	sysfs_remove_group(&client->dev.kobj, &ms5637_group);
> +	return err;
> +}
> +
> +static int ms5637_remove(struct i2c_client *client)
> +{
> +	struct ms5637 *ms5637 = i2c_get_clientdata(client);
> +
> +	hwmon_device_unregister(ms5637->hwmon_dev);
> +	sysfs_remove_group(&client->dev.kobj, &ms5637_group);
> +
> +	return 0;
> +}
> +
> +static const struct i2c_device_id ms5637_id[] = {
> +	{ "ms5637", 0 },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(i2c, ms5637_id);
> +
> +static struct i2c_driver ms5637_driver = {
> +	.class = I2C_CLASS_HWMON,
> +	.driver = {
> +		.name	= "ms5637",
> +	},
> +	.probe       = ms5637_probe,
> +	.remove      = ms5637_remove,
> +	.id_table    = ms5637_id,
> +};
> +
> +module_i2c_driver(ms5637_driver);
> +
> +MODULE_AUTHOR("William Markezana <william.markezana@meas-spec.com>");
> +MODULE_DESCRIPTION("MEAS MS5637 pressure and temperature sensor driver");
> +MODULE_LICENSE("GPL");
