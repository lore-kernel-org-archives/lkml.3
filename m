Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758483Ab3AOWdN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:33:13 -0500
Received: from mail.kernel.org ([198.145.19.201]:43015 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758487Ab3AOWdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:33:06 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Nitin Gupta <ngupta@vflare.org>,
        Mihail Kasadjikov <hamer.mk@gmail.com>, Tomas M <tomas@slax.org>,
        Minchan Kim <minchan@kernel.org>
Subject: [ 148/221] staging: zram: fix invalid memory references during disk write
Date: Tue, 15 Jan 2013 10:51:15 -0800
Message-Id: <20130115185008.730456372@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nitin Gupta <ngupta@vflare.org>

commit 397c60668aa5ae7130b5ad4e73870d7b8a787085 upstream.

Fixes a bug introduced by commit c8f2f0db1 ("zram: Fix handling
of incompressible pages") which caused invalid memory references
during disk write. Invalid references could occur in two cases:
 - Incoming data expands on compression: In this case, reference was
made to kunmap()'ed bio page.
 - Partial (non PAGE_SIZE) write with incompressible data: In this
case, reference was made to a kfree()'ed buffer.

Fixes bug 50081:
https://bugzilla.kernel.org/show_bug.cgi?id=50081

Signed-off-by: Nitin Gupta <ngupta@vflare.org>
Reported-by: Mihail Kasadjikov <hamer.mk@gmail.com>
Reported-by: Tomas M <tomas@slax.org>
Reviewed-by: Minchan Kim <minchan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/zram/zram_drv.c |   39 ++++++++++++++++++++++++---------------
 1 file changed, 24 insertions(+), 15 deletions(-)

--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -265,7 +265,7 @@ out_cleanup:
 static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 			   int offset)
 {
-	int ret;
+	int ret = 0;
 	size_t clen;
 	unsigned long handle;
 	struct page *page;
@@ -286,10 +286,8 @@ static int zram_bvec_write(struct zram *
 			goto out;
 		}
 		ret = zram_decompress_page(zram, uncmem, index);
-		if (ret) {
-			kfree(uncmem);
+		if (ret)
 			goto out;
-		}
 	}
 
 	/*
@@ -302,16 +300,18 @@ static int zram_bvec_write(struct zram *
 
 	user_mem = kmap_atomic(page);
 
-	if (is_partial_io(bvec))
+	if (is_partial_io(bvec)) {
 		memcpy(uncmem + offset, user_mem + bvec->bv_offset,
 		       bvec->bv_len);
-	else
+		kunmap_atomic(user_mem);
+		user_mem = NULL;
+	} else {
 		uncmem = user_mem;
+	}
 
 	if (page_zero_filled(uncmem)) {
-		kunmap_atomic(user_mem);
-		if (is_partial_io(bvec))
-			kfree(uncmem);
+		if (!is_partial_io(bvec))
+			kunmap_atomic(user_mem);
 		zram_stat_inc(&zram->stats.pages_zero);
 		zram_set_flag(zram, index, ZRAM_ZERO);
 		ret = 0;
@@ -321,9 +321,11 @@ static int zram_bvec_write(struct zram *
 	ret = lzo1x_1_compress(uncmem, PAGE_SIZE, src, &clen,
 			       zram->compress_workmem);
 
-	kunmap_atomic(user_mem);
-	if (is_partial_io(bvec))
-			kfree(uncmem);
+	if (!is_partial_io(bvec)) {
+		kunmap_atomic(user_mem);
+		user_mem = NULL;
+		uncmem = NULL;
+	}
 
 	if (unlikely(ret != LZO_E_OK)) {
 		pr_err("Compression failed! err=%d\n", ret);
@@ -332,8 +334,10 @@ static int zram_bvec_write(struct zram *
 
 	if (unlikely(clen > max_zpage_size)) {
 		zram_stat_inc(&zram->stats.bad_compress);
-		src = uncmem;
 		clen = PAGE_SIZE;
+		src = NULL;
+		if (is_partial_io(bvec))
+			src = uncmem;
 	}
 
 	handle = zs_malloc(zram->mem_pool, clen);
@@ -345,7 +349,11 @@ static int zram_bvec_write(struct zram *
 	}
 	cmem = zs_map_object(zram->mem_pool, handle, ZS_MM_WO);
 
+	if ((clen == PAGE_SIZE) && !is_partial_io(bvec))
+		src = kmap_atomic(page);
 	memcpy(cmem, src, clen);
+	if ((clen == PAGE_SIZE) && !is_partial_io(bvec))
+		kunmap_atomic(src);
 
 	zs_unmap_object(zram->mem_pool, handle);
 
@@ -358,9 +366,10 @@ static int zram_bvec_write(struct zram *
 	if (clen <= PAGE_SIZE / 2)
 		zram_stat_inc(&zram->stats.good_compress);
 
-	return 0;
-
 out:
+	if (is_partial_io(bvec))
+		kfree(uncmem);
+
 	if (ret)
 		zram_stat64_inc(zram, &zram->stats.failed_writes);
 	return ret;


