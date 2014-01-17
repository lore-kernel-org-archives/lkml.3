Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705AbaAQO7n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 09:59:43 -0500
Received: from merlin.infradead.org ([205.233.59.134]:36318 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752396AbaAQO5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 09:57:43 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 18/19] perf callchain: Spare double comparison of callchain first entry
Date: Fri, 17 Jan 2014 11:57:24 -0300
Message-Id: <1389970645-12075-19-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1389970645-12075-1-git-send-email-acme@infradead.org>
References: <1389970645-12075-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>

When a new callchain child branch matches an existing one in the rbtree,
the comparison of its first entry is performed twice:

1) From append_chain_children() on branch lookup

2) If 1) reports a match, append_chain() then compares all entries of
the new branch against the matching node in the rbtree, and this
comparison includes the first entry of the new branch again.

Lets shortcut this by performing the whole comparison only from
append_chain() which then returns the result of the comparison between
the first entry of the new branch and the iterating node in the rbtree.
If the first entry matches, the lookup on the current level of siblings
stops and propagates to the children of the matching nodes.

This results in less comparisons performed by the CPU.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1389713836-13375-3-git-send-email-fweisbec@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/callchain.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/tools/perf/util/callchain.c b/tools/perf/util/callchain.c
index 9eb4f57f8663..662867d5c374 100644
--- a/tools/perf/util/callchain.c
+++ b/tools/perf/util/callchain.c
@@ -15,6 +15,8 @@
 #include <errno.h>
 #include <math.h>
 
+#include "asm/bug.h"
+
 #include "hist.h"
 #include "util.h"
 #include "sort.h"
@@ -358,19 +360,14 @@ append_chain_children(struct callchain_node *root,
 	/* lookup in childrens */
 	while (*p) {
 		s64 ret;
-		struct callchain_list *cnode;
 
 		parent = *p;
 		rnode = rb_entry(parent, struct callchain_node, rb_node_in);
-		cnode = list_first_entry(&rnode->val, struct callchain_list,
-					 list);
 
-		/* just check first entry */
-		ret = match_chain(node, cnode);
-		if (ret == 0) {
-			append_chain(rnode, cursor, period);
+		/* If at least first entry matches, rely to children */
+		ret = append_chain(rnode, cursor, period);
+		if (ret == 0)
 			goto inc_children_hit;
-		}
 
 		if (ret < 0)
 			p = &parent->rb_left;
@@ -396,6 +393,7 @@ append_chain(struct callchain_node *root,
 	u64 start = cursor->pos;
 	bool found = false;
 	u64 matches;
+	int cmp = 0;
 
 	/*
 	 * Lookup in the current node
@@ -410,7 +408,8 @@ append_chain(struct callchain_node *root,
 		if (!node)
 			break;
 
-		if (match_chain(node, cnode) != 0)
+		cmp = match_chain(node, cnode);
+		if (cmp)
 			break;
 
 		found = true;
@@ -420,9 +419,10 @@ append_chain(struct callchain_node *root,
 
 	/* matches not, relay no the parent */
 	if (!found) {
+		WARN_ONCE(!cmp, "Chain comparison error\n");
 		cursor->curr = curr_snap;
 		cursor->pos = start;
-		return -1;
+		return cmp;
 	}
 
 	matches = cursor->pos - start;
-- 
1.8.1.4

