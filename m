Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818AbbAGSh0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 13:37:26 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:22843 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293AbbAGShY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 13:37:24 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-7a-54ad7ce11f81
From: Karol Wrona <k.wrona@samsung.com>
To: Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org,
        Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>, linux-kernel@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Karol Wrona <wrona.vy@gmail.com>, Karol Wrona <k.wrona@samsung.com>
Subject: [RFC PATCH] iio: Add new operating mode for non triggered sw buffers
Date: Wed, 07 Jan 2015 19:36:11 +0100
Message-id: <1420655771-22465-1-git-send-email-k.wrona@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrGJMWRmVeSWpSXmKPExsVy+t/xy7oPa9aGGKx+oWuxccZ6VosHTauY
	LE4t289ksev/G2aLs01v2C2WTJ7PajHvyDsWi8u75rBZ/N51jN1iz7otTA5cHjtn3WX3+PAx
	zmPTqk42jyVvDrF6nG8+wujRt2UVo8fnTXIB7FFcNimpOZllqUX6dglcGU/OmBQcEahY9WI1
	ewPjJ94uRk4OCQETicftK9khbDGJC/fWs3UxcnEICSxllGhcu48Vwuljkpiw4iITSBWbgLpE
	847FzCAJEYELjBLHD21hAXGYBdYwSpw5OwFslrCAr8SZ/i42EJtFQFXixe+fzCA2r4CzxJ7G
	KYxdjBxA+xQk5kyymcDIvYCRYRWjaGppckFxUnquoV5xYm5xaV66XnJ+7iZGSFh92cG4+JjV
	IUYBDkYlHt6CvjUhQqyJZcWVuYcYJTiYlUR4XZPXhgjxpiRWVqUW5ccXleakFh9iZOLglGpg
	ZJU7eO/DdWfXI3pB63arLuWorlEOFPqTvL3J4qJrw4c9G99J1yin3jnev+1Z6PsHna0zObeL
	dwueTEi7OT1qKdChRRctNLJ8pstdWR37qNbis7binen6kglHm1btWLpE5q5O+fQrG5/v2CG8
	5ObiXhWZmlPaS49scZz9a/OqPv371dusemYvVWIpzkg01GIuKk4EAH3xn9UJAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There was a need for non triggered software buffer type.  It can be used when
triggered model does not fit and INDIO_BUFFER_HARDWARE causes confusion because
the data stream can be obtained not directly form hardware backend.

Suggested-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Karol Wrona <k.wrona@samsung.com>
---
 drivers/iio/industrialio-buffer.c |    2 ++
 include/linux/iio/iio.h           |    6 ++++--
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/iio/industrialio-buffer.c b/drivers/iio/industrialio-buffer.c
index f971f79..15e6de3 100644
--- a/drivers/iio/industrialio-buffer.c
+++ b/drivers/iio/industrialio-buffer.c
@@ -680,6 +680,8 @@ static int __iio_update_buffers(struct iio_dev *indio_dev,
 		indio_dev->currentmode = INDIO_BUFFER_TRIGGERED;
 	} else if (indio_dev->modes & INDIO_BUFFER_HARDWARE) {
 		indio_dev->currentmode = INDIO_BUFFER_HARDWARE;
+	} else if (indio_dev->modes & INDIO_BUFFER_SOFTWARE) {
+		indio_dev->currentmode = INDIO_BUFFER_SOFTWARE;
 	} else { /* Should never be reached */
 		ret = -EINVAL;
 		goto error_run_postdisable;
diff --git a/include/linux/iio/iio.h b/include/linux/iio/iio.h
index 3642ce7..55e63fd 100644
--- a/include/linux/iio/iio.h
+++ b/include/linux/iio/iio.h
@@ -284,10 +284,11 @@ static inline s64 iio_get_time_ns(void)
 /* Device operating modes */
 #define INDIO_DIRECT_MODE		0x01
 #define INDIO_BUFFER_TRIGGERED		0x02
+#define INDIO_BUFFER_SOFTWARE		0x04
 #define INDIO_BUFFER_HARDWARE		0x08
 
 #define INDIO_ALL_BUFFER_MODES					\
-	(INDIO_BUFFER_TRIGGERED | INDIO_BUFFER_HARDWARE)
+	(INDIO_BUFFER_TRIGGERED | INDIO_BUFFER_HARDWARE | INDIO_BUFFER_SOFTWARE)
 
 #define INDIO_MAX_RAW_ELEMENTS		4
 
@@ -591,7 +592,8 @@ void devm_iio_trigger_free(struct device *dev, struct iio_trigger *iio_trig);
 static inline bool iio_buffer_enabled(struct iio_dev *indio_dev)
 {
 	return indio_dev->currentmode
-		& (INDIO_BUFFER_TRIGGERED | INDIO_BUFFER_HARDWARE);
+		& (INDIO_BUFFER_TRIGGERED | INDIO_BUFFER_HARDWARE |
+		   INDIO_BUFFER_SOFTWARE);
 }
 
 /**
-- 
1.7.9.5

