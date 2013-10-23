Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028Ab3JWVCo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 17:02:44 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55404 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441Ab3JWU62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 16:58:28 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 16/16] perf tools: Show progress on histogram collapsing
Date: Wed, 23 Oct 2013 17:58:15 -0300
Message-Id: <1382561895-8237-17-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1382561895-8237-1-git-send-email-acme@infradead.org>
References: <1382561895-8237-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

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
index 17c6b494e8cc..6c5ae57831f6 100644
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
index 9c828881714c..b605009e803f 100644
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
index e3598a456017..98d3891392e2 100644
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
index 386d83324a8d..76c9264ed070 100644
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
index 025503a22ff7..b51abcb2c243 100644
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
index f0b863ef4896..7e80253074b0 100644
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
index 20b175808cd3..0c7ce8bb8eba 100644
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
-- 
1.8.1.4

