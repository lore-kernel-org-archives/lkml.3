Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934063Ab3HHCwi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 22:52:38 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:65472 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933946Ab3HHCv4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 22:51:56 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org, mingo@kernel.org
Cc: David Ahern <dsahern@gmail.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 18/19] perf sched timehist: Print all events in verbose mode
Date: Wed,  7 Aug 2013 22:51:00 -0400
Message-Id: <1375930261-77273-19-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1375930261-77273-1-git-send-email-dsahern@gmail.com>
References: <1375930261-77273-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Useful for debugging and correlating extra events in a file with
the scheduling events collected.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/builtin-sched.c |   57 ++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 53 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index f5e98f1..1be9081 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -1897,6 +1897,50 @@ static struct thread *timehist_get_thread(struct perf_evsel *evsel,
 	return thread;
 }
 
+static void timehist_print_sched_event(struct perf_tool *tool,
+			       struct perf_evsel *evsel,
+			       struct perf_sample *sample,
+			       struct machine *machine)
+{
+	struct perf_sched *sched = container_of(tool, struct perf_sched, tool);
+	struct thread *thread;
+	struct thread_runtime *tr;
+	const char *evname;
+	char tstr[64];
+
+	thread = machine__findnew_thread(machine, sample->tid);
+	if (thread == NULL)
+		return;
+
+	tr = thread__priv(thread);
+	if (tr == NULL) {
+		tr = thread__init_runtime(thread, sample->pid);
+		if (tr == NULL)
+			return;
+	}
+
+	printf("%15s ", timehist_time_str(tstr, sizeof(tstr), sample->time));
+	printf("[%02d] ", sample->cpu);
+	if (sched->show_cpu_visual && sched->max_cpu)
+		printf("%*s  ", sched->max_cpu, "");
+
+	printf("%-*s ", comm_width, tr->commstr);
+
+	/* dt spacer */
+	printf(" %9s %9s ", "", "");
+
+	evname = perf_evsel__name(evsel);
+	printf("%s ", evname ? evname : "[unknown]");
+	if (evsel->attr.type == PERF_TYPE_TRACEPOINT) {
+		event_format__print(evsel->tp_format, sample->cpu,
+				    sample->raw_data, sample->raw_size);
+	}
+
+	printf("\n");
+
+	return;
+}
+
 static int timehist_sched_change_event(struct perf_tool *tool,
 				       struct perf_evsel *evsel,
 				       struct perf_sample *sample,
@@ -2079,12 +2123,14 @@ static void timehist_print_summary(struct perf_session *session)
 	printf_nsecs(total_run_time, 2);
 	printf("\n");
 }
+
 static int perf_timehist__process_sample(struct perf_tool *tool,
-					 union perf_event *event,
-					 struct perf_sample *sample,
-					 struct perf_evsel *evsel,
-					 struct machine *machine)
+						 union perf_event *event,
+						 struct perf_sample *sample,
+						 struct perf_evsel *evsel,
+						 struct machine *machine)
 {
+	struct perf_sched *sched = container_of(tool, struct perf_sched, tool);
 	int err = 0;
 
 	evsel->hists.stats.total_period += sample->period;
@@ -2094,6 +2140,9 @@ static int perf_timehist__process_sample(struct perf_tool *tool,
 		tracepoint_handler f = evsel->handler.func;
 		evsel->handler.data = event;
 
+		if (sched->show_events && verbose)
+			timehist_print_sched_event(tool, evsel, sample, machine);
+
 		if (f)
 			err = f(tool, evsel, sample, machine);
 	}
-- 
1.7.10.1

