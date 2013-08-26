Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756833Ab3HZMyY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 08:54:24 -0400
Received: from mga01.intel.com ([192.55.52.88]:14401 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756777Ab3HZMyW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 08:54:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,958,1367996400"; 
   d="scan'208";a="392111740"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: [PATCH V12 02/13] perf tools: add pid to struct thread
Date: Mon, 26 Aug 2013 16:00:19 +0300
Message-Id: <1377522030-27870-3-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1377522030-27870-1-git-send-email-adrian.hunter@intel.com>
References: <1377522030-27870-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Record pid on struct thread.  The member is named 'pid_'
to avoid confusion with the 'tid' member which was previously
named 'pid'.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: David Ahern <dsahern@gmail.com>
---
 tools/perf/util/machine.c | 16 +++++++++++-----
 tools/perf/util/thread.c  |  3 ++-
 tools/perf/util/thread.h  |  3 ++-
 3 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 4514e7e..40d92f4 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -253,7 +253,8 @@ void machines__set_id_hdr_size(struct machines *machines, u16 id_hdr_size)
 	return;
 }
 
-static struct thread *__machine__findnew_thread(struct machine *machine, pid_t tid,
+static struct thread *__machine__findnew_thread(struct machine *machine,
+						pid_t pid, pid_t tid,
 						bool create)
 {
 	struct rb_node **p = &machine->threads.rb_node;
@@ -265,8 +266,11 @@ static struct thread *__machine__findnew_thread(struct machine *machine, pid_t t
 	 * so most of the time we dont have to look up
 	 * the full rbtree:
 	 */
-	if (machine->last_match && machine->last_match->tid == tid)
+	if (machine->last_match && machine->last_match->tid == tid) {
+		if (pid && pid != machine->last_match->pid_)
+			machine->last_match->pid_ = pid;
 		return machine->last_match;
+	}
 
 	while (*p != NULL) {
 		parent = *p;
@@ -274,6 +278,8 @@ static struct thread *__machine__findnew_thread(struct machine *machine, pid_t t
 
 		if (th->tid == tid) {
 			machine->last_match = th;
+			if (pid && pid != th->pid_)
+				th->pid_ = pid;
 			return th;
 		}
 
@@ -286,7 +292,7 @@ static struct thread *__machine__findnew_thread(struct machine *machine, pid_t t
 	if (!create)
 		return NULL;
 
-	th = thread__new(tid);
+	th = thread__new(pid, tid);
 	if (th != NULL) {
 		rb_link_node(&th->rb_node, parent, p);
 		rb_insert_color(&th->rb_node, &machine->threads);
@@ -298,12 +304,12 @@ static struct thread *__machine__findnew_thread(struct machine *machine, pid_t t
 
 struct thread *machine__findnew_thread(struct machine *machine, pid_t tid)
 {
-	return __machine__findnew_thread(machine, tid, true);
+	return __machine__findnew_thread(machine, 0, tid, true);
 }
 
 struct thread *machine__find_thread(struct machine *machine, pid_t tid)
 {
-	return __machine__findnew_thread(machine, tid, false);
+	return __machine__findnew_thread(machine, 0, tid, false);
 }
 
 int machine__process_comm_event(struct machine *machine, union perf_event *event)
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
index 13c62c9..927b37f 100644
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

