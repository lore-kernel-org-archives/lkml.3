Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759325Ab3EWVQh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 17:16:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14695 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758494Ab3EWVQg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 17:16:36 -0400
From: David Milburn <dmilburn@redhat.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, asamymuthupa@micron.com
Subject: =?UTF-8?q?=5BPATCH=5D=20mtip32xx=3A=20dynamically=20allocate=20buffer=20in=20debugfs=20functions?=
Date: Thu, 23 May 2013 16:23:45 -0500
Message-Id: <1369344225-4110-1-git-send-email-dmilburn@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dynamically allocate buf to prevent warnings:

drivers/block/mtip32xx/mtip32xx.c: In function ‘mtip_hw_read_device_status’:
drivers/block/mtip32xx/mtip32xx.c:2823: warning: the frame size of 1056 bytes is larger than 1024 bytes
drivers/block/mtip32xx/mtip32xx.c: In function ‘mtip_hw_read_registers’:
drivers/block/mtip32xx/mtip32xx.c:2894: warning: the frame size of 1056 bytes is larger than 1024 bytes
drivers/block/mtip32xx/mtip32xx.c: In function ‘mtip_hw_read_flags’:
drivers/block/mtip32xx/mtip32xx.c:2917: warning: the frame size of 1056 bytes is larger than 1024 bytes

Signed-off-by: David Milburn <dmilburn@redhat.com>
---
 drivers/block/mtip32xx/mtip32xx.c |   47 +++++++++++++++++++++++++++++--------
 1 files changed, 37 insertions(+), 10 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 847107e..baa0996 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -2806,34 +2806,51 @@ static ssize_t show_device_status(struct device_driver *drv, char *buf)
 static ssize_t mtip_hw_read_device_status(struct file *f, char __user *ubuf,
 						size_t len, loff_t *offset)
 {
+	struct driver_data *dd =  (struct driver_data *)f->private_data;
 	int size = *offset;
-	char buf[MTIP_DFS_MAX_BUF_SIZE];
+	char *buf;
+	int rv = 0;
 
 	if (!len || *offset)
 		return 0;
 
+	buf = kzalloc(MTIP_DFS_MAX_BUF_SIZE, GFP_KERNEL);
+	if (!buf) {
+		dev_err(&dd->pdev->dev,
+			"Memory allocation: status buffer\n");
+		return -ENOMEM;
+	}
+
 	size += show_device_status(NULL, buf);
 
 	*offset = size <= len ? size : len;
 	size = copy_to_user(ubuf, buf, *offset);
 	if (size)
-		return -EFAULT;
+		rv = -EFAULT;
 
-	return *offset;
+	kfree(buf);
+	return rv ? rv : *offset;
 }
 
 static ssize_t mtip_hw_read_registers(struct file *f, char __user *ubuf,
 				  size_t len, loff_t *offset)
 {
 	struct driver_data *dd =  (struct driver_data *)f->private_data;
-	char buf[MTIP_DFS_MAX_BUF_SIZE];
+	char *buf;
 	u32 group_allocated;
 	int size = *offset;
-	int n;
+	int n, rv = 0;
 
 	if (!len || size)
 		return 0;
 
+	buf = kzalloc(MTIP_DFS_MAX_BUF_SIZE, GFP_KERNEL);
+	if (!buf) {
+		dev_err(&dd->pdev->dev,
+			"Memory allocation: register buffer\n");
+		return -ENOMEM;
+	}
+
 	size += sprintf(&buf[size], "H/ S ACTive      : [ 0x");
 
 	for (n = dd->slot_groups-1; n >= 0; n--)
@@ -2888,21 +2905,30 @@ static ssize_t mtip_hw_read_registers(struct file *f, char __user *ubuf,
 	*offset = size <= len ? size : len;
 	size = copy_to_user(ubuf, buf, *offset);
 	if (size)
-		return -EFAULT;
+		rv = -EFAULT;
 
-	return *offset;
+	kfree(buf);
+	return rv ? rv : *offset;
 }
 
 static ssize_t mtip_hw_read_flags(struct file *f, char __user *ubuf,
 				  size_t len, loff_t *offset)
 {
 	struct driver_data *dd =  (struct driver_data *)f->private_data;
-	char buf[MTIP_DFS_MAX_BUF_SIZE];
+	char *buf;
 	int size = *offset;
+	int rv = 0;
 
 	if (!len || size)
 		return 0;
 
+	buf = kzalloc(MTIP_DFS_MAX_BUF_SIZE, GFP_KERNEL);
+	if (!buf) {
+		dev_err(&dd->pdev->dev,
+			"Memory allocation: flag buffer\n");
+		return -ENOMEM;
+	}
+
 	size += sprintf(&buf[size], "Flag-port : [ %08lX ]\n",
 							dd->port->flags);
 	size += sprintf(&buf[size], "Flag-dd   : [ %08lX ]\n",
@@ -2911,9 +2937,10 @@ static ssize_t mtip_hw_read_flags(struct file *f, char __user *ubuf,
 	*offset = size <= len ? size : len;
 	size = copy_to_user(ubuf, buf, *offset);
 	if (size)
-		return -EFAULT;
+		rv = -EFAULT;
 
-	return *offset;
+	kfree(buf);
+	return rv ? rv : *offset;
 }
 
 static const struct file_operations mtip_device_status_fops = {
