Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028AbaCJHpj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 03:45:39 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:52385 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467AbaCJHoF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 03:44:05 -0400
X-AuditID: 9c93017d-b7c89ae000006ae1-e4-531d6d42909c
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 4/9] perf report: Add --percentage option
Date: Mon, 10 Mar 2014 16:43:55 +0900
Message-Id: <1394437440-11609-5-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1394437440-11609-1-git-send-email-namhyung@kernel.org>
References: <1394437440-11609-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
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
Acked-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Documentation/perf-report.txt | 24 +++++++++++++++-----
 tools/perf/builtin-report.c              | 30 +++++++++++++++++++++++--
 tools/perf/ui/browsers/hists.c           | 35 ++++++++++++++++++++++-------
 tools/perf/ui/gtk/hists.c                | 11 +++++----
 tools/perf/ui/hist.c                     |  8 +++----
 tools/perf/util/hist.c                   | 38 ++++++++++++++++----------------
 tools/perf/util/hist.h                   |  1 +
 tools/perf/util/symbol.c                 |  1 +
 tools/perf/util/symbol.h                 |  3 ++-
 9 files changed, 105 insertions(+), 46 deletions(-)

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
index 95580a1e122e..b8eb8c6431aa 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -335,6 +335,11 @@ static size_t hists__fprintf_nr_sample_events(struct hists *hists, struct report
 	char buf[512];
 	size_t size = sizeof(buf);
 
+	if (symbol_conf.filter_relative) {
+		nr_samples = hists->stats.nr_non_filtered_samples;
+		nr_events = hists->stats.total_non_filtered_period;
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
+				nr_samples += pos->hists.stats.nr_non_filtered_samples;
+				nr_events += pos->hists.stats.total_non_filtered_period;
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
index 7ec871af3f6f..7ad11477a0f5 100644
--- a/tools/perf/ui/browsers/hists.c
+++ b/tools/perf/ui/browsers/hists.c
@@ -769,12 +769,15 @@ static unsigned int hist_browser__refresh(struct ui_browser *browser)
 
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
 
@@ -792,8 +795,11 @@ static struct rb_node *hists__filter_entries(struct rb_node *nd,
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
@@ -813,8 +819,11 @@ static struct rb_node *hists__filter_prev_entries(struct rb_node *nd,
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
@@ -1189,6 +1198,11 @@ static int hists__browser_title(struct hists *hists, char *bf, size_t size,
 	char buf[512];
 	size_t buflen = sizeof(buf);
 
+	if (symbol_conf.filter_relative) {
+		nr_samples = hists->stats.nr_non_filtered_samples;
+		nr_events = hists->stats.total_non_filtered_period;
+	}
+
 	if (perf_evsel__is_group_event(evsel)) {
 		struct perf_evsel *pos;
 
@@ -1196,8 +1210,13 @@ static int hists__browser_title(struct hists *hists, char *bf, size_t size,
 		ev_name = buf;
 
 		for_each_group_member(pos, evsel) {
-			nr_samples += pos->hists.stats.nr_events[PERF_RECORD_SAMPLE];
-			nr_events += pos->hists.stats.total_period;
+			if (symbol_conf.filter_relative) {
+				nr_samples += pos->hists.stats.nr_non_filtered_samples;
+				nr_events += pos->hists.stats.total_non_filtered_period;
+			} else {
+				nr_samples += pos->hists.stats.nr_events[PERF_RECORD_SAMPLE];
+				nr_events += pos->hists.stats.total_period;
+			}
 		}
 	}
 
diff --git a/tools/perf/ui/gtk/hists.c b/tools/perf/ui/gtk/hists.c
index e395ef9b0ae0..91f10f3f6dd1 100644
--- a/tools/perf/ui/gtk/hists.c
+++ b/tools/perf/ui/gtk/hists.c
@@ -228,12 +228,15 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists,
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
 
@@ -261,12 +264,8 @@ static void perf_gtk__show_hists(GtkWidget *window, struct hists *hists,
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
index 0f403b83e9d1..0912805c08f4 100644
--- a/tools/perf/ui/hist.c
+++ b/tools/perf/ui/hist.c
@@ -32,10 +32,10 @@ int __hpp__fmt(struct perf_hpp *hpp, struct hist_entry *he,
 
 	if (fmt_percent) {
 		double percent = 0.0;
+		u64 total = hists__total_period(hists);
 
-		if (hists->stats.total_period)
-			percent = 100.0 * get_field(he) /
-				  hists->stats.total_period;
+		if (total)
+			percent = 100.0 * get_field(he) / total;
 
 		ret += hpp__call_print_fn(hpp, print_fn, fmt, percent);
 	} else
@@ -50,7 +50,7 @@ int __hpp__fmt(struct perf_hpp *hpp, struct hist_entry *he,
 
 		list_for_each_entry(pair, &he->pairs.head, pairs.node) {
 			u64 period = get_field(pair);
-			u64 total = pair->hists->stats.total_period;
+			u64 total = hists__total_period(pair->hists);
 
 			if (!total)
 				continue;
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 42df44178c4a..71078de683fe 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -321,10 +321,11 @@ void hists__inc_nr_entries(struct hists *hists, struct hist_entry *h)
 {
 	if (!h->filtered) {
 		hists__calc_col_len(hists, h);
-		++hists->nr_entries;
-		hists->stats.total_period += h->stat.period;
+		hists->nr_non_filtered_entries++;
 		hists->stats.total_non_filtered_period += h->stat.period;
 	}
+	hists->nr_entries++;
+	hists->stats.total_period += h->stat.period;
 }
 
 static u8 symbol__parent_filter(const struct symbol *parent)
@@ -675,8 +676,9 @@ void hists__output_resort(struct hists *hists)
 	next = rb_first(root);
 	hists->entries = RB_ROOT;
 
-	hists->nr_entries = hists->nr_non_filtered_entries = 0;
-	hists->stats.total_period = hists->stats.total_non_filtered_period = 0;
+	hists->nr_non_filtered_entries = 0;
+	hists->stats.total_period = 0;
+	hists->stats.total_non_filtered_period = 0;
 	hists__reset_col_len(hists);
 
 	while (next) {
@@ -695,16 +697,11 @@ static void hists__remove_entry_filter(struct hists *hists, struct hist_entry *h
 	if (h->filtered)
 		return;
 
-	hists->nr_entries++;
 	hists->nr_non_filtered_entries++;
-	if (h->ms.unfolded) {
-		hists->nr_entries += h->nr_rows;
+	if (h->ms.unfolded)
 		hists->nr_non_filtered_entries += h->nr_rows;
-	}
 	h->row_offset = 0;
-	hists->stats.total_period += h->stat.period;
 	hists->stats.total_non_filtered_period += h->stat.period;
-	hists->stats.nr_events[PERF_RECORD_SAMPLE] += h->stat.nr_events;
 	hists->stats.nr_non_filtered_samples += h->stat.nr_events;
 
 	hists__calc_col_len(hists, h);
@@ -727,9 +724,8 @@ void hists__filter_by_dso(struct hists *hists)
 {
 	struct rb_node *nd;
 
-	hists->nr_entries = hists->stats.total_period = 0;
-	hists->nr_non_filtered_entries = hists->stats.total_non_filtered_period = 0;
-	hists->stats.nr_events[PERF_RECORD_SAMPLE] = 0;
+	hists->nr_non_filtered_entries = 0;
+	hists->stats.total_non_filtered_period = 0;
 	hists->stats.nr_non_filtered_samples = 0;
 	hists__reset_col_len(hists);
 
@@ -762,9 +758,8 @@ void hists__filter_by_thread(struct hists *hists)
 {
 	struct rb_node *nd;
 
-	hists->nr_entries = hists->stats.total_period = 0;
-	hists->nr_non_filtered_entries = hists->stats.total_non_filtered_period = 0;
-	hists->stats.nr_events[PERF_RECORD_SAMPLE] = 0;
+	hists->nr_non_filtered_entries = 0;
+	hists->stats.total_non_filtered_period = 0;
 	hists->stats.nr_non_filtered_samples = 0;
 	hists__reset_col_len(hists);
 
@@ -795,9 +790,8 @@ void hists__filter_by_symbol(struct hists *hists)
 {
 	struct rb_node *nd;
 
-	hists->nr_entries = hists->stats.total_period = 0;
-	hists->nr_non_filtered_entries = hists->stats.total_non_filtered_period = 0;
-	hists->stats.nr_events[PERF_RECORD_SAMPLE] = 0;
+	hists->nr_non_filtered_entries = 0;
+	hists->stats.total_non_filtered_period = 0;
 	hists->stats.nr_non_filtered_samples = 0;
 	hists__reset_col_len(hists);
 
@@ -943,3 +937,9 @@ int hists__link(struct hists *leader, struct hists *other)
 
 	return 0;
 }
+
+u64 hists__total_period(struct hists *hists)
+{
+	return symbol_conf.filter_relative ? hists->stats.total_non_filtered_period :
+		hists->stats.total_period;
+}
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 213551469f36..3191496bd3b7 100644
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
index 0ada68b3b096..233681e304dd 100644
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

