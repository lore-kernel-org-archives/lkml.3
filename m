Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761548AbbA1WMg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 17:12:36 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:37132 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932102AbbA1UQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:16:52 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-a1-54c8ec61cebe
From: Karol Wrona <k.wrona@samsung.com>
To: Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Karol Wrona <wrona.vy@gmail.com>, Karol Wrona <k.wrona@samsung.com>
Subject: [PATCH v5 4/5] iio: common: ssp_sensors: Add sensorhub accelerometer
 sensor
Date: Wed, 28 Jan 2015 15:05:53 +0100
Message-id: <1422453954-27317-5-git-send-email-k.wrona@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1422453954-27317-1-git-send-email-k.wrona@samsung.com>
References: <1422453954-27317-1-git-send-email-k.wrona@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBLMWRmVeSWpSXmKPExsVy+t/xy7qJb06EGGy/xmixccZ6Vov5R86x
	WvS/Wchqce7VSkaLB02rmCxOLdvPZLHr/xtmi7NNb9gtlkyez2ox78g7FovLu+awWSy9fpHJ
	YsL0tSwWv3cdY7do3XuE3WLPui1MDgIea+atYfS43NfL5LFz1l12jw8f4zxWLv/C5rFpVSeb
	x5I3h1g9zjcfYfTo27KK0ePzJrkArigum5TUnMyy1CJ9uwSujFnz9zEWzNCv6OsXbGA8pd7F
	yMkhIWAisWrebmYIW0ziwr31bF2MXBxCAksZJXrWHWeEcPqYJDpmPAWrYhNQl2jesRjMFhGo
	kziyeisLSBGzwG1miY7mD+wgCWGBMIkzGy8AdXNwsAioShxaHQ9i8go4S6z4ZAZiSggoSMyZ
	ZANSzCngIjFl2182EFsIqOLk9vusExh5FzAyrGIUTS1NLihOSs811CtOzC0uzUvXS87P3cQI
	Ce0vOxgXH7M6xCjAwajEw/vC7ESIEGtiWXFl7iFGCQ5mJRHex3uBQrwpiZVVqUX58UWlOanF
	hxiZODilGhiZbmTJfNoxs/zMZ3u9yc7ynbyS60/9OZJS9VffxvZLbSA/03kFuWlKjEc5eO5N
	P2rGpGf6fevy7rUvo9k79JMlajXFmRh06mrv7JzZ9dk1PcBRu1XFxqZ3mT938zfW1TH5If87
	XrQbcezUubKc1dw/4hLnttRFzWs6JAWO/nJabdkmVblylRJLcUaioRZzUXEiAMuuE1NLAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds accelerometer iio driver which uses sensorhub as data
provider.

Signed-off-by: Karol Wrona <k.wrona@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/iio/accel/Makefile           |    1 +
 drivers/iio/accel/ssp_accel_sensor.c |  169 ++++++++++++++++++++++++++++++++++
 2 files changed, 170 insertions(+)
 create mode 100644 drivers/iio/accel/ssp_accel_sensor.c

diff --git a/drivers/iio/accel/Makefile b/drivers/iio/accel/Makefile
index de5b9cb..69c64b6 100644
--- a/drivers/iio/accel/Makefile
+++ b/drivers/iio/accel/Makefile
@@ -10,6 +10,7 @@ obj-$(CONFIG_KXCJK1013) += kxcjk-1013.o
 obj-$(CONFIG_KXSD9)	+= kxsd9.o
 obj-$(CONFIG_MMA8452)	+= mma8452.o
 obj-$(CONFIG_MMA9551)	+= mma9551.o
+obj-$(CONFIG_IIO_SSP_SENSORS_COMMONS) += ssp_accel_sensor.o
 
 obj-$(CONFIG_IIO_ST_ACCEL_3AXIS) += st_accel.o
 st_accel-y := st_accel_core.o
diff --git a/drivers/iio/accel/ssp_accel_sensor.c b/drivers/iio/accel/ssp_accel_sensor.c
new file mode 100644
index 0000000..4ae05fc
--- /dev/null
+++ b/drivers/iio/accel/ssp_accel_sensor.c
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

