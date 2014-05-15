Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754678AbaEOICO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 04:02:14 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:36584 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751AbaEOICI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 04:02:08 -0400
X-AuditID: cbfee61a-b7f2b6d000006c4d-8c-5374747d0c5e
From: Weijie Yang <weijie.yang@samsung.com>
To: "'Minchan Kim'" <minchan@kernel.org>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Nitin Gupta'" <ngupta@vflare.org>,
        "'Sergey Senozhatsky'" <sergey.senozhatsky@gmail.com>,
        "'Bob Liu'" <bob.liu@oracle.com>,
        "'Dan Streetman'" <ddstreet@ieee.org>,
        "'Weijie Yang'" <weijie.yang.kh@gmail.com>,
        "'Heesub Shin'" <heesub.shin@samsung.com>,
        "'Davidlohr Bueso'" <davidlohr@hp.com>,
        "'Joonsoo Kim'" <js1304@gmail.com>,
        "'linux-kernel'" <linux-kernel@vger.kernel.org>,
        "'Linux-MM'" <linux-mm@kvack.org>
Subject: [PATCH v2] zram: remove global tb_lock with fine grain lock
Date: Thu, 15 May 2014 16:00:47 +0800
Message-id: <000101cf7013$f646ac30$e2d40490$%yang@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac9wE8fNh873uuYpQ8GXlmRvONSh6g==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprJIsWRmVeSWpSXmKPExsVy+t9jQd3akpJgg/339C3mrF/DZtF1aiqL
	xZL7whYX2nazWBycvYTJYubeuawWl3fNYbO4t+Y/q8Wyr+/ZLTa0zGK3WPv5MbvFkxP/WRx4
	PHbOusvusWvbTiaPpxMOMnlsWtXJ5rHp0yR2jxMzfrN4fHx6i8Wjb8sqRo+dnzazenzeJBfA
	FcVlk5Kak1mWWqRvl8CVMXvaJLaCpUkVJy7cYGpgfO/fxcjJISFgIrFzznM2CFtM4sK99UA2
	F4eQwHRGiZ13bkI5fxgltu64BVbFJqAtcbd/IyuILSKgJrHu4AsWkCJmgaPMEhs3XmUESQgL
	uEicf/YUrIFFQFVi6oKnYHFeATuJK4e3s0PYghI/Jt9jAbGZBdQlJs1bxAxhy0tsXvMWyOYA
	Okld4tFfXYhdehJzf52GKheX2HjkFssERoFZSCbNQjJpFpJJs5C0LGBkWcUomlqQXFCclJ5r
	qFecmFtcmpeul5yfu4kRHGHPpHYwrmywOMQowMGoxMPLMLk4WIg1say4MvcQowQHs5IIr0Ja
	SbAQb0piZVVqUX58UWlOavEhRmkOFiVx3gOt1oFCAumJJanZqakFqUUwWSYOTqkGxpId7rp9
	rYZl4Y9W/P1nZ76aQSP07JaOt+J/qt48UjN48fBeUqnCU9f8SC4bd8c230zFOMk3x9JlVlmE
	9lloH3z5Vydfzm9X/TwPh0aryuaelAieeTwWX+MM2Q/51u7ZzcsdOP3nx1kMi1mn1k7at1tC
	Oa/vtNxUnT3BxamaKtP/fClbeu+BEktxRqKhFnNRcSIAp+wolawCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, we use a rwlock tb_lock to protect concurrent access to
the whole zram meta table. However, according to the actual access model,
there is only a small chance for upper user to access the same table[index],
so the current lock granularity is too big.

The idea of optimization is to change the lock granularity from whole
meta table to per table entry (table -> table[index]), so that we can
protect concurrent access to the same table[index], meanwhile allow
the maximum concurrency.
With this in mind, several kinds of locks which could be used as a
per-entry lock were tested and compared:

Test environment:
x86-64 Intel Core2 Q8400, system memory 4GB, Ubuntu 12.04,
kernel v3.15.0-rc3 as base, zram with 4 max_comp_streams LZO.

iozone test:
iozone -t 4 -R -r 16K -s 200M -I +Z
(1GB zram with ext4 filesystem, take the average of 10 tests, KB/s)

      Test       base      CAS    spinlock    rwlock   bit_spinlock
-------------------------------------------------------------------
 Initial write  1381094   1425435   1422860   1423075   1421521
       Rewrite  1529479   1641199   1668762   1672855   1654910
          Read  8468009  11324979  11305569  11117273  10997202
       Re-read  8467476  11260914  11248059  11145336  10906486
  Reverse Read  6821393   8106334   8282174   8279195   8109186
   Stride read  7191093   8994306   9153982   8961224   9004434
   Random read  7156353   8957932   9167098   8980465   8940476
Mixed workload  4172747   5680814   5927825   5489578   5972253
  Random write  1483044   1605588   1594329   1600453   1596010
        Pwrite  1276644   1303108   1311612   1314228   1300960
         Pread  4324337   4632869   4618386   4457870   4500166

To enhance the possibility of access the same table[index] concurrently,
set zram a small disksize(10MB) and let threads run with large loop count.

fio test:
fio --bs=32k --randrepeat=1 --randseed=100 --refill_buffers
--scramble_buffers=1 --direct=1 --loops=3000 --numjobs=4
--filename=/dev/zram0 --name=seq-write --rw=write --stonewall
--name=seq-read --rw=read --stonewall --name=seq-readwrite
--rw=rw --stonewall --name=rand-readwrite --rw=randrw --stonewall
(10MB zram raw block device, take the average of 10 tests, KB/s)

    Test     base     CAS    spinlock    rwlock  bit_spinlock
-------------------------------------------------------------
seq-write   933789   999357   1003298    995961   1001958
 seq-read  5634130  6577930   6380861   6243912   6230006
   seq-rw  1405687  1638117   1640256   1633903   1634459
  rand-rw  1386119  1614664   1617211   1609267   1612471

All the optimization methods show a higher performance than the base,
however, it is hard to say which method is the most appropriate.

On the other hand, zram is mostly used on small embedded system, so we
don't want to increase any memory footprint.

This patch pick the bit_spinlock method, pack object size and page_flag
into an unsigned long table.value, so as to not increase any memory
overhead on both 32-bit and 64-bit system.

On the third hand, even though different kinds of locks have different
performances, we can ignore this difference, because:
if zram is used as zram swapfile, the swap subsystem can prevent concurrent
access to the same swapslot;
if zram is used as zram-blk for set up filesystem on it, the upper filesystem
and the page cache also prevent concurrent access of the same block mostly.
So we can ignore the different performances among locks.

Changes since v1: https://lkml.org/lkml/2014/5/5/1
  - replace CAS method with bit_spinlock method
  - rename zram_test_flag() to zram_test_zero()
  - add some comments
  - change the patch subject

Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
---
 drivers/block/zram/zram_drv.c |   84 +++++++++++++++++++++++------------------
 drivers/block/zram/zram_drv.h |   22 ++++++++---
 2 files changed, 63 insertions(+), 43 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 9849b52..81f2b3e 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -179,23 +179,32 @@ static ssize_t comp_algorithm_store(struct device *dev,
 	return len;
 }
 
-/* flag operations needs meta->tb_lock */
-static int zram_test_flag(struct zram_meta *meta, u32 index,
-			enum zram_pageflags flag)
+static int zram_test_zero(struct zram_meta *meta, u32 index)
 {
-	return meta->table[index].flags & BIT(flag);
+	return meta->table[index].value & BIT(ZRAM_ZERO);
 }
 
-static void zram_set_flag(struct zram_meta *meta, u32 index,
-			enum zram_pageflags flag)
+static void zram_set_zero(struct zram_meta *meta, u32 index)
 {
-	meta->table[index].flags |= BIT(flag);
+	meta->table[index].value |= BIT(ZRAM_ZERO);
 }
 
-static void zram_clear_flag(struct zram_meta *meta, u32 index,
-			enum zram_pageflags flag)
+static void zram_clear_zero(struct zram_meta *meta, u32 index)
 {
-	meta->table[index].flags &= ~BIT(flag);
+	meta->table[index].value &= ~BIT(ZRAM_ZERO);
+}
+
+static int zram_get_obj_size(struct zram_meta *meta, u32 index)
+{
+	return meta->table[index].value & (BIT(ZRAM_FLAG_SHIFT) - 1);
+}
+
+static void zram_set_obj_size(struct zram_meta *meta,
+					u32 index, int size)
+{
+	meta->table[index].value = (unsigned long)size |
+		((meta->table[index].value >> ZRAM_FLAG_SHIFT)
+		<< ZRAM_FLAG_SHIFT );
 }
 
 static inline int is_partial_io(struct bio_vec *bvec)
@@ -255,7 +264,6 @@ static struct zram_meta *zram_meta_alloc(u64 disksize)
 		goto free_table;
 	}
 
-	rwlock_init(&meta->tb_lock);
 	return meta;
 
 free_table:
@@ -304,19 +312,19 @@ static void handle_zero_page(struct bio_vec *bvec)
 	flush_dcache_page(page);
 }
 
-/* NOTE: caller should hold meta->tb_lock with write-side */
 static void zram_free_page(struct zram *zram, size_t index)
 {
 	struct zram_meta *meta = zram->meta;
 	unsigned long handle = meta->table[index].handle;
+	int size;
 
 	if (unlikely(!handle)) {
 		/*
 		 * No memory is allocated for zero filled pages.
 		 * Simply clear zero page flag.
 		 */
-		if (zram_test_flag(meta, index, ZRAM_ZERO)) {
-			zram_clear_flag(meta, index, ZRAM_ZERO);
+		if (zram_test_zero(meta, index)) {
+			zram_clear_zero(meta, index);
 			atomic64_dec(&zram->stats.zero_pages);
 		}
 		return;
@@ -324,27 +332,28 @@ static void zram_free_page(struct zram *zram, size_t index)
 
 	zs_free(meta->mem_pool, handle);
 
-	atomic64_sub(meta->table[index].size, &zram->stats.compr_data_size);
+	size = zram_get_obj_size(meta, index);
+	atomic64_sub(size, &zram->stats.compr_data_size);
 	atomic64_dec(&zram->stats.pages_stored);
 
 	meta->table[index].handle = 0;
-	meta->table[index].size = 0;
+	zram_set_obj_size(meta, index, 0);
 }
 
 static int zram_decompress_page(struct zram *zram, char *mem, u32 index)
 {
-	int ret = 0;
 	unsigned char *cmem;
 	struct zram_meta *meta = zram->meta;
 	unsigned long handle;
-	u16 size;
+	int size;
+	int ret = 0;
 
-	read_lock(&meta->tb_lock);
+	bit_spin_lock(ZRAM_ACCESS, &meta->table[index].value);
 	handle = meta->table[index].handle;
-	size = meta->table[index].size;
+	size = zram_get_obj_size(meta, index);
 
-	if (!handle || zram_test_flag(meta, index, ZRAM_ZERO)) {
-		read_unlock(&meta->tb_lock);
+	if (!handle || zram_test_zero(meta, index)) {
+		bit_spin_unlock(ZRAM_ACCESS, &meta->table[index].value);
 		clear_page(mem);
 		return 0;
 	}
@@ -355,7 +364,7 @@ static int zram_decompress_page(struct zram *zram, char *mem, u32 index)
 	else
 		ret = zcomp_decompress(zram->comp, cmem, size, mem);
 	zs_unmap_object(meta->mem_pool, handle);
-	read_unlock(&meta->tb_lock);
+	bit_spin_unlock(ZRAM_ACCESS, &meta->table[index].value);
 
 	/* Should NEVER happen. Return bio error if it does. */
 	if (unlikely(ret)) {
@@ -376,14 +385,14 @@ static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
 	struct zram_meta *meta = zram->meta;
 	page = bvec->bv_page;
 
-	read_lock(&meta->tb_lock);
+	bit_spin_lock(ZRAM_ACCESS, &meta->table[index].value);
 	if (unlikely(!meta->table[index].handle) ||
-			zram_test_flag(meta, index, ZRAM_ZERO)) {
-		read_unlock(&meta->tb_lock);
+			zram_test_zero(meta, index)) {
+		bit_spin_unlock(ZRAM_ACCESS, &meta->table[index].value);
 		handle_zero_page(bvec);
 		return 0;
 	}
-	read_unlock(&meta->tb_lock);
+	bit_spin_unlock(ZRAM_ACCESS, &meta->table[index].value);
 
 	if (is_partial_io(bvec))
 		/* Use  a temporary buffer to decompress the page */
@@ -461,10 +470,10 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 	if (page_zero_filled(uncmem)) {
 		kunmap_atomic(user_mem);
 		/* Free memory associated with this sector now. */
-		write_lock(&zram->meta->tb_lock);
+		bit_spin_lock(ZRAM_ACCESS, &meta->table[index].value);
 		zram_free_page(zram, index);
-		zram_set_flag(meta, index, ZRAM_ZERO);
-		write_unlock(&zram->meta->tb_lock);
+		zram_set_zero(meta, index);
+		bit_spin_unlock(ZRAM_ACCESS, &meta->table[index].value);
 
 		atomic64_inc(&zram->stats.zero_pages);
 		ret = 0;
@@ -514,12 +523,12 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 	 * Free memory associated with this sector
 	 * before overwriting unused sectors.
 	 */
-	write_lock(&zram->meta->tb_lock);
+	bit_spin_lock(ZRAM_ACCESS, &meta->table[index].value);
 	zram_free_page(zram, index);
 
 	meta->table[index].handle = handle;
-	meta->table[index].size = clen;
-	write_unlock(&zram->meta->tb_lock);
+	zram_set_obj_size(meta, index, clen);
+	bit_spin_unlock(ZRAM_ACCESS, &meta->table[index].value);
 
 	/* Update stats */
 	atomic64_add(clen, &zram->stats.compr_data_size);
@@ -560,6 +569,7 @@ static void zram_bio_discard(struct zram *zram, u32 index,
 			     int offset, struct bio *bio)
 {
 	size_t n = bio->bi_iter.bi_size;
+	struct zram_meta *meta = zram->meta;
 
 	/*
 	 * zram manages data in physical block size units. Because logical block
@@ -584,9 +594,9 @@ static void zram_bio_discard(struct zram *zram, u32 index,
 		 * Discard request can be large so the lock hold times could be
 		 * lengthy.  So take the lock once per page.
 		 */
-		write_lock(&zram->meta->tb_lock);
+		bit_spin_lock(ZRAM_ACCESS, &meta->table[index].value);
 		zram_free_page(zram, index);
-		write_unlock(&zram->meta->tb_lock);
+		bit_spin_unlock(ZRAM_ACCESS, &meta->table[index].value);
 		index++;
 		n -= PAGE_SIZE;
 	}
@@ -804,9 +814,9 @@ static void zram_slot_free_notify(struct block_device *bdev,
 	zram = bdev->bd_disk->private_data;
 	meta = zram->meta;
 
-	write_lock(&meta->tb_lock);
+	bit_spin_lock(ZRAM_ACCESS, &meta->table[index].value);
 	zram_free_page(zram, index);
-	write_unlock(&meta->tb_lock);
+	bit_spin_unlock(ZRAM_ACCESS, &meta->table[index].value);
 	atomic64_inc(&zram->stats.notify_free);
 }
 
diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
index 7f21c14..caf620e 100644
--- a/drivers/block/zram/zram_drv.h
+++ b/drivers/block/zram/zram_drv.h
@@ -51,10 +51,22 @@ static const size_t max_zpage_size = PAGE_SIZE / 4 * 3;
 #define ZRAM_SECTOR_PER_LOGICAL_BLOCK	\
 	(1 << (ZRAM_LOGICAL_BLOCK_SHIFT - SECTOR_SHIFT))
 
-/* Flags for zram pages (table[page_no].flags) */
+/*
+ * The lower ZRAM_FLAG_SHIFT bits of table.value is for
+ * object size (excluding header), the higher bits is for
+ * zram_pageflags. By this means, it won't increase any
+ * memory overhead on both 32-bit and 64-bit system.
+ * zram is mostly used on small embedded system, so we
+ * don't want to increase memory footprint. That is why
+ * we pack size and flag into table.value.
+ */
+#define ZRAM_FLAG_SHIFT 24
+
+/* Flags for zram pages (table[page_no].value) */
 enum zram_pageflags {
 	/* Page consists entirely of zeros */
-	ZRAM_ZERO,
+	ZRAM_ZERO = ZRAM_FLAG_SHIFT + 1,
+	ZRAM_ACCESS,  /* page in now accessed */
 
 	__NR_ZRAM_PAGEFLAGS,
 };
@@ -64,9 +76,8 @@ enum zram_pageflags {
 /* Allocated for each disk page */
 struct table {
 	unsigned long handle;
-	u16 size;	/* object size (excluding header) */
-	u8 flags;
-} __aligned(4);
+	unsigned long value;
+};
 
 struct zram_stats {
 	atomic64_t compr_data_size;	/* compressed size of pages stored */
@@ -81,7 +92,6 @@ struct zram_stats {
 };
 
 struct zram_meta {
-	rwlock_t tb_lock;	/* protect table */
 	struct table *table;
 	struct zs_pool *mem_pool;
 };
-- 
1.7.10.4


