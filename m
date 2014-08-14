Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251AbaHNIwr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 04:52:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36723 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755216AbaHNIwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 04:52:42 -0400
Date: Thu, 14 Aug 2014 01:51:43 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-cfe1c41405fe9a559f8b3c24c904b2bb42d4a6e8@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
In-Reply-To: <1406786474-9306-3-git-send-email-adrian.hunter@intel.com>
References: <1406786474-9306-3-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf machine: Add machine__thread_exec_comm()
Git-Commit-ID: cfe1c41405fe9a559f8b3c24c904b2bb42d4a6e8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cfe1c41405fe9a559f8b3c24c904b2bb42d4a6e8
Gitweb:     http://git.kernel.org/tip/cfe1c41405fe9a559f8b3c24c904b2bb42d4a6e8
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Thu, 31 Jul 2014 09:00:45 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 13 Aug 2014 19:23:21 -0300

perf machine: Add machine__thread_exec_comm()

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
index 1b383bd..6d2d50d 100644
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
