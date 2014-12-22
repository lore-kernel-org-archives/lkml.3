Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753989AbaLVEn4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 23:43:56 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:50425 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753744AbaLVEnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 23:43:40 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH 2/7] perf report: Show progress bar for output resorting
Date: Mon, 22 Dec 2014 13:44:10 +0900
Message-Id: <1419223455-4362-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1419223455-4362-1-git-send-email-namhyung@kernel.org>
References: <1419223455-4362-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes it takes a time to resort hist entries for output in case of
a large data file.  Show a progress bar window and inform user.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-annotate.c     |  2 +-
 tools/perf/builtin-diff.c         |  2 +-
 tools/perf/builtin-report.c       | 24 ++++++++++++++++++++++--
 tools/perf/builtin-top.c          |  4 ++--
 tools/perf/tests/hists_cumulate.c |  2 +-
 tools/perf/tests/hists_filter.c   |  2 +-
 tools/perf/tests/hists_output.c   | 10 +++++-----
 tools/perf/util/hist.c            | 10 +++++++++-
 tools/perf/util/hist.h            |  2 +-
 9 files changed, 43 insertions(+), 15 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index e7417fe97a97..747f86103599 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -232,7 +232,7 @@ static int __cmd_annotate(struct perf_annotate *ann)
 		if (nr_samples > 0) {
 			total_nr_samples += nr_samples;
 			hists__collapse_resort(hists, NULL);
-			hists__output_resort(hists);
+			hists__output_resort(hists, NULL);
 
 			if (symbol_conf.event_group &&
 			    !perf_evsel__is_group_leader(pos))
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 90fd5d2f61f0..e787a4406d1f 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -605,7 +605,7 @@ static void hists__process(struct hists *hists)
 		hists__precompute(hists);
 		hists__compute_resort(hists);
 	} else {
-		hists__output_resort(hists);
+		hists__output_resort(hists, NULL);
 	}
 
 	hists__fprintf(hists, true, 0, 0, 0, stdout);
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index e2a0c2bbb3bf..2f91094e228b 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -444,6 +444,19 @@ static void report__collapse_hists(struct report *rep)
 	ui_progress__finish();
 }
 
+static void report__output_resort(struct report *rep)
+{
+	struct ui_progress prog;
+	struct perf_evsel *pos;
+
+	ui_progress__init(&prog, rep->nr_entries, "Sorting events for output...");
+
+	evlist__for_each(rep->session->evlist, pos)
+		hists__output_resort(evsel__hists(pos), &prog);
+
+	ui_progress__finish();
+}
+
 static int __cmd_report(struct report *rep)
 {
 	int ret;
@@ -495,13 +508,20 @@ static int __cmd_report(struct report *rep)
 	if (session_done())
 		return 0;
 
+	/*
+	 * recalculate number of entries after collapsing since it
+	 * might be changed during the collapse phase.
+	 */
+	rep->nr_entries = 0;
+	evlist__for_each(session->evlist, pos)
+		rep->nr_entries += evsel__hists(pos)->nr_entries;
+
 	if (rep->nr_entries == 0) {
 		ui__error("The %s file has no samples!\n", file->path);
 		return 0;
 	}
 
-	evlist__for_each(session->evlist, pos)
-		hists__output_resort(evsel__hists(pos));
+	report__output_resort(rep);
 
 	return report__browse_hists(rep);
 }
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index f1267bcf0af1..7d67e23414cc 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -285,7 +285,7 @@ static void perf_top__print_sym_table(struct perf_top *top)
 	}
 
 	hists__collapse_resort(hists, NULL);
-	hists__output_resort(hists);
+	hists__output_resort(hists, NULL);
 
 	hists__output_recalc_col_len(hists, top->print_entries - printed);
 	putchar('\n');
@@ -554,7 +554,7 @@ static void perf_top__sort_new_samples(void *arg)
 	}
 
 	hists__collapse_resort(hists, NULL);
-	hists__output_resort(hists);
+	hists__output_resort(hists, NULL);
 }
 
 static void *display_thread_tui(void *arg)
diff --git a/tools/perf/tests/hists_cumulate.c b/tools/perf/tests/hists_cumulate.c
index b6a9e2a02e46..5bb3ad42be57 100644
--- a/tools/perf/tests/hists_cumulate.c
+++ b/tools/perf/tests/hists_cumulate.c
@@ -187,7 +187,7 @@ static int do_test(struct hists *hists, struct result *expected, size_t nr_expec
 	 * function since TEST_ASSERT_VAL() returns in case of failure.
 	 */
 	hists__collapse_resort(hists, NULL);
-	hists__output_resort(hists);
+	hists__output_resort(hists, NULL);
 
 	if (verbose > 2) {
 		pr_info("use callchain: %d, cumulate callchain: %d\n",
diff --git a/tools/perf/tests/hists_filter.c b/tools/perf/tests/hists_filter.c
index 74f257a81265..59e53db7914c 100644
--- a/tools/perf/tests/hists_filter.c
+++ b/tools/perf/tests/hists_filter.c
@@ -138,7 +138,7 @@ int test__hists_filter(void)
 		struct hists *hists = evsel__hists(evsel);
 
 		hists__collapse_resort(hists, NULL);
-		hists__output_resort(hists);
+		hists__output_resort(hists, NULL);
 
 		if (verbose > 2) {
 			pr_info("Normal histogram\n");
diff --git a/tools/perf/tests/hists_output.c b/tools/perf/tests/hists_output.c
index 41328a0ed47a..b52c9faea224 100644
--- a/tools/perf/tests/hists_output.c
+++ b/tools/perf/tests/hists_output.c
@@ -152,7 +152,7 @@ static int test1(struct perf_evsel *evsel, struct machine *machine)
 		goto out;
 
 	hists__collapse_resort(hists, NULL);
-	hists__output_resort(hists);
+	hists__output_resort(hists, NULL);
 
 	if (verbose > 2) {
 		pr_info("[fields = %s, sort = %s]\n", field_order, sort_order);
@@ -252,7 +252,7 @@ static int test2(struct perf_evsel *evsel, struct machine *machine)
 		goto out;
 
 	hists__collapse_resort(hists, NULL);
-	hists__output_resort(hists);
+	hists__output_resort(hists, NULL);
 
 	if (verbose > 2) {
 		pr_info("[fields = %s, sort = %s]\n", field_order, sort_order);
@@ -306,7 +306,7 @@ static int test3(struct perf_evsel *evsel, struct machine *machine)
 		goto out;
 
 	hists__collapse_resort(hists, NULL);
-	hists__output_resort(hists);
+	hists__output_resort(hists, NULL);
 
 	if (verbose > 2) {
 		pr_info("[fields = %s, sort = %s]\n", field_order, sort_order);
@@ -384,7 +384,7 @@ static int test4(struct perf_evsel *evsel, struct machine *machine)
 		goto out;
 
 	hists__collapse_resort(hists, NULL);
-	hists__output_resort(hists);
+	hists__output_resort(hists, NULL);
 
 	if (verbose > 2) {
 		pr_info("[fields = %s, sort = %s]\n", field_order, sort_order);
@@ -487,7 +487,7 @@ static int test5(struct perf_evsel *evsel, struct machine *machine)
 		goto out;
 
 	hists__collapse_resort(hists, NULL);
-	hists__output_resort(hists);
+	hists__output_resort(hists, NULL);
 
 	if (verbose > 2) {
 		pr_info("[fields = %s, sort = %s]\n", field_order, sort_order);
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 30c49498495c..bd4a2cd73236 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -6,6 +6,7 @@
 #include "evlist.h"
 #include "evsel.h"
 #include "annotate.h"
+#include "ui/progress.h"
 #include <math.h>
 
 static bool hists__filter_entry_by_dso(struct hists *hists,
@@ -985,6 +986,7 @@ static bool hists__collapse_insert_entry(struct hists *hists __maybe_unused,
 		else
 			p = &(*p)->rb_right;
 	}
+	hists->nr_entries++;
 
 	rb_link_node(&he->rb_node_in, parent, p);
 	rb_insert_color(&he->rb_node_in, root);
@@ -1022,7 +1024,10 @@ void hists__collapse_resort(struct hists *hists, struct ui_progress *prog)
 	if (!sort__need_collapse)
 		return;
 
+	hists->nr_entries = 0;
+
 	root = hists__get_rotate_entries_in(hists);
+
 	next = rb_first(root);
 
 	while (next) {
@@ -1117,7 +1122,7 @@ static void __hists__insert_output_entry(struct rb_root *entries,
 	rb_insert_color(&he->rb_node, entries);
 }
 
-void hists__output_resort(struct hists *hists)
+void hists__output_resort(struct hists *hists, struct ui_progress *prog)
 {
 	struct rb_root *root;
 	struct rb_node *next;
@@ -1146,6 +1151,9 @@ void hists__output_resort(struct hists *hists)
 
 		if (!n->filtered)
 			hists__calc_col_len(hists, n);
+
+		if (prog)
+			ui_progress__update(prog, 1);
 	}
 }
 
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 2f9095934361..9305580cd53e 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -121,7 +121,7 @@ int hist_entry__sort_snprintf(struct hist_entry *he, char *bf, size_t size,
 			      struct hists *hists);
 void hist_entry__delete(struct hist_entry *he);
 
-void hists__output_resort(struct hists *hists);
+void hists__output_resort(struct hists *hists, struct ui_progress *prog);
 void hists__collapse_resort(struct hists *hists, struct ui_progress *prog);
 
 void hists__decay_entries(struct hists *hists, bool zap_user, bool zap_kernel);
-- 
2.1.3

