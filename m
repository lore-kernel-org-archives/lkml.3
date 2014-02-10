Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752690AbaBJCrh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 21:47:37 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:58726 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752376AbaBJCrc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 21:47:32 -0500
X-AuditID: 9c93017e-b7cf9ae000004b4b-b5-52f83dc0dae9
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Andi Kleen <andi@firstfloor.org>
Subject: [PATCH 4/8] perf top: Add --percentage option
Date: Mon, 10 Feb 2014 11:47:21 +0900
Message-Id: <1392000446-14744-5-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1392000446-14744-1-git-send-email-namhyung@kernel.org>
References: <1392000446-14744-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The --percentage option is for controlling overhead percentage
displayed.  It can only receive either of "relative" or "absolute".

For more information, please see previous commit same thing done to
"perf report".

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Documentation/perf-top.txt | 18 +++++++++++++++---
 tools/perf/builtin-top.c              | 16 ++++++++++++++++
 2 files changed, 31 insertions(+), 3 deletions(-)

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
 
diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index ed99ec4a309f..a516e0389c5e 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -1011,6 +1011,20 @@ parse_percent_limit(const struct option *opt, const char *arg,
 	return 0;
 }
 
+static int
+parse_percentage(const struct option *opt __maybe_unused, const char *arg,
+		 int unset __maybe_unused)
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
 int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 {
 	int status = -1;
@@ -1114,6 +1128,8 @@ int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_STRING('u', "uid", &target->uid_str, "user", "user to profile"),
 	OPT_CALLBACK(0, "percent-limit", &top, "percent",
 		     "Don't show entries under that percent", parse_percent_limit),
+	OPT_CALLBACK(0, "percentage", NULL, "relative|absolute",
+		     "How to display percentage of filtered entries", parse_percentage),
 	OPT_END()
 	};
 	const char * const top_usage[] = {
-- 
1.7.11.7

