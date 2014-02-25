Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964AbaBYBIa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 20:08:30 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:64692 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbaBYBIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 20:08:18 -0500
X-AuditID: 9c93017e-b7cf9ae000004b4b-a6-530becffdcec
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Nitin Gupta <ngupta@vflare.org>, Jerome Marchand <jmarchan@redhat.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        linux-kernel@vger.kernel.org, Minchan Kim <minchan@kernel.org>
Subject: [PATCH 2/2] zram: delete zram_init_device() function
Date: Tue, 25 Feb 2014 10:08:36 +0900
Message-Id: <1393290516-21158-2-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1393290516-21158-1-git-send-email-minchan@kernel.org>
References: <1393290516-21158-1-git-send-email-minchan@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

allocate new `zram_meta' in disksize_store() only for uninitialised
zram device, saving a number of allocations and deallocations in case
if disksize_store() was called on currently used device. at the same
time zram_meta stack variable is not necessary, because we can set
->meta directly. there is also no need in setting QUEUE_FLAG_NONROT
queue on every disksize_store(), set it once during device creation.

[minchan@kernel.org]: handled zram->meta alloc fail case.
Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 drivers/block/zram/zram_drv.c | 25 +++++++++----------------
 1 file changed, 9 insertions(+), 16 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 21aee3edcb25..9baac5b76bfe 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -533,40 +533,32 @@ static void zram_reset_device(struct zram *zram, bool reset_capacity)
 	up_write(&zram->init_lock);
 }
 
-static void zram_init_device(struct zram *zram, struct zram_meta *meta)
-{
-	/* zram devices sort of resembles non-rotational disks */
-	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, zram->disk->queue);
-	zram->meta = meta;
-	pr_debug("Initialization done!\n");
-}
-
 static ssize_t disksize_store(struct device *dev,
 		struct device_attribute *attr, const char *buf, size_t len)
 {
 	u64 disksize;
-	struct zram_meta *meta;
 	struct zram *zram = dev_to_zram(dev);
 
 	disksize = memparse(buf, NULL);
 	if (!disksize)
 		return -EINVAL;
 
-	disksize = PAGE_ALIGN(disksize);
-	meta = zram_meta_alloc(disksize);
-	if (!meta)
-		return -ENOMEM;
 	down_write(&zram->init_lock);
 	if (init_done(zram)) {
 		up_write(&zram->init_lock);
-		zram_meta_free(meta);
 		pr_info("Cannot change disksize for initialized device\n");
 		return -EBUSY;
 	}
 
+	disksize = PAGE_ALIGN(disksize);
+	zram->meta = zram_meta_alloc(disksize);
+	if (!zram->meta) {
+		up_write(&zram->init_lock);
+		return -ENOMEM;
+	}
+
 	zram->disksize = disksize;
 	set_capacity(zram->disk, zram->disksize >> SECTOR_SHIFT);
-	zram_init_device(zram, meta);
 	up_write(&zram->init_lock);
 
 	return len;
@@ -776,7 +768,8 @@ static int create_device(struct zram *zram, int device_id)
 
 	/* Actual capacity set using syfs (/sys/block/zram<id>/disksize */
 	set_capacity(zram->disk, 0);
-
+	/* zram devices sort of resembles non-rotational disks */
+	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, zram->disk->queue);
 	/*
 	 * To ensure that we always get PAGE_SIZE aligned
 	 * and n*PAGE_SIZED sized I/O requests.
-- 
1.8.5.3

