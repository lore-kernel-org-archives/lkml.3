Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751286Ab3KRFfK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 00:35:10 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:44291 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836Ab3KRFe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 00:34:58 -0500
X-AuditID: 9c93017d-b7b15ae000000e52-15-5289a6ff3387
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH v2 3/3] perf script: Print mmap[2] events also
Date: Mon, 18 Nov 2013 14:34:54 +0900
Message-Id: <1384752894-10974-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1384752894-10974-1-git-send-email-namhyung@kernel.org>
References: <1384752894-10974-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If --show-mmap option is given, also print internal MMAP and MMAP2
events.  It would be helpful for debugging.

  $ perf script --show-mmap
  ...
           sleep  9486 [009] 3350640.335531: mmap: [(0x400000 - 0x406000) @ 0 ]: x /usr/bin/sleep
           sleep  9486 [009] 3350640.335542: mmap: [(0x3153a00000 - 0x3153c23000) @ 0 ]: x /usr/lib64/ld-2.17.so
           sleep  9486 [009] 3350640.335553: mmap: [(0x7fff8b5fe000 - 0x7fff8b600000) @ 0x7fff8b5fe000 ]: x [vdso]
           sleep  9486 [009] 3350640.335643: mmap: [(0x3153e00000 - 0x31541c0000) @ 0 ]: x /usr/lib64/libc-2.17.so

Suggested-by: Frederic Weisbecker <fweisbec@gmail.com>
Reviewed-by: David Ahern <dsahern@gmail.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Documentation/perf-script.txt |  3 ++
 tools/perf/builtin-script.c              | 78 ++++++++++++++++++++++++++++++++
 2 files changed, 81 insertions(+)

diff --git a/tools/perf/Documentation/perf-script.txt b/tools/perf/Documentation/perf-script.txt
index 9a9a7c3d592d..ad67f3b0efda 100644
--- a/tools/perf/Documentation/perf-script.txt
+++ b/tools/perf/Documentation/perf-script.txt
@@ -206,6 +206,9 @@ OPTIONS
 --show-task
 	Display task related events (e.g. FORK, COMM, EXIT).
 
+--show-mmap
+	Display mmap related events (e.g. MMAP, MMAP2).
+
 SEE ALSO
 --------
 linkperf:perf-record[1], linkperf:perf-script-perl[1],
diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index d05e6d835877..03bf978a47ce 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -549,6 +549,7 @@ struct perf_script {
 	struct perf_tool	tool;
 	struct perf_session	*session;
 	bool			show_task_events;
+	bool			show_mmap_events;
 };
 
 static int process_attr(struct perf_tool *tool, union perf_event *event,
@@ -684,6 +685,77 @@ static int process_exit_event(struct perf_tool *tool,
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
+		sample->tid = event->comm.tid;
+		sample->pid = event->comm.pid;
+	}
+	print_sample_start(sample, thread, evsel);
+	printf("mmap: [(%#"PRIx64" - %#"PRIx64") @ %#"PRIx64" ]: %c %s\n",
+	       event->mmap.start, event->mmap.start + event->mmap.len,
+	       event->mmap.pgoff,
+	       (event->header.misc & PERF_RECORD_MISC_MMAP_DATA) ? 'r' : 'x',
+	       event->mmap.filename);
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
+	printf("mmap: [(%#"PRIx64" - %#"PRIx64") @ %#"PRIx64" %02x:%02x %"PRIu64"]: %c %s\n",
+	       event->mmap2.start, event->mmap2.start + event->mmap2.len,
+	       event->mmap2.pgoff, event->mmap2.maj, event->mmap2.min,
+	       event->mmap2.ino,
+	       (event->header.misc & PERF_RECORD_MISC_MMAP_DATA) ? 'r' : 'x',
+	       event->mmap2.filename);
+
+	return 0;
+}
+
 static void sig_handler(int sig __maybe_unused)
 {
 	session_done = 1;
@@ -701,6 +773,10 @@ static int __cmd_script(struct perf_script *script)
 		script->tool.fork = process_fork_event;
 		script->tool.exit = process_exit_event;
 	}
+	if (script->show_mmap_events) {
+		script->tool.mmap = process_mmap_event;
+		script->tool.mmap2 = process_mmap2_event;
+	}
 
 	ret = perf_session__process_events(script->session, &script->tool);
 
@@ -1466,6 +1542,8 @@ int cmd_script(int argc, const char **argv, const char *prefix __maybe_unused)
 		    "Show the path of [kernel.kallsyms]"),
 	OPT_BOOLEAN('\0', "show-task", &script.show_task_events,
 		    "Show the fork/comm/exit events"),
+	OPT_BOOLEAN('\0', "show-mmap", &script.show_mmap_events,
+		    "Show the mmap events"),
 	OPT_END()
 	};
 	const char * const script_usage[] = {
-- 
1.7.11.7

