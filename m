Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752751AbaASM0J (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jan 2014 07:26:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56007 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281AbaASM0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jan 2014 07:26:03 -0500
Date: Sun, 19 Jan 2014 04:25:17 -0800
From: tip-bot for Frederic Weisbecker <tipbot@zytor.com>
Message-ID: <tip-b965bb41061ad8d3eafda6e7feef89279fcd3916@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1389713836-13375-3-git-send-email-fweisbec@gmail.com>
References: <1389713836-13375-3-git-send-email-fweisbec@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf callchain:
  Spare double comparison of callchain first entry
Git-Commit-ID: b965bb41061ad8d3eafda6e7feef89279fcd3916
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sun, 19 Jan 2014 04:25:23 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b965bb41061ad8d3eafda6e7feef89279fcd3916
Gitweb:     http://git.kernel.org/tip/b965bb41061ad8d3eafda6e7feef89279fcd3916
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Tue, 14 Jan 2014 16:37:15 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 17 Jan 2014 11:11:01 -0300

perf callchain: Spare double comparison of callchain first entry

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
index 9eb4f57..662867d 100644
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
