Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757014Ab3AYK5b (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 05:57:31 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:56824 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756816Ab3AYK4j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 05:56:39 -0500
From: Guo Chao <yan@linux.vnet.ibm.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 5/7] loopdev: move common code into loop_figure_size()
Date: Fri, 25 Jan 2013 18:56:20 +0800
Message-Id: <1359111382-12654-6-git-send-email-yan@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359111382-12654-1-git-send-email-yan@linux.vnet.ibm.com>
References: <1359111382-12654-1-git-send-email-yan@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012510-2674-0000-0000-00000799E0C4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update block device size in accord with gendisk size and let userspace
know the change in loop_figure_size(). This is a clean up to remove
common code of loop_figure_size()'s two callers.

Signed-off-by: Guo Chao <yan@linux.vnet.ibm.com>
---
 drivers/block/loop.c |   31 +++++++------------------------
 1 file changed, 7 insertions(+), 24 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index ed85036..6579f69 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -190,6 +190,7 @@ figure_loop_size(struct loop_device *lo, loff_t offset, loff_t sizelimit)
 {
 	loff_t size = get_size(offset, sizelimit, lo->lo_backing_file);
 	sector_t x = (sector_t)size;
+	struct block_device *bdev = lo->lo_device;
 
 	if (unlikely((loff_t)x != size))
 		return -EFBIG;
@@ -198,6 +199,9 @@ figure_loop_size(struct loop_device *lo, loff_t offset, loff_t sizelimit)
 	if (lo->lo_sizelimit != sizelimit)
 		lo->lo_sizelimit = sizelimit;
 	set_capacity(lo->lo_disk, x);
+	bd_set_size(bdev, (loff_t)get_capacity(bdev->bd_disk) << 9);
+	/* let user-space know about the new size */
+	kobject_uevent(&disk_to_dev(bdev->bd_disk)->kobj, KOBJ_CHANGE);
 	return 0;
 }
 
@@ -1091,15 +1095,10 @@ loop_set_status(struct loop_device *lo, const struct loop_info64 *info)
 		return err;
 
 	if (lo->lo_offset != info->lo_offset ||
-	    lo->lo_sizelimit != info->lo_sizelimit) {
-		struct block_device *bdev = lo->lo_device;
-
+	    lo->lo_sizelimit != info->lo_sizelimit)
 		if (figure_loop_size(lo, info->lo_offset, info->lo_sizelimit))
 			return -EFBIG;
 
-		bd_set_size(bdev, (loff_t)get_capacity(bdev->bd_disk) << 9);
-		kobject_uevent(&disk_to_dev(bdev->bd_disk)->kobj, KOBJ_CHANGE);
-	}
 	loop_config_discard(lo);
 
 	memcpy(lo->lo_file_name, info->lo_file_name, LO_NAME_SIZE);
@@ -1276,26 +1275,10 @@ loop_get_status64(struct loop_device *lo, struct loop_info64 __user *arg) {
 
 static int loop_set_capacity(struct loop_device *lo, struct block_device *bdev)
 {
-	int err;
-	sector_t sec;
-	loff_t sz;
-
-	err = -ENXIO;
 	if (unlikely(lo->lo_state != Lo_bound))
-		goto out;
-	err = figure_loop_size(lo, lo->lo_offset, lo->lo_sizelimit);
-	if (unlikely(err))
-		goto out;
-	sec = get_capacity(lo->lo_disk);
-	/* the width of sector_t may be narrow for bit-shift */
-	sz = sec;
-	sz <<= 9;
-	bd_set_size(bdev, sz);
-	/* let user-space know about the new size */
-	kobject_uevent(&disk_to_dev(bdev->bd_disk)->kobj, KOBJ_CHANGE);
+		return -ENXIO;
 
- out:
-	return err;
+	return figure_loop_size(lo, lo->lo_offset, lo->lo_sizelimit);
 }
 
 static int lo_ioctl(struct block_device *bdev, fmode_t mode,
-- 
1.7.9.5

