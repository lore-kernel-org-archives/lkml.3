Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751305AbaLUOfM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 09:35:12 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:55429 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050AbaLUOfK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 09:35:10 -0500
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: [PATCH] zram: clean up zram_meta_alloc()
Date: Sun, 21 Dec 2014 23:35:41 +0900
Message-Id: <1419172541-26173-1-git-send-email-sergey.senozhatsky@gmail.com>
X-Mailer: git-send-email 2.2.1.209.g41e5f3a
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

a trivial clean up of zram_meta_alloc() error handling.

Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
---
 drivers/block/zram/zram_drv.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index bd8bda3..369fe56 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -318,31 +318,29 @@ static struct zram_meta *zram_meta_alloc(u64 disksize)
 {
 	size_t num_pages;
 	struct zram_meta *meta = kmalloc(sizeof(*meta), GFP_KERNEL);
+
 	if (!meta)
-		goto out;
+		return NULL;
 
 	num_pages = disksize >> PAGE_SHIFT;
 	meta->table = vzalloc(num_pages * sizeof(*meta->table));
 	if (!meta->table) {
 		pr_err("Error allocating zram address table\n");
-		goto free_meta;
+		goto out_error;
 	}
 
 	meta->mem_pool = zs_create_pool(GFP_NOIO | __GFP_HIGHMEM);
 	if (!meta->mem_pool) {
 		pr_err("Error creating memory pool\n");
-		goto free_table;
+		goto out_error;
 	}
 
 	return meta;
 
-free_table:
+out_error:
 	vfree(meta->table);
-free_meta:
 	kfree(meta);
-	meta = NULL;
-out:
-	return meta;
+	return NULL;
 }
 
 static void update_position(u32 *index, int *offset, struct bio_vec *bvec)
-- 
2.2.1.209.g41e5f3a

