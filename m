Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758225Ab3K0UVV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 15:21:21 -0500
Received: from merlin.infradead.org ([205.233.59.134]:32851 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757910Ab3K0URE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 15:17:04 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 27/34] perf script: Print mmap[2] events also
Date: Wed, 27 Nov 2013 17:16:27 -0300
Message-Id: <1385583394-3703-28-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1385583394-3703-1-git-send-email-acme@infradead.org>
References: <1385583394-3703-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

If --show-mmap-events option is given, also print internal MMAP and
MMAP2 events.  It would be helpful for debugging.

  $ perf script --show-mmap-events
  ...
           sleep  9486 [009] 3350640.335531: PERF_RECORD_MMAP 9486/9486: [0x400000(0x6000) @ 0]: x /usr/bin/sleep
           sleep  9486 [009] 3350640.335542: PERF_RECORD_MMAP 9486/9486: [0x3153a00000(0x223000) @ 0]: x /usr/lib64/ld-2.17.so
           sleep  9486 [009] 3350640.335553: PERF_RECORD_MMAP 9486/9486: [0x7fff8b5fe000(0x2000) @ 0x7fff8b5fe000]: x [vdso]
           sleep  9486 [009] 3350640.335643: PERF_RECORD_MMAP 9486/9486: [0x3153e00000(0x3c0000) @ 0]: x /usr/lib64/libc-2.17.so

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Suggested-by: Frederic Weisbecker <fweisbec@gmail.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1385456066-26592-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-script.txt |  3 ++
 tools/perf/builtin-script.c              | 69 ++++++++++++++++++++++++++++++++
 2 files changed, 72 insertions(+)

diff --git a/tools/perf/Documentation/perf-script.txt b/tools/perf/Documentation/perf-script.txt
index 67af9b77ea78..cfdbb1e045b5 100644
--- a/tools/perf/Documentation/perf-script.txt
+++ b/tools/perf/Documentation/perf-script.txt
@@ -206,6 +206,9 @@ OPTIONS
 --show-task-events
 	Display task related events (e.g. FORK, COMM, EXIT).
 
+--show-mmap-events
+	Display mmap related events (e.g. MMAP, MMAP2).
+
 SEE ALSO
 --------
 linkperf:perf-record[1], linkperf:perf-script-perl[1],
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index e2b9aff6506e..952dce979252 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -573,6 +573,7 @@ struct perf_script {
 	struct perf_tool	tool;
 	struct perf_session	*session;
 	bool			show_task_events;
+	bool			show_mmap_events;
 };
 
 static int process_attr(struct perf_tool *tool, union perf_event *event,
@@ -698,6 +699,68 @@ static int process_exit_event(struct perf_tool *tool,
 	return 0;
 }
 
+static int process_mmap_event(struct perf_tool *tool,
+			      union perf_event *event,
+			      struct perf_sample *sample,
+			      struct machine *machine)
+{
+	struct thread *thread;
+	struct perf_script *script = container_of(tool, struct perf_script, tool);
+	struct perf_session *session = script->session;
+	struct perf_evsel *evsel = perf_evlist__first(session->evlist);
+
+	if (perf_event__process_mmap(tool, event, sample, machine) < 0)
+		return -1;
+
+	thread = machine__findnew_thread(machine, event->mmap.pid, event->mmap.tid);
+	if (thread == NULL) {
+		pr_debug("problem processing MMAP event, skipping it.\n");
+		return -1;
+	}
+
+	if (!evsel->attr.sample_id_all) {
+		sample->cpu = 0;
+		sample->time = 0;
+		sample->tid = event->mmap.tid;
+		sample->pid = event->mmap.pid;
+	}
+	print_sample_start(sample, thread, evsel);
+	perf_event__fprintf(event, stdout);
+
+	return 0;
+}
+
+static int process_mmap2_event(struct perf_tool *tool,
+			      union perf_event *event,
+			      struct perf_sample *sample,
+			      struct machine *machine)
+{
+	struct thread *thread;
+	struct perf_script *script = container_of(tool, struct perf_script, tool);
+	struct perf_session *session = script->session;
+	struct perf_evsel *evsel = perf_evlist__first(session->evlist);
+
+	if (perf_event__process_mmap2(tool, event, sample, machine) < 0)
+		return -1;
+
+	thread = machine__findnew_thread(machine, event->mmap2.pid, event->mmap2.tid);
+	if (thread == NULL) {
+		pr_debug("problem processing MMAP2 event, skipping it.\n");
+		return -1;
+	}
+
+	if (!evsel->attr.sample_id_all) {
+		sample->cpu = 0;
+		sample->time = 0;
+		sample->tid = event->mmap2.tid;
+		sample->pid = event->mmap2.pid;
+	}
+	print_sample_start(sample, thread, evsel);
+	perf_event__fprintf(event, stdout);
+
+	return 0;
+}
+
 static void sig_handler(int sig __maybe_unused)
 {
 	session_done = 1;
@@ -715,6 +778,10 @@ static int __cmd_script(struct perf_script *script)
 		script->tool.fork = process_fork_event;
 		script->tool.exit = process_exit_event;
 	}
+	if (script->show_mmap_events) {
+		script->tool.mmap = process_mmap_event;
+		script->tool.mmap2 = process_mmap2_event;
+	}
 
 	ret = perf_session__process_events(script->session, &script->tool);
 
@@ -1480,6 +1547,8 @@ int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
 		    "Show the path of [kernel.kallsyms]"),
 	OPT_BOOLEAN('\0', "show-task-events", &script.show_task_events,
 		    "Show the fork/comm/exit events"),
+	OPT_BOOLEAN('\0', "show-mmap-events", &script.show_mmap_events,
+		    "Show the mmap events"),
 	OPT_END()
 	};
 	const char * const script_usage[] = {
-- 
1.8.1.4

