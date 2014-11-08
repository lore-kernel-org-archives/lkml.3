Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889AbaKHOOi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 09:14:38 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:19186 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753832AbaKHON7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 09:13:59 -0500
X-AuditID: cbfec7f5-b7f956d000005ed7-d1-545e25213536
From: Karol Wrona <k.wrona@samsung.com>
To: Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Karol Wrona <k.wrona@samsung.com>
Subject: [PATCH 5/5] iio: sensorhub: Add sensorhub gyroscope sensor
Date: Sat, 08 Nov 2014 15:13:16 +0100
Message-id: <1415455996-20871-6-git-send-email-k.wrona@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1415455996-20871-1-git-send-email-k.wrona@samsung.com>
References: <1415455996-20871-1-git-send-email-k.wrona@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrAJMWRmVeSWpSXmKPExsVy+t/xK7qKqnEhBmuf81v8nXSM3WLjjPWs
	Fg+aVjFZnFq2n8nibNMbdot5R96xWFzeNYfNgd3j969JjB6bVnWyefRtWcXo8XmTXABLFJdN
	SmpOZllqkb5dAlfGoUnf2AuuGVdsfLqNrYHxq1YXIyeHhICJxKs3DewQtpjEhXvr2boYuTiE
	BJYySlxd3ssEkhAS6GOSuDstG8RmE1CXaN6xmBmkSESgkVHi5uJ+NpAEs0AHo8Sidi4QW1jA
	WeJk1yewZhYBVYlVOy6AbeAFir/9cQUozgG0TUFiziQbkDCngIvEqbk7oXY5S3yZ84N5AiPv
	AkaGVYyiqaXJBcVJ6blGesWJucWleel6yfm5mxghofR1B+PSY1aHGAU4GJV4eF9Mig0RYk0s
	K67MPcQowcGsJMLbex4oxJuSWFmVWpQfX1Sak1p8iJGJg1OqgZHZse+p7wGvU/Me3fOcf+KH
	9ddr8y2ddC7P/uMwefPZTM8WzorILU/zfq7XKJh589ztQKsgaemCt16arb/OFiS3BG5jemUw
	bbp/5VLzf9t5jnEoLecSrFcJ/rB6uXdPvGUNQ/9/ma7VZ07/51xufHjxR6cpdUvjK53msDR2
	fneuK+BK3HHJN1SJpTgj0VCLuag4EQD6Kei3AwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds gyroscope iio driver which uses sensorhub as data
provider.

Change-Id: Ia16bc92159d062a29957de8e62ea3fefdcd7985a
Signed-off-by: Karol Wrona <k.wrona@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/iio/gyro/Makefile          |    2 +
 drivers/iio/gyro/ssp_gyro_sensor.c |  209 ++++++++++++++++++++++++++++++++++++
 2 files changed, 211 insertions(+)
 create mode 100644 drivers/iio/gyro/ssp_gyro_sensor.c

diff --git a/drivers/iio/gyro/Makefile b/drivers/iio/gyro/Makefile
index 36a3877..a50ff87 100644
--- a/drivers/iio/gyro/Makefile
+++ b/drivers/iio/gyro/Makefile
@@ -22,3 +22,5 @@ st_gyro-$(CONFIG_IIO_BUFFER) += st_gyro_buffer.o
 
 obj-$(CONFIG_IIO_ST_GYRO_I2C_3AXIS) += st_gyro_i2c.o
 obj-$(CONFIG_IIO_ST_GYRO_SPI_3AXIS) += st_gyro_spi.o
+
+obj-$(CONFIG_SSP_SENSOR_IIO) += ssp_gyro_sensor.o
diff --git a/drivers/iio/gyro/ssp_gyro_sensor.c b/drivers/iio/gyro/ssp_gyro_sensor.c
new file mode 100644
index 0000000..b857df4
--- /dev/null
+++ b/drivers/iio/gyro/ssp_gyro_sensor.c
@@ -0,0 +1,209 @@
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
+#include "../common/ssp_sensors/ssp_iio_sensor.h"
+
+#define CHANNEL_COUNT 3
+
+#define SSP_GYROSCOPE_NAME "ssp-gyroscope"
+static const char ssp_gyro_name[] = SSP_GYROSCOPE_NAME;
+
+enum gyro_3d_channel {
+	CHANNEL_SCAN_INDEX_X,
+	CHANNEL_SCAN_INDEX_Y,
+	CHANNEL_SCAN_INDEX_Z,
+	CHANNEL_SCAN_INDEX_TIME,
+	GYRO_3D_CHANNEL_MAX,
+};
+
+static int gyro_read_raw(struct iio_dev *indio_dev,
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
+		t = ssp_get_sensor_delay(data, SSP_GYROSCOPE_SENSOR);
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
+static int gyro_write_raw(struct iio_dev *indio_dev,
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
+		ret = ssp_change_delay(data, SSP_GYROSCOPE_SENSOR, value);
+		if (ret < 0) {
+			dev_err(&indio_dev->dev, "gyro sensor enable fail\n");
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
+static struct iio_info ssp_gyro_iio_info = {
+	.read_raw = &gyro_read_raw,
+	.write_raw = &gyro_write_raw,
+};
+
+static const struct iio_chan_spec gyro_channels[] = {
+	SSP_CHANNEL_AG(IIO_ANGL_VEL, IIO_MOD_X, CHANNEL_SCAN_INDEX_X),
+	SSP_CHANNEL_AG(IIO_ANGL_VEL, IIO_MOD_Y, CHANNEL_SCAN_INDEX_Y),
+	SSP_CHANNEL_AG(IIO_ANGL_VEL, IIO_MOD_Z, CHANNEL_SCAN_INDEX_Z),
+	IIO_CHAN_SOFT_TIMESTAMP(CHANNEL_SCAN_INDEX_TIME),
+};
+
+static int process_gyro_data(struct iio_dev *indio_dev, void *buf,
+			     int64_t timestamp)
+{
+	__le32 time = 0;
+	const int len = SSP_GYROSCOPE_SIZE;
+	int64_t calculated_time;
+
+	if (indio_dev->scan_bytes == 0)
+		return indio_dev->scan_bytes;
+
+	if (indio_dev->scan_timestamp) {
+		memcpy(&time, &((char *)buf)[len], SSP_TIME_SIZE);
+		calculated_time =
+			timestamp + (int64_t)le32_to_cpu(time) * 1000000;
+	}
+
+	return iio_push_to_buffers_with_timestamp(indio_dev, buf,
+						  calculated_time);
+}
+
+static int ssp_gyro_remove(struct platform_device *pdev)
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
+static const struct iio_buffer_setup_ops gyro_buffer_ops = {
+	.postenable = &ssp_common_buffer_postenable,
+	.predisable = &ssp_common_buffer_predisable,
+};
+
+static int ssp_gyro_probe(struct platform_device *pdev)
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
+	spd->process_data = process_gyro_data;
+	spd->type = SSP_GYROSCOPE_SENSOR;
+
+	indio_dev->name = ssp_gyro_name;
+	indio_dev->dev.parent = &pdev->dev;
+	indio_dev->info = &ssp_gyro_iio_info;
+
+	if (indio_dev->info == NULL)
+		goto err_iio_alloc;
+
+	indio_dev->modes = INDIO_BUFFER_HARDWARE;
+	indio_dev->channels = gyro_channels;
+	indio_dev->num_channels = ARRAY_SIZE(gyro_channels);
+
+	ret = ssp_common_setup_buffer(indio_dev, &gyro_buffer_ops);
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
+	ssp_register_consumer(indio_dev, SSP_GYROSCOPE_SENSOR);
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
+static const struct of_device_id ssp_gyro_id_table[] = {
+	{
+		.compatible = "samsung,mpu6500-gyro",
+	},
+	{},
+};
+
+static struct platform_driver ssp_gyro_driver = {
+	.driver = {
+		.owner = THIS_MODULE,
+		.name = SSP_GYROSCOPE_NAME,
+		.of_match_table = ssp_gyro_id_table,
+	},
+	.probe = ssp_gyro_probe,
+	.remove =  ssp_gyro_remove,
+};
+
+module_platform_driver(ssp_gyro_driver);
+
+MODULE_AUTHOR("Karol Wrona <k.wrona@samsung.com>");
+MODULE_DESCRIPTION("Samsung sensorhub gyroscopes driver");
+MODULE_LICENSE("GPL");
-- 
1.7.9.5

