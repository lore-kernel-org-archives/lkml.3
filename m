Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846AbaFBWUg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 18:20:36 -0400
Received: from mail-yk0-f177.google.com ([209.85.160.177]:33576 "EHLO
	mail-yk0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbaFBWU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 18:20:29 -0400
From: Dan Streetman <ddstreet@ieee.org>
To: Seth Jennings <sjennings@variantweb.net>, Minchan Kim <minchan@kernel.org>,
        Weijie Yang <weijie.yang@samsung.com>, Nitin Gupta <ngupta@vflare.org>
Cc: Dan Streetman <ddstreet@ieee.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Bob Liu <bob.liu@oracle.com>, Hugh Dickins <hughd@google.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Linux-MM <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCHv2 4/6] mm/zpool: zbud/zsmalloc implement zpool
Date: Mon,  2 Jun 2014 18:19:44 -0400
Message-Id: <1401747586-11861-5-git-send-email-ddstreet@ieee.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1401747586-11861-1-git-send-email-ddstreet@ieee.org>
References: <1400958369-3588-1-git-send-email-ddstreet@ieee.org>
 <1401747586-11861-1-git-send-email-ddstreet@ieee.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update zbud and zsmalloc to implement the zpool api.

Signed-off-by: Dan Streetman <ddstreet@ieee.org>
Cc: Seth Jennings <sjennings@variantweb.net>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Weijie Yang <weijie.yang@samsung.com>
---

Note to Seth: We talked about removing the retries parameter from
zbud_reclaim_page(), but I did not include that in this patch.
I'll send a separate patch for that.

Changes since v1 : https://lkml.org/lkml/2014/5/24/136
  -Update zbud_zpool_shrink() to call zbud_reclaim_page()
   in a loop until number of pages requested has been
   reclaimed, or error
  -Update zbud_zpool_shrink() to update passed *reclaimed
   param with # pages actually reclaimed
  -Update zs_pool_shrink() with new param, although function
   is not implemented yet

 mm/zbud.c     | 92 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 mm/zsmalloc.c | 82 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 174 insertions(+)

diff --git a/mm/zbud.c b/mm/zbud.c
index dd13665..645379e 100644
--- a/mm/zbud.c
+++ b/mm/zbud.c
@@ -51,6 +51,7 @@
 #include <linux/slab.h>
 #include <linux/spinlock.h>
 #include <linux/zbud.h>
+#include <linux/zpool.h>
 
 /*****************
  * Structures
@@ -114,6 +115,88 @@ struct zbud_header {
 };
 
 /*****************
+ * zpool
+ ****************/
+
+#ifdef CONFIG_ZPOOL
+
+static int zbud_zpool_evict(struct zbud_pool *pool, unsigned long handle)
+{
+	return zpool_evict(pool, handle);
+}
+
+static struct zbud_ops zbud_zpool_ops = {
+	.evict =	zbud_zpool_evict
+};
+
+static void *zbud_zpool_create(gfp_t gfp, struct zpool_ops *zpool_ops)
+{
+	return zbud_create_pool(gfp, &zbud_zpool_ops);
+}
+
+void zbud_zpool_destroy(void *pool)
+{
+	zbud_destroy_pool(pool);
+}
+
+int zbud_zpool_malloc(void *pool, size_t size, unsigned long *handle)
+{
+	return zbud_alloc(pool, size, handle);
+}
+void zbud_zpool_free(void *pool, unsigned long handle)
+{
+	zbud_free(pool, handle);
+}
+
+int zbud_zpool_shrink(void *pool, unsigned int pages,
+			unsigned int *reclaimed)
+{
+	unsigned int total = 0;
+	int ret = -EINVAL;
+
+	while (total < pages) {
+		ret = zbud_reclaim_page(pool, 8);
+		if (ret < 0)
+			break;
+		total++;
+	}
+
+	if (reclaimed)
+		*reclaimed = total;
+
+	return ret;
+}
+
+void *zbud_zpool_map(void *pool, unsigned long handle,
+			enum zpool_mapmode mm)
+{
+	return zbud_map(pool, handle);
+}
+void zbud_zpool_unmap(void *pool, unsigned long handle)
+{
+	zbud_unmap(pool, handle);
+}
+
+u64 zbud_zpool_total_size(void *pool)
+{
+	return zbud_get_pool_size(pool) * PAGE_SIZE;
+}
+
+static struct zpool_driver zbud_zpool_driver = {
+	.type =		"zbud",
+	.create =	zbud_zpool_create,
+	.destroy =	zbud_zpool_destroy,
+	.malloc =	zbud_zpool_malloc,
+	.free =		zbud_zpool_free,
+	.shrink =	zbud_zpool_shrink,
+	.map =		zbud_zpool_map,
+	.unmap =	zbud_zpool_unmap,
+	.total_size =	zbud_zpool_total_size,
+};
+
+#endif /* CONFIG_ZPOOL */
+
+/*****************
  * Helpers
 *****************/
 /* Just to make the code easier to read */
@@ -513,11 +596,20 @@ static int __init init_zbud(void)
 	/* Make sure the zbud header will fit in one chunk */
 	BUILD_BUG_ON(sizeof(struct zbud_header) > ZHDR_SIZE_ALIGNED);
 	pr_info("loaded\n");
+
+#ifdef CONFIG_ZPOOL
+	zpool_register_driver(&zbud_zpool_driver);
+#endif
+
 	return 0;
 }
 
 static void __exit exit_zbud(void)
 {
+#ifdef CONFIG_ZPOOL
+	zpool_unregister_driver(&zbud_zpool_driver);
+#endif
+
 	pr_info("unloaded\n");
 }
 
diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index fe78189..feba644 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -92,6 +92,7 @@
 #include <linux/spinlock.h>
 #include <linux/types.h>
 #include <linux/zsmalloc.h>
+#include <linux/zpool.h>
 
 /*
  * This must be power of 2 and greater than of equal to sizeof(link_free).
@@ -240,6 +241,79 @@ struct mapping_area {
 	enum zs_mapmode vm_mm; /* mapping mode */
 };
 
+/* zpool driver */
+
+#ifdef CONFIG_ZPOOL
+
+static void *zs_zpool_create(gfp_t gfp, struct zpool_ops *zpool_ops)
+{
+	return zs_create_pool(gfp);
+}
+
+void zs_zpool_destroy(void *pool)
+{
+	zs_destroy_pool(pool);
+}
+
+int zs_zpool_malloc(void *pool, size_t size, unsigned long *handle)
+{
+	*handle = zs_malloc(pool, size);
+	return *handle ? 0 : -1;
+}
+void zs_zpool_free(void *pool, unsigned long handle)
+{
+	zs_free(pool, handle);
+}
+
+int zs_zpool_shrink(void *pool, unsigned int pages,
+			unsigned int *reclaimed)
+{
+	return -EINVAL;
+}
+
+void *zs_zpool_map(void *pool, unsigned long handle,
+			enum zpool_mapmode mm)
+{
+	enum zs_mapmode zs_mm;
+
+	switch (mm) {
+	case ZPOOL_MM_RO:
+		zs_mm = ZS_MM_RO;
+		break;
+	case ZPOOL_MM_WO:
+		zs_mm = ZS_MM_WO;
+		break;
+	case ZPOOL_MM_RW: /* fallthru */
+	default:
+		zs_mm = ZS_MM_RW;
+		break;
+	}
+
+	return zs_map_object(pool, handle, zs_mm);
+}
+void zs_zpool_unmap(void *pool, unsigned long handle)
+{
+	zs_unmap_object(pool, handle);
+}
+
+u64 zs_zpool_total_size(void *pool)
+{
+	return zs_get_total_size_bytes(pool);
+}
+
+static struct zpool_driver zs_zpool_driver = {
+	.type =		"zsmalloc",
+	.create =	zs_zpool_create,
+	.destroy =	zs_zpool_destroy,
+	.malloc =	zs_zpool_malloc,
+	.free =		zs_zpool_free,
+	.shrink =	zs_zpool_shrink,
+	.map =		zs_zpool_map,
+	.unmap =	zs_zpool_unmap,
+	.total_size =	zs_zpool_total_size,
+};
+
+#endif /* CONFIG_ZPOOL */
 
 /* per-cpu VM mapping areas for zspage accesses that cross page boundaries */
 static DEFINE_PER_CPU(struct mapping_area, zs_map_area);
@@ -814,6 +888,10 @@ static void zs_exit(void)
 {
 	int cpu;
 
+#ifdef CONFIG_ZPOOL
+	zpool_unregister_driver(&zs_zpool_driver);
+#endif
+
 	cpu_notifier_register_begin();
 
 	for_each_online_cpu(cpu)
@@ -840,6 +918,10 @@ static int zs_init(void)
 
 	cpu_notifier_register_done();
 
+#ifdef CONFIG_ZPOOL
+	zpool_register_driver(&zs_zpool_driver);
+#endif
+
 	return 0;
 fail:
 	zs_exit();
-- 
1.8.3.1

