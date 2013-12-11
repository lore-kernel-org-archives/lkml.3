Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752806Ab3LKMyM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 07:54:12 -0500
Received: from mga09.intel.com ([134.134.136.24]:41707 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751496Ab3LKMj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 07:39:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,871,1378882800"; 
   d="scan'208";a="450497632"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH v0 19/71] perf evlist: Pass mmap parameters in a struct
Date: Wed, 11 Dec 2013 14:36:31 +0200
Message-Id: <1386765443-26966-20-git-send-email-alexander.shishkin@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc2
In-Reply-To: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
References: <1386765443-26966-1-git-send-email-alexander.shishkin@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

In preparation for adding more mmap parameters, pass
existing parameters in a struct.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/evlist.c | 46 ++++++++++++++++++++++++++--------------------
 1 file changed, 26 insertions(+), 20 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 50fadde..f9dbf5f 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -600,12 +600,17 @@ static int perf_evlist__alloc_mmap(struct perf_evlist *evlist)
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
@@ -619,8 +624,8 @@ static int __perf_evlist__mmap(struct perf_evlist *evlist,
 }
 
 static int perf_evlist__mmap_per_evsel(struct perf_evlist *evlist, int idx,
-				       int prot, int mask, int cpu, int thread,
-				       int *output)
+				       struct mmap_params *mp, int cpu,
+				       int thread, int *output)
 {
 	struct perf_evsel *evsel;
 
@@ -629,8 +634,7 @@ static int perf_evlist__mmap_per_evsel(struct perf_evlist *evlist, int idx,
 
 		if (*output == -1) {
 			*output = fd;
-			if (__perf_evlist__mmap(evlist, idx, prot, mask,
-						*output) < 0)
+			if (__perf_evlist__mmap(evlist, idx, mp, *output) < 0)
 				return -1;
 		} else {
 			if (ioctl(fd, PERF_EVENT_IOC_SET_OUTPUT, *output) != 0)
@@ -645,8 +649,8 @@ static int perf_evlist__mmap_per_evsel(struct perf_evlist *evlist, int idx,
 	return 0;
 }
 
-static int perf_evlist__mmap_per_cpu(struct perf_evlist *evlist, int prot,
-				     int mask)
+static int perf_evlist__mmap_per_cpu(struct perf_evlist *evlist,
+				     struct mmap_params *mp)
 {
 	int cpu, thread;
 	int nr_cpus = cpu_map__nr(evlist->cpus);
@@ -657,8 +661,8 @@ static int perf_evlist__mmap_per_cpu(struct perf_evlist *evlist, int prot,
 		int output = -1;
 
 		for (thread = 0; thread < nr_threads; thread++) {
-			if (perf_evlist__mmap_per_evsel(evlist, cpu, prot, mask,
-							cpu, thread, &output))
+			if (perf_evlist__mmap_per_evsel(evlist, cpu, mp, cpu,
+							thread, &output))
 				goto out_unmap;
 		}
 	}
@@ -671,8 +675,8 @@ out_unmap:
 	return -1;
 }
 
-static int perf_evlist__mmap_per_thread(struct perf_evlist *evlist, int prot,
-					int mask)
+static int perf_evlist__mmap_per_thread(struct perf_evlist *evlist,
+					struct mmap_params *mp)
 {
 	int thread;
 	int nr_threads = thread_map__nr(evlist->threads);
@@ -681,8 +685,8 @@ static int perf_evlist__mmap_per_thread(struct perf_evlist *evlist, int prot,
 	for (thread = 0; thread < nr_threads; thread++) {
 		int output = -1;
 
-		if (perf_evlist__mmap_per_evsel(evlist, thread, prot, mask, 0,
-						thread, &output))
+		if (perf_evlist__mmap_per_evsel(evlist, thread, mp, 0, thread,
+						&output))
 			goto out_unmap;
 	}
 
@@ -785,7 +789,9 @@ int perf_evlist__mmap(struct perf_evlist *evlist, unsigned int pages,
 	struct perf_evsel *evsel;
 	const struct cpu_map *cpus = evlist->cpus;
 	const struct thread_map *threads = evlist->threads;
-	int prot = PROT_READ | (overwrite ? 0 : PROT_WRITE), mask;
+	struct mmap_params mp = {
+		.prot = PROT_READ | (overwrite ? 0 : PROT_WRITE),
+	};
 
 	if (evlist->mmap == NULL && perf_evlist__alloc_mmap(evlist) < 0)
 		return -ENOMEM;
@@ -796,7 +802,7 @@ int perf_evlist__mmap(struct perf_evlist *evlist, unsigned int pages,
 	evlist->overwrite = overwrite;
 	evlist->mmap_len = perf_evlist__mmap_size(pages);
 	pr_debug("mmap size %zuB\n", evlist->mmap_len);
-	mask = evlist->mmap_len - page_size - 1;
+	mp.mask = evlist->mmap_len - page_size - 1;
 
 	list_for_each_entry(evsel, &evlist->entries, node) {
 		if ((evsel->attr.read_format & PERF_FORMAT_ID) &&
@@ -806,9 +812,9 @@ int perf_evlist__mmap(struct perf_evlist *evlist, unsigned int pages,
 	}
 
 	if (cpu_map__empty(cpus))
-		return perf_evlist__mmap_per_thread(evlist, prot, mask);
+		return perf_evlist__mmap_per_thread(evlist, &mp);
 
-	return perf_evlist__mmap_per_cpu(evlist, prot, mask);
+	return perf_evlist__mmap_per_cpu(evlist, &mp);
 }
 
 int perf_evlist__create_maps(struct perf_evlist *evlist, struct target *target)
-- 
1.8.5.1

