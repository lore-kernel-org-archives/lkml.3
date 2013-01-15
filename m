Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758521Ab3AOWdK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:33:10 -0500
Received: from mail.kernel.org ([198.145.19.201]:43004 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758502Ab3AOWdE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:33:04 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Nitin Gupta <ngupta@vflare.org>
Subject: [ 147/221] staging: zram: factor-out zram_decompress_page() function
Date: Tue, 15 Jan 2013 10:51:14 -0800
Message-Id: <20130115185008.665620504@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

commit 37b51fdddf64e7ba0971d070428655f8d6f36578 upstream.

zram_bvec_read() shared decompress functionality with zram_read_before_write() function.
Factor-out and make commonly used zram_decompress_page() function, which also simplified
error handling in zram_bvec_read().

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Reviewed-by: Nitin Gupta <ngupta@vflare.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/zram/zram_drv.c |  113 ++++++++++++++++------------------------
 1 file changed, 48 insertions(+), 65 deletions(-)

--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -183,62 +183,25 @@ static inline int is_partial_io(struct b
 	return bvec->bv_len != PAGE_SIZE;
 }
 
-static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
-			  u32 index, int offset, struct bio *bio)
+static int zram_decompress_page(struct zram *zram, char *mem, u32 index)
 {
-	int ret;
-	size_t clen;
-	struct page *page;
-	unsigned char *user_mem, *cmem, *uncmem = NULL;
-
-	page = bvec->bv_page;
-
-	if (zram_test_flag(zram, index, ZRAM_ZERO)) {
-		handle_zero_page(bvec);
-		return 0;
-	}
+	int ret = LZO_E_OK;
+	size_t clen = PAGE_SIZE;
+	unsigned char *cmem;
+	unsigned long handle = zram->table[index].handle;
 
-	/* Requested page is not present in compressed area */
-	if (unlikely(!zram->table[index].handle)) {
-		pr_debug("Read before write: sector=%lu, size=%u",
-			 (ulong)(bio->bi_sector), bio->bi_size);
-		handle_zero_page(bvec);
+	if (!handle || zram_test_flag(zram, index, ZRAM_ZERO)) {
+		memset(mem, 0, PAGE_SIZE);
 		return 0;
 	}
 
-	if (is_partial_io(bvec)) {
-		/* Use  a temporary buffer to decompress the page */
-		uncmem = kmalloc(PAGE_SIZE, GFP_KERNEL);
-		if (!uncmem) {
-			pr_info("Error allocating temp memory!\n");
-			return -ENOMEM;
-		}
-	}
-
-	user_mem = kmap_atomic(page);
-	if (!is_partial_io(bvec))
-		uncmem = user_mem;
-	clen = PAGE_SIZE;
-
-	cmem = zs_map_object(zram->mem_pool, zram->table[index].handle,
-				ZS_MM_RO);
-
-	if (zram->table[index].size == PAGE_SIZE) {
-		memcpy(uncmem, cmem, PAGE_SIZE);
-		ret = LZO_E_OK;
-	} else {
+	cmem = zs_map_object(zram->mem_pool, handle, ZS_MM_RO);
+	if (zram->table[index].size == PAGE_SIZE)
+		memcpy(mem, cmem, PAGE_SIZE);
+	else
 		ret = lzo1x_decompress_safe(cmem, zram->table[index].size,
-				    uncmem, &clen);
-	}
-
-	if (is_partial_io(bvec)) {
-		memcpy(user_mem + bvec->bv_offset, uncmem + offset,
-		       bvec->bv_len);
-		kfree(uncmem);
-	}
-
-	zs_unmap_object(zram->mem_pool, zram->table[index].handle);
-	kunmap_atomic(user_mem);
+						mem, &clen);
+	zs_unmap_object(zram->mem_pool, handle);
 
 	/* Should NEVER happen. Return bio error if it does. */
 	if (unlikely(ret != LZO_E_OK)) {
@@ -247,36 +210,56 @@ static int zram_bvec_read(struct zram *z
 		return ret;
 	}
 
-	flush_dcache_page(page);
-
 	return 0;
 }
 
-static int zram_read_before_write(struct zram *zram, char *mem, u32 index)
+static int zram_bvec_read(struct zram *zram, struct bio_vec *bvec,
+			  u32 index, int offset, struct bio *bio)
 {
 	int ret;
-	size_t clen = PAGE_SIZE;
-	unsigned char *cmem;
-	unsigned long handle = zram->table[index].handle;
+	struct page *page;
+	unsigned char *user_mem, *uncmem = NULL;
 
-	if (zram_test_flag(zram, index, ZRAM_ZERO) || !handle) {
-		memset(mem, 0, PAGE_SIZE);
+	page = bvec->bv_page;
+
+	if (unlikely(!zram->table[index].handle) ||
+			zram_test_flag(zram, index, ZRAM_ZERO)) {
+		handle_zero_page(bvec);
 		return 0;
 	}
 
-	cmem = zs_map_object(zram->mem_pool, handle, ZS_MM_RO);
-	ret = lzo1x_decompress_safe(cmem, zram->table[index].size,
-				    mem, &clen);
-	zs_unmap_object(zram->mem_pool, handle);
+	user_mem = kmap_atomic(page);
+	if (is_partial_io(bvec))
+		/* Use  a temporary buffer to decompress the page */
+		uncmem = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	else
+		uncmem = user_mem;
+
+	if (!uncmem) {
+		pr_info("Unable to allocate temp memory\n");
+		ret = -ENOMEM;
+		goto out_cleanup;
+	}
 
+	ret = zram_decompress_page(zram, uncmem, index);
 	/* Should NEVER happen. Return bio error if it does. */
 	if (unlikely(ret != LZO_E_OK)) {
 		pr_err("Decompression failed! err=%d, page=%u\n", ret, index);
 		zram_stat64_inc(zram, &zram->stats.failed_reads);
-		return ret;
+		goto out_cleanup;
 	}
 
-	return 0;
+	if (is_partial_io(bvec))
+		memcpy(user_mem + bvec->bv_offset, uncmem + offset,
+				bvec->bv_len);
+
+	flush_dcache_page(page);
+	ret = 0;
+out_cleanup:
+	kunmap_atomic(user_mem);
+	if (is_partial_io(bvec))
+		kfree(uncmem);
+	return ret;
 }
 
 static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
@@ -302,7 +285,7 @@ static int zram_bvec_write(struct zram *
 			ret = -ENOMEM;
 			goto out;
 		}
-		ret = zram_read_before_write(zram, uncmem, index);
+		ret = zram_decompress_page(zram, uncmem, index);
 		if (ret) {
 			kfree(uncmem);
 			goto out;


