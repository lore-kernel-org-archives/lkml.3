Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823AbbAWF6n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 00:58:43 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:47394 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbbAWF63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 00:58:29 -0500
X-Original-SENDERIP: 10.177.222.143
X-Original-MAILFROM: minchan@kernel.org
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Nitin Gupta <ngupta@vflare.org>, Jerome Marchand <jmarchan@redhat.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Minchan Kim <minchan@kernel.org>
Subject: [PATCH 1/2] zram: free meta out of init_lock
Date: Fri, 23 Jan 2015 14:58:26 +0900
Message-Id: <1421992707-32658-1-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need to call zram_meta_free, zcomp_destroy and zs_free
under init_lock. What we need to prevent race with init_lock
in reset is setting NULL into zram->meta (ie, init_done).
This patch does it.

Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 drivers/block/zram/zram_drv.c | 28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 9250b3f54a8f..0299d82275e7 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -708,6 +708,7 @@ static void zram_reset_device(struct zram *zram, bool reset_capacity)
 {
 	size_t index;
 	struct zram_meta *meta;
+	struct zcomp *comp;
 
 	down_write(&zram->init_lock);
 
@@ -719,20 +720,10 @@ static void zram_reset_device(struct zram *zram, bool reset_capacity)
 	}
 
 	meta = zram->meta;
-	/* Free all pages that are still in this zram device */
-	for (index = 0; index < zram->disksize >> PAGE_SHIFT; index++) {
-		unsigned long handle = meta->table[index].handle;
-		if (!handle)
-			continue;
-
-		zs_free(meta->mem_pool, handle);
-	}
-
-	zcomp_destroy(zram->comp);
+	comp = zram->comp;
+	zram->meta = NULL;
 	zram->max_comp_streams = 1;
 
-	zram_meta_free(zram->meta);
-	zram->meta = NULL;
 	/* Reset stats */
 	memset(&zram->stats, 0, sizeof(zram->stats));
 
@@ -742,6 +733,19 @@ static void zram_reset_device(struct zram *zram, bool reset_capacity)
 
 	up_write(&zram->init_lock);
 
+	/* Free all pages that are still in this zram device */
+	for (index = 0; index < zram->disksize >> PAGE_SHIFT; index++) {
+		unsigned long handle = meta->table[index].handle;
+
+		if (!handle)
+			continue;
+
+		zs_free(meta->mem_pool, handle);
+	}
+
+	zcomp_destroy(comp);
+	zram_meta_free(meta);
+
 	/*
 	 * Revalidate disk out of the init_lock to avoid lockdep splat.
 	 * It's okay because disk's capacity is protected by init_lock
-- 
1.9.1

