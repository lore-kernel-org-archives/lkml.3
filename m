Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754216Ab3CRQj5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 12:39:57 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:49363
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752532Ab3CRQZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 12:25:56 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, David Ahern <dsahern@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 16/54] perf evlist: Add thread_map__nr() helper
Date: Mon, 18 Mar 2013 13:25:01 -0300
Message-Id: <1363623939-10748-17-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1363623939-10748-1-git-send-email-acme@infradead.org>
References: <1363623939-10748-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

Introduce and use the thread_map__nr() function to protect a possible
NULL pointer dereference and cleanup the code a bit.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1362987798-24969-3-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-stat.c    |    4 ++--
 tools/perf/util/evlist.c     |   37 +++++++++++++++++++++++--------------
 tools/perf/util/thread_map.h |    5 +++++
 3 files changed, 30 insertions(+), 16 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 020329d..20ffaf9 100644
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
index a482547..7d71a69 100644
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
index f718df8..0cd8b31 100644
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
1.7.1

