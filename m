Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932240AbaDWHAS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 03:00:18 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:60292 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754038AbaDWHAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 03:00:10 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 2/7] perf tools: Account entry stats when it's added to the output tree
Date: Wed, 23 Apr 2014 16:00:03 +0900
Message-Id: <1398236408-8856-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398236408-8856-1-git-send-email-namhyung@kernel.org>
References: <1398236408-8856-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, accounting each sample is done in multiple places - once
when adding them to the input tree, other when adding them to the
output tree.  It's not only confusing but also can cause a subtle
problem since concurrent processing like in perf top might see the
updated stats before adding entries into the output tree - like seeing
more (blank) lines at the end and/or slight inaccurate percentage.

To fix this, only account the entries when it's moved into the output
tree so that they cannot be seen prematurely.  There're some
exceptional cases here and there - they should be addressed separately
with comments.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-annotate.c |  3 +-
 tools/perf/builtin-diff.c     | 23 ++++++++-----
 tools/perf/builtin-report.c   | 18 +++-------
 tools/perf/util/hist.c        | 78 ++++++++++++++++++++++++++-----------------
 tools/perf/util/hist.h        |  3 +-
 5 files changed, 69 insertions(+), 56 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 0da603b79b61..d30d2c2e2a7a 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -46,7 +46,7 @@ struct perf_annotate {
 };
 
 static int perf_evsel__add_sample(struct perf_evsel *evsel,
-				  struct perf_sample *sample,
+				  struct perf_sample *sample __maybe_unused,
 				  struct addr_location *al,
 				  struct perf_annotate *ann)
 {
@@ -70,7 +70,6 @@ static int perf_evsel__add_sample(struct perf_evsel *evsel,
 		return -ENOMEM;
 
 	ret = hist_entry__inc_addr_samples(he, evsel->idx, al->addr);
-	evsel->hists.stats.total_period += sample->period;
 	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
 	return ret;
 }
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 6ef80f22c1e2..f3b10dcf6838 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -341,11 +341,16 @@ static int diff__process_sample_event(struct perf_tool *tool __maybe_unused,
 		return -1;
 	}
 
-	if (al.filtered == 0) {
-		evsel->hists.stats.total_non_filtered_period += sample->period;
-		evsel->hists.nr_non_filtered_entries++;
-	}
+	/*
+	 * The total_period is updated here before going to the output
+	 * tree since normally only the baseline hists will call
+	 * hists__output_resort() and precompute needs the total
+	 * period in order to sort entries by percentage delta.
+	 */
 	evsel->hists.stats.total_period += sample->period;
+	if (!al.filtered)
+		evsel->hists.stats.total_non_filtered_period += sample->period;
+
 	return 0;
 }
 
@@ -573,10 +578,7 @@ static void hists__compute_resort(struct hists *hists)
 	hists->entries = RB_ROOT;
 	next = rb_first(root);
 
-	hists->nr_entries = 0;
-	hists->nr_non_filtered_entries = 0;
-	hists->stats.total_period = 0;
-	hists->stats.total_non_filtered_period = 0;
+	hists__reset_stats(hists);
 	hists__reset_col_len(hists);
 
 	while (next != NULL) {
@@ -586,7 +588,10 @@ static void hists__compute_resort(struct hists *hists)
 		next = rb_next(&he->rb_node_in);
 
 		insert_hist_entry_by_compute(&hists->entries, he, compute);
-		hists__inc_nr_entries(hists, he);
+		hists__inc_stats(hists, he);
+
+		if (!he->filtered)
+			hists__calc_col_len(hists, he);
 	}
 }
 
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index aed52036468d..4bdcc040b216 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -85,6 +85,10 @@ static void report__inc_stats(struct report *rep, struct hist_entry *he)
 	 */
 	if (he->stat.nr_events == 1)
 		rep->nr_entries++;
+
+	hists__inc_nr_events(he->hists, PERF_RECORD_SAMPLE);
+	if (!he->filtered)
+		he->hists->stats.nr_non_filtered_samples++;
 }
 
 static int report__add_mem_hist_entry(struct report *rep, struct addr_location *al,
@@ -135,10 +139,6 @@ static int report__add_mem_hist_entry(struct report *rep, struct addr_location *
 
 	report__inc_stats(rep, he);
 
-	evsel->hists.stats.total_period += cost;
-	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
-	if (!he->filtered)
-		evsel->hists.stats.nr_non_filtered_samples++;
 	err = hist_entry__append_callchain(he, sample);
 out:
 	return err;
@@ -189,13 +189,7 @@ static int report__add_branch_hist_entry(struct report *rep, struct addr_locatio
 				if (err)
 					goto out;
 			}
-
 			report__inc_stats(rep, he);
-
-			evsel->hists.stats.total_period += 1;
-			hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
-			if (!he->filtered)
-				evsel->hists.stats.nr_non_filtered_samples++;
 		} else
 			goto out;
 	}
@@ -230,10 +224,6 @@ static int report__add_hist_entry(struct report *rep, struct perf_evsel *evsel,
 
 	report__inc_stats(rep, he);
 
-	evsel->hists.stats.total_period += sample->period;
-	if (!he->filtered)
-		evsel->hists.stats.nr_non_filtered_samples++;
-	hists__inc_nr_events(&evsel->hists, PERF_RECORD_SAMPLE);
 out:
 	return err;
 }
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 5a892477aa50..3ebc3cd09f42 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -317,17 +317,6 @@ static struct hist_entry *hist_entry__new(struct hist_entry *template)
 	return he;
 }
 
-void hists__inc_nr_entries(struct hists *hists, struct hist_entry *h)
-{
-	if (!h->filtered) {
-		hists__calc_col_len(hists, h);
-		hists->nr_non_filtered_entries++;
-		hists->stats.total_non_filtered_period += h->stat.period;
-	}
-	hists->nr_entries++;
-	hists->stats.total_period += h->stat.period;
-}
-
 static u8 symbol__parent_filter(const struct symbol *parent)
 {
 	if (symbol_conf.exclude_other && parent == NULL)
@@ -393,7 +382,6 @@ static struct hist_entry *add_hist_entry(struct hists *hists,
 	if (!he)
 		return NULL;
 
-	hists->nr_entries++;
 	rb_link_node(&he->rb_node_in, parent, p);
 	rb_insert_color(&he->rb_node_in, hists->entries_in);
 out:
@@ -659,6 +647,35 @@ static void __hists__insert_output_entry(struct rb_root *entries,
 	rb_insert_color(&he->rb_node, entries);
 }
 
+static void hists__reset_filter_stats(struct hists *hists)
+{
+	hists->nr_non_filtered_entries = 0;
+	hists->stats.total_non_filtered_period = 0;
+}
+
+void hists__reset_stats(struct hists *hists)
+{
+	hists->nr_entries = 0;
+	hists->stats.total_period = 0;
+
+	hists__reset_filter_stats(hists);
+}
+
+static void hists__inc_filter_stats(struct hists *hists, struct hist_entry *he)
+{
+	hists->nr_non_filtered_entries++;
+	hists->stats.total_non_filtered_period += he->stat.period;
+}
+
+void hists__inc_stats(struct hists *hists, struct hist_entry *he)
+{
+	if (!he->filtered)
+		hists__inc_filter_stats(hists, he);
+
+	hists->nr_entries++;
+	hists->stats.total_period += he->stat.period;
+}
+
 void hists__output_resort(struct hists *hists)
 {
 	struct rb_root *root;
@@ -676,9 +693,7 @@ void hists__output_resort(struct hists *hists)
 	next = rb_first(root);
 	hists->entries = RB_ROOT;
 
-	hists->nr_non_filtered_entries = 0;
-	hists->stats.total_period = 0;
-	hists->stats.total_non_filtered_period = 0;
+	hists__reset_stats(hists);
 	hists__reset_col_len(hists);
 
 	while (next) {
@@ -686,7 +701,10 @@ void hists__output_resort(struct hists *hists)
 		next = rb_next(&n->rb_node_in);
 
 		__hists__insert_output_entry(&hists->entries, n, min_callchain_hits);
-		hists__inc_nr_entries(hists, n);
+		hists__inc_stats(hists, n);
+
+		if (!n->filtered)
+			hists__calc_col_len(hists, n);
 	}
 }
 
@@ -697,13 +715,13 @@ static void hists__remove_entry_filter(struct hists *hists, struct hist_entry *h
 	if (h->filtered)
 		return;
 
-	++hists->nr_non_filtered_entries;
-	if (h->ms.unfolded)
-		hists->nr_non_filtered_entries += h->nr_rows;
+	/* force fold unfiltered entry for simplicity */
+	h->ms.unfolded = false;
 	h->row_offset = 0;
-	hists->stats.total_non_filtered_period += h->stat.period;
+
 	hists->stats.nr_non_filtered_samples += h->stat.nr_events;
 
+	hists__inc_filter_stats(hists, h);
 	hists__calc_col_len(hists, h);
 }
 
@@ -724,11 +742,11 @@ void hists__filter_by_dso(struct hists *hists)
 {
 	struct rb_node *nd;
 
-	hists->nr_non_filtered_entries = 0;
-	hists->stats.total_non_filtered_period = 0;
-	hists->stats.nr_non_filtered_samples = 0;
+	hists__reset_filter_stats(hists);
 	hists__reset_col_len(hists);
 
+	hists->stats.nr_non_filtered_samples = 0;
+
 	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
 		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
 
@@ -758,11 +776,11 @@ void hists__filter_by_thread(struct hists *hists)
 {
 	struct rb_node *nd;
 
-	hists->nr_non_filtered_entries = 0;
-	hists->stats.total_non_filtered_period = 0;
-	hists->stats.nr_non_filtered_samples = 0;
+	hists__reset_filter_stats(hists);
 	hists__reset_col_len(hists);
 
+	hists->stats.nr_non_filtered_samples = 0;
+
 	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
 		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
 
@@ -790,11 +808,11 @@ void hists__filter_by_symbol(struct hists *hists)
 {
 	struct rb_node *nd;
 
-	hists->nr_non_filtered_entries = 0;
-	hists->stats.total_non_filtered_period = 0;
-	hists->stats.nr_non_filtered_samples = 0;
+	hists__reset_filter_stats(hists);
 	hists__reset_col_len(hists);
 
+	hists->stats.nr_non_filtered_samples = 0;
+
 	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
 		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
 
@@ -853,7 +871,7 @@ static struct hist_entry *hists__add_dummy_entry(struct hists *hists,
 		he->hists = hists;
 		rb_link_node(&he->rb_node_in, parent, p);
 		rb_insert_color(&he->rb_node_in, root);
-		hists__inc_nr_entries(hists, he);
+		hists__inc_stats(hists, he);
 		he->dummy = true;
 	}
 out:
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 5a0343eb22e2..ef1ad7a948c0 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -116,7 +116,8 @@ void hists__decay_entries(struct hists *hists, bool zap_user, bool zap_kernel);
 void hists__output_recalc_col_len(struct hists *hists, int max_rows);
 
 u64 hists__total_period(struct hists *hists);
-void hists__inc_nr_entries(struct hists *hists, struct hist_entry *h);
+void hists__reset_stats(struct hists *hists);
+void hists__inc_stats(struct hists *hists, struct hist_entry *h);
 void hists__inc_nr_events(struct hists *hists, u32 type);
 void events_stats__inc(struct events_stats *stats, u32 type);
 size_t events_stats__fprintf(struct events_stats *stats, FILE *fp);
-- 
1.9.2

