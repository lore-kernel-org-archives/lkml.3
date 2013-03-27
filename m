Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662Ab3C0HSC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 03:18:02 -0400
Received: from mail-da0-f43.google.com ([209.85.210.43]:43502 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751756Ab3C0HR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 03:17:59 -0400
From: Hongbo Zhang <hongbo.zhang@linaro.org>
To: linux@roeck-us.net, khali@linux-fr.org, lm-sensors@lm-sensors.org,
        cbou@mail.ru, dwmw2@infradead.org
Cc: linaro-kernel@lists.linaro.org, STEricsson_nomadik_linux@list.st.com,
        linus.walleij@linaro.org, lee.jones@linaro.org,
        linux-kernel@vger.kernel.org, Hongbo Zhang <hongbo.zhang@linaro.org>
Subject: [PATCH v7 5/5] hwmon: add ST-Ericsson ABX500 hwmon driver
Date: Wed, 27 Mar 2013 15:13:32 +0800
Message-Id: <1364368412-12810-6-git-send-email-hongbo.zhang@linaro.org>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1364368412-12810-1-git-send-email-hongbo.zhang@linaro.org>
References: <1364368412-12810-1-git-send-email-hongbo.zhang@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Each of ST-Ericsson X500 chip set series consists of both ABX500 and DBX500
chips. This is ABX500 hwmon driver, where the abx500.c is a common layer for
all ABX500s, and the ab8500.c is specific for AB8500 chip. Under this designed
structure, other chip specific files can be added simply using the same common
layer abx500.c.

Signed-off-by: Hongbo Zhang <hongbo.zhang@linaro.org>
---
 Documentation/hwmon/ab8500 |  22 ++
 Documentation/hwmon/abx500 |  28 +++
 drivers/hwmon/Kconfig      |  13 ++
 drivers/hwmon/Makefile     |   1 +
 drivers/hwmon/ab8500.c     | 206 +++++++++++++++++++
 drivers/hwmon/abx500.c     | 491 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/hwmon/abx500.h     |  69 +++++++
 7 files changed, 830 insertions(+)
 create mode 100644 Documentation/hwmon/ab8500
 create mode 100644 Documentation/hwmon/abx500
 create mode 100644 drivers/hwmon/ab8500.c
 create mode 100644 drivers/hwmon/abx500.c
 create mode 100644 drivers/hwmon/abx500.h

diff --git a/Documentation/hwmon/ab8500 b/Documentation/hwmon/ab8500
new file mode 100644
index 0000000..cf169c8
--- /dev/null
+++ b/Documentation/hwmon/ab8500
@@ -0,0 +1,22 @@
+Kernel driver ab8500
+====================
+
+Supported chips:
+  * ST-Ericsson AB8500
+    Prefix: 'ab8500'
+    Addresses scanned: -
+    Datasheet: http://www.stericsson.com/developers/documentation.jsp
+
+Authors:
+        Martin Persson <martin.persson@stericsson.com>
+        Hongbo Zhang <hongbo.zhang@linaro.org>
+
+Description
+-----------
+
+See also Documentation/hwmon/abx500. This is the ST-Ericsson AB8500 specific
+driver.
+
+Currently only the AB8500 internal sensor and one external sensor for battery
+temperature are monitored. Other GPADC channels can also be monitored if needed
+in future.
diff --git a/Documentation/hwmon/abx500 b/Documentation/hwmon/abx500
new file mode 100644
index 0000000..319a058
--- /dev/null
+++ b/Documentation/hwmon/abx500
@@ -0,0 +1,28 @@
+Kernel driver abx500
+====================
+
+Supported chips:
+  * ST-Ericsson ABx500 series
+    Prefix: 'abx500'
+    Addresses scanned: -
+    Datasheet: http://www.stericsson.com/developers/documentation.jsp
+
+Authors:
+        Martin Persson <martin.persson@stericsson.com>
+        Hongbo Zhang <hongbo.zhang@linaro.org>
+
+Description
+-----------
+
+Every ST-Ericsson Ux500 SOC consists of both ABx500 and DBx500 physically,
+this is kernel hwmon driver for ABx500.
+
+There are some GPADCs inside ABx500 which are designed for connecting to
+thermal sensors, and there is also a thermal sensor inside ABx500 too, which
+raises interrupt when critical temperature reached.
+
+This abx500 is a common layer which can monitor all of the sensors, every
+specific abx500 chip has its special configurations in its own file, e.g. some
+sensors can be configured invisible if they are not available on that chip, and
+the corresponding gpadc_addr should be set to 0, thus this sensor won't be
+polled.
diff --git a/drivers/hwmon/Kconfig b/drivers/hwmon/Kconfig
index 32f238f..d0d6b52 100644
--- a/drivers/hwmon/Kconfig
+++ b/drivers/hwmon/Kconfig
@@ -39,6 +39,19 @@ config HWMON_DEBUG_CHIP
 
 comment "Native drivers"
 
+config SENSORS_AB8500
+	tristate "AB8500 thermal monitoring"
+	depends on AB8500_GPADC && AB8500_BM
+	default n
+	help
+	  If you say yes here you get support for the thermal sensor part
+	  of the AB8500 chip. The driver includes thermal management for
+	  AB8500 die and two GPADC channels. The GPADC channel are preferably
+	  used to access sensors outside the AB8500 chip.
+
+	  This driver can also be built as a module.  If so, the module
+	  will be called abx500-temp.
+
 config SENSORS_ABITUGURU
 	tristate "Abit uGuru (rev 1 & 2)"
 	depends on X86 && DMI
diff --git a/drivers/hwmon/Makefile b/drivers/hwmon/Makefile
index 5da2874..06dfe85 100644
--- a/drivers/hwmon/Makefile
+++ b/drivers/hwmon/Makefile
@@ -19,6 +19,7 @@ obj-$(CONFIG_SENSORS_W83795)	+= w83795.o
 obj-$(CONFIG_SENSORS_W83781D)	+= w83781d.o
 obj-$(CONFIG_SENSORS_W83791D)	+= w83791d.o
 
+obj-$(CONFIG_SENSORS_AB8500)	+= abx500.o ab8500.o
 obj-$(CONFIG_SENSORS_ABITUGURU)	+= abituguru.o
 obj-$(CONFIG_SENSORS_ABITUGURU3)+= abituguru3.o
 obj-$(CONFIG_SENSORS_AD7314)	+= ad7314.o
diff --git a/drivers/hwmon/ab8500.c b/drivers/hwmon/ab8500.c
new file mode 100644
index 0000000..ee0aa3e
--- /dev/null
+++ b/drivers/hwmon/ab8500.c
@@ -0,0 +1,206 @@
+/*
+ * Copyright (C) ST-Ericsson 2010 - 2013
+ * Author: Martin Persson <martin.persson@stericsson.com>
+ *         Hongbo Zhang <hongbo.zhang@linaro.org>
+ * License Terms: GNU General Public License v2
+ *
+ * When the AB8500 thermal warning temperature is reached (threshold cannot
+ * be changed by SW), an interrupt is set, and if no further action is taken
+ * within a certain time frame, pm_power off will be called.
+ *
+ * When AB8500 thermal shutdown temperature is reached a hardware shutdown of
+ * the AB8500 will occur.
+ */
+
+#include <linux/err.h>
+#include <linux/hwmon.h>
+#include <linux/hwmon-sysfs.h>
+#include <linux/mfd/abx500.h>
+#include <linux/mfd/abx500/ab8500-bm.h>
+#include <linux/mfd/abx500/ab8500-gpadc.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/power/ab8500.h>
+#include <linux/slab.h>
+#include <linux/sysfs.h>
+#include "abx500.h"
+
+#define DEFAULT_POWER_OFF_DELAY	(HZ * 10)
+#define THERMAL_VCC		1800
+#define PULL_UP_RESISTOR	47000
+/* Number of monitored sensors should not greater than NUM_SENSORS */
+#define NUM_MONITORED_SENSORS	4
+
+struct ab8500_gpadc_cfg {
+	const struct abx500_res_to_temp *temp_tbl;
+	int tbl_sz;
+	int vcc;
+	int r_up;
+};
+
+struct ab8500_temp {
+	struct ab8500_gpadc *gpadc;
+	struct ab8500_btemp *btemp;
+	struct delayed_work power_off_work;
+	struct ab8500_gpadc_cfg cfg;
+	struct abx500_temp *abx500_data;
+};
+
+/*
+ * The hardware connection is like this:
+ * VCC----[ R_up ]-----[ NTC ]----GND
+ * where R_up is pull-up resistance, and GPADC measures voltage on NTC.
+ * and res_to_temp table is strictly sorted by falling resistance values.
+ */
+static int ab8500_voltage_to_temp(struct ab8500_gpadc_cfg *cfg,
+		int v_ntc, int *temp)
+{
+	int r_ntc, i = 0, tbl_sz = cfg->tbl_sz;
+	const struct abx500_res_to_temp *tbl = cfg->temp_tbl;
+
+	if (cfg->vcc < 0 || v_ntc >= cfg->vcc)
+		return -EINVAL;
+
+	r_ntc = v_ntc * cfg->r_up / (cfg->vcc - v_ntc);
+	if (r_ntc > tbl[0].resist || r_ntc < tbl[tbl_sz - 1].resist)
+		return -EINVAL;
+
+	while (!(r_ntc <= tbl[i].resist && r_ntc > tbl[i + 1].resist)
+		&& i < tbl_sz - 2)
+		i++;
+
+	/* return milli-Celsius */
+	*temp = tbl[i].temp * 1000 + ((tbl[i + 1].temp - tbl[i].temp) * 1000 *
+		(r_ntc - tbl[i].resist)) / (tbl[i + 1].resist - tbl[i].resist);
+
+	return 0;
+}
+
+static int ab8500_read_sensor(struct abx500_temp *data, u8 sensor, int *temp)
+{
+	int voltage, ret;
+	struct ab8500_temp *ab8500_data = data->plat_data;
+
+	if (sensor == BAT_CTRL) {
+		*temp = ab8500_btemp_get_batctrl_temp(ab8500_data->btemp);
+	} else if (sensor == BTEMP_BALL) {
+		*temp = ab8500_btemp_get_temp(ab8500_data->btemp);
+	} else {
+		voltage = ab8500_gpadc_convert(ab8500_data->gpadc, sensor);
+		if (voltage < 0)
+			return voltage;
+
+		ret = ab8500_voltage_to_temp(&ab8500_data->cfg, voltage, temp);
+		if (ret < 0)
+			return ret;
+	}
+
+	return 0;
+}
+
+static void ab8500_thermal_power_off(struct work_struct *work)
+{
+	struct ab8500_temp *ab8500_data = container_of(work,
+				struct ab8500_temp, power_off_work.work);
+	struct abx500_temp *abx500_data = ab8500_data->abx500_data;
+
+	dev_warn(&abx500_data->pdev->dev, "Power off due to critical temp\n");
+
+	pm_power_off();
+}
+
+static ssize_t ab8500_show_name(struct device *dev,
+		struct device_attribute *devattr, char *buf)
+{
+	return sprintf(buf, "ab8500\n");
+}
+
+static ssize_t ab8500_show_label(struct device *dev,
+		struct device_attribute *devattr, char *buf)
+{
+	char *label;
+	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
+	int index = attr->index;
+
+	switch (index) {
+	case 1:
+		label = "ext_adc1";
+		break;
+	case 2:
+		label = "ext_adc2";
+		break;
+	case 3:
+		label = "bat_temp";
+		break;
+	case 4:
+		label = "bat_ctrl";
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return sprintf(buf, "%s\n", label);
+}
+
+static int ab8500_temp_irq_handler(int irq, struct abx500_temp *data)
+{
+	struct ab8500_temp *ab8500_data = data->plat_data;
+
+	dev_warn(&data->pdev->dev, "Power off in %d s\n",
+		DEFAULT_POWER_OFF_DELAY / HZ);
+
+	schedule_delayed_work(&ab8500_data->power_off_work,
+		DEFAULT_POWER_OFF_DELAY);
+	return 0;
+}
+
+int abx500_hwmon_init(struct abx500_temp *data)
+{
+	struct ab8500_temp *ab8500_data;
+
+	ab8500_data = devm_kzalloc(&data->pdev->dev, sizeof(*ab8500_data),
+		GFP_KERNEL);
+	if (!ab8500_data)
+		return -ENOMEM;
+
+	ab8500_data->gpadc = ab8500_gpadc_get("ab8500-gpadc.0");
+	if (IS_ERR(ab8500_data->gpadc))
+		return PTR_ERR(ab8500_data->gpadc);
+
+	ab8500_data->btemp = ab8500_btemp_get();
+	if (IS_ERR(ab8500_data->btemp))
+		return PTR_ERR(ab8500_data->btemp);
+
+	INIT_DELAYED_WORK(&ab8500_data->power_off_work,
+		ab8500_thermal_power_off);
+
+	ab8500_data->cfg.vcc = THERMAL_VCC;
+	ab8500_data->cfg.r_up = PULL_UP_RESISTOR;
+	ab8500_data->cfg.temp_tbl = ab8500_temp_tbl_a_thermistor;
+	ab8500_data->cfg.tbl_sz = ab8500_temp_tbl_a_size;
+
+	data->plat_data = ab8500_data;
+
+	/*
+	 * ADC_AUX1 and ADC_AUX2, connected to external NTC
+	 * BTEMP_BALL and BAT_CTRL, fixed usage
+	 */
+	data->gpadc_addr[0] = ADC_AUX1;
+	data->gpadc_addr[1] = ADC_AUX2;
+	data->gpadc_addr[2] = BTEMP_BALL;
+	data->gpadc_addr[3] = BAT_CTRL;
+	data->monitored_sensors = NUM_MONITORED_SENSORS;
+
+	data->ops.read_sensor = ab8500_read_sensor;
+	data->ops.irq_handler = ab8500_temp_irq_handler;
+	data->ops.show_name = ab8500_show_name;
+	data->ops.show_label = ab8500_show_label;
+	data->ops.is_visible = NULL;
+
+	return 0;
+}
+EXPORT_SYMBOL(abx500_hwmon_init);
+
+MODULE_AUTHOR("Hongbo Zhang <hongbo.zhang@linaro.org>");
+MODULE_DESCRIPTION("AB8500 temperature driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/hwmon/abx500.c b/drivers/hwmon/abx500.c
new file mode 100644
index 0000000..491860a
--- /dev/null
+++ b/drivers/hwmon/abx500.c
@@ -0,0 +1,491 @@
+/*
+ * Copyright (C) ST-Ericsson 2010 - 2013
+ * Author: Martin Persson <martin.persson@stericsson.com>
+ *         Hongbo Zhang <hongbo.zhang@linaro.org>
+ * License Terms: GNU General Public License v2
+ *
+ * ABX500 does not provide auto ADC, so to monitor the required temperatures,
+ * a periodic work is used. It is more important to not wake up the CPU than
+ * to perform this job, hence the use of a deferred delay.
+ *
+ * A deferred delay for thermal monitor is considered safe because:
+ * If the chip gets too hot during a sleep state it's most likely due to
+ * external factors, such as the surrounding temperature. I.e. no SW decisions
+ * will make any difference.
+ */
+
+#include <linux/err.h>
+#include <linux/hwmon.h>
+#include <linux/hwmon-sysfs.h>
+#include <linux/interrupt.h>
+#include <linux/jiffies.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
+#include <linux/of.h>
+#include <linux/platform_device.h>
+#include <linux/pm.h>
+#include <linux/slab.h>
+#include <linux/sysfs.h>
+#include <linux/workqueue.h>
+#include "abx500.h"
+
+#define DEFAULT_MONITOR_DELAY	HZ
+#define DEFAULT_MAX_TEMP	130
+
+static inline void schedule_monitor(struct abx500_temp *data)
+{
+	data->work_active = true;
+	schedule_delayed_work(&data->work, DEFAULT_MONITOR_DELAY);
+}
+
+static void threshold_updated(struct abx500_temp *data)
+{
+	int i;
+	for (i = 0; i < data->monitored_sensors; i++)
+		if (data->max[i] != 0 || data->min[i] != 0) {
+			schedule_monitor(data);
+			return;
+		}
+
+	dev_dbg(&data->pdev->dev, "No active thresholds.\n");
+	cancel_delayed_work_sync(&data->work);
+	data->work_active = false;
+}
+
+static void gpadc_monitor(struct work_struct *work)
+{
+	int temp, i, ret;
+	char alarm_node[30];
+	bool updated_min_alarm, updated_max_alarm;
+	struct abx500_temp *data;
+
+	data = container_of(work, struct abx500_temp, work.work);
+	mutex_lock(&data->lock);
+
+	for (i = 0; i < data->monitored_sensors; i++) {
+		/* Thresholds are considered inactive if set to 0 */
+		if (data->max[i] == 0 && data->min[i] == 0)
+			continue;
+
+		if (data->max[i] < data->min[i])
+			continue;
+
+		ret = data->ops.read_sensor(data, data->gpadc_addr[i], &temp);
+		if (ret < 0) {
+			dev_err(&data->pdev->dev, "GPADC read failed\n");
+			continue;
+		}
+
+		updated_min_alarm = false;
+		updated_max_alarm = false;
+
+		if (data->min[i] != 0) {
+			if (temp < data->min[i]) {
+				if (data->min_alarm[i] == false) {
+					data->min_alarm[i] = true;
+					updated_min_alarm = true;
+				}
+			} else {
+				if (data->min_alarm[i] == true) {
+					data->min_alarm[i] = false;
+					updated_min_alarm = true;
+				}
+			}
+		}
+		if (data->max[i] != 0) {
+			if (temp > data->max[i]) {
+				if (data->max_alarm[i] == false) {
+					data->max_alarm[i] = true;
+					updated_max_alarm = true;
+				}
+			} else if (temp < data->max[i] - data->max_hyst[i]) {
+				if (data->max_alarm[i] == true) {
+					data->max_alarm[i] = false;
+					updated_max_alarm = true;
+				}
+			}
+		}
+
+		if (updated_min_alarm) {
+			ret = sprintf(alarm_node, "temp%d_min_alarm", i + 1);
+			sysfs_notify(&data->pdev->dev.kobj, NULL, alarm_node);
+		}
+		if (updated_max_alarm) {
+			ret = sprintf(alarm_node, "temp%d_max_alarm", i + 1);
+			sysfs_notify(&data->pdev->dev.kobj, NULL, alarm_node);
+		}
+	}
+
+	schedule_monitor(data);
+	mutex_unlock(&data->lock);
+}
+
+/* HWMON sysfs interfaces */
+static ssize_t show_name(struct device *dev, struct device_attribute *devattr,
+			 char *buf)
+{
+	struct abx500_temp *data = dev_get_drvdata(dev);
+	/* Show chip name */
+	return data->ops.show_name(dev, devattr, buf);
+}
+
+static ssize_t show_label(struct device *dev,
+			  struct device_attribute *devattr, char *buf)
+{
+	struct abx500_temp *data = dev_get_drvdata(dev);
+	/* Show each sensor label */
+	return data->ops.show_label(dev, devattr, buf);
+}
+
+static ssize_t show_input(struct device *dev,
+			  struct device_attribute *devattr, char *buf)
+{
+	int ret, temp;
+	struct abx500_temp *data = dev_get_drvdata(dev);
+	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
+	u8 gpadc_addr = data->gpadc_addr[attr->index];
+
+	ret = data->ops.read_sensor(data, gpadc_addr, &temp);
+	if (ret < 0)
+		return ret;
+
+	return sprintf(buf, "%d\n", temp);
+}
+
+/* Set functions (RW nodes) */
+static ssize_t set_min(struct device *dev, struct device_attribute *devattr,
+		       const char *buf, size_t count)
+{
+	unsigned long val;
+	struct abx500_temp *data = dev_get_drvdata(dev);
+	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
+	int res = kstrtol(buf, 10, &val);
+	if (res < 0)
+		return res;
+
+	val = clamp_val(val, 0, DEFAULT_MAX_TEMP);
+
+	mutex_lock(&data->lock);
+	data->min[attr->index] = val;
+	threshold_updated(data);
+	mutex_unlock(&data->lock);
+
+	return count;
+}
+
+static ssize_t set_max(struct device *dev, struct device_attribute *devattr,
+		       const char *buf, size_t count)
+{
+	unsigned long val;
+	struct abx500_temp *data = dev_get_drvdata(dev);
+	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
+	int res = kstrtol(buf, 10, &val);
+	if (res < 0)
+		return res;
+
+	val = clamp_val(val, 0, DEFAULT_MAX_TEMP);
+
+	mutex_lock(&data->lock);
+	data->max[attr->index] = val;
+	threshold_updated(data);
+	mutex_unlock(&data->lock);
+
+	return count;
+}
+
+static ssize_t set_max_hyst(struct device *dev,
+			    struct device_attribute *devattr,
+			    const char *buf, size_t count)
+{
+	unsigned long val;
+	struct abx500_temp *data = dev_get_drvdata(dev);
+	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
+	int res = kstrtoul(buf, 10, &val);
+	if (res < 0)
+		return res;
+
+	val = clamp_val(val, 0, DEFAULT_MAX_TEMP);
+
+	mutex_lock(&data->lock);
+	data->max_hyst[attr->index] = val;
+	threshold_updated(data);
+	mutex_unlock(&data->lock);
+
+	return count;
+}
+
+/* Show functions (RO nodes) */
+static ssize_t show_min(struct device *dev,
+			struct device_attribute *devattr, char *buf)
+{
+	struct abx500_temp *data = dev_get_drvdata(dev);
+	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
+
+	return sprintf(buf, "%ld\n", data->min[attr->index]);
+}
+
+static ssize_t show_max(struct device *dev,
+			struct device_attribute *devattr, char *buf)
+{
+	struct abx500_temp *data = dev_get_drvdata(dev);
+	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
+
+	return sprintf(buf, "%ld\n", data->max[attr->index]);
+}
+
+static ssize_t show_max_hyst(struct device *dev,
+			     struct device_attribute *devattr, char *buf)
+{
+	struct abx500_temp *data = dev_get_drvdata(dev);
+	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
+
+	return sprintf(buf, "%ld\n", data->max_hyst[attr->index]);
+}
+
+static ssize_t show_min_alarm(struct device *dev,
+			      struct device_attribute *devattr, char *buf)
+{
+	struct abx500_temp *data = dev_get_drvdata(dev);
+	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
+
+	return sprintf(buf, "%d\n", data->min_alarm[attr->index]);
+}
+
+static ssize_t show_max_alarm(struct device *dev,
+			      struct device_attribute *devattr, char *buf)
+{
+	struct abx500_temp *data = dev_get_drvdata(dev);
+	struct sensor_device_attribute *attr = to_sensor_dev_attr(devattr);
+
+	return sprintf(buf, "%d\n", data->max_alarm[attr->index]);
+}
+
+static mode_t abx500_attrs_visible(struct kobject *kobj,
+				   struct attribute *attr, int n)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct abx500_temp *data = dev_get_drvdata(dev);
+
+	if (data->ops.is_visible)
+		return data->ops.is_visible(attr, n);
+
+	return attr->mode;
+}
+
+/* Chip name, required by hwmon */
+static SENSOR_DEVICE_ATTR(name, S_IRUGO, show_name, NULL, 0);
+
+/* GPADC - SENSOR1 */
+static SENSOR_DEVICE_ATTR(temp1_label, S_IRUGO, show_label, NULL, 0);
+static SENSOR_DEVICE_ATTR(temp1_input, S_IRUGO, show_input, NULL, 0);
+static SENSOR_DEVICE_ATTR(temp1_min, S_IWUSR | S_IRUGO, show_min, set_min, 0);
+static SENSOR_DEVICE_ATTR(temp1_max, S_IWUSR | S_IRUGO, show_max, set_max, 0);
+static SENSOR_DEVICE_ATTR(temp1_max_hyst, S_IWUSR | S_IRUGO,
+			  show_max_hyst, set_max_hyst, 0);
+static SENSOR_DEVICE_ATTR(temp1_min_alarm, S_IRUGO, show_min_alarm, NULL, 0);
+static SENSOR_DEVICE_ATTR(temp1_max_alarm, S_IRUGO, show_max_alarm, NULL, 0);
+
+/* GPADC - SENSOR2 */
+static SENSOR_DEVICE_ATTR(temp2_label, S_IRUGO, show_label, NULL, 1);
+static SENSOR_DEVICE_ATTR(temp2_input, S_IRUGO, show_input, NULL, 1);
+static SENSOR_DEVICE_ATTR(temp2_min, S_IWUSR | S_IRUGO, show_min, set_min, 1);
+static SENSOR_DEVICE_ATTR(temp2_max, S_IWUSR | S_IRUGO, show_max, set_max, 1);
+static SENSOR_DEVICE_ATTR(temp2_max_hyst, S_IWUSR | S_IRUGO,
+			  show_max_hyst, set_max_hyst, 1);
+static SENSOR_DEVICE_ATTR(temp2_min_alarm, S_IRUGO, show_min_alarm, NULL, 1);
+static SENSOR_DEVICE_ATTR(temp2_max_alarm, S_IRUGO, show_max_alarm, NULL, 1);
+
+/* GPADC - SENSOR3 */
+static SENSOR_DEVICE_ATTR(temp3_label, S_IRUGO, show_label, NULL, 2);
+static SENSOR_DEVICE_ATTR(temp3_input, S_IRUGO, show_input, NULL, 2);
+static SENSOR_DEVICE_ATTR(temp3_min, S_IWUSR | S_IRUGO, show_min, set_min, 2);
+static SENSOR_DEVICE_ATTR(temp3_max, S_IWUSR | S_IRUGO, show_max, set_max, 2);
+static SENSOR_DEVICE_ATTR(temp3_max_hyst, S_IWUSR | S_IRUGO,
+			  show_max_hyst, set_max_hyst, 2);
+static SENSOR_DEVICE_ATTR(temp3_min_alarm, S_IRUGO, show_min_alarm, NULL, 2);
+static SENSOR_DEVICE_ATTR(temp3_max_alarm, S_IRUGO, show_max_alarm, NULL, 2);
+
+/* GPADC - SENSOR4 */
+static SENSOR_DEVICE_ATTR(temp4_label, S_IRUGO, show_label, NULL, 3);
+static SENSOR_DEVICE_ATTR(temp4_input, S_IRUGO, show_input, NULL, 3);
+static SENSOR_DEVICE_ATTR(temp4_min, S_IWUSR | S_IRUGO, show_min, set_min, 3);
+static SENSOR_DEVICE_ATTR(temp4_max, S_IWUSR | S_IRUGO, show_max, set_max, 3);
+static SENSOR_DEVICE_ATTR(temp4_max_hyst, S_IWUSR | S_IRUGO,
+			  show_max_hyst, set_max_hyst, 3);
+static SENSOR_DEVICE_ATTR(temp4_min_alarm, S_IRUGO, show_min_alarm, NULL, 3);
+static SENSOR_DEVICE_ATTR(temp4_max_alarm, S_IRUGO, show_max_alarm, NULL, 3);
+
+struct attribute *abx500_temp_attributes[] = {
+	&sensor_dev_attr_name.dev_attr.attr,
+
+	&sensor_dev_attr_temp1_label.dev_attr.attr,
+	&sensor_dev_attr_temp1_input.dev_attr.attr,
+	&sensor_dev_attr_temp1_min.dev_attr.attr,
+	&sensor_dev_attr_temp1_max.dev_attr.attr,
+	&sensor_dev_attr_temp1_max_hyst.dev_attr.attr,
+	&sensor_dev_attr_temp1_min_alarm.dev_attr.attr,
+	&sensor_dev_attr_temp1_max_alarm.dev_attr.attr,
+
+	&sensor_dev_attr_temp2_label.dev_attr.attr,
+	&sensor_dev_attr_temp2_input.dev_attr.attr,
+	&sensor_dev_attr_temp2_min.dev_attr.attr,
+	&sensor_dev_attr_temp2_max.dev_attr.attr,
+	&sensor_dev_attr_temp2_max_hyst.dev_attr.attr,
+	&sensor_dev_attr_temp2_min_alarm.dev_attr.attr,
+	&sensor_dev_attr_temp2_max_alarm.dev_attr.attr,
+
+	&sensor_dev_attr_temp3_label.dev_attr.attr,
+	&sensor_dev_attr_temp3_input.dev_attr.attr,
+	&sensor_dev_attr_temp3_min.dev_attr.attr,
+	&sensor_dev_attr_temp3_max.dev_attr.attr,
+	&sensor_dev_attr_temp3_max_hyst.dev_attr.attr,
+	&sensor_dev_attr_temp3_min_alarm.dev_attr.attr,
+	&sensor_dev_attr_temp3_max_alarm.dev_attr.attr,
+
+	&sensor_dev_attr_temp4_label.dev_attr.attr,
+	&sensor_dev_attr_temp4_input.dev_attr.attr,
+	&sensor_dev_attr_temp4_min.dev_attr.attr,
+	&sensor_dev_attr_temp4_max.dev_attr.attr,
+	&sensor_dev_attr_temp4_max_hyst.dev_attr.attr,
+	&sensor_dev_attr_temp4_min_alarm.dev_attr.attr,
+	&sensor_dev_attr_temp4_max_alarm.dev_attr.attr,
+	NULL
+};
+
+static const struct attribute_group abx500_temp_group = {
+	.attrs = abx500_temp_attributes,
+	.is_visible = abx500_attrs_visible,
+};
+
+static irqreturn_t abx500_temp_irq_handler(int irq, void *irq_data)
+{
+	struct platform_device *pdev = irq_data;
+	struct abx500_temp *data = platform_get_drvdata(pdev);
+
+	data->ops.irq_handler(irq, data);
+	return IRQ_HANDLED;
+}
+
+static int setup_irqs(struct platform_device *pdev)
+{
+	int ret;
+	int irq = platform_get_irq_byname(pdev, "ABX500_TEMP_WARM");
+
+	if (irq < 0) {
+		dev_err(&pdev->dev, "Get irq by name failed\n");
+		return irq;
+	}
+
+	ret = devm_request_threaded_irq(&pdev->dev, irq, NULL,
+		abx500_temp_irq_handler, IRQF_NO_SUSPEND, "abx500-temp", pdev);
+	if (ret < 0)
+		dev_err(&pdev->dev, "Request threaded irq failed (%d)\n", ret);
+
+	return ret;
+}
+
+static int abx500_temp_probe(struct platform_device *pdev)
+{
+	struct abx500_temp *data;
+	int err;
+
+	data = devm_kzalloc(&pdev->dev, sizeof(*data), GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	data->pdev = pdev;
+	mutex_init(&data->lock);
+
+	/* Chip specific initialization */
+	err = abx500_hwmon_init(data);
+	if (err	< 0 || !data->ops.read_sensor || !data->ops.show_name
+	    || !data->ops.show_label)
+		return err;
+
+	INIT_DEFERRABLE_WORK(&data->work, gpadc_monitor);
+
+	platform_set_drvdata(pdev, data);
+
+	err = sysfs_create_group(&pdev->dev.kobj, &abx500_temp_group);
+	if (err < 0) {
+		dev_err(&pdev->dev, "Create sysfs group failed (%d)\n", err);
+		return err;
+	}
+
+	data->hwmon_dev = hwmon_device_register(&pdev->dev);
+	if (IS_ERR(data->hwmon_dev)) {
+		err = PTR_ERR(data->hwmon_dev);
+		dev_err(&pdev->dev, "Class registration failed (%d)\n", err);
+		goto exit_sysfs_group;
+	}
+
+	if (data->ops.irq_handler) {
+		err = setup_irqs(pdev);
+		if (err < 0)
+			goto exit_hwmon_reg;
+	}
+	return 0;
+
+exit_hwmon_reg:
+	hwmon_device_unregister(data->hwmon_dev);
+exit_sysfs_group:
+	sysfs_remove_group(&pdev->dev.kobj, &abx500_temp_group);
+	return err;
+}
+
+static int abx500_temp_remove(struct platform_device *pdev)
+{
+	struct abx500_temp *data = platform_get_drvdata(pdev);
+
+	cancel_delayed_work_sync(&data->work);
+	hwmon_device_unregister(data->hwmon_dev);
+	sysfs_remove_group(&pdev->dev.kobj, &abx500_temp_group);
+
+	return 0;
+}
+
+static int abx500_temp_suspend(struct platform_device *pdev,
+			       pm_message_t state)
+{
+	struct abx500_temp *data = platform_get_drvdata(pdev);
+
+	if (data->work_active)
+		cancel_delayed_work_sync(&data->work);
+
+	return 0;
+}
+
+static int abx500_temp_resume(struct platform_device *pdev)
+{
+	struct abx500_temp *data = platform_get_drvdata(pdev);
+
+	if (data->work_active)
+		schedule_monitor(data);
+
+	return 0;
+}
+
+#ifdef CONFIG_OF
+static const struct of_device_id abx500_temp_match[] = {
+	{ .compatible = "stericsson,abx500-temp" },
+	{},
+};
+#endif
+
+static struct platform_driver abx500_temp_driver = {
+	.driver = {
+		.owner = THIS_MODULE,
+		.name = "abx500-temp",
+		.of_match_table = of_match_ptr(abx500_temp_match),
+	},
+	.suspend = abx500_temp_suspend,
+	.resume = abx500_temp_resume,
+	.probe = abx500_temp_probe,
+	.remove = abx500_temp_remove,
+};
+
+module_platform_driver(abx500_temp_driver);
+
+MODULE_AUTHOR("Martin Persson <martin.persson@stericsson.com>");
+MODULE_DESCRIPTION("ABX500 temperature driver");
+MODULE_LICENSE("GPL");
diff --git a/drivers/hwmon/abx500.h b/drivers/hwmon/abx500.h
new file mode 100644
index 0000000..9b295e6
--- /dev/null
+++ b/drivers/hwmon/abx500.h
@@ -0,0 +1,69 @@
+/*
+ * Copyright (C) ST-Ericsson 2010 - 2013
+ * License terms: GNU General Public License v2
+ * Author: Martin Persson <martin.persson@stericsson.com>
+ *         Hongbo Zhang <hongbo.zhang@linaro.com>
+ */
+
+#ifndef _ABX500_H
+#define _ABX500_H
+
+#define NUM_SENSORS 5
+
+struct abx500_temp;
+
+/*
+ * struct abx500_temp_ops - abx500 chip specific ops
+ * @read_sensor: reads gpadc output
+ * @irq_handler: irq handler
+ * @show_name: hwmon device name
+ * @show_label: hwmon attribute label
+ * @is_visible: is attribute visible
+ */
+struct abx500_temp_ops {
+	int (*read_sensor)(struct abx500_temp *, u8, int *);
+	int (*irq_handler)(int, struct abx500_temp *);
+	ssize_t (*show_name)(struct device *,
+			struct device_attribute *, char *);
+	ssize_t (*show_label) (struct device *,
+			struct device_attribute *, char *);
+	int (*is_visible)(struct attribute *, int);
+};
+
+/*
+ * struct abx500_temp - representation of temp mon device
+ * @pdev: platform device
+ * @hwmon_dev: hwmon device
+ * @ops: abx500 chip specific ops
+ * @gpadc_addr: gpadc channel address
+ * @min: sensor temperature min value
+ * @max: sensor temperature max value
+ * @max_hyst: sensor temperature hysteresis value for max limit
+ * @min_alarm: sensor temperature min alarm
+ * @max_alarm: sensor temperature max alarm
+ * @work: delayed work scheduled to monitor temperature periodically
+ * @work_active: True if work is active
+ * @lock: mutex
+ * @monitored_sensors: number of monitored sensors
+ * @plat_data: private usage, usually points to platform specific data
+ */
+struct abx500_temp {
+	struct platform_device *pdev;
+	struct device *hwmon_dev;
+	struct abx500_temp_ops ops;
+	u8 gpadc_addr[NUM_SENSORS];
+	unsigned long min[NUM_SENSORS];
+	unsigned long max[NUM_SENSORS];
+	unsigned long max_hyst[NUM_SENSORS];
+	bool min_alarm[NUM_SENSORS];
+	bool max_alarm[NUM_SENSORS];
+	struct delayed_work work;
+	bool work_active;
+	struct mutex lock;
+	int monitored_sensors;
+	void *plat_data;
+};
+
+int abx500_hwmon_init(struct abx500_temp *data);
+
+#endif /* _ABX500_H */
-- 
1.8.0

