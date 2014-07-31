Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756188AbaGaGC3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 02:02:29 -0400
Received: from mga11.intel.com ([192.55.52.93]:44617 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756157AbaGaGC1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 02:02:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,770,1400050800"; 
   d="scan'208";a="569799620"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 01/31] perf tools: Identify which comms are from exec
Date: Thu, 31 Jul 2014 09:00:44 +0300
Message-Id: <1406786474-9306-2-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1406786474-9306-1-git-send-email-adrian.hunter@intel.com>
References: <1406786474-9306-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/comm.c    |  7 +++++--
 tools/perf/util/comm.h    |  6 ++++--
 tools/perf/util/machine.c |  4 +++-
 tools/perf/util/thread.c  | 24 +++++++++++++++++++-----
 tools/perf/util/thread.h  | 10 +++++++++-
 5 files changed, 40 insertions(+), 11 deletions(-)

diff --git a/tools/perf/util/comm.c b/tools/perf/util/comm.c
index f9e7776..5e1e80e 100644
--- a/tools/perf/util/comm.c
+++ b/tools/perf/util/comm.c
@@ -74,7 +74,7 @@ static struct comm_str *comm_str__findnew(const char *str, struct rb_root *root)
 	return new;
 }
 
-struct comm *comm__new(const char *str, u64 timestamp)
+struct comm *comm__new(const char *str, u64 timestamp, bool exec)
 {
 	struct comm *comm = zalloc(sizeof(*comm));
 
@@ -82,6 +82,7 @@ struct comm *comm__new(const char *str, u64 timestamp)
 		return NULL;
 
 	comm->start = timestamp;
+	comm->exec = exec;
 
 	comm->comm_str = comm_str__findnew(str, &comm_str_root);
 	if (!comm->comm_str) {
@@ -94,7 +95,7 @@ struct comm *comm__new(const char *str, u64 timestamp)
 	return comm;
 }
 
-int comm__override(struct comm *comm, const char *str, u64 timestamp)
+int comm__override(struct comm *comm, const char *str, u64 timestamp, bool exec)
 {
 	struct comm_str *new, *old = comm->comm_str;
 
@@ -106,6 +107,8 @@ int comm__override(struct comm *comm, const char *str, u64 timestamp)
 	comm_str__put(old);
 	comm->comm_str = new;
 	comm->start = timestamp;
+	if (exec && !comm->exec)
+		comm->exec = true;
 
 	return 0;
 }
diff --git a/tools/perf/util/comm.h b/tools/perf/util/comm.h
index fac5bd5..51c10ab 100644
--- a/tools/perf/util/comm.h
+++ b/tools/perf/util/comm.h
@@ -11,11 +11,13 @@ struct comm {
 	struct comm_str *comm_str;
 	u64 start;
 	struct list_head list;
+	bool exec;
 };
 
 void comm__free(struct comm *comm);
-struct comm *comm__new(const char *str, u64 timestamp);
+struct comm *comm__new(const char *str, u64 timestamp, bool exec);
 const char *comm__str(const struct comm *comm);
-int comm__override(struct comm *comm, const char *str, u64 timestamp);
+int comm__override(struct comm *comm, const char *str, u64 timestamp,
+		   bool exec);
 
 #endif  /* __PERF_COMM_H */
diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 16bba9f..ea3e09f 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -404,11 +404,13 @@ int machine__process_comm_event(struct machine *machine, union perf_event *event
 	struct thread *thread = machine__findnew_thread(machine,
 							event->comm.pid,
 							event->comm.tid);
+	bool exec = event->header.misc & PERF_RECORD_MISC_COMM_EXEC;
 
 	if (dump_trace)
 		perf_event__fprintf_comm(event, stdout);
 
-	if (thread == NULL || thread__set_comm(thread, event->comm.comm, sample->time)) {
+	if (thread == NULL ||
+	    __thread__set_comm(thread, event->comm.comm, sample->time, exec)) {
 		dump_printf("problem processing PERF_RECORD_COMM, skipping event.\n");
 		return -1;
 	}
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index 12c7a25..a9df7f2 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -42,7 +42,7 @@ struct thread *thread__new(pid_t pid, pid_t tid)
 			goto err_thread;
 
 		snprintf(comm_str, 32, ":%d", tid);
-		comm = comm__new(comm_str, 0);
+		comm = comm__new(comm_str, 0, false);
 		free(comm_str);
 		if (!comm)
 			goto err_thread;
@@ -81,19 +81,33 @@ struct comm *thread__comm(const struct thread *thread)
 	return list_first_entry(&thread->comm_list, struct comm, list);
 }
 
+struct comm *thread__exec_comm(const struct thread *thread)
+{
+	struct comm *comm, *last = NULL;
+
+	list_for_each_entry(comm, &thread->comm_list, list) {
+		if (comm->exec)
+			return comm;
+		last = comm;
+	}
+
+	return last;
+}
+
 /* CHECKME: time should always be 0 if event aren't ordered */
-int thread__set_comm(struct thread *thread, const char *str, u64 timestamp)
+int __thread__set_comm(struct thread *thread, const char *str, u64 timestamp,
+		       bool exec)
 {
 	struct comm *new, *curr = thread__comm(thread);
 	int err;
 
 	/* Override latest entry if it had no specific time coverage */
-	if (!curr->start) {
-		err = comm__override(curr, str, timestamp);
+	if (!curr->start && !curr->exec) {
+		err = comm__override(curr, str, timestamp, exec);
 		if (err)
 			return err;
 	} else {
-		new = comm__new(str, timestamp);
+		new = comm__new(str, timestamp, exec);
 		if (!new)
 			return -ENOMEM;
 		list_add(&new->list, &thread->comm_list);
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index 716b772..8c75fa7 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -38,9 +38,17 @@ static inline void thread__exited(struct thread *thread)
 	thread->dead = true;
 }
 
-int thread__set_comm(struct thread *thread, const char *comm, u64 timestamp);
+int __thread__set_comm(struct thread *thread, const char *comm, u64 timestamp,
+		       bool exec);
+static inline int thread__set_comm(struct thread *thread, const char *comm,
+				   u64 timestamp)
+{
+	return __thread__set_comm(thread, comm, timestamp, false);
+}
+
 int thread__comm_len(struct thread *thread);
 struct comm *thread__comm(const struct thread *thread);
+struct comm *thread__exec_comm(const struct thread *thread);
 const char *thread__comm_str(const struct thread *thread);
 void thread__insert_map(struct thread *thread, struct map *map);
 int thread__fork(struct thread *thread, struct thread *parent, u64 timestamp);
-- 
1.8.3.2

