Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589AbaKXINv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 03:13:51 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:42772 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753162AbaKXINf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 03:13:35 -0500
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
Subject: [PATCH 1/2] perf hists browser: Print overhead percent value for first-level callchain
Date: Mon, 24 Nov 2014 17:13:26 +0900
Message-Id: <1416816807-6495-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently perf report on TUI doesn't print percent for first-level
callchain entry.  I guess it (wrongly) assumes that there's only a
single callchain in the first level.  This patch fixes it by handling
the first level callchains same as others - if it's not 100% it should
print the percent value.  Also it'll affect other callchains in the
other way around - if it's 100% (single callchain) it should not print
the percentage.

Before:
  -   30.95%     6.84%  abc2     abc2              [.] a
     - a
        - 70.00% c
           - 100.00% apic_timer_interrupt
                smp_apic_timer_interrupt
                local_apic_timer_interrupt
                hrtimer_interrupt
                ...
        + 30.00% b
     + __libc_start_main

After:
  -   30.95%     6.84%  abc2     abc2              [.] a
     - 77.90% a
        - 70.00% c
           - apic_timer_interrupt
             smp_apic_timer_interrupt
             local_apic_timer_interrupt
             hrtimer_interrupt
             ...
        + 30.00% b
     + 22.10% __libc_start_main

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/ui/browsers/hists.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index 12c17c5a3d68..8d22905a4687 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -542,8 +542,11 @@ static int hist_browser__show_callchain(struct hist_browser *browser,
 	struct rb_node *node;
 	int first_row = row, offset = level * LEVEL_OFFSET_STEP;
 	u64 new_total;
+	bool need_percent;
 
 	node = rb_first(root);
+	need_percent = !!rb_next(node);
+
 	while (node) {
 		struct callchain_node *child = rb_entry(node, struct callchain_node, rb_node);
 		struct rb_node *next = rb_next(node);
@@ -560,7 +563,7 @@ static int hist_browser__show_callchain(struct hist_browser *browser,
 
 			if (first)
 				first = false;
-			else if (level > 1)
+			else if (need_percent)
 				extra_offset = LEVEL_OFFSET_STEP;
 
 			folded_sign = callchain_list__folded(chain);
@@ -573,7 +576,7 @@ static int hist_browser__show_callchain(struct hist_browser *browser,
 			str = callchain_list__sym_name(chain, bf, sizeof(bf),
 						       browser->show_dso);
 
-			if (was_first && level > 1) {
+			if (was_first && need_percent) {
 				double percent = cumul * 100.0 / total;
 
 				if (asprintf(&alloc_str, "%2.2f%% %s", percent, str) < 0)
@@ -790,6 +793,13 @@ static int hist_browser__show_entry(struct hist_browser *browser,
 			.is_current_entry = current_entry,
 		};
 
+		if (callchain_param.mode == CHAIN_GRAPH_REL) {
+			if (symbol_conf.cumulate_callchain)
+				total = entry->stat_acc->period;
+			else
+				total = entry->stat.period;
+		}
+
 		printed += hist_browser__show_callchain(browser,
 					&entry->sorted_chain, 1, row, total,
 					hist_browser__show_callchain_entry, &arg,
-- 
2.1.2

