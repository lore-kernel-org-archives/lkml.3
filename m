Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751764AbaHMHss (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 03:48:48 -0400
Received: from mail1.bemta5.messagelabs.com ([195.245.231.144]:32952 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751704AbaHMHsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 03:48:46 -0400
X-Env-Sender: Andreas.Werner@men.de
X-Msg-Ref: server-11.tower-179.messagelabs.com!1407916123!34574241!1
X-Originating-IP: [80.255.6.145]
X-StarScan-Received: 
X-StarScan-Version: 6.11.3; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Wed, 13 Aug 2014 09:48:44 +0200
Date: Wed, 13 Aug 2014 10:40:37 +0200
From: Andreas Werner <andreas.werner@men.de>
To: <linux-kernel@vger.kernel.org>
CC: <andreas.werner@men.de>, <sameo@linux.intel.com>, <lee.jones@linaro.org>,
        <wim@iguana.be>, <linux-watchdog@vger.kernel.org>,
        <cooloney@gmail.com>, <rpurdie@rpsys.net>,
        <linux-leds@vger.kernel.org>, <jdelvare@suse.de>, <linux@roeck-us.net>,
        <lm-sensors@lm-sensors.org>
Subject: [PATCH v4 4/4] drivers/hwmon/menf21bmc_hwmon: introduce MEN14F021P00
 BMC HWMON driver
Message-ID: <cf0593273cbadcb16b094b7bc3bd9d3b5a93f7ed.1407918792.git.andreas.werner@men.de>
References: <cover.1407918792.git.andreas.werner@men.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1407918792.git.andreas.werner@men.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Originating-IP: [192.1.1.171]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added driver to support the 14F021P00 BMC Hardware Monitoring.
The BMC is a Board Management Controller including monitoring of the
board voltages.

Signed-off-by: Andreas Werner <andreas.werner@men.de>
---
 drivers/hwmon/Kconfig           |   7 ++
 drivers/hwmon/Makefile          |   1 +
 drivers/hwmon/menf21bmc_hwmon.c | 238 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 246 insertions(+)
 create mode 100644 drivers/hwmon/menf21bmc_hwmon.c

diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index 37908ff..437c00f 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -828,6 +828,13 @@ config SENSORS_MCP3021
 	  This driver can also be built as a module.  If so, the module
 	  will be called mcp3021.
 
+config SENSORS_MENF21BMC_HWMON
+	tristate "MEN 14F021P00 BMC Hardware Monitoring"
+	depends on MFD_MENF21BMC && I2C
+	help
+	  Say Y here to include support for the MEN 14F021P00 BMC
+	  hardware monitoring.
+
 config SENSORS_ADCXX
 	tristate "National Semiconductor ADCxxxSxxx"
 	depends on SPI_MASTER
diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
index 1362382..56ab872 100644
--- a/drivers/hwmon/Makefile
+++ b/drivers/hwmon/Makefile
@@ -114,6 +114,7 @@ obj-$(CONFIG_SENSORS_MAX6650)	+= max6650.o
 obj-$(CONFIG_SENSORS_MAX6697)	+= max6697.o
 obj-$(CONFIG_SENSORS_MC13783_ADC)+= mc13783-adc.o
 obj-$(CONFIG_SENSORS_MCP3021)	+= mcp3021.o
+obj-$(CONFIG_SENSORS_MENF21BMC_HWMON) += menf21bmc_hwmon.o
 obj-$(CONFIG_SENSORS_NCT6683)	+= nct6683.o
 obj-$(CONFIG_SENSORS_NCT6775)	+= nct6775.o
 obj-$(CONFIG_SENSORS_NTC_THERMISTOR)	+= ntc_thermistor.o
diff --git a/drivers/hwmon/menf21bmc_hwmon.c b/drivers/hwmon/menf21bmc_hwmon.c
new file mode 100644
index 0000000..ecb0ef1
--- /dev/null
+++ b/drivers/hwmon/menf21bmc_hwmon.c
@@ -0,0 +1,238 @@
+/*
+ *  MEN 14F021P00 Board Management Controller (BMC) hwmon driver.
+ *
+ *  This is the core hwmon driver of the MEN 14F021P00 BMC.
+ *  The BMC monitors the board voltages which can be access with this
+ *  driver through sysfs.
+ *
+ *  Copyright (C) 2014 MEN Mikro Elektronik Nuernberg GmbH
+ *
+ *  This program is free software; you can redistribute  it and/or modify it
+ *  under  the terms of  the GNU General  Public License as published by the
+ *  Free Software Foundation;  either version 2 of the  License, or (at your
+ *  option) any later version.
+ */
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/platform_device.h>
+#include <linux/hwmon.h>
+#include <linux/hwmon-sysfs.h>
+#include <linux/jiffies.h>
+#include <linux/slab.h>
+#include <linux/i2c.h>
+
+#define DEVNAME "menf21bmc_hwmon"
+
+#define BMC_VOLT_COUNT	5
+#define MENF21BMC_V33	0
+#define MENF21BMC_V5	1
+#define MENF21BMC_V12	2
+#define MENF21BMC_V5_SB	3
+#define MENF21BMC_VBAT	4
+
+#define BMC_CMD_GET_NUM_VOLT 0x8E
+#define IDX_TO_VOLT_MIN_CMD(idx) (0x40 + idx)
+#define IDX_TO_VOLT_MAX_CMD(idx) (0x50 + idx)
+#define IDX_TO_VOLT_INP_CMD(idx) (0x60 + idx)
+
+struct menf21bmc_hwmon {
+	char valid;
+	struct i2c_client *i2c_client;
+	unsigned long last_update;
+	u16 in_val[BMC_VOLT_COUNT];
+	u16 in_min[BMC_VOLT_COUNT];
+	u16 in_max[BMC_VOLT_COUNT];
+};
+
+static const char *const input_names[] = {
+	[MENF21BMC_V33]		= "MON_3,3V",
+	[MENF21BMC_V5]		= "MON_5V",
+	[MENF21BMC_V12]		= "MON_12V",
+	[MENF21BMC_V5_SB]	= "5V_STANDBY",
+	[MENF21BMC_VBAT]	= "VBAT"
+};
+
+static struct menf21bmc_hwmon *menf21bmc_hwmon_update(struct device *dev)
+{
+	int i;
+	uint16_t val;
+	struct menf21bmc_hwmon *drv_data = dev_get_drvdata(dev);
+	struct menf21bmc_hwmon *data_ret = drv_data;
+
+	if (time_after(jiffies, drv_data->last_update + HZ) || !drv_data->valid) {
+		for (i = 0; i < BMC_VOLT_COUNT; i++) {
+			val = i2c_smbus_read_word_data(drv_data->i2c_client,
+						       IDX_TO_VOLT_INP_CMD(i));
+			if (val < 0)
+				goto abort;
+
+			drv_data->in_val[i] = val;
+		}
+		drv_data->last_update = jiffies;
+		drv_data->valid = 1;
+	}
+abort:
+	return data_ret;
+}
+
+static int menf21bmc_hwmon_get_volt_limits(struct menf21bmc_hwmon *drv_data)
+{
+	int i;
+	uint16_t val;
+
+	for (i = 0; i < BMC_VOLT_COUNT; i++) {
+		val = i2c_smbus_read_word_data(drv_data->i2c_client,
+					       IDX_TO_VOLT_MIN_CMD(i));
+		if (val < 0)
+			return val;
+
+		drv_data->in_min[i] = val;
+
+		val = i2c_smbus_read_word_data(drv_data->i2c_client,
+					       IDX_TO_VOLT_MAX_CMD(i));
+		if (val < 0)
+			return val;
+
+		drv_data->in_max[i] = val;
+	}
+	return 0;
+}
+
+static ssize_t
+show_label(struct device *dev, struct device_attribute *devattr, char *buf)
+{
+	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
+
+	return sprintf(buf, "%s\n", input_names[attr->index]);
+}
+
+static ssize_t
+show_in(struct device *dev, struct device_attribute *devattr, char *buf)
+{
+	uint16_t val;
+	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
+	struct menf21bmc_hwmon *drv_data = menf21bmc_hwmon_update(dev);
+
+	val = drv_data->in_val[attr->index];
+	return sprintf(buf, "%d\n", val);
+}
+
+static ssize_t
+show_min(struct device *dev, struct device_attribute *devattr, char *buf)
+{
+	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
+	struct menf21bmc_hwmon *drv_data = menf21bmc_hwmon_update(dev);
+
+	return sprintf(buf, "%d\n", drv_data->in_min[attr->index]);
+}
+
+static ssize_t
+show_max(struct device *dev, struct device_attribute *devattr, char *buf)
+{
+	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
+	struct menf21bmc_hwmon *drv_data = menf21bmc_hwmon_update(dev);
+
+	return sprintf(buf, "%d\n", drv_data->in_max[attr->index]);
+}
+
+#define create_voltage_sysfs(idx)			\
+static SENSOR_DEVICE_ATTR(in##idx##_input, S_IRUGO,	\
+			show_in, NULL, idx);		\
+static SENSOR_DEVICE_ATTR(in##idx##_min, S_IRUGO,	\
+			show_min, NULL, idx);		\
+static SENSOR_DEVICE_ATTR(in##idx##_max, S_IRUGO,	\
+			show_max, NULL, idx);		\
+static SENSOR_DEVICE_ATTR(in##idx##_label, S_IRUGO,	\
+			show_label, NULL, idx);
+
+create_voltage_sysfs(0);
+create_voltage_sysfs(1);
+create_voltage_sysfs(2);
+create_voltage_sysfs(3);
+create_voltage_sysfs(4);
+
+static struct attribute *menf21bmc_hwmon_attr_volts[] = {
+	&sensor_dev_attr_in0_input.dev_attr.attr,
+	&sensor_dev_attr_in0_min.dev_attr.attr,
+	&sensor_dev_attr_in0_max.dev_attr.attr,
+	&sensor_dev_attr_in0_label.dev_attr.attr,
+
+	&sensor_dev_attr_in1_input.dev_attr.attr,
+	&sensor_dev_attr_in1_min.dev_attr.attr,
+	&sensor_dev_attr_in1_max.dev_attr.attr,
+	&sensor_dev_attr_in1_label.dev_attr.attr,
+
+	&sensor_dev_attr_in2_input.dev_attr.attr,
+	&sensor_dev_attr_in2_min.dev_attr.attr,
+	&sensor_dev_attr_in2_max.dev_attr.attr,
+	&sensor_dev_attr_in2_label.dev_attr.attr,
+
+	&sensor_dev_attr_in3_input.dev_attr.attr,
+	&sensor_dev_attr_in3_min.dev_attr.attr,
+	&sensor_dev_attr_in3_max.dev_attr.attr,
+	&sensor_dev_attr_in3_label.dev_attr.attr,
+
+	&sensor_dev_attr_in4_input.dev_attr.attr,
+	&sensor_dev_attr_in4_min.dev_attr.attr,
+	&sensor_dev_attr_in4_max.dev_attr.attr,
+	&sensor_dev_attr_in4_label.dev_attr.attr,
+	NULL
+};
+
+static const struct attribute_group menf21bmc_hwmon_attr_group_volts = {
+	.attrs = menf21bmc_hwmon_attr_volts,
+};
+
+static const struct attribute_group *menf21bmc_hwmon_groups[] = {
+	&menf21bmc_hwmon_attr_group_volts,
+	NULL
+};
+
+static int menf21bmc_hwmon_probe(struct platform_device *pdev)
+{
+	int ret;
+	struct menf21bmc_hwmon *drv_data;
+	struct i2c_client *i2c_client = to_i2c_client(pdev->dev.parent);
+	struct device *hwmon_dev;
+
+	drv_data = devm_kzalloc(&pdev->dev, sizeof(struct menf21bmc_hwmon),
+				GFP_KERNEL);
+	if (!drv_data)
+		return -ENOMEM;
+
+	drv_data->i2c_client = i2c_client;
+	platform_set_drvdata(pdev, drv_data);
+
+	ret = menf21bmc_hwmon_get_volt_limits(drv_data);
+	if (ret) {
+		dev_err(&pdev->dev, "failed to read sensor limits");
+		return ret;
+	}
+
+	hwmon_dev = devm_hwmon_device_register_with_groups(&pdev->dev,
+							   DEVNAME, drv_data,
+							   menf21bmc_hwmon_groups);
+
+	if (IS_ERR(hwmon_dev))
+		return PTR_ERR(hwmon_dev);
+
+	dev_info(&pdev->dev, "MEN 14F021P00 BMC hwmon device enabled");
+
+	return 0;
+}
+
+static struct platform_driver menf21bmc_hwmon = {
+	.probe		= menf21bmc_hwmon_probe,
+	.driver		= {
+		.name		= DEVNAME,
+		.owner		= THIS_MODULE,
+	},
+};
+
+module_platform_driver(menf21bmc_hwmon);
+
+MODULE_AUTHOR("Andreas Werner <andreas.werner@men.de>");
+MODULE_DESCRIPTION("MEN 14F021P00 BMC hwmon");
+MODULE_LICENSE("GPL v2");
+MODULE_ALIAS("platform:menf21bmc_hwmon");
-- 
2.0.4

