Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906AbbAGMqX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 07:46:23 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:42214 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827AbbAGMqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 07:46:21 -0500
From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        LM Sensors <lm-sensors@lm-sensors.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH] hwmon: ina2xx: allow to change the averaging rate at run-time
Date: Wed,  7 Jan 2015 13:46:09 +0100
Message-Id: <1420634769-11246-1-git-send-email-bgolaszewski@baylibre.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The averaging rate of ina226 is hardcoded to 16 in the driver. Make it
modifiable at run-time via a new sysfs attribute.

While we're at it - add an additional variable to ina2xx_data, which holds
the current configuration settings - this way we'll be able to restore the
configuration in case of an unexpected chip reset.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 Documentation/hwmon/ina2xx |   4 ++
 drivers/hwmon/ina2xx.c     | 110 +++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 110 insertions(+), 4 deletions(-)

diff --git a/Documentation/hwmon/ina2xx b/Documentation/hwmon/ina2xx
index 320dd69..4b7fb47 100644
--- a/Documentation/hwmon/ina2xx
+++ b/Documentation/hwmon/ina2xx
@@ -48,3 +48,7 @@ The shunt value in micro-ohms can be set via platform data or device tree at
 compile-time or via the shunt_resistor attribute in sysfs at run-time. Please
 refer to the Documentation/devicetree/bindings/i2c/ina2xx.txt for bindings
 if the device tree is used.
+
+The averaging rate of INA226 and INA230 can be changed via the avg_rate sysfs
+attribute. The available rates are: 1, 4, 16, 64, 128, 256, 512 and 1024. Other
+inputs will be rounded to the nearest value in the above list.
diff --git a/drivers/hwmon/ina2xx.c b/drivers/hwmon/ina2xx.c
index 49537ea..868fd5c 100644
--- a/drivers/hwmon/ina2xx.c
+++ b/drivers/hwmon/ina2xx.c
@@ -68,6 +68,16 @@
 
 #define INA2XX_RSHUNT_DEFAULT		10000
 
+/* bit masks for the averaging setting in the configuration register */
+#define INA226_AVG_RD_MASK		0x0E00
+#define INA226_AVG_WR_MASK		~INA226_AVG_RD_MASK
+
+#define INA226_READ_AVG(reg) ((reg & INA226_AVG_RD_MASK) >> 9)
+#define INA226_SHIFT_AVG(val) (val << 9)
+
+/* common attrs, ina226 attrs and NULL */
+#define INA2XX_MAX_ATTRIBUTE_GROUPS	3
+
 enum ina2xx_ids { ina219, ina226 };
 
 struct ina2xx_config {
@@ -85,12 +95,14 @@ struct ina2xx_data {
 	const struct ina2xx_config *config;
 
 	long rshunt;
+	u16 curr_config;
 
 	struct mutex update_lock;
 	bool valid;
 	unsigned long last_updated;
 
 	int kind;
+	const struct attribute_group *groups[INA2XX_MAX_ATTRIBUTE_GROUPS];
 	u16 regs[INA2XX_MAX_REGISTERS];
 };
 
@@ -115,6 +127,27 @@ static const struct ina2xx_config ina2xx_config[] = {
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
+static int ina226_avg_bits(int avg)
+{
+	int i;
+
+	/* Get the closest average from the tab. */
+	for (i = 0; i < ARRAY_SIZE(ina226_avg_tab) - 1; i++) {
+		if (avg <= (ina226_avg_tab[i] + ina226_avg_tab[i + 1]) / 2)
+			break;
+	}
+
+	return i; /* Return 0b0111 for values greater than 1024. */
+}
+
 static int ina2xx_calibrate(struct ina2xx_data *data)
 {
 	return i2c_smbus_write_word_swapped(data->client, INA2XX_CALIBRATION,
@@ -131,7 +164,7 @@ static int ina2xx_init(struct ina2xx_data *data)
 
 	/* device configuration */
 	ret = i2c_smbus_write_word_swapped(client, INA2XX_CONFIG,
-					   data->config->config_default);
+					   data->curr_config);
 	if (ret < 0)
 		return ret;
 
@@ -292,6 +325,54 @@ static ssize_t ina2xx_set_shunt(struct device *dev,
 	return count;
 }
 
+static ssize_t ina226_show_avg(struct device *dev,
+			       struct device_attribute *da, char *buf)
+{
+	struct ina2xx_data *data = ina2xx_update_device(dev);
+
+	if (IS_ERR(data))
+		return PTR_ERR(data);
+
+	return snprintf(buf, PAGE_SIZE, "%d\n",
+			ina226_avg_tab[INA226_READ_AVG(
+				       data->regs[INA2XX_CONFIG])]);
+}
+
+static ssize_t ina226_set_avg(struct device *dev,
+			      struct device_attribute *da,
+			      const char *buf, size_t count)
+{
+	struct ina2xx_data *data = dev_get_drvdata(dev);
+	unsigned long val;
+	int status, avg;
+
+	if (IS_ERR(data))
+		return PTR_ERR(data);
+
+	status = kstrtoul(buf, 10, &val);
+	if (status < 0)
+		return status;
+
+	if (val > INT_MAX || val == 0)
+		return -EINVAL;
+
+	avg = ina226_avg_bits(val);
+
+	mutex_lock(&data->update_lock);
+	data->curr_config = (data->regs[INA2XX_CONFIG] &
+			     INA226_AVG_WR_MASK) | INA226_SHIFT_AVG(avg);
+	status = i2c_smbus_write_word_swapped(data->client,
+					      INA2XX_CONFIG,
+					      data->curr_config);
+	/* Make sure the next access re-reads all registers. */
+	data->valid = 0;
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
@@ -313,6 +394,10 @@ static SENSOR_DEVICE_ATTR(shunt_resistor, S_IRUGO | S_IWUSR,
 			  ina2xx_show_value, ina2xx_set_shunt,
 			  INA2XX_CALIBRATION);
 
+/* averaging rate */
+static SENSOR_DEVICE_ATTR(avg_rate, S_IRUGO | S_IWUSR,
+			  ina226_show_avg, ina226_set_avg, 0);
+
 /* pointers to created device attributes */
 static struct attribute *ina2xx_attrs[] = {
 	&sensor_dev_attr_in0_input.dev_attr.attr,
@@ -322,7 +407,19 @@ static struct attribute *ina2xx_attrs[] = {
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
@@ -333,7 +430,7 @@ static int ina2xx_probe(struct i2c_client *client,
 	struct ina2xx_data *data;
 	struct device *hwmon_dev;
 	u32 val;
-	int ret;
+	int ret, group = 0;
 
 	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_WORD_DATA))
 		return -ENODEV;
@@ -355,6 +452,7 @@ static int ina2xx_probe(struct i2c_client *client,
 	/* set the device type */
 	data->kind = id->driver_data;
 	data->config = &ina2xx_config[data->kind];
+	data->curr_config = data->config->config_default;
 	data->client = client;
 
 	if (data->rshunt <= 0 ||
@@ -369,8 +467,12 @@ static int ina2xx_probe(struct i2c_client *client,
 
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

