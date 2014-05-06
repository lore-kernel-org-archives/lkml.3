Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933656AbaEFBjM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 21:39:12 -0400
Received: from mail.active-venture.com ([67.228.131.205]:57938 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933469AbaEFBjK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 21:39:10 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53683D38.7010904@roeck-us.net>
Date: Mon, 05 May 2014 18:39:04 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Tomas Pop <tomas.pop.mff@gmail.com>
CC: "jdelvare@suse.de" <jdelvare@suse.de>, lm-sensors@lm-sensors.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        johannes.winkelmann@sensirion.com
Subject: Re: [RFC][PATCH v2] hwmon: add support for Sensirion SHTC1 sensor
References: <1398985530.17142.15.camel@ltli10.sensirion.lokal>	 <5362FDA9.8080300@roeck-us.net>	 <1399064369.3019.83.camel@ltli10.sensirion.lokal>	 <20140502231528.GA5157@roeck-us.net> <1399338214.24993.10.camel@ltli10.sensirion.lokal>
In-Reply-To: <1399338214.24993.10.camel@ltli10.sensirion.lokal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomas,

On 05/05/2014 06:03 PM, Tomas Pop wrote:
> Hi Guenter,
>
> Here is a corrected version, I tried to address your comments and I'm sending it
> again with a kind request for comments - we will do some more extensive testing
> before the final submission, but I would like to make the code as complete as
> as possible before. Here is a list of changes to the previous version:
>
Comments below. But I don't think you tested this with real HW, did you ? :-)

> * positive, but incorrect return codes/lengths from i2c_mater_* are checked
> * usleep_range used instead of msleep
> * DEVICE_ATTR used instead of SENSOR_DEVICE_ATTR, ATTRIBITE_GROUPS used
> * devm_hwmon_device_register_with_groups instead of devm_hwmon_device_register
> * direct calls to sysfs_create_group and sysfs_create_group dropped
> * shtc1_remove function dropped
> * SHTW1 added to documentation and Kconfig
> * documentation and formating updates/corrections
>
> I did re-compile with C=1 as suggested and it is clear.
>
> Patch was generated against kernel v3.15-rc3
>
> Thanks,
> Tomas
>
> Signed-off-by: Tomas Pop <tomas.pop@sensirion.com>
> ---
>   Documentation/hwmon/shtc1           |  41 ++++++
>   drivers/hwmon/Kconfig               |  10 ++
>   drivers/hwmon/Makefile              |   1 +
>   drivers/hwmon/shtc1.c               | 266 ++++++++++++++++++++++++++++++++++++
>   include/linux/platform_data/shtc1.h |  24 ++++
>   5 files changed, 342 insertions(+)
>   create mode 100644 Documentation/hwmon/shtc1
>   create mode 100644 drivers/hwmon/shtc1.c
>   create mode 100644 include/linux/platform_data/shtc1.h
>
> diff --git a/Documentation/hwmon/shtc1 b/Documentation/hwmon/shtc1
> new file mode 100644
> index 0000000..47c9ed1
> --- /dev/null
> +++ b/Documentation/hwmon/shtc1
> @@ -0,0 +1,41 @@
> +Kernel driver shtc1
> +===================
> +
> +Supported chips:
> +  * Sensirion SHTC1
> +    Prefix: 'shtc1'
> +    Addresses scanned: none
> +    Datasheet: Publicly available at the Sensirion website
> +    http://www.sensirion.com/file/datasheet_shtc1
> +
> +  * Sensirion SHTW1
> +    Prefix: 'shtc1'
> +    Addresses scanned: none
> +    Datasheet: Not publicly available
> +
> +Author:
> +  Johannes Winkelmann <johannes.winkelmann@sensirion.com>
> +
> +Description
> +-----------
> +
> +This driver implements support for the Sensirion SHTC1 chip, a humidity and
> +temperature sensor. Temperature is measured in degrees celsius, relative
> +humidity is expressed as a percentage. Driver can be used as well for SHTW1
> +chip, which has the same electrical interface.
> +
> +The device communicates with the I2C protocol. All sensors are set to I2C
> +address 0x70. See Documentation/i2c/instantiating-devices for methods to
> +instantiate the device.
> +
> +There are two options configurable by means of shtc1_platform_data:
> +1. blocking (pull the I2C clock line down while performing the measurement) or
> +   non-blocking mode. Blocking mode will guarantee the fastest result but
> +   the I2C bus will be busy during that time.
> +2. high or low accuracy. Using high accuracy is strongly recommended.
> +
> +sysfs-Interface
> +---------------
> +
> +temp1_input - temperature input
> +humidity1_input - humidity input
> diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
> index bc196f4..f95ba5b 100644
> --- a/drivers/hwmon/Kconfig
> +++ b/drivers/hwmon/Kconfig
> @@ -1114,6 +1114,16 @@ config SENSORS_SHT21
>   	  This driver can also be built as a module.  If so, the module
>   	  will be called sht21.
>
> +config SENSORS_SHTC1
> +	tristate "Sensiron humidity and temperature sensors. SHTC1 and compat."
> +	depends on I2C
> +	help
> +	  If you say yes here you get support for the Sensiron SHTC1 and SHTW1
> +	  humidity and temperature sensor.
> +
> +	  This driver can also be built as a module.  If so, the module
> +	  will be called shtc1.
> +
>   config SENSORS_S3C
>   	tristate "Samsung built-in ADC"
>   	depends on S3C_ADC
> diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
> index c48f987..1cc5273 100644
> --- a/drivers/hwmon/Makefile
> +++ b/drivers/hwmon/Makefile
> @@ -125,6 +125,7 @@ obj-$(CONFIG_SENSORS_SCH5627)	+= sch5627.o
>   obj-$(CONFIG_SENSORS_SCH5636)	+= sch5636.o
>   obj-$(CONFIG_SENSORS_SHT15)	+= sht15.o
>   obj-$(CONFIG_SENSORS_SHT21)	+= sht21.o
> +obj-$(CONFIG_SENSORS_SHTC1)	+= shtc1.o
>   obj-$(CONFIG_SENSORS_SIS5595)	+= sis5595.o
>   obj-$(CONFIG_SENSORS_SMM665)	+= smm665.o
>   obj-$(CONFIG_SENSORS_SMSC47B397)+= smsc47b397.o
> diff --git a/drivers/hwmon/shtc1.c b/drivers/hwmon/shtc1.c
> new file mode 100644
> index 0000000..c94f670
> --- /dev/null
> +++ b/drivers/hwmon/shtc1.c
> @@ -0,0 +1,266 @@
> +/* Sensirion SHTC1 humidity and temperature sensor driver
> + *
> + * Copyright (C) 2014 Sensirion AG, Switzerland
> + * Author: Johannes Winkelmann <johannes.winkelmann@sensirion.com>
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
> +#include <linux/delay.h>
> +#include <linux/platform_data/shtc1.h>
> +
> +/* commands (high precision mode) */
> +static const unsigned char shtc1_cmd_measure_blocking_hpm[]    = { 0x7C, 0xA2 };
> +static const unsigned char shtc1_cmd_measure_nonblocking_hpm[] = { 0x78, 0x66 };
> +
> +/* commands (low precision mode) */
> +static const unsigned char shtc1_cmd_measure_blocking_lpm[]    = { 0x64, 0x58 };
> +static const unsigned char shtc1_cmd_measure_nonblocking_lpm[] = { 0x60, 0x9c };
> +
> +/* command for reading the ID register */
> +static const unsigned char shtc1_cmd_read_id_reg[]	       = { 0xef, 0xc8 };
> +
> +/* constants for reading the ID register */
> +#define SHTC1_ID_REG_CONTENT 0x07
> +#define SHTC1_ID_REG_MASK    0x1f
> +
> +/* delays for non-blocking i2c commands, both in us */
> +#define SHTC1_NONBLOCKING_WAIT_TIME_HPM  14400
> +#define SHTC1_NONBLOCKING_WAIT_TIME_LPM   1000
> +
> +#define SHTC1_CMD_LENGTH      2
> +#define SHTC1_RESPONSE_LENGTH 6
> +
> +struct shtc1_data {
> +	struct device *hwmon_dev;

Not needed. But you need the i2c client here.

> +	struct mutex update_lock;
> +	bool valid;
> +	unsigned long last_updated; /* In jiffies */
> +
> +	const unsigned char *command;
> +	unsigned int nonblocking_wait_time;
> +
> +	struct shtc1_platform_data setup;
> +
> +	int temperature;
> +	int humidity;
> +};
> +
> +static int shtc1_update_values(struct i2c_client *client,
> +			       struct shtc1_data *data,
> +			       char *buf, int bufsize)
> +{
> +	int ret = i2c_master_send(client, data->command, SHTC1_CMD_LENGTH);
> +	if (ret < 0) {
> +		dev_err(&client->dev, "failed to send command: %d\n", ret);
> +		return ret;
> +	}
> +	if (ret != SHTC1_CMD_LENGTH) {
> +		dev_err(&client->dev, "wrong nr bytes written: %d\n", ret);
> +		return -EIO;
> +	}

Can you merge those into one ? Something like

	if (ret < SHTC1_CMD_LENGTH) {
		dev_err(&client->dev, "failed to send command: %d\n", ret);
		return ret < 0 ? ret : -EIO;
	}

> +
> +	/*
> +	* In blocking mode (clock stretching mode) the I2C bus
> +	* is blocked for other traffic, thus the call to i2c_master_recv()
> +	* will wait until the data is ready. for non blocking mode, we

	s/for/For/

> +	* have to wait ourselves.
> +	*/
> +	if (!data->setup.blocking_io)
> +		usleep_range(data->nonblocking_wait_time,
> +			     data->nonblocking_wait_time + 2000);
> +
In the low precision case, this results in a wait time of 1 to 3 ms.
How about giving it a 1 ms range ? Seems to me that should be enough
and an acceptable trade-off.

> +	ret = i2c_master_recv(client, buf, bufsize);
> +	if (ret != bufsize) {
> +		dev_err(&client->dev, "failed to read values: %d\n", ret);
> +		if (ret < 0)
> +			return ret;
> +		return -EIO;

or simpler
		return ret < 0 ? ret : -EIO;

> +	}
> +
> +	return 0;
> +}
> +
> +/* sysfs attributes */
> +static struct shtc1_data *shtc1_update_client(struct device *dev)
> +{
> +	struct i2c_client *client = to_i2c_client(dev);
> +	struct shtc1_data *data = i2c_get_clientdata(client);
> +

That won't work with the new ABI (please test ;-).
You need something like
	struct shtc1_data *data = dev_get_drvdata(dev);
	struct i2c_client *client = data->client;

This is because the attributes are now attached to the hwmon device,
no longer to the i2c device. The ABI saves the pointer to 'data'
in drvdata for the hwmon device, so you can get it with dev_get_drvdata().

> +	unsigned char buf[SHTC1_RESPONSE_LENGTH];
> +	int val;
> +	int ret;
> +
> +	mutex_lock(&data->update_lock);
> +
> +	/*
> +	* Initialize 'ret' in case we had a valid result before, but
> +	* read too quickly in which case we return the last values.
> +	*/
> +	ret = 0;

A bit excessive. We all know C, or should. Just make it
	int ret = 0;
above; you don't need any comments here.

> +
> +	if (time_after(jiffies, data->last_updated + HZ / 10) || !data->valid) {
> +		ret = shtc1_update_values(client, data, buf, sizeof(buf));
> +		if (ret)
> +			goto out;
> +
> +		/*
> +		* From datasheet:
> +		* T = -45 + 175 * ST / 2^16
> +		* RH = 100 * SRH / 2^16
> +		*
> +		* Adapted for integer fixed point (3 digit) arithmetic.
> +		*/
> +		val = be16_to_cpup((__be16 *)buf);
> +		data->temperature = ((21875 * val) >> 13) - 45000;
> +		val = be16_to_cpup((__be16 *)(buf + 3));
> +		data->humidity = ((12500 * val) >> 13);
> +
> +		data->last_updated = jiffies;
> +		data->valid = 1;
> +	}
> +
> +out:
> +	mutex_unlock(&data->update_lock);
> +
> +	return ret == 0 ? data : ERR_PTR(ret);
> +}
> +
> +static ssize_t shtc1_show_temperature(struct device *dev,
> +				      struct device_attribute *attr,
> +				      char *buf)
> +{
> +	struct shtc1_data *data = shtc1_update_client(dev);
> +	if (IS_ERR(data))
> +		return PTR_ERR(data);
> +
> +	return sprintf(buf, "%d\n", data->temperature);
> +}
> +
> +static ssize_t shtc1_show_humidity(struct device *dev,
> +				   struct device_attribute *attr, char *buf)
> +{
> +	struct shtc1_data *data = shtc1_update_client(dev);
> +	if (IS_ERR(data))
> +		return PTR_ERR(data);
> +
> +	return sprintf(buf, "%d\n", data->humidity);
> +}
> +
> +static DEVICE_ATTR(temp1_input, S_IRUGO, shtc1_show_temperature, NULL);
> +static DEVICE_ATTR(humidity1_input, S_IRUGO, shtc1_show_humidity, NULL);
> +
> +static struct attribute *shtc1_attrs[] = {
> +	&dev_attr_temp1_input.attr,
> +	&dev_attr_humidity1_input.attr,
> +	NULL
> +};
> +ATTRIBUTE_GROUPS(shtc1);
> +
> +static void shtc1_select_command(struct shtc1_data *data)
> +{
> +	if (data->setup.high_precision) {
> +		data->command = data->setup.blocking_io ?
> +				shtc1_cmd_measure_blocking_hpm :
> +				shtc1_cmd_measure_nonblocking_hpm;
> +		data->nonblocking_wait_time = SHTC1_NONBLOCKING_WAIT_TIME_HPM;
> +
> +	} else {
> +		data->command = data->setup.blocking_io ?
> +				shtc1_cmd_measure_blocking_lpm :
> +				shtc1_cmd_measure_nonblocking_lpm;
> +		data->nonblocking_wait_time = SHTC1_NONBLOCKING_WAIT_TIME_LPM;
> +	}
> +}
> +
> +static int shtc1_probe(struct i2c_client *client,
> +		       const struct i2c_device_id *id)
> +{
> +	struct shtc1_data *data;
> +	int err;
> +	struct i2c_adapter *adap = client->adapter;
> +	char id_reg[2];
> +
I would suggest a local variable dev here
	struct device *dev = &client->dev;
to save all the client->dev dereferences below.

> +	if (!i2c_check_functionality(adap, I2C_FUNC_I2C)) {
> +		dev_err(&client->dev,
> +			"adapter does not support plain i2c transactions\n");
> +		return -ENODEV;
> +	}
> +
> +	err = i2c_master_send(client, shtc1_cmd_read_id_reg, SHTC1_CMD_LENGTH);
> +	if (err < 0) {
> +		dev_err(&client->dev, "could not send read command: %d\n", err);

read id command

> +		return -ENODEV;
> +	}
> +	if (err != SHTC1_CMD_LENGTH) {
> +		dev_err(&client->dev, "num bytes send is wrong: %d\n", err);

sent

Also, I would prefer a single if statement.

> +		return -ENODEV;
> +	}
> +	err = i2c_master_recv(client, id_reg, sizeof(id_reg));
> +	if (err != sizeof(id_reg)) {
> +		dev_err(&client->dev, "could not read ID register: %d\n", err);
> +		return -ENODEV;
> +	}
> +	if ((id_reg[1] & SHTC1_ID_REG_MASK) != SHTC1_ID_REG_CONTENT) {
> +		dev_err(&client->dev, "ID register doesn't match\n");
> +		return -ENODEV;
> +	}
> +
> +	data = devm_kzalloc(&client->dev, sizeof(*data), GFP_KERNEL);
> +	if (!data)
> +		return -ENOMEM;
> +
> +	/* defaults: blocking, high precision mode */
> +	data->setup.blocking_io = true;
> +	data->setup.high_precision = true;
> +
> +	if (client->dev.platform_data)
> +		data->setup = *(struct shtc1_platform_data *)client->dev.platform_data;

Line too long here. One way to solve it would be to use a local dev variable
as sugested above.

> +	shtc1_select_command(data);
> +	i2c_set_clientdata(client, data);

Not needed. But you need to save client for the update function.
	data->client = client;

> +	mutex_init(&data->update_lock);
> +
> +	data->hwmon_dev = devm_hwmon_device_register_with_groups(&client->dev,

You don't need to keep hwmon_dev in the data structure. Just use a local variable.

> +								 client->name,
> +								 data,
> +								 shtc1_groups);
> +	if (IS_ERR(data->hwmon_dev))
> +		dev_dbg(&client->dev, "unable to register hwmon device\n");
> +
> +	return PTR_ERR_OR_ZERO(data->hwmon_dev);
> +}
> +
> +/* device ID table */
> +static const struct i2c_device_id shtc1_id[] = {
> +	{ "shtc1", 0 },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(i2c, shtc1_id);
> +
> +static struct i2c_driver shtc1_i2c_driver = {
> +	.driver.name  = "shtc1",
> +	.probe        = shtc1_probe,
> +	.id_table     = shtc1_id,
> +};
> +
> +module_i2c_driver(shtc1_i2c_driver);
> +
> +MODULE_AUTHOR("Johannes Winkelmann <johannes.winkelmann@sensirion.com>");
> +MODULE_DESCRIPTION("Sensirion SHTC1 humidity and temperature sensor driver");
> +MODULE_LICENSE("GPL");
> diff --git a/include/linux/platform_data/shtc1.h b/include/linux/platform_data/shtc1.h
> new file mode 100644
> index 0000000..b06e3db
> --- /dev/null
> +++ b/include/linux/platform_data/shtc1.h
> @@ -0,0 +1,24 @@
> +/*
> + * Copyright (C) 2014 Sensirion AG, Switzerland
> + * Author: Johannes Winkelmann <johannes.winkelmann@sensirion.com>
> + *
> + * This software is licensed under the terms of the GNU General Public
> + * License version 2, as published by the Free Software Foundation, and
> + * may be copied, distributed, and modified under those terms.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + */
> +
> +#ifndef __SHTC1_H_
> +#define __SHTC1_H_
> +
> +struct shtc1_platform_data {
> +	bool blocking_io;
> +	bool high_precision;
> +};
> +
> +#endif /* __SHTC1_H_ */
>

