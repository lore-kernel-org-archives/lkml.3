Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759014Ab3FCPpl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 11:45:41 -0400
Received: from mail-pb0-f44.google.com ([209.85.160.44]:57040 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758938Ab3FCPpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 11:45:11 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Jerome Marchand <jmarchan@redhat.com>
Cc: Yijing Wang <wangyijing@huawei.com>, Jiang Liu <jiang.liu@huawei.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH v1 7/8] zram: optimize memory operations with clear_page()/copy_page()
Date: Mon,  3 Jun 2013 23:42:19 +0800
Message-Id: <1370274140-26420-8-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370274140-26420-1-git-send-email-jiang.liu@huawei.com>
References: <1370274140-26420-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
---
 drivers/staging/zram/zram_drv.c | 27 ++++++++++++++++-----------
 1 file changed, 16 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index 64b51b9..b079af5 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -128,23 +128,26 @@ static void zram_free_page(struct zram *zram, size_t index)
 	meta->table[index].size = 0;
 }
 
+static inline int is_partial_io(struct bio_vec *bvec)
+{
+	return bvec->bv_len != PAGE_SIZE;
+}
+
 static void handle_zero_page(struct bio_vec *bvec)
 {
 	struct page *page = bvec->bv_page;
 	void *user_mem;
 
 	user_mem = kmap_atomic(page);
-	memset(user_mem + bvec->bv_offset, 0, bvec->bv_len);
+	if (is_partial_io(bvec))
+		memset(user_mem + bvec->bv_offset, 0, bvec->bv_len);
+	else
+		clear_page(user_mem);
 	kunmap_atomic(user_mem);
 
 	flush_dcache_page(page);
 }
 
-static inline int is_partial_io(struct bio_vec *bvec)
-{
-	return bvec->bv_len != PAGE_SIZE;
-}
-
 static int zram_decompress_page(struct zram *zram, char *mem, u32 index)
 {
 	int ret = LZO_E_OK;
@@ -154,13 +157,13 @@ static int zram_decompress_page(struct zram *zram, char *mem, u32 index)
 	unsigned long handle = meta->table[index].handle;
 
 	if (!handle || zram_test_flag(meta, index, ZRAM_ZERO)) {
-		memset(mem, 0, PAGE_SIZE);
+		clear_page(mem);
 		return 0;
 	}
 
 	cmem = zs_map_object(meta->mem_pool, handle, ZS_MM_RO);
 	if (meta->table[index].size == PAGE_SIZE)
-		memcpy(mem, cmem, PAGE_SIZE);
+		copy_page(mem, cmem);
 	else
 		ret = lzo1x_decompress_safe(cmem, meta->table[index].size,
 						mem, &clen);
@@ -309,11 +312,13 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 	}
 	cmem = zs_map_object(meta->mem_pool, handle, ZS_MM_WO);
 
-	if ((clen == PAGE_SIZE) && !is_partial_io(bvec))
+	if ((clen == PAGE_SIZE) && !is_partial_io(bvec)) {
 		src = kmap_atomic(page);
-	memcpy(cmem, src, clen);
-	if ((clen == PAGE_SIZE) && !is_partial_io(bvec))
+		copy_page(cmem, src);
 		kunmap_atomic(src);
+	} else {
+		memcpy(cmem, src, clen);
+	}
 
 	zs_unmap_object(meta->mem_pool, handle);
 
-- 
1.8.1.2

