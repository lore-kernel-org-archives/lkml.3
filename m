Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751725AbaC2O2x (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 10:28:53 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:53203 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbaC2O2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 10:28:52 -0400
From: Akinobu Mita <akinobu.mita@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] block: fix BLKSECTGET ioctl when max_sectors is greater than USHRT_MAX
Date: Sat, 29 Mar 2014 23:28:41 +0900
Message-Id: <1396103322-3519-1-git-send-email-akinobu.mita@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BLKSECTGET ioctl loads the request queue's max_sectors as unsigned
short value to the argument pointer.  So if the max_sector is greater
than USHRT_MAX, the upper 16 bits of that is just discarded.

In such case, USHRT_MAX is more preferable than the lower 16 bits of
max_sectors.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
---
 block/compat_ioctl.c | 6 ++++--
 block/ioctl.c        | 5 ++++-
 2 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/block/compat_ioctl.c b/block/compat_ioctl.c
index fbd5a67..e0393cd 100644
--- a/block/compat_ioctl.c
+++ b/block/compat_ioctl.c
@@ -663,6 +663,7 @@ long compat_blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 	fmode_t mode = file->f_mode;
 	struct backing_dev_info *bdi;
 	loff_t size;
+	unsigned int max_sectors;
 
 	/*
 	 * O_NDELAY can be altered using fcntl(.., F_SETFL, ..), so we have
@@ -718,8 +719,9 @@ long compat_blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 	case BLKSSZGET: /* get block device hardware sector size */
 		return compat_put_int(arg, bdev_logical_block_size(bdev));
 	case BLKSECTGET:
-		return compat_put_ushort(arg,
-					 queue_max_sectors(bdev_get_queue(bdev)));
+		max_sectors = min_t(unsigned int, USHRT_MAX,
+				    queue_max_sectors(bdev_get_queue(bdev)));
+		return compat_put_ushort(arg, max_sectors);
 	case BLKROTATIONAL:
 		return compat_put_ushort(arg,
 					 !blk_queue_nonrot(bdev_get_queue(bdev)));
diff --git a/block/ioctl.c b/block/ioctl.c
index 7d5c3b2..d6cda81 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -278,6 +278,7 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 	struct backing_dev_info *bdi;
 	loff_t size;
 	int ret, n;
+	unsigned int max_sectors;
 
 	switch(cmd) {
 	case BLKFLSBUF:
@@ -375,7 +376,9 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 	case BLKDISCARDZEROES:
 		return put_uint(arg, bdev_discard_zeroes_data(bdev));
 	case BLKSECTGET:
-		return put_ushort(arg, queue_max_sectors(bdev_get_queue(bdev)));
+		max_sectors = min_t(unsigned int, USHRT_MAX,
+				    queue_max_sectors(bdev_get_queue(bdev)));
+		return put_ushort(arg, max_sectors);
 	case BLKROTATIONAL:
 		return put_ushort(arg, !blk_queue_nonrot(bdev_get_queue(bdev)));
 	case BLKRASET:
-- 
1.8.3.2

