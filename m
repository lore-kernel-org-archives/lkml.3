Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891AbbA2IUw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 03:20:52 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:51100 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631AbbA2IKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 03:10:03 -0500
X-Original-SENDERIP: 10.177.220.203
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 10/42] perf tools: Create separate mmap for dummy tracking event
Date: Thu, 29 Jan 2015 17:06:51 +0900
Message-Id: <1422518843-25818-11-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1422518843-25818-1-git-send-email-namhyung@kernel.org>
References: <1422518843-25818-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When indexed data file support is enabled, a dummy tracking event will
be used to track metadata (like task, comm and mmap events) for a
session and actual samples will be recorded in separate (intermediate)
files and then merged (with index table).

Provide separate mmap to the dummy tracking event.  The size is fixed
to 128KiB (+ 1 page) as the event rate will be lower than samples.  I
originally wanted to use a single mmap for this but cross-cpu sharing
is prohibited so it's per-cpu (or per-task) like normal mmaps.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-record.c |   9 +++-
 tools/perf/util/evlist.c    | 122 +++++++++++++++++++++++++++++++++++---------
 tools/perf/util/evlist.h    |  11 +++-
 3 files changed, 117 insertions(+), 25 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 404ab3434052..adb3eefb51ed 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -69,7 +69,7 @@ static int process_synthesized_event(struct perf_tool *tool,
 
 static int record__mmap_read(struct record *rec, int idx)
 {
-	struct perf_mmap *md = &rec->evlist->mmap[idx];
+	struct perf_mmap *md = perf_evlist__mmap_desc(rec->evlist, idx);
 	unsigned int head = perf_mmap__read_head(md);
 	unsigned int old = md->prev;
 	unsigned char *data = md->base + page_size;
@@ -105,6 +105,7 @@ static int record__mmap_read(struct record *rec, int idx)
 	}
 
 	md->prev = old;
+
 	perf_evlist__mmap_consume(rec->evlist, idx);
 out:
 	return rc;
@@ -275,6 +276,12 @@ static int record__mmap_read_all(struct record *rec)
 				goto out;
 			}
 		}
+		if (rec->evlist->track_mmap) {
+			if (record__mmap_read(rec, track_mmap_idx(i)) != 0) {
+				rc = -1;
+				goto out;
+			}
+		}
 	}
 
 	/*
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 2d81b4d154f4..ac31edecffaf 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -29,6 +29,7 @@
 
 static void perf_evlist__mmap_put(struct perf_evlist *evlist, int idx);
 static void __perf_evlist__munmap(struct perf_evlist *evlist, int idx);
+static void __perf_evlist__munmap_track(struct perf_evlist *evlist, int idx);
 
 #define FD(e, x, y) (*(int *)xyarray__entry(e->fd, x, y))
 #define SID(e, x, y) xyarray__entry(e->sample_id, x, y)
@@ -729,22 +730,39 @@ static bool perf_mmap__empty(struct perf_mmap *md)
 	return perf_mmap__read_head(md) != md->prev;
 }
 
+struct perf_mmap *perf_evlist__mmap_desc(struct perf_evlist *evlist, int idx)
+{
+	if (idx >= 0)
+		return &evlist->mmap[idx];
+	else
+		return &evlist->track_mmap[track_mmap_idx(idx)];
+}
+
 static void perf_evlist__mmap_get(struct perf_evlist *evlist, int idx)
 {
-	++evlist->mmap[idx].refcnt;
+	struct perf_mmap *md = perf_evlist__mmap_desc(evlist, idx);
+
+	++md->refcnt;
 }
 
 static void perf_evlist__mmap_put(struct perf_evlist *evlist, int idx)
 {
-	BUG_ON(evlist->mmap[idx].refcnt == 0);
+	struct perf_mmap *md = perf_evlist__mmap_desc(evlist, idx);
+
+	BUG_ON(md->refcnt == 0);
+
+	if (--md->refcnt != 0)
+		return;
 
-	if (--evlist->mmap[idx].refcnt == 0)
+	if (idx >= 0)
 		__perf_evlist__munmap(evlist, idx);
+	else
+		__perf_evlist__munmap_track(evlist, track_mmap_idx(idx));
 }
 
 void perf_evlist__mmap_consume(struct perf_evlist *evlist, int idx)
 {
-	struct perf_mmap *md = &evlist->mmap[idx];
+	struct perf_mmap *md = perf_evlist__mmap_desc(evlist, idx);
 
 	if (!evlist->overwrite) {
 		unsigned int old = md->prev;
@@ -765,6 +783,15 @@ static void __perf_evlist__munmap(struct perf_evlist *evlist, int idx)
 	}
 }
 
+static void __perf_evlist__munmap_track(struct perf_evlist *evlist, int idx)
+{
+	if (evlist->track_mmap[idx].base != NULL) {
+		munmap(evlist->track_mmap[idx].base, TRACK_MMAP_SIZE);
+		evlist->track_mmap[idx].base = NULL;
+		evlist->track_mmap[idx].refcnt = 0;
+	}
+}
+
 void perf_evlist__munmap(struct perf_evlist *evlist)
 {
 	int i;
@@ -776,23 +803,43 @@ void perf_evlist__munmap(struct perf_evlist *evlist)
 		__perf_evlist__munmap(evlist, i);
 
 	zfree(&evlist->mmap);
+
+	if (evlist->track_mmap == NULL)
+		return;
+
+	for (i = 0; i < evlist->nr_mmaps; i++)
+		__perf_evlist__munmap_track(evlist, i);
+
+	zfree(&evlist->track_mmap);
 }
 
-static int perf_evlist__alloc_mmap(struct perf_evlist *evlist)
+static int perf_evlist__alloc_mmap(struct perf_evlist *evlist, bool track_mmap)
 {
 	evlist->nr_mmaps = cpu_map__nr(evlist->cpus);
 	if (cpu_map__empty(evlist->cpus))
 		evlist->nr_mmaps = thread_map__nr(evlist->threads);
 	evlist->mmap = zalloc(evlist->nr_mmaps * sizeof(struct perf_mmap));
-	return evlist->mmap != NULL ? 0 : -ENOMEM;
+	if (evlist->mmap == NULL)
+		return -ENOMEM;
+
+	if (track_mmap) {
+		evlist->track_mmap = calloc(evlist->nr_mmaps,
+					    sizeof(struct perf_mmap));
+		if (evlist->track_mmap == NULL) {
+			zfree(&evlist->mmap);
+			return -ENOMEM;
+		}
+	}
+	return 0;
 }
 
 struct mmap_params {
-	int prot;
-	int mask;
+	int	prot;
+	size_t	len;
 };
 
-static int __perf_evlist__mmap(struct perf_evlist *evlist, int idx,
+static int __perf_evlist__mmap(struct perf_evlist *evlist __maybe_unused,
+			       struct perf_mmap *pmmap,
 			       struct mmap_params *mp, int fd)
 {
 	/*
@@ -808,15 +855,14 @@ static int __perf_evlist__mmap(struct perf_evlist *evlist, int idx,
 	 * evlist layer can't just drop it when filtering events in
 	 * perf_evlist__filter_pollfd().
 	 */
-	evlist->mmap[idx].refcnt = 2;
-	evlist->mmap[idx].prev = 0;
-	evlist->mmap[idx].mask = mp->mask;
-	evlist->mmap[idx].base = mmap(NULL, evlist->mmap_len, mp->prot,
-				      MAP_SHARED, fd, 0);
-	if (evlist->mmap[idx].base == MAP_FAILED) {
+	pmmap->refcnt = 2;
+	pmmap->prev = 0;
+	pmmap->mask = mp->len - page_size - 1;
+	pmmap->base = mmap(NULL, mp->len, mp->prot, MAP_SHARED, fd, 0);
+	if (pmmap->base == MAP_FAILED) {
 		pr_debug2("failed to mmap perf event ring buffer, error %d\n",
 			  errno);
-		evlist->mmap[idx].base = NULL;
+		pmmap->base = NULL;
 		return -1;
 	}
 
@@ -825,7 +871,8 @@ static int __perf_evlist__mmap(struct perf_evlist *evlist, int idx,
 
 static int perf_evlist__mmap_per_evsel(struct perf_evlist *evlist, int idx,
 				       struct mmap_params *mp, int cpu,
-				       int thread, int *output)
+				       int thread, int *output,
+				       int *track_output)
 {
 	struct perf_evsel *evsel;
 
@@ -837,9 +884,30 @@ static int perf_evlist__mmap_per_evsel(struct perf_evlist *evlist, int idx,
 
 		fd = FD(evsel, cpu, thread);
 
-		if (*output == -1) {
+		if (perf_evsel__is_dummy_tracking(evsel)) {
+			struct mmap_params track_mp = {
+				.prot	= mp->prot,
+				.len	= TRACK_MMAP_SIZE,
+			};
+
+			if (*track_output == -1) {
+				*track_output = fd;
+				if (__perf_evlist__mmap(evlist,
+							&evlist->track_mmap[idx],
+							&track_mp, fd) < 0)
+					return -1;
+			} else {
+				if (ioctl(fd, PERF_EVENT_IOC_SET_OUTPUT,
+					  *track_output) != 0)
+					return -1;
+			}
+
+			/* mark idx as track mmap idx (negative) */
+			idx = track_mmap_idx(idx);
+		} else if (*output == -1) {
 			*output = fd;
-			if (__perf_evlist__mmap(evlist, idx, mp, *output) < 0)
+			if (__perf_evlist__mmap(evlist, &evlist->mmap[idx],
+						mp, *output) < 0)
 				return -1;
 		} else {
 			if (ioctl(fd, PERF_EVENT_IOC_SET_OUTPUT, *output) != 0)
@@ -868,6 +936,11 @@ static int perf_evlist__mmap_per_evsel(struct perf_evlist *evlist, int idx,
 			perf_evlist__set_sid_idx(evlist, evsel, idx, cpu,
 						 thread);
 		}
+
+		if (perf_evsel__is_dummy_tracking(evsel)) {
+			/* restore idx as normal idx (positive) */
+			idx = track_mmap_idx(idx);
+		}
 	}
 
 	return 0;
@@ -883,10 +956,12 @@ static int perf_evlist__mmap_per_cpu(struct perf_evlist *evlist,
 	pr_debug2("perf event ring buffer mmapped per cpu\n");
 	for (cpu = 0; cpu < nr_cpus; cpu++) {
 		int output = -1;
+		int track_output = -1;
 
 		for (thread = 0; thread < nr_threads; thread++) {
 			if (perf_evlist__mmap_per_evsel(evlist, cpu, mp, cpu,
-							thread, &output))
+							thread, &output,
+							&track_output))
 				goto out_unmap;
 		}
 	}
@@ -908,9 +983,10 @@ static int perf_evlist__mmap_per_thread(struct perf_evlist *evlist,
 	pr_debug2("perf event ring buffer mmapped per thread\n");
 	for (thread = 0; thread < nr_threads; thread++) {
 		int output = -1;
+		int track_output = -1;
 
 		if (perf_evlist__mmap_per_evsel(evlist, thread, mp, 0, thread,
-						&output))
+						&output, &track_output))
 			goto out_unmap;
 	}
 
@@ -1033,7 +1109,7 @@ int perf_evlist__mmap(struct perf_evlist *evlist, unsigned int pages,
 		.prot = PROT_READ | (overwrite ? 0 : PROT_WRITE),
 	};
 
-	if (evlist->mmap == NULL && perf_evlist__alloc_mmap(evlist) < 0)
+	if (evlist->mmap == NULL && perf_evlist__alloc_mmap(evlist, true) < 0)
 		return -ENOMEM;
 
 	if (evlist->pollfd.entries == NULL && perf_evlist__alloc_pollfd(evlist) < 0)
@@ -1042,7 +1118,7 @@ int perf_evlist__mmap(struct perf_evlist *evlist, unsigned int pages,
 	evlist->overwrite = overwrite;
 	evlist->mmap_len = perf_evlist__mmap_size(pages);
 	pr_debug("mmap size %zuB\n", evlist->mmap_len);
-	mp.mask = evlist->mmap_len - page_size - 1;
+	mp.len = evlist->mmap_len;
 
 	evlist__for_each(evlist, evsel) {
 		if ((evsel->attr.read_format & PERF_FORMAT_ID) &&
diff --git a/tools/perf/util/evlist.h b/tools/perf/util/evlist.h
index 771175e70d2f..bf697632458d 100644
--- a/tools/perf/util/evlist.h
+++ b/tools/perf/util/evlist.h
@@ -48,11 +48,14 @@ struct perf_evlist {
 	bool		 overwrite;
 	struct fdarray	 pollfd;
 	struct perf_mmap *mmap;
+	struct perf_mmap *track_mmap;
 	struct thread_map *threads;
 	struct cpu_map	  *cpus;
 	struct perf_evsel *selected;
 };
 
+#define TRACK_MMAP_SIZE  (((128 * 1024 / page_size) + 1) * page_size)
+
 struct perf_evsel_str_handler {
 	const char *name;
 	void	   *handler;
@@ -100,8 +103,8 @@ struct perf_evsel *perf_evlist__id2evsel(struct perf_evlist *evlist, u64 id);
 struct perf_sample_id *perf_evlist__id2sid(struct perf_evlist *evlist, u64 id);
 
 union perf_event *perf_evlist__mmap_read(struct perf_evlist *evlist, int idx);
-
 void perf_evlist__mmap_consume(struct perf_evlist *evlist, int idx);
+struct perf_mmap *perf_evlist__mmap_desc(struct perf_evlist *evlist, int idx);
 
 int perf_evlist__open(struct perf_evlist *evlist);
 void perf_evlist__close(struct perf_evlist *evlist);
@@ -211,6 +214,12 @@ bool perf_evlist__can_select_event(struct perf_evlist *evlist, const char *str);
 void perf_evlist__to_front(struct perf_evlist *evlist,
 			   struct perf_evsel *move_evsel);
 
+/* convert from/to negative idx for track mmaps */
+static inline int track_mmap_idx(int idx)
+{
+	return -idx - 1;
+}
+
 /**
  * __evlist__for_each - iterate thru all the evsels
  * @list: list_head instance to iterate
-- 
2.2.2

