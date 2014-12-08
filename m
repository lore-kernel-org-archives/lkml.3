Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149AbaLHGtS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 01:49:18 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34610 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047AbaLHGtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 01:49:16 -0500
Date: Sun, 7 Dec 2014 22:48:44 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-a7444af69b2898bb9b3a847d3599e1fc98356ce5@git.kernel.org>
Cc: paulus@samba.org, hpa@zytor.com, namhyung.kim@lge.com, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, jolsa@redhat.com, mingo@kernel.org,
        dsahern@gmail.com, namhyung@kernel.org, fweisbec@gmail.com,
        acme@redhat.com, linux-kernel@vger.kernel.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, jolsa@redhat.com, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, hpa@zytor.com, namhyung.kim@lge.com,
        paulus@samba.org, tglx@linutronix.de, linux-kernel@vger.kernel.org,
        fweisbec@gmail.com, acme@redhat.com, namhyung@kernel.org,
        dsahern@gmail.com
In-Reply-To: <1416816807-6495-2-git-send-email-namhyung@kernel.org>
References: <1416816807-6495-2-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Collapse first level callchain entry if it has sibling
Git-Commit-ID: a7444af69b2898bb9b3a847d3599e1fc98356ce5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a7444af69b2898bb9b3a847d3599e1fc98356ce5
Gitweb:     http://git.kernel.org/tip/a7444af69b2898bb9b3a847d3599e1fc98356ce5
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Mon, 24 Nov 2014 17:13:27 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 24 Nov 2014 11:34:33 -0300

perf tools: Collapse first level callchain entry if it has sibling

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
index 8d22905..502daff 100644
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
 
