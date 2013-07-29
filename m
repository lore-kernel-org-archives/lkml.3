Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061Ab3G2TUP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 15:20:15 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:59322 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752174Ab3G2TUK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 15:20:10 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Rik van Riel <riel@redhat.com>, Michel Lespinasse <walken@google.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH v2 5/5] mm/zswap: use postorder iteration when destroying rbtree
Date: Mon, 29 Jul 2013 12:19:30 -0700
Message-Id: <1375125570-9401-6-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1375125570-9401-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1375125570-9401-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072919-7408-0000-0000-0000126FCB3C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Reviewed-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
---
 mm/zswap.c | 16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index deda2b6..5c853b2 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -790,26 +790,14 @@ static void zswap_frontswap_invalidate_page(unsigned type, pgoff_t offset)
 static void zswap_frontswap_invalidate_area(unsigned type)
 {
 	struct zswap_tree *tree = zswap_trees[type];
-	struct rb_node *node;
-	struct zswap_entry *entry;
+	struct zswap_entry *entry, *n;
 
 	if (!tree)
 		return;
 
 	/* walk the tree and free everything */
 	spin_lock(&tree->lock);
-	/*
-	 * TODO: Even though this code should not be executed because
-	 * the try_to_unuse() in swapoff should have emptied the tree,
-	 * it is very wasteful to rebalance the tree after every
-	 * removal when we are freeing the whole tree.
-	 *
-	 * If post-order traversal code is ever added to the rbtree
-	 * implementation, it should be used here.
-	 */
-	while ((node = rb_first(&tree->rbroot))) {
-		entry = rb_entry(node, struct zswap_entry, rbnode);
-		rb_erase(&entry->rbnode, &tree->rbroot);
+	rbtree_postorder_for_each_entry_safe(entry, n, &tree->rbroot, rbnode) {
 		zbud_free(tree->pool, entry->handle);
 		zswap_entry_cache_free(entry);
 		atomic_dec(&zswap_stored_pages);
-- 
1.8.3.4

