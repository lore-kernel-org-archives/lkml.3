Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209AbaAQLHj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 06:07:39 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:50190 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbaAQLH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 06:07:29 -0500
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: [RFC PATCH 2/3] zram: introduce zram compressor operations struct
Date: Fri, 17 Jan 2014 14:04:16 +0300
Message-Id: <1389956657-5486-3-git-send-email-sergey.senozhatsky@gmail.com>
X-Mailer: git-send-email 1.8.5.3.493.gb139ac2
In-Reply-To: <1389956657-5486-1-git-send-email-sergey.senozhatsky@gmail.com>
References: <1389956657-5486-1-git-send-email-sergey.senozhatsky@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is preparation patch to add LZ4 compression support.

struct zram_compress_ops defines common compress and decompress
prototypes. Use these ops->compress and ops->decompress callbacks
instead of direct LZO lzo1x_1_compress() and lzo1x_decompress_safe()
calls.

Compressor ops should be defined before zram meta allocation,
because the size of meta->compress_workmem depends on selected
compression algorithm.

Define LZO compressor ops and set it as the only one available
zram compressor at the moment.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
---
 drivers/block/zram/zram_drv.c | 20 +++++++++++++-------
 drivers/block/zram/zram_drv.h | 10 ++++++++++
 2 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 7124042..4f2c748 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -28,10 +28,9 @@
 #include <linux/device.h>
 #include <linux/genhd.h>
 #include <linux/highmem.h>
-#include <linux/slab.h>
-#include <linux/lzo.h>
 #include <linux/string.h>
 #include <linux/vmalloc.h>
+#include <linux/lzo.h>
 
 #include "zram_drv.h"
 
@@ -42,6 +41,12 @@ static struct zram *zram_devices;
 /* Module params (documentation at end) */
 static unsigned int num_devices = 1;
 
+static struct zram_compress_ops lzo_compressor = {
+	.workmem_sz = LZO1X_MEM_COMPRESS,
+	.compress = lzo1x_1_compress,
+	.decompress = lzo1x_decompress_safe,
+};
+
 #define ZRAM_ATTR_RO(name)						\
 static ssize_t zram_attr_##name##_show(struct device *d,		\
 				struct device_attribute *attr, char *b)	\
@@ -166,14 +171,14 @@ static void zram_meta_free(struct zram_meta *meta)
 	kfree(meta);
 }
 
-static struct zram_meta *zram_meta_alloc(u64 disksize)
+static struct zram_meta *zram_meta_alloc(int workmem_sz, u64 disksize)
 {
 	size_t num_pages;
 	struct zram_meta *meta = kmalloc(sizeof(*meta), GFP_KERNEL);
 	if (!meta)
 		goto out;
 
-	meta->compress_workmem = kzalloc(LZO1X_MEM_COMPRESS, GFP_KERNEL);
+	meta->compress_workmem = kzalloc(workmem_sz, GFP_KERNEL);
 	if (!meta->compress_workmem)
 		goto free_meta;
 
@@ -301,7 +306,7 @@ static int zram_decompress_page(struct zram *zram, char *mem, u32 index)
 	if (size == PAGE_SIZE)
 		copy_page(mem, cmem);
 	else
-		ret = lzo1x_decompress_safe(cmem, size,	mem, &clen);
+		ret = zram->ops->decompress(cmem, size, mem, &clen);
 	zs_unmap_object(meta->mem_pool, handle);
 	read_unlock(&meta->tb_lock);
 
@@ -420,7 +425,7 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 		goto out;
 	}
 
-	ret = lzo1x_1_compress(uncmem, PAGE_SIZE, src, &clen,
+	ret = zram->ops->compress(uncmem, PAGE_SIZE, src, &clen,
 			       meta->compress_workmem);
 	if (!is_partial_io(bvec)) {
 		kunmap_atomic(user_mem);
@@ -551,7 +556,7 @@ static ssize_t disksize_store(struct device *dev,
 	}
 
 	disksize = PAGE_ALIGN(disksize);
-	zram->meta = zram_meta_alloc(disksize);
+	zram->meta = zram_meta_alloc(zram->ops->workmem_sz, disksize);
 
 	zram->disksize = disksize;
 	set_capacity(zram->disk, zram->disksize >> SECTOR_SHIFT);
@@ -785,6 +790,7 @@ static int create_device(struct zram *zram, int device_id)
 		goto out_free_disk;
 	}
 
+	zram->ops = &lzo_compressor;
 	zram->meta = NULL;
 	return 0;
 
diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
index 1d5b1f5..5488682 100644
--- a/drivers/block/zram/zram_drv.h
+++ b/drivers/block/zram/zram_drv.h
@@ -88,8 +88,18 @@ struct zram_meta {
 	struct mutex buffer_lock; /* protect compress buffers */
 };
 
+/* compression/decompression functions and algorithm-specific workmem size */
+struct zram_compress_ops {
+	int (*compress)(const unsigned char *src, size_t src_len,
+			unsigned char *dst, size_t *dst_len, void *wrkmem);
+	int (*decompress)(const unsigned char *src, size_t src_len,
+			unsigned char *dst, size_t *dst_len);
+	long workmem_sz;
+};
+
 struct zram {
 	struct zram_meta *meta;
+	struct zram_compress_ops *ops;
 	struct request_queue *queue;
 	struct gendisk *disk;
 	/* Prevent concurrent execution of device init, reset and R/W request */
-- 
1.8.5.3.493.gb139ac2

