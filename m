Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283AbaBBVnp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 16:43:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:13330 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752895AbaBBVke (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 16:40:34 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 21/22] perf tools: Add raw info into hist entry
Date: Sun,  2 Feb 2014 22:39:09 +0100
Message-Id: <1391377150-23920-22-git-send-email-jolsa@redhat.com>
In-Reply-To: <1391377150-23920-1-git-send-email-jolsa@redhat.com>
References: <1391377150-23920-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding support to store raw info into hist entry,
so we could use it for entries sorting and display.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/perf/builtin-annotate.c |  4 ++--
 tools/perf/builtin-diff.c     |  4 ++--
 tools/perf/builtin-report.c   | 31 ++++++++++++++++++++++++++++++-
 tools/perf/tests/hists_link.c |  6 ++++--
 tools/perf/util/hist.c        | 21 +++++++++++++++------
 tools/perf/util/hist.h        |  7 +++++--
 tools/perf/util/sort.h        |  6 ++++++
 7 files changed, 64 insertions(+), 15 deletions(-)

diff --git a/tools/perf/builtin-annotate.c b/tools/perf/builtin-annotate.c
index 875c117..2f3ea9f 100644
--- a/tools/perf/builtin-annotate.c
+++ b/tools/perf/builtin-annotate.c
@@ -65,8 +65,8 @@ static int perf_evsel__add_sample(struct perf_evsel *evsel,
 		return 0;
 	}
 
-	he = __hists__add_entry(&evsel->hists, al, NULL, NULL, NULL, 1, 1, 0, 0,
-				true);
+	he = __hists__add_entry(&evsel->hists, al, NULL, NULL, NULL, NULL,
+				1, 1, 0, 0, true);
 	if (he == NULL)
 		return -ENOMEM;
 
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index 92faed5..0b001d9 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -307,8 +307,8 @@ static int hists__add_entry(struct hists *hists,
 			    struct addr_location *al, u64 period,
 			    u64 weight, u64 transaction)
 {
-	if (__hists__add_entry(hists, al, NULL, NULL, NULL, period, weight,
-			       transaction, 0, true) != NULL)
+	if (__hists__add_entry(hists, al, NULL, NULL, NULL, NULL,
+			       period, weight, transaction, 0, true) != NULL)
 		return 0;
 	return -ENOMEM;
 }
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index a752687..0938c4e 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -47,6 +47,7 @@ struct report {
 	bool			dont_use_callchains;
 	bool			show_full_info;
 	bool			show_threads;
+	bool			raw_info;
 	bool			inverted_callchain;
 	bool			mem_mode;
 	bool			header;
@@ -108,6 +109,23 @@ out:
 	return err;
 }
 
+static int get_raw_info(struct raw_info **rawp, struct perf_sample *sample)
+{
+	struct raw_info *raw;
+
+	if (!sample->raw_data)
+		return 0;
+
+	raw = malloc(sizeof(*raw) + sample->raw_size);
+	if (raw) {
+		memcpy(&raw->data, sample->raw_data, sample->raw_size);
+		raw->size = sample->raw_size;
+	}
+
+	*rawp = raw;
+	return raw ? 0 : -ENOMEM;
+}
+
 static int process_sample_event(struct perf_tool *tool,
 				union perf_event *event,
 				struct perf_sample *sample,
@@ -119,6 +137,7 @@ static int process_sample_event(struct perf_tool *tool,
 	struct hist_entry_iter iter = {
 		.hide_unresolved = rep->hide_unresolved,
 	};
+	struct raw_info *raw = NULL;
 	int ret;
 
 	if (perf_event__preprocess_sample(event, machine, &al, sample) < 0) {
@@ -133,6 +152,12 @@ static int process_sample_event(struct perf_tool *tool,
 	if (rep->cpu_list && !test_bit(sample->cpu, rep->cpu_bitmap))
 		return 0;
 
+	if (rep->raw_info) {
+		ret = get_raw_info(&raw, sample);
+		if (ret)
+			return ret;
+	}
+
 	if (sort__mode == SORT_MODE__BRANCH)
 		iter.ops = &hist_iter_branch;
 	else if (rep->mem_mode == 1)
@@ -145,13 +170,17 @@ static int process_sample_event(struct perf_tool *tool,
 		iter.add_entry_cb = hist_iter_cb;
 	}
 
+	iter.raw = raw;
+
 	if (al.map != NULL)
 		al.map->dso->hit = 1;
 
 	ret = hist_entry_iter__add(&iter, &al, evsel, event, sample,
 				   rep->max_stack, NULL);
-	if (ret < 0)
+	if (ret < 0) {
 		pr_debug("problem adding hist entry, skipping event\n");
+		free(raw);
+	}
 
 	return ret;
 }
diff --git a/tools/perf/tests/hists_link.c b/tools/perf/tests/hists_link.c
index e3bc8a8..3eb56c57 100644
--- a/tools/perf/tests/hists_link.c
+++ b/tools/perf/tests/hists_link.c
@@ -223,7 +223,8 @@ static int add_hist_entries(struct perf_evlist *evlist, struct machine *machine)
 				goto out;
 
 			he = __hists__add_entry(&evsel->hists, &al, NULL,
-						NULL, NULL, 1, 1, 0, 0, true);
+						NULL, NULL, NULL, 1, 1, 0, 0,
+						true);
 			if (he == NULL)
 				goto out;
 
@@ -246,7 +247,8 @@ static int add_hist_entries(struct perf_evlist *evlist, struct machine *machine)
 				goto out;
 
 			he = __hists__add_entry(&evsel->hists, &al, NULL,
-						NULL, NULL, 1, 1, 0, 0, true);
+						NULL, NULL, NULL, 1, 1, 0, 0,
+						true);
 			if (he == NULL)
 				goto out;
 
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 794d0cb..207437b 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -450,6 +450,7 @@ struct hist_entry *__hists__add_entry(struct hists *hists,
 				      struct symbol *sym_parent,
 				      struct branch_info *bi,
 				      struct mem_info *mi,
+				      struct raw_info *raw,
 				      u64 period, u64 weight, u64 transaction,
 				      u64 t, bool sample_self)
 {
@@ -474,6 +475,7 @@ struct hist_entry *__hists__add_entry(struct hists *hists,
 		.hists	= hists,
 		.branch_info = bi,
 		.mem_info = mi,
+		.raw_info = raw,
 		.transaction = transaction,
 		.time = t,
 		.idx  = idx++,
@@ -535,8 +537,8 @@ iter_add_single_mem_entry(struct hist_entry_iter *iter, struct addr_location *al
 	 * and this is indirectly achieved by passing period=weight here
 	 * and the he_stat__add_period() function.
 	 */
-	he = __hists__add_entry(&iter->evsel->hists, al, iter->parent, NULL, mi,
-				cost, cost, 0, 0, true);
+	he = __hists__add_entry(&iter->evsel->hists, al, iter->parent, NULL,
+				mi, NULL, cost, cost, 0, 0, true);
 	if (!he)
 		return -ENOMEM;
 
@@ -647,7 +649,8 @@ iter_add_next_branch_entry(struct hist_entry_iter *iter, struct addr_location *a
 	 * The report shows the percentage of total branches captured
 	 * and not events sampled. Thus we use a pseudo period of 1.
 	 */
-	he = __hists__add_entry(&evsel->hists, al, iter->parent, &bi[i], NULL,
+	he = __hists__add_entry(&evsel->hists, al, iter->parent,
+				&bi[i], NULL, NULL,
 				1, 1, 0, 0, true);
 	if (he == NULL)
 		return -ENOMEM;
@@ -692,7 +695,8 @@ iter_add_single_normal_entry(struct hist_entry_iter *iter, struct addr_location
 	struct perf_sample *sample = iter->sample;
 	struct hist_entry *he;
 
-	he = __hists__add_entry(&evsel->hists, al, iter->parent, NULL, NULL,
+	he = __hists__add_entry(&evsel->hists, al, iter->parent,
+				NULL, NULL, iter->raw,
 				sample->period, sample->weight,
 				sample->transaction, sample->time, true);
 	if (he == NULL)
@@ -748,7 +752,8 @@ iter_add_single_cumulative_entry(struct hist_entry_iter *iter,
 	struct hist_entry **he_cache = iter->priv;
 	struct hist_entry *he;
 
-	he = __hists__add_entry(&evsel->hists, al, iter->parent, NULL, NULL,
+	he = __hists__add_entry(&evsel->hists, al, iter->parent,
+				NULL, NULL, iter->raw,
 				sample->period, sample->weight,
 				sample->transaction, sample->time, true);
 	if (he == NULL)
@@ -803,6 +808,8 @@ iter_add_next_cumulative_entry(struct hist_entry_iter *iter,
 	int i;
 	struct callchain_cursor cursor;
 
+	he_tmp.raw_info = iter->raw;
+
 	callchain_cursor_snapshot(&cursor, &callchain_cursor);
 
 	callchain_cursor_advance(&callchain_cursor);
@@ -819,7 +826,8 @@ iter_add_next_cumulative_entry(struct hist_entry_iter *iter,
 		}
 	}
 
-	he = __hists__add_entry(&evsel->hists, al, iter->parent, NULL, NULL,
+	he = __hists__add_entry(&evsel->hists, al, iter->parent,
+				NULL, NULL, iter->raw,
 				sample->period, sample->weight,
 				sample->transaction, sample->time, false);
 	if (he == NULL)
@@ -961,6 +969,7 @@ hist_entry__collapse(struct hist_entry *left, struct hist_entry *right)
 
 void hist_entry__free(struct hist_entry *he)
 {
+	zfree(&he->raw_info);
 	zfree(&he->branch_info);
 	zfree(&he->mem_info);
 	zfree(&he->stat_acc);
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index c2f4bd1..ef64144 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -13,6 +13,7 @@ extern struct callchain_param callchain_param;
 struct hist_entry;
 struct addr_location;
 struct symbol;
+struct raw_info;
 
 enum hist_filter {
 	HIST_FILTER__DSO,
@@ -117,6 +118,7 @@ struct hist_entry_iter {
 	struct perf_sample *sample;
 	struct hist_entry *he;
 	struct symbol *parent;
+	struct raw_info *raw;
 	void *priv;
 
 	const struct hist_iter_ops *ops;
@@ -134,8 +136,9 @@ struct hist_entry *__hists__add_entry(struct hists *hists,
 				      struct addr_location *al,
 				      struct symbol *parent,
 				      struct branch_info *bi,
-				      struct mem_info *mi, u64 period,
-				      u64 weight, u64 transaction,
+				      struct mem_info *mi,
+				      struct raw_info *raw,
+				      u64 period, u64 weight, u64 transaction,
 				      u64 time, bool sample_self);
 int hist_entry_iter__add(struct hist_entry_iter *iter, struct addr_location *al,
 			 struct perf_evsel *evsel, const union perf_event *event,
diff --git a/tools/perf/util/sort.h b/tools/perf/util/sort.h
index 77454ee..19b0278 100644
--- a/tools/perf/util/sort.h
+++ b/tools/perf/util/sort.h
@@ -67,6 +67,11 @@ struct hist_entry_diff {
 	s64	wdiff;
 };
 
+struct raw_info {
+	unsigned int	size;
+	unsigned char	data[];
+};
+
 /**
  * struct hist_entry - histogram entry
  *
@@ -111,6 +116,7 @@ struct hist_entry {
 	struct branch_info	*branch_info;
 	struct hists		*hists;
 	struct mem_info		*mem_info;
+	struct raw_info		*raw_info;
 	struct callchain_root	callchain[0]; /* must be last member */
 };
 
-- 
1.8.3.1

