Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933067Ab3HNS35 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 14:29:57 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34338 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758610Ab3HNSZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 14:25:26 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 06/21] perf sched: Remove sched_process_fork tracepoint
Date: Wed, 14 Aug 2013 15:25:00 -0300
Message-Id: <1376504715-28107-7-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1376504715-28107-1-git-send-email-acme@infradead.org>
References: <1376504715-28107-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

The PERF_RECORD_FORK event is already collected as part of the use of
cmd_record and those events are analyzed as part of the libperf
machinery.  Using the fork tracepoint as well just duplicates the event
load.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1375930261-77273-6-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-sched.c | 60 ++++++++++++++++++++++++----------------------
 1 file changed, 31 insertions(+), 29 deletions(-)

diff --git a/tools/perf/builtin-sched.c b/tools/perf/builtin-sched.c
index 42f4587..f809cc7 100644
--- a/tools/perf/builtin-sched.c
+++ b/tools/perf/builtin-sched.c
@@ -109,8 +109,9 @@ struct trace_sched_handler {
 	int (*wakeup_event)(struct perf_sched *sched, struct perf_evsel *evsel,
 			    struct perf_sample *sample, struct machine *machine);
 
-	int (*fork_event)(struct perf_sched *sched, struct perf_evsel *evsel,
-			  struct perf_sample *sample);
+	/* PERF_RECORD_FORK event, not sched_process_fork tracepoint */
+	int (*fork_event)(struct perf_sched *sched, union perf_event *event,
+			  struct machine *machine);
 
 	int (*migrate_task_event)(struct perf_sched *sched,
 				  struct perf_evsel *evsel,
@@ -717,22 +718,29 @@ static int replay_switch_event(struct perf_sched *sched,
 	return 0;
 }
 
-static int replay_fork_event(struct perf_sched *sched, struct perf_evsel *evsel,
-			     struct perf_sample *sample)
+static int replay_fork_event(struct perf_sched *sched,
+			     union perf_event *event,
+			     struct machine *machine)
 {
-	const char *parent_comm = perf_evsel__strval(evsel, sample, "parent_comm"),
-		   *child_comm  = perf_evsel__strval(evsel, sample, "child_comm");
-	const u32 parent_pid  = perf_evsel__intval(evsel, sample, "parent_pid"),
-		  child_pid  = perf_evsel__intval(evsel, sample, "child_pid");
+	struct thread *child, *parent;
+
+	child = machine__findnew_thread(machine, event->fork.tid);
+	parent = machine__findnew_thread(machine, event->fork.ptid);
+
+	if (child == NULL || parent == NULL) {
+		pr_debug("thread does not exist on fork event: child %p, parent %p\n",
+				 child, parent);
+		return 0;
+	}
 
 	if (verbose) {
-		printf("sched_fork event %p\n", evsel);
-		printf("... parent: %s/%d\n", parent_comm, parent_pid);
-		printf("...  child: %s/%d\n", child_comm, child_pid);
+		printf("fork event\n");
+		printf("... parent: %s/%d\n", parent->comm, parent->tid);
+		printf("...  child: %s/%d\n", child->comm, child->tid);
 	}
 
-	register_pid(sched, parent_pid, parent_comm);
-	register_pid(sched, child_pid, child_comm);
+	register_pid(sched, parent->tid, parent->comm);
+	register_pid(sched, child->tid, child->comm);
 	return 0;
 }
 
@@ -824,14 +832,6 @@ static int thread_atoms_insert(struct perf_sched *sched, struct thread *thread)
 	return 0;
 }
 
-static int latency_fork_event(struct perf_sched *sched __maybe_unused,
-			      struct perf_evsel *evsel __maybe_unused,
-			      struct perf_sample *sample __maybe_unused)
-{
-	/* should insert the newcomer */
-	return 0;
-}
-
 static char sched_out_state(u64 prev_state)
 {
 	const char *str = TASK_STATE_TO_CHAR_STR;
@@ -1379,15 +1379,19 @@ static int process_sched_runtime_event(struct perf_tool *tool,
 	return 0;
 }
 
-static int process_sched_fork_event(struct perf_tool *tool,
-				    struct perf_evsel *evsel,
-				    struct perf_sample *sample,
-				    struct machine *machine __maybe_unused)
+static int perf_sched__process_fork_event(struct perf_tool *tool,
+					  union perf_event *event,
+					  struct perf_sample *sample,
+					  struct machine *machine)
 {
 	struct perf_sched *sched = container_of(tool, struct perf_sched, tool);
 
+	/* run the fork event through the perf machineruy */
+	perf_event__process_fork(tool, event, sample, machine);
+
+	/* and then run additional processing needed for this command */
 	if (sched->tp_handler->fork_event)
-		return sched->tp_handler->fork_event(sched, evsel, sample);
+		return sched->tp_handler->fork_event(sched, event, machine);
 
 	return 0;
 }
@@ -1437,7 +1441,6 @@ static int perf_sched__read_events(struct perf_sched *sched,
 		{ "sched:sched_stat_runtime", process_sched_runtime_event, },
 		{ "sched:sched_wakeup",	      process_sched_wakeup_event, },
 		{ "sched:sched_wakeup_new",   process_sched_wakeup_event, },
-		{ "sched:sched_process_fork", process_sched_fork_event, },
 		{ "sched:sched_migrate_task", process_sched_migrate_task_event, },
 	};
 	struct perf_session *session;
@@ -1652,7 +1655,7 @@ static struct perf_sched sched = {
 		.sample		 = perf_sched__process_tracepoint_sample,
 		.comm		 = perf_event__process_comm,
 		.lost		 = perf_event__process_lost,
-		.fork		 = perf_event__process_fork,
+		.fork		 = perf_sched__process_fork_event,
 		.ordered_samples = true,
 	},
 	.cmp_pid	      = LIST_HEAD_INIT(sched.cmp_pid),
@@ -1714,7 +1717,6 @@ int cmd_sched(int argc, const char **argv, const char *prefix __maybe_unused)
 		.wakeup_event	    = latency_wakeup_event,
 		.switch_event	    = latency_switch_event,
 		.runtime_event	    = latency_runtime_event,
-		.fork_event	    = latency_fork_event,
 		.migrate_task_event = latency_migrate_task_event,
 	};
 	struct trace_sched_handler map_ops  = {
-- 
1.8.1.4

