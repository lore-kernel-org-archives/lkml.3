Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410Ab3F0HvV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 03:51:21 -0400
Received: from mga01.intel.com ([192.55.52.88]:6235 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753352Ab3F0HuU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 03:50:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,950,1363158000"; 
   d="scan'208";a="361296468"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH V2 14/15] perf tools: add pid to struct thread
Date: Thu, 27 Jun 2013 10:55:06 +0300
Message-Id: <1372319707-13892-15-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1372319707-13892-1-git-send-email-adrian.hunter@intel.com>
References: <1372319707-13892-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Record pid on struct thread.  The member is named 'pid_'
to avoid confusion with the 'tid' member which was previously
named 'pid'.

Note that while "machine" functions update 'pid_', most tools
do not.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/machine.c | 47 ++++++++++++++++++++++++++++++++++++++---------
 tools/perf/util/machine.h |  4 ++++
 tools/perf/util/thread.c  |  3 ++-
 tools/perf/util/thread.h  |  3 ++-
 4 files changed, 46 insertions(+), 11 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index ef0be97..d11ca3b 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -233,7 +233,8 @@ void machines__set_id_hdr_size(struct machines *machines, u16 id_hdr_size)
 	return;
 }
 
-static struct thread *__machine__findnew_thread(struct machine *machine, pid_t tid,
+static struct thread *__machine__findnew_thread(struct machine *machine,
+						pid_t pid, pid_t tid,
 						bool create)
 {
 	struct rb_node **p = &machine->threads.rb_node;
@@ -245,8 +246,11 @@ static struct thread *__machine__findnew_thread(struct machine *machine, pid_t t
 	 * so most of the time we dont have to look up
 	 * the full rbtree:
 	 */
-	if (machine->last_match && machine->last_match->tid == tid)
+	if (machine->last_match && machine->last_match->tid == tid) {
+		if (pid && !machine->last_match->pid_)
+			machine->last_match->pid_ = pid;
 		return machine->last_match;
+	}
 
 	while (*p != NULL) {
 		parent = *p;
@@ -254,6 +258,8 @@ static struct thread *__machine__findnew_thread(struct machine *machine, pid_t t
 
 		if (th->tid == tid) {
 			machine->last_match = th;
+			if (pid && !th->pid_)
+				th->pid_ = pid;
 			return th;
 		}
 
@@ -266,7 +272,7 @@ static struct thread *__machine__findnew_thread(struct machine *machine, pid_t t
 	if (!create)
 		return NULL;
 
-	th = thread__new(tid);
+	th = thread__new(pid, tid);
 	if (th != NULL) {
 		rb_link_node(&th->rb_node, parent, p);
 		rb_insert_color(&th->rb_node, &machine->threads);
@@ -278,17 +284,25 @@ static struct thread *__machine__findnew_thread(struct machine *machine, pid_t t
 
 struct thread *machine__findnew_thread(struct machine *machine, pid_t tid)
 {
-	return __machine__findnew_thread(machine, tid, true);
+	return __machine__findnew_thread(machine, 0, tid, true);
+}
+
+struct thread *machine__findnew_thread_ex(struct machine *machine, pid_t pid,
+					  pid_t tid)
+{
+	return __machine__findnew_thread(machine, pid, tid, true);
 }
 
 struct thread *machine__find_thread(struct machine *machine, pid_t tid)
 {
-	return __machine__findnew_thread(machine, tid, false);
+	return __machine__findnew_thread(machine, 0, tid, false);
 }
 
 int machine__process_comm_event(struct machine *machine, union perf_event *event)
 {
-	struct thread *thread = machine__findnew_thread(machine, event->comm.tid);
+	struct thread *thread = machine__findnew_thread_ex(machine,
+							   event->comm.pid,
+							   event->comm.tid);
 
 	if (dump_trace)
 		perf_event__fprintf_comm(event, stdout);
@@ -969,7 +983,8 @@ int machine__process_mmap_event(struct machine *machine, union perf_event *event
 		return 0;
 	}
 
-	thread = machine__findnew_thread(machine, event->mmap.pid);
+	thread = machine__findnew_thread_ex(machine, event->mmap.pid,
+					    event->mmap.pid);
 	if (thread == NULL)
 		goto out_problem;
 
@@ -996,8 +1011,12 @@ out_problem:
 
 int machine__process_fork_event(struct machine *machine, union perf_event *event)
 {
-	struct thread *thread = machine__findnew_thread(machine, event->fork.tid);
-	struct thread *parent = machine__findnew_thread(machine, event->fork.ptid);
+	struct thread *thread = machine__findnew_thread_ex(machine,
+							   event->fork.pid,
+							   event->fork.tid);
+	struct thread *parent = machine__findnew_thread_ex(machine,
+							   event->fork.ppid,
+							   event->fork.ptid);
 
 	if (dump_trace)
 		perf_event__fprintf_task(event, stdout);
@@ -1264,3 +1283,13 @@ int machine__resolve_callchain(struct machine *machine,
 				   sample);
 
 }
+
+pid_t machine__get_thread_pid(struct machine *machine, pid_t tid)
+{
+	struct thread *thread = machine__find_thread(machine, tid);
+
+	if (!thread)
+		return 0;
+
+	return thread->pid_;
+}
diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h
index e49ba01..11a53d5 100644
--- a/tools/perf/util/machine.h
+++ b/tools/perf/util/machine.h
@@ -100,6 +100,8 @@ static inline bool machine__is_host(struct machine *machine)
 }
 
 struct thread *machine__findnew_thread(struct machine *machine, pid_t tid);
+struct thread *machine__findnew_thread_ex(struct machine *machine, pid_t pid,
+					  pid_t tid);
 
 size_t machine__fprintf(struct machine *machine, FILE *fp);
 
@@ -156,4 +158,6 @@ void machines__destroy_kernel_maps(struct machines *machines);
 
 size_t machine__fprintf_vmlinux_path(struct machine *machine, FILE *fp);
 
+pid_t machine__get_thread_pid(struct machine *machine, pid_t tid);
+
 #endif /* __PERF_MACHINE_H */
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index 6feeb88..e3d4a55 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -7,12 +7,13 @@
 #include "util.h"
 #include "debug.h"
 
-struct thread *thread__new(pid_t tid)
+struct thread *thread__new(pid_t pid, pid_t tid)
 {
 	struct thread *self = zalloc(sizeof(*self));
 
 	if (self != NULL) {
 		map_groups__init(&self->mg);
+		self->pid_ = pid;
 		self->tid = tid;
 		self->ppid = -1;
 		self->comm = malloc(32);
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index 37a86a3..bfa68e7 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -12,6 +12,7 @@ struct thread {
 		struct list_head node;
 	};
 	struct map_groups	mg;
+	pid_t			pid_; /* Not all tools update this */
 	pid_t			tid;
 	pid_t			ppid;
 	char			shortname[3];
@@ -24,7 +25,7 @@ struct thread {
 
 struct machine;
 
-struct thread *thread__new(pid_t tid);
+struct thread *thread__new(pid_t pid, pid_t tid);
 void thread__delete(struct thread *self);
 
 int thread__set_comm(struct thread *self, const char *comm);
-- 
1.7.11.7

