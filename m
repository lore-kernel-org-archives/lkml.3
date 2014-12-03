Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752534AbaLCNgQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 08:36:16 -0500
Received: from mga02.intel.com ([134.134.136.20]:4963 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752430AbaLCNgN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 08:36:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,507,1413270000"; 
   d="scan'208";a="647549849"
From: Daniel Baluta <daniel.baluta@intel.com>
To: jic23@kernel.org, pmeerw@pmeerw.net, srinivas.pandruvada@linux.intel.com,
        knaack.h@gmx.de
Cc: linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        daniel.baluta@intel.com
Subject: [PATCH v4 5/6] iio: imu: kmx61: Add support for data ready triggers
Date: Wed,  3 Dec 2014 15:31:52 +0200
Message-Id: <1417613513-28285-6-git-send-email-daniel.baluta@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417613513-28285-1-git-send-email-daniel.baluta@intel.com>
References: <1417613513-28285-1-git-send-email-daniel.baluta@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This creates a data ready trigger per IIO device.

Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
---
 drivers/iio/imu/Kconfig |   2 +
 drivers/iio/imu/kmx61.c | 295 +++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 296 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/imu/Kconfig b/drivers/iio/imu/Kconfig
index db4221d..5e610f7 100644
--- a/drivers/iio/imu/Kconfig
+++ b/drivers/iio/imu/Kconfig
@@ -28,6 +28,8 @@ config ADIS16480
 config KMX61
 	tristate "Kionix KMX61 6-axis accelerometer and magnetometer"
 	depends on I2C
+	select IIO_BUFFER
+	select IIO_TRIGGERED_BUFFER
 	help
 	  Say Y here if you want to build a driver for Kionix KMX61 6-axis
 	  accelerometer and magnetometer.
diff --git a/drivers/iio/imu/kmx61.c b/drivers/iio/imu/kmx61.c
index f69ae5a7..0f6816a 100644
--- a/drivers/iio/imu/kmx61.c
+++ b/drivers/iio/imu/kmx61.c
@@ -20,9 +20,14 @@
 #include <linux/pm_runtime.h>
 #include <linux/iio/iio.h>
 #include <linux/iio/sysfs.h>
+#include <linux/iio/trigger.h>
+#include <linux/iio/buffer.h>
+#include <linux/iio/triggered_buffer.h>
+#include <linux/iio/trigger_consumer.h>
 
 #define KMX61_DRV_NAME "kmx61"
 #define KMX61_GPIO_NAME "kmx61_int"
+#define KMX61_IRQ_NAME "kmx61_event"
 
 #define KMX61_REG_WHO_AM_I	0x00
 
@@ -55,9 +60,11 @@
 #define KMX61_MAG_ZOUT_L	0x16
 #define KMX61_MAG_ZOUT_H	0x17
 
+#define KMX61_REG_INL		0x28
 #define KMX61_REG_STBY		0x29
 #define KMX61_REG_CTRL1		0x2A
 #define KMX61_REG_ODCNTL	0x2C
+#define KMX61_REG_INC1		0x2D
 
 #define KMX61_ACC_STBY_BIT	BIT(0)
 #define KMX61_MAG_STBY_BIT	BIT(1)
@@ -67,6 +74,13 @@
 
 #define KMX61_REG_CTRL1_GSEL_MASK	0x03
 
+#define KMX61_REG_CTRL1_BIT_RES		BIT(4)
+#define KMX61_REG_CTRL1_BIT_DRDYE	BIT(5)
+
+#define KMX61_REG_INC1_BIT_DRDYM	BIT(1)
+#define KMX61_REG_INC1_BIT_DRDYA	BIT(2)
+#define KMX61_REG_INC1_BIT_IEN		BIT(5)
+
 #define KMX61_ACC_ODR_SHIFT	0
 #define KMX61_MAG_ODR_SHIFT	4
 #define KMX61_ACC_ODR_MASK	0x0F
@@ -100,9 +114,13 @@ struct kmx61_data {
 
 	/* accelerometer specific data */
 	struct iio_dev *acc_indio_dev;
+	struct iio_trigger *acc_dready_trig;
+	bool acc_dready_trig_on;
 
 	/* magnetometer specific data */
 	struct iio_dev *mag_indio_dev;
+	struct iio_trigger *mag_dready_trig;
+	bool mag_dready_trig_on;
 };
 
 enum kmx61_range {
@@ -466,6 +484,69 @@ static int kmx61_chip_init(struct kmx61_data *data)
 	return 0;
 }
 
+static int kmx61_setup_new_data_interrupt(struct kmx61_data *data,
+					  bool status, u8 device)
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
+	ret = i2c_smbus_read_byte_data(data->client, KMX61_REG_INC1);
+	if (ret < 0) {
+		dev_err(&data->client->dev, "Error reading reg_ctrl1\n");
+		return ret;
+	}
+
+	if (status) {
+		ret |= KMX61_REG_INC1_BIT_IEN;
+		if (device & KMX61_ACC)
+			ret |= KMX61_REG_INC1_BIT_DRDYA;
+		if (device & KMX61_MAG)
+			ret |=  KMX61_REG_INC1_BIT_DRDYM;
+	} else {
+		ret &= ~KMX61_REG_INC1_BIT_IEN;
+		if (device & KMX61_ACC)
+			ret &= ~KMX61_REG_INC1_BIT_DRDYA;
+		if (device & KMX61_MAG)
+			ret &= ~KMX61_REG_INC1_BIT_DRDYM;
+	}
+	ret = i2c_smbus_write_byte_data(data->client, KMX61_REG_INC1, ret);
+	if (ret < 0) {
+		dev_err(&data->client->dev, "Error writing reg_int_ctrl1\n");
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
+		ret |= KMX61_REG_CTRL1_BIT_DRDYE;
+	else
+		ret &= ~KMX61_REG_CTRL1_BIT_DRDYE;
+
+	ret = i2c_smbus_write_byte_data(data->client, KMX61_REG_CTRL1, ret);
+	if (ret < 0) {
+		dev_err(&data->client->dev, "Error writing reg_ctrl1\n");
+		return ret;
+	}
+
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
@@ -626,11 +707,34 @@ static int kmx61_write_raw(struct iio_dev *indio_dev,
 	}
 }
 
+static int kmx61_acc_validate_trigger(struct iio_dev *indio_dev,
+				      struct iio_trigger *trig)
+{
+	struct kmx61_data *data = kmx61_get_data(indio_dev);
+
+	if (data->acc_dready_trig != trig)
+		return -EINVAL;
+
+	return 0;
+}
+
+static int kmx61_mag_validate_trigger(struct iio_dev *indio_dev,
+				      struct iio_trigger *trig)
+{
+	struct kmx61_data *data = kmx61_get_data(indio_dev);
+
+	if (data->mag_dready_trig != trig)
+		return -EINVAL;
+
+	return 0;
+}
+
 static const struct iio_info kmx61_acc_info = {
 	.driver_module		= THIS_MODULE,
 	.read_raw		= kmx61_read_raw,
 	.write_raw		= kmx61_write_raw,
 	.attrs			= &kmx61_acc_attribute_group,
+	.validate_trigger	= kmx61_acc_validate_trigger,
 };
 
 static const struct iio_info kmx61_mag_info = {
@@ -638,8 +742,109 @@ static const struct iio_info kmx61_mag_info = {
 	.read_raw		= kmx61_read_raw,
 	.write_raw		= kmx61_write_raw,
 	.attrs			= &kmx61_mag_attribute_group,
+	.validate_trigger	= kmx61_mag_validate_trigger,
+};
+
+
+static int kmx61_data_rdy_trigger_set_state(struct iio_trigger *trig,
+					    bool state)
+{
+	int ret = 0;
+	u8 device;
+
+	struct iio_dev *indio_dev = iio_trigger_get_drvdata(trig);
+	struct kmx61_data *data = iio_priv(indio_dev);
+
+	mutex_lock(&data->lock);
+
+	if (data->acc_dready_trig == trig)
+		device = KMX61_ACC;
+	else
+		device = KMX61_MAG;
+
+	ret = kmx61_set_power_state(data, state, device);
+	if (ret < 0) {
+		mutex_unlock(&data->lock);
+		return ret;
+	}
+
+	ret = kmx61_setup_new_data_interrupt(data, state, device);
+	if (ret < 0) {
+		kmx61_set_power_state(data, false, device);
+		mutex_unlock(&data->lock);
+		return ret;
+	}
+
+	if (data->acc_dready_trig == trig)
+		data->acc_dready_trig_on = state;
+	else
+		data->mag_dready_trig_on = state;
+
+	mutex_unlock(&data->lock);
+
+	return 0;
+}
+
+static int kmx61_trig_try_reenable(struct iio_trigger *trig)
+{
+	struct iio_dev *indio_dev = iio_trigger_get_drvdata(trig);
+	struct kmx61_data *data = kmx61_get_data(indio_dev);
+	int ret;
+
+	ret = i2c_smbus_read_byte_data(data->client, KMX61_REG_INL);
+	if (ret < 0) {
+		dev_err(&data->client->dev, "Error reading reg_inl\n");
+		return ret;
+	}
+
+	return 0;
+}
+
+static const struct iio_trigger_ops kmx61_trigger_ops = {
+	.set_trigger_state = kmx61_data_rdy_trigger_set_state,
+	.try_reenable = kmx61_trig_try_reenable,
+	.owner = THIS_MODULE,
 };
 
+static irqreturn_t kmx61_data_rdy_trig_poll(int irq, void *private)
+{
+	struct kmx61_data *data = private;
+
+	if (data->acc_dready_trig_on)
+		iio_trigger_poll(data->acc_dready_trig);
+	if (data->mag_dready_trig_on)
+		iio_trigger_poll(data->mag_dready_trig);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t kmx61_trigger_handler(int irq, void *p)
+{
+	struct iio_poll_func *pf = p;
+	struct iio_dev *indio_dev = pf->indio_dev;
+	struct kmx61_data *data = kmx61_get_data(indio_dev);
+	int bit, ret, i = 0;
+	s16 buffer[8];
+
+	mutex_lock(&data->lock);
+	for_each_set_bit(bit, indio_dev->buffer->scan_mask,
+			 indio_dev->masklength) {
+		ret = kmx61_read_measurement(data, KMX61_ACC_XOUT_L, bit);
+		if (ret < 0) {
+			mutex_unlock(&data->lock);
+			goto err;
+		}
+		buffer[i++] = ret;
+	}
+	mutex_unlock(&data->lock);
+
+	iio_push_to_buffers(indio_dev, buffer);
+err:
+	iio_trigger_notify_done(indio_dev->trig);
+
+	return IRQ_HANDLED;
+}
+
 static const char *kmx61_match_acpi_device(struct device *dev)
 {
 	const struct acpi_device_id *id;
@@ -702,6 +907,32 @@ static struct iio_dev *kmx61_indiodev_setup(struct kmx61_data *data,
 	return indio_dev;
 }
 
+static struct iio_trigger *kmx61_trigger_setup(struct kmx61_data *data,
+					       struct iio_dev *indio_dev,
+					       const char *tag)
+{
+	struct iio_trigger *trig;
+	int ret;
+
+	trig = devm_iio_trigger_alloc(&data->client->dev,
+				      "%s-%s-dev%d",
+				      indio_dev->name,
+				      tag,
+				      indio_dev->id);
+	if (!trig)
+		return ERR_PTR(-ENOMEM);
+
+	trig->dev.parent = &data->client->dev;
+	trig->ops = &kmx61_trigger_ops;
+	iio_trigger_set_drvdata(trig, indio_dev);
+
+	ret = iio_trigger_register(trig);
+	if (ret)
+		return ERR_PTR(ret);
+
+	return trig;
+}
+
 static int kmx61_probe(struct i2c_client *client,
 		       const struct i2c_device_id *id)
 {
@@ -748,10 +979,55 @@ static int kmx61_probe(struct i2c_client *client,
 	if (client->irq < 0)
 		client->irq = kmx61_gpio_probe(client, data);
 
+	if (client->irq >= 0) {
+		ret = devm_request_threaded_irq(&client->dev, client->irq,
+						kmx61_data_rdy_trig_poll,
+						NULL,
+						IRQF_TRIGGER_RISING,
+						KMX61_IRQ_NAME,
+						data);
+		if (ret)
+			goto err_chip_uninit;
+
+		data->acc_dready_trig =
+			kmx61_trigger_setup(data, data->acc_indio_dev,
+					    "dready");
+		if (IS_ERR(data->acc_dready_trig))
+			return PTR_ERR(data->acc_dready_trig);
+
+		data->mag_dready_trig =
+			kmx61_trigger_setup(data, data->mag_indio_dev,
+					    "dready");
+		if (IS_ERR(data->mag_dready_trig)) {
+			ret = PTR_ERR(data->mag_dready_trig);
+			goto err_trigger_unregister;
+		}
+
+		ret = iio_triggered_buffer_setup(data->acc_indio_dev,
+						 &iio_pollfunc_store_time,
+						 kmx61_trigger_handler,
+						 NULL);
+		if (ret < 0) {
+			dev_err(&data->client->dev,
+				"Failed to setup acc triggered buffer\n");
+			goto err_trigger_unregister;
+		}
+
+		ret = iio_triggered_buffer_setup(data->mag_indio_dev,
+						 &iio_pollfunc_store_time,
+						 kmx61_trigger_handler,
+						 NULL);
+		if (ret < 0) {
+			dev_err(&data->client->dev,
+				"Failed to setup mag triggered buffer\n");
+			goto err_trigger_unregister;
+		}
+	}
+
 	ret = iio_device_register(data->acc_indio_dev);
 	if (ret < 0) {
 		dev_err(&client->dev, "Failed to register acc iio device\n");
-		goto err_chip_uninit;
+		goto err_buffer_cleanup;
 	}
 
 	ret = iio_device_register(data->mag_indio_dev);
@@ -774,6 +1050,16 @@ err_iio_unregister_mag:
 	iio_device_unregister(data->mag_indio_dev);
 err_iio_unregister_acc:
 	iio_device_unregister(data->acc_indio_dev);
+err_buffer_cleanup:
+	if (client->irq >= 0) {
+		iio_triggered_buffer_cleanup(data->acc_indio_dev);
+		iio_triggered_buffer_cleanup(data->mag_indio_dev);
+	}
+err_trigger_unregister:
+	if (data->acc_dready_trig)
+		iio_trigger_unregister(data->acc_dready_trig);
+	if (data->mag_dready_trig)
+		iio_trigger_unregister(data->mag_dready_trig);
 err_chip_uninit:
 	kmx61_set_mode(data, KMX61_ALL_STBY, KMX61_ACC | KMX61_MAG, true);
 	return ret;
@@ -790,6 +1076,13 @@ static int kmx61_remove(struct i2c_client *client)
 	iio_device_unregister(data->acc_indio_dev);
 	iio_device_unregister(data->mag_indio_dev);
 
+	if (client->irq >= 0) {
+		iio_triggered_buffer_cleanup(data->acc_indio_dev);
+		iio_triggered_buffer_cleanup(data->mag_indio_dev);
+		iio_trigger_unregister(data->acc_dready_trig);
+		iio_trigger_unregister(data->mag_dready_trig);
+	}
+
 	mutex_lock(&data->lock);
 	kmx61_set_mode(data, KMX61_ALL_STBY, KMX61_ACC | KMX61_MAG, true);
 	mutex_unlock(&data->lock);
-- 
1.9.1

