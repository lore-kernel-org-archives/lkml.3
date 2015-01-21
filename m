Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535AbbAUGPN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 01:15:13 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:38763 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754180AbbAUGOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 01:14:38 -0500
X-Original-SENDERIP: 10.177.222.143
X-Original-MAILFROM: minchan@kernel.org
From: Minchan Kim <minchan@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Dan Streetman <ddstreet@ieee.org>,
        Seth Jennings <sjennings@variantweb.net>,
        Nitin Gupta <ngupta@vflare.org>, Juneho Choi <juno.choi@lge.com>,
        Gunho Lee <gunho.lee@lge.com>, Luigi Semenzato <semenzato@google.com>,
        Jerome Marchand <jmarchan@redhat.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Minchan Kim <minchan@kernel.org>
Subject: [PATCH v1 09/10] zsmalloc: add fullness into stat
Date: Wed, 21 Jan 2015 15:14:25 +0900
Message-Id: <1421820866-26521-10-git-send-email-minchan@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1421820866-26521-1-git-send-email-minchan@kernel.org>
References: <1421820866-26521-1-git-send-email-minchan@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During investigating compaction, fullness information of each class
and pages_per_zspage are helpful for investigating how compaction
works well on each size class.

Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 mm/zsmalloc.c | 349 +++++++++++++++++++++++++++++++---------------------------
 1 file changed, 184 insertions(+), 165 deletions(-)

diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
index 8217e8e..48b702e 100644
--- a/mm/zsmalloc.c
+++ b/mm/zsmalloc.c
@@ -192,6 +192,8 @@ enum fullness_group {
 enum zs_stat_type {
 	OBJ_ALLOCATED,
 	OBJ_USED,
+	CLASS_ALMOST_FULL,
+	CLASS_ALMOST_EMPTY,
 	NR_ZS_STAT_TYPE,
 };
 
@@ -404,6 +406,11 @@ static struct zpool_driver zs_zpool_driver = {
 MODULE_ALIAS("zpool-zsmalloc");
 #endif /* CONFIG_ZPOOL */
 
+static unsigned int get_maxobj_per_zspage(int size, int pages_per_zspage)
+{
+	return pages_per_zspage * PAGE_SIZE / size;
+}
+
 /* per-cpu VM mapping areas for zspage accesses that cross page boundaries */
 static DEFINE_PER_CPU(struct mapping_area, zs_map_area);
 
@@ -457,6 +464,179 @@ static int get_size_class_index(int size)
 	return idx;
 }
 
+#ifdef CONFIG_ZSMALLOC_STAT
+
+static inline void zs_stat_inc(struct size_class *class,
+				enum zs_stat_type type, unsigned long cnt)
+{
+	class->stats.objs[type] += cnt;
+}
+
+static inline void zs_stat_dec(struct size_class *class,
+				enum zs_stat_type type, unsigned long cnt)
+{
+	class->stats.objs[type] -= cnt;
+}
+
+static inline unsigned long zs_stat_get(struct size_class *class,
+				enum zs_stat_type type)
+{
+	return class->stats.objs[type];
+}
+
+static int __init zs_stat_init(void)
+{
+	if (!debugfs_initialized())
+		return -ENODEV;
+
+	zs_stat_root = debugfs_create_dir("zsmalloc", NULL);
+	if (!zs_stat_root)
+		return -ENOMEM;
+
+	return 0;
+}
+
+static void __exit zs_stat_exit(void)
+{
+	debugfs_remove_recursive(zs_stat_root);
+}
+
+static int zs_stats_size_show(struct seq_file *s, void *v)
+{
+	int i;
+	struct zs_pool *pool = s->private;
+	struct size_class *class;
+	int objs_per_zspage;
+	unsigned long class_almost_full, class_almost_empty;
+	unsigned long obj_allocated, obj_used, pages_used;
+	unsigned long total_class_almost_full = 0, total_class_almost_empty = 0;
+	unsigned long total_objs = 0, total_used_objs = 0, total_pages = 0;
+
+	seq_printf(s, " %5s %5s %11s %12s %13s %10s %10s %16s\n",
+			"class", "size", "almost_full", "almost_empty",
+			"obj_allocated", "obj_used", "pages_used",
+			"pages_per_zspage");
+
+	for (i = 0; i < zs_size_classes; i++) {
+		class = pool->size_class[i];
+
+		if (class->index != i)
+			continue;
+
+		spin_lock(&class->lock);
+		class_almost_full = zs_stat_get(class, CLASS_ALMOST_FULL);
+		class_almost_empty = zs_stat_get(class, CLASS_ALMOST_EMPTY);
+		obj_allocated = zs_stat_get(class, OBJ_ALLOCATED);
+		obj_used = zs_stat_get(class, OBJ_USED);
+		spin_unlock(&class->lock);
+
+		objs_per_zspage = get_maxobj_per_zspage(class->size,
+				class->pages_per_zspage);
+		pages_used = obj_allocated / objs_per_zspage *
+				class->pages_per_zspage;
+
+		seq_printf(s, " %5u %5u %11lu %12lu %13lu %10lu %10lu %16d\n",
+			i, class->size, class_almost_full, class_almost_empty,
+			obj_allocated, obj_used, pages_used,
+			class->pages_per_zspage);
+
+		total_class_almost_full += class_almost_full;
+		total_class_almost_empty += class_almost_empty;
+		total_objs += obj_allocated;
+		total_used_objs += obj_used;
+		total_pages += pages_used;
+	}
+
+	seq_puts(s, "\n");
+	seq_printf(s, " %5s %5s %11lu %12lu %13lu %10lu %10lu\n",
+			"Total", "", total_class_almost_full,
+			total_class_almost_empty, total_objs,
+			total_used_objs, total_pages);
+
+	return 0;
+}
+
+static int zs_stats_size_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, zs_stats_size_show, inode->i_private);
+}
+
+static const struct file_operations zs_stat_size_ops = {
+	.open           = zs_stats_size_open,
+	.read           = seq_read,
+	.llseek         = seq_lseek,
+	.release        = single_release,
+};
+
+static int zs_pool_stat_create(char *name, struct zs_pool *pool)
+{
+	struct dentry *entry;
+
+	if (!zs_stat_root)
+		return -ENODEV;
+
+	entry = debugfs_create_dir(name, zs_stat_root);
+	if (!entry) {
+		pr_warn("debugfs dir <%s> creation failed\n", name);
+		return -ENOMEM;
+	}
+	pool->stat_dentry = entry;
+
+	entry = debugfs_create_file("classes", S_IFREG | S_IRUGO,
+			pool->stat_dentry, pool, &zs_stat_size_ops);
+	if (!entry) {
+		pr_warn("%s: debugfs file entry <%s> creation failed\n",
+				name, "classes");
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+static void zs_pool_stat_destroy(struct zs_pool *pool)
+{
+	debugfs_remove_recursive(pool->stat_dentry);
+}
+
+#else /* CONFIG_ZSMALLOC_STAT */
+
+static inline void zs_stat_inc(struct size_class *class,
+				enum zs_stat_type type, unsigned long cnt)
+{
+}
+
+static inline void zs_stat_dec(struct size_class *class,
+				enum zs_stat_type type, unsigned long cnt)
+{
+}
+
+static inline unsigned long zs_stat_get(struct size_class *class,
+				enum zs_stat_type type)
+{
+	return 0;
+}
+
+static int __init zs_stat_init(void)
+{
+	return 0;
+}
+
+static void __exit zs_stat_exit(void)
+{
+}
+
+static inline int zs_pool_stat_create(char *name, struct zs_pool *pool)
+{
+	return 0;
+}
+
+static inline void zs_pool_stat_destroy(struct zs_pool *pool)
+{
+}
+
+#endif
+
+
 /*
  * For each size class, zspages are divided into different groups
  * depending on how "full" they are. This was done so that we could
@@ -506,6 +686,8 @@ static void insert_zspage(struct page *page, struct size_class *class,
 		list_add_tail(&page->lru, &(*head)->lru);
 
 	*head = page;
+	zs_stat_inc(class, fullness == ZS_ALMOST_EMPTY ?
+			CLASS_ALMOST_EMPTY : CLASS_ALMOST_FULL, 1);
 }
 
 /*
@@ -531,6 +713,8 @@ static void remove_zspage(struct page *page, struct size_class *class,
 					struct page, lru);
 
 	list_del_init(&page->lru);
+	zs_stat_dec(class, fullness == ZS_ALMOST_EMPTY ?
+			CLASS_ALMOST_EMPTY : CLASS_ALMOST_FULL, 1);
 }
 
 /*
@@ -1032,11 +1216,6 @@ static void init_zs_size_classes(void)
 	zs_size_classes = nr;
 }
 
-static unsigned int get_maxobj_per_zspage(int size, int pages_per_zspage)
-{
-	return pages_per_zspage * PAGE_SIZE / size;
-}
-
 static bool can_merge(struct size_class *prev, int size, int pages_per_zspage)
 {
 	if (prev->pages_per_zspage != pages_per_zspage)
@@ -1056,166 +1235,6 @@ static bool zspage_full(struct page *page)
 	return page->inuse == page->objects;
 }
 
-#ifdef CONFIG_ZSMALLOC_STAT
-
-static inline void zs_stat_inc(struct size_class *class,
-				enum zs_stat_type type, unsigned long cnt)
-{
-	class->stats.objs[type] += cnt;
-}
-
-static inline void zs_stat_dec(struct size_class *class,
-				enum zs_stat_type type, unsigned long cnt)
-{
-	class->stats.objs[type] -= cnt;
-}
-
-static inline unsigned long zs_stat_get(struct size_class *class,
-				enum zs_stat_type type)
-{
-	return class->stats.objs[type];
-}
-
-static int __init zs_stat_init(void)
-{
-	if (!debugfs_initialized())
-		return -ENODEV;
-
-	zs_stat_root = debugfs_create_dir("zsmalloc", NULL);
-	if (!zs_stat_root)
-		return -ENOMEM;
-
-	return 0;
-}
-
-static void __exit zs_stat_exit(void)
-{
-	debugfs_remove_recursive(zs_stat_root);
-}
-
-static int zs_stats_size_show(struct seq_file *s, void *v)
-{
-	int i;
-	struct zs_pool *pool = s->private;
-	struct size_class *class;
-	int objs_per_zspage;
-	unsigned long obj_allocated, obj_used, pages_used;
-	unsigned long total_objs = 0, total_used_objs = 0, total_pages = 0;
-
-	seq_printf(s, " %5s %5s %13s %10s %10s\n", "class", "size",
-				"obj_allocated", "obj_used", "pages_used");
-
-	for (i = 0; i < zs_size_classes; i++) {
-		class = pool->size_class[i];
-
-		if (class->index != i)
-			continue;
-
-		spin_lock(&class->lock);
-		obj_allocated = zs_stat_get(class, OBJ_ALLOCATED);
-		obj_used = zs_stat_get(class, OBJ_USED);
-		spin_unlock(&class->lock);
-
-		objs_per_zspage = get_maxobj_per_zspage(class->size,
-				class->pages_per_zspage);
-		pages_used = obj_allocated / objs_per_zspage *
-				class->pages_per_zspage;
-
-		seq_printf(s, " %5u %5u    %10lu %10lu %10lu\n", i,
-			class->size, obj_allocated, obj_used, pages_used);
-
-		total_objs += obj_allocated;
-		total_used_objs += obj_used;
-		total_pages += pages_used;
-	}
-
-	seq_puts(s, "\n");
-	seq_printf(s, " %5s %5s    %10lu %10lu %10lu\n", "Total", "",
-			total_objs, total_used_objs, total_pages);
-
-	return 0;
-}
-
-static int zs_stats_size_open(struct inode *inode, struct file *file)
-{
-	return single_open(file, zs_stats_size_show, inode->i_private);
-}
-
-static const struct file_operations zs_stat_size_ops = {
-	.open           = zs_stats_size_open,
-	.read           = seq_read,
-	.llseek         = seq_lseek,
-	.release        = single_release,
-};
-
-static int zs_pool_stat_create(char *name, struct zs_pool *pool)
-{
-	struct dentry *entry;
-
-	if (!zs_stat_root)
-		return -ENODEV;
-
-	entry = debugfs_create_dir(name, zs_stat_root);
-	if (!entry) {
-		pr_warn("debugfs dir <%s> creation failed\n", name);
-		return -ENOMEM;
-	}
-	pool->stat_dentry = entry;
-
-	entry = debugfs_create_file("obj_in_classes", S_IFREG | S_IRUGO,
-			pool->stat_dentry, pool, &zs_stat_size_ops);
-	if (!entry) {
-		pr_warn("%s: debugfs file entry <%s> creation failed\n",
-				name, "obj_in_classes");
-		return -ENOMEM;
-	}
-
-	return 0;
-}
-
-static void zs_pool_stat_destroy(struct zs_pool *pool)
-{
-	debugfs_remove_recursive(pool->stat_dentry);
-}
-
-#else /* CONFIG_ZSMALLOC_STAT */
-
-static inline void zs_stat_inc(struct size_class *class,
-				enum zs_stat_type type, unsigned long cnt)
-{
-}
-
-static inline void zs_stat_dec(struct size_class *class,
-				enum zs_stat_type type, unsigned long cnt)
-{
-}
-
-static inline unsigned long zs_stat_get(struct size_class *class,
-				enum zs_stat_type type)
-{
-	return 0;
-}
-
-static int __init zs_stat_init(void)
-{
-	return 0;
-}
-
-static void __exit zs_stat_exit(void)
-{
-}
-
-static inline int zs_pool_stat_create(char *name, struct zs_pool *pool)
-{
-	return 0;
-}
-
-static inline void zs_pool_stat_destroy(struct zs_pool *pool)
-{
-}
-
-#endif
-
 unsigned long zs_get_total_pages(struct zs_pool *pool)
 {
 	return atomic_long_read(&pool->pages_allocated);
-- 
1.9.3

