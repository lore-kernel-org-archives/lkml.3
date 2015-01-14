Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888AbbANQJu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 11:09:50 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:27881 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753742AbbANQJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 11:09:44 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-0e-54b694c42bf0
From: Karol Wrona <k.wrona@samsung.com>
To: Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org,
        Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>, linux-kernel@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Karol Wrona <wrona.vy@gmail.com>, Karol Wrona <k.wrona@samsung.com>
Subject: [PATCH v4 5/5] iio: common: ssp_sensors: Add sensorhub gyroscope sensor
Date: Wed, 14 Jan 2015 17:09:22 +0100
Message-id: <1421251763-26513-5-git-send-email-k.wrona@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1421251763-26513-1-git-send-email-k.wrona@samsung.com>
References: <1421251763-26513-1-git-send-email-k.wrona@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplluLIzCtJLcpLzFFi42I5/e/4Fd0jU7aFGFx6pmyxccZ6VosHTauY
	LE4t289ksev/G2aLs01v2C2WTJ7PajHvyDsWi8u75rBZ/N51jN1iz7otTA5cHjtn3WX3+PAx
	zmPTqk42jyVvDrF6nG8+wujRt2UVo8fnTXIB7FFcNimpOZllqUX6dglcGVv6l7IXPNWreD93
	AXsDY496FyMHh4SAicTXSyZdjJxAppjEhXvr2boYuTiEBJYyShxr2Ajl9DFJTO2eyQRSxSag
	LtG8YzEzSEJE4AKjxPFDW1hAHGaBNYwSZ85OYAepEhYIkNixfBsziM0ioCqx6eMEMJtXwFmi
	e+0pFojVChJzJtmAhDkFXCT2rloIFhYCKtl5THQCI+8CRoZVjKKppckFxUnpuUZ6xYm5xaV5
	6XrJ+bmbGCFB+HUH49JjVocYBTgYlXh4HY5sDRFiTSwrrsw9xCjBwawkwvu0fFuIEG9KYmVV
	alF+fFFpTmrxIUYmDk6pBsaqN8X6BZ+9azkWbEt7J60qd2J9xqWiwJzvN5VtWT/Vyeg9WTd1
	0+6AwpscbnPOqixV5PwiEGfqd/92cWsa10G/t6d+pf/+IPlK7wZD28ZjWfaNUzaqqN/43e21
	xXByWeZGXeapDexVP9o3Be36pyGnd9jhAe+sDF+2DvtEr8x1PTMfHAgyslZiKc5INNRiLipO
	BADNabBzIAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds gyroscope iio driver which uses sensorhub as data
provider.

Signed-off-by: Karol Wrona <k.wrona@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/iio/gyro/Makefile          |    2 +
 drivers/iio/gyro/ssp_gyro_sensor.c |  169 ++++++++++++++++++++++++++++++++++++
 2 files changed, 171 insertions(+)
 create mode 100644 drivers/iio/gyro/ssp_gyro_sensor.c

diff --git a/drivers/iio/gyro/Makefile b/drivers/iio/gyro/Makefile
index 36a3877..f46341b 100644
--- a/drivers/iio/gyro/Makefile
+++ b/drivers/iio/gyro/Makefile
@@ -16,6 +16,8 @@ itg3200-y               := itg3200_core.o
 itg3200-$(CONFIG_IIO_BUFFER) += itg3200_buffer.o
 obj-$(CONFIG_ITG3200)   += itg3200.o
 
+obj-$(CONFIG_IIO_SSP_SENSORS_COMMONS) += ssp_gyro_sensor.o
+
 obj-$(CONFIG_IIO_ST_GYRO_3AXIS) += st_gyro.o
 st_gyro-y := st_gyro_core.o
 st_gyro-$(CONFIG_IIO_BUFFER) += st_gyro_buffer.o
diff --git a/drivers/iio/gyro/ssp_gyro_sensor.c b/drivers/iio/gyro/ssp_gyro_sensor.c
new file mode 100644
index 0000000..311d56f
--- /dev/null
+++ b/drivers/iio/gyro/ssp_gyro_sensor.c
@@ -0,0 +1,169 @@
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
+static const unsigned long ssp_gyro_scan_mask[] = { 0x07, 0, };
+
+static const struct iio_chan_spec ssp_gyro_channels[] = {
+	SSP_CHANNEL_AG(IIO_ANGL_VEL, IIO_MOD_X, SSP_CHANNEL_SCAN_INDEX_X),
+	SSP_CHANNEL_AG(IIO_ANGL_VEL, IIO_MOD_Y, SSP_CHANNEL_SCAN_INDEX_Y),
+	SSP_CHANNEL_AG(IIO_ANGL_VEL, IIO_MOD_Z, SSP_CHANNEL_SCAN_INDEX_Z),
+	SSP_CHAN_TIMESTAMP(SSP_CHANNEL_SCAN_INDEX_TIME),
+};
+
+static int ssp_process_gyro_data(struct iio_dev *indio_dev, void *buf,
+				 int64_t timestamp)
+{
+	return ssp_common_process_data(indio_dev, buf, SSP_GYROSCOPE_SIZE,
+				       timestamp);
+}
+
+static const struct iio_buffer_setup_ops ssp_gyro_buffer_ops = {
+	.postenable = &ssp_common_buffer_postenable,
+	.postdisable = &ssp_common_buffer_postdisable,
+};
+
+static int ssp_gyro_probe(struct platform_device *pdev)
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
+	spd->process_data = ssp_process_gyro_data;
+	spd->type = SSP_GYROSCOPE_SENSOR;
+
+	indio_dev->name = ssp_gyro_name;
+	indio_dev->dev.parent = &pdev->dev;
+	indio_dev->info = &ssp_gyro_iio_info;
+	indio_dev->modes = INDIO_BUFFER_SOFTWARE;
+	indio_dev->channels = ssp_gyro_channels;
+	indio_dev->num_channels = ARRAY_SIZE(ssp_gyro_channels);
+	indio_dev->available_scan_masks = ssp_gyro_scan_mask;
+
+	buffer = devm_iio_kfifo_allocate(&pdev->dev);
+	if (!buffer)
+		return -ENOMEM;
+
+	iio_device_attach_buffer(indio_dev, buffer);
+
+	indio_dev->setup_ops = &ssp_gyro_buffer_ops;
+
+	platform_set_drvdata(pdev, indio_dev);
+
+	ret = iio_device_register(indio_dev);
+	if (ret < 0)
+		return ret;
+
+	/* ssp registering should be done after all iio setup */
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
+
+	return 0;
+}
+
+static struct platform_driver ssp_gyro_driver = {
+	.driver = {
+		.owner = THIS_MODULE,
+		.name = SSP_GYROSCOPE_NAME,
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

