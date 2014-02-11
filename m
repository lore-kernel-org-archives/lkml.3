Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753037AbaBKWYx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 17:24:53 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:38461 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752392AbaBKWYs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 17:24:48 -0500
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: [PATCHv3 2/4] zram: use zram_comp compressing backends
Date: Wed, 12 Feb 2014 01:21:04 +0300
Message-Id: <1392157266-13488-3-git-send-email-sergey.senozhatsky@gmail.com>
X-Mailer: git-send-email 1.9.0.rc3.244.g3497008
In-Reply-To: <1392157266-13488-1-git-send-email-sergey.senozhatsky@gmail.com>
References: <1392157266-13488-1-git-send-email-sergey.senozhatsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not perform direct LZO compress/decompress calls,
initialise and use zram_comp LZO backend instead.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
---
 drivers/block/zram/Makefile   |  2 +-
 drivers/block/zram/zram_drv.c | 62 +++++++++++++++++++------------------------
 drivers/block/zram/zram_drv.h |  8 +++---
 3 files changed, 33 insertions(+), 39 deletions(-)

diff --git a/drivers/block/zram/Makefile b/drivers/block/zram/Makefile
index cb0f9ce..4c2e829 100644
--- a/drivers/block/zram/Makefile
+++ b/drivers/block/zram/Makefile
@@ -1,3 +1,3 @@
-zram-y	:=	zram_drv.o
+zram-y	:=	zcomp_lzo.o zram_comp.o zram_drv.o
 
 obj-$(CONFIG_ZRAM)	+=	zram.o
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 9baac5b..4875a16 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -29,15 +29,14 @@
 #include <linux/genhd.h>
 #include <linux/highmem.h>
 #include <linux/slab.h>
-#include <linux/lzo.h>
 #include <linux/string.h>
-#include <linux/vmalloc.h>
 
 #include "zram_drv.h"
 
 /* Globals */
 static int zram_major;
 static struct zram *zram_devices;
+static const char *default_compressor = "lzo";
 
 /* Module params (documentation at end) */
 static unsigned int num_devices = 1;
@@ -160,8 +159,6 @@ static inline int valid_io_request(struct zram *zram, struct bio *bio)
 static void zram_meta_free(struct zram_meta *meta)
 {
 	zs_destroy_pool(meta->mem_pool);
-	kfree(meta->compress_workmem);
-	free_pages((unsigned long)meta->compress_buffer, 1);
 	vfree(meta->table);
 	kfree(meta);
 }
@@ -173,22 +170,11 @@ static struct zram_meta *zram_meta_alloc(u64 disksize)
 	if (!meta)
 		goto out;
 
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
-
 	num_pages = disksize >> PAGE_SHIFT;
 	meta->table = vzalloc(num_pages * sizeof(*meta->table));
 	if (!meta->table) {
 		pr_err("Error allocating zram address table\n");
-		goto free_buffer;
+		goto free_meta;
 	}
 
 	meta->mem_pool = zs_create_pool(GFP_NOIO | __GFP_HIGHMEM);
@@ -198,15 +184,10 @@ static struct zram_meta *zram_meta_alloc(u64 disksize)
 	}
 
 	rwlock_init(&meta->tb_lock);
-	mutex_init(&meta->buffer_lock);
 	return meta;
 
 free_table:
 	vfree(meta->table);
-free_buffer:
-	free_pages((unsigned long)meta->compress_buffer, 1);
-free_workmem:
-	kfree(meta->compress_workmem);
 free_meta:
 	kfree(meta);
 	meta = NULL;
@@ -280,7 +261,7 @@ static void zram_free_page(struct zram *zram, size_t index)
 
 static int zram_decompress_page(struct zram *zram, char *mem, u32 index)
 {
-	int ret = LZO_E_OK;
+	int ret = 0;
 	size_t clen = PAGE_SIZE;
 	unsigned char *cmem;
 	struct zram_meta *meta = zram->meta;
@@ -301,12 +282,12 @@ static int zram_decompress_page(struct zram *zram, char *mem, u32 index)
 	if (size == PAGE_SIZE)
 		copy_page(mem, cmem);
 	else
-		ret = lzo1x_decompress_safe(cmem, size,	mem, &clen);
+		ret = zcomp_decompress(zram->comp, cmem, size, mem, &clen);
 	zs_unmap_object(meta->mem_pool, handle);
 	read_unlock(&meta->tb_lock);
 
 	/* Should NEVER happen. Return bio error if it does. */
-	if (unlikely(ret != LZO_E_OK)) {
+	if (unlikely(ret)) {
 		pr_err("Decompression failed! err=%d, page=%u\n", ret, index);
 		atomic64_inc(&zram->stats.failed_reads);
 		return ret;
@@ -349,7 +330,7 @@ static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
 
 	ret = zram_decompress_page(zram, uncmem, index);
 	/* Should NEVER happen. Return bio error if it does. */
-	if (unlikely(ret != LZO_E_OK))
+	if (unlikely(ret))
 		goto out_cleanup;
 
 	if (is_partial_io(bvec))
@@ -374,11 +355,10 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 	struct page *page;
 	unsigned char *user_mem, *cmem, *src, *uncmem = NULL;
 	struct zram_meta *meta = zram->meta;
+	struct zcomp_workmem *wm;
 	bool locked = false;
 
 	page = bvec->bv_page;
-	src = meta->compress_buffer;
-
 	if (is_partial_io(bvec)) {
 		/*
 		 * This is a partial IO. We need to read the full page
@@ -394,7 +374,7 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 			goto out;
 	}
 
-	mutex_lock(&meta->buffer_lock);
+	wm = zcomp_workmem_get(zram->comp);
 	locked = true;
 	user_mem = kmap_atomic(page);
 
@@ -420,19 +400,18 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 		goto out;
 	}
 
-	ret = lzo1x_1_compress(uncmem, PAGE_SIZE, src, &clen,
-			       meta->compress_workmem);
+	ret = zcomp_compress(zram->comp, wm, uncmem, bvec->bv_len, &clen);
 	if (!is_partial_io(bvec)) {
 		kunmap_atomic(user_mem);
 		user_mem = NULL;
 		uncmem = NULL;
 	}
 
-	if (unlikely(ret != LZO_E_OK)) {
+	if (unlikely(ret)) {
 		pr_err("Compression failed! err=%d\n", ret);
 		goto out;
 	}
-
+	src = wm->buffer;
 	if (unlikely(clen > max_zpage_size)) {
 		clen = PAGE_SIZE;
 		src = NULL;
@@ -457,6 +436,8 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 		memcpy(cmem, src, clen);
 	}
 
+	zcomp_workmem_put(zram->comp, wm);
+	locked = false;
 	zs_unmap_object(meta->mem_pool, handle);
 
 	/*
@@ -475,10 +456,9 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 	atomic64_inc(&zram->stats.pages_stored);
 out:
 	if (locked)
-		mutex_unlock(&meta->buffer_lock);
+		zcomp_workmem_put(zram->comp, wm);
 	if (is_partial_io(bvec))
 		kfree(uncmem);
-
 	if (ret)
 		atomic64_inc(&zram->stats.failed_writes);
 	return ret;
@@ -522,6 +502,10 @@ static void zram_reset_device(struct zram *zram, bool reset_capacity)
 		zs_free(meta->mem_pool, handle);
 	}
 
+	if (zram->comp)
+		zcomp_destroy(zram->comp);
+	zram->comp = NULL;
+
 	zram_meta_free(zram->meta);
 	zram->meta = NULL;
 	/* Reset stats */
@@ -550,9 +534,18 @@ static ssize_t disksize_store(struct device *dev,
 		return -EBUSY;
 	}
 
+	zram->comp = zcomp_create(default_compressor);
+	if (!zram->comp) {
+		up_write(&zram->init_lock);
+		pr_info("Cannot initialise compressing backend\n");
+		return -EINVAL;
+	}
+
 	disksize = PAGE_ALIGN(disksize);
 	zram->meta = zram_meta_alloc(disksize);
 	if (!zram->meta) {
+		zcomp_destroy(zram->comp);
+		zram->comp = NULL;
 		up_write(&zram->init_lock);
 		return -ENOMEM;
 	}
@@ -790,6 +783,7 @@ static int create_device(struct zram *zram, int device_id)
 	}
 
 	zram->meta = NULL;
+	zram->comp = NULL;
 	return 0;
 
 out_free_disk:
diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
index 1d5b1f5..a2e17d7 100644
--- a/drivers/block/zram/zram_drv.h
+++ b/drivers/block/zram/zram_drv.h
@@ -16,9 +16,10 @@
 #define _ZRAM_DRV_H_
 
 #include <linux/spinlock.h>
-#include <linux/mutex.h>
 #include <linux/zsmalloc.h>
 
+#include "zram_comp.h"
+
 /*
  * Some arbitrary value. This is just to catch
  * invalid value for num_devices module parameter.
@@ -81,17 +82,16 @@ struct zram_stats {
 
 struct zram_meta {
 	rwlock_t tb_lock;	/* protect table */
-	void *compress_workmem;
-	void *compress_buffer;
 	struct table *table;
 	struct zs_pool *mem_pool;
-	struct mutex buffer_lock; /* protect compress buffers */
 };
 
 struct zram {
 	struct zram_meta *meta;
 	struct request_queue *queue;
 	struct gendisk *disk;
+	struct zram_comp *comp;
+
 	/* Prevent concurrent execution of device init, reset and R/W request */
 	struct rw_semaphore init_lock;
 	/*
-- 
1.9.0.rc3.244.g3497008

