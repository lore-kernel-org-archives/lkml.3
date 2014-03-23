Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751646AbaCWVEe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2014 17:04:34 -0400
Received: from mail1.bemta5.messagelabs.com ([195.245.231.139]:5944 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751283AbaCWVDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2014 17:03:41 -0400
X-Env-Sender: stwiss.opensource@diasemi.com
X-Msg-Ref: server-9.tower-179.messagelabs.com!1395608616!26673463!3
X-Originating-IP: [82.210.246.133]
X-StarScan-Received: 
X-StarScan-Version: 6.11.1; banners=-,-,-
X-VirusChecked: Checked
Message-ID: <420d4f5c8436a66b511693531cfeda131258ce69.1395607051.git.stwiss.opensource@diasemi.com>
In-Reply-To: <cover.1395607051.git.stwiss.opensource@diasemi.com>
References: <cover.1395607051.git.stwiss.opensource@diasemi.com>
From: "Opensource [Steve Twiss]" <stwiss.opensource@diasemi.com>
Date: Sun, 23 Mar 2014 20:37:30 +0000
Subject: [RFC V1 1/3] hwmon: da9063: HWMON driver
To: Guenter Roeck <linux@roeck-us.net>, Jean Delvare <jdelvare@suse.de>
CC: David Dajun Chen <david.chen@diasemi.com>,
        LINUX-DOC <linux-doc@vger.kernel.org>,
        LINUX-KERNEL <linux-kernel@vger.kernel.org>,
        LM-SENSORS <lm-sensors@lm-sensors.org>,
        Lee Jones <lee.jones@linaro.org>, Mark Brown <broonie@linaro.org>,
        Philipp Zabel <p.zabel@pengutronix.de>, Rob Landley <rob@landley.net>,
        Samuel Ortiz <sameo@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Opensource [Steve Twiss] <stwiss.opensource@diasemi.com>

Add the HWMON driver for DA9063

Signed-off-by: Opensource [Steve Twiss] <stwiss.opensource@diasemi.com>
---
Checks performed with linux-next/next-20140321/scripts/checkpatch.pl
 da9063-hwmon.c            total: 0 errors, 0 warnings, 456 lines checked
 Kconfig                   total: 1 errors, 3 warnings, 1643 lines checked
 Makefile                  total: 0 errors, 0 warnings, 154 lines checked
 registers.h               total: 0 errors, 0 warnings, 1066 lines checked
There are errors and warning in Kconfig, however they are not caused
by this patch.

This is the hardware monitor driver component for DA9063 PMIC.

The manual measurement allows monitoring of the system voltage
VSYS, the auxiliary channels ADCIN1, ADCIN2 and ADCIN3, VBBAT
measures of the backup battery voltage and a Tjunc value for the
internal junction temperature sensor.

This patch also includes the necessary register changes, especially
the definitions for ADC_CFG (addr=0xC9) to allow settings for the
current sources.

Dependencies:

The patch in this set titled:  "mfd: da9063: Add HWMON dependencies"
- The da9063-core.c changes allows for reading the temperature trimming
  offset value from the PMIC. This used by HWMON in its calculation of
  the internal junction temperature.
- Changes to platform data definitions so that ADCIN[123]_CUR values
  may be set from outside the driver.

This patch applies against linux-next and next-20140321

Regards,
Steve Twiss, Dialog Semiconductor Ltd.



 drivers/hwmon/Kconfig                |   10 +
 drivers/hwmon/Makefile               |    1 +
 drivers/hwmon/da9063-hwmon.c         |  456 ++++++++++++++++++++++++++++++++++
 include/linux/mfd/da9063/registers.h |   34 +++
 4 files changed, 501 insertions(+)
 create mode 100644 drivers/hwmon/da9063-hwmon.c

diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index f288b60..68aa886 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -391,6 +391,16 @@ config SENSORS_DA9055
 	  This driver can also be built as a module.  If so, the module
 	  will be called da9055-hwmon.
 
+config SENSORS_DA9063
+	tristate "Dialog Semiconductor DA9063"
+	depends on MFD_DA9063
+	help
+	  If you say yes here you get support for the hardware
+	  monitoring features of the DA9063 Power Management IC.
+
+	  This driver can also be built as a module. If so, the module
+	  will be called da9063-hwmon.
+
 config SENSORS_I5K_AMB
 	tristate "FB-DIMM AMB temperature sensor on Intel 5000 series chipsets"
 	depends on PCI
diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
index c48f987..4174b07 100644
--- a/drivers/hwmon/Makefile
+++ b/drivers/hwmon/Makefile
@@ -49,6 +49,7 @@ obj-$(CONFIG_SENSORS_ATXP1)	+= atxp1.o
 obj-$(CONFIG_SENSORS_CORETEMP)	+= coretemp.o
 obj-$(CONFIG_SENSORS_DA9052_ADC)+= da9052-hwmon.o
 obj-$(CONFIG_SENSORS_DA9055)+= da9055-hwmon.o
+obj-$(CONFIG_SENSORS_DA9063)	+= da9063-hwmon.o
 obj-$(CONFIG_SENSORS_DME1737)	+= dme1737.o
 obj-$(CONFIG_SENSORS_DS620)	+= ds620.o
 obj-$(CONFIG_SENSORS_DS1621)	+= ds1621.o
diff --git a/drivers/hwmon/da9063-hwmon.c b/drivers/hwmon/da9063-hwmon.c
new file mode 100644
index 0000000..7756cb2
--- /dev/null
+++ b/drivers/hwmon/da9063-hwmon.c
@@ -0,0 +1,456 @@
+/* da9063-hwmon.c - Hardware monitor support for DA9063
+ * Copyright (C) 2014 Dialog Semiconductor Ltd.
+ *
+ * This library is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU Library General Public
+ * License as published by the Free Software Foundation; either
+ * version 2 of the License, or (at your option) any later version.
+ *
+ * This library is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * Library General Public License for more details.
+ */
+
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/err.h>
+#include <linux/delay.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/string.h>
+#include <linux/platform_device.h>
+#include <linux/hwmon.h>
+#include <linux/hwmon-sysfs.h>
+#include <linux/regmap.h>
+#include <linux/mfd/da9063/core.h>
+#include <linux/mfd/da9063/pdata.h>
+
+#define DA9063_ADC_RES	(1 << (DA9063_ADC_RES_L_BITS + DA9063_ADC_RES_M_BITS))
+#define DA9063_ADC_MAX	(DA9063_ADC_RES - 1)
+#define DA9063_2V5	2500
+#define DA9063_5V0	5000
+#define DA9063_5V5	5500
+#define DA9063_TJUNC_M	-420
+#define DA9063_TJUNC_C	-812
+#define DA9063_VBBAT_M	2048
+
+enum da9063_adc {
+	DA9063_CHAN_VSYS = DA9063_ADC_MUX_VSYS,
+	DA9063_CHAN_ADCIN1 = DA9063_ADC_MUX_ADCIN1,
+	DA9063_CHAN_ADCIN2 = DA9063_ADC_MUX_ADCIN2,
+	DA9063_CHAN_ADCIN3 = DA9063_ADC_MUX_ADCIN3,
+	DA9063_CHAN_TJUNC = DA9063_ADC_MUX_T_SENSE,
+	DA9063_CHAN_VBBAT = DA9063_ADC_MUX_VBBAT,
+	DA9063_CHAN_LDO_G1 = DA9063_ADC_MUX_LDO_G1,
+	DA9063_CHAN_LDO_G2 = DA9063_ADC_MUX_LDO_G2,
+	DA9063_CHAN_LDO_G3 = DA9063_ADC_MUX_LDO_G3
+};
+
+struct da9063_hwmon {
+	struct da9063 *da9063;
+	struct device *classdev;
+	struct mutex hwmon_mutex;
+	struct completion adc_ready;
+	signed char tjunc_offset;
+	int irq;
+};
+
+static int da9063_adc_convert(struct da9063_hwmon *hwmon, int channel,
+			      int *value)
+{
+	int val = *value;
+	int ret = 0;
+
+	switch (channel) {
+	case DA9063_CHAN_ADCIN1:
+	case DA9063_CHAN_ADCIN2:
+	case DA9063_CHAN_ADCIN3:
+		val = (DA9063_2V5 * val) / DA9063_ADC_MAX;
+		break;
+	case DA9063_CHAN_VSYS:
+		val = ((DA9063_5V5 - DA9063_2V5) * val) / DA9063_ADC_MAX +
+			DA9063_2V5;
+		break;
+	case DA9063_CHAN_TJUNC:
+		val -= hwmon->tjunc_offset;
+		val = (DA9063_TJUNC_M * (val + DA9063_TJUNC_C)) >> 10;
+		break;
+	case DA9063_CHAN_VBBAT:
+		val = (DA9063_5V0 * val) / DA9063_ADC_MAX;
+		break;
+	default:
+		ret = -EINVAL;
+		goto err_convert;
+	}
+
+	*value = val;
+err_convert:
+	return ret;
+}
+
+static int da9063_adc_current_switch(struct da9063_hwmon *hwmon, int channel,
+				     bool on)
+{
+	int ret;
+	unsigned int val;
+	unsigned int mask;
+
+	switch (channel) {
+	case DA9063_CHAN_ADCIN1:
+		mask = DA9063_ADC_AD1_ISRC_EN;
+		break;
+	case DA9063_CHAN_ADCIN2:
+		mask = DA9063_ADC_AD2_ISRC_EN;
+		break;
+	case DA9063_CHAN_ADCIN3:
+		mask = DA9063_ADC_AD3_ISRC_EN;
+		break;
+	default:
+		ret = -EINVAL;
+		goto err_switch;
+	}
+
+	if (on)
+		val = mask;
+	else
+		val = ~mask;
+
+	ret = regmap_update_bits(hwmon->da9063->regmap, DA9063_REG_ADC_CONT,
+				 mask, val);
+err_switch:
+	return ret;
+
+}
+
+static int da9063_adc_manual_read(struct da9063_hwmon *hwmon, int channel)
+{
+	int ret;
+	unsigned char val;
+	unsigned char data[2];
+	int adc_man;
+
+	mutex_lock(&hwmon->hwmon_mutex);
+
+	init_completion(&hwmon->adc_ready);
+
+	val = (channel & DA9063_ADC_MUX_MASK) | DA9063_ADC_MAN;
+	ret = regmap_update_bits(hwmon->da9063->regmap, DA9063_REG_ADC_MAN,
+				 DA9063_ADC_MUX_MASK | DA9063_ADC_MAN, val);
+	if (ret < 0)
+		goto err_mread;
+
+	ret = wait_for_completion_timeout(&hwmon->adc_ready,
+					  msecs_to_jiffies(1000));
+	if (ret == 0) {
+		ret = -ETIMEDOUT;
+		goto err_mread;
+	}
+
+	ret = regmap_read(hwmon->da9063->regmap, DA9063_REG_ADC_MAN, &adc_man);
+	if (ret < 0)
+		goto err_mread;
+
+	/* data value is not ready */
+	if (adc_man & DA9063_ADC_MAN == 0) {
+		ret = -EINVAL;
+		goto err_mread;
+	}
+
+	ret = regmap_bulk_read(hwmon->da9063->regmap,
+			       DA9063_REG_ADC_RES_L, data, 2);
+	if (ret < 0)
+		goto err_mread;
+
+	ret = (data[0] & DA9063_ADC_RES_L_MASK) >> DA9063_ADC_RES_L_SHIFT;
+	ret |= data[1] << DA9063_ADC_RES_L_BITS;
+err_mread:
+	mutex_unlock(&hwmon->hwmon_mutex);
+	return ret;
+}
+
+static irqreturn_t da9063_hwmon_irq_handler(int irq, void *irq_data)
+{
+	struct da9063_hwmon *hwmon = irq_data;
+	complete(&hwmon->adc_ready);
+	return IRQ_HANDLED;
+}
+
+static ssize_t da9063_adc_read(struct device *dev,
+			       struct device_attribute *devattr, char *buf)
+{
+	struct da9063_hwmon *hwmon = dev_get_drvdata(dev);
+	int channel = to_sensor_dev_attr(devattr)->index;
+	int val;
+	int ret;
+
+	switch (channel) {
+	case DA9063_CHAN_ADCIN1:
+	case DA9063_CHAN_ADCIN2:
+	case DA9063_CHAN_ADCIN3:
+		/* fallthrough for ADC measures */
+		ret = da9063_adc_current_switch(hwmon, channel, true);
+		if (ret < 0)
+			goto err_read;
+
+		val = da9063_adc_manual_read(hwmon, channel);
+		if (val < 0) {
+			ret = val;
+			if (ret == -EINVAL)
+				dev_err(dev, "Conversion was not completed\n");
+			else
+				dev_err(dev, "ADC read error %d\n", ret);
+			goto err_read;
+		}
+
+		ret = da9063_adc_current_switch(hwmon, channel, false);
+		if (ret < 0) {
+			dev_err(dev, "Could not switch current\n");
+			goto err_read;
+		}
+		break;
+
+	case DA9063_CHAN_VSYS:
+	case DA9063_CHAN_TJUNC:
+	case DA9063_CHAN_VBBAT:
+		/* fallthrough for internal measures */
+		val = da9063_adc_manual_read(hwmon, channel);
+		if (val < 0) {
+			dev_err(dev, "ADC read error %d\n", val);
+			return val;
+		}
+		break;
+
+	default:
+		/* error case */
+		ret = -EINVAL;
+		goto err_read;
+	}
+
+	ret = da9063_adc_convert(hwmon, channel, &val);
+	if (ret < 0) {
+		dev_err(dev, "Failed to convert ADC value %d\n", ret);
+		goto err_read;
+	}
+
+	return sprintf(buf, "%d\n", val);
+err_read:
+	return ret;
+}
+
+static ssize_t da9063_show_name(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	return sprintf(buf, DA9063_DRVNAME_HWMON "\n");
+}
+
+static ssize_t da9063_show_label(struct device *dev,
+				 struct device_attribute *devattr, char *buf)
+{
+	int channel = to_sensor_dev_attr(devattr)->index;
+	char *label;
+
+	switch (channel) {
+	case DA9063_CHAN_VSYS:
+		label = "VSYS";
+		break;
+	case DA9063_CHAN_ADCIN1:
+		label = "ADCIN1";
+		break;
+	case DA9063_CHAN_ADCIN2:
+		label = "ADCIN2";
+		break;
+	case DA9063_CHAN_ADCIN3:
+		label = "ADCIN3";
+		break;
+	case DA9063_CHAN_TJUNC:
+		label = "TJUNC";
+		break;
+	case DA9063_CHAN_VBBAT:
+		label = "VBBAT";
+		break;
+	default:
+		label = "UNKNOWN";
+	}
+
+	return sprintf(buf, "%s\n", label);
+}
+
+static SENSOR_DEVICE_ATTR(in0_input, S_IRUGO,
+			  da9063_adc_read, NULL, DA9063_CHAN_VSYS);
+static SENSOR_DEVICE_ATTR(in0_label, S_IRUGO,
+			  da9063_show_label, NULL, DA9063_CHAN_VSYS);
+
+static SENSOR_DEVICE_ATTR(in1_input, S_IRUGO,
+			  da9063_adc_read, NULL, DA9063_CHAN_ADCIN1);
+static SENSOR_DEVICE_ATTR(in1_label, S_IRUGO,
+			  da9063_show_label, NULL, DA9063_CHAN_ADCIN1);
+
+static SENSOR_DEVICE_ATTR(in2_input, S_IRUGO,
+			  da9063_adc_read, NULL, DA9063_CHAN_ADCIN2);
+static SENSOR_DEVICE_ATTR(in2_label, S_IRUGO,
+			  da9063_show_label, NULL, DA9063_CHAN_ADCIN2);
+
+static SENSOR_DEVICE_ATTR(in3_input, S_IRUGO,
+			  da9063_adc_read, NULL, DA9063_CHAN_ADCIN3);
+static SENSOR_DEVICE_ATTR(in3_label, S_IRUGO,
+			  da9063_show_label, NULL, DA9063_CHAN_ADCIN3);
+
+static SENSOR_DEVICE_ATTR(in4_input, S_IRUGO,
+			  da9063_adc_read, NULL, DA9063_CHAN_VBBAT);
+static SENSOR_DEVICE_ATTR(in4_label, S_IRUGO,
+			  da9063_show_label, NULL, DA9063_CHAN_VBBAT);
+
+static SENSOR_DEVICE_ATTR(temp1_input, S_IRUGO,
+			  da9063_adc_read, NULL, DA9063_CHAN_TJUNC);
+
+static SENSOR_DEVICE_ATTR(temp1_label, S_IRUGO,
+			  da9063_show_label, NULL, DA9063_CHAN_TJUNC);
+
+static DEVICE_ATTR(name, S_IRUGO, da9063_show_name, NULL);
+
+static struct attribute *da9063_attributes[] = {
+	&dev_attr_name.attr,
+	&sensor_dev_attr_in0_input.dev_attr.attr,
+	&sensor_dev_attr_in0_label.dev_attr.attr,
+	&sensor_dev_attr_in1_input.dev_attr.attr,
+	&sensor_dev_attr_in1_label.dev_attr.attr,
+	&sensor_dev_attr_in2_input.dev_attr.attr,
+	&sensor_dev_attr_in2_label.dev_attr.attr,
+	&sensor_dev_attr_in3_input.dev_attr.attr,
+	&sensor_dev_attr_in3_label.dev_attr.attr,
+	&sensor_dev_attr_in4_input.dev_attr.attr,
+	&sensor_dev_attr_in4_label.dev_attr.attr,
+	&sensor_dev_attr_temp1_input.dev_attr.attr,
+	&sensor_dev_attr_temp1_label.dev_attr.attr,
+	NULL
+};
+
+static const struct attribute_group da9063_attr_group = {
+	.attrs = da9063_attributes,
+};
+
+static int da9063_hwmon_probe(struct platform_device *pdev)
+{
+	struct da9063 *da9063 = dev_get_drvdata(pdev->dev.parent);
+	struct da9063_pdata *pdata = da9063->dev->platform_data;
+	struct da9063_hwmon *hwmon;
+	int ret;
+	unsigned int val;
+
+	hwmon = devm_kzalloc(&pdev->dev, sizeof(struct da9063_hwmon),
+			     GFP_KERNEL);
+	if (!hwmon)
+		return -ENOMEM;
+
+	mutex_init(&hwmon->hwmon_mutex);
+	init_completion(&hwmon->adc_ready);
+	hwmon->da9063 = da9063;
+
+	/* enable the ADC functions for GPIO 0,1,2 */
+	val = (DA9063_GPIO0_PIN_ADCIN1 << DA9063_GPIO0_PIN_MASK_SHIFT |
+	       DA9063_GPIO1_PIN_ADCIN2_COMP << DA9063_GPIO1_PIN_MASK_SHIFT);
+	ret = regmap_update_bits(hwmon->da9063->regmap, DA9063_REG_GPIO_0_1,
+				 (DA9063_GPIO0_PIN_MASK |
+				  DA9063_GPIO1_PIN_MASK), val);
+	if (ret < 0) {
+		dev_err(&pdev->dev,
+			"Failed to alter the ADCIN 1,2 bits for the GPIO 0,1 register\n");
+		return -EIO;
+	}
+
+	val = DA9063_GPIO2_PIN_ADCIN3 << DA9063_GPIO2_PIN_MASK_SHIFT;
+	ret = regmap_update_bits(hwmon->da9063->regmap, DA9063_REG_GPIO_2_3,
+				 DA9063_GPIO2_PIN_MASK, val);
+	if (ret < 0) {
+		dev_err(&pdev->dev,
+			"Failed to alter the ADCIN 3 bits for the GPIO 2,3 register\n");
+		return -EIO;
+	}
+
+	/* debounce ADC I settings */
+	val = (DA9063_ADCIN1_DEB_ON << DA9063_REG_ADCIN1_DEB_SHIFT |
+	       DA9063_ADCIN2_DEB_ON << DA9063_REG_ADCIN2_DEB_SHIFT |
+	       DA9063_ADCIN3_DEB_ON << DA9063_REG_ADCIN3_DEB_SHIFT);
+	ret = regmap_update_bits(hwmon->da9063->regmap, DA9063_REG_ADC_CFG,
+				 (DA9063_REG_ADCIN1_DEB_MASK |
+				  DA9063_REG_ADCIN2_DEB_MASK |
+				  DA9063_REG_ADCIN3_DEB_MASK), val);
+	if (ret < 0) {
+		dev_err(&pdev->dev,
+			"Failed to alter the ADC configuration register\n");
+		return -EIO;
+	}
+
+	/* set up the current configurations */
+	val = (pdata->hwmon_pdata->adcin1_cur << DA9063_REG_ADCIN1_CUR_SHIFT |
+	       pdata->hwmon_pdata->adcin2_cur << DA9063_REG_ADCIN2_CUR_SHIFT |
+	       pdata->hwmon_pdata->adcin3_cur << DA9063_REG_ADCIN3_CUR_SHIFT);
+	ret = regmap_update_bits(hwmon->da9063->regmap, DA9063_REG_ADC_CFG,
+				 (DA9063_REG_ADCIN1_CUR_MASK |
+				  DA9063_REG_ADCIN2_CUR_MASK |
+				  DA9063_REG_ADCIN3_CUR_MASK), val);
+
+	ret = regmap_read(da9063->regmap, DA9063_REG_ADC_CFG, &val);
+	if (ret < 0) {
+		dev_err(&pdev->dev,
+			"Failed to read read the ADC configuration register\n");
+		return -EIO;
+	}
+
+	hwmon->irq = platform_get_irq_byname(pdev, DA9063_DRVNAME_HWMON);
+	if (hwmon->irq < 0)
+		return hwmon->irq;
+
+	ret = devm_request_threaded_irq(&pdev->dev, hwmon->irq, NULL,
+					da9063_hwmon_irq_handler,
+					IRQF_TRIGGER_LOW | IRQF_ONESHOT,
+					"HWMON", hwmon);
+	if (ret) {
+		dev_err(&pdev->dev, "Failed to request IRQ.\n");
+		return ret;
+	}
+
+	platform_set_drvdata(pdev, hwmon);
+
+	/* set trim temperature offset to value read at startup */
+	hwmon->tjunc_offset = (signed char)hwmon->da9063->t_offset;
+
+	ret = sysfs_create_group(&pdev->dev.kobj, &da9063_attr_group);
+	if (ret)
+		return ret;
+
+	hwmon->classdev = hwmon_device_register(&pdev->dev);
+	if (IS_ERR(hwmon->classdev)) {
+		sysfs_remove_group(&pdev->dev.kobj, &da9063_attr_group);
+		return PTR_ERR(hwmon->classdev);
+	}
+
+	return 0;
+}
+
+static int da9063_hwmon_remove(struct platform_device *pdev)
+{
+	struct da9063_hwmon *hwmon = platform_get_drvdata(pdev);
+
+	hwmon_device_unregister(hwmon->classdev);
+	sysfs_remove_group(&pdev->dev.kobj, &da9063_attr_group);
+
+	return 0;
+}
+
+static struct platform_driver da9063_hwmon_driver = {
+	.probe = da9063_hwmon_probe,
+	.remove = da9063_hwmon_remove,
+	.driver = {
+		   .name = DA9063_DRVNAME_HWMON,
+		   .owner = THIS_MODULE,
+		   },
+};
+
+module_platform_driver(da9063_hwmon_driver);
+
+MODULE_DESCRIPTION("Hardware monitor support device driver for Dialog DA9063");
+MODULE_AUTHOR("S Twiss <stwiss.opensource@diasemi.com>");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:" DA9063_DRVNAME_HWMON);
diff --git a/include/linux/mfd/da9063/registers.h b/include/linux/mfd/da9063/registers.h
index 09a85c6..922371b 100644
--- a/include/linux/mfd/da9063/registers.h
+++ b/include/linux/mfd/da9063/registers.h
@@ -474,6 +474,7 @@
 
 /* DA9063_REG_GPIO_0_1 (addr=0x15) */
 #define	DA9063_GPIO0_PIN_MASK			0x03
+#define	DA9063_GPIO0_PIN_MASK_SHIFT		0
 #define		DA9063_GPIO0_PIN_ADCIN1		0x00
 #define		DA9063_GPIO0_PIN_GPI		0x01
 #define		DA9063_GPIO0_PIN_GPO_OD		0x02
@@ -485,6 +486,7 @@
 #define		DA9063_GPIO0_TYPE_GPO_VDD_IO2	0x04
 #define	DA9063_GPIO0_NO_WAKEUP			0x08
 #define	DA9063_GPIO1_PIN_MASK			0x30
+#define	DA9063_GPIO1_PIN_MASK_SHIFT		4
 #define		DA9063_GPIO1_PIN_ADCIN2_COMP	0x00
 #define		DA9063_GPIO1_PIN_GPI		0x10
 #define		DA9063_GPIO1_PIN_GPO_OD		0x20
@@ -498,6 +500,7 @@
 
 /* DA9063_REG_GPIO_2_3 (addr=0x16) */
 #define	DA9063_GPIO2_PIN_MASK			0x03
+#define	DA9063_GPIO2_PIN_MASK_SHIFT		0
 #define		DA9063_GPIO2_PIN_ADCIN3		0x00
 #define		DA9063_GPIO2_PIN_GPI		0x01
 #define		DA9063_GPIO2_PIN_GPO_PSS	0x02
@@ -813,6 +816,7 @@
 #define	DA9063_VSYS_VAL_BASE			0x00
 
 /* DA9063_REG_ADC_RES_L (addr=0x37) */
+#define	DA9063_ADC_RES_L_SHIFT			6
 #define	DA9063_ADC_RES_L_BITS			2
 #define	DA9063_ADC_RES_L_MASK			0xC0
 
@@ -979,6 +983,36 @@
 #define DA9063_GPIO_DIM				0x80
 #define DA9063_GPIO_PWM_MASK			0x7F
 
+/* DA9063_REG_ADC_CFG (addr=0xC9) */
+#define DA9063_REG_ADCIN1_CUR_MASK		0x03
+#define DA9063_REG_ADCIN1_CUR_SHIFT		0
+#define		DA9063_ADCIN1_CUR_1UA		0x00
+#define		DA9063_ADCIN1_CUR_2UA		0x01
+#define		DA9063_ADCIN1_CUR_10UA		0x02
+#define		DA9063_ADCIN1_CUR_40UA		0x03
+#define DA9063_REG_ADCIN2_CUR_MASK		0x0C
+#define DA9063_REG_ADCIN2_CUR_SHIFT		2
+#define		DA9063_ADCIN2_CUR_1UA		0x00
+#define		DA9063_ADCIN2_CUR_2UA		0x01
+#define		DA9063_ADCIN2_CUR_10UA		0x02
+#define		DA9063_ADCIN2_CUR_40UA		0x03
+#define DA9063_REG_ADCIN3_CUR_MASK		0x10
+#define DA9063_REG_ADCIN3_CUR_SHIFT		4
+#define		DA9063_ADCIN3_CUR_10UA		0x00
+#define		DA9063_ADCIN3_CUR_40UA		0x01
+#define DA9063_REG_ADCIN1_DEB_MASK		0x20
+#define DA9063_REG_ADCIN1_DEB_SHIFT		5
+#define		DA9063_ADCIN1_DEB_OFF		0x00
+#define		DA9063_ADCIN1_DEB_ON		0x01
+#define DA9063_REG_ADCIN2_DEB_MASK		0x40
+#define DA9063_REG_ADCIN2_DEB_SHIFT		6
+#define		DA9063_ADCIN2_DEB_OFF		0x00
+#define		DA9063_ADCIN2_DEB_ON		0x01
+#define DA9063_REG_ADCIN3_DEB_MASK		0x80
+#define DA9063_REG_ADCIN3_DEB_SHIFT		7
+#define		DA9063_ADCIN3_DEB_OFF		0x00
+#define		DA9063_ADCIN3_DEB_ON		0x01
+
 /* DA9063_REG_CONFIG_H (addr=0x10D) */
 #define DA9063_PWM_CLK_MASK			0x01
 #define		DA9063_PWM_CLK_PWM2MHZ		0x00
-- 
end-of-patch for RFC V1

