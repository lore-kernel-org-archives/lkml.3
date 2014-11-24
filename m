Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217AbaKXINx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 03:13:53 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:42778 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159AbaKXINe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 03:13:34 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 2/2] perf tools: Collapse first level callchain entry if it has sibling
Date: Mon, 24 Nov 2014 17:13:27 +0900
Message-Id: <1416816807-6495-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1416816807-6495-1-git-send-email-namhyung@kernel.org>
References: <1416816807-6495-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If first level callchain has more than single path like when -g caller
option is given, it should show only first one in the path and hide
others.  But it didn't do it properly nad just hindered the output.

Before:
  -   80.33%    11.11%  abc2     abc2              [.] main
     + 86.18% main
       13.82% __libc_start_main
          main

After:
  -   80.33%    11.11%  abc2     abc2              [.] main
     + 86.18% main
     + 13.82% __libc_start_main

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/browsers/hists.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 8d22905a4687..502daff76ceb 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -227,10 +227,14 @@ static void callchain_node__init_have_children_rb_tree(struct callchain_node *no
 	}
 }
 
-static void callchain_node__init_have_children(struct callchain_node *node)
+static void callchain_node__init_have_children(struct callchain_node *node,
+					       bool has_sibling)
 {
 	struct callchain_list *chain;
 
+	chain = list_entry(node->val.next, struct callchain_list, list);
+	chain->ms.has_children = has_sibling;
+
 	if (!list_empty(&node->val)) {
 		chain = list_entry(node->val.prev, struct callchain_list, list);
 		chain->ms.has_children = !RB_EMPTY_ROOT(&node->rb_root);
@@ -241,11 +245,12 @@ static void callchain_node__init_have_children(struct callchain_node *node)
 
 static void callchain__init_have_children(struct rb_root *root)
 {
-	struct rb_node *nd;
+	struct rb_node *nd = rb_first(root);
+	bool has_sibling = nd && rb_next(nd);
 
 	for (nd = rb_first(root); nd; nd = rb_next(nd)) {
 		struct callchain_node *node = rb_entry(nd, struct callchain_node, rb_node);
-		callchain_node__init_have_children(node);
+		callchain_node__init_have_children(node, has_sibling);
 	}
 }
 
-- 
2.1.2

