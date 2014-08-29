Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702AbaH2IiW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 04:38:22 -0400
Received: from mga11.intel.com ([192.55.52.93]:17723 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753664AbaH2IiT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 04:38:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="378564463"
From: Laurentiu Palcu <laurentiu.palcu@intel.com>
To: jic23@kernel.org, linux-iio@vger.kernel.org
Cc: srinivas.pandruvada@linux.intel.com, knaack.h@gmx.de, lars@metafoo.de,
        pmeerw@pmeerw.net, laurentiu.palcu@intel.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 3/3] iio: accel: BMC150: add support for other Bosch chips
Date: Fri, 29 Aug 2014 11:38:08 +0300
Message-Id: <1409301488-22166-4-git-send-email-laurentiu.palcu@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409301488-22166-1-git-send-email-laurentiu.palcu@intel.com>
References: <1409301488-22166-1-git-send-email-laurentiu.palcu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following chips are either similar or have only the resolution
different. Hence, change this driver to support these chips too:

BMI055  - combo chip (accelerometer part is identical to BMC150's)
BMA255  - identical to BMC150's accelerometer
BMA222E - 8 bit resolution
BMA250E - 10 bit resolution
BMA280  - 14 bit resolution

Additionally:
 * add bmc150_accel_match_acpi_device() function to check that the device
   has been enumerated through ACPI;
 * rename bmc150_accel_acpi_gpio_probe() to bmc150_accel_gpio_probe()
   since the ACPI matching has been moved to the new function.  Also, this
   will allow for the GPIO matching to be done against a device tree too, not only
   ACPI tree;

Signed-off-by: Laurentiu Palcu <laurentiu.palcu@intel.com>
---
 drivers/iio/accel/bmc150-accel.c | 229 ++++++++++++++++++++++++++++++---------
 1 file changed, 176 insertions(+), 53 deletions(-)

diff --git a/drivers/iio/accel/bmc150-accel.c b/drivers/iio/accel/bmc150-accel.c
index 0e6566a..ffe619c 100644
--- a/drivers/iio/accel/bmc150-accel.c
+++ b/drivers/iio/accel/bmc150-accel.c
@@ -1,5 +1,12 @@
 /*
- * BMC150 3-axis accelerometer driver
+ * 3-axis accelerometer driver supporting following Bosch-Sensortec chips:
+ *  - BMC150
+ *  - BMI055
+ *  - BMA255
+ *  - BMA250E
+ *  - BMA222E
+ *  - BMA280
+ *
  * Copyright (c) 2014, Intel Corporation.
  *
  * This program is free software; you can redistribute it and/or modify it
@@ -35,6 +42,11 @@
 
 #define BMC150_ACCEL_REG_CHIP_ID		0x00
 #define BMC150_ACCEL_CHIP_ID_VAL		0xFA
+#define BMA255_ACCEL_CHIP_ID_VAL		0xFA
+#define BMI055_ACCEL_CHIP_ID_VAL		0xFA
+#define BMA222E_ACCEL_CHIP_ID_VAL		0xF8
+#define BMA250E_ACCEL_CHIP_ID_VAL		0xF9
+#define BMA280_ACCEL_CHIP_ID_VAL		0xFB
 
 #define BMC150_ACCEL_REG_INT_STATUS_2		0x0B
 #define BMC150_ACCEL_ANY_MOTION_MASK		0x07
@@ -126,6 +138,18 @@ enum bmc150_power_modes {
 	BMC150_ACCEL_SLEEP_MODE_SUSPEND = 0x04,
 };
 
+struct bmc150_scale_info {
+	int scale;
+	int range;
+};
+
+struct bmc150_accel_chip_info {
+	u8 chip_id;
+	const struct iio_chan_spec *channels;
+	int num_channels;
+	const struct bmc150_scale_info scale_table[4];
+};
+
 struct bmc150_accel_data {
 	struct i2c_client *client;
 	struct iio_trigger *dready_trig;
@@ -140,6 +164,7 @@ struct bmc150_accel_data {
 	bool dready_trigger_on;
 	bool motion_trigger_on;
 	int64_t timestamp;
+	const struct bmc150_accel_chip_info *chip_info;
 };
 
 static const struct {
@@ -168,14 +193,6 @@ static const struct {
 				     {0x0F, 1} };
 
 static const struct {
-	int scale;
-	int range;
-} bmc150_accel_scale_table[] = { {9610, BMC150_ACCEL_DEF_RANGE_2G},
-				 {19122, BMC150_ACCEL_DEF_RANGE_4G},
-				 {38344, BMC150_ACCEL_DEF_RANGE_8G},
-				 {76590, BMC150_ACCEL_DEF_RANGE_16G} };
-
-static const struct {
 	int sleep_dur;
 	int reg_value;
 } bmc150_accel_sleep_value_table[] = { {0, 0},
@@ -267,7 +284,7 @@ static int bmc150_accel_chip_init(struct bmc150_accel_data *data)
 	}
 
 	dev_dbg(&data->client->dev, "Chip Id %x\n", ret);
-	if (ret != BMC150_ACCEL_CHIP_ID_VAL) {
+	if (ret != data->chip_info->chip_id) {
 		dev_err(&data->client->dev, "Invalid chip %x\n", ret);
 		return -ENODEV;
 	}
@@ -541,19 +558,19 @@ static int bmc150_accel_set_scale(struct bmc150_accel_data *data, int val)
 {
 	int ret, i;
 
-	for (i = 0; i < ARRAY_SIZE(bmc150_accel_scale_table); ++i) {
-		if (bmc150_accel_scale_table[i].scale == val) {
+	for (i = 0; i < ARRAY_SIZE(data->chip_info->scale_table); ++i) {
+		if (data->chip_info->scale_table[i].scale == val) {
 			ret = i2c_smbus_write_byte_data(
 					data->client,
 					BMC150_ACCEL_REG_PMU_RANGE,
-					bmc150_accel_scale_table[i].range);
+					data->chip_info->scale_table[i].range);
 			if (ret < 0) {
 				dev_err(&data->client->dev,
 					"Error writing pmu_range\n");
 				return ret;
 			}
 
-			data->range = bmc150_accel_scale_table[i].range;
+			data->range = data->chip_info->scale_table[i].range;
 			return 0;
 		}
 	}
@@ -580,10 +597,12 @@ static int bmc150_accel_get_temp(struct bmc150_accel_data *data, int *val)
 	return IIO_VAL_INT;
 }
 
-static int bmc150_accel_get_axis(struct bmc150_accel_data *data, int axis,
+static int bmc150_accel_get_axis(struct bmc150_accel_data *data,
+				 struct iio_chan_spec const *chan,
 				 int *val)
 {
 	int ret;
+	int axis = chan->scan_index;
 
 	mutex_lock(&data->mutex);
 	ret = bmc150_accel_set_power_state(data, true);
@@ -600,7 +619,8 @@ static int bmc150_accel_get_axis(struct bmc150_accel_data *data, int axis,
 		mutex_unlock(&data->mutex);
 		return ret;
 	}
-	*val = sign_extend32(ret >> 4, 11);
+	*val = sign_extend32(ret >> chan->scan_type.shift,
+			     chan->scan_type.realbits - 1);
 	ret = bmc150_accel_set_power_state(data, false);
 	mutex_unlock(&data->mutex);
 	if (ret < 0)
@@ -625,9 +645,7 @@ static int bmc150_accel_read_raw(struct iio_dev *indio_dev,
 			if (iio_buffer_enabled(indio_dev))
 				return -EBUSY;
 			else
-				return bmc150_accel_get_axis(data,
-							     chan->scan_index,
-							     val);
+				return bmc150_accel_get_axis(data, chan, val);
 		default:
 			return -EINVAL;
 		}
@@ -647,12 +665,13 @@ static int bmc150_accel_read_raw(struct iio_dev *indio_dev,
 		{
 			int i;
 
-			for (i = 0; i < ARRAY_SIZE(bmc150_accel_scale_table);
-									 ++i) {
-				if (bmc150_accel_scale_table[i].range ==
+			for (i = 0;
+			     i < ARRAY_SIZE(data->chip_info->scale_table);
+			     ++i) {
+				if (data->chip_info->scale_table[i].range ==
 								data->range) {
 					*val2 =
-					bmc150_accel_scale_table[i].scale;
+					data->chip_info->scale_table[i].scale;
 					return IIO_VAL_INT_PLUS_MICRO;
 				}
 			}
@@ -840,7 +859,7 @@ static const struct iio_event_spec bmc150_accel_event = {
 				 BIT(IIO_EV_INFO_PERIOD)
 };
 
-#define BMC150_ACCEL_CHANNEL(_axis) {					\
+#define BMC150_ACCEL_CHANNEL(_axis, bits) {				\
 	.type = IIO_ACCEL,						\
 	.modified = 1,							\
 	.channel2 = IIO_MOD_##_axis,					\
@@ -850,26 +869,101 @@ static const struct iio_event_spec bmc150_accel_event = {
 	.scan_index = AXIS_##_axis,					\
 	.scan_type = {							\
 		.sign = 's',						\
-		.realbits = 12,					\
+		.realbits = (bits),					\
 		.storagebits = 16,					\
-		.shift = 4,						\
+		.shift = 16 - (bits),					\
 	},								\
 	.event_spec = &bmc150_accel_event,				\
 	.num_event_specs = 1						\
 }
 
-static const struct iio_chan_spec bmc150_accel_channels[] = {
-	{
-		.type = IIO_TEMP,
-		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW) |
-				      BIT(IIO_CHAN_INFO_SCALE) |
-				      BIT(IIO_CHAN_INFO_OFFSET),
-		.scan_index = -1,
+#define BMC150_ACCEL_CHANNELS(bits) {					\
+	{								\
+		.type = IIO_TEMP,					\
+		.info_mask_separate = BIT(IIO_CHAN_INFO_RAW) |		\
+				      BIT(IIO_CHAN_INFO_SCALE) |	\
+				      BIT(IIO_CHAN_INFO_OFFSET),	\
+		.scan_index = -1,					\
+	},								\
+	BMC150_ACCEL_CHANNEL(X, bits),					\
+	BMC150_ACCEL_CHANNEL(Y, bits),					\
+	BMC150_ACCEL_CHANNEL(Z, bits),					\
+	IIO_CHAN_SOFT_TIMESTAMP(3),					\
+}
+
+static const struct iio_chan_spec bma222e_accel_channels[] =
+	BMC150_ACCEL_CHANNELS(8);
+static const struct iio_chan_spec bma250e_accel_channels[] =
+	BMC150_ACCEL_CHANNELS(10);
+static const struct iio_chan_spec bmc150_accel_channels[] =
+	BMC150_ACCEL_CHANNELS(12);
+static const struct iio_chan_spec bma280_accel_channels[] =
+	BMC150_ACCEL_CHANNELS(14);
+
+enum {
+	bmc150,
+	bmi055,
+	bma255,
+	bma250e,
+	bma222e,
+	bma280,
+};
+
+static const struct bmc150_accel_chip_info bmc150_accel_chip_info_tbl[] = {
+	[bmc150] = {
+		.chip_id = BMC150_ACCEL_CHIP_ID_VAL,
+		.channels = bmc150_accel_channels,
+		.num_channels = ARRAY_SIZE(bmc150_accel_channels),
+		.scale_table = { {9610, BMC150_ACCEL_DEF_RANGE_2G},
+				 {19122, BMC150_ACCEL_DEF_RANGE_4G},
+				 {38344, BMC150_ACCEL_DEF_RANGE_8G},
+				 {76590, BMC150_ACCEL_DEF_RANGE_16G} },
+	},
+	[bmi055] = {
+		.chip_id = BMI055_ACCEL_CHIP_ID_VAL,
+		.channels = bmc150_accel_channels,
+		.num_channels = ARRAY_SIZE(bmc150_accel_channels),
+		.scale_table = { {9610, BMC150_ACCEL_DEF_RANGE_2G},
+				 {19122, BMC150_ACCEL_DEF_RANGE_4G},
+				 {38344, BMC150_ACCEL_DEF_RANGE_8G},
+				 {76590, BMC150_ACCEL_DEF_RANGE_16G} },
+	},
+	[bma255] = {
+		.chip_id = BMA255_ACCEL_CHIP_ID_VAL,
+		.channels = bmc150_accel_channels,
+		.num_channels = ARRAY_SIZE(bmc150_accel_channels),
+		.scale_table = { {9610, BMC150_ACCEL_DEF_RANGE_2G},
+				 {19122, BMC150_ACCEL_DEF_RANGE_4G},
+				 {38344, BMC150_ACCEL_DEF_RANGE_8G},
+				 {76590, BMC150_ACCEL_DEF_RANGE_16G} },
+	},
+	[bma250e] = {
+		.chip_id = BMA250E_ACCEL_CHIP_ID_VAL,
+		.channels = bma250e_accel_channels,
+		.num_channels = ARRAY_SIZE(bma250e_accel_channels),
+		.scale_table = { {38344, BMC150_ACCEL_DEF_RANGE_2G},
+				 {76590, BMC150_ACCEL_DEF_RANGE_4G},
+				 {153277, BMC150_ACCEL_DEF_RANGE_8G},
+				 {306457, BMC150_ACCEL_DEF_RANGE_16G} },
+	},
+	[bma222e] = {
+		.chip_id = BMA222E_ACCEL_CHIP_ID_VAL,
+		.channels = bma222e_accel_channels,
+		.num_channels = ARRAY_SIZE(bma222e_accel_channels),
+		.scale_table = { {153277, BMC150_ACCEL_DEF_RANGE_2G},
+				 {306457, BMC150_ACCEL_DEF_RANGE_4G},
+				 {612915, BMC150_ACCEL_DEF_RANGE_8G},
+				 {1225831, BMC150_ACCEL_DEF_RANGE_16G} },
+	},
+	[bma280] = {
+		.chip_id = BMA280_ACCEL_CHIP_ID_VAL,
+		.channels = bma280_accel_channels,
+		.num_channels = ARRAY_SIZE(bma280_accel_channels),
+		.scale_table = { {2392, BMC150_ACCEL_DEF_RANGE_2G},
+				 {4785, BMC150_ACCEL_DEF_RANGE_4G},
+				 {9581, BMC150_ACCEL_DEF_RANGE_8G},
+				 {19152, BMC150_ACCEL_DEF_RANGE_16G} },
 	},
-	BMC150_ACCEL_CHANNEL(X),
-	BMC150_ACCEL_CHANNEL(Y),
-	BMC150_ACCEL_CHANNEL(Z),
-	IIO_CHAN_SOFT_TIMESTAMP(3),
 };
 
 static const struct iio_info bmc150_accel_info = {
@@ -1040,10 +1134,23 @@ static irqreturn_t bmc150_accel_data_rdy_trig_poll(int irq, void *private)
 		return IRQ_HANDLED;
 }
 
-static int bmc150_accel_acpi_gpio_probe(struct i2c_client *client,
-					struct bmc150_accel_data *data)
+static char *bmc150_accel_match_acpi_device(struct device *dev, int *data)
 {
 	const struct acpi_device_id *id;
+
+	id = acpi_match_device(dev->driver->acpi_match_table, dev);
+
+	if (!id)
+		return NULL;
+
+	*data = (int) id->driver_data;
+
+	return (char *) dev_name(dev);
+}
+
+static int bmc150_accel_gpio_probe(struct i2c_client *client,
+					struct bmc150_accel_data *data)
+{
 	struct device *dev;
 	struct gpio_desc *gpio;
 	int ret;
@@ -1052,17 +1159,11 @@ static int bmc150_accel_acpi_gpio_probe(struct i2c_client *client,
 		return -EINVAL;
 
 	dev = &client->dev;
-	if (!ACPI_HANDLE(dev))
-		return -ENODEV;
-
-	id = acpi_match_device(dev->driver->acpi_match_table, dev);
-	if (!id)
-		return -ENODEV;
 
 	/* data ready gpio interrupt pin */
 	gpio = devm_gpiod_get_index(dev, BMC150_ACCEL_GPIO_NAME, 0);
 	if (IS_ERR(gpio)) {
-		dev_err(dev, "Failed: acpi gpio get index\n");
+		dev_err(dev, "Failed: gpio get index\n");
 		return PTR_ERR(gpio);
 	}
 
@@ -1083,6 +1184,8 @@ static int bmc150_accel_probe(struct i2c_client *client,
 	struct bmc150_accel_data *data;
 	struct iio_dev *indio_dev;
 	int ret;
+	char *name = NULL;
+	int chip_id = 0;
 
 	indio_dev = devm_iio_device_alloc(&client->dev, sizeof(*data));
 	if (!indio_dev)
@@ -1092,6 +1195,16 @@ static int bmc150_accel_probe(struct i2c_client *client,
 	i2c_set_clientdata(client, indio_dev);
 	data->client = client;
 
+	if (id) {
+		name = (char *) id->name;
+		chip_id = id->driver_data;
+	}
+
+	if (ACPI_HANDLE(&client->dev))
+		name = bmc150_accel_match_acpi_device(&client->dev, &chip_id);
+
+	data->chip_info = &bmc150_accel_chip_info_tbl[chip_id];
+
 	ret = bmc150_accel_chip_init(data);
 	if (ret < 0)
 		return ret;
@@ -1099,14 +1212,14 @@ static int bmc150_accel_probe(struct i2c_client *client,
 	mutex_init(&data->mutex);
 
 	indio_dev->dev.parent = &client->dev;
-	indio_dev->channels = bmc150_accel_channels;
-	indio_dev->num_channels = ARRAY_SIZE(bmc150_accel_channels);
-	indio_dev->name = BMC150_ACCEL_DRV_NAME;
+	indio_dev->channels = data->chip_info->channels;
+	indio_dev->num_channels = data->chip_info->num_channels;
+	indio_dev->name = name;
 	indio_dev->modes = INDIO_DIRECT_MODE;
 	indio_dev->info = &bmc150_accel_info;
 
 	if (client->irq < 0)
-		client->irq = bmc150_accel_acpi_gpio_probe(client, data);
+		client->irq = bmc150_accel_gpio_probe(client, data);
 
 	if (client->irq >= 0) {
 		ret = devm_request_threaded_irq(
@@ -1284,14 +1397,24 @@ static const struct dev_pm_ops bmc150_accel_pm_ops = {
 };
 
 static const struct acpi_device_id bmc150_accel_acpi_match[] = {
-	{"BSBA0150", 0},
-	{"BMC150A", 0},
+	{"BSBA0150",	bmc150},
+	{"BMC150A",	bmc150},
+	{"BMI055A",	bmi055},
+	{"BMA0255",	bma255},
+	{"BMA250E",	bma250e},
+	{"BMA222E",	bma222e},
+	{"BMA0280",	bma280},
 	{ },
 };
 MODULE_DEVICE_TABLE(acpi, bmc150_accel_acpi_match);
 
 static const struct i2c_device_id bmc150_accel_id[] = {
-	{"bmc150_accel", 0},
+	{"bmc150_accel",	bmc150},
+	{"bmi055_accel",	bmi055},
+	{"bma255",		bma255},
+	{"bma250e",		bma250e},
+	{"bma222e",		bma222e},
+	{"bma280",		bma280},
 	{}
 };
 
-- 
1.9.1

