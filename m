Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753547Ab3JYKdu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 06:33:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52486 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207Ab3JYKds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 06:33:48 -0400
Date: Fri, 25 Oct 2013 03:33:29 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-c1fb5651bb40f9efaf32d280f39e06df7e352673@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, tglx@linutronix.de
In-Reply-To: <1381468543-25334-4-git-send-email-namhyung@kernel.org>
References: <1381468543-25334-4-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Show progress on histogram collapsing
Git-Commit-ID: c1fb5651bb40f9efaf32d280f39e06df7e352673
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Fri, 25 Oct 2013 03:33:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c1fb5651bb40f9efaf32d280f39e06df7e352673
Gitweb:     http://git.kernel.org/tip/c1fb5651bb40f9efaf32d280f39e06df7e352673
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Fri, 11 Oct 2013 14:15:38 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 23 Oct 2013 15:48:24 -0300

perf tools: Show progress on histogram collapsing

It can take quite amount of time so add progress bar UI to inform user.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1381468543-25334-4-git-send-email-namhyung@kernel.org
[ perf_progress -> ui_progress ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-annotate.c |  2 +-
 tools/perf/builtin-diff.c     |  2 +-
 tools/perf/builtin-report.c   | 10 +++++++++-
 tools/perf/builtin-top.c      |  4 ++--
 tools/perf/tests/hists_link.c |  2 +-
 tools/perf/util/hist.c        |  5 ++++-
 tools/perf/util/hist.h        |  3 ++-
 7 files changed, 20 insertions(+), 8 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 17c6b49..6c5ae57 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -247,7 +247,7 @@ static int __cmd_annotate(struct perf_annotate *ann)
 
 		if (nr_samples > 0) {
 			total_nr_samples += nr_samples;
-			hists__collapse_resort(hists);
+			hists__collapse_resort(hists, NULL);
 			hists__output_resort(hists);
 
 			if (symbol_conf.event_group &&
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 9c82888..b605009 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -369,7 +369,7 @@ static void perf_evlist__collapse_resort(struct perf_evlist *evlist)
 	list_for_each_entry(evsel, &evlist->entries, node) {
 		struct hists *hists = &evsel->hists;
 
-		hists__collapse_resort(hists);
+		hists__collapse_resort(hists, NULL);
 	}
 }
 
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index e3598a4..98d3891 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -496,6 +496,7 @@ static int __cmd_report(struct perf_report *rep)
 	struct map *kernel_map;
 	struct kmap *kernel_kmap;
 	const char *help = "For a higher level overview, try: perf report --sort comm,dso";
+	struct ui_progress prog;
 	struct perf_data_file *file = session->file;
 
 	signal(SIGINT, sig_handler);
@@ -558,13 +559,19 @@ static int __cmd_report(struct perf_report *rep)
 	}
 
 	nr_samples = 0;
+	list_for_each_entry(pos, &session->evlist->entries, node)
+		nr_samples += pos->hists.nr_entries;
+
+	ui_progress__init(&prog, nr_samples, "Merging related events...");
+
+	nr_samples = 0;
 	list_for_each_entry(pos, &session->evlist->entries, node) {
 		struct hists *hists = &pos->hists;
 
 		if (pos->idx == 0)
 			hists->symbol_filter_str = rep->symbol_filter_str;
 
-		hists__collapse_resort(hists);
+		hists__collapse_resort(hists, &prog);
 		nr_samples += hists->stats.nr_events[PERF_RECORD_SAMPLE];
 
 		/* Non-group events are considered as leader */
@@ -576,6 +583,7 @@ static int __cmd_report(struct perf_report *rep)
 			hists__link(leader_hists, hists);
 		}
 	}
+	ui_progress__finish();
 
 	if (session_done())
 		return 0;
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 386d833..76c9264 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -286,7 +286,7 @@ static void perf_top__print_sym_table(struct perf_top *top)
 		return;
 	}
 
-	hists__collapse_resort(&top->sym_evsel->hists);
+	hists__collapse_resort(&top->sym_evsel->hists, NULL);
 	hists__output_resort(&top->sym_evsel->hists);
 	hists__decay_entries(&top->sym_evsel->hists,
 			     top->hide_user_symbols,
@@ -552,7 +552,7 @@ static void perf_top__sort_new_samples(void *arg)
 	if (t->evlist->selected != NULL)
 		t->sym_evsel = t->evlist->selected;
 
-	hists__collapse_resort(&t->sym_evsel->hists);
+	hists__collapse_resort(&t->sym_evsel->hists, NULL);
 	hists__output_resort(&t->sym_evsel->hists);
 	hists__decay_entries(&t->sym_evsel->hists,
 			     t->hide_user_symbols,
diff --git a/tools/perf/tests/hists_link.c b/tools/perf/tests/hists_link.c
index 025503a..b51abcb 100644
--- a/tools/perf/tests/hists_link.c
+++ b/tools/perf/tests/hists_link.c
@@ -467,7 +467,7 @@ int test__hists_link(void)
 		goto out;
 
 	list_for_each_entry(evsel, &evlist->entries, node) {
-		hists__collapse_resort(&evsel->hists);
+		hists__collapse_resort(&evsel->hists, NULL);
 
 		if (verbose > 2)
 			print_hists(&evsel->hists);
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index f0b863e..7e80253 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -399,6 +399,7 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
 	if (!he)
 		return NULL;
 
+	hists->nr_entries++;
 	rb_link_node(&he->rb_node_in, parent, p);
 	rb_insert_color(&he->rb_node_in, hists->entries_in);
 out:
@@ -604,7 +605,7 @@ static void hists__apply_filters(struct hists *hists, struct hist_entry *he)
 	hists__filter_entry_by_symbol(hists, he);
 }
 
-void hists__collapse_resort(struct hists *hists)
+void hists__collapse_resort(struct hists *hists, struct ui_progress *prog)
 {
 	struct rb_root *root;
 	struct rb_node *next;
@@ -631,6 +632,8 @@ void hists__collapse_resort(struct hists *hists)
 			 */
 			hists__apply_filters(hists, n);
 		}
+		if (prog)
+			ui_progress__update(prog, 1);
 	}
 }
 
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 20b1758..0c7ce8b 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -5,6 +5,7 @@
 #include <pthread.h>
 #include "callchain.h"
 #include "header.h"
+#include "ui/progress.h"
 
 extern struct callchain_param callchain_param;
 
@@ -108,7 +109,7 @@ struct hist_entry *__hists__add_mem_entry(struct hists *self,
 					  u64 weight);
 
 void hists__output_resort(struct hists *self);
-void hists__collapse_resort(struct hists *self);
+void hists__collapse_resort(struct hists *self, struct ui_progress *prog);
 
 void hists__decay_entries(struct hists *hists, bool zap_user, bool zap_kernel);
 void hists__output_recalc_col_len(struct hists *hists, int max_rows);
