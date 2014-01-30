Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846AbaA3Tb7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 14:31:59 -0500
Received: from mail-ea0-f175.google.com ([209.85.215.175]:63840 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797AbaA3Tb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 14:31:56 -0500
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: [PATCHv2 2/2] zram: use zram_comp compressing backends
Date: Thu, 30 Jan 2014 22:28:08 +0300
Message-Id: <1391110088-14830-3-git-send-email-sergey.senozhatsky@gmail.com>
X-Mailer: git-send-email 1.9.rc1.183.g614c158
In-Reply-To: <1391110088-14830-1-git-send-email-sergey.senozhatsky@gmail.com>
References: <1391110088-14830-1-git-send-email-sergey.senozhatsky@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1) Use zram_comp in zram instead of direct LZO calls.

2) Introduce Kconfig ZRAM_LZO_COMPRESS and ZRAM_LZ4_COMPRESS
options to enable/disable LZO and LZ4 backends respectively.

3) Add compressor device attr that allows to list and select
compression algorithms.

usage example:
List available compression algorithms (currently selected
one is LZO):
  cat /sys/block/zram0/compressor
  <lzo> lz4

Change compression algorithm to LZ4:
  echo lz4 > /sys/block/zram0/compressor
  cat /sys/block/zram0/compressor
  lzo <lz4>

iozone test `buffer_lock mutex' vs `single workmem and spinlock'
(each test was performed on cold, freashly created zram device,
ext4 file system, LZO):
./iozone -t -T -R -l 3 -u 3 -r 16K -s 60M -I +Z
        test        unpatсhed        patched
-------------------------------------------------
  Initial write:    341274.03   |   465984.82
        Rewrite:    527752.14   |   587844.27
           Read:   2668083.00   |  3527865.95
        Re-read:   2479428.12   |  3497152.56
   Reverse Read:   1563745.16   |  2463020.33
    Stride read:   1916311.84   |  2675575.14
    Random read:   2099906.09   |  2758833.45
 Mixed workload:   1631288.54   |  2439302.68
   Random write:    428555.50   |   578720.39
         Pwrite:    339857.66   |   415078.43
          Pread:   1523965.55   |  1417191.77
         Fwrite:   1571574.03   |  1447609.02
          Fread:   5449851.44   |  5563909.53

./iozone -t -T -R -l 3 -u 3 -r 16K -s 60M -I +Z
        test        unpatсhed        patched
-------------------------------------------------
  Initial write:    435205.70   |   513995.38
        Rewrite:    617956.68   |   600445.49
           Read:   3379175.66   |  3354820.31
        Re-read:   3344446.66   |  3484581.59
   Reverse Read:   2215915.09   |  2689347.80
    Stride read:   2570020.28   |  2797849.55
    Random read:   2751191.27   |  2830580.06
 Mixed workload:   1647681.38   |  2382402.29
   Random write:    591968.77   |   597967.23
         Pwrite:    441869.31   |   526409.72
          Pread:   1530294.05   |  1466025.38
         Fwrite:   1634969.22   |  1757762.27
          Fread:   4782938.06   |  5643076.25

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
---
 drivers/block/zram/Kconfig    | 20 ++++++++-
 drivers/block/zram/Makefile   |  6 ++-
 drivers/block/zram/zram_drv.c | 96 ++++++++++++++++++++++++++++---------------
 drivers/block/zram/zram_drv.h |  8 ++--
 4 files changed, 90 insertions(+), 40 deletions(-)

diff --git a/drivers/block/zram/Kconfig b/drivers/block/zram/Kconfig
index 3450be8..4de410d 100644
--- a/drivers/block/zram/Kconfig
+++ b/drivers/block/zram/Kconfig
@@ -1,8 +1,6 @@
 config ZRAM
 	tristate "Compressed RAM block device support"
 	depends on BLOCK && SYSFS && ZSMALLOC
-	select LZO_COMPRESS
-	select LZO_DECOMPRESS
 	default n
 	help
 	  Creates virtual block devices called /dev/zramX (X = 0, 1, ...).
@@ -15,6 +13,24 @@ config ZRAM
 
 	  See zram.txt for more information.
 
+config ZRAM_LZO_COMPRESS
+	bool "Compressed RAM LZO support"
+	depends on ZRAM
+	select LZO_COMPRESS
+	select LZO_DECOMPRESS
+	default y
+	help
+	  This option adds LZO compression algorithm support.
+
+config ZRAM_LZ4_COMPRESS
+	bool "Compressed RAM LZ4 support"
+	depends on ZRAM
+	select LZ4_COMPRESS
+	select LZ4_DECOMPRESS
+	default n
+	help
+	  This option adds LZ4 compression algorithm support.
+
 config ZRAM_DEBUG
 	bool "Compressed RAM block device debug support"
 	depends on ZRAM
diff --git a/drivers/block/zram/Makefile b/drivers/block/zram/Makefile
index cb0f9ce..c649600 100644
--- a/drivers/block/zram/Makefile
+++ b/drivers/block/zram/Makefile
@@ -1,3 +1,7 @@
-zram-y	:=	zram_drv.o
+zram-y	:=	zram_comp.o zram_drv.o
+
+zram-$(CONFIG_ZRAM_LZO_COMPRESS) += zcomp_lzo.o
+
+zram-$(CONFIG_ZRAM_LZ4_COMPRESS) += zcomp_lz4.o
 
 obj-$(CONFIG_ZRAM)	+=	zram.o
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 9baac5b..46b1a44 100644
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
@@ -108,6 +107,39 @@ static ssize_t mem_used_total_show(struct device *dev,
 	return sprintf(buf, "%llu\n", val);
 }
 
+static ssize_t compressor_show(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	struct zram *zram = dev_to_zram(dev);
+	ssize_t sz = 0;
+	down_read(&zram->init_lock);
+	sz = zcomp_available_show(zram->comp, buf);
+	up_read(&zram->init_lock);
+	return sz;
+}
+
+static ssize_t compressor_store(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t len)
+{
+	struct zram *zram = dev_to_zram(dev);
+
+	down_write(&zram->init_lock);
+	if (init_done(zram) || zram->comp) {
+		up_write(&zram->init_lock);
+		pr_info("Cannot change compressor for initialized device\n");
+		return -EBUSY;
+	}
+
+	zram->comp = zcomp_create(buf);
+	if (!zram->comp) {
+		up_write(&zram->init_lock);
+		pr_info("Cannot initialise compressing backend");
+		return -EINVAL;
+	}
+	up_write(&zram->init_lock);
+	return len;
+}
+
 /* flag operations needs meta->tb_lock */
 static int zram_test_flag(struct zram_meta *meta, u32 index,
 			enum zram_pageflags flag)
@@ -160,8 +192,6 @@ static inline int valid_io_request(struct zram *zram, struct bio *bio)
 static void zram_meta_free(struct zram_meta *meta)
 {
 	zs_destroy_pool(meta->mem_pool);
-	kfree(meta->compress_workmem);
-	free_pages((unsigned long)meta->compress_buffer, 1);
 	vfree(meta->table);
 	kfree(meta);
 }
@@ -173,22 +203,11 @@ static struct zram_meta *zram_meta_alloc(u64 disksize)
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
@@ -198,15 +217,10 @@ static struct zram_meta *zram_meta_alloc(u64 disksize)
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
@@ -280,7 +294,7 @@ static void zram_free_page(struct zram *zram, size_t index)
 
 static int zram_decompress_page(struct zram *zram, char *mem, u32 index)
 {
-	int ret = LZO_E_OK;
+	int ret = 0;
 	size_t clen = PAGE_SIZE;
 	unsigned char *cmem;
 	struct zram_meta *meta = zram->meta;
@@ -301,12 +315,12 @@ static int zram_decompress_page(struct zram *zram, char *mem, u32 index)
 	if (size == PAGE_SIZE)
 		copy_page(mem, cmem);
 	else
-		ret = lzo1x_decompress_safe(cmem, size,	mem, &clen);
+		ret = zram->comp->decompress(cmem, size, mem, &clen);
 	zs_unmap_object(meta->mem_pool, handle);
 	read_unlock(&meta->tb_lock);
 
 	/* Should NEVER happen. Return bio error if it does. */
-	if (unlikely(ret != LZO_E_OK)) {
+	if (unlikely(ret)) {
 		pr_err("Decompression failed! err=%d, page=%u\n", ret, index);
 		atomic64_inc(&zram->stats.failed_reads);
 		return ret;
@@ -349,7 +363,7 @@ static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
 
 	ret = zram_decompress_page(zram, uncmem, index);
 	/* Should NEVER happen. Return bio error if it does. */
-	if (unlikely(ret != LZO_E_OK))
+	if (unlikely(ret))
 		goto out_cleanup;
 
 	if (is_partial_io(bvec))
@@ -374,11 +388,10 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
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
@@ -394,7 +407,8 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 			goto out;
 	}
 
-	mutex_lock(&meta->buffer_lock);
+	wm = zram->comp->workmem_get(zram->comp);
+	src = wm->buf;
 	locked = true;
 	user_mem = kmap_atomic(page);
 
@@ -420,15 +434,14 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 		goto out;
 	}
 
-	ret = lzo1x_1_compress(uncmem, PAGE_SIZE, src, &clen,
-			       meta->compress_workmem);
+	ret = zram->comp->compress(uncmem, PAGE_SIZE, src, &clen, wm->mem);
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
@@ -457,6 +470,8 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 		memcpy(cmem, src, clen);
 	}
 
+	zram->comp->workmem_put(zram->comp, wm);
+	locked = false;
 	zs_unmap_object(meta->mem_pool, handle);
 
 	/*
@@ -475,10 +490,9 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 	atomic64_inc(&zram->stats.pages_stored);
 out:
 	if (locked)
-		mutex_unlock(&meta->buffer_lock);
+		zram->comp->workmem_put(zram->comp, wm);
 	if (is_partial_io(bvec))
 		kfree(uncmem);
-
 	if (ret)
 		atomic64_inc(&zram->stats.failed_writes);
 	return ret;
@@ -522,6 +536,10 @@ static void zram_reset_device(struct zram *zram, bool reset_capacity)
 		zs_free(meta->mem_pool, handle);
 	}
 
+	if (zram->comp)
+		zcomp_destroy(zram->comp);
+	zram->comp = NULL;
+
 	zram_meta_free(zram->meta);
 	zram->meta = NULL;
 	/* Reset stats */
@@ -550,6 +568,14 @@ static ssize_t disksize_store(struct device *dev,
 		return -EBUSY;
 	}
 
+	if (!zram->comp)
+		zram->comp = zcomp_create(default_compressor);
+	if (!zram->comp) {
+		up_write(&zram->init_lock);
+		pr_info("Cannot initialise compressing backend\n");
+		return -EINVAL;
+	}
+
 	disksize = PAGE_ALIGN(disksize);
 	zram->meta = zram_meta_alloc(disksize);
 	if (!zram->meta) {
@@ -704,6 +730,8 @@ static DEVICE_ATTR(initstate, S_IRUGO, initstate_show, NULL);
 static DEVICE_ATTR(reset, S_IWUSR, NULL, reset_store);
 static DEVICE_ATTR(orig_data_size, S_IRUGO, orig_data_size_show, NULL);
 static DEVICE_ATTR(mem_used_total, S_IRUGO, mem_used_total_show, NULL);
+static DEVICE_ATTR(compressor, S_IRUGO | S_IWUSR,
+		compressor_show, compressor_store);
 
 ZRAM_ATTR_RO(num_reads);
 ZRAM_ATTR_RO(num_writes);
@@ -718,6 +746,7 @@ static struct attribute *zram_disk_attrs[] = {
 	&dev_attr_disksize.attr,
 	&dev_attr_initstate.attr,
 	&dev_attr_reset.attr,
+	&dev_attr_compressor.attr,
 	&dev_attr_num_reads.attr,
 	&dev_attr_num_writes.attr,
 	&dev_attr_failed_reads.attr,
@@ -790,6 +819,7 @@ static int create_device(struct zram *zram, int device_id)
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
1.9.rc1.183.g614c158

