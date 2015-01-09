Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758052AbbAIQDo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 11:03:44 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:48218 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbbAIQDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 11:03:42 -0500
From: Bartosz Golaszewski <bgolaszewski@baylibre.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Benoit Cousson <bcousson@baylibre.com>,
        Patrick Titiano <ptitiano@baylibre.com>,
        LM Sensors <lm-sensors@lm-sensors.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>
Subject: [PATCHv3] hwmon: (ina2xx) implement update_interval attribute for ina226
Date: Fri,  9 Jan 2015 17:03:42 +0100
Message-Id: <1420819422-24784-1-git-send-email-bgolaszewski@baylibre.com>
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
 Documentation/hwmon/ina2xx |   7 ++
 drivers/hwmon/ina2xx.c     | 164 +++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 165 insertions(+), 6 deletions(-)

diff --git a/Documentation/hwmon/ina2xx b/Documentation/hwmon/ina2xx
index 320dd69..450e3cc 100644
--- a/Documentation/hwmon/ina2xx
+++ b/Documentation/hwmon/ina2xx
@@ -48,3 +48,10 @@ The shunt value in micro-ohms can be set via platform data or device tree at
 compile-time or via the shunt_resistor attribute in sysfs at run-time. Please
 refer to the Documentation/devicetree/bindings/i2c/ina2xx.txt for bindings
 if the device tree is used.
+
+Additionally ina226 supports update_interval attribute as described in
+Documentation/hwmon/sysfs-interface. Internally the interval is the sum of
+bus and shunt voltage conversion times multiplied by the averaging rate. We
+don't touch the conversion times and only modify the number of averages. The
+lower limit of the update_interval is 2 ms, the upper limit is 2253 ms.
+The actual programmed interval may vary from the desired value.
diff --git a/drivers/hwmon/ina2xx.c b/drivers/hwmon/ina2xx.c
index 49537ea..a16d6a2 100644
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
+ * to 0b0100 on POR, which translates to 2200 microseconds in total.
+ */
+#define INA226_TOTAL_CONV_TIME_DEFAULT	2200
+
 enum ina2xx_ids { ina219, ina226 };
 
 struct ina2xx_config {
@@ -85,12 +100,15 @@ struct ina2xx_data {
 	const struct ina2xx_config *config;
 
 	long rshunt;
+	u16 curr_config;
 
 	struct mutex update_lock;
 	bool valid;
 	unsigned long last_updated;
+	int update_interval; /* in jiffies */
 
 	int kind;
+	const struct attribute_group *groups[INA2XX_MAX_ATTRIBUTE_GROUPS];
 	u16 regs[INA2XX_MAX_REGISTERS];
 };
 
@@ -115,6 +133,57 @@ static const struct ina2xx_config ina2xx_config[] = {
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
+	 * Multiply the total conversion time by the number of averages.
+	 * Return the result in milliseconds.
+	 */
+	return DIV_ROUND_CLOSEST(avg * INA226_TOTAL_CONV_TIME_DEFAULT, 1000);
+}
+
+static u16 ina226_interval_to_reg(int interval, u16 config)
+{
+	int avg, avg_bits;
+
+	avg = DIV_ROUND_CLOSEST(interval * 1000,
+				INA226_TOTAL_CONV_TIME_DEFAULT);
+	avg_bits = ina226_avg_bits(avg);
+
+	return (config & ~INA226_AVG_RD_MASK) | INA226_SHIFT_AVG(avg_bits);
+}
+
+static void ina226_set_update_interval(struct ina2xx_data *data)
+{
+	int ms;
+
+	ms = ina226_reg_to_interval(data->curr_config);
+	data->update_interval = msecs_to_jiffies(ms);
+}
+
 static int ina2xx_calibrate(struct ina2xx_data *data)
 {
 	return i2c_smbus_write_word_swapped(data->client, INA2XX_CALIBRATION,
@@ -131,7 +200,7 @@ static int ina2xx_init(struct ina2xx_data *data)
 
 	/* device configuration */
 	ret = i2c_smbus_write_word_swapped(client, INA2XX_CONFIG,
-					   data->config->config_default);
+					   data->curr_config);
 	if (ret < 0)
 		return ret;
 
@@ -199,12 +268,13 @@ static struct ina2xx_data *ina2xx_update_device(struct device *dev)
 {
 	struct ina2xx_data *data = dev_get_drvdata(dev);
 	struct ina2xx_data *ret = data;
+	unsigned long after;
 	int rv;
 
 	mutex_lock(&data->update_lock);
 
-	if (time_after(jiffies, data->last_updated +
-		       HZ / INA2XX_CONVERSION_RATE) || !data->valid) {
+	after = data->last_updated + data->update_interval;
+	if (time_after(jiffies, after) || !data->valid) {
 		rv = ina2xx_do_update(dev);
 		if (rv < 0)
 			ret = ERR_PTR(rv);
@@ -292,6 +362,58 @@ static ssize_t ina2xx_set_shunt(struct device *dev,
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
+
+	ina226_set_update_interval(data);
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
+	/*
+	 * We don't use data->update_interval here as we want to display
+	 * the actual interval used by the chip and jiffies_to_msecs()
+	 * doesn't seem to be accurate enough.
+	 */
+	return snprintf(buf, PAGE_SIZE, "%d\n",
+			ina226_reg_to_interval(data->regs[INA2XX_CONFIG]));
+}
+
 /* shunt voltage */
 static SENSOR_DEVICE_ATTR(in0_input, S_IRUGO, ina2xx_show_value, NULL,
 			  INA2XX_SHUNT_VOLTAGE);
@@ -313,6 +435,10 @@ static SENSOR_DEVICE_ATTR(shunt_resistor, S_IRUGO | S_IWUSR,
 			  ina2xx_show_value, ina2xx_set_shunt,
 			  INA2XX_CALIBRATION);
 
+/* update interval (ina226 only) */
+static SENSOR_DEVICE_ATTR(update_interval, S_IRUGO | S_IWUSR,
+			  ina226_show_interval, ina226_set_interval, 0);
+
 /* pointers to created device attributes */
 static struct attribute *ina2xx_attrs[] = {
 	&sensor_dev_attr_in0_input.dev_attr.attr,
@@ -322,7 +448,19 @@ static struct attribute *ina2xx_attrs[] = {
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
@@ -333,7 +471,7 @@ static int ina2xx_probe(struct i2c_client *client,
 	struct ina2xx_data *data;
 	struct device *hwmon_dev;
 	u32 val;
-	int ret;
+	int ret, group = 0;
 
 	if (!i2c_check_functionality(adapter, I2C_FUNC_SMBUS_WORD_DATA))
 		return -ENODEV;
@@ -355,8 +493,18 @@ static int ina2xx_probe(struct i2c_client *client,
 	/* set the device type */
 	data->kind = id->driver_data;
 	data->config = &ina2xx_config[data->kind];
+	data->curr_config = data->config->config_default;
 	data->client = client;
 
+	/*
+	 * Ina226 has a variable update_interval. For ina219 we
+	 * use a constant value.
+	 */
+	if (data->kind == ina226)
+		ina226_set_update_interval(data);
+	else
+		data->update_interval = HZ / INA2XX_CONVERSION_RATE;
+
 	if (data->rshunt <= 0 ||
 	    data->rshunt > data->config->calibration_factor)
 		return -ENODEV;
@@ -369,8 +517,12 @@ static int ina2xx_probe(struct i2c_client *client,
 
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

