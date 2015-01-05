Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118AbbAEOVj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 09:21:39 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:42981 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753326AbbAEOVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 09:21:17 -0500
From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        LM Sensors <lm-sensors@lm-sensors.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH v8 4/5] hwmon: ina2xx: make shunt resistance configurable at run-time
Date: Mon,  5 Jan 2015 15:20:55 +0100
Message-Id: <1420467656-6112-5-git-send-email-bgolaszewski@baylibre.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1420467656-6112-1-git-send-email-bgolaszewski@baylibre.com>
References: <1420467656-6112-1-git-send-email-bgolaszewski@baylibre.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The shunt resistance can only be set via platform_data or device tree. This
isn't suitable for devices in which the shunt resistance can change/isn't
known at boot-time.

Add a sysfs attribute that allows to read and set the shunt resistance.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 Documentation/hwmon/ina2xx |  5 +++--
 drivers/hwmon/ina2xx.c     | 48 ++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 49 insertions(+), 4 deletions(-)

diff --git a/Documentation/hwmon/ina2xx b/Documentation/hwmon/ina2xx
index 4223c2d..320dd69 100644
--- a/Documentation/hwmon/ina2xx
+++ b/Documentation/hwmon/ina2xx
@@ -44,6 +44,7 @@ The INA226 monitors both a shunt voltage drop and bus supply voltage.
 The INA230 is a high or low side current shunt and power monitor with an I2C
 interface. The INA230 monitors both a shunt voltage drop and bus supply voltage.
 
-The shunt value in micro-ohms can be set via platform data or device tree.
-Please refer to the Documentation/devicetree/bindings/i2c/ina2xx.txt for bindings
+The shunt value in micro-ohms can be set via platform data or device tree at
+compile-time or via the shunt_resistor attribute in sysfs at run-time. Please
+refer to the Documentation/devicetree/bindings/i2c/ina2xx.txt for bindings
 if the device tree is used.
diff --git a/drivers/hwmon/ina2xx.c b/drivers/hwmon/ina2xx.c
index 3234e57..49537ea 100644
--- a/drivers/hwmon/ina2xx.c
+++ b/drivers/hwmon/ina2xx.c
@@ -115,6 +115,12 @@ static const struct ina2xx_config ina2xx_config[] = {
 	},
 };
 
+static int ina2xx_calibrate(struct ina2xx_data *data)
+{
+	return i2c_smbus_write_word_swapped(data->client, INA2XX_CALIBRATION,
+			data->config->calibration_factor / data->rshunt);
+}
+
 /*
  * Initialize the configuration and calibration registers.
  */
@@ -133,8 +139,7 @@ static int ina2xx_init(struct ina2xx_data *data)
 	 * Set current LSB to 1mA, shunt is in uOhms
 	 * (equation 13 in datasheet).
 	 */
-	return i2c_smbus_write_word_swapped(client, INA2XX_CALIBRATION,
-			data->config->calibration_factor / data->rshunt);
+	return ina2xx_calibrate(data);
 }
 
 static int ina2xx_do_update(struct device *dev)
@@ -231,6 +236,9 @@ static int ina2xx_get_value(struct ina2xx_data *data, u8 reg)
 		/* signed register, LSB=1mA (selected), in mA */
 		val = (s16)data->regs[reg];
 		break;
+	case INA2XX_CALIBRATION:
+		val = data->config->calibration_factor / data->regs[reg];
+		break;
 	default:
 		/* programmer goofed */
 		WARN_ON_ONCE(1);
@@ -254,6 +262,36 @@ static ssize_t ina2xx_show_value(struct device *dev,
 			ina2xx_get_value(data, attr->index));
 }
 
+static ssize_t ina2xx_set_shunt(struct device *dev,
+				struct device_attribute *da,
+				const char *buf, size_t count)
+{
+	struct ina2xx_data *data = ina2xx_update_device(dev);
+	unsigned long val;
+	int status;
+
+	if (IS_ERR(data))
+		return PTR_ERR(data);
+
+	status = kstrtoul(buf, 10, &val);
+	if (status < 0)
+		return status;
+
+	if (val == 0 ||
+	    /* Values greater than the calibration factor make no sense. */
+	    val > data->config->calibration_factor)
+		return -EINVAL;
+
+	mutex_lock(&data->update_lock);
+	data->rshunt = val;
+	status = ina2xx_calibrate(data);
+	mutex_unlock(&data->update_lock);
+	if (status < 0)
+		return status;
+
+	return count;
+}
+
 /* shunt voltage */
 static SENSOR_DEVICE_ATTR(in0_input, S_IRUGO, ina2xx_show_value, NULL,
 			  INA2XX_SHUNT_VOLTAGE);
@@ -270,12 +308,18 @@ static SENSOR_DEVICE_ATTR(curr1_input, S_IRUGO, ina2xx_show_value, NULL,
 static SENSOR_DEVICE_ATTR(power1_input, S_IRUGO, ina2xx_show_value, NULL,
 			  INA2XX_POWER);
 
+/* shunt resistance */
+static SENSOR_DEVICE_ATTR(shunt_resistor, S_IRUGO | S_IWUSR,
+			  ina2xx_show_value, ina2xx_set_shunt,
+			  INA2XX_CALIBRATION);
+
 /* pointers to created device attributes */
 static struct attribute *ina2xx_attrs[] = {
 	&sensor_dev_attr_in0_input.dev_attr.attr,
 	&sensor_dev_attr_in1_input.dev_attr.attr,
 	&sensor_dev_attr_curr1_input.dev_attr.attr,
 	&sensor_dev_attr_power1_input.dev_attr.attr,
+	&sensor_dev_attr_shunt_resistor.dev_attr.attr,
 	NULL,
 };
 ATTRIBUTE_GROUPS(ina2xx);
-- 
2.1.3

