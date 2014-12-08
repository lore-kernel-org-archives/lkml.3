Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184AbaLHGtT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 01:49:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34609 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969AbaLHGtQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 01:49:16 -0500
Date: Sun, 7 Dec 2014 22:48:29 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-4087d11cd9455cd28da0795504451d1188633a0d@git.kernel.org>
Cc: paulus@samba.org, dsahern@gmail.com, tglx@linutronix.de,
        fweisbec@gmail.com, acme@redhat.com, namhyung.kim@lge.com,
        linux-kernel@vger.kernel.org, andi@firstfloor.org, namhyung@kernel.org,
        hpa@zytor.com, jolsa@redhat.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl
Reply-To: jolsa@redhat.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, hpa@zytor.com, andi@firstfloor.org,
        tglx@linutronix.de, dsahern@gmail.com, paulus@samba.org,
        acme@redhat.com, fweisbec@gmail.com, linux-kernel@vger.kernel.org,
        namhyung.kim@lge.com
In-Reply-To: <1416816807-6495-1-git-send-email-namhyung@kernel.org>
References: <1416816807-6495-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf hists browser:
  Print overhead percent value for first-level callchain
Git-Commit-ID: 4087d11cd9455cd28da0795504451d1188633a0d
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

Commit-ID:  4087d11cd9455cd28da0795504451d1188633a0d
Gitweb:     http://git.kernel.org/tip/4087d11cd9455cd28da0795504451d1188633a0d
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Mon, 24 Nov 2014 17:13:26 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 24 Nov 2014 11:28:48 -0300

perf hists browser: Print overhead percent value for first-level callchain

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
index 12c17c5..8d22905 100644
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
