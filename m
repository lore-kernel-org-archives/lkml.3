Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221Ab3CMJo1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 05:44:27 -0400
Received: from mail-da0-f52.google.com ([209.85.210.52]:58684 "EHLO
	mail-da0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755321Ab3CMJoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 05:44:24 -0400
From: chenggang <chenggang.qin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: chenggang <chenggang.qcg@taobao.com>, David Ahern <dsahern@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Yanmin Zhang <yanmin.zhang@intel.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Mike Galbraith <efault@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v3 1/8]Perf: Transform thread_map to linked list
Date: Wed, 13 Mar 2013 17:42:19 +0800
Message-Id: <1363167740-27735-8-git-send-email-chenggang.qin@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1363167740-27735-1-git-send-email-chenggang.qin@gmail.com>
References: <1363167740-27735-1-git-send-email-chenggang.qin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: chenggang <chenggang.qcg@taobao.com>

The size of thread_map is fixed at initialized phase according to the
files in /proc/{$pid}. It cannot be expanded and shrinked while we want
to perceive the thread fork and exit events.
We transform the thread_map structure to a linked list, and implement some
interfaces to expend and shrink it. In order to improve compatibility with
the existing code, we can get a thread by its index in the thread_map also.
1) thread_map__append()
   Append a new thread into thread_map according to new thread's pid.
2) thread_map__remove()
   Remove a exist thread from thread_map according to the index of the
   thread in thread_map.
3) thread_map__init()
   Alloc a thread_map, and initialize it. But the thread_map is empty after
   we called this function. We should call thread_map__append() to insert
   threads.
4) thread_map__delete()
   Delete a exist thread_map.
5) thread_map__set_pid()
   Set the pid of a thread by its index in the thread_map.
6) thread_map__get_pid()
   Got a thread's pid by its index in the thread_map.
7) thread_map__get_idx_by_pid()
   Got a thread's index in the thread_map according to its pid.
   While we got a PERF_RECORD_EXIT event, we only know the pid of the thread.
8) thread_map__empty_thread_map()
   Return a empty thread_map, there is only a dumb thread in it.
   This function is used to instead of the global varible empty_thread_map.

Cc: David Ahern <dsahern@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Yanmin Zhang <yanmin.zhang@intel.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Chenggang Qin <chenggang.qcg@taobao.com>

---
 tools/perf/builtin-stat.c                 |    2 +-
 tools/perf/tests/open-syscall-tp-fields.c |    2 +-
 tools/perf/util/event.c                   |   12 +-
 tools/perf/util/evlist.c                  |    2 +-
 tools/perf/util/evsel.c                   |   16 +-
 tools/perf/util/python.c                  |    2 +-
 tools/perf/util/thread_map.c              |  281 ++++++++++++++++++++++-------
 tools/perf/util/thread_map.h              |   17 +-
 8 files changed, 244 insertions(+), 90 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 9984876..293b09c 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -401,7 +401,7 @@ static int __run_perf_stat(int argc __maybe_unused, const char **argv)
 		}
 
 		if (perf_target__none(&target))
-			evsel_list->threads->map[0] = child_pid;
+			thread_map__set_pid(evsel_list->threads, 0, child_pid);
 
 		/*
 		 * Wait for the child to be ready to exec.
diff --git a/tools/perf/tests/open-syscall-tp-fields.c b/tools/perf/tests/open-syscall-tp-fields.c
index 1c52fdc..39eb770 100644
--- a/tools/perf/tests/open-syscall-tp-fields.c
+++ b/tools/perf/tests/open-syscall-tp-fields.c
@@ -43,7 +43,7 @@ int test__syscall_open_tp_fields(void)
 
 	perf_evsel__config(evsel, &opts);
 
-	evlist->threads->map[0] = getpid();
+	thread_map__append(evlist->threads, getpid());
 
 	err = perf_evlist__open(evlist);
 	if (err < 0) {
diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
index 5cd13d7..d093460 100644
--- a/tools/perf/util/event.c
+++ b/tools/perf/util/event.c
@@ -326,9 +326,11 @@ int perf_event__synthesize_thread_map(struct perf_tool *tool,
 
 	err = 0;
 	for (thread = 0; thread < threads->nr; ++thread) {
+		pid_t pid = thread_map__get_pid(threads, thread);
+
 		if (__event__synthesize_thread(comm_event, mmap_event,
-					       threads->map[thread], 0,
-					       process, tool, machine)) {
+					       pid, 0, process, tool, 
+					       machine)) {
 			err = -1;
 			break;
 		}
@@ -337,12 +339,14 @@ int perf_event__synthesize_thread_map(struct perf_tool *tool,
 		 * comm.pid is set to thread group id by
 		 * perf_event__synthesize_comm
 		 */
-		if ((int) comm_event->comm.pid != threads->map[thread]) {
+		if ((int) comm_event->comm.pid != pid) {
 			bool need_leader = true;
 
 			/* is thread group leader in thread_map? */
 			for (j = 0; j < threads->nr; ++j) {
-				if ((int) comm_event->comm.pid == threads->map[j]) {
+				pid_t pidj = thread_map__get_pid(threads, j);
+
+				if ((int) comm_event->comm.pid == pidj) {
 					need_leader = false;
 					break;
 				}
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index bc4ad79..d5063d6 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -793,7 +793,7 @@ int perf_evlist__prepare_workload(struct perf_evlist *evlist,
 	}
 
 	if (perf_target__none(&opts->target))
-		evlist->threads->map[0] = evlist->workload.pid;
+		thread_map__append(evlist->threads, evlist->workload.pid);
 
 	close(child_ready_pipe[1]);
 	close(go_pipe[0]);
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 9c82f98f..57c569d 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -835,7 +835,7 @@ retry_sample_id:
 			int group_fd;
 
 			if (!evsel->cgrp)
-				pid = threads->map[thread];
+				pid = thread_map__get_pid(threads, thread);
 
 			group_fd = get_group_fd(evsel, cpu, thread);
 
@@ -894,14 +894,6 @@ static struct {
 	.cpus	= { -1, },
 };
 
-static struct {
-	struct thread_map map;
-	int threads[1];
-} empty_thread_map = {
-	.map.nr	 = 1,
-	.threads = { -1, },
-};
-
 int perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
 		     struct thread_map *threads)
 {
@@ -911,7 +903,7 @@ int perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
 	}
 
 	if (threads == NULL)
-		threads = &empty_thread_map.map;
+		threads = thread_map__empty_thread_map();
 
 	return __perf_evsel__open(evsel, cpus, threads);
 }
@@ -919,7 +911,9 @@ int perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
 int perf_evsel__open_per_cpu(struct perf_evsel *evsel,
 			     struct cpu_map *cpus)
 {
-	return __perf_evsel__open(evsel, cpus, &empty_thread_map.map);
+	struct thread_map *empty_thread_map = thread_map__empty_thread_map();
+
+	return __perf_evsel__open(evsel, cpus, empty_thread_map);
 }
 
 int perf_evsel__open_per_thread(struct perf_evsel *evsel,
diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index 925e0c3..e3f3f1b 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -458,7 +458,7 @@ static PyObject *pyrf_thread_map__item(PyObject *obj, Py_ssize_t i)
 	if (i >= pthreads->threads->nr)
 		return NULL;
 
-	return Py_BuildValue("i", pthreads->threads->map[i]);
+	return Py_BuildValue("i", thread_map__get_pid(pthreads->threads, i));
 }
 
 static PySequenceMethods pyrf_thread_map__sequence_methods = {
diff --git a/tools/perf/util/thread_map.c b/tools/perf/util/thread_map.c
index 9b5f856..301f4ce 100644
--- a/tools/perf/util/thread_map.c
+++ b/tools/perf/util/thread_map.c
@@ -19,9 +19,116 @@ static int filter(const struct dirent *dir)
 		return 1;
 }
 
-struct thread_map *thread_map__new_by_pid(pid_t pid)
+/*
+ * Initialize a thread_map, but the thread_map is empty after calling this
+ * function. thread_pid should be inserted into it by thread_map__append().
+ */
+struct thread_map *thread_map__init(void)
 {
 	struct thread_map *threads;
+
+	threads = malloc(sizeof(*threads));
+	if (threads == NULL)
+		return NULL;
+
+	threads->nr = 0;
+	INIT_LIST_HEAD(&threads->head);
+	return threads;
+}
+
+/*
+ * Delete @threads, include its all thread_pids.
+ */
+void thread_map__delete(struct thread_map *threads)
+{
+	struct thread_pid *tp, *tmp;
+
+	list_for_each_entry_safe(tp, tmp, &threads->head, next) {
+		list_del(&tp->next);
+		free(tp);
+	}
+
+	free(threads);
+}
+
+int thread_map__has_pid(struct thread_map *threads, pid_t pid)
+{
+        struct thread_pid *tp;
+
+        list_for_each_entry(tp, &threads->head, next) {
+                if (tp->pid == pid)
+                        return 1;
+        }
+
+        return 0;
+}
+
+/*
+ * Append a thread_pid at the last of @threads.
+ */
+int thread_map__append(struct thread_map *threads, pid_t pid)
+{
+	struct thread_pid *tp;
+
+	if (threads == NULL)
+                return -1;
+
+	if (thread_map__has_pid(threads, pid) != 0)
+		return 1;
+
+	tp = malloc(sizeof(*tp));
+	if (tp == NULL)
+		return -1;
+
+	tp->pid = pid;
+	list_add_tail(&tp->next, &threads->head);
+	threads->nr++;
+
+	return 0;
+}
+
+static inline int thread_map__remove_last(struct thread_map *threads)
+{       
+        struct thread_pid *tp;
+        
+        if (!list_empty(&threads->head)) {
+                tp = list_entry(threads->head.prev, struct thread_pid, next);
+                list_del(&tp->next);
+                free(tp);
+                threads->nr--;
+                return 0;
+        }
+        
+        return -1;
+}       
+
+/*
+ * remove a thread_pid from threads, the thread_pid is indexed by @idx.
+ * if @idx is -1, the last thread_pid is removed.
+ */
+int thread_map__remove(struct thread_map *threads, int idx)
+{
+	struct thread_pid *tp, *tmp;
+	int count = 0;
+
+	if (idx == -1)
+		return thread_map__remove_last(threads);
+
+	list_for_each_entry_safe(tp, tmp, &threads->head, next) {
+		if (count++ == idx) {
+			list_del(&tp->next);
+			free(tp);
+			threads->nr--;
+			return 0;
+		}
+	}
+
+	return -1;
+}
+
+struct thread_map *thread_map__new_by_pid(pid_t pid)
+{
+	struct thread_map *threads = NULL;
 	char name[256];
 	int items;
 	struct dirent **namelist = NULL;
@@ -32,11 +139,14 @@ struct thread_map *thread_map__new_by_pid(pid_t pid)
 	if (items <= 0)
 		return NULL;
 
-	threads = malloc(sizeof(*threads) + sizeof(pid_t) * items);
+	threads = thread_map__init();
 	if (threads != NULL) {
-		for (i = 0; i < items; i++)
-			threads->map[i] = atoi(namelist[i]->d_name);
-		threads->nr = items;
+		for (i = 0; i < items; i++) {
+			pid_t pid_num = atoi(namelist[i]->d_name);
+
+			if (thread_map__append(threads, pid_num) == -1)
+				goto out_free_threads;
+		}
 	}
 
 	for (i=0; i<items; i++)
@@ -44,28 +154,38 @@ struct thread_map *thread_map__new_by_pid(pid_t pid)
 	free(namelist);
 
 	return threads;
+
+out_free_threads:
+	thread_map__delete(threads);
+	return NULL;
 }
 
 struct thread_map *thread_map__new_by_tid(pid_t tid)
 {
-	struct thread_map *threads = malloc(sizeof(*threads) + sizeof(pid_t));
+	struct thread_map *threads = NULL;
 
+	threads = thread_map__init();
 	if (threads != NULL) {
-		threads->map[0] = tid;
-		threads->nr	= 1;
+		if (thread_map__append(threads, tid) == -1)
+			goto out_free_threads;
 	}
 
 	return threads;
+
+out_free_threads:
+	thread_map__delete(threads);
+	return NULL;
 }
 
 struct thread_map *thread_map__new_by_uid(uid_t uid)
 {
 	DIR *proc;
-	int max_threads = 32, items, i;
+	int items, i;
 	char path[256];
 	struct dirent dirent, *next, **namelist = NULL;
-	struct thread_map *threads = malloc(sizeof(*threads) +
-					    max_threads * sizeof(pid_t));
+	struct thread_map *threads = NULL;
+
+	threads = thread_map__init();
 	if (threads == NULL)
 		goto out;
 
@@ -73,11 +193,8 @@ struct thread_map *thread_map__new_by_uid(uid_t uid)
 	if (proc == NULL)
 		goto out_free_threads;
 
-	threads->nr = 0;
-
 	while (!readdir_r(proc, &dirent, &next) && next) {
 		char *end;
-		bool grow = false;
 		struct stat st;
 		pid_t pid = strtol(dirent.d_name, &end, 10);
 
@@ -97,30 +214,14 @@ struct thread_map *thread_map__new_by_uid(uid_t uid)
 		if (items <= 0)
 			goto out_free_closedir;
 
-		while (threads->nr + items >= max_threads) {
-			max_threads *= 2;
-			grow = true;
-		}
-
-		if (grow) {
-			struct thread_map *tmp;
-
-			tmp = realloc(threads, (sizeof(*threads) +
-						max_threads * sizeof(pid_t)));
-			if (tmp == NULL)
+		for (i = 0; i < items; i++) {
+			if (thread_map__append(threads, atoi(namelist[i]->d_name) < 0))
 				goto out_free_namelist;
-
-			threads = tmp;
 		}
 
 		for (i = 0; i < items; i++)
-			threads->map[threads->nr + i] = atoi(namelist[i]->d_name);
-
-		for (i = 0; i < items; i++)
 			free(namelist[i]);
 		free(namelist);
-
-		threads->nr += items;
 	}
 
 out_closedir:
@@ -129,7 +230,7 @@ out:
 	return threads;
 
 out_free_threads:
-	free(threads);
+	thread_map__delete(threads);
 	return NULL;
 
 out_free_namelist:
@@ -138,7 +239,7 @@ out_free_namelist:
 	free(namelist);
 
 out_free_closedir:
-	free(threads);
+	thread_map__delete(threads);
 	threads = NULL;
 	goto out_closedir;
 }
@@ -156,11 +257,11 @@ struct thread_map *thread_map__new(pid_t pid, pid_t tid, uid_t uid)
 
 static struct thread_map *thread_map__new_by_pid_str(const char *pid_str)
 {
-	struct thread_map *threads = NULL, *nt;
+	struct thread_map *threads = NULL;
 	char name[256];
-	int items, total_tasks = 0;
+	int items;
 	struct dirent **namelist = NULL;
-	int i, j = 0;
+	int i;
 	pid_t pid, prev_pid = INT_MAX;
 	char *end_ptr;
 	struct str_node *pos;
@@ -169,6 +270,10 @@ static struct thread_map *thread_map__new_by_pid_str(const char *pid_str)
 	if (!slist)
 		return NULL;
 
+	threads = thread_map__init();
+	if (threads == NULL)
+		return NULL;
+
 	strlist__for_each(pos, slist) {
 		pid = strtol(pos->s, &end_ptr, 10);
 
@@ -184,19 +289,13 @@ static struct thread_map *thread_map__new_by_pid_str(const char *pid_str)
 		if (items <= 0)
 			goto out_free_threads;
 
-		total_tasks += items;
-		nt = realloc(threads, (sizeof(*threads) +
-				       sizeof(pid_t) * total_tasks));
-		if (nt == NULL)
-			goto out_free_namelist;
-
-		threads = nt;
-
 		for (i = 0; i < items; i++) {
-			threads->map[j++] = atoi(namelist[i]->d_name);
-			free(namelist[i]);
+			if (thread_map__append(threads, atoi(namelist[i]->d_name)) < 0)
+				goto out_free_namelist;
 		}
-		threads->nr = total_tasks;
+
+		for (i = 0; i < items; i++)
+			free(namelist[i]);
 		free(namelist);
 	}
 
@@ -210,15 +309,14 @@ out_free_namelist:
 	free(namelist);
 
 out_free_threads:
-	free(threads);
+	thread_map__delete(threads);
 	threads = NULL;
 	goto out;
 }
 
 static struct thread_map *thread_map__new_by_tid_str(const char *tid_str)
 {
-	struct thread_map *threads = NULL, *nt;
-	int ntasks = 0;
+	struct thread_map *threads = NULL;
 	pid_t tid, prev_tid = INT_MAX;
 	char *end_ptr;
 	struct str_node *pos;
@@ -226,14 +324,16 @@ static struct thread_map *thread_map__new_by_tid_str(const char *tid_str)
 
 	/* perf-stat expects threads to be generated even if tid not given */
 	if (!tid_str) {
-		threads = malloc(sizeof(*threads) + sizeof(pid_t));
-		if (threads != NULL) {
-			threads->map[0] = -1;
-			threads->nr	= 1;
-		}
+		threads = thread_map__init();
+		if (threads != NULL)
+			thread_map__append(threads, -1);
 		return threads;
 	}
 
+	threads = thread_map__init();
+	if (!threads)
+		goto out;
+
 	slist = strlist__new(false, tid_str);
 	if (!slist)
 		return NULL;
@@ -248,21 +348,14 @@ static struct thread_map *thread_map__new_by_tid_str(const char *tid_str)
 		if (tid == prev_tid)
 			continue;
 
-		ntasks++;
-		nt = realloc(threads, sizeof(*threads) + sizeof(pid_t) * ntasks);
-
-		if (nt == NULL)
+		if (thread_map__append(threads, tid) == -1)
 			goto out_free_threads;
-
-		threads = nt;
-		threads->map[ntasks - 1] = tid;
-		threads->nr		 = ntasks;
 	}
 out:
 	return threads;
 
 out_free_threads:
-	free(threads);
+	thread_map__delete(threads);
 	threads = NULL;
 	goto out;
 }
@@ -279,18 +372,66 @@ struct thread_map *thread_map__new_str(const char *pid, const char *tid,
 	return thread_map__new_by_tid_str(tid);
 }
 
-void thread_map__delete(struct thread_map *threads)
+int thread_map__get_idx_by_pid(struct thread_map *threads, pid_t pid)
 {
-	free(threads);
+	struct thread_pid *tp;
+	int count = 0;
+
+	list_for_each_entry(tp, &threads->head, next) {
+		if (tp->pid == pid)
+			return count;
+		count++;
+	}
+
+	return -1; 
+}
+
+struct thread_map *thread_map__empty_thread_map(void)
+{
+	struct thread_map *empty_thread_map = NULL;
+
+	empty_thread_map = thread_map__init();
+	if (empty_thread_map)
+		thread_map__append(empty_thread_map, -1);
+
+	return empty_thread_map;
+}
+
+int thread_map__set_pid(struct thread_map *threads, int idx, pid_t pid)
+{
+	struct thread_pid *tp;
+	int count = 0;
+
+	list_for_each_entry(tp, &threads->head, next) {
+		if (count++ == idx) {
+			tp->pid = pid;
+			return 0;
+		}
+	}
+	return -1;
+}
+
+int thread_map__get_pid(struct thread_map *threads, int idx)
+{
+	struct thread_pid *tp;
+	int count = 0;                 
+
+	list_for_each_entry(tp, &threads->head, next) {
+		if (count++ == idx)
+			return tp->pid;
+	}
+
+	return -1;
 }
 
 size_t thread_map__fprintf(struct thread_map *threads, FILE *fp)
 {
-	int i;
+	int i = 0;
+	struct thread_pid *tp;
 	size_t printed = fprintf(fp, "%d thread%s: ",
 				 threads->nr, threads->nr > 1 ? "s" : "");
-	for (i = 0; i < threads->nr; ++i)
-		printed += fprintf(fp, "%s%d", i ? ", " : "", threads->map[i]);
+	list_for_each_entry(tp, &threads->head, next)
+		printed += fprintf(fp, "%s%d", i++ ? ", " : "", tp->pid);
 
 	return printed + fprintf(fp, "\n");
 }
diff --git a/tools/perf/util/thread_map.h b/tools/perf/util/thread_map.h
index f718df8..f6691ad 100644
--- a/tools/perf/util/thread_map.h
+++ b/tools/perf/util/thread_map.h
@@ -3,20 +3,35 @@
 
 #include <sys/types.h>
 #include <stdio.h>
+#include <linux/list.h>
+
+struct thread_pid {
+        struct list_head next;
+        pid_t pid;
+};
 
 struct thread_map {
 	int nr;
-	pid_t map[];
+	struct list_head head;
 };
 
+struct thread_map *thread_map__init(void);
 struct thread_map *thread_map__new_by_pid(pid_t pid);
 struct thread_map *thread_map__new_by_tid(pid_t tid);
 struct thread_map *thread_map__new_by_uid(uid_t uid);
 struct thread_map *thread_map__new(pid_t pid, pid_t tid, uid_t uid);
+struct thread_map *thread_map__empty_thread_map(void);
 
 struct thread_map *thread_map__new_str(const char *pid,
 		const char *tid, uid_t uid);
 
+int thread_map__append(struct thread_map *threads, pid_t pid);
+int thread_map__remove(struct thread_map *threads, int idx);
+int thread_map__set_pid(struct thread_map *threads, int idx, pid_t pid);
+int thread_map__get_pid(struct thread_map *threads, int index);
+int thread_map__get_idx_by_pid(struct thread_map *threads, pid_t pid);
+int thread_map__has_pid(struct thread_map *threadsd, pid_t pid);
+
 void thread_map__delete(struct thread_map *threads);
 
 size_t thread_map__fprintf(struct thread_map *threads, FILE *fp);
-- 
1.7.9.5

