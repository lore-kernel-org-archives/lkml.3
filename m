Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754020Ab3CCStQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 13:49:16 -0500
Received: from cdptpa-omtalb.mail.rr.com ([75.180.132.120]:35839 "EHLO
	cdptpa-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753908Ab3CCStP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 13:49:15 -0500
X-Authority-Analysis: v=2.0 cv=cYNQXw/M c=1 sm=0 a=C56BoFkcj+OI1kjAe8jE5A==:17 a=MtVMNMWb1ewA:10 a=BjhBlCK6cPEA:10 a=S1A5HrydsesA:10 a=fxJcL_dCAAAA:8 a=okkl7HI8WYwA:10 a=OXeuF8pxMM_4sejTAF4A:9 a=2eKvNQJKnqYA:10 a=C56BoFkcj+OI1kjAe8jE5A==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 142.196.87.46
From: Phillip Susi <psusi@ubuntu.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] loop: cleanup partitions when detaching loop device
Date: Sun,  3 Mar 2013 13:49:13 -0500
Message-Id: <1362336553-16880-1-git-send-email-psusi@ubuntu.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any partitions added by user space to the loop device were being
left in place after detaching the loop device.  This was because
the detach path issued a BLKRRPART to clean up partitions if
LO_FLAGS_PARTSCAN was set, meaning that the partitions were auto
scanned on attach.  Replace this BLKRRPART with code that
unconditionally cleans up partitions on detach instead.

Signed-off-by: Phillip Susi <psusi@ubuntu.com>
---
 drivers/block/loop.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index ae12512..38f0239 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1039,12 +1039,24 @@ static int loop_clr_fd(struct loop_device *lo)
 	lo->lo_state = Lo_unbound;
 	/* This is safe: open() is still holding a reference. */
 	module_put(THIS_MODULE);
-	if (lo->lo_flags & LO_FLAGS_PARTSCAN && bdev)
-		ioctl_by_bdev(bdev, BLKRRPART, 0);
 	lo->lo_flags = 0;
 	if (!part_shift)
 		lo->lo_disk->flags |= GENHD_FL_NO_PART_SCAN;
 	mutex_unlock(&lo->lo_ctl_mutex);
+	if (bdev)
+	{
+		struct disk_part_iter piter;
+		struct hd_struct *part;
+
+		mutex_lock_nested(&bdev->bd_mutex, 1);
+		invalidate_partition(bdev->bd_disk, 0);
+		disk_part_iter_init(&piter, bdev->bd_disk, DISK_PITER_INCL_EMPTY);
+		while ((part = disk_part_iter_next(&piter)))
+			delete_partition(bdev->bd_disk, part->partno);
+		disk_part_iter_exit(&piter);
+		mutex_unlock(&bdev->bd_mutex);
+	}
+
 	/*
 	 * Need not hold lo_ctl_mutex to fput backing file.
 	 * Calling fput holding lo_ctl_mutex triggers a circular
-- 
1.8.1.2

