Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752AbaHMWyd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 18:54:33 -0400
Received: from mail.kernel.org ([198.145.19.201]:55446 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754206AbaHMWuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 18:50:35 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 27/41] perf hists browser: Fix a small callchain display bug
Date: Wed, 13 Aug 2014 19:48:13 -0300
Message-Id: <1407970107-24540-28-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407970107-24540-1-git-send-email-acme@kernel.org>
References: <1407970107-24540-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

The currently when perf TUI report shows callchain, the first level
chains have bogus '+' sign even though only the last one has children.

Since they are on a single line of the chain, toggling intermediate
entries has no effect.  Fix it to show '+' sign at the last entry only.
Note that non-first level callchain entries don't have this problem.

  Before:
  ---------------------------------------------------------------------------
    Children      Self  Command  Shared Object      Symbols
  -   40.70%     0.00%  swapper  [kernel.kallsyms]  [k] cpuidle_wrap_enter
     + cpuidle_wrap_enter
     + cpuidle_enter_tk
     + cpuidle_idle_call
     + cpu_idle

  After:
  ---------------------------------------------------------------------------
    Children      Self  Command  Shared Object      Symbols
  -   40.70%     0.00%  swapper  [kernel.kallsyms]  [k] cpuidle_wrap_enter
       cpuidle_wrap_enter
       cpuidle_enter_tk
       cpuidle_idle_call
     + cpu_idle

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/r/1407909761-10822-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
1.9.3

