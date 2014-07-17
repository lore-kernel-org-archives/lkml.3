Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030220AbaGQQO2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 12:14:28 -0400
Received: from mail.kernel.org ([198.145.19.201]:52461 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965328AbaGQQOY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 12:14:24 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 20/33] perf evlist: Pass mmap parameters in a struct
Date: Thu, 17 Jul 2014 13:12:22 -0300
Message-Id: <1405613555-23380-21-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405613555-23380-1-git-send-email-acme@kernel.org>
References: <1405613555-23380-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

In preparation for adding more mmap parameters, pass existing parameters
in a struct.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1405332185-4050-29-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c | 46 ++++++++++++++++++++++++++--------------------
 1 file changed, 26 insertions(+), 20 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index c51223ac25f4..814e954c1318 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -606,12 +606,17 @@ static int perf_evlist__alloc_mmap(struct perf_evlist *evlist)
 	return evlist->mmap != NULL ? 0 : -ENOMEM;
 }
 
-static int __perf_evlist__mmap(struct perf_evlist *evlist,
-			       int idx, int prot, int mask, int fd)
+struct mmap_params {
+	int prot;
+	int mask;
+};
+
+static int __perf_evlist__mmap(struct perf_evlist *evlist, int idx,
+			       struct mmap_params *mp, int fd)
 {
 	evlist->mmap[idx].prev = 0;
-	evlist->mmap[idx].mask = mask;
-	evlist->mmap[idx].base = mmap(NULL, evlist->mmap_len, prot,
+	evlist->mmap[idx].mask = mp->mask;
+	evlist->mmap[idx].base = mmap(NULL, evlist->mmap_len, mp->prot,
 				      MAP_SHARED, fd, 0);
 	if (evlist->mmap[idx].base == MAP_FAILED) {
 		pr_debug2("failed to mmap perf event ring buffer, error %d\n",
@@ -625,8 +630,8 @@ static int __perf_evlist__mmap(struct perf_evlist *evlist,
 }
 
 static int perf_evlist__mmap_per_evsel(struct perf_evlist *evlist, int idx,
-				       int prot, int mask, int cpu, int thread,
-				       int *output)
+				       struct mmap_params *mp, int cpu,
+				       int thread, int *output)
 {
 	struct perf_evsel *evsel;
 
@@ -635,8 +640,7 @@ static int perf_evlist__mmap_per_evsel(struct perf_evlist *evlist, int idx,
 
 		if (*output == -1) {
 			*output = fd;
-			if (__perf_evlist__mmap(evlist, idx, prot, mask,
-						*output) < 0)
+			if (__perf_evlist__mmap(evlist, idx, mp, *output) < 0)
 				return -1;
 		} else {
 			if (ioctl(fd, PERF_EVENT_IOC_SET_OUTPUT, *output) != 0)
@@ -651,8 +655,8 @@ static int perf_evlist__mmap_per_evsel(struct perf_evlist *evlist, int idx,
 	return 0;
 }
 
-static int perf_evlist__mmap_per_cpu(struct perf_evlist *evlist, int prot,
-				     int mask)
+static int perf_evlist__mmap_per_cpu(struct perf_evlist *evlist,
+				     struct mmap_params *mp)
 {
 	int cpu, thread;
 	int nr_cpus = cpu_map__nr(evlist->cpus);
@@ -663,8 +667,8 @@ static int perf_evlist__mmap_per_cpu(struct perf_evlist *evlist, int prot,
 		int output = -1;
 
 		for (thread = 0; thread < nr_threads; thread++) {
-			if (perf_evlist__mmap_per_evsel(evlist, cpu, prot, mask,
-							cpu, thread, &output))
+			if (perf_evlist__mmap_per_evsel(evlist, cpu, mp, cpu,
+							thread, &output))
 				goto out_unmap;
 		}
 	}
@@ -677,8 +681,8 @@ out_unmap:
 	return -1;
 }
 
-static int perf_evlist__mmap_per_thread(struct perf_evlist *evlist, int prot,
-					int mask)
+static int perf_evlist__mmap_per_thread(struct perf_evlist *evlist,
+					struct mmap_params *mp)
 {
 	int thread;
 	int nr_threads = thread_map__nr(evlist->threads);
@@ -687,8 +691,8 @@ static int perf_evlist__mmap_per_thread(struct perf_evlist *evlist, int prot,
 	for (thread = 0; thread < nr_threads; thread++) {
 		int output = -1;
 
-		if (perf_evlist__mmap_per_evsel(evlist, thread, prot, mask, 0,
-						thread, &output))
+		if (perf_evlist__mmap_per_evsel(evlist, thread, mp, 0, thread,
+						&output))
 			goto out_unmap;
 	}
 
@@ -793,7 +797,9 @@ int perf_evlist__mmap(struct perf_evlist *evlist, unsigned int pages,
 	struct perf_evsel *evsel;
 	const struct cpu_map *cpus = evlist->cpus;
 	const struct thread_map *threads = evlist->threads;
-	int prot = PROT_READ | (overwrite ? 0 : PROT_WRITE), mask;
+	struct mmap_params mp = {
+		.prot = PROT_READ | (overwrite ? 0 : PROT_WRITE),
+	};
 
 	if (evlist->mmap == NULL && perf_evlist__alloc_mmap(evlist) < 0)
 		return -ENOMEM;
@@ -804,7 +810,7 @@ int perf_evlist__mmap(struct perf_evlist *evlist, unsigned int pages,
 	evlist->overwrite = overwrite;
 	evlist->mmap_len = perf_evlist__mmap_size(pages);
 	pr_debug("mmap size %zuB\n", evlist->mmap_len);
-	mask = evlist->mmap_len - page_size - 1;
+	mp.mask = evlist->mmap_len - page_size - 1;
 
 	evlist__for_each(evlist, evsel) {
 		if ((evsel->attr.read_format & PERF_FORMAT_ID) &&
@@ -814,9 +820,9 @@ int perf_evlist__mmap(struct perf_evlist *evlist, unsigned int pages,
 	}
 
 	if (cpu_map__empty(cpus))
-		return perf_evlist__mmap_per_thread(evlist, prot, mask);
+		return perf_evlist__mmap_per_thread(evlist, &mp);
 
-	return perf_evlist__mmap_per_cpu(evlist, prot, mask);
+	return perf_evlist__mmap_per_cpu(evlist, &mp);
 }
 
 int perf_evlist__create_maps(struct perf_evlist *evlist, struct target *target)
-- 
1.9.3

