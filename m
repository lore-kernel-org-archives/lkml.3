Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936Ab3JNKN1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 06:13:27 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:50163 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787Ab3JNKNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 06:13:25 -0400
X-AuditID: cbfee61a-b7f7a6d00000235f-34-525bc3c381be
From: Weijie Yang <weijie.yang@samsung.com>
To: akpm@linux-foundation.org
Cc: sjenning@linux.vnet.ibm.com, sjennings@variantweb.net,
        "'Minchan Kim'" <minchan@kernel.org>, bob.liu@oracle.com,
        weijie.yang.kh@gmail.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, stable@vger.kernel.org
Subject: [PATCH 2/2] mm/zswap: refoctor the get/put routines
Date: Mon, 14 Oct 2013 18:12:34 +0800
Message-id: <000101cec8c6$01b10020$05130060$%yang@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac7IxccyjWXUKTCqROyKNUAvCVYonA==
Content-language: zh-cn
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLLMWRmVeSWpSXmKPExsVy+t9jAd3Dh6ODDB6+kLaYs34Nm0XXqaks
	Fpd3zWGzuLfmP6vFsq/v2S0O7VvFbvHp6CM2iwUbHzFaPDnxn8WB02PnrLvsHptWdbJ5bPo0
	id3jxIzfLB4PDm1m8fj49BaLx/VvRR6fN8kFcERx2aSk5mSWpRbp2yVwZXR8WMhWcN2j4twf
	1QbGU1ZdjJwcEgImEr+72lghbDGJC/fWs3UxcnEICSxilDjwfDILhPOHUeJ+yy1GkCo2AW2J
	u/0bwTpEBGQlpv49D1bELHCbUWLG9/9MIAlhARuJLQ9XsYPYLAKqElv3vQVr4BWwk3i+eykz
	hC0o8WPyPaBmDqBmdYkpU3JBwswC8hKb17xlBglLAIUf/dWFWKUn8fz0VUaIEnGJjUdusUxg
	FJiFZNAshEGzkAyahaRjASPLKkbR1ILkguKk9FxDveLE3OLSvHS95PzcTYzgSHkmtYNxZYPF
	IUYBDkYlHl4Bp+ggIdbEsuLK3EOMEhzMSiK8gvOAQrwpiZVVqUX58UWlOanFhxilOViUxHkP
	tFoHCgmkJ5akZqemFqQWwWSZODilGhhNL+rVSoRk1sddX6/iO52dyX9qZklxpqX566vPdazi
	PCtXCFm5aGdwxQafCT9fbpYxY6vY8Qp9R8/J5a2h7cVSks+fps3v5F/zUCT56z2DtOa3ck6T
	tuoL5J/Ik7ugki372LnI+deksuW+iTptZ3eu5NujzjQrpf/pqdWzO4VMWr/PTpp9QImlOCPR
	UIu5qDgRAPTmKBSQAgAA
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
---
 mm/zswap.c |  176 +++++++++++++++++++++++++++++-------------------------------
 1 file changed, 85 insertions(+), 91 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index f25394a..986563c 100755
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
@@ -285,6 +273,59 @@ static int zswap_rb_insert(struct rb_root *root, struct zswap_entry *entry,
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
+static void zswap_free_entry(struct zswap_tree *tree, struct zswap_entry *entry)
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
+static void zswap_entry_put(struct zswap_tree *tree, struct zswap_entry *entry)
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
+							pgoff_t offset)
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
@@ -368,18 +409,6 @@ static bool zswap_is_full(void)
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
@@ -503,7 +532,7 @@ static int zswap_writeback_entry(struct zbud_pool *pool, unsigned long handle)
 	struct page *page;
 	u8 *src, *dst;
 	unsigned int dlen;
-	int ret, refcount;
+	int ret;
 	struct writeback_control wbc = {
 		.sync_mode = WB_SYNC_NONE,
 	};
@@ -518,13 +547,12 @@ static int zswap_writeback_entry(struct zbud_pool *pool, unsigned long handle)
 
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
 
@@ -563,42 +591,34 @@ static int zswap_writeback_entry(struct zbud_pool *pool, unsigned long handle)
 	zswap_written_back_pages++;
 
 	spin_lock(&tree->lock);
-
 	/* drop local reference */
-	zswap_entry_put(entry);
-	/* drop the initial reference from entry creation */
-	refcount = zswap_entry_put(entry);
-
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
+	*  to handle (1), search the tree and free the entry
+	*/
+	 if (entry == zswap_rb_search(&tree->rbroot, offset))
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
 
@@ -682,11 +702,8 @@ static int zswap_frontswap_store(unsigned type, pgoff_t offset,
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
@@ -715,17 +732,16 @@ static int zswap_frontswap_load(unsigned type, pgoff_t offset,
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
@@ -740,22 +756,9 @@ static int zswap_frontswap_load(unsigned type, pgoff_t offset,
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
 
@@ -764,7 +767,6 @@ static void zswap_frontswap_invalidate_page(unsigned type, pgoff_t offset)
 {
 	struct zswap_tree *tree = zswap_trees[type];
 	struct zswap_entry *entry;
-	int refcount;
 
 	/* find */
 	spin_lock(&tree->lock);
@@ -776,20 +778,12 @@ static void zswap_frontswap_invalidate_page(unsigned type, pgoff_t offset)
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
@@ -815,7 +809,7 @@ static void zswap_frontswap_invalidate_area(unsigned type)
 	 */
 	while ((node = rb_first(&tree->rbroot))) {
 		entry = rb_entry(node, struct zswap_entry, rbnode);
-		rb_erase(&entry->rbnode, &tree->rbroot);
+		zswap_rb_erase(&tree->rbroot, entry);
 		zbud_free(tree->pool, entry->handle);
 		zswap_entry_cache_free(entry);
 		atomic_dec(&zswap_stored_pages);
-- 
1.7.10.4

