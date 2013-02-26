Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932670Ab3BZJm3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 04:42:29 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:35859 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760031Ab3BZJm0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 04:42:26 -0500
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
Subject: [PATCH v2 4/4] Add fork and exit callback functions into top->perf_tool
Date: Tue, 26 Feb 2013 17:41:46 +0800
Message-Id: <1361871710-6251-1-git-send-email-chenggang.qin@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: chenggang <chenggang.qcg@taobao.com>

Many applications will fork threads on-the-fly, these threads could exit before
the main thread exit. The perf top tool should perceive the new forked threads
while we profile a special application.
If the target process fork a thread or a thread exit, we will get a PERF_RECORD_FORK
 or PERF_RECORD_EXIT events. The following callback functions can process these events.
1) perf_top__process_event_fork()
   Open a new fd for the new forked, and expend the related data structures.
2) perf_top__process_event_exit()
   Close the fd of exit threadsd, and destroy the nodes in the related data structures.

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
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Signed-off-by: Chenggang Qin <chenggang.qcg@taobao.com>

---
 tools/perf/builtin-top.c     |  100 +++++++++++++++++++++++++++++++++++++++++-
 tools/perf/util/evlist.c     |   30 ++++++-------
 tools/perf/util/evsel.c      |   13 +++---
 tools/perf/util/thread_map.c |   13 ++++++
 tools/perf/util/thread_map.h |    3 --
 5 files changed, 133 insertions(+), 26 deletions(-)

diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
index 72f6eb7..94aab11 100644
--- a/tools/perf/builtin-top.c
+++ b/tools/perf/builtin-top.c
@@ -806,7 +806,7 @@ static void perf_top__mmap_read_idx(struct perf_top *top, int idx)
 	struct perf_evsel *evsel;
 	struct perf_session *session = top->session;
 	union perf_event *event;
-	struct machine *machine;
+	struct machine *machine = NULL;
 	u8 origin;
 	int ret;
 
@@ -825,6 +825,20 @@ static void perf_top__mmap_read_idx(struct perf_top *top, int idx)
 		if (event->header.type == PERF_RECORD_SAMPLE)
 			++top->samples;
 
+		if (cpu_map__all(top->evlist->cpus) &&
+		    event->header.type == PERF_RECORD_FORK)
+			(&top->tool)->fork(&top->tool, event, &sample, machine);
+
+		if (cpu_map__all(top->evlist->cpus) &&
+		    event->header.type == PERF_RECORD_EXIT) {
+			int tidx;
+
+			tidx = (&top->tool)->exit(&top->tool, event,
+				&sample, machine);
+			if (tidx == idx)
+				break;
+		}
+
 		switch (origin) {
 		case PERF_RECORD_MISC_USER:
 			++top->us_samples;
@@ -1024,11 +1038,95 @@ parse_callchain_opt(const struct option *opt, const char *arg, int unset)
 	return record_parse_callchain_opt(opt, arg, unset);
 }
 
+static int perf_top__append_thread(struct perf_top *top, int tidx)
+{
+	struct perf_evsel *counter;
+	struct perf_evlist *evlist = top->evlist;
+	struct cpu_map *cpus = evlist->cpus;
+
+	list_for_each_entry(counter, &evlist->entries, node)
+		if (perf_evsel__open_thread(counter, cpus, evlist->threads, tidx) < 0) {
+			printf("errno: %d\n", errno);
+			return -1;
+		}
+
+	if (perf_evlist__mmap_thread(evlist, false, tidx) < 0)
+		return -1;
+
+	return 0;
+}
+
+static int perf_top__process_event_fork(struct perf_tool *tool __maybe_unused,
+					union perf_event *event __maybe_unused,
+					struct perf_sample *sample __maybe_unused,
+					struct machine *machine __maybe_unused)
+{
+	pid_t tid = event->fork.tid;
+	pid_t ptid = event->fork.ptid;
+	struct perf_top *top = container_of(tool, struct perf_top, tool);
+	struct thread_map *threads = top->evlist->threads;
+	struct perf_evsel *evsel;
+	int i, ret;
+
+	if (!cpu_map__all(top->evlist->cpus))
+		return -1;
+
+	ret = thread_map__append(threads, tid);
+	if (ret == 1)
+		return ret;
+	if (ret == -1)
+		return ret;
+
+	for(i = 0; i < threads->nr; i++) {
+		if (ptid == thread_map__get_pid(threads, i)) {
+			if (perf_top__append_thread(top, threads->nr - 1) < 0)
+				goto free_new_thread;
+			break;
+		}
+	}
+
+	return 0;
+
+free_new_thread:
+	list_for_each_entry(evsel, &top->evlist->entries, node)
+		perf_evsel__close_thread(evsel, top->evlist->cpus->nr, threads->nr - 1);
+	thread_map__remove(threads, threads->nr - 1);
+	return -1;
+}
+
+static int perf_top__process_event_exit(struct perf_tool *tool __maybe_unused,
+					union perf_event *event __maybe_unused,
+					struct perf_sample *sample __maybe_unused,
+					struct machine *machine __maybe_unused)
+{
+	pid_t tid = event->fork.tid;
+	struct perf_top *top = container_of(tool, struct perf_top, tool);
+	struct perf_evsel *evsel;
+	struct thread_map *threads = top->evlist->threads;
+	int tidx = thread_map__get_idx_by_pid(threads, tid);
+
+	if (!cpu_map__all(top->evlist->cpus) || tidx < 0) //ignore
+		return -1;
+
+	perf_evlist__munmap_thread(top->evlist, tidx);
+
+	list_for_each_entry(evsel, &top->evlist->entries, node)
+		perf_evsel__close_thread(evsel, top->evlist->cpus->nr, tidx);
+
+	thread_map__remove(threads, tidx);
+
+	return tidx;
+}
+
 int cmd_top(int argc, const char **argv, const char *prefix __maybe_unused)
 {
 	int status;
 	char errbuf[BUFSIZ];
 	struct perf_top top = {
+		.tool = {
+			.fork           = perf_top__process_event_fork,
+			.exit           = perf_top__process_event_exit,
+		},
 		.count_filter	     = 5,
 		.delay_secs	     = 2,
 		.record_opts = {
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 90cfbb6..eb07dbb 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -264,24 +264,24 @@ void perf_evlist__enable(struct perf_evlist *evlist)
  */
 static int perf_evlist__append_pollfd_thread(struct perf_evlist *evlist)
 {
-        int new_nfds;
+	int new_nfds;
 
-        if (cpu_map__all(evlist->cpus)) {
-                struct pollfd *pfd;
+	if (cpu_map__all(evlist->cpus)) {
+		struct pollfd *pfd;
 
-                new_nfds = evlist->threads->nr * evlist->nr_entries;
-                pfd = zalloc(sizeof(struct pollfd) * new_nfds); //FIXME
+		new_nfds = evlist->threads->nr * evlist->nr_entries;
+		pfd = zalloc(sizeof(struct pollfd) * new_nfds);
 
-                if (!pfd)
-                        return -1;
+		if (!pfd)
+			return -1;
 
-                memcpy(pfd, evlist->pollfd, (evlist->threads->nr - 1) * evlist->nr_entries);
+		memcpy(pfd, evlist->pollfd, (evlist->threads->nr - 1) * evlist->nr_entries);
 
-                evlist->pollfd = pfd;
-                return 0;
-        }
+		evlist->pollfd = pfd;
+		return 0;
+	}
 
-        return 1;
+	return 1;
 }
 
 static int perf_evlist__alloc_pollfd(struct perf_evlist *evlist)
@@ -448,7 +448,7 @@ static int perf_evlist__append_mmap_thread(struct perf_evlist *evlist)
 		return -1;
 	evlist->nr_mmaps++;
 
-	return 1;
+	return 0;
 }
 
 static int perf_evlist__alloc_mmap(struct perf_evlist *evlist)
@@ -573,8 +573,7 @@ int perf_evlist__mmap_thread(struct perf_evlist *evlist, bool overwrite, int tid
 		goto free_append_mmap;
 
 	list_for_each_entry(evsel, &evlist->entries, node)
-		if ((evsel->attr.read_format & PERF_FORMAT_ID) &&
-		    evsel->sample_id == NULL)
+		if (evsel->attr.read_format & PERF_FORMAT_ID)
 			if (perf_evsel__append_id_thread(evsel, tidx) < 0)
 				goto free_append_pollfd;
 
@@ -633,6 +632,7 @@ void perf_evlist__munmap_thread(struct perf_evlist *evlist, int tidx)
 
 	list_for_each_entry(evsel, &evlist->entries, node) {
 		xyarray__remove(evsel->id, tidx);
+		evsel->ids--;
 		xyarray__remove(evsel->sample_id, tidx);
 	}
 
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index c439027..68b2813 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -851,10 +851,9 @@ int perf_evsel__open_thread(struct perf_evsel *evsel, struct cpu_map *cpus,
 	int cpu;
 	int pid = -1;
 	unsigned long flags = 0;
-	int err;
 
 	if (perf_evsel__append_fd(evsel, tidx) < 0)
-		return 1;
+		return -1;
 
 	if (evsel->cgrp) {
 		flags = PERF_FLAG_PID_CGROUP;
@@ -868,15 +867,15 @@ int perf_evsel__open_thread(struct perf_evsel *evsel, struct cpu_map *cpus,
 			pid = tid;
 
 		group_fd = get_group_fd(evsel, cpu, tidx);
+		evsel->attr.disabled = 0;
 		FD(evsel, cpu, tidx) = sys_perf_event_open(&evsel->attr,
 							   pid,
 							   cpus->map[cpu],
 							   group_fd, flags);
-		if (FD(evsel, cpu, tidx) < 0) {
-			printf("error: cannot open counter for: %d\n", tid);
-			err = -errno;
-			printf("errno: %d\n", errno);
-			return err;
+		if (FD(evsel, cpu, tidx) < 0) {
+			pr_warning("error: cannot open counter for: %d\n", tid);
+			pr_warning("errno: %d\n", errno);
+			return -errno;
 		}
 	}
 
diff --git a/tools/perf/util/thread_map.c b/tools/perf/util/thread_map.c
index 5f96fdf..0d3ec3f 100644
--- a/tools/perf/util/thread_map.c
+++ b/tools/perf/util/thread_map.c
@@ -322,6 +322,19 @@ struct thread_map *thread_map__new_str(const char *pid, const char *tid,
 	return thread_map__new_by_tid_str(tid);
 }
 
+int thread_map__get_idx_by_pid(struct thread_map *threads, pid_t pid)
+{
+	struct thread_pid *tp;
+	int count = 0;
+
+	list_for_each_entry(tp, &threads->head, next) {
+		if (tp->pid == pid)
+			return count;
+		count++;
+	}
+	return -1;
+}
+
 struct thread_map *thread_map__empty_thread_map(void)
 {
 	struct thread_map *empty_thread_map = NULL;
diff --git a/tools/perf/util/thread_map.h b/tools/perf/util/thread_map.h
index e5a3013..cfe586b 100644
--- a/tools/perf/util/thread_map.h
+++ b/tools/perf/util/thread_map.h
@@ -27,10 +27,7 @@ struct thread_map *thread_map__new_str(const char *pid,
 		const char *tid, uid_t uid);
 
 int thread_map__append(struct thread_map *threads, pid_t pid);
-int thread_map__remove_by_pid(struct thread_map *threads, pid_t pid);
 int thread_map__remove(struct thread_map *threads, int idx);
-int thread_map__set_xy_pid(struct xyarray *xy, struct thread_map *threads);
-int thread_map__set_pid(struct thread_map *threads, int index, pid_t pid);
 int thread_map__get_pid(struct thread_map *threads, int index);
 int thread_map__get_idx_by_pid(struct thread_map *threads, pid_t pid);
 
-- 
1.7.9.5

