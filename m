Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870AbaIGXEO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2014 19:04:14 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:41994 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947AbaIGXEK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2014 19:04:10 -0400
From: Tejun Heo <tj@kernel.org>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Chris Mason <clm@fb.com>, Dave Chinner <david@fromorbit.com>
Subject: [PATCH 1/6] block, bdi: an active gendisk always has a request_queue associated with it
Date: Mon,  8 Sep 2014 08:03:56 +0900
Message-Id: <1410131041-1881-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1410131041-1881-1-git-send-email-tj@kernel.org>
References: <1410131041-1881-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bdev_get_queue() returns the request_queue associated with the
specified block_device.  blk_get_backing_dev_info() makes use of
bdev_get_queue() to determine the associated bdi given a block_device.

All the callers of bdev_get_queue() including
blk_get_backing_dev_info() assume that bdev_get_queue() may return
NULL and implement NULL handling; however, bdev_get_queue() requires
the passed in block_device is opened and attached to its gendisk.
Because an active gendisk always has a valid request_queue associated
with it, bdev_get_queue() can never return NULL and neither can
blk_get_backing_dev_info().

Make it clear that neither of the two functions can return NULL and
remove NULL handling from all the callers.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Chris Mason <clm@fb.com>
Cc: Dave Chinner <david@fromorbit.com>
---
 block/blk-core.c       | 10 +++-------
 block/compat_ioctl.c   |  4 ----
 block/ioctl.c          |  4 ----
 fs/block_dev.c         |  2 --
 fs/btrfs/disk-io.c     |  2 +-
 fs/xfs/xfs_buf.c       |  2 --
 include/linux/blkdev.h |  2 +-
 7 files changed, 5 insertions(+), 21 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index c359d72..1702e4d 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -83,18 +83,14 @@ void blk_queue_congestion_threshold(struct request_queue *q)
  * @bdev:	device
  *
  * Locates the passed device's request queue and returns the address of its
- * backing_dev_info
- *
- * Will return NULL if the request queue cannot be located.
+ * backing_dev_info.  This function can only be called if @bdev is opened
+ * and the return value is never NULL.
  */
 struct backing_dev_info *blk_get_backing_dev_info(struct block_device *bdev)
 {
-	struct backing_dev_info *ret = NULL;
 	struct request_queue *q = bdev_get_queue(bdev);
 
-	if (q)
-		ret = &q->backing_dev_info;
-	return ret;
+	return &q->backing_dev_info;
 }
 EXPORT_SYMBOL(blk_get_backing_dev_info);
 
diff --git a/block/compat_ioctl.c b/block/compat_ioctl.c
index 18b282c..f678c73 100644
--- a/block/compat_ioctl.c
+++ b/block/compat_ioctl.c
@@ -709,8 +709,6 @@ long compat_blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 		if (!arg)
 			return -EINVAL;
 		bdi = blk_get_backing_dev_info(bdev);
-		if (bdi == NULL)
-			return -ENOTTY;
 		return compat_put_long(arg,
 				       (bdi->ra_pages * PAGE_CACHE_SIZE) / 512);
 	case BLKROGET: /* compatible */
@@ -731,8 +729,6 @@ long compat_blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 		if (!capable(CAP_SYS_ADMIN))
 			return -EACCES;
 		bdi = blk_get_backing_dev_info(bdev);
-		if (bdi == NULL)
-			return -ENOTTY;
 		bdi->ra_pages = (arg * 512) / PAGE_CACHE_SIZE;
 		return 0;
 	case BLKGETSIZE:
diff --git a/block/ioctl.c b/block/ioctl.c
index d6cda81..6c7bf90 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -356,8 +356,6 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 		if (!arg)
 			return -EINVAL;
 		bdi = blk_get_backing_dev_info(bdev);
-		if (bdi == NULL)
-			return -ENOTTY;
 		return put_long(arg, (bdi->ra_pages * PAGE_CACHE_SIZE) / 512);
 	case BLKROGET:
 		return put_int(arg, bdev_read_only(bdev) != 0);
@@ -386,8 +384,6 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 		if(!capable(CAP_SYS_ADMIN))
 			return -EACCES;
 		bdi = blk_get_backing_dev_info(bdev);
-		if (bdi == NULL)
-			return -ENOTTY;
 		bdi->ra_pages = (arg * 512) / PAGE_CACHE_SIZE;
 		return 0;
 	case BLKBSZSET:
diff --git a/fs/block_dev.c b/fs/block_dev.c
index 6d72746..d3251ec 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1173,8 +1173,6 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
 			if (!ret) {
 				bd_set_size(bdev,(loff_t)get_capacity(disk)<<9);
 				bdi = blk_get_backing_dev_info(bdev);
-				if (bdi == NULL)
-					bdi = &default_backing_dev_info;
 				bdev_inode_switch_bdi(bdev->bd_inode, bdi);
 			}
 
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index d0ed9e6..39ff591 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1694,7 +1694,7 @@ static int btrfs_congested_fn(void *congested_data, int bdi_bits)
 		if (!device->bdev)
 			continue;
 		bdi = blk_get_backing_dev_info(device->bdev);
-		if (bdi && bdi_congested(bdi, bdi_bits)) {
+		if (bdi_congested(bdi, bdi_bits)) {
 			ret = 1;
 			break;
 		}
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index cd7b8ca..497fcde 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1678,8 +1678,6 @@ xfs_alloc_buftarg(
 	btp->bt_dev =  bdev->bd_dev;
 	btp->bt_bdev = bdev;
 	btp->bt_bdi = blk_get_backing_dev_info(bdev);
-	if (!btp->bt_bdi)
-		goto error;
 
 	if (xfs_setsize_buftarg_early(btp, bdev))
 		goto error;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 518b465..e267bf0 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -865,7 +865,7 @@ extern void blk_execute_rq_nowait(struct request_queue *, struct gendisk *,
 
 static inline struct request_queue *bdev_get_queue(struct block_device *bdev)
 {
-	return bdev->bd_disk->queue;
+	return bdev->bd_disk->queue;	/* this is never NULL */
 }
 
 /*
-- 
1.9.3

