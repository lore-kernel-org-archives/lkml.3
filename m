Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933838Ab3CMPeW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 11:34:22 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:38038 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932391Ab3CMPeU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 11:34:20 -0400
Message-ID: <51409C65.1040207@linux.vnet.ibm.com>
Date: Wed, 13 Mar 2013 10:33:57 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>, minchan@kernel.org,
        Nitin Gupta <nitingupta910@gmail.com>,
        Konrad Wilk <konrad.wilk@oracle.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Bob Liu <lliubbo@gmail.com>,
        Luigi Semenzato <semenzato@google.com>, Mel Gorman <mgorman@suse.de>
Subject: Re: zsmalloc limitations and related topics
References: <0efe9610-1aa5-4aa9-bde9-227acfa969ca@default> <20130313151359.GA3130@linux.vnet.ibm.com>
In-Reply-To: <20130313151359.GA3130@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13031315-9360-0000-0000-0000114E99C4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The periodic writeback that Rob mentions would go something like this
for zswap:

---
 mm/filemap.c |    3 +--
 mm/zswap.c   |   63 +++++++++++++++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 59 insertions(+), 7 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 83efee7..fe63e95 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -735,12 +735,11 @@ repeat:
 	if (page && !radix_tree_exception(page)) {
 		lock_page(page);
 		/* Has the page been truncated? */
-		if (unlikely(page->mapping != mapping)) {
+		if (unlikely(page_mapping(page) != mapping)) {
 			unlock_page(page);
 			page_cache_release(page);
 			goto repeat;
 		}
-		VM_BUG_ON(page->index != offset);
 	}
 	return page;
 }
diff --git a/mm/zswap.c b/mm/zswap.c
index 82b8d59..0b2351e 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -42,6 +42,9 @@
 #include <linux/writeback.h>
 #include <linux/pagemap.h>
 
+#include <linux/workqueue.h>
+#include <linux/time.h>
+
 /*********************************
 * statistics
 **********************************/
@@ -102,6 +105,23 @@ module_param_named(max_compression_ratio,
 */
 #define ZSWAP_MAX_OUTSTANDING_FLUSHES 64
 
+/*
+ * The amount of time in seconds for zswap is considered "idle" and periodic
+ * writeback begins
+ */
+static int zswap_pwb_idle_secs = 30;
+
+/*
+ * The delay between iterations of periodic writeback
+ */
+static unsigned long zswap_pwb_delay_secs = 1;
+
+/*
+ * The number of pages to attempt to writeback on each iteration of the periodic
+ * writeback thread
+ */
+static int zswap_pwb_writeback_pages = 32;
+
 /*********************************
 * compression functions
 **********************************/
@@ -199,6 +219,7 @@ struct zswap_entry {
  * The tree lock in the zswap_tree struct protects a few things:
  * - the rbtree
  * - the lru list
+ * - starting/modifying the pwb_work timer
  * - the refcount field of each entry in the tree
  */
 struct zswap_tree {
@@ -207,6 +228,7 @@ struct zswap_tree {
 	spinlock_t lock;
 	struct zs_pool *pool;
 	unsigned type;
+	struct delayed_work pwb_work;
 };
 
 static struct zswap_tree *zswap_trees[MAX_SWAPFILES];
@@ -492,7 +514,7 @@ static int zswap_get_swap_cache_page(swp_entry_t entry,
 		 * called after lookup_swap_cache() failed, re-calling
 		 * that would confuse statistics.
 		 */
-		found_page = find_get_page(&swapper_space, entry.val);
+		found_page = find_lock_page(&swapper_space, entry.val);
 		if (found_page)
 			break;
 
@@ -588,9 +610,8 @@ static int zswap_writeback_entry(struct zswap_tree *tree, struct zswap_entry *en
 		break; /* not reached */
 
 	case ZSWAP_SWAPCACHE_EXIST: /* page is unlocked */
-		/* page is already in the swap cache, ignore for now */
-		return -EEXIST;
-		break; /* not reached */
+		/* page is already in the swap cache, no need to decompress */
+		break;
 
 	case ZSWAP_SWAPCACHE_NEW: /* page is locked */
 		/* decompress */
@@ -698,6 +719,26 @@ static int zswap_writeback_entries(struct zswap_tree *tree, int nr)
 	return freed_nr++;
 }
 
+/*********************************
+* periodic writeback (pwb)
+**********************************/
+void zswap_pwb_work(struct work_struct *work)
+{
+	struct delayed_work *dwork;
+	struct zswap_tree *tree;
+
+	dwork  = to_delayed_work(work);
+	tree = container_of(dwork, struct zswap_tree, pwb_work);
+
+	zswap_writeback_entries(tree, zswap_pwb_writeback_pages);
+
+	spin_lock(&tree->lock);
+	if (!list_empty(&tree->lru))
+		schedule_delayed_work(&tree->pwb_work,
+			msecs_to_jiffies(MSEC_PER_SEC * zswap_pwb_delay_secs));
+	spin_unlock(&tree->lock);
+}
+
 /*******************************************
 * page pool for temporary compression result
 ********************************************/
@@ -854,8 +895,18 @@ static int zswap_frontswap_store(unsigned type, pgoff_t offset,
 	entry->handle = handle;
 	entry->length = dlen;
 
-	/* map */
 	spin_lock(&tree->lock);
+
+	if (RB_EMPTY_ROOT(&tree->rbroot))
+		/* schedule delayed periodic writeback work */
+		schedule_delayed_work(&tree->pwb_work,
+			msecs_to_jiffies(MSEC_PER_SEC * zswap_pwb_idle_secs));
+	else
+		/* update delay on already scheduled delayed work */
+		mod_delayed_work(system_wq, &tree->pwb_work,
+			msecs_to_jiffies(MSEC_PER_SEC * zswap_pwb_idle_secs));
+
+	/* map */
 	do {
 		ret = zswap_rb_insert(&tree->rbroot, entry, &dupentry);
 		if (ret == -EEXIST) {
@@ -1001,6 +1052,7 @@ static void zswap_frontswap_invalidate_area(unsigned type)
 	 * If post-order traversal code is ever added to the rbtree
 	 * implementation, it should be used here.
 	 */
+	cancel_delayed_work_sync(&tree->pwb_work);
 	while ((node = rb_first(&tree->rbroot))) {
 		entry = rb_entry(node, struct zswap_entry, rbnode);
 		rb_erase(&entry->rbnode, &tree->rbroot);
@@ -1027,6 +1079,7 @@ static void zswap_frontswap_init(unsigned type)
 	INIT_LIST_HEAD(&tree->lru);
 	spin_lock_init(&tree->lock);
 	tree->type = type;
+	INIT_DELAYED_WORK(&tree->pwb_work, zswap_pwb_work);
 	zswap_trees[type] = tree;
 	return;
 
-- 
1.7.9.5

