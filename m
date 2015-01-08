Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756976AbbAHQk5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 11:40:57 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:64764 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756758AbbAHQkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 11:40:52 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-74-54aeb3113c11
From: Karol Wrona <k.wrona@samsung.com>
To: Jonathan Cameron <jic23@kernel.org>, linux-iio@vger.kernel.org,
        Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>, linux-kernel@vger.kernel.org
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Karol Wrona <wrona.vy@gmail.com>, Karol Wrona <k.wrona@samsung.com>
Subject: [PATCH 1/2] iio: Add no-triggered buffer helper functions
Date: Thu, 08 Jan 2015 17:40:26 +0100
Message-id: <1420735227-21091-2-git-send-email-k.wrona@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1420735227-21091-1-git-send-email-k.wrona@samsung.com>
References: <1420735227-21091-1-git-send-email-k.wrona@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFuplluLIzCtJLcpLzFFi42I5/e/4FV2hzetCDI65WGycsZ7V4kHTKiaL
	U8v2M1ns+v+G2eJs0xt2iyWT57NazDvyjsXi8q45bBa/dx1jt9izbguTA5fHzll32T0+fIzz
	2LSqk81jyZtDrB7nm48wevRtWcXo8XmTXAB7FJdNSmpOZllqkb5dAlfG1lV/mAtmqVY82HWU
	qYGxX76LkZNDQsBE4uuerYwQtpjEhXvr2boYuTiEBJYySrzvuQfl9DFJTL/5iB2kik1AXaJ5
	x2JmkISIwAVGieOHtrCAOMwCaxglzpydAFYlLOAk8WH7LiYQm0VAVWLaidcsIDavgLPEwc9f
	gWo4gPYpSMyZZAMS5hRwkXh55QRYWAioZPMfnwmMvAsYGVYxiqaWJhcUJ6XnGukVJ+YWl+al
	6yXn525ihATh1x2MS49ZHWIU4GBU4uH9cH9tiBBrYllxZe4hRgkOZiURXh3PdSFCvCmJlVWp
	RfnxRaU5qcWHGJk4OKUaGB0zGOVT7/5adn75hf7rWy4pqE7aMEv/itfmzRN+ycQdWx0QcoTv
	Js/kn4E9SVs9pG68nrVxKkv38b3Gp1pvR4f39vz6NPeeiNDpJb1O5/dvLijM9bjr3/bjaYx9
	7PzQ2Kv/M9ctnHppy+knxVZmx5WeTzdm/se5ftfp9cz3JEsdXJec1+t1X1yjxFKckWioxVxU
	nAgALNaNkCACAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These ones helps to create and manage iio_kfifo buffer when
no-triggered buffer is used.

Signed-off-by: Karol Wrona <k.wrona@samsung.com>
Suggested-by: Jonathan Cameron <jic23@kernel.org>

---
 drivers/iio/Kconfig                           |    6 +++
 drivers/iio/Makefile                          |    1 +
 drivers/iio/industrialio-notriggered-buffer.c |   72 +++++++++++++++++++++++++
 include/linux/iio/notriggered-buffer.h        |   11 ++++
 4 files changed, 90 insertions(+)
 create mode 100644 drivers/iio/industrialio-notriggered-buffer.c
 create mode 100644 include/linux/iio/notriggered-buffer.h

diff --git a/drivers/iio/Kconfig b/drivers/iio/Kconfig
index 345395e..50f6599 100644
--- a/drivers/iio/Kconfig
+++ b/drivers/iio/Kconfig
@@ -34,6 +34,12 @@ config IIO_KFIFO_BUF
 	  no buffer events so it is up to userspace to work out how
 	  often to read from the buffer.
 
+config IIO_NOTRIGGERED_BUFFER
+	tristate
+	select IIO_KFIFO_BUF
+	help
+	  Provides helper functions for setting up no-triggered buffers.
+
 config IIO_TRIGGERED_BUFFER
 	tristate
 	select IIO_TRIGGER
diff --git a/drivers/iio/Makefile b/drivers/iio/Makefile
index 698afc2..fff7b1a 100644
--- a/drivers/iio/Makefile
+++ b/drivers/iio/Makefile
@@ -8,6 +8,7 @@ industrialio-$(CONFIG_IIO_BUFFER) += industrialio-buffer.o
 industrialio-$(CONFIG_IIO_TRIGGER) += industrialio-trigger.o
 industrialio-$(CONFIG_IIO_BUFFER_CB) += buffer_cb.o
 
+obj-$(CONFIG_IIO_NOTRIGGERED_BUFFER) += industrialio-notriggered-buffer.o
 obj-$(CONFIG_IIO_TRIGGERED_BUFFER) += industrialio-triggered-buffer.o
 obj-$(CONFIG_IIO_KFIFO_BUF) += kfifo_buf.o
 
diff --git a/drivers/iio/industrialio-notriggered-buffer.c b/drivers/iio/industrialio-notriggered-buffer.c
new file mode 100644
index 0000000..3cbccab
--- /dev/null
+++ b/drivers/iio/industrialio-notriggered-buffer.c
@@ -0,0 +1,72 @@
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
+#include <linux/kernel.h>
+#include <linux/export.h>
+#include <linux/module.h>
+#include <linux/iio/iio.h>
+#include <linux/iio/buffer.h>
+#include <linux/iio/kfifo_buf.h>
+
+/**
+ * iio_notriggered_buffer_setup() - Setup no-triggered buffer and pollfunc
+ * @indio_dev:		IIO device structure
+ * @setup_ops:		Buffer setup functions to use for this device.
+ *
+ * Usage: see iio_triggered_buffer_setup() comments.
+ *
+ * To free the resources allocated by this function call
+ * iio_notriggered_buffer_cleanup().
+ *
+ * Returns: 0 - success, < 0 failure
+ */
+int iio_notriggered_buffer_setup(struct iio_dev *indio_dev,
+				 const struct iio_buffer_setup_ops *setup_ops)
+
+{
+	int ret;
+	struct iio_buffer *buffer;
+
+	buffer = iio_kfifo_allocate();
+	if (!buffer)
+		return -ENOMEM;
+
+	iio_device_attach_buffer(indio_dev, buffer);
+
+	indio_dev->setup_ops = setup_ops;
+
+	ret = iio_buffer_register(indio_dev, indio_dev->channels,
+				  indio_dev->num_channels);
+	if (ret)
+		iio_kfifo_free(buffer);
+
+	return ret;
+}
+EXPORT_SYMBOL(iio_notriggered_buffer_setup);
+
+/**
+ * iio_notriggered_buffer_cleanup() - Free resources allocated by iio_notriggered_buffer_setup()
+ * @indio_dev: IIO device structure
+ */
+void iio_notriggered_buffer_cleanup(struct iio_dev *indio_dev)
+{
+	iio_buffer_unregister(indio_dev);
+	iio_kfifo_free(indio_dev->buffer);
+}
+EXPORT_SYMBOL(iio_notriggered_buffer_cleanup);
+
+MODULE_AUTHOR("Karol Wrona <k.wrona@samsung.com>");
+MODULE_DESCRIPTION("IIO helper functions for setting up no-triggered buffers");
+MODULE_LICENSE("GPL");
diff --git a/include/linux/iio/notriggered-buffer.h b/include/linux/iio/notriggered-buffer.h
new file mode 100644
index 0000000..5b3e416
--- /dev/null
+++ b/include/linux/iio/notriggered-buffer.h
@@ -0,0 +1,11 @@
+#ifndef _LINUX_IIO_NOTRIGGERED_BUFFER_H_
+#define _LINUX_IIO_NOTRIGGERED_BUFFER_H_
+
+struct iio_dev;
+struct iio_buffer_setup_ops;
+
+int iio_notriggered_buffer_setup(struct iio_dev *indio_dev,
+				 const struct iio_buffer_setup_ops *setup_ops);
+void iio_notriggered_buffer_cleanup(struct iio_dev *indio_dev);
+
+#endif /* _LINUX_IIO_NOTRIGGERED_BUFFER_H_ */
-- 
1.7.9.5

