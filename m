Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276AbaLCKzH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 05:55:07 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:34908 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131AbaLCKyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 05:54:24 -0500
From: Bartosz Golaszewski <bartekgola@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        LM Sensors <lm-sensors@lm-sensors.org>,
        Bartosz Golaszewski <bartekgola@gmail.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH v3 2/3] hwmon: ina2xx: allow to change the averaging rate at run-time
Date: Wed,  3 Dec 2014 11:54:13 +0100
Message-Id: <1417604054-8694-3-git-send-email-bartekgola@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417604054-8694-1-git-send-email-bartekgola@gmail.com>
References: <1417604054-8694-1-git-send-email-bartekgola@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The averaging rate of ina226 is hardcoded to 16 in the driver.

Make it modifiable at run-time via a new sysfs attribute.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 drivers/hwmon/ina2xx.c | 125 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 122 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/ina2xx.c b/drivers/hwmon/ina2xx.c
index 309bfdb..9826c69 100644
--- a/drivers/hwmon/ina2xx.c
+++ b/drivers/hwmon/ina2xx.c
@@ -67,6 +67,15 @@
 /* default shunt resistance */
 #define INA2XX_RSHUNT_DEFAULT		10000
 
+/* bit masks for the averaging setting in the configuration register */
+#define INA226_AVG_RD_MASK		0x0E00
+#define INA226_AVG_WR_MASK		0xF1FF
+
+#define INA226_READ_AVG(reg) ((reg & INA226_AVG_RD_MASK) >> 9)
+
+/* common attrs, ina226 attrs and NULL */
+#define INA2XX_MAX_ATTRIBUTE_GROUPS	3
+
 enum ina2xx_ids { ina219, ina226 };
 
 struct ina2xx_config {
@@ -88,6 +97,7 @@ struct ina2xx_data {
 	unsigned long last_updated;
 
 	int kind;
+	const struct attribute_group *groups[INA2XX_MAX_ATTRIBUTE_GROUPS];
 	u16 regs[INA2XX_MAX_REGISTERS];
 
 	long rshunt;
@@ -114,11 +124,43 @@ static const struct ina2xx_config ina2xx_config[] = {
 	},
 };
 
+/*
+ * Available averaging rates for ina226. The indices correspond with
+ * the bit values expected by the chip (according to the ina226 datasheet,
+ * table 3 AVG bit settings, found at
+ * http://www.ti.com/lit/ds/symlink/ina226.pdf.
+ */
+static const int ina226_avg_tab[] = { 1, 4, 16, 64, 128, 256, 512, 1024 };
+
 static u16 ina2xx_calibration_val(const struct ina2xx_data *data)
 {
 	return data->config->calibration_factor / data->rshunt;
 }
 
+static int ina226_avg_bits(int avg)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(ina226_avg_tab); i++) {
+		if (avg == ina226_avg_tab[i])
+			return i;
+	}
+
+	return -EINVAL;
+}
+
+static int ina226_avg_val(int bits)
+{
+	/*
+	 * Value read from the config register should be correct, but do check
+	 * the boundary just in case.
+	 */
+	if (bits >= ARRAY_SIZE(ina226_avg_tab))
+		return -ENODEV;
+
+	return ina226_avg_tab[bits];
+}
+
 static struct ina2xx_data *ina2xx_update_device(struct device *dev)
 {
 	struct ina2xx_data *data = dev_get_drvdata(dev);
@@ -231,6 +273,63 @@ static ssize_t ina2xx_set_shunt(struct device *dev,
 	return count;
 }
 
+static ssize_t ina226_show_avg(struct device *dev,
+			       struct device_attribute *da, char *buf)
+{
+	struct ina2xx_data *data = ina2xx_update_device(dev);
+	int avg, i, written = 0;
+	const char *fmt;
+
+	if (IS_ERR(data))
+		return PTR_ERR(data);
+
+	avg = ina226_avg_val(INA226_READ_AVG(data->regs[INA2XX_CONFIG]));
+	if (avg < 0)
+		return avg;
+
+	for (i = 0; i < ARRAY_SIZE(ina226_avg_tab); i++) {
+		if (avg == ina226_avg_tab[i])
+			fmt = "\t[%d]";
+		else
+			fmt = "\t%d";
+
+		written += snprintf(buf + written, PAGE_SIZE - written,
+				    fmt, ina226_avg_tab[i]);
+	}
+	written += snprintf(buf + written, PAGE_SIZE - written, "\n");
+
+	return written;
+}
+
+static ssize_t ina226_set_avg(struct device *dev,
+			      struct device_attribute *da,
+			      const char *buf, size_t count)
+{
+	struct ina2xx_data *data = ina2xx_update_device(dev);
+	long val;
+	int status, avg;
+	u16 conf;
+
+	if (IS_ERR(data))
+		return PTR_ERR(data);
+
+	status = kstrtol(buf, 10, &val);
+	if (status < 0)
+		return status;
+
+	avg = ina226_avg_bits(val);
+	if (avg < 0)
+		return avg;
+
+	mutex_lock(&data->update_lock);
+	conf = (data->regs[INA2XX_CONFIG] & INA226_AVG_WR_MASK) | (avg << 9);
+	status = i2c_smbus_write_word_swapped(data->client,
+					      INA2XX_CONFIG, conf);
+	mutex_unlock(&data->update_lock);
+
+	return count;
+}
+
 /* shunt voltage */
 static SENSOR_DEVICE_ATTR(in0_input, S_IRUGO, ina2xx_show_value, NULL,
 			  INA2XX_SHUNT_VOLTAGE);
@@ -252,6 +351,10 @@ static SENSOR_DEVICE_ATTR(shunt_resistor, S_IRUGO | S_IWUSR,
 			  ina2xx_show_value, ina2xx_set_shunt,
 			  INA2XX_CALIBRATION);
 
+/* averaging rate */
+static SENSOR_DEVICE_ATTR(avg_rate, S_IRUGO | S_IWUSR,
+			  ina226_show_avg, ina226_set_avg, 0);
+
 /* pointers to created device attributes */
 static struct attribute *ina2xx_attrs[] = {
 	&sensor_dev_attr_in0_input.dev_attr.attr,
@@ -261,7 +364,19 @@ static struct attribute *ina2xx_attrs[] = {
 	&sensor_dev_attr_shunt_resistor.dev_attr.attr,
 	NULL,
 };
-ATTRIBUTE_GROUPS(ina2xx);
+
+static const struct attribute_group ina2xx_group = {
+	.attrs = ina2xx_attrs,
+};
+
+static struct attribute *ina226_attrs[] = {
+	&sensor_dev_attr_avg_rate.dev_attr.attr,
+	NULL,
+};
+
+static const struct attribute_group ina226_group = {
+	.attrs = ina226_attrs,
+};
 
 static int ina2xx_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
@@ -272,7 +387,7 @@ static int ina2xx_probe(struct i2c_client *client,
 	struct ina2xx_data *data;
 	struct device *hwmon_dev;
 	u32 val;
-	int ret;
+	int ret, group = 0;
 
 	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_WORD_DATA))
 		return -ENODEV;
@@ -323,8 +438,12 @@ static int ina2xx_probe(struct i2c_client *client,
 	data->client = client;
 	mutex_init(&data->update_lock);
 
+	data->groups[group++] = &ina2xx_group;
+	if (data->kind == ina226)
+		data->groups[group++] = &ina226_group;
+
 	hwmon_dev = devm_hwmon_device_register_with_groups(dev, client->name,
-							   data, ina2xx_groups);
+							   data, data->groups);
 	if (IS_ERR(hwmon_dev))
 		return PTR_ERR(hwmon_dev);
 
-- 
2.1.3

