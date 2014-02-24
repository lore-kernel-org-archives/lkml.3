Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206AbaBXIJh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 03:09:37 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:45706 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752713AbaBXIJd (ORCPT
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
Subject: [PATCH 4/8] perf top: Add --percentage option
Date: Mon, 24 Feb 2014 17:09:24 +0900
Message-Id: <1393229368-31412-5-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1393229368-31412-1-git-send-email-namhyung@kernel.org>
References: <1393229368-31412-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The --percentage option is for controlling overhead percentage
displayed.  It can only receive either of "relative" or "absolute".
Move the parser callback function into a common location since it's
used by multiple commands now.

For more information, please see previous commit same thing done to
"perf report".

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Documentation/perf-top.txt | 18 +++++++++++++++---
 tools/perf/builtin-report.c           | 16 +---------------
 tools/perf/builtin-top.c              |  2 ++
 tools/perf/util/hist.c                | 13 +++++++++++++
 tools/perf/util/hist.h                |  5 +++++
 5 files changed, 36 insertions(+), 18 deletions(-)

diff --git a/tools/perf/Documentation/perf-top.txt b/tools/perf/Documentation/perf-top.txt
index cdd8d4946dba..0acf54f203f0 100644
--- a/tools/perf/Documentation/perf-top.txt
+++ b/tools/perf/Documentation/perf-top.txt
@@ -124,13 +124,16 @@ Default is to monitor all CPUS.
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
@@ -166,6 +169,15 @@ Default is to monitor all CPUS.
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
index 2385e694c8c2..ca9a7fd2780e 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -709,20 +709,6 @@ parse_percent_limit(const struct option *opt, const char *str,
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
@@ -846,7 +832,7 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_CALLBACK(0, "percent-limit", &report, "percent",
 		     "Don't show entries under that percent", parse_percent_limit),
 	OPT_CALLBACK(0, "percentage", NULL, "relative|absolute",
-		     "how to display percentage of filtered entries", parse_percentage),
+		     "how to display percentage of filtered entries", parse_filter_percentage),
 	OPT_END()
 	};
 	struct perf_data_file file = {
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index ed99ec4a309f..18a2467bdf00 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1114,6 +1114,8 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_STRING('u', "uid", &target->uid_str, "user", "user to profile"),
 	OPT_CALLBACK(0, "percent-limit", &top, "percent",
 		     "Don't show entries under that percent", parse_percent_limit),
+	OPT_CALLBACK(0, "percentage", NULL, "relative|absolute",
+		     "How to display percentage of filtered entries", parse_filter_percentage),
 	OPT_END()
 	};
 	const char * const top_usage[] = {
diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 7d72deb96b77..3143b8c14a4b 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -940,3 +940,16 @@ u64 hists__total_period(struct hists *hists)
 	return symbol_conf.filter_relative ? hists->stats.total_filtered_period :
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
index 70052f30e907..d0178eab31d5 100644
--- a/tools/perf/util/hist.h
+++ b/tools/perf/util/hist.h
@@ -238,4 +238,9 @@ static inline int script_browse(const char *script_opt __maybe_unused)
 #endif
 
 unsigned int hists__sort_list_width(struct hists *hists);
+
+struct option;
+int parse_filter_percentage(const struct option *opt __maybe_unused,
+			    const char *arg, int unset __maybe_unused);
+
 #endif	/* __PERF_HIST_H */
-- 
1.7.11.7

