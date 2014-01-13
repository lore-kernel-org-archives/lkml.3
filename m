Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751944AbaAMLUi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 06:20:38 -0500
Received: from mail-pd0-f177.google.com ([209.85.192.177]:37177 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751633AbaAMLT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 06:19:29 -0500
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Nitin Gupta <ngupta@vflare.org>,
        Jerome Marchand <jmarchan@redhat.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Minchan Kim <minchan@kernel.org>
Subject: [PATCH 4/7] zram: use atomic operation for stat
Date: Mon, 13 Jan 2014 20:18:59 +0900
Message-Id: <1389611942-15544-5-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.8.4.3
In-Reply-To: <1389611942-15544-1-git-send-email-minchan@kernel.org>
References: <1389611942-15544-1-git-send-email-minchan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some of fields in zram->stats are protected by zram->lock which
is rather coarse-grained so let's use atomic operation without
explict locking.

Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 drivers/block/zram/zram_drv.c | 20 ++++++++++----------
 drivers/block/zram/zram_drv.h | 16 ++++++----------
 2 files changed, 16 insertions(+), 20 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index ebfddd8..9ab8849 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -104,7 +104,7 @@ static ssize_t zero_pages_show(struct device *dev,
 {
 	struct zram *zram = dev_to_zram(dev);
 
-	return sprintf(buf, "%u\n", zram->stats.pages_zero);
+	return sprintf(buf, "%u\n", atomic_read(&zram->stats.pages_zero));
 }
 
 static ssize_t orig_data_size_show(struct device *dev,
@@ -113,7 +113,7 @@ static ssize_t orig_data_size_show(struct device *dev,
 	struct zram *zram = dev_to_zram(dev);
 
 	return sprintf(buf, "%llu\n",
-		(u64)(zram->stats.pages_stored) << PAGE_SHIFT);
+		(u64)(atomic_read(&zram->stats.pages_stored)) << PAGE_SHIFT);
 }
 
 static ssize_t compr_data_size_show(struct device *dev,
@@ -293,21 +293,21 @@ static void zram_free_page(struct zram *zram, size_t index)
 		 */
 		if (zram_test_flag(meta, index, ZRAM_ZERO)) {
 			zram_clear_flag(meta, index, ZRAM_ZERO);
-			zram->stats.pages_zero--;
+			atomic_dec(&zram->stats.pages_zero);
 		}
 		return;
 	}
 
 	if (unlikely(size > max_zpage_size))
-		zram->stats.bad_compress--;
+		atomic_dec(&zram->stats.bad_compress);
 
 	zs_free(meta->mem_pool, handle);
 
 	if (size <= PAGE_SIZE / 2)
-		zram->stats.good_compress--;
+		atomic_dec(&zram->stats.good_compress);
 
 	atomic64_sub(meta->table[index].size, &zram->stats.compr_size);
-	zram->stats.pages_stored--;
+	atomic_dec(&zram->stats.pages_stored);
 
 	meta->table[index].handle = 0;
 	meta->table[index].size = 0;
@@ -435,7 +435,7 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 		/* Free memory associated with this sector now. */
 		zram_free_page(zram, index);
 
-		zram->stats.pages_zero++;
+		atomic_inc(&zram->stats.pages_zero);
 		zram_set_flag(meta, index, ZRAM_ZERO);
 		ret = 0;
 		goto out;
@@ -456,7 +456,7 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 	}
 
 	if (unlikely(clen > max_zpage_size)) {
-		zram->stats.bad_compress++;
+		atomic_inc(&zram->stats.bad_compress);
 		clen = PAGE_SIZE;
 		src = NULL;
 		if (is_partial_io(bvec))
@@ -493,9 +493,9 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 
 	/* Update stats */
 	atomic64_add(clen, &zram->stats.compr_size);
-	zram->stats.pages_stored++;
+	atomic_inc(&zram->stats.pages_stored);
 	if (clen <= PAGE_SIZE / 2)
-		zram->stats.good_compress++;
+		atomic_inc(&zram->stats.good_compress);
 
 out:
 	if (is_partial_io(bvec))
diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
index 0e46953..81b0170 100644
--- a/drivers/block/zram/zram_drv.h
+++ b/drivers/block/zram/zram_drv.h
@@ -68,10 +68,6 @@ struct table {
 	u8 flags;
 } __aligned(4);
 
-/*
- * All 64bit fields should only be manipulated by 64bit atomic accessors.
- * All modifications to 32bit counter should be protected by zram->lock.
- */
 struct zram_stats {
 	atomic64_t compr_size;	/* compressed size of pages stored */
 	atomic64_t num_reads;	/* failed + successful */
@@ -80,10 +76,10 @@ struct zram_stats {
 	atomic64_t failed_writes;	/* can happen when memory is too low */
 	atomic64_t invalid_io;	/* non-page-aligned I/O requests */
 	atomic64_t notify_free;	/* no. of swap slot free notifications */
-	u32 pages_zero;		/* no. of zero filled pages */
-	u32 pages_stored;	/* no. of pages currently stored */
-	u32 good_compress;	/* % of pages with compression ratio<=50% */
-	u32 bad_compress;	/* % of pages with compression ratio>=75% */
+	atomic_t pages_zero;		/* no. of zero filled pages */
+	atomic_t pages_stored;	/* no. of pages currently stored */
+	atomic_t good_compress;	/* % of pages with compression ratio<=50% */
+	atomic_t bad_compress;	/* % of pages with compression ratio>=75% */
 };
 
 struct zram_meta {
@@ -101,8 +97,8 @@ struct zram_slot_free {
 struct zram {
 	struct zram_meta *meta;
 	struct rw_semaphore lock; /* protect compression buffers, table,
-				   * 32bit stat counters against concurrent
-				   * notifications, reads and writes */
+				   * reads and writes
+				   */
 
 	struct work_struct free_work;  /* handle pending free request */
 	struct zram_slot_free *slot_free_rq; /* list head of free request */
-- 
1.8.4.3

