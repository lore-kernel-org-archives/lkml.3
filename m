Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754372AbaHLIQK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 04:16:10 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:56195 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753868AbaHLIQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 04:16:08 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [RFC/PATCH 1/2] perf top: Fix -z option behavior
Date: Tue, 12 Aug 2014 17:16:05 +0900
Message-Id: <1407831366-28892-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.0.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The current -z option does almost nothing.  It doesn't zero the
existing samples so that we can see profiles of exited process after
last refresh.  It seems it only affects annotation.

This patch clears existing entries before processing if -z option is
given.  For this original decaying logic also moved before processing.

Reported-by: Stephane Eranian <eranian@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-top.c | 23 +++++++++++++++++------
 tools/perf/util/hist.c   | 22 ++++++++++++++++++++++
 tools/perf/util/hist.h   |  1 +
 3 files changed, 40 insertions(+), 6 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 4fb6f726271c..e486501b2067 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -276,11 +276,17 @@ static void perf_top__print_sym_table(struct perf_top *top)
 		return;
 	}
 
+	if (top->zero) {
+		hists__delete_entries(&top->sym_evsel->hists);
+	} else {
+		hists__decay_entries(&top->sym_evsel->hists,
+				     top->hide_user_symbols,
+				     top->hide_kernel_symbols);
+	}
+
 	hists__collapse_resort(&top->sym_evsel->hists, NULL);
 	hists__output_resort(&top->sym_evsel->hists);
-	hists__decay_entries(&top->sym_evsel->hists,
-			     top->hide_user_symbols,
-			     top->hide_kernel_symbols);
+
 	hists__output_recalc_col_len(&top->sym_evsel->hists,
 				     top->print_entries - printed);
 	putchar('\n');
@@ -542,11 +548,16 @@ static void perf_top__sort_new_samples(void *arg)
 	if (t->evlist->selected != NULL)
 		t->sym_evsel = t->evlist->selected;
 
+	if (t->zero) {
+		hists__delete_entries(&t->sym_evsel->hists);
+	} else {
+		hists__decay_entries(&t->sym_evsel->hists,
+				     t->hide_user_symbols,
+				     t->hide_kernel_symbols);
+	}
+
 	hists__collapse_resort(&t->sym_evsel->hists, NULL);
 	hists__output_resort(&t->sym_evsel->hists);
-	hists__decay_entries(&t->sym_evsel->hists,
-			     t->hide_user_symbols,
-			     t->hide_kernel_symbols);
 }
 
 static void *display_thread_tui(void *arg)
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 30df6187ee02..86569fa3651d 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -277,6 +277,28 @@ void hists__decay_entries(struct hists *hists, bool zap_user, bool zap_kernel)
 	}
 }
 
+void hists__delete_entries(struct hists *hists)
+{
+	struct rb_node *next = rb_first(&hists->entries);
+	struct hist_entry *n;
+
+	while (next) {
+		n = rb_entry(next, struct hist_entry, rb_node);
+		next = rb_next(&n->rb_node);
+
+		rb_erase(&n->rb_node, &hists->entries);
+
+		if (sort__need_collapse)
+			rb_erase(&n->rb_node_in, &hists->entries_collapsed);
+
+		--hists->nr_entries;
+		if (!n->filtered)
+			--hists->nr_non_filtered_entries;
+
+		hist_entry__free(n);
+	}
+}
+
 /*
  * histogram, sorted on item, collects periods
  */
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 95405a8fbd95..8c9c70e18cbb 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -152,6 +152,7 @@ void hists__output_resort(struct hists *hists);
 void hists__collapse_resort(struct hists *hists, struct ui_progress *prog);
 
 void hists__decay_entries(struct hists *hists, bool zap_user, bool zap_kernel);
+void hists__delete_entries(struct hists *hists);
 void hists__output_recalc_col_len(struct hists *hists, int max_rows);
 
 u64 hists__total_period(struct hists *hists);
-- 
2.0.0

