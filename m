Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760049Ab3BZJWE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 04:22:04 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:54074 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751515Ab3BZJWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 04:22:00 -0500
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
Subject: [PATCH v2 3/4] Transform mmap and other related structures to list with new xyarray
Date: Tue, 26 Feb 2013 17:20:50 +0800
Message-Id: <1361870452-6143-4-git-send-email-chenggang.qin@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361870452-6143-1-git-send-email-chenggang.qin@gmail.com>
References: <1361870452-6143-1-git-send-email-chenggang.qin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: chenggang <chenggang.qcg@taobao.com>

evlist->mmap, evsel->id, evsel->sample_id are arrays. They cannot be expended or
shrinked easily for the forked and exited threads while we get the fork and exit
events.
We transfromed them to linked list with the new xyarray.
xyarray is a 2-dimensional structure. The row is a array still, and a row represents a cpu.
The column is a linked list, and a column represents a thread.

Some functions are implemented to expand and shrink the mmap, id and sample_id too.
1) perf_evsel__append_id_thread()
   Append a id for a evsel while a new thread is perceived.
2) perf_evsel__append_fd_thread()
   Append a fd for a evsel while a new thread is perceived.
3) perf_evlist__append_mmap_thread()
   Append a new node into evlist->mmap while a new thread is perceived.
3) perf_evsel__open_thread()
   Open the fd for the new thread with sys_perf_event_open.
4) perf_evsel__close_thread()
   Close the fd while a thread exit.
5) perf_evlist__mmap_thread()
   mmap a new thread's fd.
6) perf_evlist__munmap_thread()
   unmmap a exit thread's fd.

The following macros can be used to reference a special fd, id, mmap, sample_id etc.
1) FD(cpu, thread)
2) SID(cpu, thread)
3) ID(cpu, thread)
4) MMAP(cpu, thread)

evlist->pollfd is the parameter of syscall poll(), it must be a array. But we
implement a function (perf_evlist__append_pollfd_thread) to expand and shrink it.

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
 tools/perf/builtin-record.c |    6 +-
 tools/perf/util/evlist.c    |  169 ++++++++++++++++++++++++++++++++++++++-----
 tools/perf/util/evlist.h    |    6 +-
 tools/perf/util/evsel.c     |   83 ++++++++++++++++++++-
 tools/perf/util/evsel.h     |    8 +-
 tools/perf/util/header.c    |   31 ++++----
 tools/perf/util/header.h    |    3 +-
 7 files changed, 263 insertions(+), 43 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 774c907..13112c6 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -31,6 +31,8 @@
 #include <sched.h>
 #include <sys/mman.h>
 
+#define MMAP(e, y) (*(struct perf_mmap *)xyarray__entry(e->mmap, 0, y))
+
 #ifndef HAVE_ON_EXIT
 #ifndef ATEXIT_MAX
 #define ATEXIT_MAX 32
@@ -367,8 +369,8 @@ static int perf_record__mmap_read_all(struct perf_record *rec)
 	int rc = 0;
 
 	for (i = 0; i < rec->evlist->nr_mmaps; i++) {
-		if (rec->evlist->mmap[i].base) {
-			if (perf_record__mmap_read(rec, &rec->evlist->mmap[i]) != 0) {
+		if (MMAP(rec->evlist, i).base) {
+			if (perf_record__mmap_read(rec, &MMAP(rec->evlist, i)) != 0) {
 				rc = -1;
 				goto out;
 			}
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index d5063d6..90cfbb6 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -25,6 +25,8 @@
 
 #define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
 #define SID(e, x, y) xyarray__entry(e->sample_id, x, y)
+#define ID(e, y) (*(u64 *)xyarray__entry(e->id, 0, y))
+#define MMAP(e, y) (*(struct perf_mmap *)xyarray__entry(e->mmap, 0, y))
 
 void perf_evlist__init(struct perf_evlist *evlist, struct cpu_map *cpus,
 		       struct thread_map *threads)
@@ -85,7 +87,7 @@ static void perf_evlist__purge(struct perf_evlist *evlist)
 
 void perf_evlist__exit(struct perf_evlist *evlist)
 {
-	free(evlist->mmap);
+	xyarray__delete(evlist->mmap);
 	free(evlist->pollfd);
 	evlist->mmap = NULL;
 	evlist->pollfd = NULL;
@@ -256,6 +258,32 @@ void perf_evlist__enable(struct perf_evlist *evlist)
 	}
 }
 
+/*
+ * If threads->nr > 1, the cpu_map__nr() must be 1.
+ * If the cpu_map__nr() > 1, we should not append pollfd.
+ */
+static int perf_evlist__append_pollfd_thread(struct perf_evlist *evlist)
+{
+	int new_nfds;
+
+	if (cpu_map__all(evlist->cpus)) {
+		struct pollfd *pfd;
+
+		new_nfds = evlist->threads->nr * evlist->nr_entries;
+		pfd = zalloc(sizeof(struct pollfd) * new_nfds);
+
+		if (!pfd)
+			return -1;
+
+		memcpy(pfd, evlist->pollfd, (evlist->threads->nr - 1) * evlist->nr_entries);
+
+		evlist->pollfd = pfd;
+		return 0;
+	}
+
+	return 1;
+}
+
 static int perf_evlist__alloc_pollfd(struct perf_evlist *evlist)
 {
 	int nfds = cpu_map__nr(evlist->cpus) * evlist->threads->nr * evlist->nr_entries;
@@ -288,7 +316,7 @@ void perf_evlist__id_add(struct perf_evlist *evlist, struct perf_evsel *evsel,
 			 int cpu, int thread, u64 id)
 {
 	perf_evlist__id_hash(evlist, evsel, cpu, thread, id);
-	evsel->id[evsel->ids++] = id;
+	ID(evsel, evsel->ids++) = id;
 }
 
 static int perf_evlist__id_add_fd(struct perf_evlist *evlist,
@@ -336,7 +364,7 @@ struct perf_evsel *perf_evlist__id2evsel(struct perf_evlist *evlist, u64 id)
 
 union perf_event *perf_evlist__mmap_read(struct perf_evlist *evlist, int idx)
 {
-	struct perf_mmap *md = &evlist->mmap[idx];
+	struct perf_mmap *md = &MMAP(evlist, idx);
 	unsigned int head = perf_mmap__read_head(md);
 	unsigned int old = md->prev;
 	unsigned char *data = md->base + page_size;
@@ -404,9 +432,9 @@ void perf_evlist__munmap(struct perf_evlist *evlist)
 	int i;
 
 	for (i = 0; i < evlist->nr_mmaps; i++) {
-		if (evlist->mmap[i].base != NULL) {
-			munmap(evlist->mmap[i].base, evlist->mmap_len);
-			evlist->mmap[i].base = NULL;
+		if (MMAP(evlist, i).base != NULL) {
+			munmap(MMAP(evlist, i).base, evlist->mmap_len);
+			MMAP(evlist, i).base = NULL;
 		}
 	}
 
@@ -414,27 +442,35 @@ void perf_evlist__munmap(struct perf_evlist *evlist)
 	evlist->mmap = NULL;
 }
 
+static int perf_evlist__append_mmap_thread(struct perf_evlist *evlist)
+{
+	if (xyarray__append(evlist->mmap) < 0)
+		return -1;
+	evlist->nr_mmaps++;
+
+	return 1;
+}
+
 static int perf_evlist__alloc_mmap(struct perf_evlist *evlist)
 {
 	evlist->nr_mmaps = cpu_map__nr(evlist->cpus);
 	if (cpu_map__all(evlist->cpus))
 		evlist->nr_mmaps = evlist->threads->nr;
-	evlist->mmap = zalloc(evlist->nr_mmaps * sizeof(struct perf_mmap));
+	evlist->mmap = xyarray__new(1, evlist->nr_mmaps, sizeof(struct perf_mmap));
 	return evlist->mmap != NULL ? 0 : -ENOMEM;
 }
 
 static int __perf_evlist__mmap(struct perf_evlist *evlist,
 			       int idx, int prot, int mask, int fd)
 {
-	evlist->mmap[idx].prev = 0;
-	evlist->mmap[idx].mask = mask;
-	evlist->mmap[idx].base = mmap(NULL, evlist->mmap_len, prot,
+	MMAP(evlist, idx).prev = 0;
+	MMAP(evlist, idx).mask = mask;
+	MMAP(evlist, idx).base = mmap(NULL, evlist->mmap_len, prot,
 				      MAP_SHARED, fd, 0);
-	if (evlist->mmap[idx].base == MAP_FAILED) {
-		evlist->mmap[idx].base = NULL;
+	if (MMAP(evlist, idx).base == MAP_FAILED) {
+		MMAP(evlist, idx).base = NULL;
 		return -1;
 	}
-
 	perf_evlist__add_pollfd(evlist, fd);
 	return 0;
 }
@@ -460,7 +496,6 @@ static int perf_evlist__mmap_per_cpu(struct perf_evlist *evlist, int prot, int m
 					if (ioctl(fd, PERF_EVENT_IOC_SET_OUTPUT, output) != 0)
 						goto out_unmap;
 				}
-
 				if ((evsel->attr.read_format & PERF_FORMAT_ID) &&
 				    perf_evlist__id_add_fd(evlist, evsel, cpu, thread, fd) < 0)
 					goto out_unmap;
@@ -472,9 +507,9 @@ static int perf_evlist__mmap_per_cpu(struct perf_evlist *evlist, int prot, int m
 
 out_unmap:
 	for (cpu = 0; cpu < evlist->cpus->nr; cpu++) {
-		if (evlist->mmap[cpu].base != NULL) {
-			munmap(evlist->mmap[cpu].base, evlist->mmap_len);
-			evlist->mmap[cpu].base = NULL;
+		if (MMAP(evlist, cpu).base != NULL) {
+			munmap(MMAP(evlist, cpu).base, evlist->mmap_len);
+			MMAP(evlist, cpu).base = NULL;
 		}
 	}
 	return -1;
@@ -511,14 +546,108 @@ static int perf_evlist__mmap_per_thread(struct perf_evlist *evlist, int prot, in
 
 out_unmap:
 	for (thread = 0; thread < evlist->threads->nr; thread++) {
-		if (evlist->mmap[thread].base != NULL) {
-			munmap(evlist->mmap[thread].base, evlist->mmap_len);
-			evlist->mmap[thread].base = NULL;
+		if (MMAP(evlist, thread).base != NULL) {
+			munmap(MMAP(evlist, thread).base, evlist->mmap_len);
+			MMAP(evlist, thread).base = NULL;
+		}
+	}
+	return -1;
+}
+
+
+int perf_evlist__mmap_thread(struct perf_evlist *evlist, bool overwrite, int tidx)
+{
+	struct perf_evsel *evsel;
+	int prot = PROT_READ | (overwrite ? 0 : PROT_WRITE);
+	int mask = evlist->mmap_len - page_size - 1;
+	int output = -1;
+	struct pollfd *old_pollfd = evlist->pollfd;
+
+	if (!cpu_map__all(evlist->cpus))
+		return 1;
+
+	if (perf_evlist__append_mmap_thread(evlist) < 0)
+		return -ENOMEM;
+
+	if (perf_evlist__append_pollfd_thread(evlist) < 0)
+		goto free_append_mmap;
+
+	list_for_each_entry(evsel, &evlist->entries, node)
+		if ((evsel->attr.read_format & PERF_FORMAT_ID) &&
+		    evsel->sample_id == NULL)
+			if (perf_evsel__append_id_thread(evsel, tidx) < 0)
+				goto free_append_pollfd;
+
+	list_for_each_entry(evsel, &evlist->entries, node) {
+		int fd = FD(evsel, 0, tidx);
+
+		if (output == -1) {
+			output = fd;
+			if (__perf_evlist__mmap(evlist, tidx, prot, mask, output) < 0)
+				goto out_unmap;
+		} else {
+			if (ioctl(fd, PERF_EVENT_IOC_SET_OUTPUT, output) != 0)
+				goto out_unmap;
 		}
+
+		if ((evsel->attr.read_format & PERF_FORMAT_ID) &&
+		    perf_evlist__id_add_fd(evlist, evsel, 0, tidx, fd) < 0)
+			goto out_unmap;
+	}
+
+	free(old_pollfd);
+	return 0;
+out_unmap:
+	if (MMAP(evlist, tidx).base != NULL) {
+		munmap(MMAP(evlist, tidx).base, evlist->mmap_len);
+		MMAP(evlist, tidx).base = NULL;
+	}
+
+	list_for_each_entry(evsel, &evlist->entries, node) {
+		xyarray__remove(evsel->id, tidx);
+		xyarray__remove(evsel->sample_id, tidx);
 	}
+
+free_append_pollfd:
+	free(evlist->pollfd);
+	evlist->pollfd = old_pollfd;
+
+free_append_mmap:
+	xyarray__remove(evlist->mmap, tidx);
 	return -1;
 }
 
+void perf_evlist__munmap_thread(struct perf_evlist *evlist, int tidx)
+{
+	struct perf_evsel *evsel;
+	struct pollfd *pfd;
+	int old_nfds = evlist->threads->nr * evlist->nr_entries;
+	int new_nfds = (evlist->threads->nr - 1) * evlist->nr_entries;
+
+	if (MMAP(evlist, tidx).base != NULL) {
+		munmap(MMAP(evlist, tidx).base, evlist->mmap_len);
+		evlist->nr_mmaps--;
+		MMAP(evlist, tidx).base = NULL;
+		xyarray__remove(evlist->mmap, tidx);
+	}
+
+	list_for_each_entry(evsel, &evlist->entries, node) {
+		xyarray__remove(evsel->id, tidx);
+		xyarray__remove(evsel->sample_id, tidx);
+	}
+
+	pfd = zalloc(new_nfds * sizeof(struct pollfd));
+	memcpy(pfd, evlist->pollfd, tidx * evlist->nr_entries * sizeof(struct pollfd));
+	memcpy(pfd + (tidx * evlist->nr_entries),
+	       evlist->pollfd + (tidx + 1) * evlist->nr_entries,
+	       old_nfds - (tidx + 1) * evlist->nr_entries);
+
+	evlist->nr_fds--;
+
+	free(evlist->pollfd);
+	evlist->pollfd = pfd;
+}
+
 /** perf_evlist__mmap - Create per cpu maps to receive events
  *
  * @evlist - list of events
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 2dd07bd..5bf04cf 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -7,6 +7,7 @@
 #include "event.h"
 #include "evsel.h"
 #include "util.h"
+#include "xyarray.h"
 #include <unistd.h>
 
 struct pollfd;
@@ -37,7 +38,7 @@ struct perf_evlist {
 		pid_t	pid;
 	} workload;
 	bool		 overwrite;
-	struct perf_mmap *mmap;
+	struct xyarray   *mmap;
 	struct pollfd	 *pollfd;
 	struct thread_map *threads;
 	struct cpu_map	  *cpus;
@@ -131,6 +132,9 @@ void perf_evlist__splice_list_tail(struct perf_evlist *evlist,
 				   struct list_head *list,
 				   int nr_entries);
 
+int perf_evlist__mmap_thread(struct perf_evlist *evlist, bool overwrite, int tidx);
+void perf_evlist__munmap_thread(struct perf_evlist *evlist, int tidx);
+
 static inline struct perf_evsel *perf_evlist__first(struct perf_evlist *evlist)
 {
 	return list_entry(evlist->entries.next, struct perf_evsel, node);
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 57c569d..c439027 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -583,6 +583,20 @@ void perf_evsel__config(struct perf_evsel *evsel,
 		attr->enable_on_exec = 1;
 }
 
+int perf_evsel__append_fd_thread(struct perf_evsel *evsel, int tidx)
+{
+	int cpu_nr = evsel->fd->row_count;
+	int cpu;
+
+	if (xyarray__append(evsel->fd) < 0)
+		return -1;
+
+	for (cpu = 0; cpu < cpu_nr; cpu++)
+		FD(evsel, cpu, tidx) = -1;
+
+	return 0;
+}
+
 int perf_evsel__alloc_fd(struct perf_evsel *evsel, int ncpus, int nthreads)
 {
 	int cpu, thread;
@@ -617,13 +631,26 @@ int perf_evsel__set_filter(struct perf_evsel *evsel, int ncpus, int nthreads,
 	return 0;
 }
 
+int perf_evsel__append_id_thread(struct perf_evsel *evsel, int tidx)
+{
+	if (xyarray__append(evsel->sample_id) < 0)
+		return -ENOMEM;
+
+	if (xyarray__append(evsel->id) < 0) {
+		xyarray__remove(evsel->sample_id, tidx);
+		return -ENOMEM;
+	}
+
+	return 0;
+}
+
 int perf_evsel__alloc_id(struct perf_evsel *evsel, int ncpus, int nthreads)
 {
 	evsel->sample_id = xyarray__new(ncpus, nthreads, sizeof(struct perf_sample_id));
 	if (evsel->sample_id == NULL)
 		return -ENOMEM;
 
-	evsel->id = zalloc(ncpus * nthreads * sizeof(u64));
+	evsel->id = xyarray__new(1, ncpus * nthreads, sizeof(u64));
 	if (evsel->id == NULL) {
 		xyarray__delete(evsel->sample_id);
 		evsel->sample_id = NULL;
@@ -650,7 +677,7 @@ void perf_evsel__free_id(struct perf_evsel *evsel)
 {
 	xyarray__delete(evsel->sample_id);
 	evsel->sample_id = NULL;
-	free(evsel->id);
+	xyarray__delete(evsel->id);
 	evsel->id = NULL;
 }
 
@@ -675,7 +702,7 @@ void perf_evsel__exit(struct perf_evsel *evsel)
 	assert(list_empty(&evsel->node));
 	xyarray__delete(evsel->fd);
 	xyarray__delete(evsel->sample_id);
-	free(evsel->id);
+	xyarray__delete(evsel->id);
 }
 
 void perf_evsel__delete(struct perf_evsel *evsel)
@@ -806,6 +833,56 @@ static int get_group_fd(struct perf_evsel *evsel, int cpu, int thread)
 	return fd;
 }
 
+void perf_evsel__close_thread(struct perf_evsel *evsel, int cpu_nr, int tidx)
+{
+	int cpu;
+
+	for (cpu = 0; cpu < cpu_nr; cpu++)
+		if (FD(evsel, cpu, tidx) >= 0)
+			close(FD(evsel, cpu, tidx));
+
+	xyarray__remove(evsel->fd, tidx);
+}
+
+int perf_evsel__open_thread(struct perf_evsel *evsel, struct cpu_map *cpus,
+			     struct thread_map *threads, int tidx)
+{
+	int tid = thread_map__get_pid(threads, tidx);
+	int cpu;
+	int pid = -1;
+	unsigned long flags = 0;
+	int err;
+
+	if (perf_evsel__append_fd_thread(evsel, tidx) < 0)
+		return 1;
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
+		group_fd = get_group_fd(evsel, cpu, tidx);
+		FD(evsel, cpu, tidx) = sys_perf_event_open(&evsel->attr,
+							   pid,
+							   cpus->map[cpu],
+							   group_fd, flags);
+		if (FD(evsel, cpu, tidx) < 0) {
+			printf("error: cannot open counter for: %d\n", tid);
+			err = -errno;
+			printf("errno: %d\n", errno);
+			return err;
+		}
+	}
+
+	return 0;
+}
+
 static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
 			      struct thread_map *threads)
 {
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 52021c3..37b56ba 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -51,7 +51,7 @@ struct perf_evsel {
 	char			*filter;
 	struct xyarray		*fd;
 	struct xyarray		*sample_id;
-	u64			*id;
+	struct xyarray          *id;
 	struct perf_counts	*counts;
 	struct perf_counts	*prev_raw_counts;
 	int			idx;
@@ -271,6 +271,12 @@ static inline int perf_evsel__group_idx(struct perf_evsel *evsel)
 	return evsel->idx - evsel->leader->idx;
 }
 
+int perf_evsel__append_id_thread(struct perf_evsel *evsel, int tidx);
+int perf_evsel__append_fd_thread(struct perf_evsel *evsel, int tidx);
+void perf_evsel__close_thread(struct perf_evsel *evsel, int cpu_nr, int tidx);
+int perf_evsel__open_thread(struct perf_evsel *evsel, struct cpu_map *cpus,
+			    struct thread_map *threads, int tidx);
+
 #define for_each_group_member(_evsel, _leader) 					\
 for ((_evsel) = list_entry((_leader)->node.next, struct perf_evsel, node); 	\
      (_evsel) && (_evsel)->leader == (_leader);					\
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index f4bfd79..51a52d4 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -25,6 +25,8 @@
 #include "strbuf.h"
 #include "build-id.h"
 
+#define ID(e, y) (*(u64 *)xyarray__entry(e->id, 0, y))
+
 static bool no_buildid_cache = false;
 
 static int trace_event_count;
@@ -1260,7 +1262,6 @@ static struct perf_evsel *
 read_event_desc(struct perf_header *ph, int fd)
 {
 	struct perf_evsel *evsel, *events = NULL;
-	u64 *id;
 	void *buf = NULL;
 	u32 nre, sz, nr, i, j;
 	ssize_t ret;
@@ -1325,19 +1326,17 @@ read_event_desc(struct perf_header *ph, int fd)
 		if (!nr)
 			continue;
 
-		id = calloc(nr, sizeof(*id));
-		if (!id)
-			goto error;
 		evsel->ids = nr;
-		evsel->id = id;
+		evsel->id = xyarray__new(1, nr, sizeof(u64));
+		if (!evsel->id)
+			goto error;
 
 		for (j = 0 ; j < nr; j++) {
-			ret = readn(fd, id, sizeof(*id));
-			if (ret != (ssize_t)sizeof(*id))
+			ret = readn(fd, &ID(evsel, j), sizeof(u64));
+			if (ret != (ssize_t)sizeof(u64))
 				goto error;
 			if (ph->needs_swap)
-				*id = bswap_64(*id);
-			id++;
+				ID(evsel, j) = bswap_64(ID(evsel, j));
 		}
 	}
 out:
@@ -1355,7 +1354,6 @@ static void print_event_desc(struct perf_header *ph, int fd, FILE *fp)
 {
 	struct perf_evsel *evsel, *events = read_event_desc(ph, fd);
 	u32 j;
-	u64 *id;
 
 	if (!events) {
 		fprintf(fp, "# event desc: not available or unable to read\n");
@@ -1384,10 +1382,10 @@ static void print_event_desc(struct perf_header *ph, int fd, FILE *fp)
 
 		if (evsel->ids) {
 			fprintf(fp, ", id = {");
-			for (j = 0, id = evsel->id; j < evsel->ids; j++, id++) {
+			for (j = 0; j < evsel->ids; j++) {
 				if (j)
 					fputc(',', fp);
-				fprintf(fp, " %"PRIu64, *id);
+				fprintf(fp, " %"PRIu64, ID(evsel, j));
 			}
 			fprintf(fp, " }");
 		}
@@ -2880,12 +2878,14 @@ out_delete_evlist:
 }
 
 int perf_event__synthesize_attr(struct perf_tool *tool,
-				struct perf_event_attr *attr, u32 ids, u64 *id,
+				struct perf_event_attr *attr, u32 ids,
+				struct perf_evsel *evsel,
 				perf_event__handler_t process)
 {
 	union perf_event *ev;
 	size_t size;
 	int err;
+	u32 i;
 
 	size = sizeof(struct perf_event_attr);
 	size = PERF_ALIGN(size, sizeof(u64));
@@ -2898,7 +2898,8 @@ int perf_event__synthesize_attr(struct perf_tool *tool,
 		return -ENOMEM;
 
 	ev->attr.attr = *attr;
-	memcpy(ev->attr.id, id, ids * sizeof(u64));
+	for (i = 0; i < ids; i++)
+		ev->attr.id[i] = ID(evsel, i);
 
 	ev->attr.header.type = PERF_RECORD_HEADER_ATTR;
 	ev->attr.header.size = (u16)size;
@@ -2922,7 +2923,7 @@ int perf_event__synthesize_attrs(struct perf_tool *tool,
 
 	list_for_each_entry(evsel, &session->evlist->entries, node) {
 		err = perf_event__synthesize_attr(tool, &evsel->attr, evsel->ids,
-						  evsel->id, process);
+						  evsel, process);
 		if (err) {
 			pr_debug("failed to create perf header attribute\n");
 			return err;
diff --git a/tools/perf/util/header.h b/tools/perf/util/header.h
index c9fc55c..1852816 100644
--- a/tools/perf/util/header.h
+++ b/tools/perf/util/header.h
@@ -126,7 +126,8 @@ int build_id_cache__add_s(const char *sbuild_id, const char *debugdir,
 int build_id_cache__remove_s(const char *sbuild_id, const char *debugdir);
 
 int perf_event__synthesize_attr(struct perf_tool *tool,
-				struct perf_event_attr *attr, u32 ids, u64 *id,
+				struct perf_event_attr *attr, u32 ids,
+				struct perf_evsel *evsel,
 				perf_event__handler_t process);
 int perf_event__synthesize_attrs(struct perf_tool *tool,
 				 struct perf_session *session,
-- 
1.7.9.5

