Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385AbaE2GOu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 02:14:50 -0400
Received: from acledge1.advantech.com.tw ([61.58.41.197]:51922 "EHLO
	acledge1.advantech.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751010AbaE2GOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 02:14:48 -0400
X-Greylist: delayed 926 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 May 2014 02:14:47 EDT
From: Wei-Chun Pan <weichun.pan@advantech.com.tw>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Jean Delvare <jdelvare@suse.de>, Guenter Roeck <linux@roeck-us.net>,
        Wolfram Sang <wsa@the-dreams.de>
CC: "Louis.Lu" <Louis.Lu@advantech.com.tw>, "Neo.Lo" <neo.lo@advantech.com.tw>,
        "Hank.Peng" <Hank.Peng@advantech.com.tw>,
        "Kevin.Ong" <Kevin.Ong@advantech.com.tw>,
        <linux-kernel@vger.kernel.org>,
        Wei-Chun Pan <weichun.pan@advantech.com.tw>
Subject: [PATCH 2/3] hwmon: (iManager2) Add support for IT8516/18/28
Date: Wed, 28 May 2014 22:57:15 -0700
Message-ID: <1401343036-26159-2-git-send-email-weichun.pan@advantech.com.tw>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401343036-26159-1-git-send-email-weichun.pan@advantech.com.tw>
References: <1401343036-26159-1-git-send-email-weichun.pan@advantech.com.tw>
MIME-Version: 1.0
Content-Type: text/plain
X-StopIT: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    Advantech's new module comes equipped with "iManager" - an embedded controller (EC), providing embedded features for system integrators to increase reliability and simplify integration.
    This patch add the MFD driver for enabling Advantech iManager V2.0 chipset. Available functions support HW Monitor base on ITE-IT85XX chip. These functions are tested on Advantech SOM-5892 board. All the embedded functions are configured by a utility. Advantech has done all the hard work for user with the release of a suite of Software APIs.
    These provide not only the underlying drivers required but also a rich set of user-friendly, intelligent and integrated interfaces, which speeds development, enhances security and offers add-on value for Advantech platforms.

Signed-off-by: Wei-Chun Pan Developer <weichun.pan@advantech.com.tw>
---
 drivers/hwmon/Kconfig         |   7 +
 drivers/hwmon/Makefile        |   1 +
 drivers/hwmon/imanager2_hwm.c | 635 ++++++++++++++++++++++++++++++++++++++++++
 drivers/hwmon/imanager2_hwm.h | 118 ++++++++
 4 files changed, 761 insertions(+)
 mode change 100644 => 100755 drivers/hwmon/Kconfig
 mode change 100644 => 100755 drivers/hwmon/Makefile
 create mode 100755 drivers/hwmon/imanager2_hwm.c
 create mode 100755 drivers/hwmon/imanager2_hwm.h

diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
old mode 100644
new mode 100755
index bc196f4..d4aeab6
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -39,6 +39,13 @@ config HWMON_DEBUG_CHIP
 
 comment "Native drivers"
 
+config SENSORS_IMANAGER2
+	tristate "Support for Advantech iManager2 EC H.W. Monitor"
+	select MFD_CORE
+	select MFD_IMANAGER2
+	help
+	  Support for the Advantech iManager2 EC H.W. Monitor
+
 config SENSORS_AB8500
 	tristate "AB8500 thermal monitoring"
 	depends on AB8500_GPADC && AB8500_BM
diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
old mode 100644
new mode 100755
index c48f987..a2c8f07
--- a/drivers/hwmon/Makefile
+++ b/drivers/hwmon/Makefile
@@ -146,6 +146,7 @@ obj-$(CONFIG_SENSORS_W83L785TS)	+= w83l785ts.o
 obj-$(CONFIG_SENSORS_W83L786NG)	+= w83l786ng.o
 obj-$(CONFIG_SENSORS_WM831X)	+= wm831x-hwmon.o
 obj-$(CONFIG_SENSORS_WM8350)	+= wm8350-hwmon.o
+obj-$(CONFIG_SENSORS_IMANAGER2)	+= imanager2_hwm.o
 
 obj-$(CONFIG_PMBUS)		+= pmbus/
 
diff --git a/drivers/hwmon/imanager2_hwm.c b/drivers/hwmon/imanager2_hwm.c
new file mode 100755
index 0000000..48fe3dd
--- /dev/null
+++ b/drivers/hwmon/imanager2_hwm.c
@@ -0,0 +1,635 @@
+/* imanager2_hwm.c - HW Monitoring interface for Advantech EC IT8516/18/28
+ * Copyright (C) 2014  Richard Vidal-Dorsch <richard.dorsch@advantech.com>
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 3 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/hwmon.h>
+#include <linux/hwmon-sysfs.h>
+#include <linux/mfd/advantech/imanager2.h>
+#include "imanager2_hwm.h"
+
+#define DRV_NAME	CHIP_NAME "_hwm"
+#define DRV_VERSION	"0.4.6"
+
+/* Voltage */
+static int ec_get_voltage_adc(struct it85xx *ec, int index,
+			      u32 *volt_millivolt)
+{
+	int ret;
+	u8 portnum, tmp[2];
+
+	*volt_millivolt = 0;
+
+	spin_lock(&ec->lock);
+
+	if ((ec->flag & EC_F_MAILBOX) != 0) {
+		ret = ec_mailbox_read_buffer(ec, EC_CMD_MAILBOX_READ_HW_PIN,
+					     ec_volt_table[index].did, &tmp[0],
+					     2);
+	} else {
+		u8 pin = ec->table.pinnum[ec->table.devid2itemnum[
+						ec_volt_table[index].did]];
+
+		ret = ec_io_read(EC_CMD_ADC_INDEX, pin, &portnum, 1);
+		if (ret != 0)
+			goto unlock;
+		if (portnum == 0xFF) {
+			ret = -EFAULT;
+			goto unlock;
+		}
+
+		ret = ec_io_read_byte_without_offset(EC_CMD_ADC_READ_LSB,
+						     &tmp[1]);
+		if (ret != 0)
+			goto unlock;
+
+		ret = ec_io_read_byte_without_offset(EC_CMD_ADC_READ_MSB,
+						     &tmp[0]);
+	}
+unlock:
+	spin_unlock(&ec->lock);
+
+	if (ret != 0)
+		return ret;
+
+	*volt_millivolt = ((tmp[0] << 8 | tmp[1]) & EC_ADC_RESOLUTION_MAX) *
+			  ec_volt_table[index].factor *
+			  EC_ADC_VOLTAGE_VALUE_MAX / EC_ADC_RESOLUTION_MAX;
+
+	return 0;
+}
+
+static void ec_volt_init_once(struct it85xx *ec, int index)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(ec_volt_table); i++) {
+		if (ec->table.devid2itemnum[ec_volt_table[i].did] !=
+							EC_TABLE_ITEM_UNUSED) {
+			ec_volt_table[i].factor = 1;
+			ec_volt_table[i].visible = 1;
+		} else if (ec->table.devid2itemnum[ec_volt_table[i].did + 1] !=
+							EC_TABLE_ITEM_UNUSED) {
+			ec_volt_table[i].did += 1;
+			ec_volt_table[i].factor = 2;
+			ec_volt_table[i].visible = 1;
+		} else if (ec->table.devid2itemnum[ec_volt_table[i].did + 2] !=
+							EC_TABLE_ITEM_UNUSED) {
+			ec_volt_table[i].did += 2;
+			ec_volt_table[i].factor = 10;
+			ec_volt_table[i].visible = 1;
+		} else {
+			ec_volt_table[i].visible = 0;
+		}
+	}
+}
+
+static ssize_t show_in(struct device *dev, struct device_attribute *dev_attr,
+		       char *buf)
+{
+	struct it85xx *ec = dev_get_drvdata(dev);
+	u32 val;
+	int i = to_sensor_dev_attr(dev_attr)->index;
+	int ret = ec_get_voltage_adc(ec, i, &val);
+
+	if (ret != 0)
+		return (ssize_t)ret;
+
+	return sprintf(buf, "%u\n", val);
+}
+
+static ssize_t show_in_label(struct device *dev,
+			     struct device_attribute *dev_attr, char *buf)
+{
+	int i = to_sensor_dev_attr(dev_attr)->index;
+	return sprintf(buf, "%s\n", ec_volt_table[i].name);
+}
+
+static SENSOR_DEVICE_ATTR(in0_input, S_IRUGO, show_in, NULL, 0);
+static SENSOR_DEVICE_ATTR(in1_input, S_IRUGO, show_in, NULL, 1);
+static SENSOR_DEVICE_ATTR(in2_input, S_IRUGO, show_in, NULL, 2);
+static SENSOR_DEVICE_ATTR(in3_input, S_IRUGO, show_in, NULL, 3);
+static SENSOR_DEVICE_ATTR(in4_input, S_IRUGO, show_in, NULL, 4);
+static SENSOR_DEVICE_ATTR(in5_input, S_IRUGO, show_in, NULL, 5);
+static SENSOR_DEVICE_ATTR(in6_input, S_IRUGO, show_in, NULL, 6);
+static SENSOR_DEVICE_ATTR(in7_input, S_IRUGO, show_in, NULL, 7);
+static SENSOR_DEVICE_ATTR(in8_input, S_IRUGO, show_in, NULL, 8);
+static SENSOR_DEVICE_ATTR(in9_input, S_IRUGO, show_in, NULL, 9);
+static SENSOR_DEVICE_ATTR(in10_input, S_IRUGO, show_in, NULL, 10);
+static SENSOR_DEVICE_ATTR(in11_input, S_IRUGO, show_in, NULL, 11);
+
+static SENSOR_DEVICE_ATTR(in0_label, S_IRUGO, show_in_label, NULL, 0);
+static SENSOR_DEVICE_ATTR(in1_label, S_IRUGO, show_in_label, NULL, 1);
+static SENSOR_DEVICE_ATTR(in2_label, S_IRUGO, show_in_label, NULL, 2);
+static SENSOR_DEVICE_ATTR(in3_label, S_IRUGO, show_in_label, NULL, 3);
+static SENSOR_DEVICE_ATTR(in4_label, S_IRUGO, show_in_label, NULL, 4);
+static SENSOR_DEVICE_ATTR(in5_label, S_IRUGO, show_in_label, NULL, 5);
+static SENSOR_DEVICE_ATTR(in6_label, S_IRUGO, show_in_label, NULL, 6);
+static SENSOR_DEVICE_ATTR(in7_label, S_IRUGO, show_in_label, NULL, 7);
+static SENSOR_DEVICE_ATTR(in8_label, S_IRUGO, show_in_label, NULL, 8);
+static SENSOR_DEVICE_ATTR(in9_label, S_IRUGO, show_in_label, NULL, 9);
+static SENSOR_DEVICE_ATTR(in10_label, S_IRUGO, show_in_label, NULL, 10);
+static SENSOR_DEVICE_ATTR(in11_label, S_IRUGO, show_in_label, NULL, 11);
+
+static struct attribute *it85xx_volt_attrs[] = {
+	&sensor_dev_attr_in0_label.dev_attr.attr,
+	&sensor_dev_attr_in0_input.dev_attr.attr,
+
+	&sensor_dev_attr_in1_label.dev_attr.attr,
+	&sensor_dev_attr_in1_input.dev_attr.attr,
+
+	&sensor_dev_attr_in2_label.dev_attr.attr,
+	&sensor_dev_attr_in2_input.dev_attr.attr,
+
+	&sensor_dev_attr_in3_label.dev_attr.attr,
+	&sensor_dev_attr_in3_input.dev_attr.attr,
+
+	&sensor_dev_attr_in4_label.dev_attr.attr,
+	&sensor_dev_attr_in4_input.dev_attr.attr,
+
+	&sensor_dev_attr_in5_label.dev_attr.attr,
+	&sensor_dev_attr_in5_input.dev_attr.attr,
+
+	&sensor_dev_attr_in6_label.dev_attr.attr,
+	&sensor_dev_attr_in6_input.dev_attr.attr,
+
+	&sensor_dev_attr_in7_label.dev_attr.attr,
+	&sensor_dev_attr_in7_input.dev_attr.attr,
+
+	&sensor_dev_attr_in8_label.dev_attr.attr,
+	&sensor_dev_attr_in8_input.dev_attr.attr,
+
+	&sensor_dev_attr_in9_label.dev_attr.attr,
+	&sensor_dev_attr_in9_input.dev_attr.attr,
+
+	&sensor_dev_attr_in10_label.dev_attr.attr,
+	&sensor_dev_attr_in10_input.dev_attr.attr,
+
+	&sensor_dev_attr_in11_label.dev_attr.attr,
+	&sensor_dev_attr_in11_input.dev_attr.attr,
+
+	NULL
+};
+
+static umode_t it85xx_volt_mode(struct kobject *kobj, struct attribute *attr,
+				int index)
+{
+	struct sensor_device_attribute *sensor = container_of(
+			attr, struct sensor_device_attribute, dev_attr.attr);
+
+	if (ec_volt_table[sensor->index].visible == 0)
+		return 0;
+
+	return attr->mode;
+}
+
+static const struct attribute_group it85xx_volt_group = {
+	.attrs = it85xx_volt_attrs,
+	.is_visible = it85xx_volt_mode,
+};
+
+/* Current */
+static int ec_get_current_adc(struct it85xx *ec, int index,
+			      u32 *curr_milliampere)
+{
+	int ret;
+	u8 i, tmp[5];
+	u16 value, factor;
+	u32 baseunit;
+
+	*curr_milliampere = 0;
+
+	spin_lock(&ec->lock);
+
+	if ((ec->flag & EC_F_MAILBOX) != 0)
+		ret = ec_mailbox_read_buffer(ec, EC_CMD_MAILBOX_READ_HW_PIN,
+					     ec_curr_table[index].did,
+					     tmp, ARRAY_SIZE(tmp));
+	else
+		ret = -EOPNOTSUPP;
+
+	spin_unlock(&ec->lock);
+
+	if (ret != 0)
+		return ret;
+
+	value = (tmp[0] << 8 | tmp[1]) & EC_ADC_RESOLUTION_MAX;
+	factor = tmp[2] << 8 | tmp[3];
+	baseunit = 1;
+	for (i = 1; i < tmp[4]; i++)
+		baseunit *= 10;
+
+	*curr_milliampere = value * factor * baseunit *
+			    EC_ADC_CURRENT_VALUE_MAX / EC_ADC_RESOLUTION_MAX;
+
+	return 0;
+}
+
+static void ec_current_init_once(struct it85xx *ec)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(ec_curr_table); i++)
+		if (ec->table.devid2itemnum[ec_curr_table[i].did] !=
+							EC_TABLE_ITEM_UNUSED)
+			ec_curr_table[i].visible = 1;
+		else
+			ec_curr_table[i].visible = 0;
+}
+
+static ssize_t show_curr(struct device *dev, struct device_attribute *dev_attr,
+			 char *buf)
+{
+	struct it85xx *ec = dev_get_drvdata(dev);
+	u32 val;
+	int i = to_sensor_dev_attr(dev_attr)->index;
+	int ret = ec_get_current_adc(ec, i, &val);
+
+	if (ret != 0)
+		return (ssize_t)ret;
+
+	return sprintf(buf, "%u\n", val);
+}
+
+static ssize_t show_curr_label(struct device *dev,
+			       struct device_attribute *dev_attr, char *buf)
+{
+	int i = to_sensor_dev_attr(dev_attr)->index;
+	return sprintf(buf, "%s\n", ec_curr_table[i].name);
+}
+
+static SENSOR_DEVICE_ATTR(curr1_input, S_IRUGO, show_curr, NULL, 0);
+static SENSOR_DEVICE_ATTR(curr1_label, S_IRUGO, show_curr_label, NULL, 0);
+
+static struct attribute *it85xx_curr_attrs[] = {
+	&sensor_dev_attr_curr1_label.dev_attr.attr,
+	&sensor_dev_attr_curr1_input.dev_attr.attr,
+
+	NULL
+};
+
+static umode_t it85xx_curr_mode(struct kobject *kobj, struct attribute *attr,
+				int index)
+{
+	struct sensor_device_attribute *sensor = container_of(
+			attr, struct sensor_device_attribute, dev_attr.attr);
+
+	if (ec_curr_table[sensor->index].visible == 0)
+		return 0;
+
+	return attr->mode;
+}
+
+static const struct attribute_group it85xx_curr_group = {
+	.attrs = it85xx_curr_attrs,
+	.is_visible = it85xx_curr_mode,
+};
+
+/* Temperature */
+static int ec_get_thermal_temperature(struct it85xx *ec, int index,
+				      int *temp_millicelsius)
+{
+	int ret;
+	u8 tmp;
+
+	*temp_millicelsius = 0;
+
+	spin_lock(&ec->lock);
+	ret = ec_acpiram_read_byte(ec, ec_temp_table[index].zonetype_acpireg,
+				   &tmp);
+	spin_unlock(&ec->lock);
+
+	if (ret != 0)
+		return ret;
+
+	*temp_millicelsius = ((signed)tmp) * 1000;
+
+	return 0;
+}
+
+static void ec_temp_init_once(struct it85xx *ec)
+{
+	int i, j, ret;
+	u8 tmltype;
+	struct ec_thermalzone zone;
+
+	for (i = 0; i < ARRAY_SIZE(ec_temp_table); i++)
+		ec_temp_table[i].visible = 0;
+
+	for (i = 0; i < EC_MAX_THERMAL_ZONE; i++) {
+		spin_lock(&ec->lock);
+
+		if ((ec->flag & EC_F_MAILBOX) != 0) {
+			int len = sizeof(struct ec_thermalzone);
+			ret = ec_read_thermalzone(ec, i, NULL, NULL,
+						  (u8 *)&zone, &len);
+		} else {
+			ret = ec_io_read(
+				EC_CMD_HWRAM_READ,
+				EC_HWRAM_ADDR_THERMAL_SOURCE_SMB_STATUS(i),
+				&zone.status, 1);
+		}
+
+		spin_unlock(&ec->lock);
+
+		if (ret != 0)
+			continue;
+
+		tmltype = (zone.status >> 5);
+
+		for (j = 0; j < ARRAY_SIZE(ec_temp_table); j++) {
+			if (tmltype == ec_temp_table[j].zonetype_value) {
+				ec_temp_table[j].visible = 1;
+				break;
+			}
+		}
+	}
+}
+
+static ssize_t show_temp(struct device *dev, struct device_attribute *dev_attr,
+			 char *buf)
+{
+	struct it85xx *ec = dev_get_drvdata(dev);
+	int i = to_sensor_dev_attr(dev_attr)->index;
+	int val, ret;
+	ret = ec_get_thermal_temperature(ec, i, &val);
+
+	if (ret != 0)
+		return (ssize_t)ret;
+
+	return sprintf(buf, "%d\n", val);
+}
+
+static ssize_t show_temp_label(struct device *dev,
+			       struct device_attribute *dev_attr, char *buf)
+{
+	int i = to_sensor_dev_attr(dev_attr)->index;
+	return sprintf(buf, "%s\n", ec_temp_table[i].name);
+}
+
+static SENSOR_DEVICE_ATTR(temp1_input, S_IRUGO, show_temp, NULL, 0);
+static SENSOR_DEVICE_ATTR(temp2_input, S_IRUGO, show_temp, NULL, 1);
+static SENSOR_DEVICE_ATTR(temp3_input, S_IRUGO, show_temp, NULL, 2);
+static SENSOR_DEVICE_ATTR(temp4_input, S_IRUGO, show_temp, NULL, 3);
+
+static SENSOR_DEVICE_ATTR(temp1_label, S_IRUGO, show_temp_label, NULL, 0);
+static SENSOR_DEVICE_ATTR(temp2_label, S_IRUGO, show_temp_label, NULL, 1);
+static SENSOR_DEVICE_ATTR(temp3_label, S_IRUGO, show_temp_label, NULL, 2);
+static SENSOR_DEVICE_ATTR(temp4_label, S_IRUGO, show_temp_label, NULL, 3);
+
+static struct attribute *it85xx_temp_attrs[] = {
+	&sensor_dev_attr_temp1_label.dev_attr.attr,
+	&sensor_dev_attr_temp1_input.dev_attr.attr,
+
+	&sensor_dev_attr_temp2_label.dev_attr.attr,
+	&sensor_dev_attr_temp2_input.dev_attr.attr,
+
+	&sensor_dev_attr_temp3_label.dev_attr.attr,
+	&sensor_dev_attr_temp3_input.dev_attr.attr,
+
+	&sensor_dev_attr_temp4_label.dev_attr.attr,
+	&sensor_dev_attr_temp4_input.dev_attr.attr,
+
+	NULL
+};
+
+static umode_t it85xx_temp_mode(struct kobject *kobj, struct attribute *attr,
+				int index)
+{
+	struct sensor_device_attribute *sensor = container_of(
+			attr, struct sensor_device_attribute, dev_attr.attr);
+
+	if (ec_temp_table[sensor->index].visible == 0)
+		return 0;
+
+	return attr->mode;
+}
+
+static const struct attribute_group it85xx_temp_group = {
+	.attrs = it85xx_temp_attrs,
+	.is_visible = it85xx_temp_mode,
+};
+
+/* Fan Speed */
+static int ec_get_fan_speed(struct it85xx *ec, int index, u32 *speed_rpm)
+{
+	int ret;
+	u8 tmp[2];
+
+	*speed_rpm = 0;
+
+	spin_lock(&ec->lock);
+
+	if ((ec->flag & EC_F_MAILBOX) != 0)
+		ret = ec_mailbox_read_buffer(ec, EC_CMD_MAILBOX_READ_HW_PIN,
+					     ec_fan_table[index].did,
+					     &tmp[0], 2);
+	else
+		ret = ec_io_read(EC_CMD_ACPIRAM_READ,
+				 ec_fan_table[index].fspeed_acpireg,
+				 &tmp[0], 2);
+
+	spin_unlock(&ec->lock);
+
+	if (ret != 0)
+		return ret;
+
+	if (tmp[0] == 0xFF && tmp[1] == 0xFF)
+		return -ENODEV;
+
+	*speed_rpm = (tmp[0] << 8) | tmp[1];
+
+	return 0;
+}
+
+static void ec_fan_init_once(struct it85xx *ec)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(ec_fan_table); i++)
+		ec_fan_table[i].visible = 0;
+
+	if ((ec->flag & EC_F_MAILBOX) != 0) {
+		for (i = 0; i < ARRAY_SIZE(ec_fan_table); i++)
+			if (ec->table.devid2itemnum[ec_fan_table[i].did] !=
+							EC_TABLE_ITEM_UNUSED)
+				ec_fan_table[i].visible = 1;
+	} else {
+		int fnum, ret;
+		u8 tmp, fscr;
+
+		for (fnum = 0; fnum < EC_MAX_IO_FAN; fnum++) {
+			spin_lock(&ec->lock);
+			ret = ec_io_read(EC_CMD_HWRAM_READ,
+					 EC_HWRAM_ADDR_FAN_CONTROL(fnum),
+					 &tmp, 1);
+			spin_unlock(&ec->lock);
+
+			if (ret != 0)
+				continue;
+
+			fscr = (tmp >> 4) & 0x03;
+
+			switch (fscr) {
+			case 1:	/* tacho0 */
+			case 2:	/* tacho1 */
+			case 3:	/* tacho2 */
+				i = fscr - 1;
+				break;
+			default:
+				continue;
+			}
+
+			if (ec_fan_table[i].visible == 1)
+				continue;
+
+			ec_fan_table[i].fspeed_acpireg =
+					EC_ACPIRAM_ADDR_FAN_SPEED_BASE(i);
+
+			ec_fan_table[i].visible = 1;
+		}
+	}
+}
+
+static ssize_t show_fan(struct device *dev, struct device_attribute *dev_attr,
+			char *buf)
+{
+	struct it85xx *ec = dev_get_drvdata(dev);
+	int i = to_sensor_dev_attr(dev_attr)->index;
+	u32 val;
+	int ret = ec_get_fan_speed(ec, i, &val);
+
+	if (ret != 0)
+		return (ssize_t)ret;
+
+	return sprintf(buf, "%u\n", val);
+}
+
+static ssize_t show_fan_label(struct device *dev,
+			      struct device_attribute *dev_attr, char *buf)
+{
+	int i = to_sensor_dev_attr(dev_attr)->index;
+	return sprintf(buf, "%s\n", ec_fan_table[i].name);
+}
+
+static SENSOR_DEVICE_ATTR(fan1_input, S_IRUGO, show_fan, NULL, 0);
+static SENSOR_DEVICE_ATTR(fan2_input, S_IRUGO, show_fan, NULL, 1);
+static SENSOR_DEVICE_ATTR(fan3_input, S_IRUGO, show_fan, NULL, 2);
+
+static SENSOR_DEVICE_ATTR(fan1_label, S_IRUGO, show_fan_label, NULL, 0);
+static SENSOR_DEVICE_ATTR(fan2_label, S_IRUGO, show_fan_label, NULL, 1);
+static SENSOR_DEVICE_ATTR(fan3_label, S_IRUGO, show_fan_label, NULL, 2);
+
+static struct attribute *it85xx_fan_attrs[] = {
+	&sensor_dev_attr_fan1_label.dev_attr.attr,
+	&sensor_dev_attr_fan1_input.dev_attr.attr,
+
+	&sensor_dev_attr_fan2_label.dev_attr.attr,
+	&sensor_dev_attr_fan2_input.dev_attr.attr,
+
+	&sensor_dev_attr_fan3_label.dev_attr.attr,
+	&sensor_dev_attr_fan3_input.dev_attr.attr,
+
+	NULL
+};
+
+static umode_t it85xx_fan_mode(struct kobject *kobj, struct attribute *attr,
+			       int index)
+{
+	struct sensor_device_attribute *sensor = container_of(
+			attr, struct sensor_device_attribute, dev_attr.attr);
+
+	if (ec_fan_table[sensor->index].visible == 0)
+		return 0;
+
+	return attr->mode;
+}
+
+static const struct attribute_group it85xx_fan_group = {
+	.attrs = it85xx_fan_attrs,
+	.is_visible = it85xx_fan_mode,
+};
+
+/* HWM groups */
+static const struct attribute_group *it85xx_hwmon_groups[] = {
+	&it85xx_volt_group,
+	&it85xx_curr_group,
+	&it85xx_temp_group,
+	&it85xx_fan_group,
+
+	NULL
+};
+
+/* Module */
+static int it85xx_hwmon_probe(struct platform_device *pdev)
+{
+	struct device *dev = &pdev->dev;
+	struct it85xx *hwmon_ec;
+	struct device *hwmon_dev;
+
+	hwmon_ec = devm_kzalloc(dev, sizeof(struct it85xx), GFP_KERNEL);
+
+	if (hwmon_ec == NULL)
+		return -ENOMEM;
+
+	platform_set_drvdata(pdev, hwmon_ec);
+
+	hwmon_ec = dev->parent->platform_data;
+
+	ec_volt_init_once(hwmon_ec, 0);
+	ec_temp_init_once(hwmon_ec);
+	ec_current_init_once(hwmon_ec);
+	ec_fan_init_once(hwmon_ec);
+
+	hwmon_dev = devm_hwmon_device_register_with_groups(dev, CHIP_NAME,
+							   hwmon_ec,
+							   it85xx_hwmon_groups);
+
+	if (IS_ERR(hwmon_dev) != 0) {
+		pr_err("Could not register it85xx hwmon device\n");
+		return PTR_ERR(hwmon_dev);
+	}
+
+	pr_info("HWM driver v%s loaded\n", DRV_VERSION);
+
+	return 0;
+}
+
+static int it85xx_hwmon_remove(struct platform_device *pdev)
+{
+	pr_info("HWM driver removed\n");
+
+	return 0;
+}
+
+static struct platform_driver it85xx_hwmon_driver = {
+	.probe = it85xx_hwmon_probe,
+	.remove = it85xx_hwmon_remove,
+	.driver = {
+		.owner = THIS_MODULE,
+		.name  = DRV_NAME,
+	},
+};
+
+module_platform_driver(it85xx_hwmon_driver);
+
+MODULE_AUTHOR("Richard Vidal-Dorsch <richard.dorsch at advantech.com>");
+MODULE_DESCRIPTION("HW Monitoring interface for Advantech EC IT8516/18/28");
+MODULE_LICENSE("GPL");
+MODULE_VERSION(DRV_VERSION);
diff --git a/drivers/hwmon/imanager2_hwm.h b/drivers/hwmon/imanager2_hwm.h
new file mode 100755
index 0000000..ccf4a4c
--- /dev/null
+++ b/drivers/hwmon/imanager2_hwm.h
@@ -0,0 +1,118 @@
+/* imanager2_hwm.h - HW Monitoring interface for Advantech EC IT8516/18/28
+ * Copyright (C) 2014  Richard Vidal-Dorsch <richard.dorsch@advantech.com>
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 3 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+
+#ifndef __IMANAGER2_HWM_H__
+#define __IMANAGER2_HWM_H__
+
+/* ADC */
+#define EC_ADC_RESOLUTION_MAX		0x03FF	/* 10-bit */
+#define EC_ADC_VOLTAGE_VALUE_MAX	3000	/* max: 3.0 V */
+#define EC_ADC_CURRENT_VALUE_MAX	3000	/* max: 3.0 A */
+
+struct volt_item {
+	u8 did;
+	const char *name;
+	int factor;
+	int visible;
+};
+
+struct curr_item {
+	const u8 did;
+	const char *name;
+	int visible;
+};
+
+static struct volt_item ec_volt_table[] = {
+	{.did = adcmosbat, .name = "BAT CMOS", .factor = 0, .visible = 0},
+	{.did = adcbat, .name = "BAT", .factor = 0, .visible = 0},
+	{.did = adc5vs0, .name = "5V S0", .factor = 0, .visible = 0},
+	{.did = adv5vs5, .name = "5V S5", .factor = 0, .visible = 0},
+	{.did = adc33vs0, .name = "3V3 S0", .factor = 0, .visible = 0},
+	{.did = adc33vs5, .name = "3V3 S5", .factor = 0, .visible = 0},
+	{.did = adv12vs0, .name = "12V S0", .factor = 0, .visible = 0},
+	{.did = adcvcorea, .name = "Vcore A", .factor = 0, .visible = 0},
+	{.did = adcvcoreb, .name = "Vcore B", .factor = 0, .visible = 0},
+	{.did = adcdc, .name = "DC", .factor = 0, .visible = 0},
+	{.did = adcdcstby, .name = "DC Standby", .factor = 0, .visible = 0},
+	{.did = adcdcother, .name = "DC Other", .factor = 0, .visible = 0}
+};
+
+static struct curr_item ec_curr_table[] = {
+	{.did = adccurrent, .name = "IMON", .visible = 0}
+};
+
+/* Thermal */
+#define EC_MAX_THERMAL_ZONE	4
+
+#define EC_THERMAL_TYPE_NONE	0
+#define EC_THERMAL_TYPE_SYS1	1
+#define EC_THERMAL_TYPE_CPU	2
+#define EC_THERMAL_TYPE_SYS3	3
+#define EC_THERMAL_TYPE_SYS2	4
+
+struct temp_item {
+	const char *name;
+	const u8 zonetype_value;
+	u8 zonetype_acpireg;
+	int visible;
+};
+
+static struct temp_item ec_temp_table[] = {
+	{.name = "Temp SYS",
+	 .zonetype_value = EC_THERMAL_TYPE_SYS1,
+	 .zonetype_acpireg = EC_ACPIRAM_ADDR_LOCAL_TEMPERATURE(1),
+	 .visible = 0},
+	{.name = "Temp CPU",
+	 .zonetype_value = EC_THERMAL_TYPE_CPU,
+	 .zonetype_acpireg = EC_ACPIRAM_ADDR_REMOTE_TEMPERATURE(1),
+	 .visible = 0},
+	{.name = "Temp SYS3",
+	 .zonetype_value = EC_THERMAL_TYPE_SYS3,
+	 .zonetype_acpireg = EC_ACPIRAM_ADDR_LOCAL_TEMPERATURE(2),
+	 .visible = 0},
+	{.name = "Temp SYS2",
+	 .zonetype_value = EC_THERMAL_TYPE_SYS2,
+	 .zonetype_acpireg = EC_ACPIRAM_ADDR_REMOTE_TEMPERATURE(2),
+	 .visible = 0},
+};
+
+struct ec_thermalzone {
+	u8 channel,
+	   addr,
+	   cmd,
+	   status,
+	   fancode,
+	   temp;
+};
+
+/* Tacho */
+#define EC_MAX_IO_FAN	3
+
+struct fan_item {
+	const u8 did;
+	const char *name;
+	u8 fspeed_acpireg;
+	int visible;
+};
+
+static struct fan_item ec_fan_table[] = {
+	{.did = tacho0, .name = "Fan CPU", .fspeed_acpireg = 0, .visible = 0},
+	{.did = tacho1, .name = "Fan SYS", .fspeed_acpireg = 0, .visible = 0},
+	{.did = tacho2, .name = "Fan SYS2", .fspeed_acpireg = 0, .visible = 0},
+};
+
+#endif /* __IMANAGER2_HWM_H__ */
-- 
1.9.1

