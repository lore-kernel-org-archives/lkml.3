Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127AbaAQLHh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 06:07:37 -0500
Received: from mail-ea0-f175.google.com ([209.85.215.175]:39368 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767AbaAQLHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 06:07:25 -0500
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: [RFC PATCH 1/3] zram: delete zram_init_device() function
Date: Fri, 17 Jan 2014 14:04:15 +0300
Message-Id: <1389956657-5486-2-git-send-email-sergey.senozhatsky@gmail.com>
X-Mailer: git-send-email 1.8.5.3.493.gb139ac2
In-Reply-To: <1389956657-5486-1-git-send-email-sergey.senozhatsky@gmail.com>
References: <1389956657-5486-1-git-send-email-sergey.senozhatsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

allocate new `zram_meta' in disksize_store() only for uninitialised
zram device, saving a number of allocations and deallocations in case
if disksize_store() was called on currently used device. at the same
time zram_meta stack variable is not necessary, because we can set
->meta directly. there is also no need in setting QUEUE_FLAG_NONROT
queue on every disksize_store(), set it once during device creation.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
---
 drivers/block/zram/zram_drv.c | 19 +++++--------------
 1 file changed, 5 insertions(+), 14 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 5ec61be..7124042 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -533,38 +533,28 @@ static void zram_reset_device(struct zram *zram, bool reset_capacity)
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
 	down_write(&zram->init_lock);
 	if (init_done(zram)) {
 		up_write(&zram->init_lock);
-		zram_meta_free(meta);
 		pr_info("Cannot change disksize for initialized device\n");
 		return -EBUSY;
 	}
 
+	disksize = PAGE_ALIGN(disksize);
+	zram->meta = zram_meta_alloc(disksize);
+
 	zram->disksize = disksize;
 	set_capacity(zram->disk, zram->disksize >> SECTOR_SHIFT);
-	zram_init_device(zram, meta);
 	up_write(&zram->init_lock);
 
 	return len;
@@ -774,7 +764,8 @@ static int create_device(struct zram *zram, int device_id)
 
 	/* Actual capacity set using syfs (/sys/block/zram<id>/disksize */
 	set_capacity(zram->disk, 0);
-
+	/* zram devices sort of resembles non-rotational disks */
+	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, zram->disk->queue);
 	/*
 	 * To ensure that we always get PAGE_SIZE aligned
 	 * and n*PAGE_SIZED sized I/O requests.
-- 
1.8.5.3.493.gb139ac2

