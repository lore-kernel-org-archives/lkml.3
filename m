Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173Ab3CMJnc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 05:43:32 -0400
Received: from mail-da0-f47.google.com ([209.85.210.47]:33287 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755990Ab3CMJn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 05:43:28 -0400
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
Subject: [PATCH v3 5/8]Perf: add extend mechanism for evsel->id & evsel->fd
Date: Wed, 13 Mar 2013 17:42:15 +0800
Message-Id: <1363167740-27735-4-git-send-email-chenggang.qin@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1363167740-27735-1-git-send-email-chenggang.qin@gmail.com>
References: <1363167740-27735-1-git-send-email-chenggang.qin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: chenggang <chenggang.qcg@taobao.com>

Add extend mechanism for evsel->id & evsel->fd.

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
 tools/perf/util/evsel.c      |   76 ++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/evsel.h      |    8 +++++
 tools/perf/util/thread_map.c |    2 +-
 3 files changed, 85 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 015321f..2eb75f9 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -599,6 +599,16 @@ int perf_evsel__alloc_fd(struct perf_evsel *evsel, int ncpus, int nthreads)
 	return evsel->fd != NULL ? 0 : -ENOMEM;
 }
 
+/*
+ * Return the pointer to new fds (fds for the new thread at all cpus).
+ */
+static int** perf_evsel__extend_fd(struct perf_evsel *evsel)
+{
+	int init_fd = -1;
+
+	return (int**)xyarray__append(evsel->fd, (char *)&init_fd);
+}
+
 int perf_evsel__set_filter(struct perf_evsel *evsel, int ncpus, int nthreads,
 			   const char *filter)
 {
@@ -617,6 +627,26 @@ int perf_evsel__set_filter(struct perf_evsel *evsel, int ncpus, int nthreads,
 	return 0;
 }
 
+int perf_evsel__extend_id(struct perf_evsel *evsel)
+{
+	if (xyarray__append(evsel->sample_id, NULL) == NULL)
+		return -ENOMEM;
+
+	if (xyarray__append(evsel->id, NULL) == NULL) {
+		xyarray__remove(evsel->sample_id, -1);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
+void perf_evsel__remove_id(struct perf_evsel *evsel, int tidx)
+{
+	xyarray__remove(evsel->id, tidx);
+	evsel->ids--;
+	xyarray__remove(evsel->sample_id, tidx);
+}
+
 int perf_evsel__alloc_id(struct perf_evsel *evsel, int ncpus, int nthreads)
 {
 	evsel->sample_id = xyarray__new(ncpus, nthreads, sizeof(struct perf_sample_id));
@@ -937,6 +967,52 @@ int perf_evsel__open_per_thread(struct perf_evsel *evsel,
 	return __perf_evsel__open(evsel, &empty_cpu_map.map, threads);
 }
 
+void perf_evsel__close_single_thread(struct perf_evsel *evsel, int cpu_nr,
+				     int tidx)
+{
+	int cpu;
+
+	for (cpu = 0; cpu < cpu_nr; cpu++) {
+		if (FD(evsel, cpu, tidx) >= 0)
+			close(FD(evsel, cpu, tidx));
+	}
+	xyarray__remove(evsel->fd, tidx); 
+}
+
+int perf_evsel__open_single_thread(struct perf_evsel *evsel,
+                                   struct cpu_map *cpus, int tid)
+{
+	int cpu;
+	int pid = -1;
+	unsigned long flags = 0;
+	int **new_fds;
+
+	if ((new_fds = perf_evsel__extend_fd(evsel)) == NULL)
+		return -1;
+
+	if (evsel->cgrp) {
+		flags = PERF_FLAG_PID_CGROUP;
+		pid = evsel->cgrp->fd;
+	}
+
+	for (cpu = 0; cpu < cpus->nr; cpu++) {
+		int group_fd;
+
+		if (!evsel->cgrp)
+			pid = tid;
+
+		group_fd = get_group_fd(evsel, cpu, -1);
+		evsel->attr.disabled = 0;
+		*new_fds[cpu] = sys_perf_event_open(&evsel->attr, pid,
+						    cpus->map[cpu], group_fd,
+						    flags);
+		if (*new_fds[cpu] < 0)
+			return -errno;
+	}
+
+	return 0;
+}
+
 static int perf_evsel__parse_id_sample(const struct perf_evsel *evsel,
 				       const union perf_event *event,
 				       struct perf_sample *sample)
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 7adb116..ae391d4 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -128,6 +128,9 @@ void perf_evsel__close_fd(struct perf_evsel *evsel, int ncpus, int nthreads);
 void perf_evsel__id_new(struct perf_evsel *evsel, int nr);
 u64 *perf_evsel__get_id(struct perf_evsel *evsel, int idx);
 
+int perf_evsel__extend_id(struct perf_evsel *evsel);
+void perf_evsel__remove_id(struct perf_evsel *evsel, int tidx);
+
 void __perf_evsel__set_sample_bit(struct perf_evsel *evsel,
 				  enum perf_event_sample_format bit);
 void __perf_evsel__reset_sample_bit(struct perf_evsel *evsel,
@@ -152,6 +155,11 @@ int perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
 		     struct thread_map *threads);
 void perf_evsel__close(struct perf_evsel *evsel, int ncpus, int nthreads);
 
+int perf_evsel__open_single_thread(struct perf_evsel *evsel,
+				   struct cpu_map *cpus, int tid);
+void perf_evsel__close_single_thread(struct perf_evsel *evsel, int cpu_nr,
+				     int tidx);
+
 struct perf_sample;
 
 void *perf_evsel__rawptr(struct perf_evsel *evsel, struct perf_sample *sample,
diff --git a/tools/perf/util/thread_map.c b/tools/perf/util/thread_map.c
index 301f4ce..76f3da7 100644
--- a/tools/perf/util/thread_map.c
+++ b/tools/perf/util/thread_map.c
@@ -64,7 +64,7 @@ int thread_map__has_pid(struct thread_map *threads, pid_t pid)
 }
 
 /*
- * Append a thread_pid at the last of @threads.
+ * Append a thread_pid at the tail of @threads.
  */
 int thread_map__append(struct thread_map *threads, pid_t pid)
 {
-- 
1.7.9.5

