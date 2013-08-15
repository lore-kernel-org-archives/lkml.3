Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756611Ab3HOH4L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 03:56:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53870 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab3HOH4I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 03:56:08 -0400
Date: Thu, 15 Aug 2013 00:55:34 -0700
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-cb627505ae028a0cd88cc29ed72a4c168a08751d@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1375930261-77273-6-git-send-email-dsahern@gmail.com>
References: <1375930261-77273-6-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf sched: Remove sched_process_fork tracepoint
Git-Commit-ID: cb627505ae028a0cd88cc29ed72a4c168a08751d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 15 Aug 2013 00:55:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cb627505ae028a0cd88cc29ed72a4c168a08751d
Gitweb:     http://git.kernel.org/tip/cb627505ae028a0cd88cc29ed72a4c168a08751d
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Wed, 7 Aug 2013 22:50:47 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 12 Aug 2013 10:31:07 -0300

perf sched: Remove sched_process_fork tracepoint

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
