Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751758AbaKFM2J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 07:28:09 -0500
Received: from mga11.intel.com ([192.55.52.93]:40785 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751430AbaKFM2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 07:28:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,325,1413270000"; 
   d="scan'208";a="618165986"
From: Daniel Baluta <daniel.baluta@intel.com>
To: jic23@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        srinivas.pandruvada@linux.intel.com, daniel.baluta@intel.com
Subject: [PATCH] iio: imu: Add support for Kionix KMX61 sensor
Date: Thu,  6 Nov 2014 14:29:12 +0200
Message-Id: <1415276952-19712-1-git-send-email-daniel.baluta@intel.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minimal implementation for KMX61 6-axis accelerometer/magnetometer. It exports
raw accel/magn readings together with scale and sampling frequency.

Datasheet will be available at:
http://www.kionix.com/6-axis-accelerometer-magnetometer/kmx61

Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
---
Accelerometer is somehow similar with KXCJK-1013 but the registers
are different. Some code and ideas are borrowed from KXCJK-1013 driver.

Trying to implement KMX61 on top of kxcjk-1013.c would make code
harder to read.

 drivers/iio/imu/Kconfig  |   9 +
 drivers/iio/imu/Makefile |   2 +
 drivers/iio/imu/kmx61.c  | 575 +++++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 586 insertions(+)
 create mode 100644 drivers/iio/imu/kmx61.c

diff --git a/drivers/iio/imu/Kconfig b/drivers/iio/imu/Kconfig
index 2b0e451..d675f43 100644
--- a/drivers/iio/imu/Kconfig
+++ b/drivers/iio/imu/Kconfig
@@ -25,6 +25,15 @@ config ADIS16480
 	  Say yes here to build support for Analog Devices ADIS16375, ADIS16480,
 	  ADIS16485, ADIS16488 inertial sensors.
 
+config KMX61
+	tristate "Kionix KMX61 6-axis accelerometer and magnetometer"
+	depends on I2C
+	help
+	  Say Y here if you want to build a driver for Kionix KMX61 6-axis accelerometer
+	  and magnetometer.
+	  To compile this driver as module, choose M here: the module will be called
+	  kmx61.
+
 source "drivers/iio/imu/inv_mpu6050/Kconfig"
 
 endmenu
diff --git a/drivers/iio/imu/Makefile b/drivers/iio/imu/Makefile
index 114d2c1..e1e6e3d 100644
--- a/drivers/iio/imu/Makefile
+++ b/drivers/iio/imu/Makefile
@@ -14,3 +14,5 @@ adis_lib-$(CONFIG_IIO_ADIS_LIB_BUFFER) += adis_buffer.o
 obj-$(CONFIG_IIO_ADIS_LIB) += adis_lib.o
 
 obj-y += inv_mpu6050/
+
+obj-$(CONFIG_KMX61) += kmx61.o
diff --git a/drivers/iio/imu/kmx61.c b/drivers/iio/imu/kmx61.c
new file mode 100644
index 0000000..124d75d
--- /dev/null
+++ b/drivers/iio/imu/kmx61.c
@@ -0,0 +1,575 @@
+/*
+ * KMX61 - Kionix 6-axis Accelerometer/Magnetometer
+ *
+ * Copyright (c) 2014, Intel Corporation.
+ *
+ * This file is subject to the terms and conditions of version 2 of
+ * the GNU General Public License.  See the file COPYING in the main
+ * directory of this archive for more details.
+ *
+ * IIO driver for KMX61 (7-bit I2C slave address 0x0E or 0x0F).
+ *
+ * TODO: buffer, interrupt, thresholds, acpi, temperature sensor
+ *
+ */
+
+#include <linux/module.h>
+#include <linux/i2c.h>
+#include <linux/iio/iio.h>
+#include <linux/iio/sysfs.h>
+
+#define KMX61_DRV_NAME "kmx61"
+
+#define KMX61_REG_WHO_AM_I		0x00
+
+#define KMX61_ACC_XOUT_L		0x0A
+
+#define KMX61_ACC_XOUT_H		0x0B
+#define KMX61_ACC_YOUT_L		0x0C
+#define KMX61_ACC_YOUT_H		0x0D
+#define KMX61_ACC_ZOUT_L		0x0E
+#define KMX61_ACC_ZOUT_H		0x0F
+
+#define KMX61_MAG_XOUT_L		0x12
+
+#define KMX61_MAG_XOUT_H		0x13
+#define KMX61_MAG_YOUT_L		0x14
+#define KMX61_MAG_YOUT_H		0x15
+#define KMX61_MAG_ZOUT_L		0x16
+#define KMX61_MAG_ZOUT_H		0x17
+
+#define KMX61_REG_ODCNTL		0x2C
+
+#define KMX61_REG_STBY			0x29
+#define KMX61_REG_CTRL1			0x2A
+
+#define KMX61_REG_COTR			0x3C
+
+#define KMX61_ACC_STBY_BIT	BIT(0)
+#define KMX61_MAG_STBY_BIT	BIT(1)
+#define KMX61_ACT_STBY_BIT	BIT(7)
+
+#define KMX61_ALL_STBY		(KMX61_ACC_STBY_BIT | KMX61_MAG_STBY_BIT)
+
+#define KMX61_REG_CTRL1_GSEL0_SHIFT	0
+#define KMX61_REG_CTRL1_GSEL1_SHIFT	1
+#define KMX61_REG_CTRL1_GSEL0_MASK	0x01
+#define KMX61_REG_CTRL1_GSEL1_MASK	0x02
+
+#define KMX61_REG_CTRL1_BIT_RES		BIT(4)
+
+#define KMX61_ACC_ODR_SHIFT	0
+#define KMX61_MAG_ODR_SHIFT	4
+#define KMX61_ACC_ODR_MASK	0x0F
+#define KMX61_MAG_ODR_MASK	0xF0
+
+#define KMX61_CHIP_ID		0x12
+
+struct kmx61_data {
+	struct i2c_client *client;
+	u8 range;
+	u8 odr_bits;
+};
+
+enum kmx61_range {
+	KMX61_RANGE_2G,
+	KMX61_RANGE_4G,
+	KMX61_RANGE_8G,
+};
+
+enum kmx61_scan {
+	KMX61_SCAN_ACC_X,
+	KMX61_SCAN_ACC_Y,
+	KMX61_SCAN_ACC_Z,
+	KMX61_SCAN_TEMP,
+	KMX61_SCAN_MAG_X,
+	KMX61_SCAN_MAG_Y,
+	KMX61_SCAN_MAG_Z,
+};
+
+static const struct {
+	u16 scale;
+	u8 gsel0;
+	u8 gsel1;
+} kmx61_scale_table[] = {
+	{9582, 0, 0},
+	{19163, 1, 0},
+	{38326, 0, 1},
+};
+
+/* KMX61 devices */
+#define KMX61_ACC	0x01
+#define KMX61_MAG	0x02
+
+static const struct {
+	int val;
+	int val2;
+	int odr_bits;
+} samp_freq_table[] = { {12, 500000, 0x00},
+			{25, 0, 0x01},
+			{50, 0, 0x02},
+			{100, 0, 0x03},
+			{200, 0, 0x04},
+			{400, 0, 0x05},
+			{800, 0, 0x06},
+			{1600, 0, 0x07},
+			{0, 781000, 0x08},
+			{1, 563000, 0x09},
+			{3, 125000, 0x0A},
+			{6, 250000, 0x0B} };
+
+static IIO_CONST_ATTR(accel_scale_available, "0.009582 0.019163 0.038326");
+static IIO_CONST_ATTR(magn_scale_available, "0.001465");
+static IIO_CONST_ATTR_SAMP_FREQ_AVAIL(
+	"0.781000 1.563000 3.125000 6.250000 12.500000 25 50 100 200 400 800");
+
+static struct attribute *kmx61_attributes[] = {
+	&iio_const_attr_accel_scale_available.dev_attr.attr,
+	&iio_const_attr_magn_scale_available.dev_attr.attr,
+	&iio_const_attr_sampling_frequency_available.dev_attr.attr,
+	NULL,
+};
+
+static const struct attribute_group kmx61_attribute_group = {
+	.attrs = kmx61_attributes,
+};
+
+#define KMX61_ACC_CHAN(_axis, _index) { \
+	.type = IIO_ACCEL, \
+	.modified = 1, \
+	.channel2 = IIO_MOD_ ## _axis, \
+	.info_mask_separate = BIT(IIO_CHAN_INFO_RAW), \
+	.info_mask_shared_by_type = BIT(IIO_CHAN_INFO_SCALE) | \
+				BIT(IIO_CHAN_INFO_SAMP_FREQ), \
+	.scan_index = _index, \
+	.scan_type = { \
+		.sign = 's', \
+		.realbits = 12, \
+		.storagebits = 16, \
+		.shift = 4, \
+		.endianness = IIO_BE, \
+	}, \
+}
+
+#define KMX61_MAG_CHAN(_axis, _index) { \
+	.type = IIO_MAGN, \
+	.modified = 1, \
+	.channel2 = IIO_MOD_ ## _axis, \
+	.info_mask_separate = BIT(IIO_CHAN_INFO_RAW), \
+	.info_mask_shared_by_type = BIT(IIO_CHAN_INFO_SCALE) | \
+				BIT(IIO_CHAN_INFO_SAMP_FREQ), \
+	.scan_index = _index, \
+	.scan_type = { \
+		.sign = 's', \
+		.realbits = 14, \
+		.storagebits = 16, \
+		.shift = 2, \
+		.endianness = IIO_BE, \
+	}, \
+}
+
+static const struct iio_chan_spec kmx61_channels[] = {
+	KMX61_ACC_CHAN(X, KMX61_SCAN_ACC_X),
+	KMX61_ACC_CHAN(Y, KMX61_SCAN_ACC_Y),
+	KMX61_ACC_CHAN(Z, KMX61_SCAN_ACC_Z),
+	KMX61_MAG_CHAN(X, KMX61_SCAN_MAG_X),
+	KMX61_MAG_CHAN(Y, KMX61_SCAN_MAG_Y),
+	KMX61_MAG_CHAN(Z, KMX61_SCAN_MAG_Z),
+};
+
+static int kmx61_convert_freq_to_bit(int val, int val2)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(samp_freq_table); i++)
+		if (val == samp_freq_table[i].val &&
+		    val2 == samp_freq_table[i].val2)
+			return samp_freq_table[i].odr_bits;
+	return -EINVAL;
+}
+
+static int kmx61_set_mode(struct kmx61_data *data, u8 mode, u8 device)
+{
+	int ret;
+
+	ret = i2c_smbus_read_byte_data(data->client, KMX61_REG_STBY);
+	if (ret < 0) {
+		dev_err(&data->client->dev, "Error reading reg_stby\n");
+		return ret;
+	}
+	if (device & KMX61_ACC) {
+		if (mode & KMX61_ACC_STBY_BIT)
+			ret |= KMX61_ACC_STBY_BIT;
+		else
+			ret &= ~KMX61_ACC_STBY_BIT;
+	}
+
+	if (device & KMX61_MAG) {
+		if (mode & KMX61_MAG_STBY_BIT)
+			ret |= KMX61_MAG_STBY_BIT;
+		else
+			ret &= ~KMX61_MAG_STBY_BIT;
+	}
+
+	ret = i2c_smbus_write_byte_data(data->client, KMX61_REG_STBY, ret);
+	if (ret < 0) {
+		dev_err(&data->client->dev, "Error writing reg_stby\n");
+		return ret;
+	}
+
+	return ret;
+}
+
+static int kmx61_get_mode(struct kmx61_data *data, u8 *mode, u8 device)
+{
+	int ret;
+
+	ret = i2c_smbus_read_byte_data(data->client, KMX61_REG_STBY);
+	if (ret < 0) {
+		dev_err(&data->client->dev, "Error reading reg_stby\n");
+		return ret;
+	}
+	*mode = 0;
+
+	if (device & KMX61_ACC) {
+		if (ret & KMX61_ACC_STBY_BIT)
+			*mode |= KMX61_ACC_STBY_BIT;
+		else
+			*mode &= ~KMX61_ACC_STBY_BIT;
+	}
+
+	if (device & KMX61_MAG) {
+		if (ret & KMX61_MAG_STBY_BIT)
+			*mode |= KMX61_MAG_STBY_BIT;
+		else
+			*mode &= ~KMX61_MAG_STBY_BIT;
+	}
+
+	return 0;
+}
+
+static int kmx61_set_odr(struct kmx61_data *data, int val, int val2, u8 device)
+{
+	int ret;
+	u8 mode;
+	int lodr_bits, odr_bits;
+
+	ret = kmx61_get_mode(data, &mode, KMX61_ACC | KMX61_MAG);
+	if (ret < 0)
+		return ret;
+
+	lodr_bits = kmx61_convert_freq_to_bit(val, val2);
+	if (lodr_bits < 0)
+		return lodr_bits;
+
+	/* To change ODR, accel and magn must be in STDBY */
+	ret = kmx61_set_mode(data, KMX61_ALL_STBY, KMX61_ACC | KMX61_MAG);
+	if (ret < 0)
+		return ret;
+
+	odr_bits = 0;
+	if (device & KMX61_ACC)
+		odr_bits |= lodr_bits;
+	if (device & KMX61_MAG)
+		odr_bits |= (lodr_bits << KMX61_MAG_ODR_SHIFT);
+
+	ret = i2c_smbus_write_byte_data(data->client, KMX61_REG_ODCNTL,
+					odr_bits);
+	if (ret < 0)
+		return ret;
+
+	ret = kmx61_set_mode(data, mode, KMX61_ACC | KMX61_MAG);
+	if (ret < 0)
+		return ret;
+
+	data->odr_bits = lodr_bits;
+
+	return 0;
+}
+
+static
+int kmx61_get_odr(struct kmx61_data *data, int *val, int *val2, u8 device)
+{	int i;
+	u8 lodr_bits;
+
+	if (device & KMX61_ACC)
+		lodr_bits = (data->odr_bits >> KMX61_ACC_ODR_SHIFT) &
+			     KMX61_ACC_ODR_MASK;
+	else if (device & KMX61_MAG)
+		lodr_bits = (data->odr_bits >> KMX61_MAG_ODR_SHIFT) &
+			     KMX61_MAG_ODR_MASK;
+	else
+		return -EINVAL;
+
+	for (i = 0; i < ARRAY_SIZE(samp_freq_table); i++)
+		if (lodr_bits == samp_freq_table[i].odr_bits) {
+			*val = samp_freq_table[i].val;
+			*val2 = samp_freq_table[i].val2;
+			return 0;
+		}
+	return -EINVAL;
+}
+
+static int kmx61_set_range(struct kmx61_data *data, int range)
+{
+	int ret;
+
+	ret = i2c_smbus_read_byte_data(data->client, KMX61_REG_CTRL1);
+	if (ret < 0) {
+		dev_err(&data->client->dev, "Error reading reg_ctrl1\n");
+		return ret;
+	}
+
+	ret &= ~(KMX61_REG_CTRL1_GSEL0_MASK | KMX61_REG_CTRL1_GSEL1_MASK);
+	ret |= kmx61_scale_table[range].gsel0 << KMX61_REG_CTRL1_GSEL0_SHIFT;
+	ret |= kmx61_scale_table[range].gsel1 << KMX61_REG_CTRL1_GSEL1_SHIFT;
+
+	ret = i2c_smbus_write_byte_data(data->client, KMX61_REG_CTRL1, ret);
+	if (ret < 0) {
+		dev_err(&data->client->dev, "Error writing reg_ctrl1\n");
+		return ret;
+	}
+
+	data->range = range;
+
+	return 0;
+}
+
+static int kmx61_set_scale(struct kmx61_data *data, int val)
+{
+	int ret, i;
+	u8  mode;
+
+	for (i = 0; i < ARRAY_SIZE(kmx61_scale_table); i++) {
+		if (kmx61_scale_table[i].scale == val) {
+			ret = kmx61_get_mode(data, &mode,
+					     KMX61_ACC | KMX61_MAG);
+			if (ret < 0)
+				return ret;
+
+			ret = kmx61_set_mode(data, KMX61_ALL_STBY,
+					     KMX61_ACC | KMX61_MAG);
+			if (ret < 0)
+				return ret;
+
+			ret = kmx61_set_range(data, i);
+			if (ret < 0)
+				return ret;
+
+			ret = kmx61_set_mode(data, mode,
+					     KMX61_ACC | KMX61_MAG);
+			if (ret < 0)
+				return ret;
+
+			return 0;
+		}
+	}
+	return -EINVAL;
+}
+
+static int kmx61_chip_init(struct kmx61_data *data)
+{
+	int ret;
+
+	ret = i2c_smbus_read_byte_data(data->client, KMX61_REG_WHO_AM_I);
+	if (ret < 0) {
+		dev_err(&data->client->dev, "Error reading who_am_i\n");
+		return ret;
+	}
+
+	if (ret != KMX61_CHIP_ID) {
+		dev_err(&data->client->dev,
+			"Wrong chip id, got %x expected %x\n",
+			 ret, KMX61_CHIP_ID);
+		return -EINVAL;
+	}
+
+	/* set accel 12bit, 4g range */
+	ret = kmx61_set_range(data, KMX61_RANGE_4G);
+	if (ret < 0)
+		return ret;
+
+	/* put accel and magnetometer in operating mode */
+	ret = kmx61_set_mode(data, 0, KMX61_ACC | KMX61_MAG);
+	if (ret < 0)
+		return ret;
+
+	return 0;
+}
+
+static int kmx61_read_measurement(struct kmx61_data *data, int base, int offset)
+{
+	int ret;
+	u8 reg = base + offset * 2;
+
+	ret = i2c_smbus_read_word_data(data->client, reg);
+	if (ret < 0) {
+		dev_err(&data->client->dev, "failed to read reg at %x\n", reg);
+		return ret;
+	}
+
+	return ret;
+}
+
+static int kmx61_read_raw(struct iio_dev *indio_dev,
+			      struct iio_chan_spec const *chan, int *val,
+			      int *val2, long mask)
+{
+	struct kmx61_data *data = iio_priv(indio_dev);
+	int ret;
+	u8 base_reg;
+	u8 device;
+
+	switch (mask) {
+	case IIO_CHAN_INFO_RAW:
+		switch (chan->type) {
+		case IIO_ACCEL: case IIO_MAGN:
+			base_reg = KMX61_ACC_XOUT_L;
+			break;
+		default:
+			return -EINVAL;
+		}
+		ret = kmx61_read_measurement(data, base_reg, chan->scan_index);
+		if (ret < 0)
+			return ret;
+		*val = sign_extend32(ret >> chan->scan_type.shift,
+				     chan->scan_type.realbits - 1);
+		return IIO_VAL_INT;
+	case IIO_CHAN_INFO_SCALE:
+		switch (chan->type) {
+		case IIO_ACCEL:
+			*val = 0;
+			*val2 = kmx61_scale_table[data->range].scale;
+			return IIO_VAL_INT_PLUS_MICRO;
+		case IIO_MAGN:
+			/* 14 bits res, 1465 microGauss per magn count */
+			*val = 0;
+			*val2 = 1465;
+			return IIO_VAL_INT_PLUS_MICRO;
+		default:
+			break;
+		}
+	case IIO_CHAN_INFO_SAMP_FREQ:
+		switch (chan->type) {
+		case IIO_ACCEL:
+			device = KMX61_ACC;
+			break;
+		case IIO_MAGN:
+			device = KMX61_MAG;
+			break;
+		default:
+			return -EINVAL;
+		}
+
+		ret = kmx61_get_odr(data, val, val2, device);
+		if (ret)
+			return -EINVAL;
+		return IIO_VAL_INT_PLUS_MICRO;
+	}
+	return -EINVAL;
+}
+
+static int kmx61_write_raw(struct iio_dev *indio_dev,
+			       struct iio_chan_spec const *chan, int val,
+			       int val2, long mask)
+{
+	struct kmx61_data *data = iio_priv(indio_dev);
+	int ret;
+	u8 device;
+
+	switch (mask) {
+	case IIO_CHAN_INFO_SAMP_FREQ:
+		switch (chan->type) {
+		case IIO_ACCEL:
+			device = KMX61_ACC;
+			break;
+		case IIO_MAGN:
+			device = KMX61_MAG;
+			break;
+		default:
+			return -EINVAL;
+		}
+		ret = kmx61_set_odr(data, val, val2, device);
+		break;
+	case IIO_CHAN_INFO_SCALE:
+		switch (chan->type) {
+		case IIO_ACCEL:
+			ret = kmx61_set_scale(data, val2);
+			break;
+		default:
+			ret  = -EINVAL;
+		}
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+static const struct iio_info kmx61_info = {
+	.driver_module		= THIS_MODULE,
+	.read_raw		= kmx61_read_raw,
+	.write_raw		= kmx61_write_raw,
+	.attrs			= &kmx61_attribute_group,
+};
+
+static int kmx61_probe(struct i2c_client *client,
+		       const struct i2c_device_id *id)
+{
+	struct kmx61_data *data;
+	struct iio_dev *indio_dev;
+	int ret;
+
+	indio_dev = devm_iio_device_alloc(&client->dev, sizeof(*data));
+	if (!indio_dev)
+		return -ENOMEM;
+
+	data = iio_priv(indio_dev);
+	i2c_set_clientdata(client, indio_dev);
+	data->client = client;
+
+	indio_dev->dev.parent = &client->dev;
+	indio_dev->info = &kmx61_info;
+	indio_dev->channels = kmx61_channels;
+	indio_dev->num_channels = ARRAY_SIZE(kmx61_channels);
+	indio_dev->modes = INDIO_DIRECT_MODE;
+
+	ret = kmx61_chip_init(data);
+	if (ret < 0)
+		return ret;
+
+	return iio_device_register(indio_dev);
+}
+
+static int kmx61_remove(struct i2c_client *client)
+{
+	struct iio_dev *indio_dev = i2c_get_clientdata(client);
+	struct kmx61_data *data = iio_priv(indio_dev);
+
+	iio_device_unregister(indio_dev);
+
+	return kmx61_set_mode(data, KMX61_ALL_STBY, KMX61_ACC | KMX61_MAG);
+}
+
+static const struct i2c_device_id kmx61_id[] = {
+	{"kmx61", 0},
+	{}
+};
+
+MODULE_DEVICE_TABLE(i2c, kmx61_id);
+
+static struct i2c_driver kmx61_driver = {
+	.driver = {
+		.name = "kmx61",
+	},
+	.probe		= kmx61_probe,
+	.remove		= kmx61_remove,
+	.id_table	= kmx61_id,
+};
+
+module_i2c_driver(kmx61_driver);
+
+MODULE_AUTHOR("Daniel Baluta <daniel.baluta@intel.com>");
+MODULE_DESCRIPTION("KMX61 accelerometer/magnetometer driver");
+MODULE_LICENSE("GPL v2");
-- 
1.9.1

