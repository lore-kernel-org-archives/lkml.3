Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830Ab3DREOJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 00:14:09 -0400
Received: from mail.active-venture.com ([67.228.131.205]:54561 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719Ab3DREOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 00:14:07 -0400
X-Originating-IP: 108.223.40.66
Date: Wed, 17 Apr 2013 21:14:24 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Anthony Olech <anthony.olech.opensource@diasemi.com>
Cc: Jean Delvare <khali@linux-fr.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Randy Dunlap <rdunlap@xenotime.net>, lm-sensors@lm-sensors.org,
        LKML <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
Subject: Re: [NEW DRIVER V5 6/7] drivers/hwmon: DA9058 HWMON driver
Message-ID: <20130418041424.GA7535@roeck-us.net>
References: <201304171640.r3HGe3hX023847@latitude>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201304171640.r3HGe3hX023847@latitude>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 17, 2013 at 05:33:36PM +0100, Anthony Olech wrote:
> This patch is relative to linux next-20130417
> 
> This is the HWMON component driver of the Dialog DA9058 PMIC.
> This driver is just one component of the whole DA9058 PMIC driver.
> It depends on the CORE and ADC component drivers of the DA9058 MFD.
> 
> Changes relative to V3 of this patch:
> - rebased to latest tagged linux-next - previously relative to mainline
> Documentation/hwmon/da9058
> - added final NL
> drivers/hwmon/Kconfig
> - changed dependancy from I2C to MFD
> drivers/hwmon/Makefile
> - put in alphabetical order
> drivers/hwmon/da9058-hwmon.c
> - aligned subsequent lines of function declarations
> - used single function for all slow labels
> - used recommended ..._label as function name
> - error conditions are returned as negative integers
> - chaned to suggested return value casting
> - removed all constant sysfile atributes except the labels
> - corrected parameter to adc read function to unsigned
> - used suggest name 'input' instead of 'value'
> - changed first temp attribute to temp1
> - fixed expression error to boolean and from bitwise and
> - removed redundant return statement
> - removed race condition by initializing before create sysfs
> - corected alignments on broken long lines
> 
> Signed-off-by: Anthony Olech <anthony.olech.opensource@diasemi.com>
> Signed-off-by: David Dajun Chen <david.chen@diasemi.com>
> ---
>  Documentation/hwmon/da9058   |   39 +++++
>  drivers/hwmon/Kconfig        |   10 ++
>  drivers/hwmon/Makefile       |    3 +-
>  drivers/hwmon/da9058-hwmon.c |  349 ++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 400 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/hwmon/da9058
>  create mode 100644 drivers/hwmon/da9058-hwmon.c
> 
> diff --git a/Documentation/hwmon/da9058 b/Documentation/hwmon/da9058
> new file mode 100644
> index 0000000..eaedfe7
> --- /dev/null
> +++ b/Documentation/hwmon/da9058
> @@ -0,0 +1,39 @@
> +Kernel driver da9058-hwmon
> +==========================
> +
> +Supported chips:
> +  * Dialog Semiconductor DA9058 PMIC
> +    Prefix: 'da9058'
> +    Datasheet:
> +	http://www.dialog-semiconductor.com/products/power-management/da9058
> +
> +Authors: Opensource [Anthony Olech] <anthony.olech.opensource@diasemi.com>
> +
> +Description
> +-----------
> +
> +The DA9058 PMIC contains a 5 channel ADC which can be used to monitor a
> +range of system operating parameters, including the battery voltage and
> +temperature.  The ADC measures voltage, but two of the ADC channels can
> +be configured to supply a current, so that if an NTC termister is connected
> +then the voltage reading can be converted to a temperature. Currently the
> +driver provides reporting of all the input values but does not provide any
> +alarms.
> +
> +Voltage Monitoring
> +------------------
> +
> +Voltages are sampled in either 'automatic' or 'manual' mode, which is an
> +initialization parameter set in the platform data by the machine driver.
> +In manual mode the ADC conversion is 12 bit and in automatic mode it is
> +10 bit. However all the raw readings are reported as 12 bit numbers.
> +
> +Physical Limits
> +---------------
> +
> +vbat   2500 - 4500 milliVolts
> +tbat   0    - 2500 milliVolts
> +adc    0    - 2500 milliVolts
> +vfpin  0    - 4095 milliVolts
> +tjunc  there is a correction factor programmed during manufacturing
> +
> diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
> index da93094..8014af2 100644
> --- a/drivers/hwmon/Kconfig
> +++ b/drivers/hwmon/Kconfig
> @@ -324,6 +324,16 @@ config SENSORS_ATXP1
>  	  This driver can also be built as a module.  If so, the module
>  	  will be called atxp1.
>  
> +config SENSORS_DA9058
> +	tristate "Dialog Semiconductor DA9058 ADC"
> +	depends on MFD_DA9058 && DA9058_ADC
> +	help
> +	  If you say yes here you get support for the hardware monitoring
> +	  functionality of the Dialog Semiconductor DA9058 PMIC.
> +
> +	  This driver can also be built as a module.  If so, the module
> +	  will be called da9058-hwmon.
> +
>  config SENSORS_DS620
>  	tristate "Dallas Semiconductor DS620"
>  	depends on I2C
> diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
> index c51b0dc..5b7705a 100644
> --- a/drivers/hwmon/Makefile
> +++ b/drivers/hwmon/Makefile
> @@ -46,7 +46,8 @@ obj-$(CONFIG_SENSORS_ASC7621)	+= asc7621.o
>  obj-$(CONFIG_SENSORS_ATXP1)	+= atxp1.o
>  obj-$(CONFIG_SENSORS_CORETEMP)	+= coretemp.o
>  obj-$(CONFIG_SENSORS_DA9052_ADC)+= da9052-hwmon.o
> -obj-$(CONFIG_SENSORS_DA9055)+= da9055-hwmon.o
> +obj-$(CONFIG_SENSORS_DA9055)	+= da9055-hwmon.o
> +obj-$(CONFIG_SENSORS_DA9058)	+= da9058-hwmon.o
>  obj-$(CONFIG_SENSORS_DME1737)	+= dme1737.o
>  obj-$(CONFIG_SENSORS_DS620)	+= ds620.o
>  obj-$(CONFIG_SENSORS_DS1621)	+= ds1621.o
> diff --git a/drivers/hwmon/da9058-hwmon.c b/drivers/hwmon/da9058-hwmon.c
> new file mode 100644
> index 0000000..b273f58
> --- /dev/null
> +++ b/drivers/hwmon/da9058-hwmon.c
> @@ -0,0 +1,349 @@
> +/*
> + *  Copyright (C) 2012 Dialog Semiconductor Ltd.
> + *

2012 - 2013 ?

> + *  This program is free software; you can redistribute it and/or modify
> + *  it under the terms of the GNU General Public License as published by
> + *  the Free Software Foundation; either version 2 of the License, or
> + *  (at your option) any later version.
> + *
> + */
> +
> +#include <linux/module.h>
> +#include <linux/err.h>
> +#include <linux/hwmon.h>
> +#include <linux/hwmon-sysfs.h>
> +#include <linux/regmap.h>

Are you using any regmap code ?

> +#include <linux/mfd/core.h>
> +
> +#include <linux/mfd/da9058/version.h>
> +#include <linux/mfd/da9058/registers.h>
> +#include <linux/mfd/da9058/core.h>
> +#include <linux/mfd/da9058/hwmon.h>

Why is the hwmon include file exported ? Is it needed outside this file ?
If not, the defined should just be added here, without extra include file.
If the defines are needed elsewhere, I would expect to be copied on the patch
adding the file.

Also, do you really need to include all those header files ? For example,
I don't immediately see how you use version.h.

> +static ssize_t da9058_vbat_show_adc(struct device *dev,
> +				    struct device_attribute *devattr,
> +				    char *buf)
> +{
> +	struct da9058_hwmon *hwmon = dev_get_drvdata(dev);
> +	unsigned int voltage; /* x000 .. xFFF = 2500 .. 4500 mV */
> +	int ret;
> +
> +	ret = da9058_adc_read(hwmon->da9058, DA9058_ADCMAN_MUXSEL_VBAT,
> +			      hwmon->use_automatic_adc, &voltage);
> +	if (ret)
> +		return ret;
> +
> +	return sprintf(buf, "%d\n", 2500 + voltage * 2000 / 0xFFF);
> +}
> +
> +static ssize_t da9058_tbat_show_type(struct device *dev,
> +				     struct device_attribute *devattr,
> +				     char *buf)
> +{
> +	struct da9058_hwmon *hwmon = dev_get_drvdata(dev);
> +
> +	return sprintf(buf, "%d\n", hwmon->battery_sensor_type);
> +}
> +
> +static ssize_t da9058_tbat_show_adc(struct device *dev,
> +				    struct device_attribute *devattr,
> +				    char *buf)
> +{
> +	struct da9058_hwmon *hwmon = dev_get_drvdata(dev);
> +	unsigned int voltage; /* x000 .. xFFF = 0 .. 2500 mV */
> +	int ret;
> +
> +	ret = da9058_adc_read(hwmon->da9058, DA9058_ADCMAN_MUXSEL_TEMP,
> +			      hwmon->use_automatic_adc, &voltage);
> +	if (ret)
> +		return ret;
> +
> +	return sprintf(buf, "%d\n", voltage * 2500 / 0xFFF);

Might be a good idea to use DIV_ROUND_CLOSEST for those divisions to improve
rounding.

> +}
> +
> +static ssize_t da9058_gp_show_adc(struct device *dev,
> +				  struct device_attribute *devattr,
> +				  char *buf)
> +{
> +	struct da9058_hwmon *hwmon = dev_get_drvdata(dev);
> +	unsigned int voltage; /* xFFF .. x800 = 0 .. 2500 mV */
> +	int ret;
> +
> +	ret = da9058_adc_read(hwmon->da9058, DA9058_ADCMAN_MUXSEL_ADCIN,
> +			      hwmon->use_automatic_adc, &voltage);
> +	if (ret)
> +		return ret;
> +
> +	return sprintf(buf, "%d\n", (0xFFF - voltage) * 2500 / 0x7FF);
> +}
> +
> +static ssize_t da9058_tjunc_show_min(struct device *dev,
> +				     struct device_attribute *devattr,
> +				     char *buf)
> +{
> +	struct da9058_hwmon *hwmon = dev_get_drvdata(dev);
> +	unsigned int toffreg;
> +	int ret = da9058_reg_read(hwmon->da9058, DA9058_TOFFSET_REG, &toffreg);
> +
> +	if (ret)
> +		return ret;
> +
> +	return sprintf(buf, "%d\n", -(1708 * (s8)((u8)toffreg) + 108800));
> +}
> +
> +static ssize_t da9058_tjunc_show_max(struct device *dev,
> +				     struct device_attribute *devattr,
> +				     char *buf)
> +{
> +	struct da9058_hwmon *hwmon = dev_get_drvdata(dev);
> +	unsigned int toffreg;
> +	int ret = da9058_reg_read(hwmon->da9058, DA9058_TOFFSET_REG, &toffreg);
> +
> +	if (ret)
> +		return ret;
> +
> +	return sprintf(buf, "%d\n", 1708*(255 - (s8)((u8)toffreg)) - 108800);

Please watch for coding style: space before and after '*'. You have several
of those in the patch. Don't ask me why checkpatch doesn't complain.

> +}
> +
> +/*
> + *  The algorithm for converting the value is
> + *  Degrees celsius = 1.708 * (TJUNC_RES - T_OFFSET) - 108.8
> + *  T_OFFSET is a trim value used to improve accuracy of the result
> + */
> +static ssize_t da9058_tjunc_show_adc(struct device *dev,
> +				     struct device_attribute *devattr,
> +				     char *buf)
> +{
> +	struct da9058_hwmon *hwmon = dev_get_drvdata(dev);
> +	int tjunc;
> +	unsigned int toffreg;
> +	int ret;
> +
> +	ret = da9058_reg_read(hwmon->da9058, DA9058_TOFFSET_REG, &toffreg);
> +	if (ret < 0)
> +		return ret;
> +
> +	ret = da9058_adc_read(hwmon->da9058, DA9058_ADCMAN_MUXSEL_TJUNC,
> +			      hwmon->use_automatic_adc, &tjunc);
> +	if (ret < 0)
> +		return ret;
> +
> +	tjunc >>= 4;	/* recover most sig 8 bits as a pos/zero number */

"Recover" is a bit odd here. Is this what you mean ?

> +
> +	return sprintf(buf, "%d\n", 1708*(tjunc - (s8)((u8)toffreg)) - 108800);

Here again

> +}
> +static ssize_t da9058_tjunc_show_offset(struct device *dev,
> +					struct device_attribute *devattr,
> +					char *buf)
> +{
> +	struct da9058_hwmon *hwmon = dev_get_drvdata(dev);
> +	unsigned int toffreg;
> +	int ret;
> +
> +	ret = da9058_reg_read(hwmon->da9058, DA9058_TOFFSET_REG, &toffreg);
> +	if (ret < 0)
> +		return ret;
> +
> +	return sprintf(buf, "%d\n", -1708*(s8)((u8)toffreg) - 108800);

And again

> +}
> +
> +static ssize_t da9058_vfpin_show_adc(struct device *dev,
> +				     struct device_attribute *devattr,
> +				     char *buf)
> +{
> +	struct da9058_hwmon *hwmon = dev_get_drvdata(dev);
> +	unsigned int voltage; /* x000 .. xFFF = 0 .. 4095 mV */
> +	int ret;
> +
> +	ret = da9058_adc_read(hwmon->da9058, DA9058_ADCMAN_MUXSEL_VF,
> +			      hwmon->use_automatic_adc, &voltage);
> +	if (ret)
> +		return ret;
> +
> +	return sprintf(buf, "%d\n", voltage);
> +}
> +
> +static ssize_t da9058_hwmon_show_name(struct device *dev,
> +				      struct device_attribute *devattr,
> +				      char *buf)
> +{
> +	return sprintf(buf, "da9058\n");
> +}
> +
> +static ssize_t da9058_show_label(struct device *dev,
> +				 struct device_attribute *devattr,
> +				 char *buf)
> +{
> +	int channel = to_sensor_dev_attr(devattr)->index;
> +
> +	switch (channel) {
> +	case 0:	return sprintf(buf, "vbat\n");
> +	case 1:	return sprintf(buf, "tbat\n");
> +	case 2:	return sprintf(buf, "vfpin\n");
> +	case 3:	return sprintf(buf, "adc\n");
> +	case 4:	return sprintf(buf, "tjunc\n");
> +	default: return -EINVAL;

One statement per line, please.

On the other side, since the value range of channel is well known,
it would be simpler to declare

static const char * const da9058_labels[] = {
	"vbat", "tbat", "vfpin", "adc", "tjunc"
};
	...
	return sprintf("%s\n", da9058_labels[channel]);

and drop the case statement entirely.

Plus, you can actually merge "da9058_hwmon_show_name" into the same function
by just defining another index for it.

> +	}
> +}
> +
> +static DEVICE_ATTR(name, S_IRUGO, da9058_hwmon_show_name, NULL);
> +
> +static SENSOR_DEVICE_ATTR(in0_label, S_IRUGO, da9058_show_label, NULL, 0);
> +static SENSOR_DEVICE_ATTR(in0_input, S_IRUGO, da9058_vbat_show_adc, NULL, 0);
> +
> +static SENSOR_DEVICE_ATTR(temp1_label, S_IRUGO, da9058_show_label, NULL, 1);
> +static SENSOR_DEVICE_ATTR(temp1_type, S_IRUGO, da9058_tbat_show_type, NULL, 1);
> +static SENSOR_DEVICE_ATTR(temp1_input, S_IRUGO, da9058_tbat_show_adc, NULL, 1);
> +
> +static SENSOR_DEVICE_ATTR(in1_label, S_IRUGO, da9058_show_label, NULL, 2);
> +static SENSOR_DEVICE_ATTR(in1_input, S_IRUGO, da9058_vfpin_show_adc, NULL, 2);
> +
> +static SENSOR_DEVICE_ATTR(in2_label, S_IRUGO, da9058_show_label, NULL, 3);
> +static SENSOR_DEVICE_ATTR(in2_input, S_IRUGO, da9058_gp_show_adc, NULL, 3);
> +
> +static SENSOR_DEVICE_ATTR(temp2_label, S_IRUGO, da9058_show_label, NULL, 4);
> +static SENSOR_DEVICE_ATTR(temp2_min, S_IRUGO, da9058_tjunc_show_min, NULL, 4);
> +static SENSOR_DEVICE_ATTR(temp2_max, S_IRUGO, da9058_tjunc_show_max, NULL, 4);
> +static SENSOR_DEVICE_ATTR(temp2_input, S_IRUGO, da9058_tjunc_show_adc, NULL, 4);
> +static SENSOR_DEVICE_ATTR(temp2_offset, S_IRUGO, da9058_tjunc_show_offset, NULL,
> +				4);

Alignment ?

> +
> +static struct attribute *da9058_attr[] = {
> +	&dev_attr_name.attr,
> +	&sensor_dev_attr_in0_label.dev_attr.attr,
> +	&sensor_dev_attr_in0_input.dev_attr.attr,
> +	&sensor_dev_attr_temp1_label.dev_attr.attr,
> +	&sensor_dev_attr_temp1_type.dev_attr.attr,
> +	&sensor_dev_attr_temp1_input.dev_attr.attr,
> +	&sensor_dev_attr_in1_label.dev_attr.attr,
> +	&sensor_dev_attr_in1_input.dev_attr.attr,
> +	&sensor_dev_attr_in2_label.dev_attr.attr,
> +	&sensor_dev_attr_in2_input.dev_attr.attr,
> +	&sensor_dev_attr_temp2_label.dev_attr.attr,
> +	&sensor_dev_attr_temp2_min.dev_attr.attr,
> +	&sensor_dev_attr_temp2_max.dev_attr.attr,
> +	&sensor_dev_attr_temp2_input.dev_attr.attr,
> +	&sensor_dev_attr_temp2_offset.dev_attr.attr,
> +	NULL
> +};
> +
> +static const struct attribute_group da9058_attr_group = {.attrs = da9058_attr};

Might be better to split this instead of packing it together to avoid the
80-column limit.

> +
> +static int da9058_hwmon_probe(struct platform_device *pdev)
> +{
> +	struct da9058 *da9058 = dev_get_drvdata(pdev->dev.parent);
> +	const struct mfd_cell *cell = mfd_get_cell(pdev);
> +	struct da9058_hwmon_pdata *hwmon_pdata;
> +	struct da9058_hwmon *hwmon;
> +	int ret;
> +
> +	if (cell == NULL) {
> +		ret = -ENODEV;
> +		goto exit;

Just return -ENODEV is good enough here. See CodingStyle, chapter 7.
Same below where you can return directly.

> +	}
> +
> +	hwmon_pdata = cell->platform_data;
> +
> +	if (hwmon_pdata == NULL) {
> +		ret = -EINVAL;
> +		goto exit;
> +	}
> +
> +	if (hwmon_pdata->use_automatic_adc &&
> +	    !hwmon_pdata->temp_adc_resistance) {
> +		ret = -EINVAL; /* impossible setting */
> +		goto exit;
> +	}
> +
> +	hwmon = devm_kzalloc(&pdev->dev, sizeof(struct da9058_hwmon),
> +				GFP_KERNEL);

Is the alignment correct here ?

> +	if (!hwmon) {
> +		ret = -ENOMEM;
> +		goto exit;
> +	}
> +
> +	platform_set_drvdata(pdev, hwmon);
> +
> +	hwmon->da9058 = da9058;
> +	hwmon->pdev = pdev;
> +	hwmon->use_automatic_adc = hwmon_pdata->use_automatic_adc;
> +	hwmon->temp_adc_resistance = hwmon_pdata->temp_adc_resistance;
> +	hwmon->vf_adc_resistance = hwmon_pdata->vf_adc_resistance;
> +	hwmon->battery_sensor_type = hwmon_pdata->battery_sensor_type;
> +
> +	if (hwmon->use_automatic_adc) {
> +		unsigned int mode = DA9058_ADCCONT_AUTOADCEN |
> +				DA9058_ADCCONT_TEMPISRCEN |
> +				DA9058_ADCCONT_AUTOVBATEN |
> +				DA9058_ADCCONT_AUTOVFEN |
> +				DA9058_ADCCONT_AUTOAINEN;
> +
> +		if (hwmon->vf_adc_resistance)
> +			mode |= DA9058_ADCCONT_VFISRCEN;
> +
> +		ret = da9058_reg_write(da9058, DA9058_ADCCONT_REG, mode);
> +		if (ret)
> +			goto failed_to_initialize_device;
> +	} else {
> +		unsigned int mode = 0;
> +
> +		if (hwmon->temp_adc_resistance)
> +			mode |= DA9058_ADCCONT_TEMPISRCEN;
> +		if (hwmon->vf_adc_resistance)
> +			mode |= DA9058_ADCCONT_VFISRCEN;
> +
> +		ret = da9058_reg_write(da9058, DA9058_ADCCONT_REG, mode);
> +		if (ret)
> +			goto failed_to_initialize_device;

The last 6 lines are duplicate and can be outside the if/else statement. Just
declare mode at the beginning of the function.

> +	}
> +
> +	mutex_init(&hwmon->hwmon_lock);

Any idea what you plan to use this lock for ?

> +
> +	hwmon->class_device = hwmon_device_register(&pdev->dev);
> +	if (IS_ERR(hwmon->class_device)) {
> +		ret = PTR_ERR(hwmon->class_device);
> +		goto failed_to_register_device;
> +	}

hwmon_device_register comes last to prevent race conditions where the hwmon
device exists and is reported to user space, but the attributes are missing.
> +
> +	ret = sysfs_create_group(&pdev->dev.kobj, &da9058_attr_group);
> +	if (ret)
> +		goto failed_to_create_sysfs_group;
> +
> +	goto exit;

Please just return 0; here.

> +
> +failed_to_create_sysfs_group:
> +	hwmon_device_unregister(hwmon->class_device);
> +failed_to_register_device:
> +	sysfs_remove_group(&pdev->dev.kobj, &da9058_attr_group);
> +failed_to_initialize_device:
> +exit:

Two labels are really unnecessary here.

> +	return ret;
> +}
> +
> +static int da9058_hwmon_remove(struct platform_device *pdev)
> +{
> +	struct da9058_hwmon *hwmon = platform_get_drvdata(pdev);
> +
> +	sysfs_remove_group(&pdev->dev.kobj, &da9058_attr_group);
> +
> +
One empty line is enough.

> +	hwmon_device_unregister(hwmon->class_device);
> +
hwmon_device_unregister comes first to prevent race conditions on unload.

> +	return 0;
> +}
> +
> +static struct platform_driver da9058_hwmon_driver = {
> +	.probe = da9058_hwmon_probe,
> +	.remove = da9058_hwmon_remove,
> +	.driver = {
> +		.name = "da9058-hwmon",
> +		.owner = THIS_MODULE,
> +	},
> +};
> +
> +module_platform_driver(da9058_hwmon_driver);
> +
> +MODULE_DESCRIPTION("Dialog DA9058 PMIC HardWare Monitor Driver");

HardWare isn't really common english, not even as capital letters.

> +MODULE_AUTHOR("Anthony Olech <Anthony.Olech@diasemi.com>");
> +MODULE_LICENSE("GPL v2");
> +MODULE_ALIAS("platform:da9058-hwmon");
> -- 
> end-of-patch for NEW DRIVER V5
> 
> 
