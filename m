Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932300AbaIKUzI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 16:55:08 -0400
Received: from mail-ig0-f169.google.com ([209.85.213.169]:38030 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932264AbaIKUzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 16:55:03 -0400
From: Dan Streetman <ddstreet@ieee.org>
To: Minchan Kim <minchan@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Seth Jennings <sjennings@variantweb.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Streetman <ddstreet@ieee.org>
Subject: [PATCH 06/10] zsmalloc: add zs_ops to zs_pool
Date: Thu, 11 Sep 2014 16:53:57 -0400
Message-Id: <1410468841-320-7-git-send-email-ddstreet@ieee.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1410468841-320-1-git-send-email-ddstreet@ieee.org>
References: <1410468841-320-1-git-send-email-ddstreet@ieee.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add struct zs_ops with a evict() callback function.  Add documentation
to zs_free() function clarifying that it cannot be called with a
zs_pool handle after that handle has been successfully evicted;
since evict calls into a function provided by the zs_pool creator,
the creator is therefore responsible for ensuring this requirement.

This is required to implement zsmalloc shrinking.

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
Cc: Minchan Kim <minchan@kernel.org>
---
 drivers/block/zram/zram_drv.c |  2 +-
 include/linux/zsmalloc.h      |  6 +++++-
 mm/zsmalloc.c                 | 26 ++++++++++++++++++++++++--
 3 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index bc20fe1..31ba9c7 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -328,7 +328,7 @@ static struct zram_meta *zram_meta_alloc(u64 disksize)
 		goto free_meta;
 	}
 
-	meta->mem_pool = zs_create_pool(GFP_NOIO | __GFP_HIGHMEM);
+	meta->mem_pool = zs_create_pool(GFP_NOIO | __GFP_HIGHMEM, NULL);
 	if (!meta->mem_pool) {
 		pr_err("Error creating memory pool\n");
 		goto free_table;
diff --git a/include/linux/zsmalloc.h b/include/linux/zsmalloc.h
index 05c2147..2c341d4 100644
--- a/include/linux/zsmalloc.h
+++ b/include/linux/zsmalloc.h
@@ -36,7 +36,11 @@ enum zs_mapmode {
 
 struct zs_pool;
 
-struct zs_pool *zs_create_pool(gfp_t flags);
+struct zs_ops {
+	int (*evict)(struct zs_pool *pool, unsigned long handle);
+};
+
+struct zs_pool *zs_create_pool(gfp_t flags, struct zs_ops *ops);
 void zs_destroy_pool(struct zs_pool *pool);
 
 unsigned long zs_malloc(struct zs_pool *pool, size_t size);
diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index a2e417b..3dc7dae 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -221,6 +221,8 @@ struct zs_pool {
 
 	gfp_t flags;	/* allocation flags used when growing pool */
 	atomic_long_t pages_allocated;
+
+	struct zs_ops *ops;
 };
 
 /*
@@ -256,9 +258,18 @@ static enum fullness_group lru_fg[] = {
 
 #ifdef CONFIG_ZPOOL
 
+static int zs_zpool_evict(struct zs_pool *pool, unsigned long handle)
+{
+	return zpool_evict(pool, handle);
+}
+
+static struct zs_ops zs_zpool_ops = {
+	.evict =	zs_zpool_evict
+};
+
 static void *zs_zpool_create(gfp_t gfp, struct zpool_ops *zpool_ops)
 {
-	return zs_create_pool(gfp);
+	return zs_create_pool(gfp, &zs_zpool_ops);
 }
 
 static void zs_zpool_destroy(void *pool)
@@ -1019,7 +1030,7 @@ fail:
  * On success, a pointer to the newly created pool is returned,
  * otherwise NULL.
  */
-struct zs_pool *zs_create_pool(gfp_t flags)
+struct zs_pool *zs_create_pool(gfp_t flags, struct zs_ops *ops)
 {
 	int i, ovhd_size;
 	struct zs_pool *pool;
@@ -1046,6 +1057,7 @@ struct zs_pool *zs_create_pool(gfp_t flags)
 	}
 
 	pool->flags = flags;
+	pool->ops = ops;
 
 	return pool;
 }
@@ -1130,6 +1142,16 @@ unsigned long zs_malloc(struct zs_pool *pool, size_t size)
 }
 EXPORT_SYMBOL_GPL(zs_malloc);
 
+/**
+ * zs_free - Free the handle from this pool.
+ * @pool: pool containing the handle
+ * @obj: the handle to free
+ *
+ * The caller must provide a valid handle that is contained
+ * in the provided pool.  The caller must ensure this is
+ * not called after evict() has returned successfully for the
+ * handle.
+ */
 void zs_free(struct zs_pool *pool, unsigned long obj)
 {
 	struct page *first_page, *f_page;
-- 
1.8.3.1

