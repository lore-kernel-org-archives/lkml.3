Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170AbaLCKyZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 05:54:25 -0500
Received: from mail-wi0-f175.google.com ([209.85.212.175]:54831 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbaLCKyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 05:54:24 -0500
From: Bartosz Golaszewski <bartekgola@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        LM Sensors <lm-sensors@lm-sensors.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH v3 1/3] hwmon: ina2xx: make shunt resistance configurable at run-time
Date: Wed,  3 Dec 2014 11:54:12 +0100
Message-Id: <1417604054-8694-2-git-send-email-bartekgola@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417604054-8694-1-git-send-email-bartekgola@gmail.com>
References: <1417604054-8694-1-git-send-email-bartekgola@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bartosz Golaszewski <bgolaszewski@baylibre.com>

The shunt resistance can only be set via platform_data or device tree. This
isn't suitable for devices in which the shunt resistance can change/isn't
known at boot-time.

Add a sysfs attribute that allows to read and set the shunt resistance.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 drivers/hwmon/ina2xx.c | 70 +++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 61 insertions(+), 9 deletions(-)

diff --git a/drivers/hwmon/ina2xx.c b/drivers/hwmon/ina2xx.c
index e01feba..309bfdb 100644
--- a/drivers/hwmon/ina2xx.c
+++ b/drivers/hwmon/ina2xx.c
@@ -51,7 +51,6 @@
 #define INA226_ALERT_LIMIT		0x07
 #define INA226_DIE_ID			0xFF
 
-
 /* register count */
 #define INA219_REGISTERS		6
 #define INA226_REGISTERS		8
@@ -65,6 +64,9 @@
 /* worst case is 68.10 ms (~14.6Hz, ina219) */
 #define INA2XX_CONVERSION_RATE		15
 
+/* default shunt resistance */
+#define INA2XX_RSHUNT_DEFAULT		10000
+
 enum ina2xx_ids { ina219, ina226 };
 
 struct ina2xx_config {
@@ -87,6 +89,8 @@ struct ina2xx_data {
 
 	int kind;
 	u16 regs[INA2XX_MAX_REGISTERS];
+
+	long rshunt;
 };
 
 static const struct ina2xx_config ina2xx_config[] = {
@@ -110,6 +114,11 @@ static const struct ina2xx_config ina2xx_config[] = {
 	},
 };
 
+static u16 ina2xx_calibration_val(const struct ina2xx_data *data)
+{
+	return data->config->calibration_factor / data->rshunt;
+}
+
 static struct ina2xx_data *ina2xx_update_device(struct device *dev)
 {
 	struct ina2xx_data *data = dev_get_drvdata(dev);
@@ -164,6 +173,9 @@ static int ina2xx_get_value(struct ina2xx_data *data, u8 reg)
 		/* signed register, LSB=1mA (selected), in mA */
 		val = (s16)data->regs[reg];
 		break;
+	case INA2XX_CALIBRATION:
+		val = data->config->calibration_factor / data->regs[reg];
+		break;
 	default:
 		/* programmer goofed */
 		WARN_ON_ONCE(1);
@@ -187,6 +199,38 @@ static ssize_t ina2xx_show_value(struct device *dev,
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
+	    val > data->config->calibration_factor ||
+	    val > LONG_MAX)
+		return -EINVAL;
+
+	mutex_lock(&data->update_lock);
+	data->rshunt = val;
+	status = i2c_smbus_write_word_swapped(data->client, INA2XX_CALIBRATION,
+					      ina2xx_calibration_val(data));
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
@@ -203,12 +247,18 @@ static SENSOR_DEVICE_ATTR(curr1_input, S_IRUGO, ina2xx_show_value, NULL,
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
@@ -221,7 +271,6 @@ static int ina2xx_probe(struct i2c_client *client,
 	struct device *dev = &client->dev;
 	struct ina2xx_data *data;
 	struct device *hwmon_dev;
-	long shunt = 10000; /* default shunt value 10mOhms */
 	u32 val;
 	int ret;
 
@@ -234,19 +283,22 @@ static int ina2xx_probe(struct i2c_client *client,
 
 	if (dev_get_platdata(dev)) {
 		pdata = dev_get_platdata(dev);
-		shunt = pdata->shunt_uohms;
+		data->rshunt = pdata->shunt_uohms;
 	} else if (!of_property_read_u32(dev->of_node,
 					 "shunt-resistor", &val)) {
-		shunt = val;
+		data->rshunt = val;
+	} else {
+		data->rshunt = INA2XX_RSHUNT_DEFAULT;
 	}
 
-	if (shunt <= 0)
-		return -ENODEV;
-
 	/* set the device type */
 	data->kind = id->driver_data;
 	data->config = &ina2xx_config[data->kind];
 
+	if (data->rshunt <= 0 ||
+	    data->rshunt > data->config->calibration_factor)
+		return -ENODEV;
+
 	/* device configuration */
 	ret = i2c_smbus_write_word_swapped(client, INA2XX_CONFIG,
 					   data->config->config_default);
@@ -261,7 +313,7 @@ static int ina2xx_probe(struct i2c_client *client,
 	 * (equation 13 in datasheet).
 	 */
 	ret = i2c_smbus_write_word_swapped(client, INA2XX_CALIBRATION,
-				data->config->calibration_factor / shunt);
+					   ina2xx_calibration_val(data));
 	if (ret < 0) {
 		dev_err(dev,
 			"error writing to the calibration register: %d", ret);
@@ -277,7 +329,7 @@ static int ina2xx_probe(struct i2c_client *client,
 		return PTR_ERR(hwmon_dev);
 
 	dev_info(dev, "power monitor %s (Rshunt = %li uOhm)\n",
-		 id->name, shunt);
+		 id->name, data->rshunt);
 
 	return 0;
 }
-- 
2.1.3

