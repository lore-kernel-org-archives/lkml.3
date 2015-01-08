Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756503AbbAHQdm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 11:33:42 -0500
Received: from mail-we0-f178.google.com ([74.125.82.178]:61086 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753998AbbAHQdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 11:33:41 -0500
X-Greylist: delayed 488 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Jan 2015 11:33:40 EST
From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        LM Sensors <lm-sensors@lm-sensors.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCH] hwmon: (ina2xx) implement update_interval attribute for ina226
Date: Thu,  8 Jan 2015 17:25:13 +0100
Message-Id: <1420734313-24546-1-git-send-email-bgolaszewski@baylibre.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This attribute allows to configure the update interval of ina226. Although
the bus and shunt voltage conversion times remain hardcoded to 1.1 ms, we can
now modify said interval by changing the averaging rate.

While we're at it - add an additional variable to ina2xx_data, which holds
the current configuration settings - this way we'll be able to restore the
configuration in case of an unexpected chip reset.

Signed-off-by: Bartosz Golaszewski <bgolaszewski@baylibre.com>
---
 Documentation/hwmon/ina2xx |   3 +
 drivers/hwmon/ina2xx.c     | 133 +++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 132 insertions(+), 4 deletions(-)

diff --git a/Documentation/hwmon/ina2xx b/Documentation/hwmon/ina2xx
index 320dd69..f4f2696 100644
--- a/Documentation/hwmon/ina2xx
+++ b/Documentation/hwmon/ina2xx
@@ -48,3 +48,6 @@ The shunt value in micro-ohms can be set via platform data or device tree at
 compile-time or via the shunt_resistor attribute in sysfs at run-time. Please
 refer to the Documentation/devicetree/bindings/i2c/ina2xx.txt for bindings
 if the device tree is used.
+
+Additionally ina226 supports update_interval attribute as described in
+Documentation/hwmon/sysfs-interface.
diff --git a/drivers/hwmon/ina2xx.c b/drivers/hwmon/ina2xx.c
index 49537ea..048c229 100644
--- a/drivers/hwmon/ina2xx.c
+++ b/drivers/hwmon/ina2xx.c
@@ -68,6 +68,21 @@
 
 #define INA2XX_RSHUNT_DEFAULT		10000
 
+/* bit mask for reading the averaging setting in the configuration register */
+#define INA226_AVG_RD_MASK		0x0E00
+
+#define INA226_READ_AVG(reg)		(((reg) & INA226_AVG_RD_MASK) >> 9)
+#define INA226_SHIFT_AVG(val)		((val) << 9)
+
+/* common attrs, ina226 attrs and NULL */
+#define INA2XX_MAX_ATTRIBUTE_GROUPS	3
+
+/*
+ * Both bus voltage and shunt voltage conversion times for ina226 are set
+ * to 0b0100 on POR, which translates to 1100 microseconds.
+ */
+#define INA226_CONV_TIME_DEFAULT	1100
+
 enum ina2xx_ids { ina219, ina226 };
 
 struct ina2xx_config {
@@ -85,12 +100,14 @@ struct ina2xx_data {
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
 
@@ -115,6 +132,48 @@ static const struct ina2xx_config ina2xx_config[] = {
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
+static int ina226_reg_to_interval(u16 config)
+{
+	int avg = ina226_avg_tab[INA226_READ_AVG(config)];
+
+	/*
+	 * Add bus and shunt voltage conversion times and multiple them
+	 * by the averaging rate. Return the result in milliseconds.
+	 */
+	return (avg * 2 * INA226_CONV_TIME_DEFAULT) / 1000;
+}
+
+static u16 ina226_interval_to_reg(int interval, u16 config)
+{
+	int avg, avg_bits;
+
+	avg = (interval * 1000) / (2 * INA226_CONV_TIME_DEFAULT);
+	avg_bits = ina226_avg_bits(avg);
+
+	return (config & ~INA226_AVG_RD_MASK) | INA226_SHIFT_AVG(avg_bits);
+}
+
 static int ina2xx_calibrate(struct ina2xx_data *data)
 {
 	return i2c_smbus_write_word_swapped(data->client, INA2XX_CALIBRATION,
@@ -131,7 +190,7 @@ static int ina2xx_init(struct ina2xx_data *data)
 
 	/* device configuration */
 	ret = i2c_smbus_write_word_swapped(client, INA2XX_CONFIG,
-					   data->config->config_default);
+					   data->curr_config);
 	if (ret < 0)
 		return ret;
 
@@ -292,6 +351,51 @@ static ssize_t ina2xx_set_shunt(struct device *dev,
 	return count;
 }
 
+static ssize_t ina226_set_interval(struct device *dev,
+				   struct device_attribute *da,
+				   const char *buf, size_t count)
+{
+	struct ina2xx_data *data = dev_get_drvdata(dev);
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
+	if (val > INT_MAX || val == 0)
+		return -EINVAL;
+
+	mutex_lock(&data->update_lock);
+	data->curr_config = ina226_interval_to_reg(val,
+						   data->regs[INA2XX_CONFIG]);
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
+static ssize_t ina226_show_interval(struct device *dev,
+				    struct device_attribute *da, char *buf)
+{
+	struct ina2xx_data *data = ina2xx_update_device(dev);
+
+	if (IS_ERR(data))
+		return PTR_ERR(data);
+
+	return snprintf(buf, PAGE_SIZE, "%d\n",
+			ina226_reg_to_interval(data->regs[INA2XX_CONFIG]));
+}
+
 /* shunt voltage */
 static SENSOR_DEVICE_ATTR(in0_input, S_IRUGO, ina2xx_show_value, NULL,
 			  INA2XX_SHUNT_VOLTAGE);
@@ -313,6 +417,10 @@ static SENSOR_DEVICE_ATTR(shunt_resistor, S_IRUGO | S_IWUSR,
 			  ina2xx_show_value, ina2xx_set_shunt,
 			  INA2XX_CALIBRATION);
 
+/* update interval (ina226 only) */
+static SENSOR_DEVICE_ATTR(update_interval, S_IRUGO | S_IWUSR,
+			  ina226_show_interval, ina226_set_interval, 0);
+
 /* pointers to created device attributes */
 static struct attribute *ina2xx_attrs[] = {
 	&sensor_dev_attr_in0_input.dev_attr.attr,
@@ -322,7 +430,19 @@ static struct attribute *ina2xx_attrs[] = {
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
+	&sensor_dev_attr_update_interval.dev_attr.attr,
+	NULL,
+};
+
+static const struct attribute_group ina226_group = {
+	.attrs = ina226_attrs,
+};
 
 static int ina2xx_probe(struct i2c_client *client,
 			const struct i2c_device_id *id)
@@ -333,7 +453,7 @@ static int ina2xx_probe(struct i2c_client *client,
 	struct ina2xx_data *data;
 	struct device *hwmon_dev;
 	u32 val;
-	int ret;
+	int ret, group = 0;
 
 	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_WORD_DATA))
 		return -ENODEV;
@@ -355,6 +475,7 @@ static int ina2xx_probe(struct i2c_client *client,
 	/* set the device type */
 	data->kind = id->driver_data;
 	data->config = &ina2xx_config[data->kind];
+	data->curr_config = data->config->config_default;
 	data->client = client;
 
 	if (data->rshunt <= 0 ||
@@ -369,8 +490,12 @@ static int ina2xx_probe(struct i2c_client *client,
 
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

