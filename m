Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187AbaBXIJg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 03:09:36 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:45694 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264AbaBXIJd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 03:09:33 -0500
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 3/8] perf report: Add --percentage option
Date: Mon, 24 Feb 2014 17:09:23 +0900
Message-Id: <1393229368-31412-4-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1393229368-31412-1-git-send-email-namhyung@kernel.org>
References: <1393229368-31412-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The --percentage option is for controlling overhead percentage
displayed.  It can only receive either of "relative" or "absolute".

"relative" means it's relative to filtered entries only so that the
sum of shown entries will be always 100%.  "absolute" means it retains
the original value before and after the filter is applied.

  $ perf report -s comm
  # Overhead       Command
  # ........  ............
  #
      74.19%           cc1
       7.61%           gcc
       6.11%            as
       4.35%            sh
       4.14%          make
       1.13%        fixdep
  ...

  $ perf report -s comm -c cc1,gcc --percentage absolute
  # Overhead       Command
  # ........  ............
  #
      74.19%           cc1
       7.61%           gcc

  $ perf report -s comm -c cc1,gcc --percentage relative
  # Overhead       Command
  # ........  ............
  #
      90.69%           cc1
       9.31%           gcc

Note that it has zero effect if no filter was applied.

Suggested-by: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Documentation/perf-report.txt | 24 +++++++++++++-----
 tools/perf/builtin-report.c              | 30 ++++++++++++++++++++--
 tools/perf/ui/browsers/hists.c           | 43 ++++++++++++++++++++++++--------
 tools/perf/ui/gtk/hists.c                | 19 +++++++-------
 tools/perf/ui/hist.c                     |  8 +++---
 tools/perf/util/hist.c                   | 29 ++++++++++-----------
 tools/perf/util/hist.h                   |  1 +
 tools/perf/util/symbol.c                 |  1 +
 tools/perf/util/symbol.h                 |  3 ++-
 9 files changed, 109 insertions(+), 49 deletions(-)

diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 8eab8a4bdeb8..09af66298564 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -25,10 +25,6 @@ OPTIONS
 --verbose::
         Be more verbose. (show symbol address, etc)
 
--d::
---dsos=::
-	Only consider symbols in these dsos. CSV that understands
-	file://filename entries.
 -n::
 --show-nr-samples::
 	Show the number of samples for each symbol
@@ -42,11 +38,18 @@ OPTIONS
 -c::
 --comms=::
 	Only consider symbols in these comms. CSV that understands
-	file://filename entries.
+	file://filename entries.  This option will affect the percentage of
+	the overhead column.  See --percentage for more info.
+-d::
+--dsos=::
+	Only consider symbols in these dsos. CSV that understands
+	file://filename entries.  This option will affect the percentage of
+	the overhead column.  See --percentage for more info.
 -S::
 --symbols=::
 	Only consider these symbols. CSV that understands
-	file://filename entries.
+	file://filename entries.  This option will affect the percentage of
+	the overhead column.  See --percentage for more info.
 
 --symbol-filter=::
 	Only show symbols that match (partially) with this filter.
@@ -237,6 +240,15 @@ OPTIONS
 	Do not show entries which have an overhead under that percent.
 	(Default: 0).
 
+--percentage::
+	Determine how to display the overhead percentage of filtered entries.
+	Filters can be applied by --comms, --dsos and/or --symbols options and
+	Zoom operations on the TUI (thread, dso, etc).
+
+	"relative" means it's relative to filtered entries only so that the
+	sum of shown entries will be always 100%.  "absolute" means it retains
+	the original value before and after the filter is applied.
+
 --header::
 	Show header information in the perf.data file.  This includes
 	various information like hostname, OS and perf version, cpu/mem
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 3f8478603d51..2385e694c8c2 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -335,6 +335,11 @@ static size_t hists__fprintf_nr_sample_events(struct hists *hists, struct report
 	char buf[512];
 	size_t size = sizeof(buf);
 
+	if (symbol_conf.filter_relative) {
+		nr_samples = hists->stats.nr_filtered_samples;
+		nr_events = hists->stats.total_filtered_period;
+	}
+
 	if (perf_evsel__is_group_event(evsel)) {
 		struct perf_evsel *pos;
 
@@ -342,8 +347,13 @@ static size_t hists__fprintf_nr_sample_events(struct hists *hists, struct report
 		evname = buf;
 
 		for_each_group_member(pos, evsel) {
-			nr_samples += pos->hists.stats.nr_events[PERF_RECORD_SAMPLE];
-			nr_events += pos->hists.stats.total_period;
+			if (symbol_conf.filter_relative) {
+				nr_samples += pos->hists.stats.nr_filtered_samples;
+				nr_events += pos->hists.stats.total_filtered_period;
+			} else {
+				nr_samples += pos->hists.stats.nr_events[PERF_RECORD_SAMPLE];
+				nr_events += pos->hists.stats.total_period;
+			}
 		}
 	}
 
@@ -699,6 +709,20 @@ parse_percent_limit(const struct option *opt, const char *str,
 	return 0;
 }
 
+static int
+parse_percentage(const struct option *opt __maybe_unused, const char *str,
+		 int unset __maybe_unused)
+{
+	if (!strcmp(str, "relative"))
+		symbol_conf.filter_relative = true;
+	else if (!strcmp(str, "absolute"))
+		symbol_conf.filter_relative = false;
+	else
+		return -1;
+
+	return 0;
+}
+
 int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 {
 	struct perf_session *session;
@@ -821,6 +845,8 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_BOOLEAN(0, "mem-mode", &report.mem_mode, "mem access profile"),
 	OPT_CALLBACK(0, "percent-limit", &report, "percent",
 		     "Don't show entries under that percent", parse_percent_limit),
+	OPT_CALLBACK(0, "percentage", NULL, "relative|absolute",
+		     "how to display percentage of filtered entries", parse_percentage),
 	OPT_END()
 	};
 	struct perf_data_file file = {
diff --git a/tools/perf/ui/browsers/hists.c b/tools/perf/ui/browsers/hists.c
index b720b92eba6e..c4251af43bd2 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -604,9 +604,10 @@ static int __hpp__color_fmt(struct perf_hpp *hpp, struct hist_entry *he,
 	double percent = 0.0;
 	struct hists *hists = he->hists;
 	struct hpp_arg *arg = hpp->ptr;
+	u64 total = hists__total_period(hists);
 
-	if (hists->stats.total_period)
-		percent = 100.0 * get_field(he) / hists->stats.total_period;
+	if (total)
+		percent = 100.0 * get_field(he) / total;
 
 	ui_browser__set_percent_color(arg->b, percent, arg->current_entry);
 
@@ -629,7 +630,8 @@ static int __hpp__color_fmt(struct perf_hpp *hpp, struct hist_entry *he,
 
 		list_for_each_entry(pair, &he->pairs.head, pairs.node) {
 			u64 period = get_field(pair);
-			u64 total = pair->hists->stats.total_period;
+
+			total = hists__total_period(pair->hists);
 
 			if (!total)
 				continue;
@@ -811,12 +813,15 @@ static unsigned int hist_browser__refresh(struct ui_browser *browser)
 
 	for (nd = browser->top; nd; nd = rb_next(nd)) {
 		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
-		float percent = h->stat.period * 100.0 /
-					hb->hists->stats.total_period;
+		u64 total = hists__total_period(h->hists);
+		float percent = 0.0;
 
 		if (h->filtered)
 			continue;
 
+		if (total)
+			percent = h->stat.period * 100.0 / total;
+
 		if (percent < hb->min_pcnt)
 			continue;
 
@@ -834,8 +839,11 @@ static struct rb_node *hists__filter_entries(struct rb_node *nd,
 {
 	while (nd != NULL) {
 		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
-		float percent = h->stat.period * 100.0 /
-					hists->stats.total_period;
+		u64 total = hists__total_period(hists);
+		float percent = 0.0;
+
+		if (total)
+			percent = h->stat.period * 100.0 / total;
 
 		if (percent < min_pcnt)
 			return NULL;
@@ -855,8 +863,11 @@ static struct rb_node *hists__filter_prev_entries(struct rb_node *nd,
 {
 	while (nd != NULL) {
 		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
-		float percent = h->stat.period * 100.0 /
-					hists->stats.total_period;
+		u64 total = hists__total_period(hists);
+		float percent = 0.0;
+
+		if (total)
+			percent = h->stat.period * 100.0 / total;
 
 		if (!h->filtered && percent >= min_pcnt)
 			return nd;
@@ -1231,6 +1242,11 @@ static int hists__browser_title(struct hists *hists, char *bf, size_t size,
 	char buf[512];
 	size_t buflen = sizeof(buf);
 
+	if (symbol_conf.filter_relative) {
+		nr_samples = hists->stats.nr_filtered_samples;
+		nr_events = hists->stats.total_filtered_period;
+	}
+
 	if (perf_evsel__is_group_event(evsel)) {
 		struct perf_evsel *pos;
 
@@ -1238,8 +1254,13 @@ static int hists__browser_title(struct hists *hists, char *bf, size_t size,
 		ev_name = buf;
 
 		for_each_group_member(pos, evsel) {
-			nr_samples += pos->hists.stats.nr_events[PERF_RECORD_SAMPLE];
-			nr_events += pos->hists.stats.total_period;
+			if (symbol_conf.filter_relative) {
+				nr_samples += pos->hists.stats.nr_filtered_samples;
+				nr_events += pos->hists.stats.total_filtered_period;
+			} else {
+				nr_samples += pos->hists.stats.nr_events[PERF_RECORD_SAMPLE];
+				nr_events += pos->hists.stats.total_period;
+			}
 		}
 	}
 
diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
index 5b95c44f3435..b787decf54b8 100644
--- a/tools/perf/ui/gtk/hists.c
+++ b/tools/perf/ui/gtk/hists.c
@@ -33,9 +33,10 @@ static int __hpp__color_fmt(struct perf_hpp *hpp, struct hist_entry *he,
 	double percent = 0.0;
 	struct hists *hists = he->hists;
 	struct perf_evsel *evsel = hists_to_evsel(hists);
+	u64 total = hists__total_period(hists);
 
-	if (hists->stats.total_period)
-		percent = 100.0 * get_field(he) / hists->stats.total_period;
+	if (total)
+		percent = 100.0 * get_field(he) / total;
 
 	ret = __percent_color_snprintf(hpp->buf, hpp->size, percent);
 
@@ -48,7 +49,8 @@ static int __hpp__color_fmt(struct perf_hpp *hpp, struct hist_entry *he,
 
 		list_for_each_entry(pair, &he->pairs.head, pairs.node) {
 			u64 period = get_field(pair);
-			u64 total = pair->hists->stats.total_period;
+
+			total = hists__total_period(pair->hists);
 
 			evsel = hists_to_evsel(pair->hists);
 			idx_delta = perf_evsel__group_idx(evsel) - prev_idx - 1;
@@ -280,12 +282,15 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists,
 	for (nd = rb_first(&hists->entries); nd; nd = rb_next(nd)) {
 		struct hist_entry *h = rb_entry(nd, struct hist_entry, rb_node);
 		GtkTreeIter iter;
-		float percent = h->stat.period * 100.0 /
-					hists->stats.total_period;
+		u64 total = hists__total_period(h->hists);
+		float percent = 0.0;
 
 		if (h->filtered)
 			continue;
 
+		if (total)
+			percent = h->stat.period * 100.0 / total;
+
 		if (percent < min_pcnt)
 			continue;
 
@@ -313,12 +318,8 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists,
 		}
 
 		if (symbol_conf.use_callchain && sort__has_sym) {
-			u64 total;
-
 			if (callchain_param.mode == CHAIN_GRAPH_REL)
 				total = h->stat.period;
-			else
-				total = hists->stats.total_period;
 
 			perf_gtk__add_callchain(&h->sorted_chain, store, &iter,
 						sym_col, total);
diff --git a/tools/perf/ui/hist.c b/tools/perf/ui/hist.c
index 78f4c92e9b73..85dddbff4678 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -21,10 +21,10 @@ static int __hpp__fmt(struct perf_hpp *hpp, struct hist_entry *he,
 
 	if (fmt_percent) {
 		double percent = 0.0;
+		u64 total = hists__total_period(hists);
 
-		if (hists->stats.total_period)
-			percent = 100.0 * get_field(he) /
-				  hists->stats.total_period;
+		if (total)
+			percent = 100.0 * get_field(he) / total;
 
 		ret = print_fn(hpp->buf, hpp->size, fmt, percent);
 	} else
@@ -39,7 +39,7 @@ static int __hpp__fmt(struct perf_hpp *hpp, struct hist_entry *he,
 
 		list_for_each_entry(pair, &he->pairs.head, pairs.node) {
 			u64 period = get_field(pair);
-			u64 total = pair->hists->stats.total_period;
+			u64 total = hists__total_period(pair->hists);
 
 			if (!total)
 				continue;
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 743947d891bd..7d72deb96b77 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -321,10 +321,11 @@ void hists__inc_nr_entries(struct hists *hists, struct hist_entry *h)
 {
 	if (!h->filtered) {
 		hists__calc_col_len(hists, h);
-		++hists->nr_entries;
-		hists->stats.total_period += h->stat.period;
+		hists->nr_filtered_entries++;
 		hists->stats.total_filtered_period += h->stat.period;
 	}
+	hists->nr_entries++;
+	hists->stats.total_period += h->stat.period;
 }
 
 static u8 symbol__parent_filter(const struct symbol *parent)
@@ -675,8 +676,9 @@ void hists__output_resort(struct hists *hists)
 	next = rb_first(root);
 	hists->entries = RB_ROOT;
 
-	hists->nr_entries = hists->nr_filtered_entries = 0;
-	hists->stats.total_period = hists->stats.total_filtered_period = 0;
+	hists->nr_filtered_entries = 0;
+	hists->stats.total_period = 0;
+	hists->stats.total_filtered_period = 0;
 	hists__reset_col_len(hists);
 
 	while (next) {
@@ -695,16 +697,11 @@ static void hists__remove_entry_filter(struct hists *hists, struct hist_entry *h
 	if (h->filtered)
 		return;
 
-	hists->nr_entries++;
 	hists->nr_filtered_entries++;
-	if (h->ms.unfolded) {
-		hists->nr_entries += h->nr_rows;
+	if (h->ms.unfolded)
 		hists->nr_filtered_entries += h->nr_rows;
-	}
 	h->row_offset = 0;
-	hists->stats.total_period += h->stat.period;
 	hists->stats.total_filtered_period += h->stat.period;
-	hists->stats.nr_events[PERF_RECORD_SAMPLE] += h->stat.nr_events;
 	hists->stats.nr_filtered_samples += h->stat.nr_events;
 
 	hists__calc_col_len(hists, h);
@@ -727,9 +724,7 @@ void hists__filter_by_dso(struct hists *hists)
 {
 	struct rb_node *nd;
 
-	hists->nr_entries = hists->stats.total_period = 0;
 	hists->nr_filtered_entries = hists->stats.total_filtered_period = 0;
-	hists->stats.nr_events[PERF_RECORD_SAMPLE] = 0;
 	hists->stats.nr_filtered_samples = 0;
 	hists__reset_col_len(hists);
 
@@ -762,9 +757,7 @@ void hists__filter_by_thread(struct hists *hists)
 {
 	struct rb_node *nd;
 
-	hists->nr_entries = hists->stats.total_period = 0;
 	hists->nr_filtered_entries = hists->stats.total_filtered_period = 0;
-	hists->stats.nr_events[PERF_RECORD_SAMPLE] = 0;
 	hists->stats.nr_filtered_samples = 0;
 	hists__reset_col_len(hists);
 
@@ -795,9 +788,7 @@ void hists__filter_by_symbol(struct hists *hists)
 {
 	struct rb_node *nd;
 
-	hists->nr_entries = hists->stats.total_period = 0;
 	hists->nr_filtered_entries = hists->stats.total_filtered_period = 0;
-	hists->stats.nr_events[PERF_RECORD_SAMPLE] = 0;
 	hists->stats.nr_filtered_samples = 0;
 	hists__reset_col_len(hists);
 
@@ -943,3 +934,9 @@ int hists__link(struct hists *leader, struct hists *other)
 
 	return 0;
 }
+
+u64 hists__total_period(struct hists *hists)
+{
+	return symbol_conf.filter_relative ? hists->stats.total_filtered_period :
+		hists->stats.total_period;
+}
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 2f5686f4031b..70052f30e907 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -115,6 +115,7 @@ void hists__collapse_resort(struct hists *hists, struct ui_progress *prog);
 void hists__decay_entries(struct hists *hists, bool zap_user, bool zap_kernel);
 void hists__output_recalc_col_len(struct hists *hists, int max_rows);
 
+u64 hists__total_period(struct hists *hists);
 void hists__inc_nr_entries(struct hists *hists, struct hist_entry *h);
 void hists__inc_nr_events(struct hists *hists, u32 type);
 void events_stats__inc(struct events_stats *stats, u32 type);
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 46e2ede12c51..f2382f2ff2f0 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -33,6 +33,7 @@ struct symbol_conf symbol_conf = {
 	.try_vmlinux_path = true,
 	.annotate_src	  = true,
 	.demangle	  = true,
+	.filter_relative  = true,
 	.symfs            = "",
 };
 
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 501e4e722e8e..ae94e006a52d 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -115,7 +115,8 @@ struct symbol_conf {
 			annotate_asm_raw,
 			annotate_src,
 			event_group,
-			demangle;
+			demangle,
+			filter_relative;
 	const char	*vmlinux_name,
 			*kallsyms_name,
 			*source_prefix,
-- 
1.7.11.7

