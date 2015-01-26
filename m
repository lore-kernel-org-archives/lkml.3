Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528AbbAZKQ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 05:16:27 -0500
Received: from mail-we0-f173.google.com ([74.125.82.173]:63436 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932154AbbAZKPw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 05:15:52 -0500
From: David Herrmann <dh.herrmann@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, David Herrmann <dh.herrmann@gmail.com>
Subject: [PATCH RFC] loop: make partition scanning reliable
Date: Mon, 26 Jan 2015 11:15:19 +0100
Message-Id: <1422267319-8428-1-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 2.2.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So far, loop-device partition-scanning is skipped with EBUSY if the
bd_mutex cannot be locked. This might happen, if someone runs open() /
close() / ioctl() in parallel to LOOP_SET_FD/LOOP_CHANGE_FD and friends.

__fput() on open files might get delayed arbitrarily, which means,
blkdev_put() might get called at any point in time, locking bd_mutex and
thus preventing any possible partition-rescanning in parallel. This
basically requires user-space to *always* run BLKRRSCAN after
LOOP_SET_FD/LOOP_CHANGE_FD as we cannot know whether someone else is about
to close their FD at the same time.

Fix this by running BLKRRPART without holding lo_ctl_mutex, thus, we will
no longer deadlock if we lock bd_mutex.

Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
---
 block/ioctl.c        |  9 ++++++---
 drivers/block/loop.c | 49 ++++++++++++++++++++++++++++++-------------------
 include/linux/fs.h   |  1 +
 3 files changed, 37 insertions(+), 22 deletions(-)

diff --git a/block/ioctl.c b/block/ioctl.c
index 6c7bf90..01c6550 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -150,7 +150,7 @@ static int blkpg_ioctl(struct block_device *bdev, struct blkpg_ioctl_arg __user
 	}
 }
 
-static int blkdev_reread_part(struct block_device *bdev)
+int blkdev_reread_part(struct block_device *bdev, int skipbusy)
 {
 	struct gendisk *disk = bdev->bd_disk;
 	int res;
@@ -159,12 +159,15 @@ static int blkdev_reread_part(struct block_device *bdev)
 		return -EINVAL;
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
-	if (!mutex_trylock(&bdev->bd_mutex))
+	if (!skipbusy)
+		mutex_lock(&bdev->bd_mutex);
+	else if (!mutex_trylock(&bdev->bd_mutex))
 		return -EBUSY;
 	res = rescan_partitions(disk, bdev);
 	mutex_unlock(&bdev->bd_mutex);
 	return res;
 }
+EXPORT_SYMBOL(blkdev_reread_part);
 
 static int blk_ioctl_discard(struct block_device *bdev, uint64_t start,
 			     uint64_t len, int secure)
@@ -407,7 +410,7 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 		ret = blkpg_ioctl(bdev, (struct blkpg_ioctl_arg __user *) arg);
 		break;
 	case BLKRRPART:
-		ret = blkdev_reread_part(bdev);
+		ret = blkdev_reread_part(bdev, 1);
 		break;
 	case BLKGETSIZE:
 		size = i_size_read(bdev->bd_inode);
diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 6cb1beb..4047985 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -637,7 +637,7 @@ out:
  * new backing store is the same size and type as the old backing store.
  */
 static int loop_change_fd(struct loop_device *lo, struct block_device *bdev,
-			  unsigned int arg)
+			  unsigned int arg, int *rrpart)
 {
 	struct file	*file, *old_file;
 	struct inode	*inode;
@@ -676,7 +676,7 @@ static int loop_change_fd(struct loop_device *lo, struct block_device *bdev,
 
 	fput(old_file);
 	if (lo->lo_flags & LO_FLAGS_PARTSCAN)
-		ioctl_by_bdev(bdev, BLKRRPART, 0);
+		*rrpart = 1;
 	return 0;
 
  out_putf:
@@ -821,7 +821,7 @@ static void loop_config_discard(struct loop_device *lo)
 }
 
 static int loop_set_fd(struct loop_device *lo, fmode_t mode,
-		       struct block_device *bdev, unsigned int arg)
+		       struct block_device *bdev, unsigned int arg, int *rrpart)
 {
 	struct file	*file, *f;
 	struct inode	*inode;
@@ -917,7 +917,7 @@ static int loop_set_fd(struct loop_device *lo, fmode_t mode,
 	if (part_shift)
 		lo->lo_flags |= LO_FLAGS_PARTSCAN;
 	if (lo->lo_flags & LO_FLAGS_PARTSCAN)
-		ioctl_by_bdev(bdev, BLKRRPART, 0);
+		*rrpart = 1;
 
 	/* Grab the block_device to prevent its destruction after we
 	 * put /dev/loopXX inode. Later in loop_clr_fd() we bdput(bdev).
@@ -1064,7 +1064,8 @@ static int loop_clr_fd(struct loop_device *lo)
 }
 
 static int
-loop_set_status(struct loop_device *lo, const struct loop_info64 *info)
+loop_set_status(struct loop_device *lo, const struct loop_info64 *info,
+		int *rrpart)
 {
 	int err;
 	struct loop_func_table *xfer;
@@ -1123,7 +1124,7 @@ loop_set_status(struct loop_device *lo, const struct loop_info64 *info)
 	     !(lo->lo_flags & LO_FLAGS_PARTSCAN)) {
 		lo->lo_flags |= LO_FLAGS_PARTSCAN;
 		lo->lo_disk->flags &= ~GENHD_FL_NO_PART_SCAN;
-		ioctl_by_bdev(lo->lo_device, BLKRRPART, 0);
+		*rrpart = 1;
 	}
 
 	lo->lo_encrypt_key_size = info->lo_encrypt_key_size;
@@ -1223,7 +1224,8 @@ loop_info64_to_old(const struct loop_info64 *info64, struct loop_info *info)
 }
 
 static int
-loop_set_status_old(struct loop_device *lo, const struct loop_info __user *arg)
+loop_set_status_old(struct loop_device *lo, const struct loop_info __user *arg,
+		    int *rrpart)
 {
 	struct loop_info info;
 	struct loop_info64 info64;
@@ -1231,17 +1233,18 @@ loop_set_status_old(struct loop_device *lo, const struct loop_info __user *arg)
 	if (copy_from_user(&info, arg, sizeof (struct loop_info)))
 		return -EFAULT;
 	loop_info64_from_old(&info, &info64);
-	return loop_set_status(lo, &info64);
+	return loop_set_status(lo, &info64, rrpart);
 }
 
 static int
-loop_set_status64(struct loop_device *lo, const struct loop_info64 __user *arg)
+loop_set_status64(struct loop_device *lo, const struct loop_info64 __user *arg,
+		  int *rrpart)
 {
 	struct loop_info64 info64;
 
 	if (copy_from_user(&info64, arg, sizeof (struct loop_info64)))
 		return -EFAULT;
-	return loop_set_status(lo, &info64);
+	return loop_set_status(lo, &info64, rrpart);
 }
 
 static int
@@ -1289,15 +1292,15 @@ static int lo_ioctl(struct block_device *bdev, fmode_t mode,
 	unsigned int cmd, unsigned long arg)
 {
 	struct loop_device *lo = bdev->bd_disk->private_data;
-	int err;
+	int err, rrpart = 0;
 
 	mutex_lock_nested(&lo->lo_ctl_mutex, 1);
 	switch (cmd) {
 	case LOOP_SET_FD:
-		err = loop_set_fd(lo, mode, bdev, arg);
+		err = loop_set_fd(lo, mode, bdev, arg, &rrpart);
 		break;
 	case LOOP_CHANGE_FD:
-		err = loop_change_fd(lo, bdev, arg);
+		err = loop_change_fd(lo, bdev, arg, &rrpart);
 		break;
 	case LOOP_CLR_FD:
 		/* loop_clr_fd would have unlocked lo_ctl_mutex on success */
@@ -1309,7 +1312,8 @@ static int lo_ioctl(struct block_device *bdev, fmode_t mode,
 		err = -EPERM;
 		if ((mode & FMODE_WRITE) || capable(CAP_SYS_ADMIN))
 			err = loop_set_status_old(lo,
-					(struct loop_info __user *)arg);
+					(struct loop_info __user *)arg,
+					&rrpart);
 		break;
 	case LOOP_GET_STATUS:
 		err = loop_get_status_old(lo, (struct loop_info __user *) arg);
@@ -1318,7 +1322,8 @@ static int lo_ioctl(struct block_device *bdev, fmode_t mode,
 		err = -EPERM;
 		if ((mode & FMODE_WRITE) || capable(CAP_SYS_ADMIN))
 			err = loop_set_status64(lo,
-					(struct loop_info64 __user *) arg);
+					(struct loop_info64 __user *) arg,
+					&rrpart);
 		break;
 	case LOOP_GET_STATUS64:
 		err = loop_get_status64(lo, (struct loop_info64 __user *) arg);
@@ -1334,6 +1339,9 @@ static int lo_ioctl(struct block_device *bdev, fmode_t mode,
 	mutex_unlock(&lo->lo_ctl_mutex);
 
 out_unlocked:
+	if (rrpart)
+		blkdev_reread_part(bdev, 0);
+
 	return err;
 }
 
@@ -1429,7 +1437,7 @@ loop_info64_to_compat(const struct loop_info64 *info64,
 
 static int
 loop_set_status_compat(struct loop_device *lo,
-		       const struct compat_loop_info __user *arg)
+		       const struct compat_loop_info __user *arg, int *rrpart)
 {
 	struct loop_info64 info64;
 	int ret;
@@ -1437,7 +1445,7 @@ loop_set_status_compat(struct loop_device *lo,
 	ret = loop_info64_from_compat(arg, &info64);
 	if (ret < 0)
 		return ret;
-	return loop_set_status(lo, &info64);
+	return loop_set_status(lo, &info64, rrpart);
 }
 
 static int
@@ -1460,14 +1468,17 @@ static int lo_compat_ioctl(struct block_device *bdev, fmode_t mode,
 			   unsigned int cmd, unsigned long arg)
 {
 	struct loop_device *lo = bdev->bd_disk->private_data;
-	int err;
+	int err, rrpart = 0;
 
 	switch(cmd) {
 	case LOOP_SET_STATUS:
 		mutex_lock(&lo->lo_ctl_mutex);
 		err = loop_set_status_compat(
-			lo, (const struct compat_loop_info __user *) arg);
+			lo, (const struct compat_loop_info __user *) arg,
+			&rrpart);
 		mutex_unlock(&lo->lo_ctl_mutex);
+		if (rrpart)
+			blkdev_reread_part(bdev, 0);
 		break;
 	case LOOP_GET_STATUS:
 		mutex_lock(&lo->lo_ctl_mutex);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 9ab779e..755a056 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2153,6 +2153,7 @@ extern const struct file_operations bad_sock_fops;
 #ifdef CONFIG_BLOCK
 extern int ioctl_by_bdev(struct block_device *, unsigned, unsigned long);
 extern int blkdev_ioctl(struct block_device *, fmode_t, unsigned, unsigned long);
+extern int blkdev_reread_part(struct block_device *bdev, int skipbusy);
 extern long compat_blkdev_ioctl(struct file *, unsigned, unsigned long);
 extern int blkdev_get(struct block_device *bdev, fmode_t mode, void *holder);
 extern struct block_device *blkdev_get_by_path(const char *path, fmode_t mode,
-- 
2.2.2

