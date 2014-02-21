Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344AbaBULy0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 06:54:26 -0500
Received: from mail-ea0-f172.google.com ([209.85.215.172]:64238 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548AbaBULyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 06:54:23 -0500
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: [PATCHv6 2/6] zram: use zcomp compressing backends
Date: Fri, 21 Feb 2014 14:50:39 +0300
Message-Id: <1392983443-9807-3-git-send-email-sergey.senozhatsky@gmail.com>
X-Mailer: git-send-email 1.9.0.291.g027825b
In-Reply-To: <1392983443-9807-1-git-send-email-sergey.senozhatsky@gmail.com>
References: <1392983443-9807-1-git-send-email-sergey.senozhatsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not perform direct LZO compress/decompress calls, initialise
and use zcomp LZO backend (single compression stream) instead.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
---
 drivers/block/zram/Makefile   |  2 +-
 drivers/block/zram/zram_drv.c | 62 +++++++++++++++++++------------------------
 drivers/block/zram/zram_drv.h |  8 +++---
 3 files changed, 32 insertions(+), 40 deletions(-)

diff --git a/drivers/block/zram/Makefile b/drivers/block/zram/Makefile
index cb0f9ce..757c6a5 100644
--- a/drivers/block/zram/Makefile
+++ b/drivers/block/zram/Makefile
@@ -1,3 +1,3 @@
-zram-y	:=	zram_drv.o
+zram-y	:=	zcomp_lzo.o zcomp.o zram_drv.o
 
 obj-$(CONFIG_ZRAM)	+=	zram.o
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 9baac5b..200c12a 100644
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
@@ -280,8 +261,7 @@ static void zram_free_page(struct zram *zram, size_t index)
 
 static int zram_decompress_page(struct zram *zram, char *mem, u32 index)
 {
-	int ret = LZO_E_OK;
-	size_t clen = PAGE_SIZE;
+	int ret = 0;
 	unsigned char *cmem;
 	struct zram_meta *meta = zram->meta;
 	unsigned long handle;
@@ -301,12 +281,12 @@ static int zram_decompress_page(struct zram *zram, char *mem, u32 index)
 	if (size == PAGE_SIZE)
 		copy_page(mem, cmem);
 	else
-		ret = lzo1x_decompress_safe(cmem, size,	mem, &clen);
+		ret = zcomp_decompress(zram->comp, cmem, size, mem);
 	zs_unmap_object(meta->mem_pool, handle);
 	read_unlock(&meta->tb_lock);
 
 	/* Should NEVER happen. Return bio error if it does. */
-	if (unlikely(ret != LZO_E_OK)) {
+	if (unlikely(ret)) {
 		pr_err("Decompression failed! err=%d, page=%u\n", ret, index);
 		atomic64_inc(&zram->stats.failed_reads);
 		return ret;
@@ -349,7 +329,7 @@ static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
 
 	ret = zram_decompress_page(zram, uncmem, index);
 	/* Should NEVER happen. Return bio error if it does. */
-	if (unlikely(ret != LZO_E_OK))
+	if (unlikely(ret))
 		goto out_cleanup;
 
 	if (is_partial_io(bvec))
@@ -374,11 +354,10 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 	struct page *page;
 	unsigned char *user_mem, *cmem, *src, *uncmem = NULL;
 	struct zram_meta *meta = zram->meta;
+	struct zcomp_strm *zstrm;
 	bool locked = false;
 
 	page = bvec->bv_page;
-	src = meta->compress_buffer;
-
 	if (is_partial_io(bvec)) {
 		/*
 		 * This is a partial IO. We need to read the full page
@@ -394,7 +373,7 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 			goto out;
 	}
 
-	mutex_lock(&meta->buffer_lock);
+	zstrm = zcomp_strm_get(zram->comp);
 	locked = true;
 	user_mem = kmap_atomic(page);
 
@@ -420,19 +399,18 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 		goto out;
 	}
 
-	ret = lzo1x_1_compress(uncmem, PAGE_SIZE, src, &clen,
-			       meta->compress_workmem);
+	ret = zcomp_compress(zram->comp, zstrm, uncmem, &clen);
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
+	src = zstrm->buffer;
 	if (unlikely(clen > max_zpage_size)) {
 		clen = PAGE_SIZE;
 		src = NULL;
@@ -457,6 +435,8 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 		memcpy(cmem, src, clen);
 	}
 
+	zcomp_strm_put(zram->comp, zstrm);
+	locked = false;
 	zs_unmap_object(meta->mem_pool, handle);
 
 	/*
@@ -475,10 +455,9 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 	atomic64_inc(&zram->stats.pages_stored);
 out:
 	if (locked)
-		mutex_unlock(&meta->buffer_lock);
+		zcomp_strm_put(zram->comp, zstrm);
 	if (is_partial_io(bvec))
 		kfree(uncmem);
-
 	if (ret)
 		atomic64_inc(&zram->stats.failed_writes);
 	return ret;
@@ -522,6 +501,9 @@ static void zram_reset_device(struct zram *zram, bool reset_capacity)
 		zs_free(meta->mem_pool, handle);
 	}
 
+	zcomp_destroy(zram->comp);
+	zram->comp = NULL;
+
 	zram_meta_free(zram->meta);
 	zram->meta = NULL;
 	/* Reset stats */
@@ -550,9 +532,18 @@ static ssize_t disksize_store(struct device *dev,
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
@@ -790,6 +781,7 @@ static int create_device(struct zram *zram, int device_id)
 	}
 
 	zram->meta = NULL;
+	zram->comp = NULL;
 	return 0;
 
 out_free_disk:
diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
index 1d5b1f5..45e04f7 100644
--- a/drivers/block/zram/zram_drv.h
+++ b/drivers/block/zram/zram_drv.h
@@ -16,9 +16,10 @@
 #define _ZRAM_DRV_H_
 
 #include <linux/spinlock.h>
-#include <linux/mutex.h>
 #include <linux/zsmalloc.h>
 
+#include "zcomp.h"
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
+	struct zcomp *comp;
+
 	/* Prevent concurrent execution of device init, reset and R/W request */
 	struct rw_semaphore init_lock;
 	/*
-- 
1.9.0.291.g027825b

