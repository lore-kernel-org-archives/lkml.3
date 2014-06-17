Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933339AbaFQQNR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 12:13:17 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:36869 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933090AbaFQQNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 12:13:15 -0400
Date: Tue, 17 Jun 2014 17:11:05 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Heiko Schocher <hs@denx.de>
Cc: "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        Jean Delvare <khali@linux-fr.org>, Guenter Roeck <linux@roeck-us.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v4] hwmon: Driver for TI TMP103 temperature sensor
Message-ID: <20140617161105.GF8930@leverpostej>
References: <1402992713-22711-1-git-send-email-hs@denx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1402992713-22711-1-git-send-email-hs@denx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 17, 2014 at 09:11:53AM +0100, Heiko Schocher wrote:
> Driver for the TI TMP103.
> 
> The TI TMP103 is similar to the TMP102.  It differs from the TMP102
> by having only 8 bit registers.
> 
> Signed-off-by: Heiko Schocher <hs@denx.de>
> 
> ---
> 
> Cc: Jean Delvare <khali@linux-fr.org>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Cc: linux-kernel@vger.kernel.org
> Cc: devicetree@vger.kernel.org
> Cc: linux-doc@vger.kernel.org
> 
> - change for v2:
>   - add comments from GuenterRoeck:
>     - remove Cc from commit subject
>     - add devicetree maintainer
>     - move Documentation to Documentation/hwmon/tmp103
>     - remove devicetree bindings from Documentation
>     - add compatible string to
>       "Documentation/devicetree/bindings/i2c/trivial-devices.txt"
>     - remove CamelCase
>     - fix Codingstyle issues
>     - use ATTRIBUTE_GROUPS and devm_hwmon_device_register_with_groups()
>     - remove unsused define TMP103_CONFIG_RD_ONLY
>     - restore config register when exit()
>     - use regmap
> - changes for v3:
>   again a lot of fantastic tips how to use regmap efficiently
>   from Guenter Roeck:
>   - get rid of "struct tmp103"
>   - get rid of "static const u8 tmp103_reg[]"
>   - get rid of mutex lock
>   - drop config_orig entirely
>   - use regmap_update_bits()
> - changes for v4:
>   - add comment from Guenter Roeck:
>     define TMP103_CONFIG_MASK and TMP103_CONF_SD_MASK
>     separately to ensure you catch all the to-be-cleared bits.
> 
>  .../devicetree/bindings/i2c/trivial-devices.txt    |   1 +
>  Documentation/hwmon/tmp103                         |  28 +++
>  drivers/hwmon/Kconfig                              |  10 +
>  drivers/hwmon/Makefile                             |   1 +
>  drivers/hwmon/tmp103.c                             | 207 +++++++++++++++++++++
>  5 files changed, 247 insertions(+)
>  create mode 100644 Documentation/hwmon/tmp103
>  create mode 100644 drivers/hwmon/tmp103.c
> 
> diff --git a/Documentation/devicetree/bindings/i2c/trivial-devices.txt b/Documentation/devicetree/bindings/i2c/trivial-devices.txt
> index bef86e5..fc944e0 100644
> --- a/Documentation/devicetree/bindings/i2c/trivial-devices.txt
> +++ b/Documentation/devicetree/bindings/i2c/trivial-devices.txt
> @@ -83,5 +83,6 @@ stm,m41t80		M41T80 - SERIAL ACCESS RTC WITH ALARMS
>  taos,tsl2550		Ambient Light Sensor with SMBUS/Two Wire Serial Interface
>  ti,tsc2003		I2C Touch-Screen Controller
>  ti,tmp102		Low Power Digital Temperature Sensor with SMBUS/Two Wire Serial Interface
> +ti,tmp103		Low Power Digital Temperature Sensor with SMBUS/Two Wire Serial Interface
>  ti,tmp275		Digital Temperature Sensor
>  winbond,wpct301		i2c trusted platform module (TPM)
> diff --git a/Documentation/hwmon/tmp103 b/Documentation/hwmon/tmp103
> new file mode 100644
> index 0000000..ec00a15
> --- /dev/null
> +++ b/Documentation/hwmon/tmp103
> @@ -0,0 +1,28 @@
> +Kernel driver tmp103
> +====================
> +
> +Supported chips:
> +  * Texas Instruments TMP103
> +    Prefix: 'tmp103'
> +    Addresses scanned: none
> +    Product info and datasheet: http://www.ti.com/product/tmp103
> +
> +Author:
> +	Heiko Schocher <hs@denx.de>
> +
> +Description
> +-----------
> +
> +The TMP103 is a digital output temperature sensor in a four-ball
> +wafer chip-scale package (WCSP). The TMP103 is capable of reading
> +temperatures to a resolution of 1°C. The TMP103 is specified for
> +operation over a temperature range of –40°C to +125°C.
> +
> +Resolution: 8 Bits
> +Accuracy: ±1°C Typ (–10°C to +100°C)
> +
> +The driver provides the common sysfs-interface for temperatures (see
> +Documentation/hwmon/sysfs-interface under Temperatures).
> +
> +Please refer how to instantiate this driver:
> +Documentation/i2c/instantiating-devices
> diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
> index 08531a1..c882d4b 100644
> --- a/drivers/hwmon/Kconfig
> +++ b/drivers/hwmon/Kconfig
> @@ -1391,6 +1391,16 @@ config SENSORS_TMP102
>  	  This driver can also be built as a module.  If so, the module
>  	  will be called tmp102.
>  
> +config SENSORS_TMP103
> +	tristate "Texas Instruments TMP103"
> +	depends on I2C
> +	help
> +	  If you say yes here you get support for Texas Instruments TMP103
> +	  sensor chips.
> +
> +	  This driver can also be built as a module.  If so, the module
> +	  will be called tmp103.
> +
>  config SENSORS_TMP401
>  	tristate "Texas Instruments TMP401 and compatibles"
>  	depends on I2C
> diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
> index 3dc0f02..cc0df1ef 100644
> --- a/drivers/hwmon/Makefile
> +++ b/drivers/hwmon/Makefile
> @@ -135,6 +135,7 @@ obj-$(CONFIG_SENSORS_SMSC47M192)+= smsc47m192.o
>  obj-$(CONFIG_SENSORS_AMC6821)	+= amc6821.o
>  obj-$(CONFIG_SENSORS_THMC50)	+= thmc50.o
>  obj-$(CONFIG_SENSORS_TMP102)	+= tmp102.o
> +obj-$(CONFIG_SENSORS_TMP103)	+= tmp103.o
>  obj-$(CONFIG_SENSORS_TMP401)	+= tmp401.o
>  obj-$(CONFIG_SENSORS_TMP421)	+= tmp421.o
>  obj-$(CONFIG_SENSORS_TWL4030_MADC)+= twl4030-madc-hwmon.o
> diff --git a/drivers/hwmon/tmp103.c b/drivers/hwmon/tmp103.c
> new file mode 100644
> index 0000000..d133d09
> --- /dev/null
> +++ b/drivers/hwmon/tmp103.c
> @@ -0,0 +1,207 @@
> +/*
> + * Texas Instruments TMP103 SMBus temperature sensor driver
> + * Copyright (C) 2014 Heiko Schocher <hs@denx.de>
> + *
> + * Based on:
> + * Texas Instruments TMP102 SMBus temperature sensor driver
> + *
> + * Copyright (C) 2010 Steven King <sfking@fdwdc.com>
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
> +#include <linux/regmap.h>
> +
> +#define	DRIVER_NAME "tmp103"
> +
> +#define TMP103_TEMP_REG		0x00
> +#define TMP103_CONF_REG		0x01
> +#define TMP103_TLOW_REG		0x02
> +#define TMP103_THIGH_REG	0x03
> +
> +#define TMP103_CONF_M0		0x01
> +#define TMP103_CONF_M1		0x02
> +#define TMP103_CONF_LC		0x04
> +#define TMP103_CONF_FL		0x08
> +#define TMP103_CONF_FH		0x10
> +#define TMP103_CONF_CR0		0x20
> +#define TMP103_CONF_CR1		0x40
> +#define TMP103_CONF_ID		0x80
> +#define TMP103_CONF_SD		(TMP103_CONF_M0 | TMP103_CONF_M1)
> +#define TMP103_CONF_SD_MASK	(TMP103_CONF_M0 | TMP103_CONF_M1)
> +
> +#define TMP103_CONFIG		(TMP103_CONF_CR1 | TMP103_CONF_M1)
> +#define TMP103_CONFIG_MASK	(TMP103_CONF_CR0 | TMP103_CONF_CR1 | \
> +				 TMP103_CONF_M0 | TMP103_CONF_M1)
> +
> +static inline int tmp103_reg_to_mc(s8 val)
> +{
> +	return val * 1000;
> +}
> +
> +static inline u8 tmp103_mc_to_reg(int val)
> +{
> +	return DIV_ROUND_CLOSEST(val, 1000);
> +}
> +
> +static ssize_t tmp103_show_temp(struct device *dev,
> +				struct device_attribute *attr,
> +				char *buf)
> +{
> +	struct sensor_device_attribute *sda = to_sensor_dev_attr(attr);
> +	struct regmap *regmap = dev_get_drvdata(dev);
> +	unsigned int regval;
> +	int ret;
> +
> +	ret = regmap_read(regmap, sda->index, &regval);
> +	if (ret < 0)
> +		return ret;
> +
> +	return sprintf(buf, "%d\n", tmp103_reg_to_mc(regval));
> +}
> +
> +static ssize_t tmp103_set_temp(struct device *dev,
> +			       struct device_attribute *attr,
> +			       const char *buf, size_t count)
> +{
> +	struct sensor_device_attribute *sda = to_sensor_dev_attr(attr);
> +	struct regmap *regmap = dev_get_drvdata(dev);
> +	long val;
> +	int ret;
> +
> +	if (kstrtol(buf, 10, &val) < 0)
> +		return -EINVAL;
> +
> +	val = clamp_val(val, -55000, 127000);
> +	ret = regmap_write(regmap, sda->index, tmp103_mc_to_reg(val));
> +	return ret ? ret : count;
> +}
> +
> +static SENSOR_DEVICE_ATTR(temp1_input, S_IRUGO, tmp103_show_temp, NULL ,
> +			  TMP103_TEMP_REG);
> +
> +static SENSOR_DEVICE_ATTR(temp1_min, S_IWUSR | S_IRUGO, tmp103_show_temp,
> +			  tmp103_set_temp, TMP103_TLOW_REG);
> +
> +static SENSOR_DEVICE_ATTR(temp1_max, S_IWUSR | S_IRUGO, tmp103_show_temp,
> +			  tmp103_set_temp, TMP103_THIGH_REG);
> +
> +static struct attribute *tmp103_attrs[] = {
> +	&sensor_dev_attr_temp1_input.dev_attr.attr,
> +	&sensor_dev_attr_temp1_min.dev_attr.attr,
> +	&sensor_dev_attr_temp1_max.dev_attr.attr,
> +	NULL
> +};
> +ATTRIBUTE_GROUPS(tmp103);
> +
> +static bool tmp103_regmap_is_volatile(struct device *dev, unsigned int reg)
> +{
> +	return reg == TMP103_TEMP_REG;
> +}
> +
> +static struct regmap_config tmp103_regmap_config = {
> +	.reg_bits = 8,
> +	.val_bits = 8,
> +	.max_register = TMP103_THIGH_REG,
> +	.volatile_reg = tmp103_regmap_is_volatile,
> +};
> +
> +static int tmp103_probe(struct i2c_client *client,
> +			const struct i2c_device_id *id)
> +{
> +	struct device *dev = &client->dev;
> +	struct device *hwmon_dev;
> +	struct regmap *regmap;
> +	int ret;
> +
> +	if (!i2c_check_functionality(client->adapter,
> +				     I2C_FUNC_SMBUS_BYTE_DATA)) {
> +		dev_err(&client->dev,
> +			"adapter doesn't support SMBus byte transactions\n");
> +		return -ENODEV;
> +	}
> +
> +	regmap = devm_regmap_init_i2c(client, &tmp103_regmap_config);
> +	if (IS_ERR(regmap)) {
> +		dev_err(dev, "failed to allocate register map\n");
> +		return PTR_ERR(regmap);
> +	}
> +
> +	ret = regmap_update_bits(regmap, TMP103_CONF_REG, TMP103_CONFIG_MASK,
> +				 TMP103_CONFIG);
> +	if (ret < 0) {
> +		dev_err(&client->dev, "error writing config register\n");
> +		return ret;
> +	}
> +
> +	hwmon_dev = hwmon_device_register_with_groups(dev, client->name,
> +						      regmap, tmp103_groups);
> +	return PTR_ERR_OR_ZERO(hwmon_dev);
> +}
> +
> +#ifdef CONFIG_PM
> +static int tmp103_suspend(struct device *dev)
> +{
> +	struct regmap *regmap = dev_get_drvdata(dev);
> +
> +	return regmap_update_bits(regmap, TMP103_CONF_REG,
> +				  TMP103_CONF_SD_MASK, 0);
> +}
> +
> +static int tmp103_resume(struct device *dev)
> +{
> +	struct regmap *regmap = dev_get_drvdata(dev);
> +
> +	return regmap_update_bits(regmap, TMP103_CONF_REG,
> +				  TMP103_CONF_SD_MASK, TMP103_CONF_SD);
> +}
> +
> +static const struct dev_pm_ops tmp103_dev_pm_ops = {
> +	.suspend	= tmp103_suspend,
> +	.resume		= tmp103_resume,
> +};
> +
> +#define TMP103_DEV_PM_OPS (&tmp103_dev_pm_ops)
> +#else
> +#define	TMP103_DEV_PM_OPS NULL
> +#endif /* CONFIG_PM */
> +
> +static const struct i2c_device_id tmp103_id[] = {
> +	{ DRIVER_NAME, 0 },

This seems to be used for compatible string matching. As such, I think
it would make more sense to have the string in full here so as to
discourage it from being changed arbitrarily in future.

Otherwise, the dt part looks fine by me.

Cheers,
Mark.
