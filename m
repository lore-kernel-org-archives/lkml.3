Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753935AbbANQJw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 11:09:52 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:26943 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710AbbANQJm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 11:09:42 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-50-54b694c2348a
From: Karol Wrona <k.wrona@samsung.com>
To: Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org,
        Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>, linux-kernel@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Karol Wrona <wrona.vy@gmail.com>, Karol Wrona <k.wrona@samsung.com>
Subject: [PATCH v4 4/5] iio: common: ssp_sensors: Add sensorhub accelerometer
 sensor
Date: Wed, 14 Jan 2015 17:09:21 +0100
Message-id: <1421251763-26513-4-git-send-email-k.wrona@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1421251763-26513-1-git-send-email-k.wrona@samsung.com>
References: <1421251763-26513-1-git-send-email-k.wrona@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupjluLIzCtJLcpLzFFi42I5/e/4Fd1DU7aFGPSdULHYOGM9q8WDplVM
	FqeW7Wey2PX/DbPF2aY37BZLJs9ntZh35B2LxeVdc9gsfu86xm6xZ90WJgcuj52z7rJ7fPgY
	57FpVSebx5I3h1g9zjcfYfTo27KK0ePzJrkA9igum5TUnMyy1CJ9uwSujJ7b25gKTuhXTN24
	n6mB8Yt6FyMnh4SAicS80ztYIWwxiQv31rN1MXJxCAksZZTYNKefGcLpY5KY2j2TCaSKTUBd
	onnHYrCEiMAFRonjh7awgDjMAmsYJc6cncAOUiUsECbx6+9csA4WAVWJ1ql9jCA2r4CzRO/d
	y0A7OID2KUjMmWQDEuYUcJHYu2ohC0hYCKhk5zHRCYy8CxgZVjGKppYmFxQnpeca6hUn5haX
	5qXrJefnbmKEhOGXHYyLj1kdYhTgYFTi4dWYsC1EiDWxrLgy9xCjBAezkgjv03KgEG9KYmVV
	alF+fFFpTmrxIUYmDk6pBkaj/wvZ9m3hjJAI+aE6p//1+sdTlU8fnLvcNoQ/+leOlKHLgcXT
	5z7IPvBPRznBe13OKf/LX/rO2fuEm4qc3/h4esTnw9rvbm3Zcoyf7dSXj+2etY+bTx//Hy+5
	/pBec8DGv0z+hybXKCXPk/qiVs4Rq+Py6IF2WeKbWQWJPd3zlmmeTC+3r3BQYinOSDTUYi4q
	TgQAtOZYvCECAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds accelerometer iio driver which uses sensorhub as data
provider.

Signed-off-by: Karol Wrona <k.wrona@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/iio/accel/Makefile           |    1 +
 drivers/iio/accel/ssp_accel_sensor.c |  170 ++++++++++++++++++++++++++++++++++
 2 files changed, 171 insertions(+)
 create mode 100644 drivers/iio/accel/ssp_accel_sensor.c

diff --git a/drivers/iio/accel/Makefile b/drivers/iio/accel/Makefile
index a593996..487f520 100644
--- a/drivers/iio/accel/Makefile
+++ b/drivers/iio/accel/Makefile
@@ -9,6 +9,7 @@ obj-$(CONFIG_HID_SENSOR_ACCEL_3D) += hid-sensor-accel-3d.o
 obj-$(CONFIG_KXCJK1013) += kxcjk-1013.o
 obj-$(CONFIG_KXSD9)	+= kxsd9.o
 obj-$(CONFIG_MMA8452)	+= mma8452.o
+obj-$(CONFIG_IIO_SSP_SENSORS_COMMONS) += ssp_accel_sensor.o
 
 obj-$(CONFIG_IIO_ST_ACCEL_3AXIS) += st_accel.o
 st_accel-y := st_accel_core.o
diff --git a/drivers/iio/accel/ssp_accel_sensor.c b/drivers/iio/accel/ssp_accel_sensor.c
new file mode 100644
index 0000000..f14125a
--- /dev/null
+++ b/drivers/iio/accel/ssp_accel_sensor.c
@@ -0,0 +1,170 @@
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
+#define SSP_ACCEL_NAME "ssp-accelerometer"
+static const char ssp_accel_device_name[] = SSP_ACCEL_NAME;
+
+enum ssp_accel_3d_channel {
+	SSP_CHANNEL_SCAN_INDEX_X,
+	SSP_CHANNEL_SCAN_INDEX_Y,
+	SSP_CHANNEL_SCAN_INDEX_Z,
+	SSP_CHANNEL_SCAN_INDEX_TIME,
+};
+
+static int ssp_accel_read_raw(struct iio_dev *indio_dev,
+			      struct iio_chan_spec const *chan,  int *val,
+			      int *val2, long mask)
+{
+	u32 t;
+	struct ssp_data *data = dev_get_drvdata(indio_dev->dev.parent->parent);
+
+	switch (mask) {
+	case IIO_CHAN_INFO_SAMP_FREQ:
+		t = ssp_get_sensor_delay(data, SSP_ACCELEROMETER_SENSOR);
+		ssp_convert_to_freq(t, val, val2);
+		return IIO_VAL_INT_PLUS_MICRO;
+	default:
+		break;
+	}
+
+	return -EINVAL;
+}
+
+static int ssp_accel_write_raw(struct iio_dev *indio_dev,
+			       struct iio_chan_spec const *chan, int val,
+			       int val2, long mask)
+{
+	int ret;
+	struct ssp_data *data = dev_get_drvdata(indio_dev->dev.parent->parent);
+
+	switch (mask) {
+	case IIO_CHAN_INFO_SAMP_FREQ:
+		ret = ssp_convert_to_time(val, val2);
+		ret = ssp_change_delay(data, SSP_ACCELEROMETER_SENSOR, ret);
+		if (ret < 0)
+			dev_err(&indio_dev->dev, "accel sensor enable fail\n");
+
+		return ret;
+	default:
+		break;
+	}
+
+	return -EINVAL;
+}
+
+static struct iio_info ssp_accel_iio_info = {
+	.read_raw = &ssp_accel_read_raw,
+	.write_raw = &ssp_accel_write_raw,
+};
+
+static const unsigned long ssp_accel_scan_mask[] = { 0x7, 0, };
+
+static const struct iio_chan_spec ssp_acc_channels[] = {
+	SSP_CHANNEL_AG(IIO_ACCEL, IIO_MOD_X, SSP_CHANNEL_SCAN_INDEX_X),
+	SSP_CHANNEL_AG(IIO_ACCEL, IIO_MOD_Y, SSP_CHANNEL_SCAN_INDEX_Y),
+	SSP_CHANNEL_AG(IIO_ACCEL, IIO_MOD_Z, SSP_CHANNEL_SCAN_INDEX_Z),
+	SSP_CHAN_TIMESTAMP(SSP_CHANNEL_SCAN_INDEX_TIME),
+};
+
+static int ssp_process_accel_data(struct iio_dev *indio_dev, void *buf,
+				  int64_t timestamp)
+{
+	return ssp_common_process_data(indio_dev, buf, SSP_ACCELEROMETER_SIZE,
+				       timestamp);
+}
+
+static const struct iio_buffer_setup_ops ssp_accel_buffer_ops = {
+	.postenable = &ssp_common_buffer_postenable,
+	.postdisable = &ssp_common_buffer_postdisable,
+};
+
+static int ssp_accel_probe(struct platform_device *pdev)
+{
+	int ret;
+	struct iio_dev *indio_dev;
+	struct ssp_sensor_data *spd;
+	struct iio_buffer *buffer;
+
+	indio_dev = devm_iio_device_alloc(&pdev->dev, sizeof(*spd));
+	if (!indio_dev)
+		return -ENOMEM;
+
+	spd = iio_priv(indio_dev);
+
+	spd->process_data = ssp_process_accel_data;
+	spd->type = SSP_ACCELEROMETER_SENSOR;
+
+	indio_dev->name = ssp_accel_device_name;
+	indio_dev->dev.parent = &pdev->dev;
+	indio_dev->dev.of_node = pdev->dev.of_node;
+	indio_dev->info = &ssp_accel_iio_info;
+	indio_dev->modes = INDIO_BUFFER_SOFTWARE;
+	indio_dev->channels = ssp_acc_channels;
+	indio_dev->num_channels = ARRAY_SIZE(ssp_acc_channels);
+	indio_dev->available_scan_masks = ssp_accel_scan_mask;
+
+	buffer = devm_iio_kfifo_allocate(&pdev->dev);
+	if (!buffer)
+		return -ENOMEM;
+
+	iio_device_attach_buffer(indio_dev, buffer);
+
+	indio_dev->setup_ops = &ssp_accel_buffer_ops;
+
+	platform_set_drvdata(pdev, indio_dev);
+
+	ret = iio_device_register(indio_dev);
+	if (ret < 0)
+		return ret;
+
+	/* ssp registering should be done after all iio setup */
+	ssp_register_consumer(indio_dev, SSP_ACCELEROMETER_SENSOR);
+
+	return 0;
+}
+
+static int ssp_accel_remove(struct platform_device *pdev)
+{
+	struct iio_dev *indio_dev = platform_get_drvdata(pdev);
+
+	iio_device_unregister(indio_dev);
+
+	return 0;
+}
+
+static struct platform_driver ssp_accel_driver = {
+	.driver = {
+		.owner = THIS_MODULE,
+		.name = SSP_ACCEL_NAME,
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

