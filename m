Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752826AbaEBQdK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 12:33:10 -0400
Received: from mailrelay004.isp.belgacom.be ([195.238.6.170]:46083 "EHLO
	mailrelay004.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752047AbaEBQdG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 12:33:06 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqgaAA3IY1NbsmU4/2dsb2JhbABagwarXwMBAQEBAQEEAZoBAgKBEBd0glMTHCMYgQIkE4hFAcpJhVaIfIRAAQOPFooZAZJvgzY7MA
Date: Fri, 2 May 2014 18:35:10 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        akpm <akpm@linux-foundation.org>
Subject: [PATCH 1/1] mm/zswap.c: add lock helper
Message-Id: <20140502183510.21ee4a06d787b3882e77faba@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

&tree->lock is used all over the place

Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 mm/zswap.c | 44 +++++++++++++++++++++++++-------------------
 1 file changed, 25 insertions(+), 19 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index aeaef0f..581f36f 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -532,6 +532,7 @@ static int zswap_writeback_entry(struct zbud_pool *pool, unsigned long handle)
 	struct zswap_tree *tree;
 	pgoff_t offset;
 	struct zswap_entry *entry;
+	spinlock_t *lock;
 	struct page *page;
 	u8 *src, *dst;
 	unsigned int dlen;
@@ -545,17 +546,18 @@ static int zswap_writeback_entry(struct zbud_pool *pool, unsigned long handle)
 	swpentry = zhdr->swpentry; /* here */
 	zbud_unmap(pool, handle);
 	tree = zswap_trees[swp_type(swpentry)];
+	lock = &tree->lock;
 	offset = swp_offset(swpentry);
 
 	/* find and ref zswap entry */
-	spin_lock(&tree->lock);
+	spin_lock(lock);
 	entry = zswap_entry_find_get(&tree->rbroot, offset);
 	if (!entry) {
 		/* entry was invalidated */
-		spin_unlock(&tree->lock);
+		spin_unlock(lock);
 		return 0;
 	}
-	spin_unlock(&tree->lock);
+	spin_unlock(lock);
 	BUG_ON(offset != entry->offset);
 
 	/* try to allocate swap cache page */
@@ -595,7 +597,7 @@ static int zswap_writeback_entry(struct zbud_pool *pool, unsigned long handle)
 	page_cache_release(page);
 	zswap_written_back_pages++;
 
-	spin_lock(&tree->lock);
+	spin_lock(lock);
 	/* drop local reference */
 	zswap_entry_put(tree, entry);
 
@@ -608,7 +610,7 @@ static int zswap_writeback_entry(struct zbud_pool *pool, unsigned long handle)
 	*/
 	if (entry == zswap_rb_search(&tree->rbroot, offset))
 		zswap_entry_put(tree, entry);
-	spin_unlock(&tree->lock);
+	spin_unlock(lock);
 
 	goto end;
 
@@ -620,9 +622,9 @@ static int zswap_writeback_entry(struct zbud_pool *pool, unsigned long handle)
 	* it it either okay to return !0
 	*/
 fail:
-	spin_lock(&tree->lock);
+	spin_lock(lock);
 	zswap_entry_put(tree, entry);
-	spin_unlock(&tree->lock);
+	spin_unlock(lock);
 
 end:
 	return ret;
@@ -637,6 +639,7 @@ static int zswap_frontswap_store(unsigned type, pgoff_t offset,
 {
 	struct zswap_tree *tree = zswap_trees[type];
 	struct zswap_entry *entry, *dupentry;
+	spinlock_t *lock = &tree->lock;
 	int ret;
 	unsigned int dlen = PAGE_SIZE, len;
 	unsigned long handle;
@@ -702,7 +705,7 @@ static int zswap_frontswap_store(unsigned type, pgoff_t offset,
 	entry->length = dlen;
 
 	/* map */
-	spin_lock(&tree->lock);
+	spin_lock(lock);
 	do {
 		ret = zswap_rb_insert(&tree->rbroot, entry, &dupentry);
 		if (ret == -EEXIST) {
@@ -712,7 +715,7 @@ static int zswap_frontswap_store(unsigned type, pgoff_t offset,
 			zswap_entry_put(tree, dupentry);
 		}
 	} while (ret == -EEXIST);
-	spin_unlock(&tree->lock);
+	spin_unlock(lock);
 
 	/* update stats */
 	atomic_inc(&zswap_stored_pages);
@@ -736,19 +739,20 @@ static int zswap_frontswap_load(unsigned type, pgoff_t offset,
 {
 	struct zswap_tree *tree = zswap_trees[type];
 	struct zswap_entry *entry;
+	spinlock_t *lock = &tree->lock;
 	u8 *src, *dst;
 	unsigned int dlen;
 	int ret;
 
 	/* find */
-	spin_lock(&tree->lock);
+	spin_lock(lock);
 	entry = zswap_entry_find_get(&tree->rbroot, offset);
 	if (!entry) {
 		/* entry was written back */
-		spin_unlock(&tree->lock);
+		spin_unlock(lock);
 		return -1;
 	}
-	spin_unlock(&tree->lock);
+	spin_unlock(lock);
 
 	/* decompress */
 	dlen = PAGE_SIZE;
@@ -761,9 +765,9 @@ static int zswap_frontswap_load(unsigned type, pgoff_t offset,
 	zbud_unmap(zswap_pool, entry->handle);
 	BUG_ON(ret);
 
-	spin_lock(&tree->lock);
+	spin_lock(lock);
 	zswap_entry_put(tree, entry);
-	spin_unlock(&tree->lock);
+	spin_unlock(lock);
 
 	return 0;
 }
@@ -773,13 +777,14 @@ static void zswap_frontswap_invalidate_page(unsigned type, pgoff_t offset)
 {
 	struct zswap_tree *tree = zswap_trees[type];
 	struct zswap_entry *entry;
+	spinlock_t *lock = &tree->lock;
 
 	/* find */
-	spin_lock(&tree->lock);
+	spin_lock(lock);
 	entry = zswap_rb_search(&tree->rbroot, offset);
 	if (!entry) {
 		/* entry was written back */
-		spin_unlock(&tree->lock);
+		spin_unlock(lock);
 		return;
 	}
 
@@ -789,7 +794,7 @@ static void zswap_frontswap_invalidate_page(unsigned type, pgoff_t offset)
 	/* drop the initial reference from entry creation */
 	zswap_entry_put(tree, entry);
 
-	spin_unlock(&tree->lock);
+	spin_unlock(lock);
 }
 
 /* frees all zswap entries for the given swap type */
@@ -797,16 +802,17 @@ static void zswap_frontswap_invalidate_area(unsigned type)
 {
 	struct zswap_tree *tree = zswap_trees[type];
 	struct zswap_entry *entry, *n;
+	spinlock_t *lock = &tree->lock;
 
 	if (!tree)
 		return;
 
 	/* walk the tree and free everything */
-	spin_lock(&tree->lock);
+	spin_lock(lock);
 	rbtree_postorder_for_each_entry_safe(entry, n, &tree->rbroot, rbnode)
 		zswap_free_entry(entry);
 	tree->rbroot = RB_ROOT;
-	spin_unlock(&tree->lock);
+	spin_unlock(lock);
 	kfree(tree);
 	zswap_trees[type] = NULL;
 }
-- 
1.8.4.5

