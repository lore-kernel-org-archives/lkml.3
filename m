Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751891AbaKUSTp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 13:19:45 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:60854 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbaKUSTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 13:19:42 -0500
X-AuditID: cbfec7f4-b7f6c6d00000120b-ef-546f823b18f6
From: Karol Wrona <k.wrona@samsung.com>
To: Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Karol Wrona <k.wrona@samsung.com>
Subject: [PATCH v2 4/5] iio: sensorhub: Add sensorhub accelerometer sensor
Date: Fri, 21 Nov 2014 19:19:16 +0100
Message-id: <1416593957-19788-5-git-send-email-k.wrona@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1416593957-19788-1-git-send-email-k.wrona@samsung.com>
References: <1416593957-19788-1-git-send-email-k.wrona@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrAJMWRmVeSWpSXmKPExsVy+t/xa7rWTfkhBgtmmFr8nXSM3WLjjPWs
	Fg+aVjFZnFq2n8nibNMbdot5R96xWFzeNYfNgd3j969JjB6bVnWyefRtWcXo8XmTXABLFJdN
	SmpOZllqkb5dAlfGt+uHWQsumla0vl/A2MC4V6eLkZNDQsBE4v2qa0wQtpjEhXvr2boYuTiE
	BJYySmy7+J0Zwuljkvj6+icjSBWbgLpE847FYAkRgUZGiZuL+9lAEswCHYwSi9q5uhg5OIQF
	vCS+HuECCbMIqEpsOLgQrIRXwFniZM8jRpASCQEFiTmTbEDCnAIuEu0zl4GVCAGVXL2+g30C
	I+8CRoZVjKKppckFxUnpuYZ6xYm5xaV56XrJ+bmbGCGh9GUH4+JjVocYBTgYlXh4Dzjmhgix
	JpYVV+YeYpTgYFYS4S0Xzg8R4k1JrKxKLcqPLyrNSS0+xMjEwSnVwMgyP62kwz1mdqxk8bfc
	sF3H5n4xkZOTepjlkbyH11jv11uTanb33Sm1uWvWdJeecHR0t/Fdc86uq17bbsXS/7z8R7dw
	ae/RldIzX56XFPHMO+Mui/CcjQbmLNxunlcShD4U61m9rxG37atZVRu/xmZDrE16yxebqxx/
	TlhNnT77MdMeud8vlFiKMxINtZiLihMBizM0nQMCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds accelerometer iio driver which uses sensorhub as data
provider.

Signed-off-by: Karol Wrona <k.wrona@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/iio/accel/Makefile           |    2 +
 drivers/iio/accel/ssp_accel_sensor.c |  223 ++++++++++++++++++++++++++++++++++
 2 files changed, 225 insertions(+)
 create mode 100644 drivers/iio/accel/ssp_accel_sensor.c

diff --git a/drivers/iio/accel/Makefile b/drivers/iio/accel/Makefile
index a593996..2ab1ca6 100644
--- a/drivers/iio/accel/Makefile
+++ b/drivers/iio/accel/Makefile
@@ -16,3 +16,5 @@ st_accel-$(CONFIG_IIO_BUFFER) += st_accel_buffer.o
 
 obj-$(CONFIG_IIO_ST_ACCEL_I2C_3AXIS) += st_accel_i2c.o
 obj-$(CONFIG_IIO_ST_ACCEL_SPI_3AXIS) += st_accel_spi.o
+
+obj-$(CONFIG_SSP_SENSOR_IIO) += ssp_accel_sensor.o
diff --git a/drivers/iio/accel/ssp_accel_sensor.c b/drivers/iio/accel/ssp_accel_sensor.c
new file mode 100644
index 0000000..e167479
--- /dev/null
+++ b/drivers/iio/accel/ssp_accel_sensor.c
@@ -0,0 +1,223 @@
+/*
+ *  Copyright (C) 2014, Samsung Electronics Co. Ltd. All Rights Reserved.
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ */
+
+#include <linux/iio/common/ssp_sensors.h>
+#include <linux/iio/iio.h>
+#include <linux/iio/kfifo_buf.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include "../common/ssp_sensors/ssp_iio_sensor.h"
+
+#define CHANNEL_COUNT 3
+
+#define SSP_ACCEL_NAME "ssp-accelrometer"
+static const char ssp_accel_device_name[] = SSP_ACCEL_NAME;
+
+enum accel_3d_channel {
+	CHANNEL_SCAN_INDEX_X,
+	CHANNEL_SCAN_INDEX_Y,
+	CHANNEL_SCAN_INDEX_Z,
+	CHANNEL_SCAN_INDEX_TIME,
+	ACCEL_3D_CHANNEL_MAX,
+};
+
+static int accel_read_raw(struct iio_dev *indio_dev,
+			  struct iio_chan_spec const *chan,
+			  int *val,
+			  int *val2,
+			  long mask)
+{
+	int ret;
+	u32 t;
+	struct ssp_data *data = dev_get_drvdata(indio_dev->dev.parent->parent);
+
+	switch (mask) {
+	case IIO_CHAN_INFO_SAMP_FREQ:
+		t = ssp_get_sensor_delay(data, SSP_ACCELEROMETER_SENSOR);
+		ssp_convert_to_freq(t, val, val2);
+		ret = IIO_VAL_INT_PLUS_MICRO;
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	return ret;
+}
+
+static int accel_write_raw(struct iio_dev *indio_dev,
+			   struct iio_chan_spec const *chan,
+			   int val,
+			   int val2,
+			   long mask)
+{
+	int ret, value;
+	struct ssp_data *data = dev_get_drvdata(indio_dev->dev.parent->parent);
+
+	switch (mask) {
+	case IIO_CHAN_INFO_SAMP_FREQ:
+		value = ssp_convert_to_time(val, val2);
+		ret = ssp_change_delay(data, SSP_ACCELEROMETER_SENSOR, value);
+		if (ret < 0) {
+			dev_err(&indio_dev->dev, "accel sensor enable fail\n");
+			ret = -EINVAL;
+		}
+		break;
+	default:
+		ret = -EINVAL;
+		break;
+	}
+
+	return ret;
+}
+
+static struct iio_info ssp_accel_iio_info = {
+	.read_raw = &accel_read_raw,
+	.write_raw = &accel_write_raw,
+};
+
+static const struct iio_chan_spec acc_channels[] = {
+	SSP_CHANNEL_AG(IIO_ACCEL, IIO_MOD_X, CHANNEL_SCAN_INDEX_X),
+	SSP_CHANNEL_AG(IIO_ACCEL, IIO_MOD_Y, CHANNEL_SCAN_INDEX_Y),
+	SSP_CHANNEL_AG(IIO_ACCEL, IIO_MOD_Z, CHANNEL_SCAN_INDEX_Z),
+	IIO_CHAN_SOFT_TIMESTAMP(CHANNEL_SCAN_INDEX_TIME),
+};
+
+static int process_accel_data(struct iio_dev *indio_dev, void *buf,
+			      int64_t timestamp)
+{
+	__le32 time = 0;
+	const int len = SSP_ACCELEROMETER_SIZE;
+	int64_t calculated_time;
+	char *data;
+	int ret;
+
+	if (indio_dev->scan_bytes == 0)
+		return 0;
+
+	data = kmalloc(indio_dev->scan_bytes, GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	memcpy(data, buf, len);
+
+	if (indio_dev->scan_timestamp) {
+		memcpy(&time, &((char *)buf)[len], SSP_TIME_SIZE);
+		calculated_time =
+			timestamp + (int64_t)le32_to_cpu(time) * 1000000;
+	}
+
+	ret = iio_push_to_buffers_with_timestamp(indio_dev, data,
+						  calculated_time);
+
+	kfree(data);
+
+	return ret;
+}
+
+static int ssp_accel_remove(struct platform_device *pdev)
+{
+	struct iio_dev *indio_dev = platform_get_drvdata(pdev);
+
+	iio_buffer_unregister(indio_dev);
+	iio_kfifo_free(indio_dev->buffer);
+	iio_device_unregister(indio_dev);
+	iio_device_free(indio_dev);
+
+	return 0;
+}
+
+static const struct iio_buffer_setup_ops accel_buffer_ops = {
+	.postenable = &ssp_common_buffer_postenable,
+	.predisable = &ssp_common_buffer_predisable,
+};
+
+static int ssp_accel_probe(struct platform_device *pdev)
+{
+	int ret = 0;
+	struct iio_dev *indio_dev;
+	struct ssp_sensor_data  *spd;
+
+	indio_dev = iio_device_alloc(sizeof(*spd));
+	if (IS_ERR(indio_dev)) {
+		dev_err(&pdev->dev, "device alloc fail\n");
+		return PTR_ERR(indio_dev);
+	}
+
+	spd = iio_priv(indio_dev);
+
+	spd->process_data = process_accel_data;
+	spd->type = SSP_ACCELEROMETER_SENSOR;
+
+	indio_dev->name = ssp_accel_device_name;
+	indio_dev->dev.parent = &pdev->dev;
+	indio_dev->dev.of_node = pdev->dev.of_node;
+	indio_dev->info = &ssp_accel_iio_info;
+
+	if (indio_dev->info == NULL)
+		goto err_iio_alloc;
+
+	indio_dev->modes = INDIO_BUFFER_HARDWARE;
+	indio_dev->channels = acc_channels;
+	indio_dev->num_channels = ARRAY_SIZE(acc_channels);
+
+	ret = ssp_common_setup_buffer(indio_dev, &accel_buffer_ops);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Buffer setup fail\n");
+		goto err_iio_alloc;
+	}
+
+	ret = iio_device_register(indio_dev);
+	if (ret < 0)
+		goto err_iio_buffer;
+
+	platform_set_drvdata(pdev, indio_dev);
+
+	ssp_register_consumer(indio_dev, SSP_ACCELEROMETER_SENSOR);
+
+	return 0;
+
+err_iio_buffer:
+	iio_buffer_unregister(indio_dev);
+	iio_kfifo_free(indio_dev->buffer);
+err_iio_alloc:
+	iio_device_free(indio_dev);
+
+	return ret;
+}
+
+static const struct of_device_id ssp_accel_id_table[] = {
+	{
+		.compatible = "samsung,mpu6500-accel",
+	},
+	{},
+};
+
+static struct platform_driver ssp_accel_driver = {
+	.driver = {
+		.owner = THIS_MODULE,
+		.name = SSP_ACCEL_NAME,
+		.of_match_table = ssp_accel_id_table,
+	},
+	.probe = ssp_accel_probe,
+	.remove =  ssp_accel_remove,
+};
+
+module_platform_driver(ssp_accel_driver);
+
+MODULE_AUTHOR("Karol Wrona <k.wrona@samsung.com>");
+MODULE_DESCRIPTION("Samsung sensorhub accelerometers driver");
+MODULE_LICENSE("GPL");
-- 
1.7.9.5

