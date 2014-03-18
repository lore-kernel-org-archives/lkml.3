Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209AbaCRP55 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 11:57:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15369 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755643AbaCRP4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 11:56:40 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Don Zickus <dzickus@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: [PATCH 4/6] perf tools: Add machine pointer into thread struct
Date: Tue, 18 Mar 2014 15:46:54 +0100
Message-Id: <1395154016-26709-5-git-send-email-jolsa@redhat.com>
In-Reply-To: <1395154016-26709-1-git-send-email-jolsa@redhat.com>
References: <1395154016-26709-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Need machine pointer in thread object, so we could
lookup the process thread in following patch.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Don Zickus <dzickus@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
---
 tools/perf/util/machine.c | 2 +-
 tools/perf/util/thread.c  | 4 +++-
 tools/perf/util/thread.h  | 5 ++++-
 3 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index d1f06d2..237d7c2 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -311,7 +311,7 @@ static struct thread *__machine__findnew_thread(struct machine *machine,
 	if (!create)
 		return NULL;
 
-	th = thread__new(pid, tid);
+	th = thread__new(pid, tid, machine);
 	if (th != NULL) {
 		rb_link_node(&th->rb_node, parent, p);
 		rb_insert_color(&th->rb_node, &machine->threads);
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index bacf60b..cbe451a 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -8,13 +8,15 @@
 #include "debug.h"
 #include "comm.h"
 
-struct thread *thread__new(pid_t pid, pid_t tid)
+struct thread *thread__new(pid_t pid, pid_t tid,
+			   struct machine *machine)
 {
 	char *comm_str;
 	struct comm *comm;
 	struct thread *thread = zalloc(sizeof(*thread));
 
 	if (thread != NULL) {
+		thread->machine = machine;
 		thread->pid_ = pid;
 		thread->tid = tid;
 		thread->ppid = -1;
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index b3f7d8e..21521e1 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -7,12 +7,14 @@
 #include <sys/types.h>
 #include "symbol.h"
 #include <strlist.h>
+#include "machine.h"
 
 struct thread {
 	union {
 		struct rb_node	 rb_node;
 		struct list_head node;
 	};
+	struct machine		*machine;
 	struct map_groups	*mg;
 	pid_t			pid_; /* Not all tools update this */
 	pid_t			tid;
@@ -29,7 +31,8 @@ struct thread {
 struct machine;
 struct comm;
 
-struct thread *thread__new(pid_t pid, pid_t tid);
+struct thread *thread__new(pid_t pid, pid_t tid,
+			   struct machine *machine);
 void thread__delete(struct thread *thread);
 static inline void thread__exited(struct thread *thread)
 {
-- 
1.8.3.1

