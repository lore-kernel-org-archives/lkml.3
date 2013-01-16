Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758298Ab3APIJH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 03:09:07 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:58321 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652Ab3APIJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 03:09:06 -0500
X-AuditID: 9c930197-b7b76ae000000e7d-2c-50f6601d8480
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org, js1304@gmail.com,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH 2/3] staging, zcache: use zs_mem_[read/write]
Date: Wed, 16 Jan 2013 17:08:56 +0900
Message-Id: <1358323737-13396-2-git-send-email-iamjoonsoo.kim@lge.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358323737-13396-1-git-send-email-iamjoonsoo.kim@lge.com>
References: <1358323737-13396-1-git-send-email-iamjoonsoo.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now, we have newly introduced APIs which reduce copy overhead of
zsmalloc for objects on page boundary.
So use it in zcache.

Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
index 52b43b7..d1dee76 100644
--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@ -704,7 +704,7 @@ static unsigned long zv_create(struct zs_pool *pool, uint32_t pool_id,
 				struct tmem_oid *oid, uint32_t index,
 				void *cdata, unsigned clen)
 {
-	struct zv_hdr *zv;
+	struct zv_hdr zv;
 	u32 size = clen + sizeof(struct zv_hdr);
 	int chunks = (size + (CHUNK_SIZE - 1)) >> CHUNK_SHIFT;
 	unsigned long handle = 0;
@@ -716,14 +716,13 @@ static unsigned long zv_create(struct zs_pool *pool, uint32_t pool_id,
 		goto out;
 	atomic_inc(&zv_curr_dist_counts[chunks]);
 	atomic_inc(&zv_cumul_dist_counts[chunks]);
-	zv = zs_map_object(pool, handle, ZS_MM_WO);
-	zv->index = index;
-	zv->oid = *oid;
-	zv->pool_id = pool_id;
-	zv->size = clen;
-	SET_SENTINEL(zv, ZVH);
-	memcpy((char *)zv + sizeof(struct zv_hdr), cdata, clen);
-	zs_unmap_object(pool, handle);
+	zv.index = index;
+	zv.oid = *oid;
+	zv.pool_id = pool_id;
+	zv.size = clen;
+	SET_SENTINEL((&zv), ZVH);
+	zs_mem_write(pool, handle, &zv, 0, sizeof(struct zv_hdr));
+	zs_mem_write(pool, handle, cdata, sizeof(struct zv_hdr), clen);
 out:
 	return handle;
 }
@@ -731,15 +730,13 @@ out:
 static void zv_free(struct zs_pool *pool, unsigned long handle)
 {
 	unsigned long flags;
-	struct zv_hdr *zv;
+	struct zv_hdr zv;
 	uint16_t size;
 	int chunks;
 
-	zv = zs_map_object(pool, handle, ZS_MM_RW);
-	ASSERT_SENTINEL(zv, ZVH);
-	size = zv->size + sizeof(struct zv_hdr);
-	INVERT_SENTINEL(zv, ZVH);
-	zs_unmap_object(pool, handle);
+	zs_mem_read(pool, handle, &zv, 0, sizeof(struct zv_hdr));
+	ASSERT_SENTINEL((&zv), ZVH);
+	size = zv.size + sizeof(struct zv_hdr);
 
 	chunks = (size + (CHUNK_SIZE - 1)) >> CHUNK_SHIFT;
 	BUG_ON(chunks >= NCHUNKS);
-- 
1.7.9.5

