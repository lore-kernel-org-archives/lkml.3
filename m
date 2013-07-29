Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753839Ab3G2TTr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 15:19:47 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:55303 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512Ab3G2TTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 15:19:44 -0400
From: Cody P Schafer <cody@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Rik van Riel <riel@redhat.com>, Michel Lespinasse <walken@google.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Cody P Schafer <cody@linux.vnet.ibm.com>
Subject: [PATCH v2 1/5] rbtree: add postorder iteration functions
Date: Mon, 29 Jul 2013 12:19:26 -0700
Message-Id: <1375125570-9401-2-git-send-email-cody@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1375125570-9401-1-git-send-email-cody@linux.vnet.ibm.com>
References: <1375125570-9401-1-git-send-email-cody@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13072919-3620-0000-0000-000003B9020F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add postorder iteration functions for rbtree. These are useful for
safely freeing an entire rbtree without modifying the tree at all.

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Reviewed-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
---
 include/linux/rbtree.h |  4 ++++
 lib/rbtree.c           | 40 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 44 insertions(+)

diff --git a/include/linux/rbtree.h b/include/linux/rbtree.h
index 0022c1b..c467151 100644
--- a/include/linux/rbtree.h
+++ b/include/linux/rbtree.h
@@ -68,6 +68,10 @@ extern struct rb_node *rb_prev(const struct rb_node *);
 extern struct rb_node *rb_first(const struct rb_root *);
 extern struct rb_node *rb_last(const struct rb_root *);
 
+/* Postorder iteration - always visit the parent after its children */
+extern struct rb_node *rb_first_postorder(const struct rb_root *);
+extern struct rb_node *rb_next_postorder(const struct rb_node *);
+
 /* Fast replacement of a single node without remove/rebalance/add/rebalance */
 extern void rb_replace_node(struct rb_node *victim, struct rb_node *new, 
 			    struct rb_root *root);
diff --git a/lib/rbtree.c b/lib/rbtree.c
index c0e31fe..65f4eff 100644
--- a/lib/rbtree.c
+++ b/lib/rbtree.c
@@ -518,3 +518,43 @@ void rb_replace_node(struct rb_node *victim, struct rb_node *new,
 	*new = *victim;
 }
 EXPORT_SYMBOL(rb_replace_node);
+
+static struct rb_node *rb_left_deepest_node(const struct rb_node *node)
+{
+	for (;;) {
+		if (node->rb_left)
+			node = node->rb_left;
+		else if (node->rb_right)
+			node = node->rb_right;
+		else
+			return (struct rb_node *)node;
+	}
+}
+
+struct rb_node *rb_next_postorder(const struct rb_node *node)
+{
+	const struct rb_node *parent;
+	if (!node)
+		return NULL;
+	parent = rb_parent(node);
+
+	/* If we're sitting on node, we've already seen our children */
+	if (parent && node == parent->rb_left && parent->rb_right) {
+		/* If we are the parent's left node, go to the parent's right
+		 * node then all the way down to the left */
+		return rb_left_deepest_node(parent->rb_right);
+	} else
+		/* Otherwise we are the parent's right node, and the parent
+		 * should be next */
+		return (struct rb_node *)parent;
+}
+EXPORT_SYMBOL(rb_next_postorder);
+
+struct rb_node *rb_first_postorder(const struct rb_root *root)
+{
+	if (!root->rb_node)
+		return NULL;
+
+	return rb_left_deepest_node(root->rb_node);
+}
+EXPORT_SYMBOL(rb_first_postorder);
-- 
1.8.3.4

