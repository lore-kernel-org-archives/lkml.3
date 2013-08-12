Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842Ab3HLGOD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 02:14:03 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:52098 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754164Ab3HLGOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 02:14:00 -0400
X-AuditID: 9c93017d-b7cdfae0000026c0-58-52087d269269
From: Minchan Kim <minchan@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Minchan Kim <minchan@kernel.org>,
        Nitin Gupta <ngupta@vflare.org>, Jiang Liu <jiang.liu@huawei.com>,
        stable@vger.kernel.org
Subject: [PATCH] zram: fix invalid memory access
Date: Mon, 12 Aug 2013 15:13:55 +0900
Message-Id: <1376288036-14628-1-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[1] tried to fix invalid memory access on zram->disk but it didn't
fix properly because get_disk failed during module exit path.

Actually, we don't need to reset zram->disk's capacity to zero
in module exit path so that this patch introduces new argument
"reset_capacity" on zram_reset_divice and it only reset it when
reset_store is called.

[1] 6030ea9b,  zram: avoid invalid memory access in zram_exit()

Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Jiang Liu <jiang.liu@huawei.com>
Cc: stable@vger.kernel.org
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 drivers/staging/zram/zram_drv.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 7ebf91d..ebf9d6c 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -523,7 +523,7 @@ static int zram_bvec_rw(struct zram *zram, struct bio_vec *bvec, u32 index,
 	return ret;
 }
 
-static void zram_reset_device(struct zram *zram)
+static void zram_reset_device(struct zram *zram, bool reset_capacity)
 {
 	size_t index;
 	struct zram_meta *meta;
@@ -552,7 +552,8 @@ static void zram_reset_device(struct zram *zram)
 	memset(&zram->stats, 0, sizeof(zram->stats));
 
 	zram->disksize = 0;
-	set_capacity(zram->disk, 0);
+	if (reset_capacity)
+		set_capacity(zram->disk, 0);
 	up_write(&zram->init_lock);
 }
 
@@ -636,7 +637,7 @@ static ssize_t reset_store(struct device *dev,
 	if (bdev)
 		fsync_bdev(bdev);
 
-	zram_reset_device(zram);
+	zram_reset_device(zram, true);
 	return len;
 }
 
@@ -903,10 +904,12 @@ static void __exit zram_exit(void)
 	for (i = 0; i < num_devices; i++) {
 		zram = &zram_devices[i];
 
-		get_disk(zram->disk);
 		destroy_device(zram);
-		zram_reset_device(zram);
-		put_disk(zram->disk);
+		/*
+		 * Shouldn't access zram->disk after destroy_device
+		 * because destroy_device already released zram->disk.
+		 */
+		zram_reset_device(zram, false);
 	}
 
 	unregister_blkdev(zram_major, "zram");
-- 
1.7.9.5

