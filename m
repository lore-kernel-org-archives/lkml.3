Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758484Ab3APIJX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 03:09:23 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:58321 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758188Ab3APIJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 03:09:07 -0500
X-AuditID: 9c930197-b7b76ae000000e7d-2f-50f6601d2030
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org, js1304@gmail.com,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH 3/3] staging, zram: use zs_mem_[read/write]
Date: Wed, 16 Jan 2013 17:08:57 +0900
Message-Id: <1358323737-13396-3-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358323737-13396-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1358323737-13396-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, we have newly introduced APIs which reduce copy overhead of
zsmalloc for objects on page boundary.
So use it in zram.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index fb4a7c9..554a742 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -195,13 +195,14 @@ static int zram_decompress_page(struct zram *zram, char *mem, u32 index)
 		return 0;
 	}
 
-	cmem = zs_map_object(zram->mem_pool, handle, ZS_MM_RO);
 	if (zram->table[index].size == PAGE_SIZE)
-		memcpy(mem, cmem, PAGE_SIZE);
-	else
+		zs_mem_read(zram->mem_pool, handle, mem, 0, PAGE_SIZE);
+	else {
+		cmem = zs_map_object(zram->mem_pool, handle, ZS_MM_RO);
 		ret = lzo1x_decompress_safe(cmem, zram->table[index].size,
 						mem, &clen);
-	zs_unmap_object(zram->mem_pool, handle);
+		zs_unmap_object(zram->mem_pool, handle);
+	}
 
 	/* Should NEVER happen. Return bio error if it does. */
 	if (unlikely(ret != LZO_E_OK)) {
@@ -269,7 +270,7 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 	size_t clen;
 	unsigned long handle;
 	struct page *page;
-	unsigned char *user_mem, *cmem, *src, *uncmem = NULL;
+	unsigned char *user_mem, *src, *uncmem = NULL;
 
 	page = bvec->bv_page;
 	src = zram->compress_buffer;
@@ -343,11 +344,8 @@ static int zram_bvec_write(struct zram *zram, struct bio_vec *bvec, u32 index,
 		ret = -ENOMEM;
 		goto out;
 	}
-	cmem = zs_map_object(zram->mem_pool, handle, ZS_MM_WO);
-
-	memcpy(cmem, src, clen);
 
-	zs_unmap_object(zram->mem_pool, handle);
+	zs_mem_write(zram->mem_pool, handle, src, 0, clen);
 
 	zram->table[index].handle = handle;
 	zram->table[index].size = clen;
-- 
1.7.9.5

