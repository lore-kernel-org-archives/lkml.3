Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875Ab3DLPJZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 11:09:25 -0400
Received: from mail.active-venture.com ([67.228.131.205]:60035 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367Ab3DLPJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 11:09:24 -0400
X-Originating-IP: 108.223.40.66
Date: Fri, 12 Apr 2013 08:09:33 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Anthony Olech <anthony.olech.opensource@diasemi.com>
Cc: Jean Delvare <khali@linux-fr.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Randy Dunlap <rdunlap@xenotime.net>, lm-sensors@lm-sensors.org,
        LKML <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
Subject: Re: [NEW DRIVER V4 6/7] DA9058 HWMON driver
Message-ID: <20130412150933.GB28704@roeck-us.net>
References: <201304121312.r3CDCJte011826@latitude>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201304121312.r3CDCJte011826@latitude>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 12, 2013 at 02:05:28PM +0100, Anthony Olech wrote:
> This is the HWMON component driver of the Dialog DA9058 PMIC.
> This driver is just one component of the whole DA9058 PMIC driver.
> It depends on the CORE and ADC component drivers of the DA9058 MFD.
> 
> Signed-off-by: Anthony Olech <anthony.olech.opensource@diasemi.com>
> Signed-off-by: David Dajun Chen <david.chen@diasemi.com>
> ---

No changelog ? That makes it unnecessarily difficult to review the driver,
especially since a cursory glance suggests that you introduced new problems
since V3. What is the point of calling devm_kfree() ? Why bother with
devm_kzalloc() if you ignore its benefits anyway ?

Anyway, I don't have time right now to re-review the entire thing as I'll have
to pull my comments from the previous version, compare and figure out what you
changed and what you didn't change. So this will have to wait a bit.

Guenter

>  Documentation/hwmon/da9058   |   38 +++++
>  drivers/hwmon/Kconfig        |   10 ++
>  drivers/hwmon/Makefile       |    3 +-
>  drivers/hwmon/da9058-hwmon.c |  341 ++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 391 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/hwmon/da9058
>  create mode 100644 drivers/hwmon/da9058-hwmon.c
> 
> diff --git a/Documentation/hwmon/da9058 b/Documentation/hwmon/da9058
> new file mode 100644
> index 0000000..841148f
> --- /dev/null
> +++ b/Documentation/hwmon/da9058
> @@ -0,0 +1,38 @@
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
> diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
> index 89ac1cb..9a3f226 100644
> --- a/drivers/hwmon/Kconfig
> +++ b/drivers/hwmon/Kconfig
> @@ -304,6 +304,16 @@ config SENSORS_ATXP1
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
> index 8d6d97e..c3b103b 100644
> --- a/drivers/hwmon/Makefile
> +++ b/drivers/hwmon/Makefile
> @@ -44,7 +44,8 @@ obj-$(CONFIG_SENSORS_ASC7621)	+= asc7621.o
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
> index 0000000..3859b16
> --- /dev/null
> +++ b/drivers/hwmon/da9058-hwmon.c
> @@ -0,0 +1,341 @@
> +/*
> + *  Copyright (C) 2012 Dialog Semiconductor Ltd.
> + *
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
> +#include <linux/mfd/core.h>
> +
> +#include <linux/mfd/da9058/version.h>
> +#include <linux/mfd/da9058/registers.h>
> +#include <linux/mfd/da9058/core.h>
> +#include <linux/mfd/da9058/hwmon.h>
> +
> +static ssize_t da9058_vbat_show_adc(struct device *dev,
> +				struct device_attribute *devattr, char *buf)
> +{
> +	struct da9058_hwmon *hwmon = dev_get_drvdata(dev);
> +	int voltage; /* x000 .. xFFF = 2500 .. 4500 mV */
> +	int ret;
> +
> +	ret = da9058_adc_read(hwmon->da9058, DA9058_ADCMAN_MUXSEL_VBAT,
> +					hwmon->use_automatic_adc, &voltage);
> +	if (ret)
> +		return ret;
> +
> +	return sprintf(buf, "%d\n", 2500 + voltage * 2000 / 0xFFF);
> +}
> +
> +static ssize_t da9058_tbat_show_type(struct device *dev,
> +				struct device_attribute *devattr, char *buf)
> +{
> +	struct da9058_hwmon *hwmon = dev_get_drvdata(dev);
> +
> +	return sprintf(buf, "%d\n", hwmon->battery_sensor_type);
> +}
> +
> +static ssize_t da9058_tbat_show_adc(struct device *dev,
> +				struct device_attribute *devattr, char *buf)
> +{
> +	struct da9058_hwmon *hwmon = dev_get_drvdata(dev);
> +	int voltage; /* x000 .. xFFF = 0 .. 2500 mV */
> +	int ret;
> +
> +	ret = da9058_adc_read(hwmon->da9058, DA9058_ADCMAN_MUXSEL_TEMP,
> +					hwmon->use_automatic_adc, &voltage);
> +	if (ret)
> +		return ret;
> +
> +	return sprintf(buf, "%d\n", voltage * 2500 / 0xFFF);
> +}
> +
> +static ssize_t da9058_gp_show_adc(struct device *dev,
> +				struct device_attribute *devattr, char *buf)
> +{
> +	struct da9058_hwmon *hwmon = dev_get_drvdata(dev);
> +	int voltage; /* xFFF .. x800 = 0 .. 2500 mV */
> +	int ret;
> +
> +	ret = da9058_adc_read(hwmon->da9058, DA9058_ADCMAN_MUXSEL_ADCIN,
> +				hwmon->use_automatic_adc, &voltage);
> +	if (ret)
> +		return ret;
> +
> +	return sprintf(buf, "%d\n", (0xFFF - voltage) * 2500 / 0x7FF);
> +}
> +
> +static ssize_t da9058_tjunc_show_min(struct device *dev,
> +				struct device_attribute *devattr, char *buf)
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
> +				struct device_attribute *devattr, char *buf)
> +{
> +	struct da9058_hwmon *hwmon = dev_get_drvdata(dev);
> +	unsigned int toffreg;
> +	int ret = da9058_reg_read(hwmon->da9058, DA9058_TOFFSET_REG, &toffreg);
> +
> +	if (ret)
> +		return ret;
> +
> +	return sprintf(buf, "%d\n", 1708*(255 - (s8)((u8)toffreg)) - 108800);
> +}
> +
> +/*
> + *  The algorithm for converting the value is
> + *  Degrees celsius = 1.708 * (TJUNC_RES - T_OFFSET) - 108.8
> + *  T_OFFSET is a trim value used to improve accuracy of the result
> + */
> +static ssize_t da9058_tjunc_show_adc(struct device *dev,
> +				struct device_attribute *devattr, char *buf)
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
> +					hwmon->use_automatic_adc, &tjunc);
> +	if (ret < 0)
> +		return ret;
> +
> +	tjunc >>= 4;	/* recover most sig 8 bits as a pos/zero number */
> +
> +	return sprintf(buf, "%d\n", 1708*(tjunc - (s8)((u8)toffreg)) - 108800);
> +}
> +static ssize_t da9058_tjunc_show_offset(struct device *dev,
> +				struct device_attribute *devattr, char *buf)
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
> +}
> +
> +static ssize_t da9058_vfpin_show_adc(struct device *dev,
> +				struct device_attribute *devattr, char *buf)
> +{
> +	struct da9058_hwmon *hwmon = dev_get_drvdata(dev);
> +	int voltage; /* x000 .. xFFF = 0 .. 4095 mV */
> +	int ret;
> +
> +	ret = da9058_adc_read(hwmon->da9058, DA9058_ADCMAN_MUXSEL_VF,
> +					hwmon->use_automatic_adc, &voltage);
> +	if (ret)
> +		return ret;
> +
> +	return sprintf(buf, "%d\n", voltage);
> +}
> +
> +static ssize_t da9058_hwmon_show_name(struct device *dev,
> +				struct device_attribute *devattr, char *buf)
> +{
> +	return sprintf(buf, "da9058\n");
> +}
> +
> +static ssize_t da9058_show_label(struct device *dev,
> +				struct device_attribute *devattr, char *buf)
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
> +			!hwmon_pdata->temp_adc_resistance) {
> +		ret = -EINVAL; /* impossible setting */
> +		goto exit;
> +	}
> +
> +	hwmon = devm_kzalloc(&pdev->dev, sizeof(struct da9058_hwmon),
> +				GFP_KERNEL);
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
> +	}
> +
> +	mutex_init(&hwmon->hwmon_lock);
> +
> +	hwmon->class_device = hwmon_device_register(&pdev->dev);
> +	if (IS_ERR(hwmon->class_device)) {
> +		ret = PTR_ERR(hwmon->class_device);
> +		goto failed_to_register_device;
> +	}
> +
> +	ret = sysfs_create_group(&pdev->dev.kobj, &da9058_attr_group);
> +	if (ret)
> +		goto failed_to_create_sysfs_group;
> +
> +	goto exit;
> +
> +failed_to_create_sysfs_group:
> +	hwmon_device_unregister(hwmon->class_device);
> +failed_to_register_device:
> +	sysfs_remove_group(&pdev->dev.kobj, &da9058_attr_group);
> +failed_to_initialize_device:
> +	devm_kfree(&pdev->dev, hwmon);
> +exit:
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
> +	hwmon_device_unregister(hwmon->class_device);
> +
> +	devm_kfree(&pdev->dev, hwmon);
> +
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
> +MODULE_AUTHOR("Anthony Olech <Anthony.Olech@diasemi.com>");
> +MODULE_LICENSE("GPL v2");
> +MODULE_ALIAS("platform:da9058-hwmon");
> -- 
> end-of-patch for NEW DRIVER V4
> 
> 
