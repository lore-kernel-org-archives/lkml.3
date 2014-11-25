Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784AbaKYNWd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 08:22:33 -0500
Received: from mail.kernel.org ([198.145.19.201]:35587 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754420AbaKYNWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 08:22:30 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 02/12] perf tools: Collapse first level callchain entry if it has sibling
Date: Tue, 25 Nov 2014 10:22:00 -0300
Message-Id: <1416921730-5063-3-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1416921730-5063-1-git-send-email-acme@kernel.org>
References: <1416921730-5063-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

If first level callchain has more than single path like when -g caller
option is given, it should show only first one in the path and hide
others.  But it didn't do it properly and just hindered the output.

Before:
  -   80.33%    11.11%  abc2     abc2              [.] main
     + 86.18% main
       13.82% __libc_start_main
          main

After:
  -   80.33%    11.11%  abc2     abc2              [.] main
     + 86.18% main
     + 13.82% __libc_start_main

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1416816807-6495-2-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
1.9.3

