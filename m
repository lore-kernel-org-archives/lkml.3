Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932953AbaDBSKv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 14:10:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31108 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932888AbaDBSJT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 14:09:19 -0400
From: Luiz Capitulino <lcapitulino@redhat.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, mtosatti@redhat.com, aarcange@redhat.com,
        mgorman@suse.de, akpm@linux-foundation.org, andi@firstfloor.org,
        davidlohr@hp.com, rientjes@google.com, isimatu.yasuaki@jp.fujitsu.com,
        yinghai@kernel.org, riel@redhat.com
Subject: [PATCH 3/4] hugetlb: move helpers up in the file
Date: Wed,  2 Apr 2014 14:08:47 -0400
Message-Id: <1396462128-32626-4-git-send-email-lcapitulino@redhat.com>
In-Reply-To: <1396462128-32626-1-git-send-email-lcapitulino@redhat.com>
References: <1396462128-32626-1-git-send-email-lcapitulino@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Next commit will add new code which will want to call the
for_each_node_mask_to_alloc() macro. Move it, its buddy
for_each_node_mask_to_free() and their dependencies up in the file so
the new code can use them. This is just code movement, no logic change.

Signed-off-by: Luiz Capitulino <lcapitulino@redhat.com>
---
 mm/hugetlb.c | 146 +++++++++++++++++++++++++++++------------------------------
 1 file changed, 73 insertions(+), 73 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 7e07e47..2c7a44a 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -570,6 +570,79 @@ err:
 	return NULL;
 }
 
+/*
+ * common helper functions for hstate_next_node_to_{alloc|free}.
+ * We may have allocated or freed a huge page based on a different
+ * nodes_allowed previously, so h->next_node_to_{alloc|free} might
+ * be outside of *nodes_allowed.  Ensure that we use an allowed
+ * node for alloc or free.
+ */
+static int next_node_allowed(int nid, nodemask_t *nodes_allowed)
+{
+	nid = next_node(nid, *nodes_allowed);
+	if (nid == MAX_NUMNODES)
+		nid = first_node(*nodes_allowed);
+	VM_BUG_ON(nid >= MAX_NUMNODES);
+
+	return nid;
+}
+
+static int get_valid_node_allowed(int nid, nodemask_t *nodes_allowed)
+{
+	if (!node_isset(nid, *nodes_allowed))
+		nid = next_node_allowed(nid, nodes_allowed);
+	return nid;
+}
+
+/*
+ * returns the previously saved node ["this node"] from which to
+ * allocate a persistent huge page for the pool and advance the
+ * next node from which to allocate, handling wrap at end of node
+ * mask.
+ */
+static int hstate_next_node_to_alloc(struct hstate *h,
+					nodemask_t *nodes_allowed)
+{
+	int nid;
+
+	VM_BUG_ON(!nodes_allowed);
+
+	nid = get_valid_node_allowed(h->next_nid_to_alloc, nodes_allowed);
+	h->next_nid_to_alloc = next_node_allowed(nid, nodes_allowed);
+
+	return nid;
+}
+
+/*
+ * helper for free_pool_huge_page() - return the previously saved
+ * node ["this node"] from which to free a huge page.  Advance the
+ * next node id whether or not we find a free huge page to free so
+ * that the next attempt to free addresses the next node.
+ */
+static int hstate_next_node_to_free(struct hstate *h, nodemask_t *nodes_allowed)
+{
+	int nid;
+
+	VM_BUG_ON(!nodes_allowed);
+
+	nid = get_valid_node_allowed(h->next_nid_to_free, nodes_allowed);
+	h->next_nid_to_free = next_node_allowed(nid, nodes_allowed);
+
+	return nid;
+}
+
+#define for_each_node_mask_to_alloc(hs, nr_nodes, node, mask)		\
+	for (nr_nodes = nodes_weight(*mask);				\
+		nr_nodes > 0 &&						\
+		((node = hstate_next_node_to_alloc(hs, mask)) || 1);	\
+		nr_nodes--)
+
+#define for_each_node_mask_to_free(hs, nr_nodes, node, mask)		\
+	for (nr_nodes = nodes_weight(*mask);				\
+		nr_nodes > 0 &&						\
+		((node = hstate_next_node_to_free(hs, mask)) || 1);	\
+		nr_nodes--)
+
 static void update_and_free_page(struct hstate *h, struct page *page)
 {
 	int i;
@@ -750,79 +823,6 @@ static struct page *alloc_fresh_huge_page_node(struct hstate *h, int nid)
 	return page;
 }
 
-/*
- * common helper functions for hstate_next_node_to_{alloc|free}.
- * We may have allocated or freed a huge page based on a different
- * nodes_allowed previously, so h->next_node_to_{alloc|free} might
- * be outside of *nodes_allowed.  Ensure that we use an allowed
- * node for alloc or free.
- */
-static int next_node_allowed(int nid, nodemask_t *nodes_allowed)
-{
-	nid = next_node(nid, *nodes_allowed);
-	if (nid == MAX_NUMNODES)
-		nid = first_node(*nodes_allowed);
-	VM_BUG_ON(nid >= MAX_NUMNODES);
-
-	return nid;
-}
-
-static int get_valid_node_allowed(int nid, nodemask_t *nodes_allowed)
-{
-	if (!node_isset(nid, *nodes_allowed))
-		nid = next_node_allowed(nid, nodes_allowed);
-	return nid;
-}
-
-/*
- * returns the previously saved node ["this node"] from which to
- * allocate a persistent huge page for the pool and advance the
- * next node from which to allocate, handling wrap at end of node
- * mask.
- */
-static int hstate_next_node_to_alloc(struct hstate *h,
-					nodemask_t *nodes_allowed)
-{
-	int nid;
-
-	VM_BUG_ON(!nodes_allowed);
-
-	nid = get_valid_node_allowed(h->next_nid_to_alloc, nodes_allowed);
-	h->next_nid_to_alloc = next_node_allowed(nid, nodes_allowed);
-
-	return nid;
-}
-
-/*
- * helper for free_pool_huge_page() - return the previously saved
- * node ["this node"] from which to free a huge page.  Advance the
- * next node id whether or not we find a free huge page to free so
- * that the next attempt to free addresses the next node.
- */
-static int hstate_next_node_to_free(struct hstate *h, nodemask_t *nodes_allowed)
-{
-	int nid;
-
-	VM_BUG_ON(!nodes_allowed);
-
-	nid = get_valid_node_allowed(h->next_nid_to_free, nodes_allowed);
-	h->next_nid_to_free = next_node_allowed(nid, nodes_allowed);
-
-	return nid;
-}
-
-#define for_each_node_mask_to_alloc(hs, nr_nodes, node, mask)		\
-	for (nr_nodes = nodes_weight(*mask);				\
-		nr_nodes > 0 &&						\
-		((node = hstate_next_node_to_alloc(hs, mask)) || 1);	\
-		nr_nodes--)
-
-#define for_each_node_mask_to_free(hs, nr_nodes, node, mask)		\
-	for (nr_nodes = nodes_weight(*mask);				\
-		nr_nodes > 0 &&						\
-		((node = hstate_next_node_to_free(hs, mask)) || 1);	\
-		nr_nodes--)
-
 static int alloc_fresh_huge_page(struct hstate *h, nodemask_t *nodes_allowed)
 {
 	struct page *page;
-- 
1.8.1.4

