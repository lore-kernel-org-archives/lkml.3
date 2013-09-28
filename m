Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898Ab3I1TNn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 15:13:43 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:56252 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754399Ab3I1TNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 15:13:18 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 3/7] perf trace: Fix comm resolution when reading events from file
Date: Sat, 28 Sep 2013 13:13:00 -0600
Message-Id: <1380395584-9025-4-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1380395584-9025-1-git-send-email-dsahern@gmail.com>
References: <1380395584-9025-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Task comm's are getting lost when processing events from a file. The problem is
that the trace struct used by the live processing has its host machine and the
perf-session used for file based processing has its host machine.  Fix by
having both references point to the same machine.

Before:

     0.030 ( 0.001 ms): :27743/27743 brk( ...
     0.057 ( 0.004 ms): :27743/27743 mmap(len: 4096, prot: READ|WRITE, flags: ...
     0.075 ( 0.006 ms): :27743/27743 access(filename: 0x7f3809fbce00, mode: R ...
     0.091 ( 0.005 ms): :27743/27743 open(filename: 0x7f3809fba14c, flags: CLOEXEC ...
...

After:
     0.030 ( 0.001 ms): make/27743 brk( ...
     0.057 ( 0.004 ms): make/27743 mmap(len: 4096, prot: READ|WRITE, flags: ...
     0.075 ( 0.006 ms): make/27743 access(filename: 0x7f3809fbce00, mode: R ...
     0.091 ( 0.005 ms): make/27743 open(filename: 0x7f3809fba14c, flags: CLOEXEC ...
...

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/builtin-trace.c |   29 +++++++++++++++++++----------
 1 file changed, 19 insertions(+), 10 deletions(-)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 0c93928..420e48b 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -892,7 +892,7 @@ struct trace {
 		struct syscall  *table;
 	} syscalls;
 	struct perf_record_opts opts;
-	struct machine		host;
+	struct machine		*host;
 	u64			base_time;
 	bool			full_time;
 	FILE			*output;
@@ -1079,26 +1079,33 @@ static int trace__tool_process(struct perf_tool *tool,
 
 static int trace__symbols_init(struct trace *trace, struct perf_evlist *evlist)
 {
+	struct machine *host;
 	int err = symbol__init();
 
 	if (err)
 		return err;
 
-	machine__init(&trace->host, "", HOST_KERNEL_ID);
-	machine__create_kernel_maps(&trace->host);
+	host = malloc(sizeof(*host));
+	if (host == NULL)
+		return -ENOMEM;
+
+	machine__init(host, "", HOST_KERNEL_ID);
+	machine__create_kernel_maps(host);
 
 	if (perf_target__has_task(&trace->opts.target)) {
 		err = perf_event__synthesize_thread_map(&trace->tool, evlist->threads,
 							trace__tool_process,
-							&trace->host);
+							host);
 	} else {
 		err = perf_event__synthesize_threads(&trace->tool, trace__tool_process,
-						     &trace->host);
+						     host);
 	}
 
 	if (err)
 		symbol__exit();
 
+	trace->host = host;
+
 	return err;
 }
 
@@ -1303,7 +1310,7 @@ static int trace__sys_enter(struct trace *trace, struct perf_evsel *evsel,
 	if (sc->filtered)
 		return 0;
 
-	thread = machine__findnew_thread(&trace->host, sample->pid,
+	thread = machine__findnew_thread(trace->host, sample->pid,
 					 sample->tid);
 	ttrace = thread__trace(thread, trace->output);
 	if (ttrace == NULL)
@@ -1357,7 +1364,7 @@ static int trace__sys_exit(struct trace *trace, struct perf_evsel *evsel,
 	if (sc->filtered)
 		return 0;
 
-	thread = machine__findnew_thread(&trace->host, sample->pid,
+	thread = machine__findnew_thread(trace->host, sample->pid,
 					 sample->tid);
 	ttrace = thread__trace(thread, trace->output);
 	if (ttrace == NULL)
@@ -1427,7 +1434,7 @@ static int trace__sched_stat_runtime(struct trace *trace, struct perf_evsel *evs
 {
         u64 runtime = perf_evsel__intval(evsel, sample, "runtime");
 	double runtime_ms = (double)runtime / NSEC_PER_MSEC;
-	struct thread *thread = machine__findnew_thread(&trace->host,
+	struct thread *thread = machine__findnew_thread(trace->host,
 							sample->pid,
 							sample->tid);
 	struct thread_trace *ttrace = thread__trace(thread, trace->output);
@@ -1628,7 +1635,7 @@ again:
 				trace->base_time = sample.time;
 
 			if (type != PERF_RECORD_SAMPLE) {
-				trace__process_event(trace, &trace->host, event);
+				trace__process_event(trace, trace->host, event);
 				continue;
 			}
 
@@ -1722,6 +1729,8 @@ static int trace__replay(struct trace *trace)
 	if (session == NULL)
 		return -ENOMEM;
 
+	trace->host = &session->machines.host;
+
 	err = perf_session__set_tracepoints_handlers(session, handlers);
 	if (err)
 		goto out;
@@ -1812,7 +1821,7 @@ static size_t trace__fprintf_thread_summary(struct trace *trace, FILE *fp)
 	};
 	data.printed = trace__fprintf_threads_header(fp);
 
-	machine__for_each_thread(&trace->host, trace__fprintf_one_thread, &data);
+	machine__for_each_thread(trace->host, trace__fprintf_one_thread, &data);
 
 	return data.printed;
 }
-- 
1.7.10.1

