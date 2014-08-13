Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754553AbaHMWvb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 18:51:31 -0400
Received: from mail.kernel.org ([198.145.19.201]:55777 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754504AbaHMWv1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 18:51:27 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 39/41] perf machine: Add machine__thread_exec_comm()
Date: Wed, 13 Aug 2014 19:48:25 -0300
Message-Id: <1407970107-24540-40-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407970107-24540-1-git-send-email-acme@kernel.org>
References: <1407970107-24540-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Add machine__thread_exec_comm() to return the comm that matches the last
exec, if the comm_exec flag is present, or the last comm otherwise.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1406786474-9306-3-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/machine.c | 26 ++++++++++++++++++++++++++
 tools/perf/util/machine.h |  4 ++++
 tools/perf/util/session.c | 24 +++++++++++++++++++++++-
 3 files changed, 53 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index ea3e09f6a9c6..b093b93607fb 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -31,6 +31,7 @@ int machine__init(struct machine *machine, const char *root_dir, pid_t pid)
 
 	machine->symbol_filter = NULL;
 	machine->id_hdr_size = 0;
+	machine->comm_exec = false;
 
 	machine->root_dir = strdup(root_dir);
 	if (machine->root_dir == NULL)
@@ -179,6 +180,19 @@ void machines__set_symbol_filter(struct machines *machines,
 	}
 }
 
+void machines__set_comm_exec(struct machines *machines, bool comm_exec)
+{
+	struct rb_node *nd;
+
+	machines->host.comm_exec = comm_exec;
+
+	for (nd = rb_first(&machines->guests); nd; nd = rb_next(nd)) {
+		struct machine *machine = rb_entry(nd, struct machine, rb_node);
+
+		machine->comm_exec = comm_exec;
+	}
+}
+
 struct machine *machines__find(struct machines *machines, pid_t pid)
 {
 	struct rb_node **p = &machines->guests.rb_node;
@@ -398,6 +412,15 @@ struct thread *machine__find_thread(struct machine *machine, pid_t pid,
 	return __machine__findnew_thread(machine, pid, tid, false);
 }
 
+struct comm *machine__thread_exec_comm(struct machine *machine,
+				       struct thread *thread)
+{
+	if (machine->comm_exec)
+		return thread__exec_comm(thread);
+	else
+		return thread__comm(thread);
+}
+
 int machine__process_comm_event(struct machine *machine, union perf_event *event,
 				struct perf_sample *sample)
 {
@@ -406,6 +429,9 @@ int machine__process_comm_event(struct machine *machine, union perf_event *event
 							event->comm.tid);
 	bool exec = event->header.misc & PERF_RECORD_MISC_COMM_EXEC;
 
+	if (exec)
+		machine->comm_exec = true;
+
 	if (dump_trace)
 		perf_event__fprintf_comm(event, stdout);
 
diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h
index b972824e6294..61216e028319 100644
--- a/tools/perf/util/machine.h
+++ b/tools/perf/util/machine.h
@@ -26,6 +26,7 @@ struct machine {
 	struct rb_node	  rb_node;
 	pid_t		  pid;
 	u16		  id_hdr_size;
+	bool		  comm_exec;
 	char		  *root_dir;
 	struct rb_root	  threads;
 	struct list_head  dead_threads;
@@ -47,6 +48,8 @@ struct map *machine__kernel_map(struct machine *machine, enum map_type type)
 
 struct thread *machine__find_thread(struct machine *machine, pid_t pid,
 				    pid_t tid);
+struct comm *machine__thread_exec_comm(struct machine *machine,
+				       struct thread *thread);
 
 int machine__process_comm_event(struct machine *machine, union perf_event *event,
 				struct perf_sample *sample);
@@ -88,6 +91,7 @@ char *machine__mmap_name(struct machine *machine, char *bf, size_t size);
 
 void machines__set_symbol_filter(struct machines *machines,
 				 symbol_filter_t symbol_filter);
+void machines__set_comm_exec(struct machines *machines, bool comm_exec);
 
 struct machine *machine__new_host(void);
 int machine__init(struct machine *machine, const char *root_dir, pid_t pid);
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 1b383bd93af6..6d2d50dea1d8 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -67,6 +67,25 @@ static void perf_session__destroy_kernel_maps(struct perf_session *session)
 	machines__destroy_kernel_maps(&session->machines);
 }
 
+static bool perf_session__has_comm_exec(struct perf_session *session)
+{
+	struct perf_evsel *evsel;
+
+	evlist__for_each(session->evlist, evsel) {
+		if (evsel->attr.comm_exec)
+			return true;
+	}
+
+	return false;
+}
+
+static void perf_session__set_comm_exec(struct perf_session *session)
+{
+	bool comm_exec = perf_session__has_comm_exec(session);
+
+	machines__set_comm_exec(&session->machines, comm_exec);
+}
+
 struct perf_session *perf_session__new(struct perf_data_file *file,
 				       bool repipe, struct perf_tool *tool)
 {
@@ -90,6 +109,7 @@ struct perf_session *perf_session__new(struct perf_data_file *file,
 				goto out_close;
 
 			perf_session__set_id_hdr_size(session);
+			perf_session__set_comm_exec(session);
 		}
 	}
 
@@ -866,8 +886,10 @@ static s64 perf_session__process_user_event(struct perf_session *session,
 	switch (event->header.type) {
 	case PERF_RECORD_HEADER_ATTR:
 		err = tool->attr(tool, event, &session->evlist);
-		if (err == 0)
+		if (err == 0) {
 			perf_session__set_id_hdr_size(session);
+			perf_session__set_comm_exec(session);
+		}
 		return err;
 	case PERF_RECORD_HEADER_EVENT_TYPE:
 		/*
-- 
1.9.3

