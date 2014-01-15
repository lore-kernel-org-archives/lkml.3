Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154AbaAOBLp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 20:11:45 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:58308 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933AbaAOBK3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 20:10:29 -0500
X-AuditID: 9c93017e-b7b63ae000000e6a-e6-52d5e002d441
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Nitin Gupta <ngupta@vflare.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Jerome Marchand <jmarchan@redhat.com>,
        Minchan Kim <minchan@kernel.org>
Subject: [PATCH v2 2/4] zram: introduce zram->tb_lock
Date: Wed, 15 Jan 2014 10:11:08 +0900
Message-Id: <1389748270-15618-3-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1389748270-15618-1-git-send-email-minchan@kernel.org>
References: <1389748270-15618-1-git-send-email-minchan@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, table is protected by zram->lock but it's rather
coarse-grained lock and it makes hard for scalibility.

Let's use own rwlock instead of depending on zram->lock.
This patch adds new locking so obviously, it would make slow
but this patch is just prepartion for removing coarse-grained
rw_semaphore(ie, zram->lock) which is hurdle about zram
scalability.

Final patch in this patchset series will remove the lock
from read-path and change rw_semaphore with mutex in write path.
With bonus, we could drop pending slot free mess in next patch.

Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 drivers/staging/zram/zram_drv.c | 26 +++++++++++++++++++++-----
 drivers/staging/zram/zram_drv.h |  3 ++-
 2 files changed, 23 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 6613225dfca1..8636f8511518 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -140,6 +140,7 @@ static ssize_t mem_used_total_show(struct device *dev,
 	return sprintf(buf, "%llu\n", val);
 }
 
+/* flag operations needs meta->tb_lock */
 static int zram_test_flag(struct zram_meta *meta, u32 index,
 			enum zram_pageflags flag)
 {
@@ -227,6 +228,7 @@ static struct zram_meta *zram_meta_alloc(u64 disksize)
 		goto free_table;
 	}
 
+	rwlock_init(&meta->tb_lock);
 	return meta;
 
 free_table:
@@ -279,6 +281,7 @@ static void handle_zero_page(struct bio_vec *bvec)
 	flush_dcache_page(page);
 }
 
+/* NOTE: caller should hold meta->tb_lock with write-side */
 static void zram_free_page(struct zram *zram, size_t index)
 {
 	struct zram_meta *meta = zram->meta;
@@ -318,20 +321,26 @@ static int zram_decompress_page(struct zram *zram, char *mem, u32 index)
 	size_t clen = PAGE_SIZE;
 	unsigned char *cmem;
 	struct zram_meta *meta = zram->meta;
-	unsigned long handle = meta->table[index].handle;
+	unsigned long handle;
+	u16 size;
+
+	read_lock(&meta->tb_lock);
+	handle = meta->table[index].handle;
+	size = meta->table[index].size;
 
 	if (!handle || zram_test_flag(meta, index, ZRAM_ZERO)) {
+		read_unlock(&meta->tb_lock);
 		clear_page(mem);
 		return 0;
 	}
 
 	cmem = zs_map_object(meta->mem_pool, handle, ZS_MM_RO);
-	if (meta->table[index].size == PAGE_SIZE)
+	if (size == PAGE_SIZE)
 		copy_page(mem, cmem);
 	else
-		ret = lzo1x_decompress_safe(cmem, meta->table[index].size,
-						mem, &clen);
+		ret = lzo1x_decompress_safe(cmem, size,	mem, &clen);
 	zs_unmap_object(meta->mem_pool, handle);
+	read_unlock(&meta->tb_lock);
 
 	/* Should NEVER happen. Return bio error if it does. */
 	if (unlikely(ret != LZO_E_OK)) {
@@ -352,11 +361,14 @@ static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
 	struct zram_meta *meta = zram->meta;
 	page = bvec->bv_page;
 
+	read_lock(&meta->tb_lock);
 	if (unlikely(!meta->table[index].handle) ||
 			zram_test_flag(meta, index, ZRAM_ZERO)) {
+		read_unlock(&meta->tb_lock);
 		handle_zero_page(bvec);
 		return 0;
 	}
+	read_unlock(&meta->tb_lock);
 
 	if (is_partial_io(bvec))
 		/* Use  a temporary buffer to decompress the page */
@@ -432,10 +444,12 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 	if (page_zero_filled(uncmem)) {
 		kunmap_atomic(user_mem);
 		/* Free memory associated with this sector now. */
+		write_lock(&zram->meta->tb_lock);
 		zram_free_page(zram, index);
+		zram_set_flag(meta, index, ZRAM_ZERO);
+		write_unlock(&zram->meta->tb_lock);
 
 		atomic_inc(&zram->stats.pages_zero);
-		zram_set_flag(meta, index, ZRAM_ZERO);
 		ret = 0;
 		goto out;
 	}
@@ -485,10 +499,12 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 	 * Free memory associated with this sector
 	 * before overwriting unused sectors.
 	 */
+	write_lock(&zram->meta->tb_lock);
 	zram_free_page(zram, index);
 
 	meta->table[index].handle = handle;
 	meta->table[index].size = clen;
+	write_unlock(&zram->meta->tb_lock);
 
 	/* Update stats */
 	atomic64_add(clen, &zram->stats.compr_size);
diff --git a/drivers/staging/zram/zram_drv.h b/drivers/staging/zram/zram_drv.h
index 459483966c3d..cf64bea3f7cc 100644
--- a/drivers/staging/zram/zram_drv.h
+++ b/drivers/staging/zram/zram_drv.h
@@ -84,6 +84,7 @@ struct zram_stats {
 };
 
 struct zram_meta {
+	rwlock_t tb_lock;	/* protect table */
 	void *compress_workmem;
 	void *compress_buffer;
 	struct table *table;
@@ -97,7 +98,7 @@ struct zram_slot_free {
 
 struct zram {
 	struct zram_meta *meta;
-	struct rw_semaphore lock; /* protect compression buffers, table,
+	struct rw_semaphore lock; /* protect compression buffers,
 				   * reads and writes
 				   */
 
-- 
1.8.5.2

