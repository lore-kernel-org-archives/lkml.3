Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066AbaDPSlw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 14:41:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17218 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755983AbaDPSlt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 14:41:49 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>
Subject: [PATCH 03/11] perf top: Add --percentage option
Date: Wed, 16 Apr 2014 20:41:31 +0200
Message-Id: <1397673699-25824-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1397673699-25824-1-git-send-email-jolsa@redhat.com>
References: <1397673699-25824-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

The --percentage option is for controlling overhead percentage
displayed.  It can only receive either of "relative" or "absolute".
Move the parser callback function into a common location since it's
used by multiple commands now.

For more information, please see previous commit same thing done to
"perf report".

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/1397145720-8063-4-git-send-email-namhyung@kernel.org
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/Documentation/perf-top.txt | 18 +++++++++++++++---
 tools/perf/builtin-report.c           | 16 +---------------
 tools/perf/builtin-top.c              |  5 +++--
 tools/perf/util/hist.c                | 13 +++++++++++++
 tools/perf/util/hist.h                |  5 +++++
 5 files changed, 37 insertions(+), 20 deletions(-)

diff --git a/tools/perf/Documentation/perf-top.txt b/tools/perf/Documentation/perf-top.txt
index 976b00c..64ed79c 100644
--- a/tools/perf/Documentation/perf-top.txt
+++ b/tools/perf/Documentation/perf-top.txt
@@ -123,13 +123,16 @@ Default is to monitor all CPUS.
 	Show a column with the sum of periods.
 
 --dsos::
-	Only consider symbols in these dsos.
+	Only consider symbols in these dsos.  This option will affect the
+	percentage of the overhead column.  See --percentage for more info.
 
 --comms::
-	Only consider symbols in these comms.
+	Only consider symbols in these comms.  This option will affect the
+	percentage of the overhead column.  See --percentage for more info.
 
 --symbols::
-	Only consider these symbols.
+	Only consider these symbols.  This option will affect the
+	percentage of the overhead column.  See --percentage for more info.
 
 -M::
 --disassembler-style=:: Set disassembler style for objdump.
@@ -165,6 +168,15 @@ Default is to monitor all CPUS.
 	Do not show entries which have an overhead under that percent.
 	(Default: 0).
 
+--percentage::
+	Determine how to display the overhead percentage of filtered entries.
+	Filters can be applied by --comms, --dsos and/or --symbols options and
+	Zoom operations on the TUI (thread, dso, etc).
+
+	"relative" means it's relative to filtered entries only so that the
+	sum of shown entries will be always 100%. "absolute" means it retains
+	the original value before and after the filter is applied.
+
 INTERACTIVE PROMPTING KEYS
 --------------------------
 
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index 7ec351b..af8cb7a 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -717,20 +717,6 @@ parse_percent_limit(const struct option *opt, const char *str,
 	return 0;
 }
 
-static int
-parse_percentage(const struct option *opt __maybe_unused, const char *str,
-		 int unset __maybe_unused)
-{
-	if (!strcmp(str, "relative"))
-		symbol_conf.filter_relative = true;
-	else if (!strcmp(str, "absolute"))
-		symbol_conf.filter_relative = false;
-	else
-		return -1;
-
-	return 0;
-}
-
 int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 {
 	struct perf_session *session;
@@ -854,7 +840,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_CALLBACK(0, "percent-limit", &report, "percent",
 		     "Don't show entries under that percent", parse_percent_limit),
 	OPT_CALLBACK(0, "percentage", NULL, "relative|absolute",
-		     "how to display percentage of filtered entries", parse_percentage),
+		     "how to display percentage of filtered entries", parse_filter_percentage),
 	OPT_END()
 	};
 	struct perf_data_file file = {
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 2526901..37d3046 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -697,8 +697,7 @@ static void perf_event__process_sample(struct perf_tool *tool,
 	if (event->header.misc & PERF_RECORD_MISC_EXACT_IP)
 		top->exact_samples++;
 
-	if (perf_event__preprocess_sample(event, machine, &al, sample) < 0 ||
-	    al.filtered)
+	if (perf_event__preprocess_sample(event, machine, &al, sample) < 0)
 		return;
 
 	if (!top->kptr_restrict_warned &&
@@ -1119,6 +1118,8 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_STRING('u', "uid", &target->uid_str, "user", "user to profile"),
 	OPT_CALLBACK(0, "percent-limit", &top, "percent",
 		     "Don't show entries under that percent", parse_percent_limit),
+	OPT_CALLBACK(0, "percentage", NULL, "relative|absolute",
+		     "How to display percentage of filtered entries", parse_filter_percentage),
 	OPT_END()
 	};
 	const char * const top_usage[] = {
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 3ebd89a..3c2dd23 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -943,3 +943,16 @@ u64 hists__total_period(struct hists *hists)
 	return symbol_conf.filter_relative ? hists->stats.total_non_filtered_period :
 		hists->stats.total_period;
 }
+
+int parse_filter_percentage(const struct option *opt __maybe_unused,
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
diff --git a/tools/perf/util/hist.h b/tools/perf/util/hist.h
index 3191496..a4ec336 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -254,4 +254,9 @@ static inline int script_browse(const char *script_opt __maybe_unused)
 #endif
 
 unsigned int hists__sort_list_width(struct hists *hists);
+
+struct option;
+int parse_filter_percentage(const struct option *opt __maybe_unused,
+			    const char *arg, int unset __maybe_unused);
+
 #endif	/* __PERF_HIST_H */
-- 
1.8.3.1

