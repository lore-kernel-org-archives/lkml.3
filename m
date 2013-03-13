Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756157Ab3CMJnS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 05:43:18 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:35383 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754489Ab3CMJnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 05:43:15 -0400
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
Subject: [PATCH v3 6/8]Perf: Add extend mechanism for mmap & pollfd.
Date: Wed, 13 Mar 2013 17:42:14 +0800
Message-Id: <1363167740-27735-3-git-send-email-chenggang.qin@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1363167740-27735-1-git-send-email-chenggang.qin@gmail.com>
References: <1363167740-27735-1-git-send-email-chenggang.qin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: chenggang <chenggang.qcg@taobao.com>

Add extend mechanism for mmap & pollfd. Then we can adjust them while threads
are forked or exited.

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
 tools/perf/util/evlist.c |  151 +++++++++++++++++++++++++++++++++++++++++++++-
 tools/perf/util/evlist.h |    3 +
 tools/perf/util/evsel.c  |    7 ++-
 3 files changed, 156 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index c1cd8f9..74af9bb 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -85,7 +85,7 @@ static void perf_evlist__purge(struct perf_evlist *evlist)
 
 void perf_evlist__exit(struct perf_evlist *evlist)
 {
-	free(evlist->mmap);
+	xyarray__delete(evlist->mmap);
 	free(evlist->pollfd);
 	evlist->mmap = NULL;
 	evlist->pollfd = NULL;
@@ -256,6 +256,32 @@ void perf_evlist__enable(struct perf_evlist *evlist)
 	}
 }
 
+/*
+ * If threads->nr > 1, the cpu_map__nr() must be 1.
+ * If the cpu_map__nr() > 1, we should not append pollfd.
+ */
+static int perf_evlist__extend_pollfd(struct perf_evlist *evlist)
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
@@ -416,6 +442,20 @@ void perf_evlist__munmap(struct perf_evlist *evlist)
 	evlist->mmap = NULL;
 }
 
+static struct perf_mmap * perf_evlist__extend_mmap(struct perf_evlist *evlist)
+{
+	struct perf_mmap **new_mmap = NULL;
+
+	new_mmap = (struct perf_mmap **)xyarray__append(evlist->mmap, NULL);
+
+	if (new_mmap != NULL) {
+		evlist->nr_mmaps++;
+		return *new_mmap;
+	}
+
+	return NULL;
+}
+
 static int perf_evlist__alloc_mmap(struct perf_evlist *evlist)
 {
 	evlist->nr_mmaps = cpu_map__nr(evlist->cpus);
@@ -433,7 +473,7 @@ static int __perf_evlist__mmap(struct perf_evlist *evlist,
 	pmmap->prev = 0;
 	pmmap->mask = mask;
 	pmmap->base = mmap(NULL, evlist->mmap_len, prot,
-				      MAP_SHARED, fd, 0);
+			   MAP_SHARED, fd, 0);
 	if (pmmap->base == MAP_FAILED) {
 		pmmap->base = NULL;
 		return -1;
@@ -527,6 +567,111 @@ out_unmap:
 	return -1;
 }
 
+int perf_evlist__mmap_thread(struct perf_evlist *evlist, bool overwrite)
+{
+	struct perf_evsel *evsel;
+	int prot = PROT_READ | (overwrite ? 0 : PROT_WRITE);
+	int mask = evlist->mmap_len - page_size -1;
+	int output = -1;
+	struct pollfd *old_pollfd = evlist->pollfd;
+	struct perf_mmap *pmmap;
+
+	if (!cpu_map__all(evlist->cpus))
+		return 1;
+
+	if ((pmmap = perf_evlist__extend_mmap(evlist)) == NULL)
+		return -ENOMEM;
+
+	if (perf_evlist__extend_pollfd(evlist) < 0)
+		goto free_append_mmap;
+
+	list_for_each_entry(evsel, &evlist->entries, node) {
+		if (evsel->attr.read_format & PERF_FORMAT_ID) {
+			if (perf_evsel__extend_id(evsel) < 0)
+				goto free_append_pollfd;
+		}
+	}
+
+	list_for_each_entry(evsel, &evlist->entries, node) {
+		int fd = FD(evsel, 0, -1);
+
+		if (output == -1) {
+			output = fd;
+
+			pmmap->prev = 0;
+			pmmap->mask = mask;
+			pmmap->base = mmap(NULL, evlist->mmap_len, prot,
+					   MAP_SHARED, fd, 0);
+
+			if (pmmap->base == MAP_FAILED) {
+				pmmap->base = NULL;
+				goto out_unmap;
+			}
+			perf_evlist__add_pollfd(evlist, fd);
+		} else {
+			if (ioctl(fd, PERF_EVENT_IOC_SET_OUTPUT, output) != 0)
+				goto out_unmap;
+		}
+		if ((evsel->attr.read_format & PERF_FORMAT_ID) &&
+		    perf_evlist__id_add_fd(evlist, evsel, 0, -1, fd) < 0)
+			goto out_unmap;
+	}
+
+	free(old_pollfd);
+	return 0;
+out_unmap:
+	pmmap = perf_evlist__get_mmap(evlist, -1);
+
+	if (pmmap->base != NULL) {
+		munmap(pmmap->base, evlist->mmap_len);
+		pmmap->base = NULL;
+	}
+
+	list_for_each_entry(evsel, &evlist->entries, node) {
+		xyarray__remove(evsel->id, -1);
+		xyarray__remove(evsel->sample_id, -1);
+	}
+
+free_append_pollfd:
+	free(evlist->pollfd);
+	evlist->pollfd = old_pollfd;
+
+free_append_mmap:
+	xyarray__remove(evlist->mmap, -1);
+	return -1;
+}
+
+void perf_evlist__munmap_thread(struct perf_evlist *evlist, int tidx)
+{
+	struct perf_evsel *evsel;
+	struct pollfd *pfd;
+	struct perf_mmap *pmmap = perf_evlist__get_mmap(evlist, tidx);
+	int old_nfds = evlist->threads->nr * evlist->nr_entries;
+	int new_nfds = (evlist->threads->nr -1 ) * evlist->nr_entries;
+
+	if (pmmap->base != NULL) {
+		munmap(pmmap->base, evlist->mmap_len);
+		evlist->nr_mmaps--;
+		pmmap->base = NULL;
+		xyarray__remove(evlist->mmap, tidx);
+	}
+
+	list_for_each_entry(evsel, &evlist->entries, node) {
+		perf_evsel__remove_id(evsel, tidx);
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
@@ -580,7 +725,7 @@ int perf_evlist__mmap(struct perf_evlist *evlist, unsigned int pages,
 	return perf_evlist__mmap_per_cpu(evlist, prot, mask);
 }
 
-struct perf_mmap *perf_evlist__get_mmap(struct perf_evlist *evlist, int idx) 
+struct perf_mmap *perf_evlist__get_mmap(struct perf_evlist *evlist, int idx)
 {
 	return (struct perf_mmap *)xyarray__entry(evlist->mmap, 0, idx);
 }
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index eb22e49..8693c11 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -96,6 +96,9 @@ int perf_evlist__mmap(struct perf_evlist *evlist, unsigned int pages,
 		      bool overwrite);
 void perf_evlist__munmap(struct perf_evlist *evlist);
 
+int perf_evlist__mmap_thread(struct perf_evlist *evlist, bool overwrite);
+void perf_evlist__munmap_thread(struct perf_evlist *evlist, int tidx);
+
 void perf_evlist__disable(struct perf_evlist *evlist);
 void perf_evlist__enable(struct perf_evlist *evlist);
 
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 2eb75f9..5671ee9 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -720,7 +720,7 @@ void perf_evsel__exit(struct perf_evsel *evsel)
 	assert(list_empty(&evsel->node));
 	xyarray__delete(evsel->fd);
 	xyarray__delete(evsel->sample_id);
-	free(evsel->id);
+	xyarray__delete(evsel->id);
 }
 
 void perf_evsel__delete(struct perf_evsel *evsel)
@@ -845,7 +845,10 @@ static int get_group_fd(struct perf_evsel *evsel, int cpu, int thread)
 	 */
 	BUG_ON(!leader->fd);
 
-	fd = FD(leader, cpu, thread);
+	if (thread == -1)
+		fd = *(int *)xyarray__entry(leader->fd, cpu, -1);
+	else
+		fd = FD(leader, cpu, thread);
 	BUG_ON(fd == -1);
 
 	return fd;
-- 
1.7.9.5

