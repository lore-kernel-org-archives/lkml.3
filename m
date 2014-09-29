Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754070AbaI2OYk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 10:24:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53036 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751891AbaI2OYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 10:24:38 -0400
Date: Mon, 29 Sep 2014 10:21:10 -0400
From: David Jeffery <djeffery@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] Return short read or 0 at end of a raw device, not EIO
Message-ID: <20140929142110.GA12562@fury.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes to the basic direct I/O code have broken the raw driver when reading
to the end of a raw device.  Instead of returning a short read for a read that
extends partially beyond the device's end or 0 when at the end of the device,
these reads now return EIO.

The raw driver needs the same end of device handling as was added for normal
block devices.  Using blkdev_read_iter, which has the needed size checks,
prevents the EIO conditions at the end of the device.

Signed-off-by: David Jeffery <djeffery@redhat.com>
---

 drivers/char/raw.c |    2 +-
 fs/block_dev.c     |    3 ++-
 include/linux/fs.h |    1 +
 3 files changed, 4 insertions(+), 2 deletions(-)


diff --git a/drivers/char/raw.c b/drivers/char/raw.c
index 0102dc7..a24891b 100644
--- a/drivers/char/raw.c
+++ b/drivers/char/raw.c
@@ -285,7 +285,7 @@ static long raw_ctl_compat_ioctl(struct file *file, unsigned int cmd,
 
 static const struct file_operations raw_fops = {
 	.read		= new_sync_read,
-	.read_iter	= generic_file_read_iter,
+	.read_iter	= blkdev_read_iter,
 	.write		= new_sync_write,
 	.write_iter	= blkdev_write_iter,
 	.fsync		= blkdev_fsync,
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 6d72746..12aa041 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1591,7 +1591,7 @@ ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from)
 }
 EXPORT_SYMBOL_GPL(blkdev_write_iter);
 
-static ssize_t blkdev_read_iter(struct kiocb *iocb, struct iov_iter *to)
+ssize_t blkdev_read_iter(struct kiocb *iocb, struct iov_iter *to)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *bd_inode = file->f_mapping->host;
@@ -1605,6 +1605,7 @@ static ssize_t blkdev_read_iter(struct kiocb *iocb, struct iov_iter *to)
 	iov_iter_truncate(to, size);
 	return generic_file_read_iter(iocb, to);
 }
+EXPORT_SYMBOL_GPL(blkdev_read_iter);
 
 /*
  * Try to release a page associated with block device when the system
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 9418772..0c20168 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2455,6 +2455,7 @@ extern ssize_t new_sync_read(struct file *filp, char __user *buf, size_t len, lo
 extern ssize_t new_sync_write(struct file *filp, const char __user *buf, size_t len, loff_t *ppos);
 
 /* fs/block_dev.c */
+extern ssize_t blkdev_read_iter(struct kiocb *iocb, struct iov_iter *to);
 extern ssize_t blkdev_write_iter(struct kiocb *iocb, struct iov_iter *from);
 extern int blkdev_fsync(struct file *filp, loff_t start, loff_t end,
 			int datasync);
