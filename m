Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961Ab3CKHoe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 03:44:34 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:42341 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab3CKHn0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 03:43:26 -0400
X-AuditID: 9c930179-b7c78ae000000e4b-76-513d8b1b453e
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, David Ahern <dsahern@gmail.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 3/7] perf evlist: Add thread_map__nr() helper
Date: Mon, 11 Mar 2013 16:43:14 +0900
Message-Id: <1362987798-24969-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1362987798-24969-1-git-send-email-namhyung@kernel.org>
References: <1362987798-24969-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Introduce and use the thread_map__nr() function to protect a possible
NULL pointer dereference and cleanup the code a bit.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-stat.c    |  4 ++--
 tools/perf/util/evlist.c     | 37 +++++++++++++++++++++++--------------
 tools/perf/util/thread_map.h |  5 +++++
 3 files changed, 30 insertions(+), 16 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 020329dca005..20ffaf98782e 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -249,7 +249,7 @@ static int read_counter_aggr(struct perf_evsel *counter)
 	int i;
 
 	if (__perf_evsel__read(counter, perf_evsel__nr_cpus(counter),
-			       evsel_list->threads->nr, scale) < 0)
+			       thread_map__nr(evsel_list->threads), scale) < 0)
 		return -1;
 
 	for (i = 0; i < 3; i++)
@@ -488,7 +488,7 @@ static int __run_perf_stat(int argc __maybe_unused, const char **argv)
 		list_for_each_entry(counter, &evsel_list->entries, node) {
 			read_counter_aggr(counter);
 			perf_evsel__close_fd(counter, perf_evsel__nr_cpus(counter),
-					     evsel_list->threads->nr);
+					     thread_map__nr(evsel_list->threads));
 		}
 	}
 
diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index a482547495b6..7d71a691b864 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -227,12 +227,14 @@ void perf_evlist__disable(struct perf_evlist *evlist)
 {
 	int cpu, thread;
 	struct perf_evsel *pos;
+	int nr_cpus = cpu_map__nr(evlist->cpus);
+	int nr_threads = thread_map__nr(evlist->threads);
 
-	for (cpu = 0; cpu < cpu_map__nr(evlist->cpus); cpu++) {
+	for (cpu = 0; cpu < nr_cpus; cpu++) {
 		list_for_each_entry(pos, &evlist->entries, node) {
 			if (!perf_evsel__is_group_leader(pos))
 				continue;
-			for (thread = 0; thread < evlist->threads->nr; thread++)
+			for (thread = 0; thread < nr_threads; thread++)
 				ioctl(FD(pos, cpu, thread),
 				      PERF_EVENT_IOC_DISABLE, 0);
 		}
@@ -243,12 +245,14 @@ void perf_evlist__enable(struct perf_evlist *evlist)
 {
 	int cpu, thread;
 	struct perf_evsel *pos;
+	int nr_cpus = cpu_map__nr(evlist->cpus);
+	int nr_threads = thread_map__nr(evlist->threads);
 
-	for (cpu = 0; cpu < cpu_map__nr(evlist->cpus); cpu++) {
+	for (cpu = 0; cpu < nr_cpus; cpu++) {
 		list_for_each_entry(pos, &evlist->entries, node) {
 			if (!perf_evsel__is_group_leader(pos))
 				continue;
-			for (thread = 0; thread < evlist->threads->nr; thread++)
+			for (thread = 0; thread < nr_threads; thread++)
 				ioctl(FD(pos, cpu, thread),
 				      PERF_EVENT_IOC_ENABLE, 0);
 		}
@@ -257,7 +261,9 @@ void perf_evlist__enable(struct perf_evlist *evlist)
 
 static int perf_evlist__alloc_pollfd(struct perf_evlist *evlist)
 {
-	int nfds = cpu_map__nr(evlist->cpus) * evlist->threads->nr * evlist->nr_entries;
+	int nr_cpus = cpu_map__nr(evlist->cpus);
+	int nr_threads = thread_map__nr(evlist->threads);
+	int nfds = nr_cpus * nr_threads * evlist->nr_entries;
 	evlist->pollfd = malloc(sizeof(struct pollfd) * nfds);
 	return evlist->pollfd != NULL ? 0 : -ENOMEM;
 }
@@ -417,7 +423,7 @@ static int perf_evlist__alloc_mmap(struct perf_evlist *evlist)
 {
 	evlist->nr_mmaps = cpu_map__nr(evlist->cpus);
 	if (cpu_map__all(evlist->cpus))
-		evlist->nr_mmaps = evlist->threads->nr;
+		evlist->nr_mmaps = thread_map__nr(evlist->threads);
 	evlist->mmap = zalloc(evlist->nr_mmaps * sizeof(struct perf_mmap));
 	return evlist->mmap != NULL ? 0 : -ENOMEM;
 }
@@ -442,11 +448,13 @@ static int perf_evlist__mmap_per_cpu(struct perf_evlist *evlist, int prot, int m
 {
 	struct perf_evsel *evsel;
 	int cpu, thread;
+	int nr_cpus = cpu_map__nr(evlist->cpus);
+	int nr_threads = thread_map__nr(evlist->threads);
 
-	for (cpu = 0; cpu < cpu_map__nr(evlist->cpus); cpu++) {
+	for (cpu = 0; cpu < nr_cpus; cpu++) {
 		int output = -1;
 
-		for (thread = 0; thread < evlist->threads->nr; thread++) {
+		for (thread = 0; thread < nr_threads; thread++) {
 			list_for_each_entry(evsel, &evlist->entries, node) {
 				int fd = FD(evsel, cpu, thread);
 
@@ -470,7 +478,7 @@ static int perf_evlist__mmap_per_cpu(struct perf_evlist *evlist, int prot, int m
 	return 0;
 
 out_unmap:
-	for (cpu = 0; cpu < cpu_map__nr(evlist->cpus); cpu++) {
+	for (cpu = 0; cpu < nr_cpus; cpu++) {
 		if (evlist->mmap[cpu].base != NULL) {
 			munmap(evlist->mmap[cpu].base, evlist->mmap_len);
 			evlist->mmap[cpu].base = NULL;
@@ -483,8 +491,9 @@ static int perf_evlist__mmap_per_thread(struct perf_evlist *evlist, int prot, in
 {
 	struct perf_evsel *evsel;
 	int thread;
+	int nr_threads = thread_map__nr(evlist->threads);
 
-	for (thread = 0; thread < evlist->threads->nr; thread++) {
+	for (thread = 0; thread < nr_threads; thread++) {
 		int output = -1;
 
 		list_for_each_entry(evsel, &evlist->entries, node) {
@@ -509,7 +518,7 @@ static int perf_evlist__mmap_per_thread(struct perf_evlist *evlist, int prot, in
 	return 0;
 
 out_unmap:
-	for (thread = 0; thread < evlist->threads->nr; thread++) {
+	for (thread = 0; thread < nr_threads; thread++) {
 		if (evlist->mmap[thread].base != NULL) {
 			munmap(evlist->mmap[thread].base, evlist->mmap_len);
 			evlist->mmap[thread].base = NULL;
@@ -610,7 +619,7 @@ int perf_evlist__apply_filters(struct perf_evlist *evlist)
 	struct perf_evsel *evsel;
 	int err = 0;
 	const int ncpus = cpu_map__nr(evlist->cpus),
-		  nthreads = evlist->threads->nr;
+		  nthreads = thread_map__nr(evlist->threads);
 
 	list_for_each_entry(evsel, &evlist->entries, node) {
 		if (evsel->filter == NULL)
@@ -629,7 +638,7 @@ int perf_evlist__set_filter(struct perf_evlist *evlist, const char *filter)
 	struct perf_evsel *evsel;
 	int err = 0;
 	const int ncpus = cpu_map__nr(evlist->cpus),
-		  nthreads = evlist->threads->nr;
+		  nthreads = thread_map__nr(evlist->threads);
 
 	list_for_each_entry(evsel, &evlist->entries, node) {
 		err = perf_evsel__set_filter(evsel, ncpus, nthreads, filter);
@@ -726,7 +735,7 @@ int perf_evlist__open(struct perf_evlist *evlist)
 	return 0;
 out_err:
 	ncpus = cpu_map__nr(evlist->cpus);
-	nthreads = evlist->threads ? evlist->threads->nr : 1;
+	nthreads = thread_map__nr(evlist->threads);
 
 	list_for_each_entry_reverse(evsel, &evlist->entries, node)
 		perf_evsel__close(evsel, ncpus, nthreads);
diff --git a/tools/perf/util/thread_map.h b/tools/perf/util/thread_map.h
index f718df8a3c59..0cd8b3108084 100644
--- a/tools/perf/util/thread_map.h
+++ b/tools/perf/util/thread_map.h
@@ -21,4 +21,9 @@ void thread_map__delete(struct thread_map *threads);
 
 size_t thread_map__fprintf(struct thread_map *threads, FILE *fp);
 
+static inline int thread_map__nr(struct thread_map *threads)
+{
+	return threads ? threads->nr : 1;
+}
+
 #endif	/* __PERF_THREAD_MAP_H */
-- 
1.7.11.7

