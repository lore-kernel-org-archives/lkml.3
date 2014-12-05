Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383AbaLET4y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 14:56:54 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:33516 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751905AbaLET4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 14:56:09 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-54-54820dd7740d
From: Karol Wrona <k.wrona@samsung.com>
To: Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org,
        Hartmut Knaack <knaack.h@gmx.de>, linux-kernel@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Karol Wrona <wrona.vy@gmail.com>, Karol Wrona <k.wrona@samsung.com>
Subject: [PATCH v3 5/5] iio: common: ssp_sensors: Add sensorhub gyroscope sensor
Date: Fri, 05 Dec 2014 20:54:50 +0100
Message-id: <1417809290-9662-6-git-send-email-k.wrona@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1417809290-9662-1-git-send-email-k.wrona@samsung.com>
References: <1417809290-9662-1-git-send-email-k.wrona@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNJMWRmVeSWpSXmKPExsVy+t/xK7rXeZtCDJqvqllsnLGe1eJB0yom
	i1PL9jNZ7Pr/htnibNMbdot5R96xWFzeNYfNYs+6LUwOHB47Z91l9/jwMc5j06pONo++LasY
	PT5vkgtgjeKySUnNySxLLdK3S+DKeDDvM3vBR+OK9pdP2RsYZ2h3MXJySAiYSPz/84YZwhaT
	uHBvPVsXIxeHkMBSRolXf5cwQTh9TBJXHp5gA6liE1CXaN6xmBkkISLQwijx4ucuVhCHWWAN
	o8SZsxPYQaqEBQIk5l66CtbBIqAqse7HbRYQm1fASeLJlkVANgfQPgWJOZNsQMKcAs4S177N
	YAKxhYBKnh37xTyBkXcBI8MqRtHU0uSC4qT0XEO94sTc4tK8dL3k/NxNjJAA+7KDcfExq0OM
	AhyMSjy8F6wbQ4RYE8uKK3MPMUpwMCuJ8CbPBgrxpiRWVqUW5ccXleakFh9iZOLglGpgTJs+
	tyKpZ/f2klmXhZw/9L06ObVrueHLTfaHG+rmBc/3YBe75qzhx11iwloVqXd73sJVD47PmpG9
	+uD695Vcu+5uZbEsFprx4uFFxycCUgvL3pgtOH28Zqan3eI2HdPUbXVNx+9bx1b4uAf+OOWz
	/u8XtmTF0Bk1VeyyJZ6lxW8V/jh9WrEiTYmlOCPRUIu5qDgRAK6/s0wOAgAA
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
 drivers/iio/gyro/ssp_gyro_sensor.c |  202 ++++++++++++++++++++++++++++++++++++
 2 files changed, 204 insertions(+)
 create mode 100644 drivers/iio/gyro/ssp_gyro_sensor.c

diff --git a/drivers/iio/gyro/Makefile b/drivers/iio/gyro/Makefile
index 36a3877..68f1437 100644
--- a/drivers/iio/gyro/Makefile
+++ b/drivers/iio/gyro/Makefile
@@ -16,6 +16,8 @@ itg3200-y               := itg3200_core.o
 itg3200-$(CONFIG_IIO_BUFFER) += itg3200_buffer.o
 obj-$(CONFIG_ITG3200)   += itg3200.o
 
+obj-$(CONFIG_IIO_SSP_SENSOR) += ssp_gyro_sensor.o
+
 obj-$(CONFIG_IIO_ST_GYRO_3AXIS) += st_gyro.o
 st_gyro-y := st_gyro_core.o
 st_gyro-$(CONFIG_IIO_BUFFER) += st_gyro_buffer.o
diff --git a/drivers/iio/gyro/ssp_gyro_sensor.c b/drivers/iio/gyro/ssp_gyro_sensor.c
new file mode 100644
index 0000000..5820a43
--- /dev/null
+++ b/drivers/iio/gyro/ssp_gyro_sensor.c
@@ -0,0 +1,202 @@
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
+#define SSP_CHANNEL_COUNT 3
+
+#define SSP_GYROSCOPE_NAME "ssp-gyroscope"
+static const char ssp_gyro_name[] = SSP_GYROSCOPE_NAME;
+
+enum ssp_gyro_3d_channel {
+	SSP_CHANNEL_SCAN_INDEX_X,
+	SSP_CHANNEL_SCAN_INDEX_Y,
+	SSP_CHANNEL_SCAN_INDEX_Z,
+	SSP_CHANNEL_SCAN_INDEX_TIME,
+	GYRO_3D_CHANNEL_MAX,
+};
+
+static int ssp_gyro_read_raw(struct iio_dev *indio_dev,
+			     struct iio_chan_spec const *chan, int *val,
+			     int *val2, long mask)
+{
+	u32 t;
+	struct ssp_data *data = dev_get_drvdata(indio_dev->dev.parent->parent);
+
+	switch (mask) {
+	case IIO_CHAN_INFO_SAMP_FREQ:
+		t = ssp_get_sensor_delay(data, SSP_GYROSCOPE_SENSOR);
+		ssp_convert_to_freq(t, val, val2);
+		return IIO_VAL_INT_PLUS_MICRO;
+	default:
+		break;
+	}
+
+	return -EINVAL;
+}
+
+static int ssp_gyro_write_raw(struct iio_dev *indio_dev,
+			      struct iio_chan_spec const *chan, int val,
+			      int val2, long mask)
+{
+	int ret;
+	struct ssp_data *data = dev_get_drvdata(indio_dev->dev.parent->parent);
+
+	switch (mask) {
+	case IIO_CHAN_INFO_SAMP_FREQ:
+		ret = ssp_convert_to_time(val, val2);
+		ret = ssp_change_delay(data, SSP_GYROSCOPE_SENSOR, ret);
+		if (ret < 0)
+			dev_err(&indio_dev->dev, "gyro sensor enable fail\n");
+
+		return ret;
+	default:
+		break;
+	}
+
+	return -EINVAL;
+}
+
+static struct iio_info ssp_gyro_iio_info = {
+	.read_raw = &ssp_gyro_read_raw,
+	.write_raw = &ssp_gyro_write_raw,
+};
+
+static const struct iio_chan_spec ssp_gyro_channels[] = {
+	SSP_CHANNEL_AG(IIO_ANGL_VEL, IIO_MOD_X, SSP_CHANNEL_SCAN_INDEX_X),
+	SSP_CHANNEL_AG(IIO_ANGL_VEL, IIO_MOD_Y, SSP_CHANNEL_SCAN_INDEX_Y),
+	SSP_CHANNEL_AG(IIO_ANGL_VEL, IIO_MOD_Z, SSP_CHANNEL_SCAN_INDEX_Z),
+	IIO_CHAN_SOFT_TIMESTAMP(SSP_CHANNEL_SCAN_INDEX_TIME),
+};
+
+static int ssp_process_gyro_data(struct iio_dev *indio_dev, void *buf,
+				 int64_t timestamp)
+{
+	__le32 time;
+	const int len = SSP_GYROSCOPE_SIZE;
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
+						 calculated_time);
+
+	kfree(data);
+
+	return ret;
+}
+
+static const struct iio_buffer_setup_ops ssp_gyro_buffer_ops = {
+	.postenable = &ssp_common_buffer_postenable,
+	.predisable = &ssp_common_buffer_predisable,
+};
+
+static int ssp_gyro_probe(struct platform_device *pdev)
+{
+	int ret;
+	struct iio_dev *indio_dev;
+	struct ssp_sensor_data *spd;
+
+	indio_dev = iio_device_alloc(sizeof(*spd));
+	if (!indio_dev)
+		return -ENOMEM;
+
+	spd = iio_priv(indio_dev);
+
+	spd->process_data = ssp_process_gyro_data;
+	spd->type = SSP_GYROSCOPE_SENSOR;
+
+	indio_dev->name = ssp_gyro_name;
+	indio_dev->dev.parent = &pdev->dev;
+	indio_dev->info = &ssp_gyro_iio_info;
+	indio_dev->modes = INDIO_BUFFER_HARDWARE;
+	indio_dev->channels = ssp_gyro_channels;
+	indio_dev->num_channels = ARRAY_SIZE(ssp_gyro_channels);
+
+	ret = ssp_common_setup_buffer(indio_dev, &ssp_gyro_buffer_ops);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "Buffer setup fail\n");
+		return ret;
+	}
+
+	platform_set_drvdata(pdev, indio_dev);
+
+	ret = iio_device_register(indio_dev);
+	if (ret < 0) {
+		iio_buffer_unregister(indio_dev);
+		iio_kfifo_free(indio_dev->buffer);
+		return ret;
+	};
+
+	/* similar to accel */
+	ssp_register_consumer(indio_dev, SSP_GYROSCOPE_SENSOR);
+
+	return 0;
+}
+
+static int ssp_gyro_remove(struct platform_device *pdev)
+{
+	struct iio_dev *indio_dev = platform_get_drvdata(pdev);
+
+	iio_device_unregister(indio_dev);
+	iio_buffer_unregister(indio_dev);
+	iio_kfifo_free(indio_dev->buffer);
+
+	return 0;
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
+	.remove = ssp_gyro_remove,
+};
+
+module_platform_driver(ssp_gyro_driver);
+
+MODULE_AUTHOR("Karol Wrona <k.wrona@samsung.com>");
+MODULE_DESCRIPTION("Samsung sensorhub gyroscopes driver");
+MODULE_LICENSE("GPL");
-- 
1.7.9.5

