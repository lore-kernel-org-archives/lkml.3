Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964968AbbA2EOp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 23:14:45 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:42699 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754324AbbA2EOo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 23:14:44 -0500
X-AuditID: cbfee61a-f79c06d000004e71-92-54c9b3ac940d
From: Ganesh Mahendran <opensource.ganesh@gmail.com>
To: minchan@kernel.org, ngupta@vflare.org, sergey.senozhatsky.work@gmail.com
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Ganesh Mahendran <opensource.ganesh@gmail.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: [PATCH v2] zram: free meta table in zram_meta_free
Date: Tue, 20 Jan 2015 07:43:47 +0800
Message-id: <1421711028-5553-1-git-send-email-opensource.ganesh@gmail.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphluLIzCtJLcpLzFFi42I5/e+xgO6azSdDDH49UbeYs34Nm8XlXXPY
	LO6t+c9qsezre3aLDS2z2C1abz1msXg0YRKTxdrPj9kdODx2zrrL7rFpVSebx6ZPk9g9Tsz4
	zeKx89NmVo/Pm+QC2KK4bFJSczLLUov07RK4Mua3dDAX/Baq6H0Q1MB4kr+LkZNDQsBEYtal
	FYwQtpjEhXvr2boYuTiEBBYxSvSu3ckI4bQzSfw9tIQNpIoNqOPG6VZ2EFtEwEfi9Zlr7CBF
	zALbGCUObVvAApIQFrCWeLi4C6yBRUBV4uLEBiCbg4NXwEtixgxuEFNCQEFiziSbCYzcCxgZ
	VjGKphYkFxQnpeca6hUn5haX5qXrJefnbmIEh80zqR2MKxssDjEKcDAq8fBy1J8MEWJNLCuu
	zD3EKMHBrCTCe70ZKMSbklhZlVqUH19UmpNafIhRmoNFSZxXyb4tREggPbEkNTs1tSC1CCbL
	xMEp1cBoJSWfE/v86jrTt7KaNWYSbWaXF02r/ciX/d4leMfxv1U/Db+y+JbJWF3luOj9yG3N
	NbEA7S9fZXPkjqw+6D1fY9EJuZZ2BoFnv2arTs+peqKzUNPp1Kk3js2/Nv0oVnow6+kGjQlS
	K1iY1S+1GyxS+aTrUN18wXOiYYHX2v8qjhmJgtnu10KVWIozEg21mIuKEwFt3QZiFwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

zram_meta_alloc() and zram_meta_free() are a pair.
In zram_meta_alloc(), meta table is allocated. So it it better to free
it in zram_meta_free().

Signed-off-by: Ganesh Mahendran <opensource.ganesh@gmail.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
---
v2: use zram->disksize to get num of pages - Sergey
---
 drivers/block/zram/zram_drv.c |   33 ++++++++++++++++-----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 9250b3f..aa5a4c5 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -307,8 +307,21 @@ static inline int valid_io_request(struct zram *zram,
 	return 1;
 }
 
-static void zram_meta_free(struct zram_meta *meta)
+static void zram_meta_free(struct zram_meta *meta, u64 disksize)
 {
+	size_t num_pages = disksize >> PAGE_SHIFT;
+	size_t index;
+
+	/* Free all pages that are still in this zram device */
+	for (index = 0; index < num_pages; index++) {
+		unsigned long handle = meta->table[index].handle;
+
+		if (!handle)
+			continue;
+
+		zs_free(meta->mem_pool, handle);
+	}
+
 	zs_destroy_pool(meta->mem_pool);
 	vfree(meta->table);
 	kfree(meta);
@@ -706,9 +719,6 @@ static void zram_bio_discard(struct zram *zram, u32 index,
 
 static void zram_reset_device(struct zram *zram, bool reset_capacity)
 {
-	size_t index;
-	struct zram_meta *meta;
-
 	down_write(&zram->init_lock);
 
 	zram->limit_pages = 0;
@@ -718,20 +728,9 @@ static void zram_reset_device(struct zram *zram, bool reset_capacity)
 		return;
 	}
 
-	meta = zram->meta;
-	/* Free all pages that are still in this zram device */
-	for (index = 0; index < zram->disksize >> PAGE_SHIFT; index++) {
-		unsigned long handle = meta->table[index].handle;
-		if (!handle)
-			continue;
-
-		zs_free(meta->mem_pool, handle);
-	}
-
 	zcomp_destroy(zram->comp);
 	zram->max_comp_streams = 1;
-
-	zram_meta_free(zram->meta);
+	zram_meta_free(zram->meta, zram->disksize);
 	zram->meta = NULL;
 	/* Reset stats */
 	memset(&zram->stats, 0, sizeof(zram->stats));
@@ -803,7 +802,7 @@ out_destroy_comp:
 	up_write(&zram->init_lock);
 	zcomp_destroy(comp);
 out_free_meta:
-	zram_meta_free(meta);
+	zram_meta_free(meta, disksize);
 	return err;
 }
 
-- 
1.7.9.5

