Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751565Ab3FCEo7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 00:44:59 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:49356 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751144Ab3FCEoU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 00:44:20 -0400
X-AuditID: 9c930197-b7be3ae000000eab-9f-51ac1f204b79
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [PATCH v2 3/4] perf report: Add --time-filter option
Date: Mon,  3 Jun 2013 13:44:12 +0900
Message-Id: <1370234653-31582-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1370234653-31582-1-git-send-email-namhyung@kernel.org>
References: <1370234653-31582-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The --time-filter option is for limiting samples within a range of
time.  A time range looks like <time1>-<time2> and at most one of them
can be omitted.  This can be useful when analyzing a part of a huge
data only.

Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: David Ahern <dsahern@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Documentation/perf-report.txt |  7 +++++++
 tools/perf/builtin-report.c              | 27 +++++++++++++++++++++++++++
 2 files changed, 34 insertions(+)

diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 66dab7410c1d..04a96f657ca7 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -214,6 +214,13 @@ OPTIONS
 	Do not show entries which have an overhead under that percent.
 	(Default: 0).
 
+-X::
+--time-filter::
+	Report samples within a range of time only. A time range can be given
+	like 'time1-time2' and treated as a start time and end time
+	respectively. The time format is like "<sec>.<usec>". Either of time1
+	or time2 can be omitted.
+
 SEE ALSO
 --------
 linkperf:perf-stat[1], linkperf:perf-annotate[1]
diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index ca98d34cd58b..e09e1bdb1401 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -53,6 +53,7 @@ struct perf_report {
 	const char		*cpu_list;
 	const char		*symbol_filter_str;
 	float			min_percent;
+	u64			time_start, time_end;
 	DECLARE_BITMAP(cpu_bitmap, MAX_NR_CPUS);
 };
 
@@ -318,6 +319,12 @@ static int process_sample_event(struct perf_tool *tool,
 	if (rep->cpu_list && !test_bit(sample->cpu, rep->cpu_bitmap))
 		return 0;
 
+	if (rep->time_start && rep->time_start > sample->time)
+		return 0;
+
+	if (rep->time_end && rep->time_end < sample->time)
+		return 0;
+
 	if (sort__mode == SORT_MODE__BRANCH) {
 		ret = perf_report__add_branch_hist_entry(tool, &al, sample,
 							 evsel, machine);
@@ -714,6 +721,24 @@ parse_percent_limit(const struct option *opt, const char *str,
 	return 0;
 }
 
+static int
+parse_time_filter(const struct option *opt, const char *str,
+		  int unset __maybe_unused)
+{
+	struct perf_report *rep = opt->value;
+	char *sep;
+
+	sep = strchr(str, '-');
+	if (sep == NULL)
+		return parse_nsec_time(str, &rep->time_start);
+	else if (sep == str)
+		return parse_nsec_time(++str, &rep->time_end);
+
+	*sep++ = '\0';
+	return parse_nsec_time(str, &rep->time_start) ||
+		parse_nsec_time(sep , &rep->time_end);
+}
+
 int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 {
 	struct perf_session *session;
@@ -825,6 +850,8 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_BOOLEAN(0, "mem-mode", &report.mem_mode, "mem access profile"),
 	OPT_CALLBACK(0, "percent-limit", &report, "percent",
 		     "Don't show entries under that percent", parse_percent_limit),
+	OPT_CALLBACK('X', "time-filter", &report, "time[-time]",
+		     "Only display entries in the time range", parse_time_filter),
 	OPT_END()
 	};
 
-- 
1.7.11.7

