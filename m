Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751100AbaHMGCp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 02:02:45 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:53428 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbaHMGCo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 02:02:44 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH] perf ui/tui: Fix a small callchain display bug
Date: Wed, 13 Aug 2014 15:02:41 +0900
Message-Id: <1407909761-10822-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The currently when perf TUI report shows callchain, the first level
chains have bogus '+' sign even though only the last one has children.

Since they are on a single line of the chain, toggling intermediate
entries has no effect.  Fix it to show '+' sign at the last entry
only.  Note that non-first level callchain entries don't have this
problem.

Before:

  Children      Self  Command  Shared Object      Symbols
---------------------------------------------------------------------------
-   40.70%     0.00%  swapper  [kernel.kallsyms]  [k] cpuidle_wrap_enter
   + cpuidle_wrap_enter
   + cpuidle_enter_tk
   + cpuidle_idle_call
   + cpu_idle

After:

  Children      Self  Command  Shared Object      Symbols
---------------------------------------------------------------------------
-   40.70%     0.00%  swapper  [kernel.kallsyms]  [k] cpuidle_wrap_enter
     cpuidle_wrap_enter
     cpuidle_enter_tk
     cpuidle_idle_call
   + cpu_idle

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/browsers/hists.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 045c1e16ac59..1818d1275d02 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -228,8 +228,10 @@ static void callchain_node__init_have_children(struct callchain_node *node)
 {
 	struct callchain_list *chain;
 
-	list_for_each_entry(chain, &node->val, list)
+	if (!list_empty(&node->val)) {
+		chain = list_entry(node->val.prev, struct callchain_list, list);
 		chain->ms.has_children = !RB_EMPTY_ROOT(&node->rb_root);
+	}
 
 	callchain_node__init_have_children_rb_tree(node);
 }
-- 
2.0.0

