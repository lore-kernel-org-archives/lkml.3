Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718AbaBJCri (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 21:47:38 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:48677 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752366AbaBJCrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 21:47:32 -0500
X-AuditID: 9c93017e-b7cf9ae000004b4b-c6-52f83dc2433a
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 5/8] perf diff: Add --percentage option
Date: Mon, 10 Feb 2014 11:47:22 +0900
Message-Id: <1392000446-14744-6-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1392000446-14744-1-git-send-email-namhyung@kernel.org>
References: <1392000446-14744-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The --percentage option is for controlling overhead percentage
displayed.  It can only receive either of "relative" or "absolute" and
affects -c delta output only.

For more information, please see previous commit same thing done to
"perf report".

Cc: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Documentation/perf-diff.txt | 21 +++++++++++++---
 tools/perf/builtin-diff.c              | 46 +++++++++++++++++++++++++++++-----
 2 files changed, 58 insertions(+), 9 deletions(-)

diff --git a/tools/perf/Documentation/perf-diff.txt b/tools/perf/Documentation/perf-diff.txt
index fdfceee0ffd0..fbfa1192923c 100644
--- a/tools/perf/Documentation/perf-diff.txt
+++ b/tools/perf/Documentation/perf-diff.txt
@@ -33,17 +33,20 @@ OPTIONS
 -d::
 --dsos=::
 	Only consider symbols in these dsos. CSV that understands
-	file://filename entries.
+	file://filename entries.  This option will affect the percentage
+	of the Baseline/Delta column.  See --percentage for more info.
 
 -C::
 --comms=::
 	Only consider symbols in these comms. CSV that understands
-	file://filename entries.
+	file://filename entries.  This option will affect the percentage
+	of the Baseline/Delta column.  See --percentage for more info.
 
 -S::
 --symbols=::
 	Only consider these symbols. CSV that understands
-	file://filename entries.
+	file://filename entries.  This option will affect the percentage
+	of the Baseline/Delta column.  See --percentage for more info.
 
 -s::
 --sort=::
@@ -89,6 +92,14 @@ OPTIONS
 --order::
        Specify compute sorting column number.
 
+--percentage::
+	Determine how to display the overhead percentage of filtered entries.
+	Filters can be applied by --comms, --dsos and/or --symbols options.
+
+	"relative" means it's relative to filtered entries only so that the
+	sum of shown entries will be always 100%.  "absolute" means it retains
+	the original value before and after the filter is applied.
+
 COMPARISON
 ----------
 The comparison is governed by the baseline file. The baseline perf.data
@@ -157,6 +168,10 @@ with:
   - period_percent being the % of the hist entry period value within
     single data file
 
+  - with filtering by -C, -d and/or -S, period_percent might be changed
+    relative to how entries are filtered.  Use --percentage=absolute to
+    prevent such fluctuation.
+
 ratio
 ~~~~~
 If specified the 'Ratio' column is displayed with value 'r' computed as:
diff --git a/tools/perf/builtin-diff.c b/tools/perf/builtin-diff.c
index a77e31246c00..2c7406d9eb5d 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -221,6 +221,10 @@ static int setup_compute(const struct option *opt, const char *str,
 static double period_percent(struct hist_entry *he, u64 period)
 {
 	u64 total = he->hists->stats.total_period;
+
+	if (symbol_conf.filter_relative)
+		total = he->hists->stats.total_filtered_period;
+
 	return (period * 100.0) / total;
 }
 
@@ -259,11 +263,18 @@ static s64 compute_wdiff(struct hist_entry *he, struct hist_entry *pair)
 static int formula_delta(struct hist_entry *he, struct hist_entry *pair,
 			 char *buf, size_t size)
 {
+	u64 he_total = he->hists->stats.total_period;
+	u64 pair_total = pair->hists->stats.total_period;
+
+	if (symbol_conf.filter_relative) {
+		he_total = he->hists->stats.total_filtered_period;
+		pair_total = pair->hists->stats.total_filtered_period;
+	}
 	return scnprintf(buf, size,
 			 "(%" PRIu64 " * 100 / %" PRIu64 ") - "
 			 "(%" PRIu64 " * 100 / %" PRIu64 ")",
-			  pair->stat.period, pair->hists->stats.total_period,
-			  he->stat.period, he->hists->stats.total_period);
+			 pair->stat.period, pair_total,
+			 he->stat.period, he_total);
 }
 
 static int formula_ratio(struct hist_entry *he, struct hist_entry *pair,
@@ -327,15 +338,16 @@ static int diff__process_sample_event(struct perf_tool *tool __maybe_unused,
 		return -1;
 	}
 
-	if (al.filtered)
-		return 0;
-
 	if (hists__add_entry(&evsel->hists, &al, sample->period,
 			     sample->weight, sample->transaction)) {
 		pr_warning("problem incrementing symbol period, skipping event\n");
 		return -1;
 	}
 
+	if (al.filtered == 0) {
+		evsel->hists.stats.total_filtered_period += sample->period;
+		evsel->hists.nr_filtered_entries++;
+	}
 	evsel->hists.stats.total_period += sample->period;
 	return 0;
 }
@@ -565,7 +577,9 @@ static void hists__compute_resort(struct hists *hists)
 	next = rb_first(root);
 
 	hists->nr_entries = 0;
+	hists->nr_filtered_entries = 0;
 	hists->stats.total_period = 0;
+	hists->stats.total_filtered_period = 0;
 	hists__reset_col_len(hists);
 
 	while (next != NULL) {
@@ -695,6 +709,19 @@ static int __cmd_diff(void)
 	return ret;
 }
 
+static int parse_percentage(const struct option *opt __maybe_unused,
+			    const char *arg, int unset __maybe_unused)
+{
+	if (!strcmp(arg, "relative"))
+		symbol_conf.filter_relative = true;
+	else if (!strcmp(arg, "absolute"))
+		symbol_conf.filter_relative = false;
+	else
+		return -1;
+
+	return 0;
+}
+
 static const char * const diff_usage[] = {
 	"perf diff [<options>] [old_file] [new_file]",
 	NULL,
@@ -732,13 +759,20 @@ static const struct option options[] = {
 	OPT_STRING(0, "symfs", &symbol_conf.symfs, "directory",
 		    "Look for files with symbols relative to this directory"),
 	OPT_UINTEGER('o', "order", &sort_compute, "Specify compute sorting."),
+	OPT_CALLBACK(0, "percentage", NULL, "relative|absolute",
+		     "How to display percentage of filtered entries", parse_percentage),
 	OPT_END()
 };
 
 static double baseline_percent(struct hist_entry *he)
 {
 	struct hists *hists = he->hists;
-	return 100.0 * he->stat.period / hists->stats.total_period;
+	u64 total = hists->stats.total_period;
+
+	if (symbol_conf.filter_relative)
+		total = hists->stats.total_filtered_period;
+
+	return 100.0 * he->stat.period / total;
 }
 
 static int hpp__color_baseline(struct perf_hpp_fmt *fmt,
-- 
1.7.11.7

