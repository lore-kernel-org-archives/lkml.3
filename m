Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234AbaHNIwo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 04:52:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36719 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755211AbaHNIwj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 04:52:39 -0400
Date: Thu, 14 Aug 2014 01:51:30 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-65de51f93ebf9305ec011da59c0b5fe29429d1b9@git.kernel.org>
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
In-Reply-To: <1406786474-9306-2-git-send-email-adrian.hunter@intel.com>
References: <1406786474-9306-2-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Identify which comms are from exec
Git-Commit-ID: 65de51f93ebf9305ec011da59c0b5fe29429d1b9
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

Commit-ID:  65de51f93ebf9305ec011da59c0b5fe29429d1b9
Gitweb:     http://git.kernel.org/tip/65de51f93ebf9305ec011da59c0b5fe29429d1b9
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Thu, 31 Jul 2014 09:00:44 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 13 Aug 2014 19:23:08 -0300

perf tools: Identify which comms are from exec

For grouping together all the data from a single execution, which is
needed for pairing calls and returns e.g. any outstanding calls when a
process exec's will never return.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1406786474-9306-2-git-send-email-adrian.hunter@intel.com
[ Remove testing if comm->exec is false before setting it to true ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/comm.c    |  7 +++++--
 tools/perf/util/comm.h    |  6 ++++--
 tools/perf/util/machine.c |  4 +++-
 tools/perf/util/thread.c  | 24 +++++++++++++++++++-----
 tools/perf/util/thread.h  | 10 +++++++++-
 5 files changed, 40 insertions(+), 11 deletions(-)

diff --git a/tools/perf/util/comm.c b/tools/perf/util/comm.c
index f9e7776..b2bb59d 100644
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
+	if (exec)
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
