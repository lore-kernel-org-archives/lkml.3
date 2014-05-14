Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbaENVgb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 17:36:31 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:33488 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590AbaENVfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 17:35:22 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>, Arnd Bergmann <arnd@arndb.de>,
        Eric Biederman <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        lxc-devel@lists.linuxcontainers.org,
        Seth Forshee <seth.forshee@canonical.com>
Subject: [RFC PATCH 08/11] block: Allow blkdev ioctls within user namespaces
Date: Wed, 14 May 2014 16:34:56 -0500
Message-Id: <1400103299-144589-9-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1400103299-144589-1-git-send-email-seth.forshee@canonical.com>
References: <1400103299-144589-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many blkdev ioctls require CAP_SYS_ADMIN, preventing them from
being used on block devices owned by unpriveleged user
namespaces. Change this to requiring only CAP_SYS_ADMIN within
the namespace which owns the device. Most devices are owned by
init_user_ns, and in that case this check is equivalent.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 block/compat_ioctl.c |  3 ++-
 block/ioctl.c        | 16 ++++++++--------
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/block/compat_ioctl.c b/block/compat_ioctl.c
index fbd5a67cb773..b16745d14ac2 100644
--- a/block/compat_ioctl.c
+++ b/block/compat_ioctl.c
@@ -10,6 +10,7 @@
 #include <linux/syscalls.h>
 #include <linux/types.h>
 #include <linux/uaccess.h>
+#include <linux/user_namespace.h>
 
 static int compat_put_ushort(unsigned long arg, unsigned short val)
 {
@@ -725,7 +726,7 @@ long compat_blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 					 !blk_queue_nonrot(bdev_get_queue(bdev)));
 	case BLKRASET: /* compatible, but no compat_ptr (!) */
 	case BLKFRASET:
-		if (!capable(CAP_SYS_ADMIN))
+		if (!ns_capable(disk_to_dev(disk)->ns, CAP_SYS_ADMIN))
 			return -EACCES;
 		bdi = blk_get_backing_dev_info(bdev);
 		if (bdi == NULL)
diff --git a/block/ioctl.c b/block/ioctl.c
index 7d5c3b20af45..45bb28d59b56 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -7,12 +7,13 @@
 #include <linux/backing-dev.h>
 #include <linux/fs.h>
 #include <linux/blktrace_api.h>
+#include <linux/user_namespace.h>
 #include <asm/uaccess.h>
 
 static int blkpg_ioctl(struct block_device *bdev, struct blkpg_ioctl_arg __user *arg)
 {
 	struct block_device *bdevp;
-	struct gendisk *disk;
+	struct gendisk *disk = bdev->bd_disk;
 	struct hd_struct *part, *lpart;
 	struct blkpg_ioctl_arg a;
 	struct blkpg_partition p;
@@ -20,13 +21,12 @@ static int blkpg_ioctl(struct block_device *bdev, struct blkpg_ioctl_arg __user
 	long long start, length;
 	int partno;
 
-	if (!capable(CAP_SYS_ADMIN))
+	if (!ns_capable(disk_to_dev(disk)->ns, CAP_SYS_ADMIN))
 		return -EACCES;
 	if (copy_from_user(&a, arg, sizeof(struct blkpg_ioctl_arg)))
 		return -EFAULT;
 	if (copy_from_user(&p, a.data, sizeof(struct blkpg_partition)))
 		return -EFAULT;
-	disk = bdev->bd_disk;
 	if (bdev != bdev->bd_contains)
 		return -EINVAL;
 	partno = p.pno;
@@ -157,7 +157,7 @@ static int blkdev_reread_part(struct block_device *bdev)
 
 	if (!disk_part_scan_enabled(disk) || bdev != bdev->bd_contains)
 		return -EINVAL;
-	if (!capable(CAP_SYS_ADMIN))
+	if (!ns_capable(disk_to_dev(disk)->ns, CAP_SYS_ADMIN))
 		return -EACCES;
 	if (!mutex_trylock(&bdev->bd_mutex))
 		return -EBUSY;
@@ -281,7 +281,7 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 
 	switch(cmd) {
 	case BLKFLSBUF:
-		if (!capable(CAP_SYS_ADMIN))
+		if (!ns_capable(disk_to_dev(disk)->ns, CAP_SYS_ADMIN))
 			return -EACCES;
 
 		ret = __blkdev_driver_ioctl(bdev, mode, cmd, arg);
@@ -296,7 +296,7 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 		ret = __blkdev_driver_ioctl(bdev, mode, cmd, arg);
 		if (!is_unrecognized_ioctl(ret))
 			return ret;
-		if (!capable(CAP_SYS_ADMIN))
+		if (!ns_capable(disk_to_dev(disk)->ns, CAP_SYS_ADMIN))
 			return -EACCES;
 		if (get_user(n, (int __user *)(arg)))
 			return -EFAULT;
@@ -380,7 +380,7 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 		return put_ushort(arg, !blk_queue_nonrot(bdev_get_queue(bdev)));
 	case BLKRASET:
 	case BLKFRASET:
-		if(!capable(CAP_SYS_ADMIN))
+		if(!ns_capable(disk_to_dev(disk)->ns, CAP_SYS_ADMIN))
 			return -EACCES;
 		bdi = blk_get_backing_dev_info(bdev);
 		if (bdi == NULL)
@@ -389,7 +389,7 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 		return 0;
 	case BLKBSZSET:
 		/* set the logical block size */
-		if (!capable(CAP_SYS_ADMIN))
+		if (!ns_capable(disk_to_dev(disk)->ns, CAP_SYS_ADMIN))
 			return -EACCES;
 		if (!arg)
 			return -EINVAL;
-- 
1.9.1

