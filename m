Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756764AbaDQJ40 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 05:56:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52833 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755372AbaDQJ4T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 05:56:19 -0400
Date: Thu, 17 Apr 2014 02:56:07 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-8810f6ced73556c1a63b6269a6cdad8d630aaaf0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, namhyung@kernel.org, jolsa@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, namhyung@kernel.org, jolsa@redhat.com
In-Reply-To: <1397145720-8063-5-git-send-email-namhyung@kernel.org>
References: <1397145720-8063-5-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf diff: Add --percentage option
Git-Commit-ID: 8810f6ced73556c1a63b6269a6cdad8d630aaaf0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8810f6ced73556c1a63b6269a6cdad8d630aaaf0
Gitweb:     http://git.kernel.org/tip/8810f6ced73556c1a63b6269a6cdad8d630aaaf0
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Fri, 7 Feb 2014 12:06:07 +0900
Committer:  Jiri Olsa <jolsa@redhat.com>
CommitDate: Wed, 16 Apr 2014 17:16:03 +0200

perf diff: Add --percentage option

The --percentage option is for controlling overhead percentage
displayed.  It can only receive either of "relative" or "absolute" and
affects -c delta output only.

For more information, please see previous commit same thing done to
"perf report".

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/1397145720-8063-5-git-send-email-namhyung@kernel.org
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/Documentation/perf-diff.txt | 21 ++++++++++++++++++---
 tools/perf/builtin-diff.c              | 30 ++++++++++++++++++++++--------
 2 files changed, 40 insertions(+), 11 deletions(-)

diff --git a/tools/perf/Documentation/perf-diff.txt b/tools/perf/Documentation/perf-diff.txt
index fdfceee..fbfa119 100644
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
index 204fffe..c903fe1 100644
--- a/tools/perf/builtin-diff.c
+++ b/tools/perf/builtin-diff.c
@@ -220,7 +220,8 @@ static int setup_compute(const struct option *opt, const char *str,
 
 static double period_percent(struct hist_entry *he, u64 period)
 {
-	u64 total = he->hists->stats.total_period;
+	u64 total = hists__total_period(he->hists);
+
 	return (period * 100.0) / total;
 }
 
@@ -259,11 +260,18 @@ static s64 compute_wdiff(struct hist_entry *he, struct hist_entry *pair)
 static int formula_delta(struct hist_entry *he, struct hist_entry *pair,
 			 char *buf, size_t size)
 {
+	u64 he_total = he->hists->stats.total_period;
+	u64 pair_total = pair->hists->stats.total_period;
+
+	if (symbol_conf.filter_relative) {
+		he_total = he->hists->stats.total_non_filtered_period;
+		pair_total = pair->hists->stats.total_non_filtered_period;
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
@@ -327,15 +335,16 @@ static int diff__process_sample_event(struct perf_tool *tool __maybe_unused,
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
+		evsel->hists.stats.total_non_filtered_period += sample->period;
+		evsel->hists.nr_non_filtered_entries++;
+	}
 	evsel->hists.stats.total_period += sample->period;
 	return 0;
 }
@@ -565,7 +574,9 @@ static void hists__compute_resort(struct hists *hists)
 	next = rb_first(root);
 
 	hists->nr_entries = 0;
+	hists->nr_non_filtered_entries = 0;
 	hists->stats.total_period = 0;
+	hists->stats.total_non_filtered_period = 0;
 	hists__reset_col_len(hists);
 
 	while (next != NULL) {
@@ -732,13 +743,16 @@ static const struct option options[] = {
 	OPT_STRING(0, "symfs", &symbol_conf.symfs, "directory",
 		    "Look for files with symbols relative to this directory"),
 	OPT_UINTEGER('o', "order", &sort_compute, "Specify compute sorting."),
+	OPT_CALLBACK(0, "percentage", NULL, "relative|absolute",
+		     "How to display percentage of filtered entries", parse_filter_percentage),
 	OPT_END()
 };
 
 static double baseline_percent(struct hist_entry *he)
 {
-	struct hists *hists = he->hists;
-	return 100.0 * he->stat.period / hists->stats.total_period;
+	u64 total = hists__total_period(he->hists);
+
+	return 100.0 * he->stat.period / total;
 }
 
 static int hpp__color_baseline(struct perf_hpp_fmt *fmt,
