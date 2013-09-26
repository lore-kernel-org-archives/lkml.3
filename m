Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098Ab3IZJAW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 05:00:22 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:61659 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755864Ab3IZI6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 04:58:19 -0400
X-AuditID: 9c93016f-b7bc8ae000004e6e-e2-5243f7252879
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5/8] perf tools: Add time argument on comm setting
Date: Thu, 26 Sep 2013 17:58:07 +0900
Message-Id: <1380185890-25758-6-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1380185890-25758-1-git-send-email-namhyung@kernel.org>
References: <1380185890-25758-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>

This way we can later delimit a lifecycle for the comm and map a hist to
a precise comm:timeslice couple.

Comm and fork events that don't have PERF_SAMPLE_TIME samples can only
send 0 value as a timestamp and thus should overwrite any previous comm
on a given thread because there is no sensible way to keep track of all
the comms lifecycles in a thread without time informations.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-6tyow99vgmmtt9qwr2u2lqd7@git.kernel.org
[ Made it cope with PERF_RECORD_MMAP2 ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-top.c        |  2 +-
 tools/perf/builtin-trace.c      | 12 ++++++------
 tools/perf/tests/code-reading.c |  2 +-
 tools/perf/tests/hists_link.c   |  4 ++--
 tools/perf/util/event.c         | 28 ++++++++++++++--------------
 tools/perf/util/machine.c       | 39 ++++++++++++++++++++++-----------------
 tools/perf/util/machine.h       | 21 ++++++++++++++-------
 tools/perf/util/session.c       |  2 +-
 tools/perf/util/thread.c        |  6 ++++--
 tools/perf/util/thread.h        |  4 ++--
 10 files changed, 67 insertions(+), 53 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 0cb077f823de..bb5364c87c3f 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -856,7 +856,7 @@ static void perf_top__mmap_read_idx(struct perf_top *top, int idx)
 						   &sample, machine);
 		} else if (event->header.type < PERF_RECORD_MAX) {
 			hists__inc_nr_events(&evsel->hists, event->header.type);
-			machine__process_event(machine, event);
+			machine__process_event(machine, event, &sample);
 		} else
 			++session->stats.nr_unknown_events;
 	}
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index a96fd47b369b..f1d0dc48ba34 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1034,7 +1034,7 @@ static size_t trace__fprintf_entry_head(struct trace *trace, struct thread *thre
 }
 
 static int trace__process_event(struct trace *trace, struct machine *machine,
-				union perf_event *event)
+				union perf_event *event, struct perf_sample *sample)
 {
 	int ret = 0;
 
@@ -1042,9 +1042,9 @@ static int trace__process_event(struct trace *trace, struct machine *machine,
 	case PERF_RECORD_LOST:
 		color_fprintf(trace->output, PERF_COLOR_RED,
 			      "LOST %" PRIu64 " events!\n", event->lost.lost);
-		ret = machine__process_lost_event(machine, event);
+		ret = machine__process_lost_event(machine, event, sample);
 	default:
-		ret = machine__process_event(machine, event);
+		ret = machine__process_event(machine, event, sample);
 		break;
 	}
 
@@ -1053,11 +1053,11 @@ static int trace__process_event(struct trace *trace, struct machine *machine,
 
 static int trace__tool_process(struct perf_tool *tool,
 			       union perf_event *event,
-			       struct perf_sample *sample __maybe_unused,
+			       struct perf_sample *sample,
 			       struct machine *machine)
 {
 	struct trace *trace = container_of(tool, struct trace, tool);
-	return trace__process_event(trace, machine, event);
+	return trace__process_event(trace, machine, event, sample);
 }
 
 static int trace__symbols_init(struct trace *trace, struct perf_evlist *evlist)
@@ -1581,7 +1581,7 @@ again:
 				trace->base_time = sample.time;
 
 			if (type != PERF_RECORD_SAMPLE) {
-				trace__process_event(trace, &trace->host, event);
+				trace__process_event(trace, &trace->host, event, &sample);
 				continue;
 			}
 
diff --git a/tools/perf/tests/code-reading.c b/tools/perf/tests/code-reading.c
index 6fb781d5586c..38d233a27de6 100644
--- a/tools/perf/tests/code-reading.c
+++ b/tools/perf/tests/code-reading.c
@@ -276,7 +276,7 @@ static int process_event(struct machine *machine, struct perf_evlist *evlist,
 		return process_sample_event(machine, evlist, event, state);
 
 	if (event->header.type < PERF_RECORD_MAX)
-		return machine__process_event(machine, event);
+		return machine__process_event(machine, event, NULL);
 
 	return 0;
 }
diff --git a/tools/perf/tests/hists_link.c b/tools/perf/tests/hists_link.c
index 735cff2c52ce..56f811d55a6f 100644
--- a/tools/perf/tests/hists_link.c
+++ b/tools/perf/tests/hists_link.c
@@ -93,7 +93,7 @@ static struct machine *setup_fake_machine(struct machines *machines)
 		if (thread == NULL)
 			goto out;
 
-		thread__set_comm(thread, fake_threads[i].comm);
+		thread__set_comm(thread, fake_threads[i].comm, 0);
 	}
 
 	for (i = 0; i < ARRAY_SIZE(fake_mmap_info); i++) {
@@ -110,7 +110,7 @@ static struct machine *setup_fake_machine(struct machines *machines)
 		strcpy(fake_mmap_event.mmap.filename,
 		       fake_mmap_info[i].filename);
 
-		machine__process_mmap_event(machine, &fake_mmap_event);
+		machine__process_mmap_event(machine, &fake_mmap_event, NULL);
 	}
 
 	for (i = 0; i < ARRAY_SIZE(fake_symbols); i++) {
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index d639bfe29309..c7b2458b47a6 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -516,18 +516,18 @@ size_t perf_event__fprintf_comm(union perf_event *event, FILE *fp)
 
 int perf_event__process_comm(struct perf_tool *tool __maybe_unused,
 			     union perf_event *event,
-			     struct perf_sample *sample __maybe_unused,
+			     struct perf_sample *sample,
 			     struct machine *machine)
 {
-	return machine__process_comm_event(machine, event);
+	return machine__process_comm_event(machine, event, sample);
 }
 
 int perf_event__process_lost(struct perf_tool *tool __maybe_unused,
 			     union perf_event *event,
-			     struct perf_sample *sample __maybe_unused,
+			     struct perf_sample *sample,
 			     struct machine *machine)
 {
-	return machine__process_lost_event(machine, event);
+	return machine__process_lost_event(machine, event, sample);
 }
 
 size_t perf_event__fprintf_mmap(union perf_event *event, FILE *fp)
@@ -550,18 +550,18 @@ size_t perf_event__fprintf_mmap2(union perf_event *event, FILE *fp)
 
 int perf_event__process_mmap(struct perf_tool *tool __maybe_unused,
 			     union perf_event *event,
-			     struct perf_sample *sample __maybe_unused,
+			     struct perf_sample *sample,
 			     struct machine *machine)
 {
-	return machine__process_mmap_event(machine, event);
+	return machine__process_mmap_event(machine, event, sample);
 }
 
 int perf_event__process_mmap2(struct perf_tool *tool __maybe_unused,
 			     union perf_event *event,
-			     struct perf_sample *sample __maybe_unused,
+			     struct perf_sample *sample,
 			     struct machine *machine)
 {
-	return machine__process_mmap2_event(machine, event);
+	return machine__process_mmap2_event(machine, event, sample);
 }
 
 size_t perf_event__fprintf_task(union perf_event *event, FILE *fp)
@@ -573,18 +573,18 @@ size_t perf_event__fprintf_task(union perf_event *event, FILE *fp)
 
 int perf_event__process_fork(struct perf_tool *tool __maybe_unused,
 			     union perf_event *event,
-			     struct perf_sample *sample __maybe_unused,
+			     struct perf_sample *sample,
 			     struct machine *machine)
 {
-	return machine__process_fork_event(machine, event);
+	return machine__process_fork_event(machine, event, sample);
 }
 
 int perf_event__process_exit(struct perf_tool *tool __maybe_unused,
 			     union perf_event *event,
-			     struct perf_sample *sample __maybe_unused,
+			     struct perf_sample *sample,
 			     struct machine *machine)
 {
-	return machine__process_exit_event(machine, event);
+	return machine__process_exit_event(machine, event, sample);
 }
 
 size_t perf_event__fprintf(union perf_event *event, FILE *fp)
@@ -615,10 +615,10 @@ size_t perf_event__fprintf(union perf_event *event, FILE *fp)
 
 int perf_event__process(struct perf_tool *tool __maybe_unused,
 			union perf_event *event,
-			struct perf_sample *sample __maybe_unused,
+			struct perf_sample *sample,
 			struct machine *machine)
 {
-	return machine__process_event(machine, event);
+	return machine__process_event(machine, event, sample);
 }
 
 void thread__find_addr_map(struct thread *self,
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 933d14f287ca..b8fc8a0d03ec 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -40,7 +40,7 @@ int machine__init(struct machine *machine, const char *root_dir, pid_t pid)
 			return -ENOMEM;
 
 		snprintf(comm, sizeof(comm), "[guest/%d]", pid);
-		thread__set_comm(thread, comm);
+		thread__set_comm(thread, comm, 0);
 	}
 
 	return 0;
@@ -314,7 +314,8 @@ struct thread *machine__find_thread(struct machine *machine, pid_t tid)
 	return __machine__findnew_thread(machine, 0, tid, false);
 }
 
-int machine__process_comm_event(struct machine *machine, union perf_event *event)
+int machine__process_comm_event(struct machine *machine, union perf_event *event,
+				struct perf_sample *sample)
 {
 	struct thread *thread = machine__findnew_thread(machine,
 							event->comm.pid,
@@ -323,7 +324,7 @@ int machine__process_comm_event(struct machine *machine, union perf_event *event
 	if (dump_trace)
 		perf_event__fprintf_comm(event, stdout);
 
-	if (thread == NULL || thread__set_comm(thread, event->comm.comm)) {
+	if (thread == NULL || thread__set_comm(thread, event->comm.comm, sample->time)) {
 		dump_printf("problem processing PERF_RECORD_COMM, skipping event.\n");
 		return -1;
 	}
@@ -332,7 +333,7 @@ int machine__process_comm_event(struct machine *machine, union perf_event *event
 }
 
 int machine__process_lost_event(struct machine *machine __maybe_unused,
-				union perf_event *event)
+				union perf_event *event, struct perf_sample *sample __maybe_unused)
 {
 	dump_printf(": id:%" PRIu64 ": lost:%" PRIu64 "\n",
 		    event->lost.id, event->lost.lost);
@@ -998,7 +999,8 @@ out_problem:
 }
 
 int machine__process_mmap2_event(struct machine *machine,
-				 union perf_event *event)
+				 union perf_event *event,
+				 struct perf_sample *sample __maybe_unused)
 {
 	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
 	struct thread *thread;
@@ -1045,7 +1047,8 @@ out_problem:
 	return 0;
 }
 
-int machine__process_mmap_event(struct machine *machine, union perf_event *event)
+int machine__process_mmap_event(struct machine *machine, union perf_event *event,
+				struct perf_sample *sample __maybe_unused)
 {
 	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
 	struct thread *thread;
@@ -1102,7 +1105,8 @@ static void machine__remove_thread(struct machine *machine, struct thread *th)
 	list_add_tail(&th->node, &machine->dead_threads);
 }
 
-int machine__process_fork_event(struct machine *machine, union perf_event *event)
+int machine__process_fork_event(struct machine *machine, union perf_event *event,
+				struct perf_sample *sample)
 {
 	struct thread *thread = machine__find_thread(machine, event->fork.tid);
 	struct thread *parent = machine__findnew_thread(machine,
@@ -1119,7 +1123,7 @@ int machine__process_fork_event(struct machine *machine, union perf_event *event
 		perf_event__fprintf_task(event, stdout);
 
 	if (thread == NULL || parent == NULL ||
-	    thread__fork(thread, parent) < 0) {
+	    thread__fork(thread, parent, sample->time) < 0) {
 		dump_printf("problem processing PERF_RECORD_FORK, skipping event.\n");
 		return -1;
 	}
@@ -1127,8 +1131,8 @@ int machine__process_fork_event(struct machine *machine, union perf_event *event
 	return 0;
 }
 
-int machine__process_exit_event(struct machine *machine __maybe_unused,
-				union perf_event *event)
+int machine__process_exit_event(struct machine *machine, union perf_event *event,
+				struct perf_sample *sample __maybe_unused)
 {
 	struct thread *thread = machine__find_thread(machine, event->fork.tid);
 
@@ -1141,23 +1145,24 @@ int machine__process_exit_event(struct machine *machine __maybe_unused,
 	return 0;
 }
 
-int machine__process_event(struct machine *machine, union perf_event *event)
+int machine__process_event(struct machine *machine, union perf_event *event,
+			   struct perf_sample *sample)
 {
 	int ret;
 
 	switch (event->header.type) {
 	case PERF_RECORD_COMM:
-		ret = machine__process_comm_event(machine, event); break;
+		ret = machine__process_comm_event(machine, event, sample); break;
 	case PERF_RECORD_MMAP:
-		ret = machine__process_mmap_event(machine, event); break;
+		ret = machine__process_mmap_event(machine, event, sample); break;
 	case PERF_RECORD_MMAP2:
-		ret = machine__process_mmap2_event(machine, event); break;
+		ret = machine__process_mmap2_event(machine, event, sample); break;
 	case PERF_RECORD_FORK:
-		ret = machine__process_fork_event(machine, event); break;
+		ret = machine__process_fork_event(machine, event, sample); break;
 	case PERF_RECORD_EXIT:
-		ret = machine__process_exit_event(machine, event); break;
+		ret = machine__process_exit_event(machine, event, sample); break;
 	case PERF_RECORD_LOST:
-		ret = machine__process_lost_event(machine, event); break;
+		ret = machine__process_lost_event(machine, event, sample); break;
 	default:
 		ret = -1;
 		break;
diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h
index 58a6be1fc739..1db29d8ce595 100644
--- a/tools/perf/util/machine.h
+++ b/tools/perf/util/machine.h
@@ -40,13 +40,20 @@ struct map *machine__kernel_map(struct machine *machine, enum map_type type)
 
 struct thread *machine__find_thread(struct machine *machine, pid_t tid);
 
-int machine__process_comm_event(struct machine *machine, union perf_event *event);
-int machine__process_exit_event(struct machine *machine, union perf_event *event);
-int machine__process_fork_event(struct machine *machine, union perf_event *event);
-int machine__process_lost_event(struct machine *machine, union perf_event *event);
-int machine__process_mmap_event(struct machine *machine, union perf_event *event);
-int machine__process_mmap2_event(struct machine *machine, union perf_event *event);
-int machine__process_event(struct machine *machine, union perf_event *event);
+int machine__process_comm_event(struct machine *machine, union perf_event *event,
+				struct perf_sample *sample);
+int machine__process_exit_event(struct machine *machine, union perf_event *event,
+				struct perf_sample *sample);
+int machine__process_fork_event(struct machine *machine, union perf_event *event,
+				struct perf_sample *sample);
+int machine__process_lost_event(struct machine *machine, union perf_event *event,
+				struct perf_sample *sample);
+int machine__process_mmap_event(struct machine *machine, union perf_event *event,
+				struct perf_sample *sample);
+int machine__process_mmap2_event(struct machine *machine, union perf_event *event,
+				 struct perf_sample *sample);
+int machine__process_event(struct machine *machine, union perf_event *event,
+				struct perf_sample *sample);
 
 typedef void (*machine__process_t)(struct machine *machine, void *data);
 
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 9f62be8bc167..8de3ab388187 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1130,7 +1130,7 @@ static struct thread *perf_session__register_idle_thread(struct perf_session *se
 {
 	struct thread *thread = perf_session__findnew(self, 0);
 
-	if (thread == NULL || thread__set_comm(thread, "swapper")) {
+	if (thread == NULL || thread__set_comm(thread, "swapper", 0)) {
 		pr_err("problem inserting idle task.\n");
 		thread = NULL;
 	}
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index bb50b9fda9c2..509abed750e6 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -31,7 +31,8 @@ void thread__delete(struct thread *self)
 	free(self);
 }
 
-int thread__set_comm(struct thread *self, const char *comm)
+int thread__set_comm(struct thread *self, const char *comm,
+		     u64 timestamp __maybe_unused)
 {
 	int err;
 
@@ -73,7 +74,8 @@ void thread__insert_map(struct thread *self, struct map *map)
 	map_groups__insert(&self->mg, map);
 }
 
-int thread__fork(struct thread *self, struct thread *parent)
+int thread__fork(struct thread *self, struct thread *parent,
+		 u64 timestamp __maybe_unused)
 {
 	int i;
 
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index 84db214d90bd..b738c9948508 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -33,11 +33,11 @@ static inline void thread__exited(struct thread *thread)
 	thread->dead = true;
 }
 
-int thread__set_comm(struct thread *self, const char *comm);
+int thread__set_comm(struct thread *self, const char *comm, u64 timestamp);
 int thread__comm_len(struct thread *self);
 const char *thread__comm_curr(const struct thread *thread);
 void thread__insert_map(struct thread *self, struct map *map);
-int thread__fork(struct thread *self, struct thread *parent);
+int thread__fork(struct thread *self, struct thread *parent, u64 timestamp);
 size_t thread__fprintf(struct thread *thread, FILE *fp);
 
 static inline struct map *thread__find_map(struct thread *self,
-- 
1.7.11.7

