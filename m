Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854AbaGaGKq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 02:10:46 -0400
Received: from mga11.intel.com ([192.55.52.93]:44617 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756158AbaGaGC2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 02:02:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,770,1400050800"; 
   d="scan'208";a="569799663"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 02/31] perf tools: Add machine__thread_exec_comm()
Date: Thu, 31 Jul 2014 09:00:45 +0300
Message-Id: <1406786474-9306-3-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1406786474-9306-1-git-send-email-adrian.hunter@intel.com>
References: <1406786474-9306-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add machine__thread_exec_comm() to return the comm
that matches the last exec, if the comm_exec flag
is present, or the last comm otherwise.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/machine.c | 26 ++++++++++++++++++++++++++
 tools/perf/util/machine.h |  4 ++++
 tools/perf/util/session.c | 24 +++++++++++++++++++++++-
 3 files changed, 53 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index ea3e09f..b093b93 100644
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
index b972824..61216e0 100644
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
index 88dfef7..bf24696 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -66,6 +66,25 @@ static void perf_session__destroy_kernel_maps(struct perf_session *session)
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
@@ -91,6 +110,7 @@ struct perf_session *perf_session__new(struct perf_data_file *file,
 				goto out_close;
 
 			perf_session__set_id_hdr_size(session);
+			perf_session__set_comm_exec(session);
 		}
 	}
 
@@ -1005,8 +1025,10 @@ static s64 perf_session__process_user_event(struct perf_session *session,
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
1.8.3.2

