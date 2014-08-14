Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754994AbaHNIta (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 04:49:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36528 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754530AbaHNIt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 04:49:26 -0400
Date: Thu, 14 Aug 2014 01:48:54 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-82162b5ae3d152fd7d887b36213f5b6785fe1294@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de
In-Reply-To: <1407909761-10822-1-git-send-email-namhyung@kernel.org>
References: <1407909761-10822-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf hists browser:
  Fix a small callchain display bug
Git-Commit-ID: 82162b5ae3d152fd7d887b36213f5b6785fe1294
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

Commit-ID:  82162b5ae3d152fd7d887b36213f5b6785fe1294
Gitweb:     http://git.kernel.org/tip/82162b5ae3d152fd7d887b36213f5b6785fe1294
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Wed, 13 Aug 2014 15:02:41 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 13 Aug 2014 17:12:56 -0300

perf hists browser: Fix a small callchain display bug

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
index 045c1e1..1818d12 100644
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
