Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756634Ab3ILUaF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 16:30:05 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:51607 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756238Ab3ILU3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 16:29:54 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 2/4] perf tools: Add time argument on comm setting
Date: Thu, 12 Sep 2013 22:29:41 +0200
Message-Id: <1379017783-27032-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1379017783-27032-1-git-send-email-fweisbec@gmail.com>
References: <1379017783-27032-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This way we can later delimit a lifecycle for the comm and map
a hist to a precise comm:timeslice couple.

Comm and fork events that don't have PERF_SAMPLE_TIME samples
can only send 0 value as a timestamp and thus should overwrite any
previous comm on a given thread because there is no sensible way
to keep track of all the comms lifecycles in a thread without
time informations.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/builtin-top.c        |    2 +-
 tools/perf/builtin-trace.c      |   12 ++++++------
 tools/perf/tests/code-reading.c |    2 +-
 tools/perf/tests/hists_link.c   |    4 ++--
 tools/perf/util/event.c         |   24 ++++++++++++------------
 tools/perf/util/machine.c       |   34 +++++++++++++++++++---------------
 tools/perf/util/machine.h       |   18 ++++++++++++------
 tools/perf/util/session.c       |    2 +-
 tools/perf/util/thread.c        |    6 ++++--
 tools/perf/util/thread.h        |    4 ++--
 10 files changed, 60 insertions(+), 48 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 2122141..ccf707d 100644
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
index d14ec25..a57063e 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -456,7 +456,7 @@ static size_t trace__fprintf_entry_head(struct trace *trace, struct thread *thre
 }
 
 static int trace__process_event(struct trace *trace, struct machine *machine,
-				union perf_event *event)
+				union perf_event *event, struct perf_sample *sample)
 {
 	int ret = 0;
 
@@ -464,9 +464,9 @@ static int trace__process_event(struct trace *trace, struct machine *machine,
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
 
@@ -475,11 +475,11 @@ static int trace__process_event(struct trace *trace, struct machine *machine,
 
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
@@ -977,7 +977,7 @@ again:
 				trace->base_time = sample.time;
 
 			if (type != PERF_RECORD_SAMPLE) {
-				trace__process_event(trace, &trace->host, event);
+				trace__process_event(trace, &trace->host, event, &sample);
 				continue;
 			}
 
diff --git a/tools/perf/tests/code-reading.c b/tools/perf/tests/code-reading.c
index 6fb781d..38d233a 100644
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
index 274be5d..a97063d 100644
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
index c3a35ca..5c9508a 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -506,18 +506,18 @@ size_t perf_event__fprintf_comm(union perf_event *event, FILE *fp)
 
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
@@ -529,10 +529,10 @@ size_t perf_event__fprintf_mmap(union perf_event *event, FILE *fp)
 
 int perf_event__process_mmap(struct perf_tool *tool __maybe_unused,
 			     union perf_event *event,
-			     struct perf_sample *sample __maybe_unused,
+			     struct perf_sample *sample,
 			     struct machine *machine)
 {
-	return machine__process_mmap_event(machine, event);
+	return machine__process_mmap_event(machine, event, sample);
 }
 
 size_t perf_event__fprintf_task(union perf_event *event, FILE *fp)
@@ -544,18 +544,18 @@ size_t perf_event__fprintf_task(union perf_event *event, FILE *fp)
 
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
@@ -583,10 +583,10 @@ size_t perf_event__fprintf(union perf_event *event, FILE *fp)
 
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
index 1dca61f..c862686 100644
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
@@ -997,7 +998,8 @@ out_problem:
 	return -1;
 }
 
-int machine__process_mmap_event(struct machine *machine, union perf_event *event)
+int machine__process_mmap_event(struct machine *machine, union perf_event *event,
+				struct perf_sample *sample __maybe_unused)
 {
 	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
 	struct thread *thread;
@@ -1053,7 +1055,8 @@ static void machine__remove_thread(struct machine *machine, struct thread *th)
 	list_add_tail(&th->node, &machine->dead_threads);
 }
 
-int machine__process_fork_event(struct machine *machine, union perf_event *event)
+int machine__process_fork_event(struct machine *machine, union perf_event *event,
+				struct perf_sample *sample)
 {
 	struct thread *thread = machine__find_thread(machine, event->fork.tid);
 	struct thread *parent = machine__findnew_thread(machine,
@@ -1070,7 +1073,7 @@ int machine__process_fork_event(struct machine *machine, union perf_event *event
 		perf_event__fprintf_task(event, stdout);
 
 	if (thread == NULL || parent == NULL ||
-	    thread__fork(thread, parent) < 0) {
+	    thread__fork(thread, parent, sample->time) < 0) {
 		dump_printf("problem processing PERF_RECORD_FORK, skipping event.\n");
 		return -1;
 	}
@@ -1078,8 +1081,8 @@ int machine__process_fork_event(struct machine *machine, union perf_event *event
 	return 0;
 }
 
-int machine__process_exit_event(struct machine *machine __maybe_unused,
-				union perf_event *event)
+int machine__process_exit_event(struct machine *machine, union perf_event *event,
+				struct perf_sample *sample __maybe_unused)
 {
 	struct thread *thread = machine__find_thread(machine, event->fork.tid);
 
@@ -1092,21 +1095,22 @@ int machine__process_exit_event(struct machine *machine __maybe_unused,
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
index 0df925b..fda2839 100644
--- a/tools/perf/util/machine.h
+++ b/tools/perf/util/machine.h
@@ -40,12 +40,18 @@ struct map *machine__kernel_map(struct machine *machine, enum map_type type)
 
 struct thread *machine__find_thread(struct machine *machine, pid_t tid);
 
-int machine__process_comm_event(struct machine *machine, union perf_event *event);
-int machine__process_exit_event(struct machine *machine, union perf_event *event);
-int machine__process_fork_event(struct machine *machine, union perf_event *event);
-int machine__process_lost_event(struct machine *machine, union perf_event *event);
-int machine__process_mmap_event(struct machine *machine, union perf_event *event);
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
+int machine__process_event(struct machine *machine, union perf_event *event,
+				struct perf_sample *sample);
 
 typedef void (*machine__process_t)(struct machine *machine, void *data);
 
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 476caa1..8ef2d6d 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1089,7 +1089,7 @@ static struct thread *perf_session__register_idle_thread(struct perf_session *se
 {
 	struct thread *thread = perf_session__findnew(self, 0);
 
-	if (thread == NULL || thread__set_comm(thread, "swapper")) {
+	if (thread == NULL || thread__set_comm(thread, "swapper", 0)) {
 		pr_err("problem inserting idle task.\n");
 		thread = NULL;
 	}
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index a139451..1466baf 100644
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
index 4eccee7..fda69d9 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -33,11 +33,11 @@ static inline void thread__exited(struct thread *thread)
 	thread->dead = true;
 }
 
-int thread__set_comm(struct thread *self, const char *comm);
+int thread__set_comm(struct thread *self, const char *comm, u64 timestamp);
 int thread__comm_len(struct thread *self);
 const char *thread__comm_curr(struct thread *self);
 void thread__insert_map(struct thread *self, struct map *map);
-int thread__fork(struct thread *self, struct thread *parent);
+int thread__fork(struct thread *self, struct thread *parent, u64 timestamp);
 size_t thread__fprintf(struct thread *thread, FILE *fp);
 
 static inline struct map *thread__find_map(struct thread *self,
-- 
1.7.5.4

