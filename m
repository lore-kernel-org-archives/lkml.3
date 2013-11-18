Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751343Ab3KRDBR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 22:01:17 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:58902 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974Ab3KRDAo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 22:00:44 -0500
X-AuditID: 9c93017d-b7b15ae000000e52-1b-528982da627e
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [RFC/PATCH 2/3] perf script: Print comm, fork and exit events also
Date: Mon, 18 Nov 2013 12:00:41 +0900
Message-Id: <1384743642-15120-2-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1384743642-15120-1-git-send-email-namhyung@kernel.org>
References: <1384743642-15120-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If --show-task option is given, also print internal COMM, FORK and
EXIT events.  It would be helpful for debugging.

Suggested-by: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Documentation/perf-script.txt |   3 +
 tools/perf/builtin-script.c              | 110 +++++++++++++++++++++++++++++++
 2 files changed, 113 insertions(+)

diff --git a/tools/perf/Documentation/perf-script.txt b/tools/perf/Documentation/perf-script.txt
index e9cbfcddfa3f..9a9a7c3d592d 100644
--- a/tools/perf/Documentation/perf-script.txt
+++ b/tools/perf/Documentation/perf-script.txt
@@ -203,6 +203,9 @@ OPTIONS
 --show-kernel-path::
 	Try to resolve the path of [kernel.kallsyms]
 
+--show-task
+	Display task related events (e.g. FORK, COMM, EXIT).
+
 SEE ALSO
 --------
 linkperf:perf-record[1], linkperf:perf-script-perl[1],
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index b392770766dd..bc4cbb8b8867 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -548,6 +548,7 @@ static int process_sample_event(struct perf_tool *tool __maybe_unused,
 struct perf_script {
 	struct perf_tool	tool;
 	struct perf_session	*session;
+	bool			show_task_events;
 };
 
 static int process_attr(struct perf_tool *tool, union perf_event *event,
@@ -578,6 +579,106 @@ static int process_attr(struct perf_tool *tool, union perf_event *event,
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
+	char *oldname;
+
+	thread = machine__findnew_thread(machine, event->comm.pid, event->comm.tid);
+	if (thread == NULL) {
+		pr_debug("problem processing COMM event, skipping it.\n");
+		return -1;
+	}
+
+	oldname = strdup(thread__comm_str(thread));
+	if (oldname == NULL) {
+		pr_debug("problem processing COMM event, skipping it.\n");
+		return -1;
+	}
+
+	if (perf_event__process_comm(tool, event, sample, machine) < 0)
+		return -1;
+
+	if (!evsel->attr.sample_id_all) {
+		sample->cpu = 0;
+		sample->time = 0;
+		sample->tid = event->comm.tid;
+		sample->pid = event->comm.pid;
+	}
+	print_sample_start(sample, thread, evsel);
+	printf("comm: %s --> %s\n", oldname, event->comm.comm);
+
+	return 0;
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
+	printf("fork: %s (%d --> %d)\n", thread__comm_str(thread),
+	       event->fork.ptid, event->fork.tid);
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
+	printf("exit: %s (%d)\n", thread__comm_str(thread), event->fork.tid);
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
@@ -589,6 +690,13 @@ static int __cmd_script(struct perf_script *script)
 
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
@@ -1351,6 +1459,8 @@ int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
 		    "display extended information from perf.data file"),
 	OPT_BOOLEAN('\0', "show-kernel-path", &symbol_conf.show_kernel_path,
 		    "Show the path of [kernel.kallsyms]"),
+	OPT_BOOLEAN('\0', "show-task", &script.show_task_events,
+		    "Show the fork/comm/exit events"),
 	OPT_END()
 	};
 	const char * const script_usage[] = {
-- 
1.7.11.7

