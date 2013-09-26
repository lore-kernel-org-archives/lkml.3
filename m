Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932075Ab3IZI7n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 04:59:43 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:46685 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755849Ab3IZI6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 04:58:21 -0400
X-AuditID: 9c93016f-b7bc8ae000004e6e-e8-5243f726fd00
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 6/8] perf tools: Add new comm infrastructure
Date: Thu, 26 Sep 2013 17:58:08 +0900
Message-Id: <1380185890-25758-7-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1380185890-25758-1-git-send-email-namhyung@kernel.org>
References: <1380185890-25758-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>

This new comm infrastructure provides two features:

1) It keeps track of all comms lifecycle for a given thread. This
way we can associate a timeframe to any thread comm, as long as
PERF_SAMPLE_TIME samples are joined to comm and fork events.

As a result we should have more precise comm sorted hists with
seperated entries for pre and post exec time after a fork.

2) It also makes sure that a given comm string is not duplicated
but rather shared among the threads that refer to it. This way the
threads comm can be compared against pointer values from the sort
infrastructure.

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-hwjf70b2wve9m2kosxiq8bb3@git.kernel.org
[ Fixed up minor const pointer issues and removed 'self' usage ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/Makefile      |   2 +
 tools/perf/util/comm.c   | 106 +++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/comm.h   |  20 +++++++++
 tools/perf/util/thread.c | 100 +++++++++++++++++++++++++++++++-------------
 tools/perf/util/thread.h |   3 +-
 5 files changed, 202 insertions(+), 29 deletions(-)
 create mode 100644 tools/perf/util/comm.c
 create mode 100644 tools/perf/util/comm.h

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index b62e12d2ba6b..42001f387e7f 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -272,6 +272,7 @@ LIB_H += util/color.h
 LIB_H += util/values.h
 LIB_H += util/sort.h
 LIB_H += util/hist.h
+LIB_H += util/comm.h
 LIB_H += util/thread.h
 LIB_H += util/thread_map.h
 LIB_H += util/trace-event.h
@@ -339,6 +340,7 @@ LIB_OBJS += $(OUTPUT)util/machine.o
 LIB_OBJS += $(OUTPUT)util/map.o
 LIB_OBJS += $(OUTPUT)util/pstack.o
 LIB_OBJS += $(OUTPUT)util/session.o
+LIB_OBJS += $(OUTPUT)util/comm.o
 LIB_OBJS += $(OUTPUT)util/thread.o
 LIB_OBJS += $(OUTPUT)util/thread_map.o
 LIB_OBJS += $(OUTPUT)util/trace-event-parse.o
diff --git a/tools/perf/util/comm.c b/tools/perf/util/comm.c
new file mode 100644
index 000000000000..0cfb55202537
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
+static void comm_str_get(struct comm_str *cs)
+{
+	cs->ref++;
+}
+
+static void comm_str_put(struct comm_str *cs)
+{
+	if (!--cs->ref) {
+		rb_erase(&cs->rb_node, &comm_str_root);
+		free(cs->str);
+		free(cs);
+	}
+}
+
+static struct comm_str *comm_str_alloc(const char *str)
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
+static struct comm_str *comm_str_findnew(const char *str, struct rb_root *root)
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
+	new = comm_str_alloc(str);
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
+	comm->comm_str = comm_str_findnew(str, &comm_str_root);
+	if (!comm->comm_str) {
+		free(comm);
+		return NULL;
+	}
+
+	comm_str_get(comm->comm_str);
+
+	return comm;
+}
+
+void comm__free(struct comm *comm)
+{
+	comm_str_put(comm->comm_str);
+	free(comm);
+}
+
+const char *comm__str(const struct comm *comm)
+{
+	return comm->comm_str->str;
+}
diff --git a/tools/perf/util/comm.h b/tools/perf/util/comm.h
new file mode 100644
index 000000000000..f62d215bede2
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
index 509abed750e6..9cb01566eff1 100644
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
 	struct thread *self = zalloc(sizeof(*self));
 
 	if (self != NULL) {
@@ -16,47 +19,88 @@ struct thread *thread__new(pid_t pid, pid_t tid)
 		self->pid_ = pid;
 		self->tid = tid;
 		self->ppid = -1;
-		self->comm = malloc(32);
-		if (self->comm)
-			snprintf(self->comm, 32, ":%d", self->tid);
+		INIT_LIST_HEAD(&self->comm_list);
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
+		list_add(&comm->list, &self->comm_list);
 	}
 
 	return self;
+
+err_thread:
+	free(self);
+	return NULL;
 }
 
 void thread__delete(struct thread *self)
 {
+	struct comm *comm, *tmp;
+
 	map_groups__exit(&self->mg);
-	free(self->comm);
+	list_for_each_entry_safe(comm, tmp, &self->comm_list, list) {
+		list_del(&comm->list);
+		comm__free(comm);
+	}
+
 	free(self);
 }
 
-int thread__set_comm(struct thread *self, const char *comm,
-		     u64 timestamp __maybe_unused)
+static struct comm *curr_comm(const struct thread *thread)
 {
-	int err;
-
-	if (self->comm)
-		free(self->comm);
-	self->comm = strdup(comm);
-	err = self->comm == NULL ? -ENOMEM : 0;
-	if (!err) {
-		self->comm_set = true;
+	if (list_empty(&thread->comm_list))
+		return NULL;
+
+	return list_first_entry(&thread->comm_list, struct comm, list);
+}
+
+/* CHECKME: time should always be 0 if event aren't ordered */
+int thread__set_comm(struct thread *thread, const char *str, u64 timestamp)
+{
+	struct comm *new, *curr = curr_comm(thread);
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
 
 const char *thread__comm_curr(const struct thread *thread)
 {
-	return thread->comm;
+	const struct comm *comm = curr_comm(thread);
+
+	if (!comm)
+		return NULL;
+
+	return comm__str(comm);
 }
 
+/* CHECKME: it should probably better return the max comm len from its comm list */
 int thread__comm_len(struct thread *self)
 {
 	if (!self->comm_len) {
-		if (!self->comm)
+		const char *comm = thread__comm_curr(self);
+		if (!comm)
 			return 0;
-		self->comm_len = strlen(self->comm);
+		self->comm_len = strlen(comm);
 	}
 
 	return self->comm_len;
@@ -74,25 +118,25 @@ void thread__insert_map(struct thread *self, struct map *map)
 	map_groups__insert(&self->mg, map);
 }
 
-int thread__fork(struct thread *self, struct thread *parent,
-		 u64 timestamp __maybe_unused)
+int thread__fork(struct thread *thread, struct thread *parent, u64 timestamp)
 {
-	int i;
+	int i, err;
 
 	if (parent->comm_set) {
-		if (self->comm)
-			free(self->comm);
-		self->comm = strdup(parent->comm);
-		if (!self->comm)
+		const char *comm = thread__comm_curr(parent);
+		if (!comm)
 			return -ENOMEM;
-		self->comm_set = true;
+		err = thread__set_comm(thread, comm, timestamp);
+		if (!err)
+			return err;
+		thread->comm_set = true;
 	}
 
 	for (i = 0; i < MAP__NR_TYPES; ++i)
-		if (map_groups__clone(&self->mg, &parent->mg, i) < 0)
+		if (map_groups__clone(&thread->mg, &parent->mg, i) < 0)
 			return -ENOMEM;
 
-	self->ppid = parent->tid;
+	thread->ppid = parent->tid;
 
 	return 0;
 }
diff --git a/tools/perf/util/thread.h b/tools/perf/util/thread.h
index b738c9948508..0ec37bae88d0 100644
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
-- 
1.7.11.7

