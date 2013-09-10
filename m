Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755816Ab3IJI0W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 04:26:22 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:45991 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754527Ab3IJIY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 04:24:26 -0400
X-AuditID: 9c93017e-b7c76ae000003897-a0-522ed734d24a
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 3/3] perf tools: Show progress on histogram collapsing
Date: Tue, 10 Sep 2013 17:24:18 +0900
Message-Id: <1378801458-2515-4-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1378801458-2515-1-git-send-email-namhyung@kernel.org>
References: <1378801458-2515-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

It can take quite amount of time so add progress bar UI to inform user.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
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
index f988d380c52f..8984db37de6f 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -231,7 +231,7 @@ static int __cmd_annotate(struct perf_annotate *ann)
 
 		if (nr_samples > 0) {
 			total_nr_samples += nr_samples;
-			hists__collapse_resort(hists);
+			hists__collapse_resort(hists, NULL);
 			hists__output_resort(hists);
 
 			if (symbol_conf.event_group &&
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index f28799e94f2a..f4ab7d210105 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -367,7 +367,7 @@ static void perf_evlist__collapse_resort(struct perf_evlist *evlist)
 	list_for_each_entry(evsel, &evlist->entries, node) {
 		struct hists *hists = &evsel->hists;
 
-		hists__collapse_resort(hists);
+		hists__collapse_resort(hists, NULL);
 	}
 }
 
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 9725aa375414..e88231cd9655 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -488,6 +488,7 @@ static int __cmd_report(struct perf_report *rep)
 	struct map *kernel_map;
 	struct kmap *kernel_kmap;
 	const char *help = "For a higher level overview, try: perf report --sort comm,dso";
+	struct perf_progress prog;
 
 	signal(SIGINT, sig_handler);
 
@@ -549,13 +550,19 @@ static int __cmd_report(struct perf_report *rep)
 	}
 
 	nr_samples = 0;
+	list_for_each_entry(pos, &session->evlist->entries, node)
+		nr_samples += pos->hists.nr_entries;
+
+	ui_progress__setup(&prog, nr_samples);
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
@@ -567,6 +574,7 @@ static int __cmd_report(struct perf_report *rep)
 			hists__link(leader_hists, hists);
 		}
 	}
+	ui_progress__finish();
 
 	if (nr_samples == 0) {
 		ui__error("The %s file has no samples!\n", session->filename);
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 212214162bb2..cabd027bd507 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -287,7 +287,7 @@ static void perf_top__print_sym_table(struct perf_top *top)
 		return;
 	}
 
-	hists__collapse_resort(&top->sym_evsel->hists);
+	hists__collapse_resort(&top->sym_evsel->hists, NULL);
 	hists__output_resort(&top->sym_evsel->hists);
 	hists__decay_entries(&top->sym_evsel->hists,
 			     top->hide_user_symbols,
@@ -553,7 +553,7 @@ static void perf_top__sort_new_samples(void *arg)
 	if (t->evlist->selected != NULL)
 		t->sym_evsel = t->evlist->selected;
 
-	hists__collapse_resort(&t->sym_evsel->hists);
+	hists__collapse_resort(&t->sym_evsel->hists, NULL);
 	hists__output_resort(&t->sym_evsel->hists);
 	hists__decay_entries(&t->sym_evsel->hists,
 			     t->hide_user_symbols,
diff --git a/tools/perf/tests/hists_link.c b/tools/perf/tests/hists_link.c
index 4228ffc0d968..3b5faaa5c8cf 100644
--- a/tools/perf/tests/hists_link.c
+++ b/tools/perf/tests/hists_link.c
@@ -465,7 +465,7 @@ int test__hists_link(void)
 		goto out;
 
 	list_for_each_entry(evsel, &evlist->entries, node) {
-		hists__collapse_resort(&evsel->hists);
+		hists__collapse_resort(&evsel->hists, NULL);
 
 		if (verbose > 2)
 			print_hists(&evsel->hists);
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 46a0d35a05e1..1f5767f97dce 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -395,6 +395,7 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
 	if (!he)
 		return NULL;
 
+	hists->nr_entries++;
 	rb_link_node(&he->rb_node_in, parent, p);
 	rb_insert_color(&he->rb_node_in, hists->entries_in);
 out:
@@ -598,7 +599,7 @@ static void hists__apply_filters(struct hists *hists, struct hist_entry *he)
 	hists__filter_entry_by_symbol(hists, he);
 }
 
-void hists__collapse_resort(struct hists *hists)
+void hists__collapse_resort(struct hists *hists, struct perf_progress *prog)
 {
 	struct rb_root *root;
 	struct rb_node *next;
@@ -623,6 +624,8 @@ void hists__collapse_resort(struct hists *hists)
 			 */
 			hists__apply_filters(hists, n);
 		}
+		if (prog)
+			ui_progress__advance(prog, 1, "Merging related events...");
 	}
 }
 
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 1329b6b6ffe6..6e27c0e9d31a 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -5,6 +5,7 @@
 #include <pthread.h>
 #include "callchain.h"
 #include "header.h"
+#include "ui/progress.h"
 
 extern struct callchain_param callchain_param;
 
@@ -104,7 +105,7 @@ struct hist_entry *__hists__add_mem_entry(struct hists *self,
 					  u64 weight);
 
 void hists__output_resort(struct hists *self);
-void hists__collapse_resort(struct hists *self);
+void hists__collapse_resort(struct hists *self, struct perf_progress *prog);
 
 void hists__decay_entries(struct hists *hists, bool zap_user, bool zap_kernel);
 void hists__output_recalc_col_len(struct hists *hists, int max_rows);
-- 
1.7.11.7

