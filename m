Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752359AbaLET4w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 14:56:52 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:45573 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875AbaLET4J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 14:56:09 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-53-54820dd65519
From: Karol Wrona <k.wrona@samsung.com>
To: Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org,
        Hartmut Knaack <knaack.h@gmx.de>, linux-kernel@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Karol Wrona <wrona.vy@gmail.com>, Karol Wrona <k.wrona@samsung.com>
Subject: [PATCH v3 3/5] iio: common: ssp_sensors: Add sensorhub iio commons
Date: Fri, 05 Dec 2014 20:54:48 +0100
Message-id: <1417809290-9662-4-git-send-email-k.wrona@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1417809290-9662-1-git-send-email-k.wrona@samsung.com>
References: <1417809290-9662-1-git-send-email-k.wrona@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNJMWRmVeSWpSXmKPExsVy+t/xK7rXeJtCDPY1GlpsnLGe1eJB0yom
	i1PL9jNZ7Pr/htnibNMbdot5R96xWFzeNYfNYs+6LUwOHB47Z91l9/jwMc5j06pONo++LasY
	PT5vkgtgjeKySUnNySxLLdK3S+DKeN/6gbngiFpFz+4LbA2MF+S7GDk5JARMJDqP7GKBsMUk
	Ltxbz9bFyMUhJLCUUWL39wmMEE4fk8TcfX9YQarYBNQlmncsZgZJiAi0MEq8+LmLFcRhFljD
	KHHm7AR2kCphAW+JTR2XmEFsFgFVictrusBsXgEnictPvwPZHED7FCTmTLIBCXMKOEtc+zaD
	CcQWAip5duwX8wRG3gWMDKsYRVNLkwuKk9JzDfWKE3OLS/PS9ZLzczcxQgLsyw7GxcesDjEK
	cDAq8fBesG4MEWJNLCuuzD3EKMHBrCTCmzwbKMSbklhZlVqUH19UmpNafIiRiYNTqoEx81DV
	zCKrioSZr1ZlXcgJZHWs4/Mvvl5cMofJa3rdw8eZLDrdM7O3bfimy+du4tL5f3mfjl9B3qSV
	BxY7neePjxb6flt3zgO7DUf7cz7/eaX0LEfsUUiF4s/cB3qtBca7/H7lzdNWnDTJ1Km6wM9F
	+G/Jf6HNE1sKji55dyRuSkPF7nLB2XFKLMUZiYZazEXFiQBNTZwoDgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds common library for sensorhub iio drivers.

Change-Id: I1038cb31c051f7e8ffde696a4121518daa5af081
Signed-off-by: Karol Wrona <k.wrona@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/iio/common/ssp_sensors/ssp_iio.c        |   82 +++++++++++++++++++++++
 drivers/iio/common/ssp_sensors/ssp_iio_sensor.h |   56 ++++++++++++++++
 2 files changed, 138 insertions(+)
 create mode 100644 drivers/iio/common/ssp_sensors/ssp_iio.c
 create mode 100644 drivers/iio/common/ssp_sensors/ssp_iio_sensor.h

diff --git a/drivers/iio/common/ssp_sensors/ssp_iio.c b/drivers/iio/common/ssp_sensors/ssp_iio.c
new file mode 100644
index 0000000..036be12
--- /dev/null
+++ b/drivers/iio/common/ssp_sensors/ssp_iio.c
@@ -0,0 +1,82 @@
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
+#include <linux/iio/kfifo_buf.h>
+#include "ssp_iio_sensor.h"
+
+/**
+ * ssp_common_buffer_postenable() - generic postenable callback for ssp buffer
+ *
+ * @indio_dev:		iio device
+ *
+ * Returns 0 or negative value in case of error
+ */
+int ssp_common_buffer_postenable(struct iio_dev *indio_dev)
+{
+	struct ssp_sensor_data *spd = iio_priv(indio_dev);
+	struct ssp_data *data = dev_get_drvdata(indio_dev->dev.parent->parent);
+
+	return ssp_enable_sensor(data, spd->type,
+				 ssp_get_sensor_delay(data, spd->type));
+}
+EXPORT_SYMBOL(ssp_common_buffer_postenable);
+
+/**
+ * ssp_common_buffer_predisable() - generic predisable callback for ssp buffer
+ *
+ * @indio_dev:		iio device
+ *
+ * Returns 0 or negative value in case of error
+ */
+int ssp_common_buffer_predisable(struct iio_dev *indio_dev)
+{
+	struct ssp_sensor_data *spd = iio_priv(indio_dev);
+	struct ssp_data *data = dev_get_drvdata(indio_dev->dev.parent->parent);
+
+	return ssp_disable_sensor(data, spd->type);
+}
+EXPORT_SYMBOL(ssp_common_buffer_predisable);
+
+/**
+ * ssp_common_setup_buffer() - creates iio kfifo and registers the buffer
+ *                             for device
+ *
+ * @indio_dev:		iio device
+ *
+ * Returns 0 or negative value in case of error
+ */
+int ssp_common_setup_buffer(struct iio_dev *indio_dev,
+			    const struct iio_buffer_setup_ops *ops)
+{
+	int ret;
+	struct iio_buffer *buffer;
+
+	buffer = iio_kfifo_allocate(indio_dev);
+	if (!buffer)
+		return -ENOMEM;
+
+	iio_device_attach_buffer(indio_dev, buffer);
+
+	indio_dev->setup_ops = ops;
+
+	ret = iio_buffer_register(indio_dev, indio_dev->channels,
+				  indio_dev->num_channels);
+	if (ret)
+		iio_kfifo_free(buffer);
+
+	return ret;
+}
+EXPORT_SYMBOL(ssp_common_setup_buffer);
diff --git a/drivers/iio/common/ssp_sensors/ssp_iio_sensor.h b/drivers/iio/common/ssp_sensors/ssp_iio_sensor.h
new file mode 100644
index 0000000..4b79be0
--- /dev/null
+++ b/drivers/iio/common/ssp_sensors/ssp_iio_sensor.h
@@ -0,0 +1,56 @@
+#ifndef __SSP_IIO_SENSOR_H__
+#define __SSP_IIO_SENSOR_H__
+
+#define SSP_CHANNEL_AG(_type, _mod, _index) \
+{ \
+		.type = _type,\
+		.modified = 1,\
+		.channel2 = _mod,\
+		.info_mask_shared_by_type = BIT(IIO_CHAN_INFO_SAMP_FREQ),\
+		.scan_index = _index,\
+		.scan_type = {\
+			.sign = 's',\
+			.realbits = 16,\
+			.storagebits = 16,\
+			.shift = 0,\
+			.endianness = IIO_LE,\
+		},\
+}
+
+#define SSP_DIVISOR	1000000ULL
+#define SSP_MS_PER_S	1000
+#define SSP_DIVIDEND	(SSP_DIVISOR * SSP_MS_PER_S)
+
+int ssp_common_buffer_postenable(struct iio_dev *indio_dev);
+
+int ssp_common_buffer_predisable(struct iio_dev *indio_dev);
+
+int ssp_common_setup_buffer(struct iio_dev *indio_dev,
+			    const struct iio_buffer_setup_ops *ops);
+
+/* Converts time in ms to frequency */
+static inline void ssp_convert_to_freq(u32 time, int *integer_part,
+				       int *fractional)
+{
+	if (time == 0) {
+		*fractional = 0;
+		*integer_part = 0;
+		return;
+	}
+
+	*integer_part = SSP_DIVIDEND / time;
+	*fractional = do_div(*integer_part, SSP_DIVISOR);
+}
+
+/* Converts frequency to time in ms*/
+static inline int ssp_convert_to_time(int integer_part, int fractional)
+{
+	u64 value;
+
+	value = integer_part * SSP_DIVISOR + fractional;
+	if (value == 0)
+		return 0;
+
+	return div_u64(SSP_DIVIDEND, value);
+}
+#endif /* __SSP_IIO_SENSOR_H__ */
-- 
1.7.9.5

