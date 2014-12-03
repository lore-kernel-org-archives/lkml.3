Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752574AbaLCNsI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 08:48:08 -0500
Received: from mga03.intel.com ([134.134.136.65]:37524 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751936AbaLCNsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 08:48:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,507,1413270000"; 
   d="scan'208";a="647549865"
From: Daniel Baluta <daniel.baluta@intel.com>
To: jic23@kernel.org, pmeerw@pmeerw.net, srinivas.pandruvada@linux.intel.com,
        knaack.h@gmx.de
Cc: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        daniel.baluta@intel.com
Subject: [PATCH v4 6/6] iio: imu: kmx61: Add support for any motion trigger
Date: Wed,  3 Dec 2014 15:31:53 +0200
Message-Id: <1417613513-28285-7-git-send-email-daniel.baluta@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417613513-28285-1-git-send-email-daniel.baluta@intel.com>
References: <1417613513-28285-1-git-send-email-daniel.baluta@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We use WUFE (Wake Up from Sleep Engine) and BTSE (Back to Sleep Engine)
to detect general motion input.

Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
---
 drivers/iio/imu/kmx61.c | 433 +++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 426 insertions(+), 7 deletions(-)

diff --git a/drivers/iio/imu/kmx61.c b/drivers/iio/imu/kmx61.c
index 0f6816a..972424b 100644
--- a/drivers/iio/imu/kmx61.c
+++ b/drivers/iio/imu/kmx61.c
@@ -20,6 +20,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/iio/iio.h>
 #include <linux/iio/sysfs.h>
+#include <linux/iio/events.h>
 #include <linux/iio/trigger.h>
 #include <linux/iio/buffer.h>
 #include <linux/iio/triggered_buffer.h>
@@ -30,6 +31,8 @@
 #define KMX61_IRQ_NAME "kmx61_event"
 
 #define KMX61_REG_WHO_AM_I	0x00
+#define KMX61_REG_INS1		0x01
+#define KMX61_REG_INS2		0x02
 
 /*
  * three 16-bit accelerometer output registers for X/Y/Z axis
@@ -63,20 +66,36 @@
 #define KMX61_REG_INL		0x28
 #define KMX61_REG_STBY		0x29
 #define KMX61_REG_CTRL1		0x2A
+#define KMX61_REG_CTRL2		0x2B
 #define KMX61_REG_ODCNTL	0x2C
 #define KMX61_REG_INC1		0x2D
 
+#define KMX61_REG_WUF_THRESH	0x3D
+#define KMX61_REG_WUF_TIMER	0x3E
+
 #define KMX61_ACC_STBY_BIT	BIT(0)
 #define KMX61_MAG_STBY_BIT	BIT(1)
 #define KMX61_ACT_STBY_BIT	BIT(7)
 
 #define KMX61_ALL_STBY		(KMX61_ACC_STBY_BIT | KMX61_MAG_STBY_BIT)
 
+#define KMX61_REG_INS1_BIT_WUFS		BIT(1)
+
+#define KMX61_REG_INS2_BIT_ZP		BIT(0)
+#define KMX61_REG_INS2_BIT_ZN		BIT(1)
+#define KMX61_REG_INS2_BIT_YP		BIT(2)
+#define KMX61_REG_INS2_BIT_YN		BIT(3)
+#define KMX61_REG_INS2_BIT_XP		BIT(4)
+#define KMX61_REG_INS2_BIT_XN		BIT(5)
+
 #define KMX61_REG_CTRL1_GSEL_MASK	0x03
 
 #define KMX61_REG_CTRL1_BIT_RES		BIT(4)
 #define KMX61_REG_CTRL1_BIT_DRDYE	BIT(5)
+#define KMX61_REG_CTRL1_BIT_WUFE	BIT(6)
+#define KMX61_REG_CTRL1_BIT_BTSE	BIT(7)
 
+#define KMX61_REG_INC1_BIT_WUFS		BIT(0)
 #define KMX61_REG_INC1_BIT_DRDYM	BIT(1)
 #define KMX61_REG_INC1_BIT_DRDYA	BIT(2)
 #define KMX61_REG_INC1_BIT_IEN		BIT(5)
@@ -86,6 +105,11 @@
 #define KMX61_ACC_ODR_MASK	0x0F
 #define KMX61_MAG_ODR_MASK	0xF0
 
+#define KMX61_OWUF_MASK		0x7
+
+#define KMX61_DEFAULT_WAKE_THRESH	1
+#define KMX61_DEFAULT_WAKE_DURATION	1
+
 #define KMX61_SLEEP_DELAY_MS	2000
 
 #define KMX61_CHIP_ID		0x12
@@ -111,11 +135,16 @@ struct kmx61_data {
 	/* config bits */
 	u8 range;
 	u8 odr_bits;
+	u8 wake_thresh;
+	u8 wake_duration;
 
 	/* accelerometer specific data */
 	struct iio_dev *acc_indio_dev;
 	struct iio_trigger *acc_dready_trig;
+	struct iio_trigger *motion_trig;
 	bool acc_dready_trig_on;
+	bool motion_trig_on;
+	bool ev_enable_state;
 
 	/* magnetometer specific data */
 	struct iio_dev *mag_indio_dev;
@@ -154,6 +183,23 @@ static const struct {
 			{3, 125000, 0x0A},
 			{6, 250000, 0x0B} };
 
+static const struct {
+	int val;
+	int val2;
+	int odr_bits;
+} kmx61_wake_up_odr_table[] = { {0, 781000, 0x00},
+				 {1, 563000, 0x01},
+				 {3, 125000, 0x02},
+				 {6, 250000, 0x03},
+				 {12, 500000, 0x04},
+				 {25, 0, 0x05},
+				 {50, 0, 0x06},
+				 {100, 0, 0x06},
+				 {200, 0, 0x06},
+				 {400, 0, 0x06},
+				 {800, 0, 0x06},
+				 {1600, 0, 0x06} };
+
 static IIO_CONST_ATTR(accel_scale_available, "0.009582 0.019163 0.038326");
 static IIO_CONST_ATTR(magn_scale_available, "0.001465");
 static IIO_CONST_ATTR_SAMP_FREQ_AVAIL(
@@ -179,6 +225,14 @@ static const struct attribute_group kmx61_mag_attribute_group = {
 	.attrs = kmx61_mag_attributes,
 };
 
+static const struct iio_event_spec kmx61_event = {
+	.type = IIO_EV_TYPE_THRESH,
+	.dir = IIO_EV_DIR_EITHER,
+	.mask_separate = BIT(IIO_EV_INFO_VALUE) |
+			 BIT(IIO_EV_INFO_ENABLE) |
+			 BIT(IIO_EV_INFO_PERIOD),
+};
+
 #define KMX61_ACC_CHAN(_axis) { \
 	.type = IIO_ACCEL, \
 	.modified = 1, \
@@ -195,6 +249,8 @@ static const struct attribute_group kmx61_mag_attribute_group = {
 		.shift = 4, \
 		.endianness = IIO_LE, \
 	}, \
+	.event_spec = &kmx61_event, \
+	.num_event_specs = 1 \
 }
 
 #define KMX61_MAG_CHAN(_axis) { \
@@ -250,6 +306,31 @@ static int kmx61_convert_freq_to_bit(int val, int val2)
 	return -EINVAL;
 }
 
+static int kmx61_convert_bit_to_freq(u8 odr_bits, int *val, int *val2)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(kmx61_samp_freq_table); i++)
+		if (odr_bits == kmx61_samp_freq_table[i].odr_bits) {
+			*val = kmx61_samp_freq_table[i].val;
+			*val2 = kmx61_samp_freq_table[i].val2;
+			return 0;
+		}
+	return -EINVAL;
+}
+
+
+static int kmx61_convert_wake_up_odr_to_bit(int val, int val2)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(kmx61_wake_up_odr_table); ++i)
+		if (kmx61_wake_up_odr_table[i].val == val &&
+			kmx61_wake_up_odr_table[i].val2 == val2)
+				return kmx61_wake_up_odr_table[i].odr_bits;
+	return -EINVAL;
+}
+
 /**
  * kmx61_set_mode() - set KMX61 device operating mode
  * @data - kmx61 device private data pointer
@@ -338,6 +419,21 @@ static int kmx61_get_mode(struct kmx61_data *data, u8 *mode, u8 device)
 	return 0;
 }
 
+int kmx61_set_wake_up_odr(struct kmx61_data *data, int val, int val2)
+{
+	int ret, odr_bits;
+
+	odr_bits = kmx61_convert_wake_up_odr_to_bit(val, val2);
+	if (odr_bits < 0)
+		return odr_bits;
+
+	ret = i2c_smbus_write_byte_data(data->client, KMX61_REG_CTRL2,
+					odr_bits);
+	if (ret < 0)
+		dev_err(&data->client->dev, "Error writing reg_ctrl2\n");
+	return ret;
+}
+
 static int kmx61_set_odr(struct kmx61_data *data, int val, int val2, u8 device)
 {
 	int ret;
@@ -369,6 +465,12 @@ static int kmx61_set_odr(struct kmx61_data *data, int val, int val2, u8 device)
 	if (ret < 0)
 		return ret;
 
+	if (device & KMX61_ACC) {
+		ret = kmx61_set_wake_up_odr(data, val, val2);
+		if (ret)
+			return ret;
+	}
+
 	return kmx61_set_mode(data, mode, KMX61_ACC | KMX61_MAG, true);
 }
 
@@ -449,7 +551,7 @@ static int kmx61_set_scale(struct kmx61_data *data, u16 uscale)
 
 static int kmx61_chip_init(struct kmx61_data *data)
 {
-	int ret;
+	int ret, val, val2;
 
 	ret = i2c_smbus_read_byte_data(data->client, KMX61_REG_WHO_AM_I);
 	if (ret < 0) {
@@ -476,11 +578,23 @@ static int kmx61_chip_init(struct kmx61_data *data)
 	}
 	data->odr_bits = ret;
 
+	/* set output data rate for wake up (motion detection) function */
+	ret = kmx61_convert_bit_to_freq(data->odr_bits, &val, &val2);
+	if (ret < 0)
+		return ret;
+
+	ret = kmx61_set_wake_up_odr(data, val, val2);
+	if (ret < 0)
+		return ret;
+
 	/* set acc/magn to OPERATION mode */
 	ret = kmx61_set_mode(data, 0, KMX61_ACC | KMX61_MAG, true);
 	if (ret < 0)
 		return ret;
 
+	data->wake_thresh = KMX61_DEFAULT_WAKE_THRESH;
+	data->wake_duration = KMX61_DEFAULT_WAKE_DURATION;
+
 	return 0;
 }
 
@@ -547,6 +661,87 @@ static int kmx61_setup_new_data_interrupt(struct kmx61_data *data,
 	return 0;
 }
 
+static int kmx61_chip_update_thresholds(struct kmx61_data *data)
+{
+	int ret;
+
+	ret = i2c_smbus_write_byte_data(data->client,
+					KMX61_REG_WUF_TIMER,
+					data->wake_duration);
+	if (ret < 0) {
+		dev_err(&data->client->dev, "Errow writing reg_wuf_timer\n");
+		return ret;
+	}
+
+	ret = i2c_smbus_write_byte_data(data->client,
+					KMX61_REG_WUF_THRESH,
+					data->wake_thresh);
+	if (ret < 0) {
+		dev_err(&data->client->dev, "Error writing reg_wuf_thresh\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static int kmx61_setup_any_motion_interrupt(struct kmx61_data *data,
+					    bool status, u8 device)
+{
+	u8 mode;
+	int ret;
+
+	ret = kmx61_get_mode(data, &mode, KMX61_ACC | KMX61_MAG);
+	if (ret < 0)
+		return ret;
+
+	ret = kmx61_set_mode(data, KMX61_ALL_STBY, KMX61_ACC | KMX61_MAG, true);
+	if (ret < 0)
+		return ret;
+
+	ret = kmx61_chip_update_thresholds(data);
+	if (ret < 0)
+		return ret;
+
+	ret = i2c_smbus_read_byte_data(data->client, KMX61_REG_INC1);
+	if (ret < 0) {
+		dev_err(&data->client->dev, "Error reading reg_inc1\n");
+		return ret;
+	}
+	if (status)
+		ret |= (KMX61_REG_INC1_BIT_IEN | KMX61_REG_INC1_BIT_WUFS);
+	else
+		ret &= ~(KMX61_REG_INC1_BIT_IEN | KMX61_REG_INC1_BIT_WUFS);
+
+	ret = i2c_smbus_write_byte_data(data->client, KMX61_REG_INC1, ret);
+	if (ret < 0) {
+		dev_err(&data->client->dev, "Error writing reg_inc1\n");
+		return ret;
+	}
+
+	ret = i2c_smbus_read_byte_data(data->client, KMX61_REG_CTRL1);
+	if (ret < 0) {
+		dev_err(&data->client->dev, "Error reading reg_ctrl1\n");
+		return ret;
+	}
+
+	if (status)
+		ret |= KMX61_REG_CTRL1_BIT_WUFE | KMX61_REG_CTRL1_BIT_BTSE;
+	else
+		ret &= ~(KMX61_REG_CTRL1_BIT_WUFE | KMX61_REG_CTRL1_BIT_BTSE);
+
+	ret = i2c_smbus_write_byte_data(data->client, KMX61_REG_CTRL1, ret);
+	if (ret < 0) {
+		dev_err(&data->client->dev, "Error writing reg_ctrl1\n");
+		return ret;
+	}
+	mode |= KMX61_ACT_STBY_BIT;
+	ret = kmx61_set_mode(data, mode, KMX61_ACC | KMX61_MAG, true);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
 /**
  * kmx61_set_power_state() - set power state for kmx61 @device
  * @data - kmx61 device private pointer
@@ -707,12 +902,111 @@ static int kmx61_write_raw(struct iio_dev *indio_dev,
 	}
 }
 
+static int kmx61_read_event(struct iio_dev *indio_dev,
+			    const struct iio_chan_spec *chan,
+			    enum iio_event_type type,
+			    enum iio_event_direction dir,
+			    enum iio_event_info info,
+			    int *val, int *val2)
+{
+	struct kmx61_data *data = kmx61_get_data(indio_dev);
+
+	*val2 = 0;
+	switch (info) {
+	case IIO_EV_INFO_VALUE:
+		*val = data->wake_thresh;
+		break;
+	case IIO_EV_INFO_PERIOD:
+		*val = data->wake_duration;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return IIO_VAL_INT;
+}
+
+static int kmx61_write_event(struct iio_dev *indio_dev,
+			    const struct iio_chan_spec *chan,
+			    enum iio_event_type type,
+			    enum iio_event_direction dir,
+			    enum iio_event_info info,
+			    int val, int val2)
+{
+	struct kmx61_data *data = kmx61_get_data(indio_dev);
+
+	if (data->ev_enable_state)
+		return -EBUSY;
+
+	switch (info) {
+	case IIO_EV_INFO_VALUE:
+		data->wake_thresh = val;
+		break;
+	case IIO_EV_INFO_PERIOD:
+		data->wake_duration = val;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	return IIO_VAL_INT;
+}
+
+static int kmx61_read_event_config(struct iio_dev *indio_dev,
+				   const struct iio_chan_spec *chan,
+				   enum iio_event_type type,
+				   enum iio_event_direction dir)
+{
+	struct kmx61_data *data = kmx61_get_data(indio_dev);
+
+	return data->ev_enable_state;
+}
+
+static int kmx61_write_event_config(struct iio_dev *indio_dev,
+				   const struct iio_chan_spec *chan,
+				   enum iio_event_type type,
+				   enum iio_event_direction dir,
+				   int state)
+{
+	struct kmx61_data *data = kmx61_get_data(indio_dev);
+	int ret;
+
+	if (state && data->ev_enable_state)
+		return 0;
+
+	mutex_lock(&data->lock);
+
+	if (!state && data->motion_trig_on) {
+		data->ev_enable_state = 0;
+		mutex_unlock(&data->lock);
+		return 0;
+	}
+
+	ret = kmx61_set_power_state(data, state, KMX61_ACC);
+	if (ret < 0) {
+		mutex_unlock(&data->lock);
+		return ret;
+	}
+
+	ret = kmx61_setup_any_motion_interrupt(data, state, KMX61_ACC);
+	if (ret < 0) {
+		kmx61_set_power_state(data, false, KMX61_ACC);
+		mutex_unlock(&data->lock);
+		return ret;
+	}
+
+	data->ev_enable_state = state;
+	mutex_unlock(&data->lock);
+
+	return 0;
+}
+
 static int kmx61_acc_validate_trigger(struct iio_dev *indio_dev,
 				      struct iio_trigger *trig)
 {
 	struct kmx61_data *data = kmx61_get_data(indio_dev);
 
-	if (data->acc_dready_trig != trig)
+	if (data->acc_dready_trig != trig && data->motion_trig != trig)
 		return -EINVAL;
 
 	return 0;
@@ -734,6 +1028,10 @@ static const struct iio_info kmx61_acc_info = {
 	.read_raw		= kmx61_read_raw,
 	.write_raw		= kmx61_write_raw,
 	.attrs			= &kmx61_acc_attribute_group,
+	.read_event_value	= kmx61_read_event,
+	.write_event_value	= kmx61_write_event,
+	.read_event_config	= kmx61_read_event_config,
+	.write_event_config	= kmx61_write_event_config,
 	.validate_trigger	= kmx61_acc_validate_trigger,
 };
 
@@ -753,11 +1051,18 @@ static int kmx61_data_rdy_trigger_set_state(struct iio_trigger *trig,
 	u8 device;
 
 	struct iio_dev *indio_dev = iio_trigger_get_drvdata(trig);
-	struct kmx61_data *data = iio_priv(indio_dev);
+	struct kmx61_data *data = kmx61_get_data(indio_dev);
 
 	mutex_lock(&data->lock);
 
-	if (data->acc_dready_trig == trig)
+	if (!state && data->ev_enable_state && data->motion_trig_on) {
+		data->motion_trig_on = false;
+		mutex_unlock(&data->lock);
+		return 0;
+	}
+
+
+	if (data->acc_dready_trig == trig || data->motion_trig)
 		device = KMX61_ACC;
 	else
 		device = KMX61_MAG;
@@ -768,7 +1073,10 @@ static int kmx61_data_rdy_trigger_set_state(struct iio_trigger *trig,
 		return ret;
 	}
 
-	ret = kmx61_setup_new_data_interrupt(data, state, device);
+	if (data->acc_dready_trig == trig || data->mag_dready_trig == trig)
+		ret = kmx61_setup_new_data_interrupt(data, state, device);
+	else
+		ret = kmx61_setup_any_motion_interrupt(data, state, KMX61_ACC);
 	if (ret < 0) {
 		kmx61_set_power_state(data, false, device);
 		mutex_unlock(&data->lock);
@@ -777,8 +1085,10 @@ static int kmx61_data_rdy_trigger_set_state(struct iio_trigger *trig,
 
 	if (data->acc_dready_trig == trig)
 		data->acc_dready_trig_on = state;
-	else
+	else if (data->mag_dready_trig == trig)
 		data->mag_dready_trig_on = state;
+	else
+		data->motion_trig_on = state;
 
 	mutex_unlock(&data->lock);
 
@@ -806,6 +1116,99 @@ static const struct iio_trigger_ops kmx61_trigger_ops = {
 	.owner = THIS_MODULE,
 };
 
+static irqreturn_t kmx61_event_handler(int irq, void *private)
+{
+	struct kmx61_data *data = private;
+	struct iio_dev *indio_dev = data->acc_indio_dev;
+	int ret;
+
+	ret = i2c_smbus_read_byte_data(data->client, KMX61_REG_INS1);
+	if (ret < 0) {
+		dev_err(&data->client->dev, "Error reading reg_ins1\n");
+		goto ack_intr;
+	}
+
+	if (ret & KMX61_REG_INS1_BIT_WUFS) {
+		ret = i2c_smbus_read_byte_data(data->client, KMX61_REG_INS2);
+		if (ret < 0) {
+			dev_err(&data->client->dev, "Error reading reg_ins2\n");
+			goto ack_intr;
+		}
+
+		if (ret & KMX61_REG_INS2_BIT_XN)
+			iio_push_event(indio_dev,
+				       IIO_MOD_EVENT_CODE(IIO_ACCEL,
+				       0,
+				       IIO_MOD_X,
+				       IIO_EV_TYPE_THRESH,
+				       IIO_EV_DIR_FALLING),
+				       0);
+
+		if (ret & KMX61_REG_INS2_BIT_XP)
+			iio_push_event(indio_dev,
+				       IIO_MOD_EVENT_CODE(IIO_ACCEL,
+				       0,
+				       IIO_MOD_X,
+				       IIO_EV_TYPE_THRESH,
+				       IIO_EV_DIR_RISING),
+				       0);
+
+		if (ret & KMX61_REG_INS2_BIT_YN)
+			iio_push_event(indio_dev,
+				       IIO_MOD_EVENT_CODE(IIO_ACCEL,
+				       0,
+				       IIO_MOD_Y,
+				       IIO_EV_TYPE_THRESH,
+				       IIO_EV_DIR_FALLING),
+				       0);
+
+		if (ret & KMX61_REG_INS2_BIT_YP)
+			iio_push_event(indio_dev,
+				       IIO_MOD_EVENT_CODE(IIO_ACCEL,
+				       0,
+				       IIO_MOD_Y,
+				       IIO_EV_TYPE_THRESH,
+				       IIO_EV_DIR_RISING),
+				       0);
+
+		if (ret & KMX61_REG_INS2_BIT_ZN)
+			iio_push_event(indio_dev,
+				       IIO_MOD_EVENT_CODE(IIO_ACCEL,
+				       0,
+				       IIO_MOD_Z,
+				       IIO_EV_TYPE_THRESH,
+				       IIO_EV_DIR_FALLING),
+				       0);
+
+		if (ret & KMX61_REG_INS2_BIT_ZP)
+			iio_push_event(indio_dev,
+				       IIO_MOD_EVENT_CODE(IIO_ACCEL,
+				       0,
+				       IIO_MOD_Z,
+				       IIO_EV_TYPE_THRESH,
+				       IIO_EV_DIR_RISING),
+				       0);
+	}
+
+ack_intr:
+	ret = i2c_smbus_read_byte_data(data->client, KMX61_REG_CTRL1);
+	if (ret < 0)
+		dev_err(&data->client->dev, "Error reading reg_ctrl1\n");
+
+	ret |= KMX61_REG_CTRL1_BIT_RES;
+	ret = i2c_smbus_write_byte_data(data->client, KMX61_REG_CTRL1, ret);
+	if (ret < 0)
+		dev_err(&data->client->dev, "Error reading reg_ctrl1\n");
+
+	ret = i2c_smbus_read_byte_data(data->client, KMX61_REG_INL);
+	if (ret < 0)
+		dev_err(&data->client->dev, "Error reading reg_inl\n");
+
+	ret = i2c_smbus_read_byte_data(data->client, KMX61_REG_INS1);
+
+	return IRQ_HANDLED;
+}
+
 static irqreturn_t kmx61_data_rdy_trig_poll(int irq, void *private)
 {
 	struct kmx61_data *data = private;
@@ -815,6 +1218,11 @@ static irqreturn_t kmx61_data_rdy_trig_poll(int irq, void *private)
 	if (data->mag_dready_trig_on)
 		iio_trigger_poll(data->mag_dready_trig);
 
+	if (data->motion_trig_on)
+		iio_trigger_poll(data->motion_trig);
+
+	if (data->ev_enable_state)
+		return IRQ_WAKE_THREAD;
 	return IRQ_HANDLED;
 }
 
@@ -982,7 +1390,7 @@ static int kmx61_probe(struct i2c_client *client,
 	if (client->irq >= 0) {
 		ret = devm_request_threaded_irq(&client->dev, client->irq,
 						kmx61_data_rdy_trig_poll,
-						NULL,
+						kmx61_event_handler,
 						IRQF_TRIGGER_RISING,
 						KMX61_IRQ_NAME,
 						data);
@@ -1003,6 +1411,14 @@ static int kmx61_probe(struct i2c_client *client,
 			goto err_trigger_unregister;
 		}
 
+		data->motion_trig =
+			kmx61_trigger_setup(data, data->acc_indio_dev,
+					    "any-motion");
+		if (IS_ERR(data->motion_trig)) {
+			ret = PTR_ERR(data->motion_trig);
+			goto err_trigger_unregister;
+		}
+
 		ret = iio_triggered_buffer_setup(data->acc_indio_dev,
 						 &iio_pollfunc_store_time,
 						 kmx61_trigger_handler,
@@ -1060,6 +1476,8 @@ err_trigger_unregister:
 		iio_trigger_unregister(data->acc_dready_trig);
 	if (data->mag_dready_trig)
 		iio_trigger_unregister(data->mag_dready_trig);
+	if (data->motion_trig)
+		iio_trigger_unregister(data->motion_trig);
 err_chip_uninit:
 	kmx61_set_mode(data, KMX61_ALL_STBY, KMX61_ACC | KMX61_MAG, true);
 	return ret;
@@ -1081,6 +1499,7 @@ static int kmx61_remove(struct i2c_client *client)
 		iio_triggered_buffer_cleanup(data->mag_indio_dev);
 		iio_trigger_unregister(data->acc_dready_trig);
 		iio_trigger_unregister(data->mag_dready_trig);
+		iio_trigger_unregister(data->motion_trig);
 	}
 
 	mutex_lock(&data->lock);
-- 
1.9.1

