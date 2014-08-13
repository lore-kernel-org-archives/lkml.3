Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750967AbaHMGaI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 02:30:08 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:20559 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750705AbaHMGaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 02:30:06 -0400
X-AuditID: cbfee61b-f79f86d00000144c-85-53eb05eb607a
From: a.mathur@samsung.com
To: jic23@kernel.org, lars@metafoo.de
Cc: cpgs@samsung.com, linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        aniroop.mathur@gmail.com, p.shailesh@samsung.com, r.mahale@samsung.com,
        vidushi.koul@samsung.com, narendra.m1@samsung.com
Subject: [PATCH 1/1] IIO: Added write function in iio_buffer_fileops
Date: Wed, 13 Aug 2014 11:59:51 +0530
Message-id: <1407911391-26696-1-git-send-email-a.mathur@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkluLIzCtJLcpLzFFi42I5/e+xoO5r1tfBBv+m81j83D2DxeLlIU2L
	B02rmCyWTJ7PajHvyDsWi8u75rBZLD1/htlix5RWFotT7xqYLP5evMTmwOWxc9Zddo9NqzrZ
	PJa8OcTq0bdlFaPH501yAaxRXDYpqTmZZalF+nYJXBk9N+6xFUxWqFj/9Ad7A+N1qS5GTg4J
	AROJtY8esULYYhIX7q1n62Lk4hASmM4ocWHvUhYI5yejxKTJF9hAqtgEpCTunL3NCGKLCKhK
	fFn0mBWkiFngDKPEt43/wIqEBVwktv65CmazABW1HPwJ1MDBwQsU/zajDMSUEFCQmDPJZgIj
	9wJGhlWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwQH0THoH46oGi0OMAhyMSjy8O1xfBQux
	JpYVV+YeYpTgYFYS4XXYAhTiTUmsrEotyo8vKs1JLT7EKM3BoiTOe7DVOlBIID2xJDU7NbUg
	tQgmy8TBKdXAuGBFjcFi+di6/5yXNE/XeQvc32nGIXTCs3hP3/spN3Im5TBzb/wv7+95bve8
	7Gux31arp/n6X165yasm2MPTQsd5zi6zDIVXqQltR9X57ry/aCcvXuSpUOfWduT2rw8vOTaG
	nr9fecJU2TNOwff6zr0Me8IWH1vFx3dN4P2VRn699ulvCxTeKLEUZyQaajEXFScCAHvRMdkc	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Aniroop Mathur <a.mathur@samsung.com>

Earlier, user space can only read from iio device node but cannot write to it.
This patch adds write function in iio buffer file operations, 
which will allow user-space applications/HAL to write the data 
to iio device node.
So now there will be two way communication between IIO subsystem 
and user space. (userspace <--> kernel) 

It can be used by HAL or any user-space application which wants to
write data to iio device node/buffer upon receiving some data from it.
As an example, 
It is useful for iio device simulator application which need to record 
the data by reading from iio device node and replay the recorded data 
by writing back to iio device node.

Signed-off-by: Aniroop Mathur <a.mathur@samsung.com>
---
 drivers/iio/iio_core.h            |    5 ++++-
 drivers/iio/industrialio-buffer.c |   34 ++++++++++++++++++++++++++++++++++
 drivers/iio/industrialio-core.c   |    1 +
 3 files changed, 39 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/iio_core.h b/drivers/iio/iio_core.h
index 5f0ea77..ba3fe53 100644
--- a/drivers/iio/iio_core.h
+++ b/drivers/iio/iio_core.h
@@ -47,10 +47,12 @@ unsigned int iio_buffer_poll(struct file *filp,
 			     struct poll_table_struct *wait);
 ssize_t iio_buffer_read_first_n_outer(struct file *filp, char __user *buf,
 				      size_t n, loff_t *f_ps);
-
+ssize_t iio_buffer_write_first_n_outer(struct file *filp,
+			     const char __user *buf, size_t n, loff_t *f_ps);
 
 #define iio_buffer_poll_addr (&iio_buffer_poll)
 #define iio_buffer_read_first_n_outer_addr (&iio_buffer_read_first_n_outer)
+#define iio_buffer_write_first_n_outer_addr (&iio_buffer_write_first_n_outer)
 
 void iio_disable_all_buffers(struct iio_dev *indio_dev);
 void iio_buffer_wakeup_poll(struct iio_dev *indio_dev);
@@ -59,6 +61,7 @@ void iio_buffer_wakeup_poll(struct iio_dev *indio_dev);
 
 #define iio_buffer_poll_addr NULL
 #define iio_buffer_read_first_n_outer_addr NULL
+#define iio_buffer_write_first_n_outer_addr NULL
 
 static inline void iio_disable_all_buffers(struct iio_dev *indio_dev) {}
 static inline void iio_buffer_wakeup_poll(struct iio_dev *indio_dev) {}
diff --git a/drivers/iio/industrialio-buffer.c b/drivers/iio/industrialio-buffer.c
index 9f1a140..ef889af 100644
--- a/drivers/iio/industrialio-buffer.c
+++ b/drivers/iio/industrialio-buffer.c
@@ -21,6 +21,7 @@
 #include <linux/slab.h>
 #include <linux/poll.h>
 #include <linux/sched.h>
+#include <asm/uaccess.h>
 
 #include <linux/iio/iio.h>
 #include "iio_core.h"
@@ -87,6 +88,39 @@ ssize_t iio_buffer_read_first_n_outer(struct file *filp, char __user *buf,
 }
 
 /**
+ * iio_buffer_write_first_n_outer() - chrdev write to buffer
+ *
+ * This function pushes the user space data to kernel iio buffer
+ **/
+ssize_t iio_buffer_write_first_n_outer(struct file *filp,
+				const char __user *buf, size_t n, loff_t *f_ps)
+{
+	struct iio_dev *indio_dev = filp->private_data;
+	struct iio_buffer *rb = indio_dev->buffer;
+	int ret = -1;
+	unsigned char *data = NULL;
+
+	if (!indio_dev->info)
+		return -ENODEV;
+
+	if (n != 1)
+		return -EINVAL;
+
+	data = kzalloc(1, GFP_KERNEL);
+	if (!data)
+		return -ENOMEM;
+
+	if (copy_from_user(data, buf, 1)) {
+		kfree(data);
+		return -EFAULT;
+	}
+
+	ret = iio_push_to_buffer(rb, data);
+	kfree(data);
+	return ret;
+}
+
+/**
  * iio_buffer_poll() - poll the buffer to find out if it has data
  */
 unsigned int iio_buffer_poll(struct file *filp,
diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
index 4b1f375..a98dba9 100644
--- a/drivers/iio/industrialio-core.c
+++ b/drivers/iio/industrialio-core.c
@@ -1114,6 +1114,7 @@ static long iio_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 
 static const struct file_operations iio_buffer_fileops = {
 	.read = iio_buffer_read_first_n_outer_addr,
+	.write = iio_buffer_write_first_n_outer_addr,
 	.release = iio_chrdev_release,
 	.open = iio_chrdev_open,
 	.poll = iio_buffer_poll_addr,
-- 
1.7.9.5

