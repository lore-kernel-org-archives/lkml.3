Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751591Ab3G3McH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 08:32:07 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:27907 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750857Ab3G3McE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 08:32:04 -0400
X-AuditID: cbfee61b-b7efe6d000007b11-61-51f7b2415505
From: Piotr Sarna <p.sarna@partner.samsung.com>
To: gregkh@linuxfoundation.org
Cc: ngupta@vflare.org, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, b.zolnierkie@samsung.com,
        Piotr Sarna <p.sarna@partner.samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH 1/2] staging: zram: add Crypto API support
Date: Tue, 30 Jul 2013 14:30:48 +0200
Message-id: <1375187449-6546-1-git-send-email-p.sarna@partner.samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpgluLIzCtJLcpLzFFi42I5/e+xgK7jpu+BBq9/6VhsnLGe1WLPmV/s
	Fs2L17NZnG16w25xedccNosNLbPYLVYtinJg97i37zCLx/65a9g9Dr7bw+TRt2UVo8fOT5tZ
	PT5vkgtgi+KySUnNySxLLdK3S+DK2LDgOUvBbqeKL7O6WBoYF5t1MXJySAiYSMz9NJMVwhaT
	uHBvPVsXIxeHkMAiRol3s1uYIZx2JoltH3czgVSxCehLfLm+hgXEFhGQk3hy+w9YEbPAUUaJ
	qdfXM4IkhAWsJE5e2QBWxCKgKnG/8T4biM0r4CWxt+kkUJwDaJ2CxJxJNhMYuRcwMqxiFE0t
	SC4oTkrPNdIrTswtLs1L10vOz93ECA6XZ9I7GFc1WBxiFOBgVOLh3VDwLVCINbGsuDL3EKME
	B7OSCO/5id8DhXhTEiurUovy44tKc1KLDzFKc7AoifMebLUOFBJITyxJzU5NLUgtgskycXBK
	NTBWn/woXbdidqYJ3+Oyg/+e9PYohzYFzPMIyO38GCPHd3GPLoP+mrQ2JUOnwHgnjWe3ypzz
	GeMOvBIQ+bDvAP/+JUJfphTq+dusvrx521R+W6bE9LLPTxZyWrl0msx2/jXPQyR5r1v4jdrs
	+dcMgmrDei89i8tas3udwleGk3M/hLD+7bLU2ajEUpyRaKjFXFScCACTx3ONEwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current version of zram does not allow any substitution of a default
compression algorithm. Therefore, I decided to change the existing
implementation of page compression by adding Crypto API compability.

All direct calls to lzo1x compression/decompression methods are now
replaced by calls consistent with Crypto. Also, I removed "workmem"
field from struct zram_meta, as it was there for lzo1x purposes only
and is no longer needed. Finally, I added a set of functions required
by Crypto API to work properly.

In order to substitute the default algorithm (lzo), change the value
of zram.compressor module parameter to a proper name (e.g. lz4).

Signed-off-by: Piotr Sarna <p.sarna@partner.samsung.com>
Acked-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/staging/zram/Kconfig    |    5 +-
 drivers/staging/zram/zram_drv.c |  106 ++++++++++++++++++++++++++++++++-------
 drivers/staging/zram/zram_drv.h |    1 -
 3 files changed, 89 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/zram/Kconfig b/drivers/staging/zram/Kconfig
index 983314c..b51cac5 100644
--- a/drivers/staging/zram/Kconfig
+++ b/drivers/staging/zram/Kconfig
@@ -1,8 +1,7 @@
 config ZRAM
 	tristate "Compressed RAM block device support"
-	depends on BLOCK && SYSFS && ZSMALLOC
-	select LZO_COMPRESS
-	select LZO_DECOMPRESS
+	depends on BLOCK && SYSFS && ZSMALLOC && CRYPTO=y
+	select CRYPTO_LZO
 	default n
 	help
 	  Creates virtual block devices called /dev/zramX (X = 0, 1, ...).
diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 7ebf91d..d6f1f67 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -29,12 +29,14 @@
 #include <linux/genhd.h>
 #include <linux/highmem.h>
 #include <linux/slab.h>
-#include <linux/lzo.h>
+#include <linux/crypto.h>
 #include <linux/string.h>
 #include <linux/vmalloc.h>
 
 #include "zram_drv.h"
 
+#define ZRAM_COMPRESSOR_DEFAULT "lzo"
+
 /* Globals */
 static int zram_major;
 static struct zram *zram_devices;
@@ -42,6 +44,64 @@ static struct zram *zram_devices;
 /* Module params (documentation at end) */
 static unsigned int num_devices = 1;
 
+/* Cryptographic API features */
+static char *zram_compressor = ZRAM_COMPRESSOR_DEFAULT;
+static struct crypto_comp *zram_comp_tfm;
+
+enum comp_op {
+	ZRAM_COMPOP_COMPRESS,
+	ZRAM_COMPOP_DECOMPRESS
+};
+
+static int zram_comp_op(enum comp_op op, const u8 *src, unsigned int slen,
+			u8 *dst, unsigned int *dlen)
+{
+	struct crypto_comp *tfm;
+	int ret;
+
+	tfm = zram_comp_tfm;
+	switch (op) {
+	case ZRAM_COMPOP_COMPRESS:
+		ret = crypto_comp_compress(tfm, src, slen, dst, dlen);
+		break;
+	case ZRAM_COMPOP_DECOMPRESS:
+		ret = crypto_comp_decompress(tfm, src, slen, dst, dlen);
+		break;
+	default:
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+static int __init zram_comp_init(void)
+{
+	int ret;
+	ret = crypto_has_comp(zram_compressor, 0, 0);
+	if (!ret) {
+		pr_info("%s is not available\n", zram_compressor);
+		zram_compressor = ZRAM_COMPRESSOR_DEFAULT;
+		ret = crypto_has_comp(zram_compressor, 0, 0);
+		if (!ret)
+			return -ENODEV;
+	}
+	pr_info("using %s compressor\n", zram_compressor);
+
+	/* alloc transform */
+	zram_comp_tfm = crypto_alloc_comp(zram_compressor, 0, 0);
+	if (!zram_comp_tfm)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static inline void zram_comp_exit(void)
+{
+	if (zram_comp_tfm)
+		crypto_free_comp(zram_comp_tfm);
+}
+/* end of Cryptographic API features */
+
 static inline struct zram *dev_to_zram(struct device *dev)
 {
 	return (struct zram *)dev_to_disk(dev)->private_data;
@@ -190,7 +250,6 @@ static inline int valid_io_request(struct zram *zram, struct bio *bio)
 static void zram_meta_free(struct zram_meta *meta)
 {
 	zs_destroy_pool(meta->mem_pool);
-	kfree(meta->compress_workmem);
 	free_pages((unsigned long)meta->compress_buffer, 1);
 	vfree(meta->table);
 	kfree(meta);
@@ -203,15 +262,11 @@ static struct zram_meta *zram_meta_alloc(u64 disksize)
 	if (!meta)
 		goto out;
 
-	meta->compress_workmem = kzalloc(LZO1X_MEM_COMPRESS, GFP_KERNEL);
-	if (!meta->compress_workmem)
-		goto free_meta;
-
 	meta->compress_buffer =
 		(void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, 1);
 	if (!meta->compress_buffer) {
 		pr_err("Error allocating compressor buffer space\n");
-		goto free_workmem;
+		goto free_meta;
 	}
 
 	num_pages = disksize >> PAGE_SHIFT;
@@ -233,8 +288,6 @@ free_table:
 	vfree(meta->table);
 free_buffer:
 	free_pages((unsigned long)meta->compress_buffer, 1);
-free_workmem:
-	kfree(meta->compress_workmem);
 free_meta:
 	kfree(meta);
 	meta = NULL;
@@ -314,7 +367,7 @@ static void zram_free_page(struct zram *zram, size_t index)
 
 static int zram_decompress_page(struct zram *zram, char *mem, u32 index)
 {
-	int ret = LZO_E_OK;
+	int ret = 0;
 	size_t clen = PAGE_SIZE;
 	unsigned char *cmem;
 	struct zram_meta *meta = zram->meta;
@@ -329,12 +382,13 @@ static int zram_decompress_page(struct zram *zram, char *mem, u32 index)
 	if (meta->table[index].size == PAGE_SIZE)
 		copy_page(mem, cmem);
 	else
-		ret = lzo1x_decompress_safe(cmem, meta->table[index].size,
-						mem, &clen);
+		ret = zram_comp_op(ZRAM_COMPOP_DECOMPRESS, cmem,
+			meta->table[index].size, mem, &clen);
+
 	zs_unmap_object(meta->mem_pool, handle);
 
 	/* Should NEVER happen. Return bio error if it does. */
-	if (unlikely(ret != LZO_E_OK)) {
+	if (unlikely(ret != 0)) {
 		pr_err("Decompression failed! err=%d, page=%u\n", ret, index);
 		atomic64_inc(&zram->stats.failed_reads);
 		return ret;
@@ -374,7 +428,7 @@ static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
 
 	ret = zram_decompress_page(zram, uncmem, index);
 	/* Should NEVER happen. Return bio error if it does. */
-	if (unlikely(ret != LZO_E_OK))
+	if (unlikely(ret != 0))
 		goto out_cleanup;
 
 	if (is_partial_io(bvec))
@@ -440,8 +494,8 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 		goto out;
 	}
 
-	ret = lzo1x_1_compress(uncmem, PAGE_SIZE, src, &clen,
-			       meta->compress_workmem);
+	ret = zram_comp_op(ZRAM_COMPOP_COMPRESS, uncmem,
+			   PAGE_SIZE, src, &clen);
 
 	if (!is_partial_io(bvec)) {
 		kunmap_atomic(user_mem);
@@ -449,7 +503,7 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 		uncmem = NULL;
 	}
 
-	if (unlikely(ret != LZO_E_OK)) {
+	if (unlikely(ret != 0)) {
 		pr_err("Compression failed! err=%d\n", ret);
 		goto out;
 	}
@@ -854,18 +908,26 @@ static int __init zram_init(void)
 {
 	int ret, dev_id;
 
+	/* Initialize Cryptographic API */
+	pr_info("Loading Crypto API features\n");
+	if (zram_comp_init()) {
+		pr_err("Compressor initialization failed\n");
+		ret = -ENOMEM;
+		goto out;
+	}
+
 	if (num_devices > max_num_devices) {
 		pr_warn("Invalid value for num_devices: %u\n",
 				num_devices);
 		ret = -EINVAL;
-		goto out;
+		goto free_comp;
 	}
 
 	zram_major = register_blkdev(0, "zram");
 	if (zram_major <= 0) {
 		pr_warn("Unable to get major number\n");
 		ret = -EBUSY;
-		goto out;
+		goto free_comp;
 	}
 
 	/* Allocate the device array and initialize each one */
@@ -891,6 +953,8 @@ free_devices:
 	kfree(zram_devices);
 unregister:
 	unregister_blkdev(zram_major, "zram");
+free_comp:
+	zram_comp_exit();
 out:
 	return ret;
 }
@@ -912,6 +976,7 @@ static void __exit zram_exit(void)
 	unregister_blkdev(zram_major, "zram");
 
 	kfree(zram_devices);
+	zram_comp_exit();
 	pr_debug("Cleanup done!\n");
 }
 
@@ -921,6 +986,9 @@ module_exit(zram_exit);
 module_param(num_devices, uint, 0);
 MODULE_PARM_DESC(num_devices, "Number of zram devices");
 
+module_param_named(compressor, zram_compressor, charp, 0);
+MODULE_PARM_DESC(compressor, "Compressor type");
+
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_AUTHOR("Nitin Gupta <ngupta@vflare.org>");
 MODULE_DESCRIPTION("Compressed RAM Block Device");
diff --git a/drivers/staging/zram/zram_drv.h b/drivers/staging/zram/zram_drv.h
index 9e57bfb..93f4d14 100644
--- a/drivers/staging/zram/zram_drv.h
+++ b/drivers/staging/zram/zram_drv.h
@@ -88,7 +88,6 @@ struct zram_stats {
 };
 
 struct zram_meta {
-	void *compress_workmem;
 	void *compress_buffer;
 	struct table *table;
 	struct zs_pool *mem_pool;
-- 
1.7.9.5

