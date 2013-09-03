Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759800Ab3ICIa2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 04:30:28 -0400
Received: from intranet.asianux.com ([58.214.24.6]:42189 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759755Ab3ICIaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 04:30:23 -0400
X-Spam-Score: -100.9
Message-ID: <52259DDE.6070401@asianux.com>
Date: Tue, 03 Sep 2013 16:29:18 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>, "'Jiri Kosina'" <trivial@kernel.org>
CC: Jens Axboe <axboe@kernel.dk>, Guenter Roeck <linux@roeck-us.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH trivial] block/ioctl.c: let code match 'kernel code style'
References: <521B2E75.1040802@asianux.com> <5220177E.709@asianux.com> <52201896.9040309@asianux.com> <5220254E.3050704@roeck-us.net> <52203CF0.5040600@asianux.com> <52207F74.6000702@roeck-us.net> <CAFLxGvyExTMSWOppheCwDA8RorSu_mLqW9a3f3GKFrsA2xbkfA@mail.gmail.com> <52208DFD.20105@roeck-us.net> <52240566.3040201@asianux.com>
In-Reply-To: <52240566.3040201@asianux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For 'switch case', remove redundancy '\t' (also can let related lines
within 80 columns) and remove redundancy empty lines, just like other
'switch case' which match 'kernel code style' within the file.

Let blkpg_ioctl() within 80 columns. Let 2nd line of blkdev_ioctl() and
__blkdev_driver_ioctl() align 1st line parameter's start position, just
like blk_ioctl_discard() and blk_ioctl_zeroout() within the file.

For is_unrecognized_ioctl(), can shrink the 'return' statement into one
line (so can save 2 lines), it still matches 'kernel code style' and it
is no conflict with others within the file.


Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 block/ioctl.c |  216 ++++++++++++++++++++++++++++-----------------------------
 1 files changed, 105 insertions(+), 111 deletions(-)

diff --git a/block/ioctl.c b/block/ioctl.c
index a31d91d..4a0be2d 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -9,7 +9,8 @@
 #include <linux/blktrace_api.h>
 #include <asm/uaccess.h>
 
-static int blkpg_ioctl(struct block_device *bdev, struct blkpg_ioctl_arg __user *arg)
+static int blkpg_ioctl(struct block_device *bdev,
+		       struct blkpg_ioctl_arg __user *arg)
 {
 	struct block_device *bdevp;
 	struct gendisk *disk;
@@ -32,121 +33,119 @@ static int blkpg_ioctl(struct block_device *bdev, struct blkpg_ioctl_arg __user
 	partno = p.pno;
 	if (partno <= 0)
 		return -EINVAL;
-	switch (a.op) {
-		case BLKPG_ADD_PARTITION:
-			start = p.start >> 9;
-			length = p.length >> 9;
-			/* check for fit in a hd_struct */
-			if (sizeof(sector_t) == sizeof(long) &&
-			    sizeof(long long) > sizeof(long)) {
-				long pstart = start, plength = length;
-				if (pstart != start || plength != length
-				    || pstart < 0 || plength < 0 || partno > 65535)
-					return -EINVAL;
-			}
-
-			mutex_lock(&bdev->bd_mutex);
-
-			/* overlap? */
-			disk_part_iter_init(&piter, disk,
-					    DISK_PITER_INCL_EMPTY);
-			while ((part = disk_part_iter_next(&piter))) {
-				if (!(start + length <= part->start_sect ||
-				      start >= part->start_sect + part->nr_sects)) {
-					disk_part_iter_exit(&piter);
-					mutex_unlock(&bdev->bd_mutex);
-					return -EBUSY;
-				}
-			}
-			disk_part_iter_exit(&piter);
 
-			/* all seems OK */
-			part = add_partition(disk, partno, start, length,
-					     ADDPART_FLAG_NONE, NULL);
-			mutex_unlock(&bdev->bd_mutex);
-			return IS_ERR(part) ? PTR_ERR(part) : 0;
-		case BLKPG_DEL_PARTITION:
-			part = disk_get_part(disk, partno);
-			if (!part)
-				return -ENXIO;
+	switch (a.op) {
+	case BLKPG_ADD_PARTITION:
+		start = p.start >> 9;
+		length = p.length >> 9;
+		/* check for fit in a hd_struct */
+		if (sizeof(sector_t) == sizeof(long) &&
+		    sizeof(long long) > sizeof(long)) {
+			long pstart = start, plength = length;
+			if (pstart != start || plength != length
+			    || pstart < 0 || plength < 0 || partno > 65535)
+				return -EINVAL;
+		}
 
-			bdevp = bdget(part_devt(part));
-			disk_put_part(part);
-			if (!bdevp)
-				return -ENOMEM;
+		mutex_lock(&bdev->bd_mutex);
 
-			mutex_lock(&bdevp->bd_mutex);
-			if (bdevp->bd_openers) {
-				mutex_unlock(&bdevp->bd_mutex);
-				bdput(bdevp);
+		/* overlap? */
+		disk_part_iter_init(&piter, disk, DISK_PITER_INCL_EMPTY);
+		while ((part = disk_part_iter_next(&piter))) {
+			if (!(start + length <= part->start_sect ||
+			      start >= part->start_sect + part->nr_sects)) {
+				disk_part_iter_exit(&piter);
+				mutex_unlock(&bdev->bd_mutex);
 				return -EBUSY;
 			}
-			/* all seems OK */
-			fsync_bdev(bdevp);
-			invalidate_bdev(bdevp);
-
-			mutex_lock_nested(&bdev->bd_mutex, 1);
-			delete_partition(disk, partno);
-			mutex_unlock(&bdev->bd_mutex);
+		}
+		disk_part_iter_exit(&piter);
+
+		/* all seems OK */
+		part = add_partition(disk, partno, start, length,
+				     ADDPART_FLAG_NONE, NULL);
+		mutex_unlock(&bdev->bd_mutex);
+		return IS_ERR(part) ? PTR_ERR(part) : 0;
+	case BLKPG_DEL_PARTITION:
+		part = disk_get_part(disk, partno);
+		if (!part)
+			return -ENXIO;
+
+		bdevp = bdget(part_devt(part));
+		disk_put_part(part);
+		if (!bdevp)
+			return -ENOMEM;
+
+		mutex_lock(&bdevp->bd_mutex);
+		if (bdevp->bd_openers) {
 			mutex_unlock(&bdevp->bd_mutex);
 			bdput(bdevp);
-
-			return 0;
-		case BLKPG_RESIZE_PARTITION:
-			start = p.start >> 9;
-			/* new length of partition in bytes */
-			length = p.length >> 9;
-			/* check for fit in a hd_struct */
-			if (sizeof(sector_t) == sizeof(long) &&
-			    sizeof(long long) > sizeof(long)) {
-				long pstart = start, plength = length;
-				if (pstart != start || plength != length
-				    || pstart < 0 || plength < 0)
-					return -EINVAL;
-			}
-			part = disk_get_part(disk, partno);
-			if (!part)
-				return -ENXIO;
-			bdevp = bdget(part_devt(part));
-			if (!bdevp) {
-				disk_put_part(part);
-				return -ENOMEM;
-			}
-			mutex_lock(&bdevp->bd_mutex);
-			mutex_lock_nested(&bdev->bd_mutex, 1);
-			if (start != part->start_sect) {
-				mutex_unlock(&bdevp->bd_mutex);
-				mutex_unlock(&bdev->bd_mutex);
-				bdput(bdevp);
-				disk_put_part(part);
+			return -EBUSY;
+		}
+		/* all seems OK */
+		fsync_bdev(bdevp);
+		invalidate_bdev(bdevp);
+
+		mutex_lock_nested(&bdev->bd_mutex, 1);
+		delete_partition(disk, partno);
+		mutex_unlock(&bdev->bd_mutex);
+		mutex_unlock(&bdevp->bd_mutex);
+		bdput(bdevp);
+		return 0;
+	case BLKPG_RESIZE_PARTITION:
+		start = p.start >> 9;
+		/* new length of partition in bytes */
+		length = p.length >> 9;
+		/* check for fit in a hd_struct */
+		if (sizeof(sector_t) == sizeof(long) &&
+		    sizeof(long long) > sizeof(long)) {
+			long pstart = start, plength = length;
+			if (pstart != start || plength != length
+			    || pstart < 0 || plength < 0)
 				return -EINVAL;
-			}
-			/* overlap? */
-			disk_part_iter_init(&piter, disk,
-					    DISK_PITER_INCL_EMPTY);
-			while ((lpart = disk_part_iter_next(&piter))) {
-				if (lpart->partno != partno &&
-				   !(start + length <= lpart->start_sect ||
-				   start >= lpart->start_sect + lpart->nr_sects)
-				   ) {
-					disk_part_iter_exit(&piter);
-					mutex_unlock(&bdevp->bd_mutex);
-					mutex_unlock(&bdev->bd_mutex);
-					bdput(bdevp);
-					disk_put_part(part);
-					return -EBUSY;
-				}
-			}
-			disk_part_iter_exit(&piter);
-			part_nr_sects_write(part, (sector_t)length);
-			i_size_write(bdevp->bd_inode, p.length);
+		}
+		part = disk_get_part(disk, partno);
+		if (!part)
+			return -ENXIO;
+		bdevp = bdget(part_devt(part));
+		if (!bdevp) {
+			disk_put_part(part);
+			return -ENOMEM;
+		}
+		mutex_lock(&bdevp->bd_mutex);
+		mutex_lock_nested(&bdev->bd_mutex, 1);
+		if (start != part->start_sect) {
 			mutex_unlock(&bdevp->bd_mutex);
 			mutex_unlock(&bdev->bd_mutex);
 			bdput(bdevp);
 			disk_put_part(part);
-			return 0;
-		default:
 			return -EINVAL;
+		}
+		/* overlap? */
+		disk_part_iter_init(&piter, disk, DISK_PITER_INCL_EMPTY);
+		while ((lpart = disk_part_iter_next(&piter))) {
+			if (lpart->partno != partno &&
+			   !(start + length <= lpart->start_sect ||
+			   start >= lpart->start_sect + lpart->nr_sects)
+			   ) {
+				disk_part_iter_exit(&piter);
+				mutex_unlock(&bdevp->bd_mutex);
+				mutex_unlock(&bdev->bd_mutex);
+				bdput(bdevp);
+				disk_put_part(part);
+				return -EBUSY;
+			}
+		}
+		disk_part_iter_exit(&piter);
+		part_nr_sects_write(part, (sector_t)length);
+		i_size_write(bdevp->bd_inode, p.length);
+		mutex_unlock(&bdevp->bd_mutex);
+		mutex_unlock(&bdev->bd_mutex);
+		bdput(bdevp);
+		disk_put_part(part);
+		return 0;
+	default:
+		return -EINVAL;
 	}
 }
 
@@ -232,7 +231,7 @@ static int put_u64(unsigned long arg, u64 val)
 }
 
 int __blkdev_driver_ioctl(struct block_device *bdev, fmode_t mode,
-			unsigned cmd, unsigned long arg)
+			  unsigned cmd, unsigned long arg)
 {
 	struct gendisk *disk = bdev->bd_disk;
 
@@ -263,16 +262,14 @@ EXPORT_SYMBOL_GPL(__blkdev_driver_ioctl);
  */
 static inline int is_unrecognized_ioctl(int ret)
 {
-	return	ret == -EINVAL ||
-		ret == -ENOTTY ||
-		ret == -ENOIOCTLCMD;
+	return	ret == -EINVAL || ret == -ENOTTY || ret == -ENOIOCTLCMD;
 }
 
 /*
  * always keep this in sync with compat_blkdev_ioctl()
  */
 int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
-			unsigned long arg)
+		 unsigned long arg)
 {
 	struct gendisk *disk = bdev->bd_disk;
 	struct backing_dev_info *bdi;
@@ -291,7 +288,6 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 		fsync_bdev(bdev);
 		invalidate_bdev(bdev);
 		return 0;
-
 	case BLKROSET:
 		ret = __blkdev_driver_ioctl(bdev, mode, cmd, arg);
 		if (!is_unrecognized_ioctl(ret))
@@ -302,7 +298,6 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 			return -EFAULT;
 		set_device_ro(bdev, n);
 		return 0;
-
 	case BLKDISCARD:
 	case BLKSECDISCARD: {
 		uint64_t range[2];
@@ -327,7 +322,6 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 
 		return blk_ioctl_zeroout(bdev, range[0], range[1]);
 	}
-
 	case HDIO_GETGEO: {
 		struct hd_geometry geo;
 
-- 
1.7.7.6
