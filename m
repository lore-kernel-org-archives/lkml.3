Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753764Ab3FFQMg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 12:12:36 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:39144 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685Ab3FFQMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 12:12:03 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Jerome Marchand <jmarchan@redhat.com>
Cc: Jiang Liu <jiang.liu@huawei.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3 10/10] zram: use atomic64_xxx() to replace zram_stat64_xxx()
Date: Fri,  7 Jun 2013 00:07:31 +0800
Message-Id: <1370534851-26056-11-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370534851-26056-1-git-send-email-jiang.liu@huawei.com>
References: <1370534851-26056-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use atomic64_xxx() to replace open-coded zram_stat64_xxx().
Some architectures have native support of atomic64 operations,
so we can get rid of the spin_lock() in zram_stat64_xxx().
On the other hand, for platforms use generic version of atomic64
implement, it may cause an extra save/restore of the interrupt
flag.  So it's a tradeoff.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
---
 drivers/staging/zram/zram_drv.c   | 37 ++++++++-----------------------------
 drivers/staging/zram/zram_drv.h   | 19 +++++++++++--------
 drivers/staging/zram/zram_sysfs.c | 21 +++++----------------
 3 files changed, 24 insertions(+), 53 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index b4f84b6b..518e87d 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -42,25 +42,6 @@ static struct zram *zram_devices;
 /* Module params (documentation at end) */
 static unsigned int num_devices = 1;
 
-static void zram_stat64_add(struct zram *zram, u64 *v, u64 inc)
-{
-	spin_lock(&zram->stat64_lock);
-	*v = *v + inc;
-	spin_unlock(&zram->stat64_lock);
-}
-
-static void zram_stat64_sub(struct zram *zram, u64 *v, u64 dec)
-{
-	spin_lock(&zram->stat64_lock);
-	*v = *v - dec;
-	spin_unlock(&zram->stat64_lock);
-}
-
-static void zram_stat64_inc(struct zram *zram, u64 *v)
-{
-	zram_stat64_add(zram, v, 1);
-}
-
 static int zram_test_flag(struct zram_meta *meta, u32 index,
 			enum zram_pageflags flag)
 {
@@ -120,8 +101,7 @@ static void zram_free_page(struct zram *zram, size_t index)
 	if (size <= PAGE_SIZE / 2)
 		zram->stats.good_compress--;
 
-	zram_stat64_sub(zram, &zram->stats.compr_size,
-			meta->table[index].size);
+	atomic64_sub(meta->table[index].size, &zram->stats.compr_size);
 	zram->stats.pages_stored--;
 
 	meta->table[index].handle = 0;
@@ -172,7 +152,7 @@ static int zram_decompress_page(struct zram *zram, char *mem, u32 index)
 	/* Should NEVER happen. Return bio error if it does. */
 	if (unlikely(ret != LZO_E_OK)) {
 		pr_err("Decompression failed! err=%d, page=%u\n", ret, index);
-		zram_stat64_inc(zram, &zram->stats.failed_reads);
+		atomic64_inc(&zram->stats.failed_reads);
 		return ret;
 	}
 
@@ -326,7 +306,7 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 	meta->table[index].size = clen;
 
 	/* Update stats */
-	zram_stat64_add(zram, &zram->stats.compr_size, clen);
+	atomic64_add(clen, &zram->stats.compr_size);
 	zram->stats.pages_stored++;
 	if (clen <= PAGE_SIZE / 2)
 		zram->stats.good_compress++;
@@ -336,7 +316,7 @@ out:
 		kfree(uncmem);
 
 	if (ret)
-		zram_stat64_inc(zram, &zram->stats.failed_writes);
+		atomic64_inc(&zram->stats.failed_writes);
 	return ret;
 }
 
@@ -373,10 +353,10 @@ static void __zram_make_request(struct zram *zram, struct bio *bio, int rw)
 
 	switch (rw) {
 	case READ:
-		zram_stat64_inc(zram, &zram->stats.num_reads);
+		atomic64_inc(&zram->stats.num_reads);
 		break;
 	case WRITE:
-		zram_stat64_inc(zram, &zram->stats.num_writes);
+		atomic64_inc(&zram->stats.num_writes);
 		break;
 	}
 
@@ -456,7 +436,7 @@ static void zram_make_request(struct request_queue *queue, struct bio *bio)
 		goto error;
 
 	if (!valid_io_request(zram, bio)) {
-		zram_stat64_inc(zram, &zram->stats.invalid_io);
+		atomic64_inc(&zram->stats.invalid_io);
 		goto error;
 	}
 
@@ -595,7 +575,7 @@ static void zram_slot_free_notify(struct block_device *bdev,
 	down_write(&zram->lock);
 	zram_free_page(zram, index);
 	up_write(&zram->lock);
-	zram_stat64_inc(zram, &zram->stats.notify_free);
+	atomic64_inc(&zram->stats.notify_free);
 }
 
 static const struct block_device_operations zram_devops = {
@@ -609,7 +589,6 @@ static int create_device(struct zram *zram, int device_id)
 
 	init_rwsem(&zram->lock);
 	init_rwsem(&zram->init_lock);
-	spin_lock_init(&zram->stat64_lock);
 
 	zram->queue = blk_alloc_queue(GFP_KERNEL);
 	if (!zram->queue) {
diff --git a/drivers/staging/zram/zram_drv.h b/drivers/staging/zram/zram_drv.h
index b3a315d..11b09fc 100644
--- a/drivers/staging/zram/zram_drv.h
+++ b/drivers/staging/zram/zram_drv.h
@@ -69,14 +69,18 @@ struct table {
 	u8 flags;
 } __aligned(4);
 
+/*
+ * All 64bit fields should only be manipulated by 64bit atomic accessors.
+ * All modifications to 32bit counter should be protected by zram->lock.
+ */
 struct zram_stats {
-	u64 compr_size;		/* compressed size of pages stored */
-	u64 num_reads;		/* failed + successful */
-	u64 num_writes;		/* --do-- */
-	u64 failed_reads;	/* should NEVER! happen */
-	u64 failed_writes;	/* can happen when memory is too low */
-	u64 invalid_io;		/* non-page-aligned I/O requests */
-	u64 notify_free;	/* no. of swap slot free notifications */
+	atomic64_t compr_size;	/* compressed size of pages stored */
+	atomic64_t num_reads;	/* failed + successful */
+	atomic64_t num_writes;	/* --do-- */
+	atomic64_t failed_reads;	/* should NEVER! happen */
+	atomic64_t failed_writes;	/* can happen when memory is too low */
+	atomic64_t invalid_io;	/* non-page-aligned I/O requests */
+	atomic64_t notify_free;	/* no. of swap slot free notifications */
 	u32 pages_zero;		/* no. of zero filled pages */
 	u32 pages_stored;	/* no. of pages currently stored */
 	u32 good_compress;	/* % of pages with compression ratio<=50% */
@@ -92,7 +96,6 @@ struct zram_meta {
 
 struct zram {
 	struct zram_meta *meta;
-	spinlock_t stat64_lock;	/* protect 64-bit stats */
 	struct rw_semaphore lock; /* protect compression buffers, table,
 				   * 32bit stat counters against concurrent
 				   * notifications, reads and writes */
diff --git a/drivers/staging/zram/zram_sysfs.c b/drivers/staging/zram/zram_sysfs.c
index e239d94..93a2f9c 100644
--- a/drivers/staging/zram/zram_sysfs.c
+++ b/drivers/staging/zram/zram_sysfs.c
@@ -19,17 +19,6 @@
 
 #include "zram_drv.h"
 
-static u64 zram_stat64_read(struct zram *zram, u64 *v)
-{
-	u64 val;
-
-	spin_lock(&zram->stat64_lock);
-	val = *v;
-	spin_unlock(&zram->stat64_lock);
-
-	return val;
-}
-
 static inline struct zram *dev_to_zram(struct device *dev)
 {
 	return (struct zram *)dev_to_disk(dev)->private_data;
@@ -116,7 +105,7 @@ static ssize_t num_reads_show(struct device *dev,
 	struct zram *zram = dev_to_zram(dev);
 
 	return sprintf(buf, "%llu\n",
-		zram_stat64_read(zram, &zram->stats.num_reads));
+			(u64)atomic64_read(&zram->stats.num_reads));
 }
 
 static ssize_t num_writes_show(struct device *dev,
@@ -125,7 +114,7 @@ static ssize_t num_writes_show(struct device *dev,
 	struct zram *zram = dev_to_zram(dev);
 
 	return sprintf(buf, "%llu\n",
-		zram_stat64_read(zram, &zram->stats.num_writes));
+			(u64)atomic64_read(&zram->stats.num_writes));
 }
 
 static ssize_t invalid_io_show(struct device *dev,
@@ -134,7 +123,7 @@ static ssize_t invalid_io_show(struct device *dev,
 	struct zram *zram = dev_to_zram(dev);
 
 	return sprintf(buf, "%llu\n",
-		zram_stat64_read(zram, &zram->stats.invalid_io));
+			(u64)atomic64_read(&zram->stats.invalid_io));
 }
 
 static ssize_t notify_free_show(struct device *dev,
@@ -143,7 +132,7 @@ static ssize_t notify_free_show(struct device *dev,
 	struct zram *zram = dev_to_zram(dev);
 
 	return sprintf(buf, "%llu\n",
-		zram_stat64_read(zram, &zram->stats.notify_free));
+			(u64)atomic64_read(&zram->stats.notify_free));
 }
 
 static ssize_t zero_pages_show(struct device *dev,
@@ -169,7 +158,7 @@ static ssize_t compr_data_size_show(struct device *dev,
 	struct zram *zram = dev_to_zram(dev);
 
 	return sprintf(buf, "%llu\n",
-		zram_stat64_read(zram, &zram->stats.compr_size));
+			(u64)atomic64_read(&zram->stats.compr_size));
 }
 
 static ssize_t mem_used_total_show(struct device *dev,
-- 
1.8.1.2

