Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896Ab3AYK4n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 05:56:43 -0500
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:60823 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756802Ab3AYK4h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 05:56:37 -0500
From: Guo Chao <yan@linux.vnet.ibm.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/7] loopdev: update block device size in loop_set_status()
Date: Fri, 25 Jan 2013 18:56:19 +0800
Message-Id: <1359111382-12654-5-git-send-email-yan@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359111382-12654-1-git-send-email-yan@linux.vnet.ibm.com>
References: <1359111382-12654-1-git-send-email-yan@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012510-8878-0000-0000-000005A83864
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Loop device driver sometimes fails to impose the size limit on the
device. Keep issuing following two commands:

losetup --offset 7517244416 --sizelimit 3224971264 /dev/loop0 backed_file
blockdev --getsize64 /dev/loop0

blockdev reports file size instead of sizelimit several out of 100 times.

The problems are:

	- losetup set up the device in two ioctl:
		  LOOP_SET_FD and LOOP_SET_STATUS64.

	- LOOP_SET_STATUS64 only update size of gendisk.

Block device size will be updated lazily when device comes to use. If udev
rushes in between the two ioctl, it will bring in a block device whose
size is backing file size. If the device is not released after
LOOP_SET_STATUS64 ioctl, blockdev will not see the updated size.

Update block size in LOOP_SET_STATUS64 ioctl.

Reported-by: M. Hindess <hindessm@uk.ibm.com>
Signed-off-by: Guo Chao <yan@linux.vnet.ibm.com>
---
 drivers/block/loop.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 7f80653..ed85036 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1092,8 +1092,13 @@ loop_set_status(struct loop_device *lo, const struct loop_info64 *info)
 
 	if (lo->lo_offset != info->lo_offset ||
 	    lo->lo_sizelimit != info->lo_sizelimit) {
+		struct block_device *bdev = lo->lo_device;
+
 		if (figure_loop_size(lo, info->lo_offset, info->lo_sizelimit))
 			return -EFBIG;
+
+		bd_set_size(bdev, (loff_t)get_capacity(bdev->bd_disk) << 9);
+		kobject_uevent(&disk_to_dev(bdev->bd_disk)->kobj, KOBJ_CHANGE);
 	}
 	loop_config_discard(lo);
 
-- 
1.7.9.5

