Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196Ab3CMJn7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 05:43:59 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:61663 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755506Ab3CMJn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 05:43:56 -0400
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
Subject: [PATCH v3 3/8]Perf: Transform evlist->mmap to xyarray
Date: Wed, 13 Mar 2013 17:42:17 +0800
Message-Id: <1363167740-27735-6-git-send-email-chenggang.qin@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1363167740-27735-1-git-send-email-chenggang.qin@gmail.com>
References: <1363167740-27735-1-git-send-email-chenggang.qin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: chenggang <chenggang.qcg@taobao.com>

Transformed evlist->mmap to xyarray. Then the evlist->mmap is transformed
to a linked list too.

1) perf_evlist__mmap_thread()
   mmap a new fd for a new thread forked on-the-fly.
2) void perf_evlist__munmap_thread()
   munmap a fd for a exited thread on-the-fly.
3) perf_evlist__get_mmap()
   get a perf_mmap struct in the evlist->mmap list by its index.
4) for_each_mmap(md, evlist)
   traverse all perf_mmap structures in the evlist->mmap list.

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
 tools/perf/Makefile         |    3 ++-
 tools/perf/builtin-record.c |    8 +++----
 tools/perf/util/evlist.c    |   49 ++++++++++++++++++++++++++-----------------
 tools/perf/util/evlist.h    |    8 ++++++-
 4 files changed, 43 insertions(+), 25 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index a2108ca..7f3f066 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -209,7 +209,8 @@ BASIC_CFLAGS = \
 	-Iutil \
 	-I. \
 	-I$(TRACE_EVENT_DIR) \
-	-D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE
+	-D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -D_GNU_SOURCE \
+	-std=gnu99
 
 BASIC_LDFLAGS =
 
diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 774c907..3bca0b2 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -363,12 +363,12 @@ static struct perf_event_header finished_round_event = {
 
 static int perf_record__mmap_read_all(struct perf_record *rec)
 {
-	int i;
 	int rc = 0;
+	struct perf_mmap *pmmap = NULL;
 
-	for (i = 0; i < rec->evlist->nr_mmaps; i++) {
-		if (rec->evlist->mmap[i].base) {
-			if (perf_record__mmap_read(rec, &rec->evlist->mmap[i]) != 0) {
+	for_each_mmap(pmmap, rec->evlist) {
+		if (pmmap->base) {
+			if (perf_record__mmap_read(rec, pmmap) != 0) {
 				rc = -1;
 				goto out;
 			}
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index d5063d6..7515651 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -336,7 +336,7 @@ struct perf_evsel *perf_evlist__id2evsel(struct perf_evlist *evlist, u64 id)
 
 union perf_event *perf_evlist__mmap_read(struct perf_evlist *evlist, int idx)
 {
-	struct perf_mmap *md = &evlist->mmap[idx];
+	struct perf_mmap *md = perf_evlist__get_mmap(evlist, idx);
 	unsigned int head = perf_mmap__read_head(md);
 	unsigned int old = md->prev;
 	unsigned char *data = md->base + page_size;
@@ -401,16 +401,16 @@ union perf_event *perf_evlist__mmap_read(struct perf_evlist *evlist, int idx)
 
 void perf_evlist__munmap(struct perf_evlist *evlist)
 {
-	int i;
+	struct perf_mmap *pmmap = NULL;
 
-	for (i = 0; i < evlist->nr_mmaps; i++) {
-		if (evlist->mmap[i].base != NULL) {
-			munmap(evlist->mmap[i].base, evlist->mmap_len);
-			evlist->mmap[i].base = NULL;
+	for_each_mmap(pmmap, evlist) {
+		if (pmmap->base != NULL) {
+			munmap(pmmap->base, evlist->mmap_len);
+			pmmap->base = NULL;
 		}
 	}
 
-	free(evlist->mmap);
+	xyarray__delete(evlist->mmap);
 	evlist->mmap = NULL;
 }
 
@@ -419,19 +419,21 @@ static int perf_evlist__alloc_mmap(struct perf_evlist *evlist)
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
+	struct perf_mmap *pmmap = perf_evlist__get_mmap(evlist, idx);
+
+	pmmap->prev = 0;
+	pmmap->mask = mask;
+	pmmap->base = mmap(NULL, evlist->mmap_len, prot,
 				      MAP_SHARED, fd, 0);
-	if (evlist->mmap[idx].base == MAP_FAILED) {
-		evlist->mmap[idx].base = NULL;
+	if (pmmap->base == MAP_FAILED) {
+		pmmap->base = NULL;
 		return -1;
 	}
 
@@ -472,9 +474,11 @@ static int perf_evlist__mmap_per_cpu(struct perf_evlist *evlist, int prot, int m
 
 out_unmap:
 	for (cpu = 0; cpu < evlist->cpus->nr; cpu++) {
-		if (evlist->mmap[cpu].base != NULL) {
-			munmap(evlist->mmap[cpu].base, evlist->mmap_len);
-			evlist->mmap[cpu].base = NULL;
+		struct perf_mmap *pmmap = perf_evlist__get_mmap(evlist, cpu);
+
+		if (pmmap->base != NULL) {
+			munmap(pmmap->base, evlist->mmap_len);
+			pmmap->base = NULL;
 		}
 	}
 	return -1;
@@ -511,9 +515,11 @@ static int perf_evlist__mmap_per_thread(struct perf_evlist *evlist, int prot, in
 
 out_unmap:
 	for (thread = 0; thread < evlist->threads->nr; thread++) {
-		if (evlist->mmap[thread].base != NULL) {
-			munmap(evlist->mmap[thread].base, evlist->mmap_len);
-			evlist->mmap[thread].base = NULL;
+		struct perf_mmap *pmmap = perf_evlist__get_mmap(evlist, thread);
+
+		if (pmmap->base != NULL) {
+			munmap(pmmap->base, evlist->mmap_len);
+			pmmap->base = NULL;
 		}
 	}
 	return -1;
@@ -572,6 +578,11 @@ int perf_evlist__mmap(struct perf_evlist *evlist, unsigned int pages,
 	return perf_evlist__mmap_per_cpu(evlist, prot, mask);
 }
 
+struct perf_mmap *perf_evlist__get_mmap(struct perf_evlist *evlist, int idx) 
+{
+	return (struct perf_mmap *)xyarray__entry(evlist->mmap, 0, idx);
+}
+
 int perf_evlist__create_maps(struct perf_evlist *evlist,
 			     struct perf_target *target)
 {
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 2dd07bd..eb22e49 100644
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
+	struct xyarray	 *mmap;
 	struct pollfd	 *pollfd;
 	struct thread_map *threads;
 	struct cpu_map	  *cpus;
@@ -131,6 +132,8 @@ void perf_evlist__splice_list_tail(struct perf_evlist *evlist,
 				   struct list_head *list,
 				   int nr_entries);
 
+struct perf_mmap *perf_evlist__get_mmap(struct perf_evlist *evlist, int idx);
+
 static inline struct perf_evsel *perf_evlist__first(struct perf_evlist *evlist)
 {
 	return list_entry(evlist->entries.next, struct perf_evsel, node);
@@ -163,4 +166,7 @@ static inline void perf_mmap__write_tail(struct perf_mmap *md,
 	pc->data_tail = tail;
 }
 
+#define for_each_mmap(pmmap, evlist) \
+	xyarray_for_each_content(pmmap, &evlist->mmap->rows[0].head, struct perf_mmap)
+
 #endif /* __PERF_EVLIST_H */
-- 
1.7.9.5

