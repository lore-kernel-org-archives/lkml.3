Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804Ab3JXJyS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 05:54:18 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:25433 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124Ab3JXJyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 05:54:15 -0400
X-AuditID: cbfee61b-b7fd56d000001fc6-e3-5268ee455f17
From: Weijie Yang <weijie.yang@samsung.com>
To: akpm@linux-foundation.org
Cc: sjennings@variantweb.net, "'Minchan Kim'" <minchan@kernel.org>,
        bob.liu@oracle.com, weijie.yang.kh@gmail.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH RESEND 2/2] mm/zswap: refoctor the get/put routines
Date: Thu, 24 Oct 2013 17:53:32 +0800
Message-id: <000101ced09e$fed90a10$fc8b1e30$%yang@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7QnqIuK2LUGrHvRXiF3/Zj6FcWiQ==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrCLMWRmVeSWpSXmKPExsVy+t9jAV3XdxlBBnfuW1vMWb+GzaLr1FQW
	i8u75rBZ3Fvzn9Vi2df37Bafjj5is1iw8RGjxZMT/1kcODx2zrrL7rFpVSebx6ZPk9g9Tsz4
	zeLx8ektFo/r34o8Pm+SC2CP4rJJSc3JLEst0rdL4Mr4vmMJS8FFr4p3z68xNzDOs+li5OSQ
	EDCRuLhtPROELSZx4d56ti5GLg4hgUWMEl/WtkI5fxglXh05zApSxSagLXG3fyOYLSIgKzH1
	73kWkCJmgT2MEhvetICNEhZwlmh4d4gNxGYRUJVYv3YzI4jNK2AnsffVeihbUOLH5HtAzRxA
	zeoSU6bkgoSZBeQlNq95ywwSlgAKP/qrC7FKT+LPq9ssECXiEhuP3GKZwCgwC8mgWQiDZiEZ
	NAtJxwJGllWMoqkFyQXFSem5RnrFibnFpXnpesn5uZsYwXHxTHoH46oGi0OMAhyMSjy8Gh/S
	g4RYE8uKK3MPMUpwMCuJ8HpWZAQJ8aYkVlalFuXHF5XmpBYfYpTmYFES5z3Yah0oJJCeWJKa
	nZpakFoEk2Xi4JRqYOxZmd31LnLa9Oe78kQiw7YqcH7fmnhA8ySX8NRtxx9v2nGzInThmg9S
	Bd4Pn0U17Ey0/Oda+upR0wGlFQmHP4oUnhU+7BZ+/77oC40pbgrbj8uz187gumW945uP49cn
	f46xa//7nNEpc7DKguvUf52JczpOR13rTo077X22+/gZYe3nod0hzwOUWIozEg21mIuKEwF4
	pdWwhwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The refcount routine was not fit the kernel get/put semantic exactly,
There were too many judgement statements on refcount and it could be minus.

This patch does the following:

- move refcount judgement to zswap_entry_put() to hide resource free function.

- add a new function zswap_entry_find_get(), so that callers can use easily
in the following pattern:

   zswap_entry_find_get
   .../* do something */
   zswap_entry_put

- to eliminate compile error, move some functions declaration

This patch is based on Minchan Kim <minchan@kernel.org> 's idea and suggestion.

Signed-off-by: Weijie Yang <weijie.yang@samsung.com>
Cc: Seth Jennings <sjennings@variantweb.net>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Bob Liu <bob.liu@oracle.com>
---
 mm/zswap.c |  182 +++++++++++++++++++++++++++++-------------------------------
 1 file changed, 88 insertions(+), 94 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index 6b86251..1c12e33 100755
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -217,6 +217,7 @@ static struct zswap_entry *zswap_entry_cache_alloc(gfp_t gfp)
 	if (!entry)
 		return NULL;
 	entry->refcount = 1;
+	RB_CLEAR_NODE(&entry->rbnode);
 	return entry;
 }
 
@@ -225,19 +226,6 @@ static void zswap_entry_cache_free(struct zswap_entry *entry)
 	kmem_cache_free(zswap_entry_cache, entry);
 }
 
-/* caller must hold the tree lock */
-static void zswap_entry_get(struct zswap_entry *entry)
-{
-	entry->refcount++;
-}
-
-/* caller must hold the tree lock */
-static int zswap_entry_put(struct zswap_entry *entry)
-{
-	entry->refcount--;
-	return entry->refcount;
-}
-
 /*********************************
 * rbtree functions
 **********************************/
@@ -285,6 +273,61 @@ static int zswap_rb_insert(struct rb_root *root, struct zswap_entry *entry,
 	return 0;
 }
 
+static void zswap_rb_erase(struct rb_root *root, struct zswap_entry *entry)
+{
+	if (!RB_EMPTY_NODE(&entry->rbnode)) {
+		rb_erase(&entry->rbnode, root);
+		RB_CLEAR_NODE(&entry->rbnode);
+	}
+}
+
+/*
+ * Carries out the common pattern of freeing and entry's zsmalloc allocation,
+ * freeing the entry itself, and decrementing the number of stored pages.
+ */
+static void zswap_free_entry(struct zswap_tree *tree,
+			struct zswap_entry *entry)
+{
+	zbud_free(tree->pool, entry->handle);
+	zswap_entry_cache_free(entry);
+	atomic_dec(&zswap_stored_pages);
+	zswap_pool_pages = zbud_get_pool_size(tree->pool);
+}
+
+/* caller must hold the tree lock */
+static void zswap_entry_get(struct zswap_entry *entry)
+{
+	entry->refcount++;
+}
+
+/* caller must hold the tree lock
+* remove from the tree and free it, if nobody reference the entry
+*/
+static void zswap_entry_put(struct zswap_tree *tree,
+			struct zswap_entry *entry)
+{
+	int refcount = --entry->refcount;
+
+	BUG_ON(refcount < 0);
+	if (refcount == 0) {
+		zswap_rb_erase(&tree->rbroot, entry);
+		zswap_free_entry(tree, entry);
+	}
+}
+
+/* caller must hold the tree lock */
+static struct zswap_entry *zswap_entry_find_get(struct rb_root *root,
+				pgoff_t offset)
+{
+	struct zswap_entry *entry = NULL;
+
+	entry = zswap_rb_search(root, offset);
+	if (entry)
+		zswap_entry_get(entry);
+
+	return entry;
+}
+
 /*********************************
 * per-cpu code
 **********************************/
@@ -368,18 +411,6 @@ static bool zswap_is_full(void)
 		zswap_pool_pages);
 }
 
-/*
- * Carries out the common pattern of freeing and entry's zsmalloc allocation,
- * freeing the entry itself, and decrementing the number of stored pages.
- */
-static void zswap_free_entry(struct zswap_tree *tree, struct zswap_entry *entry)
-{
-	zbud_free(tree->pool, entry->handle);
-	zswap_entry_cache_free(entry);
-	atomic_dec(&zswap_stored_pages);
-	zswap_pool_pages = zbud_get_pool_size(tree->pool);
-}
-
 /*********************************
 * writeback code
 **********************************/
@@ -503,7 +534,7 @@ static int zswap_writeback_entry(struct zbud_pool *pool, unsigned long handle)
 	struct page *page;
 	u8 *src, *dst;
 	unsigned int dlen;
-	int ret, refcount;
+	int ret;
 	struct writeback_control wbc = {
 		.sync_mode = WB_SYNC_NONE,
 	};
@@ -518,13 +549,12 @@ static int zswap_writeback_entry(struct zbud_pool *pool, unsigned long handle)
 
 	/* find and ref zswap entry */
 	spin_lock(&tree->lock);
-	entry = zswap_rb_search(&tree->rbroot, offset);
+	entry = zswap_entry_find_get(&tree->rbroot, offset);
 	if (!entry) {
 		/* entry was invalidated */
 		spin_unlock(&tree->lock);
 		return 0;
 	}
-	zswap_entry_get(entry);
 	spin_unlock(&tree->lock);
 	BUG_ON(offset != entry->offset);
 
@@ -563,42 +593,35 @@ static int zswap_writeback_entry(struct zbud_pool *pool, unsigned long handle)
 	zswap_written_back_pages++;
 
 	spin_lock(&tree->lock);
-
 	/* drop local reference */
-	zswap_entry_put(entry);
-	/* drop the initial reference from entry creation */
-	refcount = zswap_entry_put(entry);
+	zswap_entry_put(tree, entry);
 
 	/*
-	 * There are three possible values for refcount here:
-	 * (1) refcount is 1, load is in progress, unlink from rbtree,
-	 *     load will free
-	 * (2) refcount is 0, (normal case) entry is valid,
-	 *     remove from rbtree and free entry
-	 * (3) refcount is -1, invalidate happened during writeback,
-	 *     free entry
-	 */
-	if (refcount >= 0) {
-		/* no invalidate yet, remove from rbtree */
-		rb_erase(&entry->rbnode, &tree->rbroot);
-	}
+	* There are two possible situations for entry here:
+	* (1) refcount is 1(normal case),  entry is valid and on the tree
+	* (2) refcount is 0, entry is freed and not on the tree
+	*     because invalidate happened during writeback
+	*  search the tree and free the entry if find entry
+	*/
+	if (entry == zswap_rb_search(&tree->rbroot, offset))
+		zswap_entry_put(tree, entry);
 	spin_unlock(&tree->lock);
-	if (refcount <= 0) {
-		/* free the entry */
-		zswap_free_entry(tree, entry);
-		return 0;
-	}
-	return -EAGAIN;
 
+	goto end;
+
+	/*
+	* if we get here due to ZSWAP_SWAPCACHE_EXIST
+	* a load may happening concurrently
+	* it is safe and okay to not free the entry
+	* if we free the entry in the following put
+	* it it either okay to return !0
+	*/
 fail:
 	spin_lock(&tree->lock);
-	refcount = zswap_entry_put(entry);
-	if (refcount <= 0) {
-		/* invalidate happened, consider writeback as success */
-		zswap_free_entry(tree, entry);
-		ret = 0;
-	}
+	zswap_entry_put(tree, entry);
 	spin_unlock(&tree->lock);
+
+end:
 	return ret;
 }
 
@@ -682,11 +705,8 @@ static int zswap_frontswap_store(unsigned type, pgoff_t offset,
 		if (ret == -EEXIST) {
 			zswap_duplicate_entry++;
 			/* remove from rbtree */
-			rb_erase(&dupentry->rbnode, &tree->rbroot);
-			if (!zswap_entry_put(dupentry)) {
-				/* free */
-				zswap_free_entry(tree, dupentry);
-			}
+			zswap_rb_erase(&tree->rbroot, dupentry);
+			zswap_entry_put(tree, dupentry);
 		}
 	} while (ret == -EEXIST);
 	spin_unlock(&tree->lock);
@@ -715,17 +735,16 @@ static int zswap_frontswap_load(unsigned type, pgoff_t offset,
 	struct zswap_entry *entry;
 	u8 *src, *dst;
 	unsigned int dlen;
-	int refcount, ret;
+	int ret;
 
 	/* find */
 	spin_lock(&tree->lock);
-	entry = zswap_rb_search(&tree->rbroot, offset);
+	entry = zswap_entry_find_get(&tree->rbroot, offset);
 	if (!entry) {
 		/* entry was written back */
 		spin_unlock(&tree->lock);
 		return -1;
 	}
-	zswap_entry_get(entry);
 	spin_unlock(&tree->lock);
 
 	/* decompress */
@@ -740,22 +759,9 @@ static int zswap_frontswap_load(unsigned type, pgoff_t offset,
 	BUG_ON(ret);
 
 	spin_lock(&tree->lock);
-	refcount = zswap_entry_put(entry);
-	if (likely(refcount)) {
-		spin_unlock(&tree->lock);
-		return 0;
-	}
+	zswap_entry_put(tree, entry);
 	spin_unlock(&tree->lock);
 
-	/*
-	 * We don't have to unlink from the rbtree because
-	 * zswap_writeback_entry() or zswap_frontswap_invalidate page()
-	 * has already done this for us if we are the last reference.
-	 */
-	/* free */
-
-	zswap_free_entry(tree, entry);
-
 	return 0;
 }
 
@@ -764,7 +770,6 @@ static void zswap_frontswap_invalidate_page(unsigned type, pgoff_t offset)
 {
 	struct zswap_tree *tree = zswap_trees[type];
 	struct zswap_entry *entry;
-	int refcount;
 
 	/* find */
 	spin_lock(&tree->lock);
@@ -776,20 +781,12 @@ static void zswap_frontswap_invalidate_page(unsigned type, pgoff_t offset)
 	}
 
 	/* remove from rbtree */
-	rb_erase(&entry->rbnode, &tree->rbroot);
+	zswap_rb_erase(&tree->rbroot, entry);
 
 	/* drop the initial reference from entry creation */
-	refcount = zswap_entry_put(entry);
+	zswap_entry_put(tree, entry);
 
 	spin_unlock(&tree->lock);
-
-	if (refcount) {
-		/* writeback in progress, writeback will free */
-		return;
-	}
-
-	/* free */
-	zswap_free_entry(tree, entry);
 }
 
 /* frees all zswap entries for the given swap type */
@@ -803,11 +800,8 @@ static void zswap_frontswap_invalidate_area(unsigned type)
 
 	/* walk the tree and free everything */
 	spin_lock(&tree->lock);
-	rbtree_postorder_for_each_entry_safe(entry, n, &tree->rbroot, rbnode) {
-		zbud_free(tree->pool, entry->handle);
-		zswap_entry_cache_free(entry);
-		atomic_dec(&zswap_stored_pages);
-	}
+	rbtree_postorder_for_each_entry_safe(entry, n, &tree->rbroot, rbnode)
+		zswap_free_entry(tree, entry);
 	tree->rbroot = RB_ROOT;
 	spin_unlock(&tree->lock);
 
-- 
1.7.10.4


