Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890Ab3KDUUQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 15:20:16 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49892 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807Ab3KDUUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 15:20:09 -0500
Date: Mon, 4 Nov 2013 12:19:46 -0800
From: tip-bot for Frederic Weisbecker <tipbot@zytor.com>
Message-ID: <tip-hwjf70b2wve9m2kosxiq8bb3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, acme@redhat.com,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com, eranian@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, mingo@elte.hu
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Add new COMM infrastructure
Git-Commit-ID: 1902efe7f626fdebe1520f5ff11f1309ec506708
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 04 Nov 2013 12:19:52 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1902efe7f626fdebe1520f5ff11f1309ec506708
Gitweb:     http://git.kernel.org/tip/1902efe7f626fdebe1520f5ff11f1309ec506708
Author:     Frederic Weisbecker <fweisbec@gmail.com>
AuthorDate: Wed, 11 Sep 2013 16:56:44 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 4 Nov 2013 12:13:53 -0300

perf tools: Add new COMM infrastructure

This new COMM infrastructure provides two features:

1) It keeps track of all comms lifecycle for a given thread. This way we
can associate a timeframe to any thread COMM, as long as
PERF_SAMPLE_TIME samples are joined to COMM and fork events.

As a result we should have more precise COMM sorted hists with seperated
entries for pre and post exec time after a fork.

2) It also makes sure that a given COMM string is not duplicated but
rather shared among the threads that refer to it. This way the threads
COMM can be compared against pointer values from the sort
infrastructure.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Tested-by: Jiri Olsa <jolsa@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-hwjf70b2wve9m2kosxiq8bb3@git.kernel.org
[ Rename some accessor functions ]
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
[ Use __ as separator for class__method for private comm_str methods ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile.perf   |   2 +
 tools/perf/builtin-trace.c |   4 +-
 tools/perf/util/comm.c     | 106 +++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/comm.h     |  20 +++++++++
 tools/perf/util/thread.c   |  92 +++++++++++++++++++++++++++++----------
 tools/perf/util/thread.h   |   3 +-
 6 files changed, 200 insertions(+), 27 deletions(-)

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index bc7cfa1..cb52bdb 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -273,6 +273,7 @@ LIB_H += util/color.h
 LIB_H += util/values.h
 LIB_H += util/sort.h
 LIB_H += util/hist.h
+LIB_H += util/comm.h
 LIB_H += util/thread.h
 LIB_H += util/thread_map.h
 LIB_H += util/trace-event.h
@@ -341,6 +342,7 @@ LIB_OBJS += $(OUTPUT)util/machine.o
 LIB_OBJS += $(OUTPUT)util/map.o
 LIB_OBJS += $(OUTPUT)util/pstack.o
 LIB_OBJS += $(OUTPUT)util/session.o
+LIB_OBJS += $(OUTPUT)util/comm.o
 LIB_OBJS += $(OUTPUT)util/thread.o
 LIB_OBJS += $(OUTPUT)util/thread_map.o
 LIB_OBJS += $(OUTPUT)util/trace-event-parse.o
diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index 95d6392..b3e57dc 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1114,7 +1114,7 @@ static size_t trace__fprintf_entry_head(struct trace *trace, struct thread *thre
 
 	if (trace->multiple_threads) {
 		if (trace->show_comm)
-			printed += fprintf(fp, "%.14s/", thread->comm);
+			printed += fprintf(fp, "%.14s/", thread__comm_str(thread));
 		printed += fprintf(fp, "%d ", thread->tid);
 	}
 
@@ -1986,7 +1986,7 @@ static int trace__fprintf_one_thread(struct thread *thread, void *priv)
 	else if (ratio > 5.0)
 		color = PERF_COLOR_YELLOW;
 
-	printed += color_fprintf(fp, color, "%20s", thread->comm);
+	printed += color_fprintf(fp, color, "%20s", thread__comm_str(thread));
 	printed += fprintf(fp, " - %-5d :%11lu   [", thread->tid, ttrace->nr_events);
 	printed += color_fprintf(fp, color, "%5.1f%%", ratio);
 	printed += fprintf(fp, " ] %10.3f ms\n", ttrace->runtime_ms);
diff --git a/tools/perf/util/comm.c b/tools/perf/util/comm.c
new file mode 100644
index 0000000..8b3ac9f
--- /dev/null
+++ b/tools/perf/util/comm.c
@@ -0,0 +1,106 @@
+#include "comm.h"
+#include "util.h"
+#include <stdlib.h>
+#include <stdio.h>
+
+struct comm_str {
+	char *str;
+	struct rb_node rb_node;
+	int ref;
+};
+
+/* Should perhaps be moved to struct machine */
+static struct rb_root comm_str_root;
+
+static void comm_str__get(struct comm_str *cs)
+{
+	cs->ref++;
+}
+
+static void comm_str__put(struct comm_str *cs)
+{
+	if (!--cs->ref) {
+		rb_erase(&cs->rb_node, &comm_str_root);
+		free(cs->str);
+		free(cs);
+	}
+}
+
+static struct comm_str *comm_str__alloc(const char *str)
+{
+	struct comm_str *cs;
+
+	cs = zalloc(sizeof(*cs));
+	if (!cs)
+		return NULL;
+
+	cs->str = strdup(str);
+	if (!cs->str) {
+		free(cs);
+		return NULL;
+	}
+
+	return cs;
+}
+
+static struct comm_str *comm_str__findnew(const char *str, struct rb_root *root)
+{
+	struct rb_node **p = &root->rb_node;
+	struct rb_node *parent = NULL;
+	struct comm_str *iter, *new;
+	int cmp;
+
+	while (*p != NULL) {
+		parent = *p;
+		iter = rb_entry(parent, struct comm_str, rb_node);
+
+		cmp = strcmp(str, iter->str);
+		if (!cmp)
+			return iter;
+
+		if (cmp < 0)
+			p = &(*p)->rb_left;
+		else
+			p = &(*p)->rb_right;
+	}
+
+	new = comm_str__alloc(str);
+	if (!new)
+		return NULL;
+
+	rb_link_node(&new->rb_node, parent, p);
+	rb_insert_color(&new->rb_node, root);
+
+	return new;
+}
+
+struct comm *comm__new(const char *str, u64 timestamp)
+{
+	struct comm *comm = zalloc(sizeof(*comm));
+
+	if (!comm)
+		return NULL;
+
+	comm->start = timestamp;
+
+	comm->comm_str = comm_str__findnew(str, &comm_str_root);
+	if (!comm->comm_str) {
+		free(comm);
+		return NULL;
+	}
+
+	comm_str__get(comm->comm_str);
+
+	return comm;
+}
+
+void comm__free(struct comm *comm)
+{
+	comm_str__put(comm->comm_str);
+	free(comm);
+}
+
+const char *comm__str(const struct comm *comm)
+{
+	return comm->comm_str->str;
+}
diff --git a/tools/perf/util/comm.h b/tools/perf/util/comm.h
new file mode 100644
index 0000000..f62d215
--- /dev/null
+++ b/tools/perf/util/comm.h
@@ -0,0 +1,20 @@
+#ifndef __PERF_COMM_H
+#define __PERF_COMM_H
+
+#include "../perf.h"
+#include <linux/rbtree.h>
+#include <linux/list.h>
+
+struct comm_str;
+
+struct comm {
+	struct comm_str *comm_str;
+	u64 start;
+	struct list_head list;
+};
+
+void comm__free(struct comm *comm);
+struct comm *comm__new(const char *str, u64 timestamp);
+const char *comm__str(const struct comm *comm);
+
+#endif  /* __PERF_COMM_H */
diff --git a/tools/perf/util/thread.c b/tools/perf/util/thread.c
index 0ea73fe..15c53c2 100644
--- a/tools/perf/util/thread.c
+++ b/tools/perf/util/thread.c
@@ -6,9 +6,12 @@
 #include "thread.h"
 #include "util.h"
 #include "debug.h"
+#include "comm.h"
 
 struct thread *thread__new(pid_t pid, pid_t tid)
 {
+	char *comm_str;
+	struct comm *comm;
 	struct thread *thread = zalloc(sizeof(*thread));
 
 	if (thread != NULL) {
@@ -16,47 +19,88 @@ struct thread *thread__new(pid_t pid, pid_t tid)
 		thread->pid_ = pid;
 		thread->tid = tid;
 		thread->ppid = -1;
-		thread->comm = malloc(32);
-		if (thread->comm)
-			snprintf(thread->comm, 32, ":%d", thread->tid);
+		INIT_LIST_HEAD(&thread->comm_list);
+
+		comm_str = malloc(32);
+		if (!comm_str)
+			goto err_thread;
+
+		snprintf(comm_str, 32, ":%d", tid);
+		comm = comm__new(comm_str, 0);
+		free(comm_str);
+		if (!comm)
+			goto err_thread;
+
+		list_add(&comm->list, &thread->comm_list);
 	}
 
 	return thread;
+
+err_thread:
+	free(thread);
+	return NULL;
 }
 
 void thread__delete(struct thread *thread)
 {
+	struct comm *comm, *tmp;
+
 	map_groups__exit(&thread->mg);
-	free(thread->comm);
+	list_for_each_entry_safe(comm, tmp, &thread->comm_list, list) {
+		list_del(&comm->list);
+		comm__free(comm);
+	}
+
 	free(thread);
 }
 
-int thread__set_comm(struct thread *thread, const char *comm,
-		     u64 timestamp __maybe_unused)
+static struct comm *thread__comm(const struct thread *thread)
 {
-	int err;
+	if (list_empty(&thread->comm_list))
+		return NULL;
 
-	if (thread->comm)
-		free(thread->comm);
-	thread->comm = strdup(comm);
-	err = thread->comm == NULL ? -ENOMEM : 0;
-	if (!err) {
-		thread->comm_set = true;
+	return list_first_entry(&thread->comm_list, struct comm, list);
+}
+
+/* CHECKME: time should always be 0 if event aren't ordered */
+int thread__set_comm(struct thread *thread, const char *str, u64 timestamp)
+{
+	struct comm *new, *curr = thread__comm(thread);
+
+	/* Override latest entry if it had no specific time coverage */
+	if (!curr->start) {
+		list_del(&curr->list);
+		comm__free(curr);
 	}
-	return err;
+
+	new = comm__new(str, timestamp);
+	if (!new)
+		return -ENOMEM;
+
+	list_add(&new->list, &thread->comm_list);
+	thread->comm_set = true;
+
+	return 0;
 }
 
 const char *thread__comm_str(const struct thread *thread)
 {
-	return thread->comm;
+	const struct comm *comm = thread__comm(thread);
+
+	if (!comm)
+		return NULL;
+
+	return comm__str(comm);
 }
 
+/* CHECKME: it should probably better return the max comm len from its comm list */
 int thread__comm_len(struct thread *thread)
 {
 	if (!thread->comm_len) {
-		if (!thread->comm)
+		const char *comm = thread__comm_str(thread);
+		if (!comm)
 			return 0;
-		thread->comm_len = strlen(thread->comm);
+		thread->comm_len = strlen(comm);
 	}
 
 	return thread->comm_len;
@@ -74,17 +118,17 @@ void thread__insert_map(struct thread *thread, struct map *map)
 	map_groups__insert(&thread->mg, map);
 }
 
-int thread__fork(struct thread *thread, struct thread *parent,
-		 u64 timestamp __maybe_unused)
+int thread__fork(struct thread *thread, struct thread *parent, u64 timestamp)
 {
-	int i;
+	int i, err;
 
 	if (parent->comm_set) {
-		if (thread->comm)
-			free(thread->comm);
-		thread->comm = strdup(parent->comm);
-		if (!thread->comm)
+		const char *comm = thread__comm_str(parent);
+		if (!comm)
 			return -ENOMEM;
+		err = thread__set_comm(thread, comm, timestamp);
+		if (!err)
+			return err;
 		thread->comm_set = true;
 	}
 
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index 4e97242..8702c6b 100644
--- a/tools/perf/util/thread.h
+++ b/tools/perf/util/thread.h
@@ -2,6 +2,7 @@
 #define __PERF_THREAD_H
 
 #include <linux/rbtree.h>
+#include <linux/list.h>
 #include <unistd.h>
 #include <sys/types.h>
 #include "symbol.h"
@@ -18,7 +19,7 @@ struct thread {
 	char			shortname[3];
 	bool			comm_set;
 	bool			dead; /* if set thread has exited */
-	char			*comm;
+	struct list_head	comm_list;
 	int			comm_len;
 
 	void			*priv;
