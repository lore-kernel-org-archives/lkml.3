Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750986AbaEEECh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 00:02:37 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:47133 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736AbaEEECf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 00:02:35 -0400
X-AuditID: cbfee61b-b7f766d00000646c-29-53670d59fdcf
From: Weijie Yang <weijie.yang@samsung.com>
To: "'Minchan Kim'" <minchan@kernel.org>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Nitin Gupta'" <ngupta@vflare.org>,
        "'Sergey Senozhatsky'" <sergey.senozhatsky@gmail.com>,
        "'Bob Liu'" <bob.liu@oracle.com>,
        "'Dan Streetman'" <ddstreet@ieee.org>, weijie.yang.kh@gmail.com,
        heesub.shin@samsung.com,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux-MM'" <linux-mm@kvack.org>
Subject: [PATCH] zram: remove global tb_lock by using lock-free CAS
Date: Mon, 05 May 2014 12:01:21 +0800
Message-id: <000001cf6816$d538c370$7faa4a50$%yang@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9oFqx4MQ7DrwL3RienTnu1FdbXDA==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupikeLIzCtJLcpLzFFi42I5/e+xgG4kb3qwweOnKhZz1q9hs+g6NZXF
	4kLbbhaLg7OXMFlc3jWHzeLemv+sFsu+vme32NAyi91i7efH7BZPTvxnceDy2DnrLrvH0wkH
	mTw2repk89j0aRK7x4kZv1k8Pj69xeLRt2UVo8fOT5tZPT5vkgvgjOKySUnNySxLLdK3S+DK
	+LR1MnvBRNOKnq9ZDYwvtLoYOTkkBEwk3m+/wgJhi0lcuLeerYuRi0NIYBGjxLW1f5ggnD+M
	ElvmXWIGqWIT0Ja427+RFcQWEVCTWHfwBQtIEbPATSaJk8deM4EkhAWcJV78bGEEsVkEVCXW
	3Z8BtoJXwE5iw98FrBC2oMSPyffA4swC6hKT5i1ihrDlJTaveQtkcwCdpC7x6K8uxC49iZUL
	JrFClIhLbDxyi2UCo8AsJJNmIZk0C8mkWUhaFjCyrGIUTS1ILihOSs810itOzC0uzUvXS87P
	3cQIjqFn0jsYVzVYHGIU4GBU4uFNYE4PFmJNLCuuzD3EKMHBrCTCO4sRKMSbklhZlVqUH19U
	mpNafIhRmoNFSZz3YKt1oJBAemJJanZqakFqEUyWiYNTqoFxpfPc0E0hCrl+O63qy3dpFpst
	jWLeF/1NPuQMi+Hq5ydmTZTI+XFDuebLVNt1+5kOxa8QuS1u6SuQGRjzJ8kmc8f34IMvhYTb
	Ob+unOYoc8r/R+UmgWofCQlLVof/1/in2OQ5WPqsmB1grrnd8uOC4/xu7OfuhVxJ3nVVoNt0
	u7jwq2aFZx1KLMUZiYZazEXFiQCZF6RLnQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, we use a rwlock tb_lock to protect concurrent access to
whole zram meta table. However, according to the actual access model,
there is only a small chance for upper user access the same table[index],
so the current lock granularity is too big.

This patch add a atomic state for every table[index] to record its access,
by using CAS operation, protect concurrent access to the same table[index],
meanwhile allow the maximum concurrency.

On 64-bit system, it will not increase the meta table memory overhead, and
on 32-bit system with 4K page_size, it will increase about 1MB memory overhead
for 1GB zram. So, it is cost-efficient.

Test result:
(x86-64 Intel Core2 Q8400, system memory 4GB, Ubuntu 12.04,
kernel v3.15.0-rc3, zram 1GB with 4 max_comp_streams LZO,
take the average of 5 tests)

iozone -t 4 -R -r 16K -s 200M -I +Z

      Test          base	   lock-free	ratio
------------------------------------------------------
 Initial write   1348017.60    1424141.62   +5.6%
       Rewrite   1520189.16    1652504.81   +8.7%
          Read   8294445.45   11404668.35   +37.5%
       Re-read   8134448.83   11555483.75   +42.1%
  Reverse Read   6748717.97    8394478.17   +24.4%
   Stride read   7220276.66    9372229.95   +29.8%
   Random read   7133010.06    9187221.90   +28.8%
Mixed workload   4056980.71    5843370.85   +44.0%
  Random write   1470106.17    1608947.04   +9.4%
        Pwrite   1259493.72    1311055.32   +4.1%
         Pread   4247583.17    4652056.11   +9.5%

Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
---

This patch is based on linux-next tree, commit b5c8d48bf8f42 

 drivers/block/zram/zram_drv.c |   41 ++++++++++++++++++++++++++---------------
 drivers/block/zram/zram_drv.h |    5 ++++-
 2 files changed, 30 insertions(+), 16 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 48eccb3..8b70945
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -255,7 +255,6 @@ static struct zram_meta *zram_meta_alloc(u64 disksize)
 		goto free_table;
 	}
 
-	rwlock_init(&meta->tb_lock);
 	return meta;
 
 free_table:
@@ -339,12 +338,14 @@ static int zram_decompress_page(struct zram *zram, char *mem, u32 index)
 	unsigned long handle;
 	u16 size;
 
-	read_lock(&meta->tb_lock);
+	while(atomic_cmpxchg(&meta->table[index].state, IDLE, ACCESS) != IDLE)
+		cpu_relax();
+
 	handle = meta->table[index].handle;
 	size = meta->table[index].size;
 
 	if (!handle || zram_test_flag(meta, index, ZRAM_ZERO)) {
-		read_unlock(&meta->tb_lock);
+		atomic_set(&meta->table[index].state, IDLE);
 		clear_page(mem);
 		return 0;
 	}
@@ -355,7 +356,7 @@ static int zram_decompress_page(struct zram *zram, char *mem, u32 index)
 	else
 		ret = zcomp_decompress(zram->comp, cmem, size, mem);
 	zs_unmap_object(meta->mem_pool, handle);
-	read_unlock(&meta->tb_lock);
+	atomic_set(&meta->table[index].state, IDLE);
 
 	/* Should NEVER happen. Return bio error if it does. */
 	if (unlikely(ret)) {
@@ -376,14 +377,16 @@ static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
 	struct zram_meta *meta = zram->meta;
 	page = bvec->bv_page;
 
-	read_lock(&meta->tb_lock);
+	while(atomic_cmpxchg(&meta->table[index].state, IDLE, ACCESS) != IDLE)
+		cpu_relax();
+
 	if (unlikely(!meta->table[index].handle) ||
 			zram_test_flag(meta, index, ZRAM_ZERO)) {
-		read_unlock(&meta->tb_lock);
+		atomic_set(&meta->table[index].state, IDLE);
 		handle_zero_page(bvec);
 		return 0;
 	}
-	read_unlock(&meta->tb_lock);
+	atomic_set(&meta->table[index].state, IDLE);
 
 	if (is_partial_io(bvec))
 		/* Use  a temporary buffer to decompress the page */
@@ -461,10 +464,13 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 	if (page_zero_filled(uncmem)) {
 		kunmap_atomic(user_mem);
 		/* Free memory associated with this sector now. */
-		write_lock(&zram->meta->tb_lock);
+		while(atomic_cmpxchg(&meta->table[index].state,
+				IDLE, ACCESS) != IDLE)
+			cpu_relax();
+
 		zram_free_page(zram, index);
 		zram_set_flag(meta, index, ZRAM_ZERO);
-		write_unlock(&zram->meta->tb_lock);
+		atomic_set(&meta->table[index].state, IDLE);
 
 		atomic64_inc(&zram->stats.zero_pages);
 		ret = 0;
@@ -514,12 +520,13 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 	 * Free memory associated with this sector
 	 * before overwriting unused sectors.
 	 */
-	write_lock(&zram->meta->tb_lock);
+	while(atomic_cmpxchg(&meta->table[index].state, IDLE, ACCESS) != IDLE)
+		cpu_relax();
 	zram_free_page(zram, index);
 
 	meta->table[index].handle = handle;
 	meta->table[index].size = clen;
-	write_unlock(&zram->meta->tb_lock);
+	atomic_set(&meta->table[index].state, IDLE);
 
 	/* Update stats */
 	atomic64_add(clen, &zram->stats.compr_data_size);
@@ -560,6 +567,7 @@ static void zram_bio_discard(struct zram *zram, u32 index,
 			     int offset, struct bio *bio)
 {
 	size_t n = bio->bi_iter.bi_size;
+	struct zram_meta *meta = zram->meta;
 
 	/*
 	 * zram manages data in physical block size units. Because logical block
@@ -584,9 +592,11 @@ static void zram_bio_discard(struct zram *zram, u32 index,
 		 * Discard request can be large so the lock hold times could be
 		 * lengthy.  So take the lock once per page.
 		 */
-		write_lock(&zram->meta->tb_lock);
+		while(atomic_cmpxchg(&meta->table[index].state,
+				IDLE, ACCESS) != IDLE)
+			cpu_relax();
 		zram_free_page(zram, index);
-		write_unlock(&zram->meta->tb_lock);
+		atomic_set(&meta->table[index].state, IDLE);
 		index++;
 		n -= PAGE_SIZE;
 	}
@@ -804,9 +814,10 @@ static void zram_slot_free_notify(struct block_device *bdev,
 	zram = bdev->bd_disk->private_data;
 	meta = zram->meta;
 
-	write_lock(&meta->tb_lock);
+	while(atomic_cmpxchg(&meta->table[index].state, IDLE, ACCESS) != IDLE)
+		cpu_relax();
 	zram_free_page(zram, index);
-	write_unlock(&meta->tb_lock);
+	atomic_set(&meta->table[index].state, IDLE);
 	atomic64_inc(&zram->stats.notify_free);
 }
 
diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
index 7f21c14..76b2bb5
--- a/drivers/block/zram/zram_drv.h
+++ b/drivers/block/zram/zram_drv.h
@@ -61,9 +61,13 @@ enum zram_pageflags {
 
 /*-- Data structures */
 
+#define IDLE   0
+#define ACCESS 1
+
 /* Allocated for each disk page */
 struct table {
 	unsigned long handle;
+	atomic_t state;
 	u16 size;	/* object size (excluding header) */
 	u8 flags;
 } __aligned(4);
@@ -81,7 +85,6 @@ struct zram_stats {
 };
 
 struct zram_meta {
-	rwlock_t tb_lock;	/* protect table */
 	struct table *table;
 	struct zs_pool *mem_pool;
 };
-- 
1.7.10.4


