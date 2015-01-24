Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753307AbbAXNqL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 08:46:11 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:59001 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081AbbAXNqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 08:46:08 -0500
From: Ganesh Mahendran <opensource.ganesh@gmail.com>
To: minchan@kernel.org, ngupta@vflare.org
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Ganesh Mahendran <opensource.ganesh@gmail.com>
Subject: [PATCH] zram: free meta table in zram_meta_free
Date: Sat, 24 Jan 2015 21:45:53 +0800
Message-Id: <1422107153-9701-1-git-send-email-opensource.ganesh@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

zram_meta_alloc() and zram_meta_free() are a pair.
In zram_meta_alloc(), meta table is allocated. So it it better to free
it in zram_meta_free().

Signed-off-by: Ganesh Mahendran <opensource.ganesh@gmail.com>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Minchan Kim <minchan@kernel.org>
---
 drivers/block/zram/zram_drv.c |   28 ++++++++++++++--------------
 drivers/block/zram/zram_drv.h |    1 +
 2 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 9bbc302..52fef1b 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -309,6 +309,18 @@ static inline int valid_io_request(struct zram *zram,
 
 static void zram_meta_free(struct zram_meta *meta)
 {
+	size_t index;
+
+	/* Free all pages that are still in this zram device */
+	for (index = 0; index < meta->num_pages; index++) {
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
@@ -316,14 +328,13 @@ static void zram_meta_free(struct zram_meta *meta)
 
 static struct zram_meta *zram_meta_alloc(int device_id, u64 disksize)
 {
-	size_t num_pages;
 	char pool_name[8];
 	struct zram_meta *meta = kmalloc(sizeof(*meta), GFP_KERNEL);
 	if (!meta)
 		goto out;
 
-	num_pages = disksize >> PAGE_SHIFT;
-	meta->table = vzalloc(num_pages * sizeof(*meta->table));
+	meta->num_pages = disksize >> PAGE_SHIFT;
+	meta->table = vzalloc(meta->num_pages * sizeof(*meta->table));
 	if (!meta->table) {
 		pr_err("Error allocating zram address table\n");
 		goto free_meta;
@@ -708,7 +719,6 @@ static void zram_bio_discard(struct zram *zram, u32 index,
 
 static void zram_reset_device(struct zram *zram, bool reset_capacity)
 {
-	size_t index;
 	struct zram_meta *meta;
 	struct zcomp *comp;
 
@@ -735,16 +745,6 @@ static void zram_reset_device(struct zram *zram, bool reset_capacity)
 
 	up_write(&zram->init_lock);
 
-	/* Free all pages that are still in this zram device */
-	for (index = 0; index < zram->disksize >> PAGE_SHIFT; index++) {
-		unsigned long handle = meta->table[index].handle;
-
-		if (!handle)
-			continue;
-
-		zs_free(meta->mem_pool, handle);
-	}
-
 	zcomp_destroy(comp);
 	zram_meta_free(meta);
 
diff --git a/drivers/block/zram/zram_drv.h b/drivers/block/zram/zram_drv.h
index b05a816..e492f6b 100644
--- a/drivers/block/zram/zram_drv.h
+++ b/drivers/block/zram/zram_drv.h
@@ -96,6 +96,7 @@ struct zram_stats {
 struct zram_meta {
 	struct zram_table_entry *table;
 	struct zs_pool *mem_pool;
+	size_t num_pages;
 };
 
 struct zram {
-- 
1.7.9.5

