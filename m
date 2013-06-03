Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751730Ab3FCEpJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 00:45:09 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:49356 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751179Ab3FCEoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 00:44:23 -0400
X-AuditID: 9c930197-b7be3ae000000eab-a2-51ac1f206dfe
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, Jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH/RFC v2 4/4] perf inject: Add --time-filter option
Date: Mon,  3 Jun 2013 13:44:13 +0900
Message-Id: <1370234653-31582-4-git-send-email-namhyung@kernel.org>
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

It's unclear how to specify a time range when used with a pipe.  It
seems that we need to support relative time too.

Cc: David Ahern <dsahern@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Documentation/perf-inject.txt |  7 +++++++
 tools/perf/builtin-inject.c              | 35 ++++++++++++++++++++++++++++++++
 2 files changed, 42 insertions(+)

diff --git a/tools/perf/Documentation/perf-inject.txt b/tools/perf/Documentation/perf-inject.txt
index a00a34276c54..5bc474369dfb 100644
--- a/tools/perf/Documentation/perf-inject.txt
+++ b/tools/perf/Documentation/perf-inject.txt
@@ -41,6 +41,13 @@ OPTIONS
 	tasks slept. sched_switch contains a callchain where a task slept and
 	sched_stat contains a timeslice how long a task slept.
 
+-X::
+--time-filter::
+	Display samples within a range of time only. A time range can be given
+	like 'time1-time2' and treated as a start time and an end time
+	respectively. The time format is like "<sec>.<usec>". Either of time1
+	or time2 can be omitted.
+
 SEE ALSO
 --------
 linkperf:perf-record[1], linkperf:perf-report[1], linkperf:perf-archive[1]
diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index 84ad6abe4258..4fcd75508b24 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -28,6 +28,7 @@ struct perf_inject {
 	int		 pipe_output,
 			 output;
 	u64		 bytes_written;
+	u64		 time_start, time_end;
 	struct list_head samples;
 };
 
@@ -112,6 +113,14 @@ static int perf_event__repipe_sample(struct perf_tool *tool,
 				     struct perf_evsel *evsel,
 				     struct machine *machine)
 {
+	struct perf_inject *inject = container_of(tool, struct perf_inject, tool);
+
+	if (inject->time_start && inject->time_start > sample->time)
+		return 0;
+
+	if (inject->time_end && inject->time_end < sample->time)
+		return 0;
+
 	if (evsel->handler.func) {
 		inject_handler f = evsel->handler.func;
 		return f(tool, event, sample, evsel, machine);
@@ -206,6 +215,13 @@ static int perf_event__inject_buildid(struct perf_tool *tool,
 	struct addr_location al;
 	struct thread *thread;
 	u8 cpumode;
+	struct perf_inject *inject = container_of(tool, struct perf_inject, tool);
+
+	if (inject->time_start && inject->time_start > sample->time)
+		return 0;
+
+	if (inject->time_end && inject->time_end < sample->time)
+		return 0;
 
 	cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
 
@@ -393,6 +409,23 @@ static int __cmd_inject(struct perf_inject *inject)
 	return ret;
 }
 
+static int
+parse_time_filter(const struct option *opt, const char *str,
+		  int unset __maybe_unused)
+{
+	struct perf_inject *inject = opt->value;
+	char *sep = strchr(str, '-');
+
+	if (sep == NULL)
+		return parse_nsec_time(str, &inject->time_start);
+	else if (sep == str)
+		return parse_nsec_time(++str, &inject->time_end);
+
+	*sep++ = '\0';
+	return parse_nsec_time(str, &inject->time_start) ||
+		parse_nsec_time(sep, &inject->time_end);
+}
+
 int cmd_inject(int argc, const char **argv, const char *prefix __maybe_unused)
 {
 	struct perf_inject inject = {
@@ -427,6 +460,8 @@ int cmd_inject(int argc, const char **argv, const char *prefix __maybe_unused)
 			    "where and how long tasks slept"),
 		OPT_INCR('v', "verbose", &verbose,
 			 "be more verbose (show build ids, etc)"),
+		OPT_CALLBACK('X', "time-filter", &inject, "time[-time]",
+			     "Only display entries in the time range", parse_time_filter),
 		OPT_END()
 	};
 	const char * const inject_usage[] = {
-- 
1.7.11.7

