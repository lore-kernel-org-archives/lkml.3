Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758062Ab3KIBk2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 20:40:28 -0500
Received: from mail.active-venture.com ([67.228.131.205]:50633 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757850Ab3KIBk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 20:40:26 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <527D9286.4080009@roeck-us.net>
Date: Fri, 08 Nov 2013 17:40:22 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Arnaud Ebalard <arno@natisbad.org>, Jean Delvare <khali@linux-fr.org>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>, Grant Likely <grant.likely@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        lm-sensors@lm-sensors.org
Subject: Re: [PATCHv0] hwmon: Add support for GMT G751 Temp. Sensor and Thermal
 Watchdog
References: <87ob5uv5bv.fsf@natisbad.org>
In-Reply-To: <87ob5uv5bv.fsf@natisbad.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2013 03:31 PM, Arnaud Ebalard wrote:
>
> This patch adds support for GMT G751 Temperature Sensor and Thermal
> Watchdog I2C chip. It has been tested via DT on a Netgear ReadyNAS
> 2120 (Marvell Armada XP based ARM device).
>
> Signed-off-by: Arnaud Ebalard <arno@natisbad.org>

Arnaud,

unless I am missing something, this is just an lm75 with a different name.

Please use the lm75 driver and add the g751 parameters to it.

Thanks,
Guenter

> ---
>   Documentation/devicetree/bindings/hwmon/g751.txt   |  24 +
>   .../devicetree/bindings/vendor-prefixes.txt        |   1 +
>   Documentation/hwmon/g751                           |  44 ++
>   drivers/hwmon/Kconfig                              |  11 +
>   drivers/hwmon/Makefile                             |   1 +
>   drivers/hwmon/g751.c                               | 481 +++++++++++++++++++++
>   include/linux/platform_data/g751.h                 |  35 ++
>   7 files changed, 597 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/hwmon/g751.txt
>   create mode 100644 Documentation/hwmon/g751
>   create mode 100644 drivers/hwmon/g751.c
>   create mode 100644 include/linux/platform_data/g751.h
>
> diff --git a/Documentation/devicetree/bindings/hwmon/g751.txt b/Documentation/devicetree/bindings/hwmon/g751.txt
> new file mode 100644
> index 0000000..ebec788
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/hwmon/g751.txt
> @@ -0,0 +1,24 @@
> +GMT G751 Digital Temperature Sensor and Thermal Watchdog
> +
> +Required node properties:
> +
> + - "compatible": must be either "gmt,g751"
> + - "reg": I2C bus address of the device
> +
> +Optional properties:
> +
> + - "polarity": Over temperature Shutdown (OS) output polarity. Accepted values
> +	       are 0 and 1. 0 (the default) is used to make the output active
> +	       low. 1 makes the output active high.
> +
> +Additional information on operational parameters for the device is available
> +in Documentation/hwmon/g751. A detailed datasheet for the device is available
> +at http://natisbad.org/NAS4/refs/GMT_G751.pdf.
> +
> +Example g751 node:
> +
> +   g751: g751@4c {
> +	compatible = "gmt,g751";
> +	reg = <0x4c>;
> +	polarity = <1>; /* OS output Active High */
> +   };
> diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
> index 2956800..634c35f 100644
> --- a/Documentation/devicetree/bindings/vendor-prefixes.txt
> +++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
> @@ -28,6 +28,7 @@ est	ESTeem Wireless Modems
>   fsl	Freescale Semiconductor
>   GEFanuc	GE Fanuc Intelligent Platforms Embedded Systems, Inc.
>   gef	GE Fanuc Intelligent Platforms Embedded Systems, Inc.
> +gmt	Global Mixed-mode Technology Inc.
>   hisilicon	Hisilicon Limited.
>   hp	Hewlett Packard
>   ibm	International Business Machines (IBM)
> diff --git a/Documentation/hwmon/g751 b/Documentation/hwmon/g751
> new file mode 100644
> index 0000000..3508d53
> --- /dev/null
> +++ b/Documentation/hwmon/g751
> @@ -0,0 +1,44 @@
> +Kernel driver g751
> +==================
> +
> +The GMT G751 is an I2C digital temperature sensor and thermal watchdog. For
> +additional information, a detailed datasheet of the chip is available at
> +http://natisbad.org/NAS4/refs/GMT_G751.pdf.
> +
> +sysfs bindings (found in a subdirectory of/sys/bus/i2c/drivers/g751/) are
> +described below. They are available to the user to control the operation
> +of the device. The main information provided by the device (temperature,
> +via temp_input) is usually used by a userland daemon like fancontrol.
> +
> +Note that polarity of Over temperature Shutdown (OS) output is considered
> +a hardware characteristics of the system and can be modified via devicetree
> +bindings documented in Documentation/devicetree/bindings/hwmon/g751.txt or
> +using a specific platform_data structure in board initialization file (see
> +include/linux/platform_data/g751.h).
> +
> +temp_input: current temperature input value in millidegree Celsius. This
> +      parameter is RO.
> +
> +thyst: defined Thyst value in millidegree Celsius. See 'mode' below for
> +      details. Default value depends on G751 flavour (45000 for G751-1,
> +      75000 for G751-2). This parameter is RW.
> +
> +tos: defined Tos value in millidegree Celsius. See 'mode' below for details.
> +      Default value depends on G751 flavour (50000 for G751-1, 80000 for
> +      G751-2). This parameter is RW.
> +
> +fault_queue: number of faults necessary to detect before setting OS output.
> +      This can be used to avoid false tripping due to noise. Valid values
> +      are 1 (default), 2, 4 and 6. This parameter is RW.
> +
> +mode: used to toggle between comparatore mode (0, default mode) and interrupt
> +      mode (1). In comparator mode, the OS output behaves like a thermostat
> +      and becomes active when temperature exceeds Tos limit. It then leaves
> +      the active state when the temperature drops again below Thyst. In
> +      interrupt mode, exceeding Tos also makes OS output active in which case
> +      it will remain active until reading any register. It can then be activated
> +      again only after temperature goes below Thyst. This parameter is RW.
> +
> +shutdown: when set to 1 (0 being the default), the G751 goes to low power
> +      shutdown mode. Placing G751 in shutdown mode also has the effect of
> +      resetting the OS output. This parameter is RW.
> diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
> index b3ab9d4..524d1d7 100644
> --- a/drivers/hwmon/Kconfig
> +++ b/drivers/hwmon/Kconfig
> @@ -451,6 +451,17 @@ config SENSORS_FSCHMD
>   	  This driver can also be built as a module.  If so, the module
>   	  will be called fschmd.
>
> +config SENSORS_G751
> +	tristate "GMT G751"
> +	depends on I2C
> +	help
> +	  If you say yes here you get support for Global Mixed-mode
> +	  Technology Inc G751 Digital Temperature Sensor and Thermal
> +	  Watchdog.
> +
> +	  This driver can also be built as a module.  If so, the module
> +	  will be called g751.
> +
>   config SENSORS_G760A
>   	tristate "GMT G760A"
>   	depends on I2C
> diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
> index ec7cde0..5c8bfc6 100644
> --- a/drivers/hwmon/Makefile
> +++ b/drivers/hwmon/Makefile
> @@ -59,6 +59,7 @@ obj-$(CONFIG_SENSORS_F71882FG)	+= f71882fg.o
>   obj-$(CONFIG_SENSORS_F75375S)	+= f75375s.o
>   obj-$(CONFIG_SENSORS_FAM15H_POWER) += fam15h_power.o
>   obj-$(CONFIG_SENSORS_FSCHMD)	+= fschmd.o
> +obj-$(CONFIG_SENSORS_G751)	+= g751.o
>   obj-$(CONFIG_SENSORS_G760A)	+= g760a.o
>   obj-$(CONFIG_SENSORS_G762)	+= g762.o
>   obj-$(CONFIG_SENSORS_GL518SM)	+= gl518sm.o
> diff --git a/drivers/hwmon/g751.c b/drivers/hwmon/g751.c
> new file mode 100644
> index 0000000..9c85c41
> --- /dev/null
> +++ b/drivers/hwmon/g751.c
> @@ -0,0 +1,481 @@
> +/*
> + * g751 - Driver for the Global Mixed-mode Technology Inc. G751 digital
> + *        temperature sensor and thermal watchdog chip.
> + *
> + * Copyright (C) 2013, Arnaud EBALARD <arno@natisbad.org>
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
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation.
> + */
> +
> +#include <linux/device.h>
> +#include <linux/module.h>
> +#include <linux/init.h>
> +#include <linux/i2c.h>
> +#include <linux/hwmon.h>
> +#include <linux/hwmon-sysfs.h>
> +#include <linux/err.h>
> +#include <linux/mutex.h>
> +#include <linux/kernel.h>
> +#include <linux/of.h>
> +#include <linux/of_device.h>
> +#include <linux/platform_data/g751.h>
> +
> +#define DRVNAME "g751"
> +
> +static const struct i2c_device_id g751_id[] = {
> +	{ "g751", 0 },
> +	{ }
> +};
> +MODULE_DEVICE_TABLE(i2c, g751_id);
> +
> +/* Four data registers can be addressed via a pointer register */
> +enum g751_data_reg {
> +	G751_REG_TEMP  = 0x00, /* 16-bit reg */
> +	G751_REG_CONF  = 0x01, /*  8-bit reg */
> +	G751_REG_THYST = 0x02, /* 16-bit reg */
> +	G751_REG_TOS   = 0x03, /* 16-bit reg */
> +};
> +
> +/* Provide size of given register */
> +#define G751_DATA_REG_LEN(reg) (((reg) == G751_REG_CONF) ? 1 : 2)
> +
> +/* Configuration register bits: shifts and masks */
> +#define G751_CONF_FQUEUE_SHIFT   3
> +#define G751_CONF_FQUEUE_MASK    0x03
> +#define G751_CONF_POLARITY_SHIFT 2
> +#define G751_CONF_POLARITY_MASK  0x02
> +#define G751_CONF_MODE_SHIFT     1
> +#define G751_CONF_MODE_MASK      0x01
> +#define G751_CONF_SHUTDOWN_SHIFT 0
> +#define G751_CONF_SHUTDOWN_MASK  0x01
> +
> +/* Temperature conversion helpers from/to register value */
> +static inline void temp_from_reg(int32_t *temp, u8 *regval)
> +{
> +	int8_t *buf = (int8_t *)(regval);
> +	*temp = (buf[0]*1000 + ((buf[1] & 0x80) ? 500 : 0));
> +}
> +
> +static inline void temp_to_reg(u8 *regval, int32_t temp)
> +{
> +	regval[0] = (temp < 0 && temp/1000 == 0) ? 0xff : temp/1000;
> +	regval[1] = ((temp/500) & 0x1) ? 0x80 : 0x00;
> +}
> +
> +struct g751_data {
> +	struct i2c_client *client;
> +	struct device *hwmon_dev;
> +	struct mutex lock;
> +};
> +
> +/*
> + * Read content of 'reg' register and put result in 'val' buffer if
> + * everything went ok; 0 is returned in that case. A negative value
> + * is returned on error, in which case 'val' is not updated.
> + */
> +static int g751_reg_read(struct device *dev, u8 reg, u8 *val)
> +{
> +	struct i2c_client *client = to_i2c_client(dev);
> +	u8 buf[2] = { reg , 0 };
> +	struct i2c_msg msgs[2] = {
> +		{
> +			.addr = client->addr,
> +			.flags = client->flags,
> +			.len = sizeof(u8),
> +			.buf = buf
> +		},
> +		{
> +			.addr = client->addr,
> +			.flags = client->flags | I2C_M_RD,
> +			.len = G751_DATA_REG_LEN(reg),
> +			.buf = buf
> +		}
> +	};
> +	int ret;
> +
> +	BUG_ON(reg > 3);
> +
> +	ret = i2c_transfer(client->adapter, msgs, 2);
> +	if (ret < 0) {
> +		dev_err(&client->dev, "%s: register read failed\n", __func__);
> +		return ret;
> +	}
> +	memcpy(val, buf, G751_DATA_REG_LEN(reg));
> +
> +	return 0;
> +}
> +
> +/*
> + * Write content of given 'val' buffer to 'reg' register. 0 is returned
> + * on success. A negative value is returned on error.
> + */
> +static int g751_reg_write(struct device *dev, u8 reg, u8 *val)
> +{
> +	struct i2c_client *client = to_i2c_client(dev);
> +	u8 buf[3] = { reg, 0, 0 };
> +	struct i2c_msg msgs[1] = {
> +		{
> +			.addr = client->addr,
> +			.flags = client->flags,
> +			.len = G751_DATA_REG_LEN(reg) + 1,
> +			.buf = buf
> +		}
> +	};
> +	int ret;
> +
> +	BUG_ON(reg > 3 || reg == 0); /* temp reg (0) is read-only */
> +
> +	memcpy(&buf[1], val, G751_DATA_REG_LEN(reg));
> +	ret = i2c_transfer(client->adapter, msgs, 1);
> +	if (ret < 0) {
> +		dev_err(&client->dev, "%s: register write failed\n", __func__);
> +		return ret;
> +	}
> +
> +	return 0;
> +}
> +
> +/* Generic helper to extract some specific bits of conf register */
> +static int conf_reg_bits_get(struct device *dev, u8 *val,
> +			     u8 bitshift, u8 bitmask)
> +{
> +	struct i2c_client *client = to_i2c_client(dev);
> +	struct g751_data *data = i2c_get_clientdata(client);
> +	u8 regval;
> +	int ret;
> +
> +	mutex_lock(&data->lock);
> +	ret = g751_reg_read(dev, G751_REG_CONF, &regval);
> +	mutex_unlock(&data->lock);
> +	if (ret < 0)
> +		return ret;
> +
> +	*val = (regval >> bitshift) & bitmask;
> +
> +	return 0;
> +}
> +
> +/* Generic helper to set some specific bits of conf register */
> +static int conf_reg_bits_set(struct device *dev, u8 val,
> +			     u8 bitshift, u8 bitmask)
> +{
> +	struct i2c_client *client = to_i2c_client(dev);
> +	struct g751_data *data = i2c_get_clientdata(client);
> +	u8 regval;
> +	int ret;
> +
> +	mutex_lock(&data->lock);
> +	ret = g751_reg_read(dev, G751_REG_CONF, &regval);
> +	if (ret < 0)
> +		goto out;
> +
> +	regval &= ~(bitmask << bitshift);
> +	regval |= val << bitshift;
> +
> +	ret = g751_reg_write(dev, G751_REG_CONF, &regval);
> + out:
> +	mutex_unlock(&data->lock);
> +
> +	return ret;
> +}
> +
> +/*
> + * sysfs
> + */
> +
> +#define show_temp(value, reg)						\
> +static ssize_t show_##value(struct device *dev, struct device_attribute *da, \
> +			    char *buf) \
> +{ \
> +	u8 regval[2];					\
> +	int32_t temp;					\
> +	int ret;					\
> +							\
> +	ret = g751_reg_read(dev, reg, regval);		\
> +	if (ret < 0)					\
> +		return ret;				\
> +	temp_from_reg(&temp, regval);			\
> +							\
> +	return sprintf(buf, "%d\n", temp);		\
> +}
> +
> +show_temp(temp_input, G751_REG_TEMP);
> +show_temp(temp_hyst, G751_REG_THYST);
> +show_temp(temp_os, G751_REG_TOS);
> +
> +#define set_temp(value, reg)						\
> +static ssize_t set_##value(struct device *dev, struct device_attribute *da, \
> +			   const char *buf, size_t count) \
> +{ \
> +	u8 regval[2];					\
> +	int32_t temp;					\
> +	int ret;					\
> +							\
> +	ret = kstrtos32(buf, 10, &temp);		\
> +	if (ret)					\
> +		return ret;				\
> +	temp_to_reg(regval, temp);			\
> +							\
> +	ret = g751_reg_write(dev, reg, regval);		\
> +	if (ret < 0)					\
> +		return ret;				\
> +							\
> +	return count;					\
> +}
> +
> +set_temp(temp_hyst, G751_REG_THYST);
> +set_temp(temp_os, G751_REG_TOS);
> +
> +/*
> + * Read and write functions for fault_queue sysfs file. Get and set
> + * fault_queue length (either 1 (default), 2, 4 or 6).
> + */
> +static ssize_t show_fqueue(struct device *dev, struct device_attribute *da,
> +			   char *buf)
> +{
> +	u8 regval;
> +	int ret;
> +
> +	ret = conf_reg_bits_get(dev, &regval, G751_CONF_FQUEUE_SHIFT,
> +				G751_CONF_FQUEUE_MASK);
> +	if (ret < 0)
> +		return ret;
> +
> +	return sprintf(buf, "%d\n", regval ? regval * 2 : 1);
> +}
> +
> +static ssize_t set_fqueue(struct device *dev,
> +			  struct device_attribute *da,
> +			  const char *buf, size_t count)
> +{
> +	int ret;
> +	u8 val;
> +
> +	if (kstrtou8(buf, 10, &val))
> +		return -EINVAL;
> +
> +	switch (val) {
> +	case 1:
> +		val = 0;
> +		break;
> +	case 2:
> +	case 4:
> +	case 6:
> +		val /= 2;
> +		break;
> +	default:
> +		return -EINVAL;
> +	}
> +
> +	ret = conf_reg_bits_set(dev, val, G751_CONF_FQUEUE_SHIFT,
> +				G751_CONF_FQUEUE_MASK);
> +
> +	return ret < 0 ? ret : count;
> +}
> +
> +/*
> + * Read and write functions for mode sysfs file. Get and set mode (0 for
> + * comparator mode and 1 for interrupt mode).
> + */
> +static ssize_t show_mode(struct device *dev, struct device_attribute *da,
> +			 char *buf)
> +{
> +	u8 regval;
> +	int ret;
> +
> +	ret = conf_reg_bits_get(dev, &regval, G751_CONF_MODE_SHIFT,
> +				G751_CONF_MODE_MASK);
> +	if (ret < 0)
> +		return ret;
> +
> +	return sprintf(buf, "%d\n", regval);
> +}
> +
> +static ssize_t set_mode(struct device *dev,
> +			struct device_attribute *da,
> +			const char *buf, size_t count)
> +{
> +	int ret;
> +	u8 val;
> +
> +	if (kstrtou8(buf, 10, &val) || val > 1)
> +		return -EINVAL;
> +
> +	ret = conf_reg_bits_set(dev, val, G751_CONF_MODE_SHIFT,
> +				G751_CONF_MODE_MASK);
> +
> +	return ret < 0 ? ret : count;
> +}
> +
> +/*
> + * Read and write functions for shutdown sysfs file. Get and set low power
> + * shutdown mode (1 for low power shutdown mode).
> + */
> +static ssize_t show_shutdown(struct device *dev,
> +			     struct device_attribute *da, char *buf)
> +{
> +	u8 regval;
> +	int ret;
> +
> +	ret = conf_reg_bits_get(dev, &regval, G751_CONF_MODE_SHIFT,
> +				G751_CONF_MODE_MASK);
> +	if (ret < 0)
> +		return ret;
> +
> +	return sprintf(buf, "%d\n", regval);
> +}
> +
> +static ssize_t set_shutdown(struct device *dev,
> +			    struct device_attribute *da,
> +			    const char *buf, size_t count)
> +{
> +	int ret;
> +	u8 val;
> +
> +	if (kstrtou8(buf, 10, &val) || val > 1)
> +		return -EINVAL;
> +
> +	ret = conf_reg_bits_set(dev, val, G751_CONF_SHUTDOWN_SHIFT,
> +				G751_CONF_SHUTDOWN_MASK);
> +
> +	return ret < 0 ? ret : count;
> +}
> +
> +#ifdef CONFIG_OF
> +static struct of_device_id g751_dt_match[] = {
> +	{ .compatible = "gmt,g751" },
> +	{ },
> +};
> +
> +static void g751_of_import_polarity(struct i2c_client *client, int *pol)
> +{
> +	const __be32 *prop;
> +	int len;
> +
> +	prop = of_get_property(client->dev.of_node, "polarity", &len);
> +	if (!prop || len != sizeof(u32))
> +		return;
> +
> +	*pol = !!be32_to_cpu(prop[0]);
> +}
> +#else
> +static void g751_of_import_polarity(struct i2c_client *client, int *pol) {}
> +#endif
> +
> +static DEVICE_ATTR(temp_input, S_IRUGO, show_temp_input, NULL);
> +static DEVICE_ATTR(thyst, S_IRUGO|S_IWUSR, show_temp_hyst, set_temp_hyst);
> +static DEVICE_ATTR(tos, S_IRUGO|S_IWUSR, show_temp_os, set_temp_os);
> +static DEVICE_ATTR(fault_queue, S_IRUGO|S_IWUSR, show_fqueue, set_fqueue);
> +static DEVICE_ATTR(mode, S_IRUGO|S_IWUSR, show_mode, set_mode);
> +static DEVICE_ATTR(shutdown, S_IRUGO|S_IWUSR, show_shutdown, set_shutdown);
> +
> +/* Driver data */
> +static struct attribute *g751_attributes[] = {
> +	&dev_attr_temp_input.attr,
> +	&dev_attr_thyst.attr,
> +	&dev_attr_tos.attr,
> +	&dev_attr_fault_queue.attr,
> +	&dev_attr_mode.attr,
> +	&dev_attr_shutdown.attr,
> +	NULL
> +};
> +
> +static const struct attribute_group g751_group = {
> +	.name = "g751",
> +	.attrs = g751_attributes,
> +};
> +
> +static int g751_probe(struct i2c_client *client, const struct i2c_device_id *id)
> +{
> +	struct g751_platform_data *pdata;
> +	struct g751_data *data;
> +	int polarity = -1;
> +	int ret;
> +
> +	if (!i2c_check_functionality(client->adapter, I2C_FUNC_SMBUS_BYTE_DATA))
> +		return -ENODEV;
> +
> +	data = devm_kzalloc(&client->dev, sizeof(struct g751_data), GFP_KERNEL);
> +	if (!data)
> +		return -ENOMEM;
> +
> +	i2c_set_clientdata(client, data);
> +	data->client = client;
> +	mutex_init(&data->lock);
> +
> +	/* Change polarity if requested either via platform data or OF */
> +	pdata = dev_get_platdata(&client->dev);
> +	if (pdata)
> +		polarity = !!pdata->polarity;
> +	else
> +		g751_of_import_polarity(client, &polarity);
> +
> +	if (polarity != -1) {
> +		dev_dbg(&client->dev, "found polarity (%d)\n", polarity);
> +
> +		ret = conf_reg_bits_set(&client->dev, polarity,
> +					G751_CONF_POLARITY_SHIFT,
> +					G751_CONF_POLARITY_MASK);
> +		if (ret)
> +			dev_err(&client->dev, "unable to set polarity (%d)\n",
> +				polarity);
> +	}
> +
> +	/* Register sysfs hooks */
> +	ret = sysfs_create_group(&client->dev.kobj, &g751_group);
> +	if (ret)
> +		goto out;
> +
> +	data->hwmon_dev = hwmon_device_register(&client->dev);
> +	if (IS_ERR(data->hwmon_dev)) {
> +		ret = PTR_ERR(data->hwmon_dev);
> +		goto sysfs_clean;
> +	}
> +
> +	return 0;
> +
> + sysfs_clean:
> +	sysfs_remove_group(&client->dev.kobj, &g751_group);
> +
> + out:
> +	return ret;
> +}
> +
> +static int g751_remove(struct i2c_client *client)
> +{
> +	struct g751_data *data = i2c_get_clientdata(client);
> +
> +	hwmon_device_unregister(data->hwmon_dev);
> +	sysfs_remove_group(&client->dev.kobj, &g751_group);
> +
> +	return 0;
> +}
> +
> +static struct i2c_driver g751_driver = {
> +	.driver = {
> +		.name = DRVNAME,
> +		.owner = THIS_MODULE,
> +		.of_match_table = of_match_ptr(g751_dt_match),
> +	},
> +	.probe	  = g751_probe,
> +	.remove	  = g751_remove,
> +	.id_table = g751_id,
> +};
> +
> +module_i2c_driver(g751_driver);
> +
> +MODULE_AUTHOR("Arnaud EBALARD <arno@natisbad.org>");
> +MODULE_DESCRIPTION("GMT G751 driver");
> +MODULE_LICENSE("GPL");
> diff --git a/include/linux/platform_data/g751.h b/include/linux/platform_data/g751.h
> new file mode 100644
> index 0000000..fec0415
> --- /dev/null
> +++ b/include/linux/platform_data/g751.h
> @@ -0,0 +1,35 @@
> +/*
> + * Platform data structure for g751 temperature sensor and thermal
> + * watchdog driver
> + *
> + * Copyright (C) 2013, Arnaud EBALARD <arno@natisbad.org>
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
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation.
> + */
> +#ifndef __LINUX_PLATFORM_DATA_G751_H__
> +#define __LINUX_PLATFORM_DATA_G751_H__
> +
> +/*
> + * Following structure can be used to set g751 driver platform
> + * specific data during board init, i.e. over temperature (OS)
> + * output polarity: 0 for active low (the default), 1 for active
> + * high).
> + */
> +
> +struct g751_platform_data {
> +	u8 polarity;
> +};
> +
> +#endif /* __LINUX_PLATFORM_DATA_G751_H__ */
>

