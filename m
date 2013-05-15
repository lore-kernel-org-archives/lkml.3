Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758319Ab3EOJYR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 05:24:17 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:43119 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051Ab3EOJYH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 05:24:07 -0400
X-AuditID: 9c930197-b7b76ae000003523-33-519354322ffb
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Andi Kleen <andi@firstfloor.org>, Pekka Enberg <penberg@kernel.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>
Subject: [RFC/PATCH 2/2] perf report: Add --time-filter option
Date: Wed, 15 May 2013 18:23:59 +0900
Message-Id: <1368609839-19899-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1368609839-19899-1-git-send-email-namhyung@kernel.org>
References: <1368609839-19899-1-git-send-email-namhyung@kernel.org>
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
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Documentation/perf-report.txt |  6 ++++++
 tools/perf/builtin-report.c              | 33 ++++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+)

diff --git a/tools/perf/Documentation/perf-report.txt b/tools/perf/Documentation/perf-report.txt
index 7d5f4f38aa52..67544c2d8e69 100644
--- a/tools/perf/Documentation/perf-report.txt
+++ b/tools/perf/Documentation/perf-report.txt
@@ -210,6 +210,12 @@ OPTIONS
 	Demangle symbol names to human readable form. It's enabled by default,
 	disable with --no-demangle.
 
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
index d45bf9b0361d..2cd3f640cc4a 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -52,6 +52,7 @@ struct perf_report {
 	symbol_filter_t		annotate_init;
 	const char		*cpu_list;
 	const char		*symbol_filter_str;
+	u64			time_start, time_end;
 	DECLARE_BITMAP(cpu_bitmap, MAX_NR_CPUS);
 };
 
@@ -311,6 +312,12 @@ static int process_sample_event(struct perf_tool *tool,
 	if (rep->cpu_list && !test_bit(sample->cpu, rep->cpu_bitmap))
 		return 0;
 
+	if (rep->time_start && rep->time_start > sample->time)
+		return 0;
+
+	if (rep->time_end && rep->time_end < sample->time)
+		return 0;
+
 	if (sort__mode == SORT_MODE__BRANCH) {
 		if (perf_report__add_branch_hist_entry(tool, &al, sample,
 						       evsel, machine)) {
@@ -700,6 +707,30 @@ parse_branch_mode(const struct option *opt __maybe_unused,
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
+	if (sep == NULL || sep[1] == '\0') {
+		rep->time_start = parse_nsec_time(str);
+		return 0;
+	} else if (sep == str) {
+		rep->time_end = parse_nsec_time(++str);
+		return 0;
+	}
+
+	*sep++ = '\0';
+
+	rep->time_start = parse_nsec_time(str);
+	rep->time_end = parse_nsec_time(sep);
+
+	return 0;
+}
+
 int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 {
 	struct perf_session *session;
@@ -809,6 +840,8 @@ int cmd_report(int argc, const char **argv, const char *prefix __maybe_unused)
 	OPT_BOOLEAN(0, "demangle", &symbol_conf.demangle,
 		    "Disable symbol demangling"),
 	OPT_BOOLEAN(0, "mem-mode", &report.mem_mode, "mem access profile"),
+	OPT_CALLBACK(0, "time-filter", &report, "time[-time]",
+		    "Only display entries in the time range", parse_time_filter),
 	OPT_END()
 	};
 
-- 
1.7.11.7

