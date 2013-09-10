Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756063Ab3IJI0u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 04:26:50 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:45991 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754554Ab3IJIYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 04:24:22 -0400
X-AuditID: 9c93017e-b7c76ae000003897-9e-522ed7342824
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 1/3] perf callchain: Convert children list to rbtree
Date: Tue, 10 Sep 2013 17:24:16 +0900
Message-Id: <1378801458-2515-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1378801458-2515-1-git-send-email-namhyung@kernel.org>
References: <1378801458-2515-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Current collapse stage has a scalability problem which can be
reproduced easily with parallel kernel build.  This is because it
needs to traverse every children of callchain linearly during the
collapse/merge stage.  Convert it to rbtree reduced the overhead
significantly.

On my 400MB perf.data file which recorded with make -j32 kernel build:

  $ time perf --no-pager report --stdio > /dev/null

before:
  real	6m22.073s
  user	6m18.683s
  sys	0m0.706s

after:
  real	0m20.780s
  user	0m19.962s
  sys	0m0.689s

During the perf report the overhead on append_chain_children went down
from 96.69% to 18.16%:

  -  18.16%  perf  perf                [.] append_chain_children
     - append_chain_children
        - 77.48% append_chain_children
           + 69.79% merge_chain_branch
           - 22.96% append_chain_children
              + 67.44% merge_chain_branch
              + 30.15% append_chain_children
              + 2.41% callchain_append
           + 7.25% callchain_append
        + 12.26% callchain_append
        + 10.22% merge_chain_branch
  +  11.58%  perf  perf                [.] dso__find_symbol
  +   8.02%  perf  perf                [.] sort__comm_cmp
  +   5.48%  perf  libc-2.17.so        [.] malloc_consolidate

Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/callchain.c | 151 +++++++++++++++++++++++++++++++++-----------
 tools/perf/util/callchain.h |   5 +-
 2 files changed, 116 insertions(+), 40 deletions(-)

diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index 482f68081cd8..4ac385515c2f 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -21,12 +21,6 @@
 
 __thread struct callchain_cursor callchain_cursor;
 
-#define chain_for_each_child(child, parent)	\
-	list_for_each_entry(child, &parent->children, siblings)
-
-#define chain_for_each_child_safe(child, next, parent)	\
-	list_for_each_entry_safe(child, next, &parent->children, siblings)
-
 static void
 rb_insert_callchain(struct rb_root *root, struct callchain_node *chain,
 		    enum chain_mode mode)
@@ -71,10 +65,17 @@ static void
 __sort_chain_flat(struct rb_root *rb_root, struct callchain_node *node,
 		  u64 min_hit)
 {
+	struct rb_node *n;
 	struct callchain_node *child;
 
-	chain_for_each_child(child, node)
+	n = rb_first(&node->rb_root_in);
+	while (n) {
+		child = rb_entry(n, struct callchain_node, rb_node);
+		n = rb_next(n);
+		rb_erase(&child->rb_node, &node->rb_root_in);
+
 		__sort_chain_flat(rb_root, child, min_hit);
+	}
 
 	if (node->hit && node->hit >= min_hit)
 		rb_insert_callchain(rb_root, node, CHAIN_FLAT);
@@ -94,11 +95,17 @@ sort_chain_flat(struct rb_root *rb_root, struct callchain_root *root,
 static void __sort_chain_graph_abs(struct callchain_node *node,
 				   u64 min_hit)
 {
+	struct rb_node *n;
 	struct callchain_node *child;
 
 	node->rb_root = RB_ROOT;
+	n = rb_first(&node->rb_root_in);
+
+	while (n) {
+		child = rb_entry(n, struct callchain_node, rb_node);
+		n = rb_next(n);
+		rb_erase(&child->rb_node, &node->rb_root_in);
 
-	chain_for_each_child(child, node) {
 		__sort_chain_graph_abs(child, min_hit);
 		if (callchain_cumul_hits(child) >= min_hit)
 			rb_insert_callchain(&node->rb_root, child,
@@ -117,13 +124,19 @@ sort_chain_graph_abs(struct rb_root *rb_root, struct callchain_root *chain_root,
 static void __sort_chain_graph_rel(struct callchain_node *node,
 				   double min_percent)
 {
+	struct rb_node *n;
 	struct callchain_node *child;
 	u64 min_hit;
 
 	node->rb_root = RB_ROOT;
 	min_hit = ceil(node->children_hit * min_percent);
 
-	chain_for_each_child(child, node) {
+	n = rb_first(&node->rb_root_in);
+	while (n) {
+		child = rb_entry(n, struct callchain_node, rb_node);
+		n = rb_next(n);
+		rb_erase(&child->rb_node, &node->rb_root_in);
+
 		__sort_chain_graph_rel(child, min_percent);
 		if (callchain_cumul_hits(child) >= min_hit)
 			rb_insert_callchain(&node->rb_root, child,
@@ -173,19 +186,22 @@ create_child(struct callchain_node *parent, bool inherit_children)
 		return NULL;
 	}
 	new->parent = parent;
-	INIT_LIST_HEAD(&new->children);
 	INIT_LIST_HEAD(&new->val);
 
 	if (inherit_children) {
-		struct callchain_node *next;
+		struct rb_node *n;
+		struct callchain_node *child;
 
-		list_splice(&parent->children, &new->children);
-		INIT_LIST_HEAD(&parent->children);
+		new->rb_root_in = parent->rb_root_in;
+		parent->rb_root_in = RB_ROOT;
 
-		chain_for_each_child(next, new)
-			next->parent = new;
+		n = rb_first(&new->rb_root_in);
+		while (n) {
+			child = rb_entry(n, struct callchain_node, rb_node);
+			child->parent = new;
+			n = rb_next(n);
+		}
 	}
-	list_add_tail(&new->siblings, &parent->children);
 
 	return new;
 }
@@ -223,7 +239,7 @@ fill_node(struct callchain_node *node, struct callchain_cursor *cursor)
 	}
 }
 
-static void
+static struct callchain_node *
 add_child(struct callchain_node *parent,
 	  struct callchain_cursor *cursor,
 	  u64 period)
@@ -235,6 +251,19 @@ add_child(struct callchain_node *parent,
 
 	new->children_hit = 0;
 	new->hit = period;
+	return new;
+}
+
+static s64 match_chain(struct callchain_cursor_node *node,
+		      struct callchain_list *cnode)
+{
+	struct symbol *sym = node->sym;
+
+	if (cnode->ms.sym && sym &&
+	    callchain_param.key == CCKEY_FUNCTION)
+		return cnode->ms.sym->start - sym->start;
+	else
+		return cnode->ip - node->ip;
 }
 
 /*
@@ -254,6 +283,12 @@ split_add_child(struct callchain_node *parent,
 
 	/* split */
 	new = create_child(parent, true);
+	/* move existing children under new child */
+	new->rb_root_in = parent->rb_root_in;
+	parent->rb_root_in = RB_ROOT;
+	/* make it the first child */
+	rb_link_node(&new->rb_node, NULL, &parent->rb_root_in.rb_node);
+	rb_insert_color(&new->rb_node, &parent->rb_root_in);
 
 	/* split the callchain and move a part to the new child */
 	old_tail = parent->val.prev;
@@ -272,9 +307,33 @@ split_add_child(struct callchain_node *parent,
 
 	/* create a new child for the new branch if any */
 	if (idx_total < cursor->nr) {
+		struct callchain_node *first;
+		struct callchain_list *cnode;
+		struct callchain_cursor_node *node;
+		struct rb_node *p, **pp;
+
 		parent->hit = 0;
-		add_child(parent, cursor, period);
 		parent->children_hit += period;
+
+		node = callchain_cursor_current(cursor);
+		new = add_child(parent, cursor, period);
+
+		/*
+		 * This is second child since we moved parent's children
+		 * to new (first) child above.
+		 */
+		p = parent->rb_root_in.rb_node;
+		first = rb_entry(p, struct callchain_node, rb_node);
+		cnode = list_first_entry(&first->val, struct callchain_list,
+					 list);
+
+		if (match_chain(node, cnode) < 0)
+			pp = &p->rb_left;
+		else
+			pp = &p->rb_right;
+
+		rb_link_node(&new->rb_node, p, pp);
+		rb_insert_color(&new->rb_node, &parent->rb_root_in);
 	} else {
 		parent->hit = period;
 	}
@@ -291,16 +350,39 @@ append_chain_children(struct callchain_node *root,
 		      u64 period)
 {
 	struct callchain_node *rnode;
+	struct callchain_cursor_node *node;
+	struct rb_node **p = &root->rb_root_in.rb_node;
+	struct rb_node *parent = NULL;
+
+	node = callchain_cursor_current(cursor);
+	if (!node)
+		return;
 
 	/* lookup in childrens */
-	chain_for_each_child(rnode, root) {
-		unsigned int ret = append_chain(rnode, cursor, period);
+	while (*p) {
+		s64 ret;
+		struct callchain_list *cnode;
 
-		if (!ret)
+		parent = *p;
+		rnode = rb_entry(parent, struct callchain_node, rb_node);
+		cnode = list_first_entry(&rnode->val, struct callchain_list,
+					 list);
+
+		/* just check first entry */
+		ret = match_chain(node, cnode);
+		if (ret < 0)
+			p = &parent->rb_left;
+		else if (ret > 0)
+			p = &parent->rb_right;
+		else {
+			append_chain(rnode, cursor, period);
 			goto inc_children_hit;
+		}
 	}
 	/* nothing in children, add to the current node */
-	add_child(root, cursor, period);
+	rnode = add_child(root, cursor, period);
+	rb_link_node(&rnode->rb_node, parent, p);
+	rb_insert_color(&rnode->rb_node, &root->rb_root_in);
 
 inc_children_hit:
 	root->children_hit += period;
@@ -325,28 +407,20 @@ append_chain(struct callchain_node *root,
 	 */
 	list_for_each_entry(cnode, &root->val, list) {
 		struct callchain_cursor_node *node;
-		struct symbol *sym;
 
 		node = callchain_cursor_current(cursor);
 		if (!node)
 			break;
 
-		sym = node->sym;
-
-		if (cnode->ms.sym && sym &&
-		    callchain_param.key == CCKEY_FUNCTION) {
-			if (cnode->ms.sym->start != sym->start)
-				break;
-		} else if (cnode->ip != node->ip)
+		if (match_chain(node, cnode) != 0)
 			break;
 
-		if (!found)
-			found = true;
+		found = true;
 
 		callchain_cursor_advance(cursor);
 	}
 
-	/* matches not, relay on the parent */
+	/* matches not, relay no the parent */
 	if (!found) {
 		cursor->curr = curr_snap;
 		cursor->pos = start;
@@ -395,8 +469,9 @@ merge_chain_branch(struct callchain_cursor *cursor,
 		   struct callchain_node *dst, struct callchain_node *src)
 {
 	struct callchain_cursor_node **old_last = cursor->last;
-	struct callchain_node *child, *next_child;
+	struct callchain_node *child;
 	struct callchain_list *list, *next_list;
+	struct rb_node *n;
 	int old_pos = cursor->nr;
 	int err = 0;
 
@@ -412,12 +487,16 @@ merge_chain_branch(struct callchain_cursor *cursor,
 		append_chain_children(dst, cursor, src->hit);
 	}
 
-	chain_for_each_child_safe(child, next_child, src) {
+	n = rb_first(&src->rb_root_in);
+	while (n) {
+		child = container_of(n, struct callchain_node, rb_node);
+		n = rb_next(n);
+		rb_erase(&child->rb_node, &src->rb_root_in);
+
 		err = merge_chain_branch(cursor, dst, child);
 		if (err)
 			break;
 
-		list_del(&child->siblings);
 		free(child);
 	}
 
diff --git a/tools/perf/util/callchain.h b/tools/perf/util/callchain.h
index 2b585bc308cf..1b22b6269213 100644
--- a/tools/perf/util/callchain.h
+++ b/tools/perf/util/callchain.h
@@ -21,10 +21,9 @@ enum chain_order {
 
 struct callchain_node {
 	struct callchain_node	*parent;
-	struct list_head	siblings;
-	struct list_head	children;
 	struct list_head	val;
 	struct rb_node		rb_node; /* to sort nodes in an rbtree */
+	struct rb_root		rb_root_in; /* sorted tree of children */
 	struct rb_root		rb_root; /* sorted tree of children */
 	unsigned int		val_nr;
 	u64			hit;
@@ -86,8 +85,6 @@ extern __thread struct callchain_cursor callchain_cursor;
 
 static inline void callchain_init(struct callchain_root *root)
 {
-	INIT_LIST_HEAD(&root->node.siblings);
-	INIT_LIST_HEAD(&root->node.children);
 	INIT_LIST_HEAD(&root->node.val);
 
 	root->node.parent = NULL;
-- 
1.7.11.7

