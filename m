Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757962Ab3K0URL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 15:17:11 -0500
Received: from merlin.infradead.org ([205.233.59.134]:32852 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757911Ab3K0URF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 15:17:05 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 26/34] perf script: Print comm, fork and exit events also
Date: Wed, 27 Nov 2013 17:16:26 -0300
Message-Id: <1385583394-3703-27-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1385583394-3703-1-git-send-email-acme@infradead.org>
References: <1385583394-3703-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

If --show-task-events option is given, also print internal COMM, FORK
and EXIT events.  It would be helpful for debugging.

  $ perf script --show-task-events
  ...
         swapper     0 [009] 3350640.335261: sched:sched_switch: prev_comm=swapper/9
           sleep  9486 [009] 3350640.335509: PERF_RECORD_COMM: sleep:9486
           sleep  9486 [009] 3350640.335806: sched:sched_stat_runtime: comm=sleep pid=9486
         firefox  2635 [003] 3350641.275896: PERF_RECORD_FORK(2635:9487):(2635:2635)
         firefox  2635 [003] 3350641.275896: sched:sched_process_fork: comm=firefox pid=2635
           sleep  9486 [009] 3350641.336009: PERF_RECORD_EXIT(9486:9486):(9486:9486)

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Suggested-by: Frederic Weisbecker <fweisbec@gmail.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1385455873-25865-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-script.txt |   3 +
 tools/perf/builtin-script.c              | 105 +++++++++++++++++++++++++++++++
 2 files changed, 108 insertions(+)

diff --git a/tools/perf/Documentation/perf-script.txt b/tools/perf/Documentation/perf-script.txt
index e9cbfcddfa3f..67af9b77ea78 100644
--- a/tools/perf/Documentation/perf-script.txt
+++ b/tools/perf/Documentation/perf-script.txt
@@ -203,6 +203,9 @@ OPTIONS
 --show-kernel-path::
 	Try to resolve the path of [kernel.kallsyms]
 
+--show-task-events
+	Display task related events (e.g. FORK, COMM, EXIT).
+
 SEE ALSO
 --------
 linkperf:perf-record[1], linkperf:perf-script-perl[1],
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 9f3ba4404a14..e2b9aff6506e 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -572,6 +572,7 @@ static int process_sample_event(struct perf_tool *tool __maybe_unused,
 struct perf_script {
 	struct perf_tool	tool;
 	struct perf_session	*session;
+	bool			show_task_events;
 };
 
 static int process_attr(struct perf_tool *tool, union perf_event *event,
@@ -602,6 +603,101 @@ static int process_attr(struct perf_tool *tool, union perf_event *event,
 	return perf_evsel__check_attr(evsel, scr->session);
 }
 
+static int process_comm_event(struct perf_tool *tool,
+			      union perf_event *event,
+			      struct perf_sample *sample,
+			      struct machine *machine)
+{
+	struct thread *thread;
+	struct perf_script *script = container_of(tool, struct perf_script, tool);
+	struct perf_session *session = script->session;
+	struct perf_evsel *evsel = perf_evlist__first(session->evlist);
+	int ret = -1;
+
+	thread = machine__findnew_thread(machine, event->comm.pid, event->comm.tid);
+	if (thread == NULL) {
+		pr_debug("problem processing COMM event, skipping it.\n");
+		return -1;
+	}
+
+	if (perf_event__process_comm(tool, event, sample, machine) < 0)
+		goto out;
+
+	if (!evsel->attr.sample_id_all) {
+		sample->cpu = 0;
+		sample->time = 0;
+		sample->tid = event->comm.tid;
+		sample->pid = event->comm.pid;
+	}
+	print_sample_start(sample, thread, evsel);
+	perf_event__fprintf(event, stdout);
+	ret = 0;
+
+out:
+	return ret;
+}
+
+static int process_fork_event(struct perf_tool *tool,
+			      union perf_event *event,
+			      struct perf_sample *sample,
+			      struct machine *machine)
+{
+	struct thread *thread;
+	struct perf_script *script = container_of(tool, struct perf_script, tool);
+	struct perf_session *session = script->session;
+	struct perf_evsel *evsel = perf_evlist__first(session->evlist);
+
+	if (perf_event__process_fork(tool, event, sample, machine) < 0)
+		return -1;
+
+	thread = machine__findnew_thread(machine, event->fork.pid, event->fork.tid);
+	if (thread == NULL) {
+		pr_debug("problem processing FORK event, skipping it.\n");
+		return -1;
+	}
+
+	if (!evsel->attr.sample_id_all) {
+		sample->cpu = 0;
+		sample->time = event->fork.time;
+		sample->tid = event->fork.tid;
+		sample->pid = event->fork.pid;
+	}
+	print_sample_start(sample, thread, evsel);
+	perf_event__fprintf(event, stdout);
+
+	return 0;
+}
+static int process_exit_event(struct perf_tool *tool,
+			      union perf_event *event,
+			      struct perf_sample *sample,
+			      struct machine *machine)
+{
+	struct thread *thread;
+	struct perf_script *script = container_of(tool, struct perf_script, tool);
+	struct perf_session *session = script->session;
+	struct perf_evsel *evsel = perf_evlist__first(session->evlist);
+
+	thread = machine__findnew_thread(machine, event->fork.pid, event->fork.tid);
+	if (thread == NULL) {
+		pr_debug("problem processing EXIT event, skipping it.\n");
+		return -1;
+	}
+
+	if (!evsel->attr.sample_id_all) {
+		sample->cpu = 0;
+		sample->time = 0;
+		sample->tid = event->comm.tid;
+		sample->pid = event->comm.pid;
+	}
+	print_sample_start(sample, thread, evsel);
+	perf_event__fprintf(event, stdout);
+
+	if (perf_event__process_exit(tool, event, sample, machine) < 0)
+		return -1;
+
+	return 0;
+}
+
 static void sig_handler(int sig __maybe_unused)
 {
 	session_done = 1;
@@ -613,6 +709,13 @@ static int __cmd_script(struct perf_script *script)
 
 	signal(SIGINT, sig_handler);
 
+	/* override event processing functions */
+	if (script->show_task_events) {
+		script->tool.comm = process_comm_event;
+		script->tool.fork = process_fork_event;
+		script->tool.exit = process_exit_event;
+	}
+
 	ret = perf_session__process_events(script->session, &script->tool);
 
 	if (debug_mode)
@@ -1375,6 +1478,8 @@ int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
 		    "display extended information from perf.data file"),
 	OPT_BOOLEAN('\0', "show-kernel-path", &symbol_conf.show_kernel_path,
 		    "Show the path of [kernel.kallsyms]"),
+	OPT_BOOLEAN('\0', "show-task-events", &script.show_task_events,
+		    "Show the fork/comm/exit events"),
 	OPT_END()
 	};
 	const char * const script_usage[] = {
-- 
1.8.1.4

