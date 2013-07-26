Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760390Ab3GZVOe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 17:14:34 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:57495 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933356Ab3GZVOY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 17:14:24 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Rik van Riel <riel@redhat.com>, Michel Lespinasse <walken@google.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH 5/5] mm/zswap: use postorder iteration when destroying rbtree
Date: Fri, 26 Jul 2013 14:13:43 -0700
Message-Id: <1374873223-25557-6-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1374873223-25557-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1374873223-25557-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072621-7182-0000-0000-000007E11386
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
---
 mm/zswap.c | 15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff --git a/mm/zswap.c b/mm/zswap.c
index deda2b6..98d99c4 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -791,25 +791,14 @@ static void zswap_frontswap_invalidate_area(unsigned type)
 {
 	struct zswap_tree *tree = zswap_trees[type];
 	struct rb_node *node;
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

