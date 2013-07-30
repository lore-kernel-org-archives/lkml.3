Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757284Ab3G3Sqg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 14:46:36 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:54276 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757016Ab3G3Sqe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 14:46:34 -0400
Date: Tue, 30 Jul 2013 21:45:42 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Piotr Sarna <p.sarna@partner.samsung.com>
Cc: devel@driverdev.osuosl.org, b.zolnierkie@samsung.com,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>, ngupta@vflare.org
Subject: Re: [PATCH 2/2] staging: zram: add per-cpu support to Crypto
Message-ID: <20130730184542.GA2299@swordfish>
References: <1375187449-6546-1-git-send-email-p.sarna@partner.samsung.com>
 <1375187449-6546-2-git-send-email-p.sarna@partner.samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375187449-6546-2-git-send-email-p.sarna@partner.samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (07/30/13 14:30), Piotr Sarna wrote:
> 
> Since original zram code did not implement any per-cpu operations,
> my previous patch (staging: zram: add Crypto API support) did not
> include them either.
> 
> This patch complements the first one with per-cpu support for Crypto,
> allocating tfms buffer separately for each online processor.
> Changes are based on zswap and zcache per-cpu code.
> 
> Basic tests (concurrent writing several 10-40MB chunks to zram) performed
> on an ARM-based EXYNOS4412 Quad-Core showed that per-cpu code provides
> noticeable time saving, ranging between 30-40% for LZO and LZ4 compressors.
> Sample data (LZO): writing 160MB, 40MB per thread took 0.60s with per-cpu
> code included and approximately 0.80s without per-cpu support.

Hello,

I've been working on similar thing, though my implementation does not deal
with per-cpu data and CPU hotplug actions. I know Greg's opinion on your patch
set, so I just share my thoughts/work.


Each zram device contains a list of workmem structures with required
compression/decompression and algorithm working memory pre-allocated. The
number of allocated workmem structures is limited to online CPUs number. Each
reader/writer performs idle workmem list lookup, with possible cases:
-- idle workmem exist: removes it from idle list and performs operation
-- idle workmem does not exist:
	a) workmem number is less than online CPUs: allocate new workmem
	b) workmem number is equals to online CPUs: put task into wait
	list

upon completion task puts workmem to idle list (or releases structure if
the number of online CPUs has decreased) and wakes up existing sleepers.
There is no more rw lock in RW path, as well, so writer does not block
readers (unless they touch the same sector. many concurrent readers are
allowed, while write should block concurrent read/write operations).

patch also hides direct compression call, and introduces

struct zram_compress_ops {
	long workmem_sz;

	int (*compress)(const unsigned char *src, size_t src_len,
			unsigned char *dst, size_t *dst_len, void *wrkmem);

	int (*decompress)(const unsigned char *src, size_t src_len,
			unsigned char *dst, size_t *dst_len);
};

instead, so compression algorithm can be changed via sysfs (not in this patch).



initial testing has demonstrated that iozone in mixed workflow can perform
significantly faster (iozone -t -T -R -l 3 -u 3 -r 16K -s 40M +Z -I):

w/o patch (LZO)
	Children see throughput for 8 mixed workload	= 428973.09 KB/sec
	Parent sees throughput for 8 mixed workload	= 384181.66 KB/sec

w/ patch (LZO)

	Children see throughput for 8 mixed workload	= 2957859.84 KB/sec
	Parent sees throughput for 8 mixed workload	= 1859763.07 KB/sec

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

---

 drivers/staging/zram/zram_drv.c | 604 +++++++++++++++++++++++-----------------
 drivers/staging/zram/zram_drv.h |  75 +++--
 2 files changed, 403 insertions(+), 276 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 7ebf91d..e936e38 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -29,9 +29,8 @@
 #include <linux/genhd.h>
 #include <linux/highmem.h>
 #include <linux/slab.h>
-#include <linux/lzo.h>
 #include <linux/string.h>
-#include <linux/vmalloc.h>
+#include <linux/lzo.h>
 
 #include "zram_drv.h"
 
@@ -99,21 +98,13 @@ static ssize_t notify_free_show(struct device *dev,
 			(u64)atomic64_read(&zram->stats.notify_free));
 }
 
-static ssize_t zero_pages_show(struct device *dev,
-		struct device_attribute *attr, char *buf)
-{
-	struct zram *zram = dev_to_zram(dev);
-
-	return sprintf(buf, "%u\n", zram->stats.pages_zero);
-}
-
 static ssize_t orig_data_size_show(struct device *dev,
 		struct device_attribute *attr, char *buf)
 {
 	struct zram *zram = dev_to_zram(dev);
 
 	return sprintf(buf, "%llu\n",
-		(u64)(zram->stats.pages_stored) << PAGE_SHIFT);
+		(u64)atomic64_read(&zram->stats.pages_stored) << PAGE_SHIFT);
 }
 
 static ssize_t compr_data_size_show(struct device *dev,
@@ -134,7 +125,7 @@ static ssize_t mem_used_total_show(struct device *dev,
 
 	down_read(&zram->init_lock);
 	if (zram->init_done)
-		val = zs_get_total_size_bytes(meta->mem_pool);
+		val = zs_get_total_size_bytes(meta->pool);
 	up_read(&zram->init_lock);
 
 	return sprintf(buf, "%llu\n", val);
@@ -143,19 +134,19 @@ static ssize_t mem_used_total_show(struct device *dev,
 static int zram_test_flag(struct zram_meta *meta, u32 index,
 			enum zram_pageflags flag)
 {
-	return meta->table[index].flags & BIT(flag);
+	return meta->sector[index].flags & BIT(flag);
 }
 
 static void zram_set_flag(struct zram_meta *meta, u32 index,
 			enum zram_pageflags flag)
 {
-	meta->table[index].flags |= BIT(flag);
+	meta->sector[index].flags |= BIT(flag);
 }
 
 static void zram_clear_flag(struct zram_meta *meta, u32 index,
 			enum zram_pageflags flag)
 {
-	meta->table[index].flags &= ~BIT(flag);
+	meta->sector[index].flags &= ~BIT(flag);
 }
 
 static inline int is_partial_io(struct bio_vec *bvec)
@@ -187,68 +178,166 @@ static inline int valid_io_request(struct zram *zram, struct bio *bio)
 	return 1;
 }
 
-static void zram_meta_free(struct zram_meta *meta)
+static void update_position(u32 *index, int *offset, struct bio_vec *bvec)
+{
+	if (*offset + bvec->bv_len >= PAGE_SIZE)
+		(*index)++;
+	*offset = (*offset + bvec->bv_len) % PAGE_SIZE;
+}
+
+/* free workmem, release workmem pages */
+static void free_workmem(struct list_head *wm)
 {
-	zs_destroy_pool(meta->mem_pool);
-	kfree(meta->compress_workmem);
-	free_pages((unsigned long)meta->compress_buffer, 1);
-	vfree(meta->table);
+	struct zram_workmem *workmem = list_entry(wm,
+						struct zram_workmem, list);
+
+	kfree(workmem->dbuf);
+	kfree(workmem->cbuf);
+	kfree(workmem->mem);
+	kfree(workmem);
+}
+
+/* allocate new workmem structure, return ERR_PTR on error */
+static struct list_head *alloc_workmem(struct zram *zram)
+{
+	struct zram_workmem *workmem;
+
+	workmem = kzalloc(sizeof(*workmem), GFP_NOFS);
+	if (!workmem)
+		return ERR_PTR(-ENOMEM);
+
+	INIT_LIST_HEAD(&workmem->list);
+
+	/* algorithm (lzo, lz4) specific working memory buffer */
+	workmem->mem = kzalloc(zram->ops.workmem_sz, GFP_KERNEL);
+	/* allocate 2 pages. 1 for compressed data, plus 1 extra for the
+	 * case when compressed size is larger than the original one. */
+	workmem->dbuf = kmalloc(2 * PAGE_SIZE, GFP_KERNEL);
+	workmem->cbuf = kmalloc(2 * PAGE_SIZE, GFP_KERNEL);
+	if (!workmem->mem || !workmem->dbuf || !workmem->cbuf)
+		goto fail;
+
+	return &workmem->list;
+fail:
+	free_workmem(&workmem->list);
+	return ERR_PTR(-ENOMEM);
+}
+
+/* find idle workmem or allocate a new one if number of active workmem structures
+ * is less than online CPUs number */
+static struct list_head *find_workmem(struct zram *zram)
+{
+	struct zram_meta *meta = zram->meta;
+	struct list_head *workmem;
+	int cpus = num_online_cpus();
+retry:
+	/* get existing idle workmem or wait until other processes release
+	 * one for us. */
+	spin_lock(&zram->lock);
+	if (!list_empty(&meta->idle_workmem)) {
+		workmem = meta->idle_workmem.next;
+		list_del(workmem);
+		spin_unlock(&zram->lock);
+		return workmem;
+	}
+
+	/* number of active workmem is limited to online CPUs number,
+	 * wait for existing workmem to become idle */
+	if (atomic_read(&meta->num_workmem) >= cpus) {
+		DEFINE_WAIT(wait);
+
+		spin_unlock(&zram->lock);
+		prepare_to_wait_exclusive(&meta->workmem_wait, &wait,
+				TASK_UNINTERRUPTIBLE);
+		if (atomic_read(&meta->num_workmem) >= cpus)
+			schedule();
+		finish_wait(&meta->workmem_wait, &wait);
+		goto retry;
+	}
+
+	atomic_inc(&meta->num_workmem);
+	spin_unlock(&zram->lock);
+
+	workmem = alloc_workmem(zram);
+	if (IS_ERR(workmem)) {
+		atomic_dec(&meta->num_workmem);
+		if (waitqueue_active(&meta->workmem_wait))
+			wake_up(&meta->workmem_wait);
+	}
+	return workmem;
+}
+
+/* put workmem to idle list or release it, if the number of online
+ * CPUs has decreased */
+static void put_workmem(struct zram *zram, struct list_head *workmem)
+{
+	struct zram_meta *meta = zram->meta;
+	spin_lock(&zram->lock);
+	/* add workmem to idle list or release it if the number of
+	 * online CPUs has decreased since the last time we checked it.*/
+	if (atomic_read(&meta->num_workmem) <= num_online_cpus()) {
+		list_add_tail(workmem, &meta->idle_workmem);
+		spin_unlock(&zram->lock);
+		goto wake;
+	}
+	spin_unlock(&zram->lock);
+
+	free_workmem(workmem);
+	atomic_dec(&meta->num_workmem);
+wake:
+	if (waitqueue_active(&meta->workmem_wait))
+		wake_up(&meta->workmem_wait);
+}
+
+static void zram_free_meta(struct zram_meta *meta)
+{
+	struct list_head *workmem;
+
+	while (!list_empty(&meta->idle_workmem)) {
+		workmem = meta->idle_workmem.next;
+		list_del(workmem);
+		free_workmem(workmem);
+		atomic_dec(&meta->num_workmem);
+	}
+
+	zs_destroy_pool(meta->pool);
+	vfree(meta->sector);
 	kfree(meta);
 }
 
-static struct zram_meta *zram_meta_alloc(u64 disksize)
+static struct zram_meta *zram_alloc_meta(u64 disksize)
 {
 	size_t num_pages;
 	struct zram_meta *meta = kmalloc(sizeof(*meta), GFP_KERNEL);
 	if (!meta)
-		goto out;
-
-	meta->compress_workmem = kzalloc(LZO1X_MEM_COMPRESS, GFP_KERNEL);
-	if (!meta->compress_workmem)
-		goto free_meta;
-
-	meta->compress_buffer =
-		(void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, 1);
-	if (!meta->compress_buffer) {
-		pr_err("Error allocating compressor buffer space\n");
-		goto free_workmem;
-	}
+		goto out_error;
 
 	num_pages = disksize >> PAGE_SHIFT;
-	meta->table = vzalloc(num_pages * sizeof(*meta->table));
-	if (!meta->table) {
-		pr_err("Error allocating zram address table\n");
-		goto free_buffer;
+	meta->sector = vzalloc(num_pages * sizeof(*meta->sector));
+	if (!meta->sector) {
+		pr_err("Error allocating zram address sector\n");
+		goto out_error;
 	}
 
-	meta->mem_pool = zs_create_pool(GFP_NOIO | __GFP_HIGHMEM);
-	if (!meta->mem_pool) {
+	meta->pool = zs_create_pool(GFP_NOIO | __GFP_HIGHMEM);
+	if (!meta->pool) {
 		pr_err("Error creating memory pool\n");
-		goto free_table;
+		goto out_error;
 	}
 
-	return meta;
+	INIT_LIST_HEAD(&meta->idle_workmem);
+	atomic_set(&meta->num_workmem, 0);
+	init_waitqueue_head(&meta->workmem_wait);
+	init_waitqueue_head(&meta->io_wait);
 
-free_table:
-	vfree(meta->table);
-free_buffer:
-	free_pages((unsigned long)meta->compress_buffer, 1);
-free_workmem:
-	kfree(meta->compress_workmem);
-free_meta:
+	return meta;
+out_error:
+	vfree(meta->sector);
 	kfree(meta);
-	meta = NULL;
-out:
+	meta = ERR_PTR(-ENOMEM);
 	return meta;
 }
 
-static void update_position(u32 *index, int *offset, struct bio_vec *bvec)
-{
-	if (*offset + bvec->bv_len >= PAGE_SIZE)
-		(*index)++;
-	*offset = (*offset + bvec->bv_len) % PAGE_SIZE;
-}
-
 static int page_zero_filled(void *ptr)
 {
 	unsigned int pos;
@@ -282,244 +371,269 @@ static void handle_zero_page(struct bio_vec *bvec)
 static void zram_free_page(struct zram *zram, size_t index)
 {
 	struct zram_meta *meta = zram->meta;
-	unsigned long handle = meta->table[index].handle;
-	u16 size = meta->table[index].size;
+	unsigned long handle = meta->sector[index].handle;
+	u16 size = meta->sector[index].size;
 
-	if (unlikely(!handle)) {
-		/*
-		 * No memory is allocated for zero filled pages.
-		 * Simply clear zero page flag.
-		 */
-		if (zram_test_flag(meta, index, ZRAM_ZERO)) {
-			zram_clear_flag(meta, index, ZRAM_ZERO);
-			zram->stats.pages_zero--;
-		}
+	if (!handle || zram_test_flag(meta, index, ZRAM_ZERO)) {
+		zram_clear_flag(meta, index, ZRAM_ZERO);
 		return;
 	}
 
-	if (unlikely(size > max_zpage_size))
-		zram->stats.bad_compress--;
+	if (size > max_zpage_size)
+		atomic64_dec(&zram->stats.bad_compress);
+	else
+		atomic64_dec(&zram->stats.good_compress);
+
+	zs_free(meta->pool, handle);
+
+	atomic64_sub(meta->sector[index].size, &zram->stats.compr_size);
+	atomic64_dec(&zram->stats.pages_stored);
+
+	meta->sector[index].handle = 0;
+	meta->sector[index].size = 0;
+}
 
-	zs_free(meta->mem_pool, handle);
+static unsigned long zram_get_pool_handle(struct zram *zram, size_t size,
+					u32 index)
+{
+	struct zram_meta *meta = zram->meta;
+	unsigned long handle = meta->sector[index].handle;
 
-	if (size <= PAGE_SIZE / 2)
-		zram->stats.good_compress--;
+	/* use existing memory, if its size is sufficient */
+	if (handle && meta->sector[index].size >= size) {
+		atomic64_sub(meta->sector[index].size,
+				&zram->stats.compr_size);
+		return handle;
+	}
+	/* free existing handle */
+	zram_free_page(zram, index);
 
-	atomic64_sub(meta->table[index].size, &zram->stats.compr_size);
-	zram->stats.pages_stored--;
+	handle = zs_malloc(meta->pool, size);
+	if (!handle)
+		return handle;
+	/* update stats */
+	if (size < max_zpage_size)
+		atomic64_inc(&zram->stats.good_compress);
+	else
+		atomic64_inc(&zram->stats.bad_compress);
 
-	meta->table[index].handle = 0;
-	meta->table[index].size = 0;
+	atomic64_inc(&zram->stats.pages_stored);
+	atomic64_add(size, &zram->stats.compr_size);
+
+	return handle;
 }
 
-static int zram_decompress_page(struct zram *zram, char *mem, u32 index)
+static int zram_decompress_page(struct zram *zram, char *page, u32 index)
 {
-	int ret = LZO_E_OK;
-	size_t clen = PAGE_SIZE;
 	unsigned char *cmem;
+	int ret = 0;
+	size_t clen = PAGE_SIZE, size;
 	struct zram_meta *meta = zram->meta;
-	unsigned long handle = meta->table[index].handle;
+	unsigned long handle = meta->sector[index].handle;
 
 	if (!handle || zram_test_flag(meta, index, ZRAM_ZERO)) {
-		clear_page(mem);
+		clear_page(page);
 		return 0;
 	}
 
-	cmem = zs_map_object(meta->mem_pool, handle, ZS_MM_RO);
-	if (meta->table[index].size == PAGE_SIZE)
-		copy_page(mem, cmem);
+	size = meta->sector[index].size;
+	cmem = zs_map_object(meta->pool, handle, ZS_MM_RO);
+	if (meta->sector[index].size == PAGE_SIZE)
+		copy_page(page, cmem);
 	else
-		ret = lzo1x_decompress_safe(cmem, meta->table[index].size,
-						mem, &clen);
-	zs_unmap_object(meta->mem_pool, handle);
+		ret = zram->ops.decompress(cmem, size, page, &clen);
+	zs_unmap_object(meta->pool, handle);
 
-	/* Should NEVER happen. Return bio error if it does. */
-	if (unlikely(ret != LZO_E_OK)) {
-		pr_err("Decompression failed! err=%d, page=%u\n", ret, index);
+	if (unlikely(ret))
 		atomic64_inc(&zram->stats.failed_reads);
-		return ret;
-	}
-
-	return 0;
+	return ret;
 }
 
-static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
-			  u32 index, int offset, struct bio *bio)
+static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec, u32 index, int offset)
 {
-	int ret;
-	struct page *page;
-	unsigned char *user_mem, *uncmem = NULL;
+	int ret = -EINVAL;
+	unsigned char *page;
 	struct zram_meta *meta = zram->meta;
-	page = bvec->bv_page;
 
-	if (unlikely(!meta->table[index].handle) ||
+	if (!meta->sector[index].handle ||
 			zram_test_flag(meta, index, ZRAM_ZERO)) {
 		handle_zero_page(bvec);
 		return 0;
 	}
 
-	if (is_partial_io(bvec))
-		/* Use  a temporary buffer to decompress the page */
-		uncmem = kmalloc(PAGE_SIZE, GFP_NOIO);
-
-	user_mem = kmap_atomic(page);
-	if (!is_partial_io(bvec))
-		uncmem = user_mem;
-
-	if (!uncmem) {
-		pr_info("Unable to allocate temp memory\n");
-		ret = -ENOMEM;
-		goto out_cleanup;
-	}
-
-	ret = zram_decompress_page(zram, uncmem, index);
-	/* Should NEVER happen. Return bio error if it does. */
-	if (unlikely(ret != LZO_E_OK))
-		goto out_cleanup;
-
-	if (is_partial_io(bvec))
-		memcpy(user_mem + bvec->bv_offset, uncmem + offset,
-				bvec->bv_len);
-
-	flush_dcache_page(page);
-	ret = 0;
-out_cleanup:
-	kunmap_atomic(user_mem);
-	if (is_partial_io(bvec))
-		kfree(uncmem);
+	page = kmap_atomic(bvec->bv_page);
+	ret = zram_decompress_page(zram, page, index);
+	kunmap_atomic(page);
+	flush_dcache_page(bvec->bv_page);
 	return ret;
 }
 
-static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
-			   int offset)
+static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index, int offset)
 {
 	int ret = 0;
 	size_t clen;
 	unsigned long handle;
-	struct page *page;
-	unsigned char *user_mem, *cmem, *src, *uncmem = NULL;
+	unsigned char *page = NULL, *pool_mem;
 	struct zram_meta *meta = zram->meta;
+	struct zram_workmem *wm;
+	struct list_head *workmem = find_workmem(zram);
+
+	if (IS_ERR(workmem))
+		return ret;
 
-	page = bvec->bv_page;
-	src = meta->compress_buffer;
+	wm = list_entry(workmem, struct zram_workmem, list);
 
+	page = kmap_atomic(bvec->bv_page);
 	if (is_partial_io(bvec)) {
-		/*
-		 * This is a partial IO. We need to read the full page
-		 * before to write the changes.
-		 */
-		uncmem = kmalloc(PAGE_SIZE, GFP_NOIO);
-		if (!uncmem) {
-			ret = -ENOMEM;
-			goto out;
-		}
-		ret = zram_decompress_page(zram, uncmem, index);
+		ret = zram_decompress_page(zram, wm->dbuf, index);
 		if (ret)
 			goto out;
+		/* copy page bytes to working memory */
+		memcpy(wm->dbuf + offset, page + bvec->bv_offset, bvec->bv_len);
+		kunmap_atomic(page);
+		page = wm->dbuf;
 	}
 
-	user_mem = kmap_atomic(page);
-
-	if (is_partial_io(bvec)) {
-		memcpy(uncmem + offset, user_mem + bvec->bv_offset,
-		       bvec->bv_len);
-		kunmap_atomic(user_mem);
-		user_mem = NULL;
-	} else {
-		uncmem = user_mem;
-	}
-
-	if (page_zero_filled(uncmem)) {
-		kunmap_atomic(user_mem);
-		/* Free memory associated with this sector now. */
-		zram_free_page(zram, index);
-
-		zram->stats.pages_zero++;
+	if (page_zero_filled(page)) {
 		zram_set_flag(meta, index, ZRAM_ZERO);
-		ret = 0;
+		zram_free_page(zram, index);
 		goto out;
 	}
 
-	ret = lzo1x_1_compress(uncmem, PAGE_SIZE, src, &clen,
-			       meta->compress_workmem);
-
+	ret = zram->ops.compress(page, bvec->bv_len, wm->cbuf, &clen, wm->mem);
 	if (!is_partial_io(bvec)) {
-		kunmap_atomic(user_mem);
-		user_mem = NULL;
-		uncmem = NULL;
+		kunmap_atomic(page);
+		page = NULL;
 	}
 
-	if (unlikely(ret != LZO_E_OK)) {
-		pr_err("Compression failed! err=%d\n", ret);
+	if (unlikely(ret)) {
+		pr_err("Compression failed: error=%d\n", ret);
 		goto out;
 	}
 
-	if (unlikely(clen > max_zpage_size)) {
-		zram->stats.bad_compress++;
+	if (clen >= max_zpage_size)
 		clen = PAGE_SIZE;
-		src = NULL;
-		if (is_partial_io(bvec))
-			src = uncmem;
-	}
-
-	handle = zs_malloc(meta->mem_pool, clen);
-	if (!handle) {
-		pr_info("Error allocating memory for compressed page: %u, size=%zu\n",
+	
+	handle = zram_get_pool_handle(zram, clen, index);
+	if (unlikely(!handle)) {
+		pr_info("Allocation error: page=%u, size=%zu\n",
 			index, clen);
 		ret = -ENOMEM;
 		goto out;
 	}
-	cmem = zs_map_object(meta->mem_pool, handle, ZS_MM_WO);
 
-	if ((clen == PAGE_SIZE) && !is_partial_io(bvec)) {
-		src = kmap_atomic(page);
-		copy_page(cmem, src);
-		kunmap_atomic(src);
-	} else {
-		memcpy(cmem, src, clen);
+	pool_mem = zs_map_object(meta->pool, handle, ZS_MM_WO);
+	if (clen != PAGE_SIZE)
+		memcpy(pool_mem, wm->cbuf, clen);
+	else {
+		page = kmap_atomic(bvec->bv_page);
+		copy_page(pool_mem, page);
+		kunmap_atomic(page);
+		page = NULL;
 	}
+	zs_unmap_object(meta->pool, handle);
 
-	zs_unmap_object(meta->mem_pool, handle);
-
-	/*
-	 * Free memory associated with this sector
-	 * before overwriting unused sectors.
-	 */
-	zram_free_page(zram, index);
-
-	meta->table[index].handle = handle;
-	meta->table[index].size = clen;
-
-	/* Update stats */
-	atomic64_add(clen, &zram->stats.compr_size);
-	zram->stats.pages_stored++;
-	if (clen <= PAGE_SIZE / 2)
-		zram->stats.good_compress++;
-
+	meta->sector[index].handle = handle;
+	meta->sector[index].size = clen;
 out:
-	if (is_partial_io(bvec))
-		kfree(uncmem);
+	put_workmem(zram, workmem);
 
-	if (ret)
+	if (page && !is_partial_io(bvec))
+		kunmap_atomic(page);
+	if (unlikely(ret))
 		atomic64_inc(&zram->stats.failed_writes);
 	return ret;
 }
 
+/* lock zram sector or sleep until sector is available for RW */
+static int zram_begin_sector_rw(struct zram *zram, struct zram_sector *sector, int type)
+{
+	struct zram_meta *meta = zram->meta;
+	int ret = 1;
+	spin_lock(&zram->lock);
+retry:
+	/* sector count:
+	 * 0   -- free to use
+	 * >0  -- number of active readers (many), writers are blocked
+	 * -1  -- active writer (only one), readers and writers are blocked
+	 */
+	if (type == WRITE) {
+		/* active RW or pending operation */
+		if (sector->count != 0 || sector->pending_write ||
+				sector->pending_read) {
+			DEFINE_WAIT(wait);
+
+			sector->pending_write++;
+			spin_unlock(&zram->lock);
+			prepare_to_wait_exclusive(&meta->io_wait, &wait,
+					TASK_UNINTERRUPTIBLE);
+			schedule();
+			finish_wait(&meta->io_wait, &wait);
+			spin_lock(&zram->lock);
+			sector->pending_write--;
+			goto retry;
+		}
+		sector->count = -1;
+	} else {
+		/* active write or pending write */
+		if (sector->count < 0 || sector->pending_write) {
+			DEFINE_WAIT(wait);
+
+			sector->pending_read++;
+			spin_unlock(&zram->lock);
+			prepare_to_wait_exclusive(&meta->io_wait, &wait,
+					TASK_UNINTERRUPTIBLE);
+			schedule();
+			finish_wait(&meta->io_wait, &wait);
+			spin_lock(&zram->lock);
+			sector->pending_read--;
+			goto retry;
+		}
+		sector->count++;
+	}
+	ret = 0;
+	spin_unlock(&zram->lock);
+	return ret;
+}
+
+/* unlock sector and wake up pending processes */
+static int zram_end_sector_rw(struct zram *zram, struct zram_sector *sector, int type)
+{
+	struct zram_meta *meta = zram->meta;
+	spin_lock(&zram->lock);
+	if (type == WRITE)
+		sector->count = 0;
+	else
+		sector->count--;
+	/* wake up pending oprocess only if sector count is zero */
+	if (sector->count == 0 && waitqueue_active(&meta->io_wait))
+		wake_up(&meta->io_wait);
+	spin_unlock(&zram->lock);
+	return 0;
+}
+
 static int zram_bvec_rw(struct zram *zram, struct bio_vec *bvec, u32 index,
-			int offset, struct bio *bio, int rw)
+			int offset, struct bio *bio)
 {
-	int ret;
+	struct zram_meta *meta = zram->meta;
+	struct zram_sector *sector = &meta->sector[index];
+	int type = bio_data_dir(bio);
+	int ret = -EINVAL;
 
-	if (rw == READ) {
-		down_read(&zram->lock);
-		ret = zram_bvec_read(zram, bvec, index, offset, bio);
-		up_read(&zram->lock);
-	} else {
-		down_write(&zram->lock);
+	if (type == READA)
+		type = READ;
+
+	zram_begin_sector_rw(zram, sector, type);
+
+	if (type == WRITE) {
+		atomic64_inc(&zram->stats.num_writes);
 		ret = zram_bvec_write(zram, bvec, index, offset);
-		up_write(&zram->lock);
+	} else {
+		atomic64_inc(&zram->stats.num_reads);
+		ret = zram_bvec_read(zram, bvec, index, offset);
 	}
 
+	zram_end_sector_rw(zram, sector, type);
 	return ret;
 }
 
@@ -539,14 +653,14 @@ static void zram_reset_device(struct zram *zram)
 
 	/* Free all pages that are still in this zram device */
 	for (index = 0; index < zram->disksize >> PAGE_SHIFT; index++) {
-		unsigned long handle = meta->table[index].handle;
+		unsigned long handle = meta->sector[index].handle;
 		if (!handle)
 			continue;
 
-		zs_free(meta->mem_pool, handle);
+		zs_free(meta->pool, handle);
 	}
 
-	zram_meta_free(zram->meta);
+	zram_free_meta(zram->meta);
 	zram->meta = NULL;
 	/* Reset stats */
 	memset(&zram->stats, 0, sizeof(zram->stats));
@@ -578,6 +692,10 @@ static void zram_init_device(struct zram *zram, struct zram_meta *meta)
 	zram->meta = meta;
 	zram->init_done = 1;
 
+	zram->ops.workmem_sz = LZO1X_MEM_COMPRESS;
+	zram->ops.compress = lzo1x_1_compress;
+	zram->ops.decompress = lzo1x_decompress_safe;
+
 	pr_debug("Initialization done!\n");
 }
 
@@ -593,11 +711,14 @@ static ssize_t disksize_store(struct device *dev,
 		return -EINVAL;
 
 	disksize = PAGE_ALIGN(disksize);
-	meta = zram_meta_alloc(disksize);
+	meta = zram_alloc_meta(disksize);
+	if (IS_ERR(meta))
+		return -ENOMEM;
+
 	down_write(&zram->init_lock);
 	if (zram->init_done) {
 		up_write(&zram->init_lock);
-		zram_meta_free(meta);
+		zram_free_meta(meta);
 		pr_info("Cannot change disksize for initialized device\n");
 		return -EBUSY;
 	}
@@ -640,21 +761,12 @@ static ssize_t reset_store(struct device *dev,
 	return len;
 }
 
-static void __zram_make_request(struct zram *zram, struct bio *bio, int rw)
+static void __zram_make_request(struct zram *zram, struct bio *bio)
 {
 	int i, offset;
 	u32 index;
 	struct bio_vec *bvec;
 
-	switch (rw) {
-	case READ:
-		atomic64_inc(&zram->stats.num_reads);
-		break;
-	case WRITE:
-		atomic64_inc(&zram->stats.num_writes);
-		break;
-	}
-
 	index = bio->bi_sector >> SECTORS_PER_PAGE_SHIFT;
 	offset = (bio->bi_sector & (SECTORS_PER_PAGE - 1)) << SECTOR_SHIFT;
 
@@ -672,16 +784,15 @@ static void __zram_make_request(struct zram *zram, struct bio *bio, int rw)
 			bv.bv_len = max_transfer_size;
 			bv.bv_offset = bvec->bv_offset;
 
-			if (zram_bvec_rw(zram, &bv, index, offset, bio, rw) < 0)
+			if (zram_bvec_rw(zram, &bv, index, offset, bio) < 0)
 				goto out;
 
 			bv.bv_len = bvec->bv_len - max_transfer_size;
 			bv.bv_offset += max_transfer_size;
-			if (zram_bvec_rw(zram, &bv, index+1, 0, bio, rw) < 0)
+			if (zram_bvec_rw(zram, &bv, index + 1, 0, bio) < 0)
 				goto out;
 		} else
-			if (zram_bvec_rw(zram, bvec, index, offset, bio, rw)
-			    < 0)
+			if (zram_bvec_rw(zram, bvec, index, offset, bio) < 0)
 				goto out;
 
 		update_position(&index, &offset, bvec);
@@ -711,9 +822,8 @@ static void zram_make_request(struct request_queue *queue, struct bio *bio)
 		goto error;
 	}
 
-	__zram_make_request(zram, bio, bio_data_dir(bio));
+	__zram_make_request(zram, bio);
 	up_read(&zram->init_lock);
-
 	return;
 
 error:
@@ -724,12 +834,10 @@ error:
 static void zram_slot_free_notify(struct block_device *bdev,
 				unsigned long index)
 {
-	struct zram *zram;
-
-	zram = bdev->bd_disk->private_data;
-	down_write(&zram->lock);
+	struct zram *zram = bdev->bd_disk->private_data;
+	spin_lock(&zram->lock);
 	zram_free_page(zram, index);
-	up_write(&zram->lock);
+	spin_unlock(&zram->lock);
 	atomic64_inc(&zram->stats.notify_free);
 }
 
@@ -746,7 +854,6 @@ static DEVICE_ATTR(num_reads, S_IRUGO, num_reads_show, NULL);
 static DEVICE_ATTR(num_writes, S_IRUGO, num_writes_show, NULL);
 static DEVICE_ATTR(invalid_io, S_IRUGO, invalid_io_show, NULL);
 static DEVICE_ATTR(notify_free, S_IRUGO, notify_free_show, NULL);
-static DEVICE_ATTR(zero_pages, S_IRUGO, zero_pages_show, NULL);
 static DEVICE_ATTR(orig_data_size, S_IRUGO, orig_data_size_show, NULL);
 static DEVICE_ATTR(compr_data_size, S_IRUGO, compr_data_size_show, NULL);
 static DEVICE_ATTR(mem_used_total, S_IRUGO, mem_used_total_show, NULL);
@@ -759,7 +866,6 @@ static struct attribute *zram_disk_attrs[] = {
 	&dev_attr_num_writes.attr,
 	&dev_attr_invalid_io.attr,
 	&dev_attr_notify_free.attr,
-	&dev_attr_zero_pages.attr,
 	&dev_attr_orig_data_size.attr,
 	&dev_attr_compr_data_size.attr,
 	&dev_attr_mem_used_total.attr,
@@ -774,9 +880,9 @@ static int create_device(struct zram *zram, int device_id)
 {
 	int ret = -ENOMEM;
 
-	init_rwsem(&zram->lock);
 	init_rwsem(&zram->init_lock);
-
+	spin_lock_init(&zram->lock);
+	
 	zram->queue = blk_alloc_queue(GFP_KERNEL);
 	if (!zram->queue) {
 		pr_err("Error allocating disk queue for device %d\n",
diff --git a/drivers/staging/zram/zram_drv.h b/drivers/staging/zram/zram_drv.h
index 9e57bfb..64d015f 100644
--- a/drivers/staging/zram/zram_drv.h
+++ b/drivers/staging/zram/zram_drv.h
@@ -16,7 +16,7 @@
 #define _ZRAM_DRV_H_
 
 #include <linux/spinlock.h>
-#include <linux/mutex.h>
+#include <linux/rwsem.h>
 
 #include "../zsmalloc/zsmalloc.h"
 
@@ -55,19 +55,20 @@ static const size_t max_zpage_size = PAGE_SIZE / 4 * 3;
 enum zram_pageflags {
 	/* Page consists entirely of zeros */
 	ZRAM_ZERO,
-
 	__NR_ZRAM_PAGEFLAGS,
 };
 
 /*-- Data structures */
 
 /* Allocated for each disk page */
-struct table {
+struct zram_sector {
 	unsigned long handle;
-	u16 size;	/* object size (excluding header) */
-	u8 count;	/* object ref count (not yet used) */
+	u16 size; /* object size (excluding header) */
+	u8 pending_write;
+	u8 pending_read;
+	s8 count; /* prevent concurrent sector read-write operations */
 	u8 flags;
-} __aligned(4);
+};
 
 /*
  * All 64bit fields should only be manipulated by 64bit atomic accessors.
@@ -77,39 +78,59 @@ struct zram_stats {
 	atomic64_t compr_size;	/* compressed size of pages stored */
 	atomic64_t num_reads;	/* failed + successful */
 	atomic64_t num_writes;	/* --do-- */
+	atomic64_t pages_stored; /* no. of pages stored */
+	/* no. of pages with compression ratio<75% */
+	atomic64_t good_compress;
+	/* no. of pages with compression ratio>=75% */
+	atomic64_t bad_compress;
 	atomic64_t failed_reads;	/* should NEVER! happen */
 	atomic64_t failed_writes;	/* can happen when memory is too low */
 	atomic64_t invalid_io;	/* non-page-aligned I/O requests */
 	atomic64_t notify_free;	/* no. of swap slot free notifications */
-	u32 pages_zero;		/* no. of zero filled pages */
-	u32 pages_stored;	/* no. of pages currently stored */
-	u32 good_compress;	/* % of pages with compression ratio<=50% */
-	u32 bad_compress;	/* % of pages with compression ratio>=75% */
+};
+
+/*
+ * compression/decompression functions and algorithm workmem size.
+ */
+struct zram_compress_ops {
+	long workmem_sz;
+
+	int (*compress)(const unsigned char *src, size_t src_len,
+			unsigned char *dst, size_t *dst_len, void *wrkmem);
+
+	int (*decompress)(const unsigned char *src, size_t src_len,
+			unsigned char *dst, size_t *dst_len);
+};
+
+struct zram_workmem {
+	struct list_head list;
+	void *mem;	/* algorithm workmem */
+	void *dbuf;	/* decompression buffer */
+	void *cbuf;	/* compression buffer */
 };
 
 struct zram_meta {
-	void *compress_workmem;
-	void *compress_buffer;
-	struct table *table;
-	struct zs_pool *mem_pool;
+	struct zram_sector *sector;
+	struct zs_pool *pool;
+
+	struct list_head idle_workmem;
+	atomic_t num_workmem;
+	wait_queue_head_t workmem_wait;
+	wait_queue_head_t io_wait;
 };
 
 struct zram {
-	struct zram_meta *meta;
-	struct rw_semaphore lock; /* protect compression buffers, table,
-				   * 32bit stat counters against concurrent
-				   * notifications, reads and writes */
-	struct request_queue *queue;
-	struct gendisk *disk;
-	int init_done;
-	/* Prevent concurrent execution of device init, reset and R/W request */
 	struct rw_semaphore init_lock;
-	/*
-	 * This is the limit on amount of *uncompressed* worth of data
-	 * we can store in a disk.
-	 */
-	u64 disksize;	/* bytes */
+	spinlock_t lock;
+	/* Prevent concurrent execution of device init, reset and R/W request */
+	int init_done;
+	struct zram_meta *meta;
 
 	struct zram_stats stats;
+	struct zram_compress_ops ops;
+
+	u64 disksize;
+	struct request_queue *queue;
+	struct gendisk *disk;
 };
 #endif

