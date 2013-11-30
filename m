Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753550Ab3K3Mxc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 07:53:32 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59751 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348Ab3K3Mx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 07:53:27 -0500
Date: Sat, 30 Nov 2013 04:53:07 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-ad7ebb9a48f59bad2714b64725653a73d78b686e@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1385455873-25865-1-git-send-email-namhyung@kernel.org>
References: <1385455873-25865-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf script: Print comm,
  fork and exit events also
Git-Commit-ID: ad7ebb9a48f59bad2714b64725653a73d78b686e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sat, 30 Nov 2013 04:53:14 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ad7ebb9a48f59bad2714b64725653a73d78b686e
Gitweb:     http://git.kernel.org/tip/ad7ebb9a48f59bad2714b64725653a73d78b686e
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Tue, 26 Nov 2013 17:51:12 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 27 Nov 2013 14:58:38 -0300

perf script: Print comm, fork and exit events also

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
index e9cbfcd..67af9b7 100644
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
index 9f3ba44..e2b9aff 100644
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
