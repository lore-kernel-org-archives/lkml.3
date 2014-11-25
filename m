Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754415AbaKYNWa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 08:22:30 -0500
Received: from mail.kernel.org ([198.145.19.201]:35554 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752527AbaKYNW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 08:22:26 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Andi Kleen <andi@firstfloor.org>, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 01/12] perf hists browser: Print overhead percent value for first-level callchain
Date: Tue, 25 Nov 2014 10:21:59 -0300
Message-Id: <1416921730-5063-2-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1416921730-5063-1-git-send-email-acme@kernel.org>
References: <1416921730-5063-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

Currently perf report on TUI doesn't print percent for first-level
callchain entry.

I guess it (wrongly) assumes that there's only a single callchain in the
first level.

This patch fixes it by handling the first level callchains same as
others - if it's not 100% it should print the percent value.

Also it'll affect other callchains in the other way around - if it's
100% (single callchain) it should not print the percentage.

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

Reported-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1416816807-6495-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
1.9.3

