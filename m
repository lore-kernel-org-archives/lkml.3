Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439Ab3F1Ilw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 04:41:52 -0400
Received: from mga14.intel.com ([143.182.124.37]:4700 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755036Ab3F1Ih7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 04:37:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,957,1363158000"; 
   d="scan'208";a="323821319"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH V3 08/15] perf tools: tidy duplicated munmap code
Date: Fri, 28 Jun 2013 11:43:19 +0300
Message-Id: <1372409006-8431-9-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1372409006-8431-1-git-send-email-adrian.hunter@intel.com>
References: <1372409006-8431-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The same lines of code are used in three places.
Make it a new function '__perf_evlist__munmap()'.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/evlist.c | 32 ++++++++++++++------------------
 1 file changed, 14 insertions(+), 18 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 99b43dd..3c8b569 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -403,16 +403,20 @@ union perf_event *perf_evlist__mmap_read(struct perf_evlist *evlist, int idx)
 	return event;
 }
 
+static void __perf_evlist__munmap(struct perf_evlist *evlist, int idx)
+{
+	if (evlist->mmap[idx].base != NULL) {
+		munmap(evlist->mmap[idx].base, evlist->mmap_len);
+		evlist->mmap[idx].base = NULL;
+	}
+}
+
 void perf_evlist__munmap(struct perf_evlist *evlist)
 {
 	int i;
 
-	for (i = 0; i < evlist->nr_mmaps; i++) {
-		if (evlist->mmap[i].base != NULL) {
-			munmap(evlist->mmap[i].base, evlist->mmap_len);
-			evlist->mmap[i].base = NULL;
-		}
-	}
+	for (i = 0; i < evlist->nr_mmaps; i++)
+		__perf_evlist__munmap(evlist, i);
 
 	free(evlist->mmap);
 	evlist->mmap = NULL;
@@ -477,12 +481,8 @@ static int perf_evlist__mmap_per_cpu(struct perf_evlist *evlist, int prot, int m
 	return 0;
 
 out_unmap:
-	for (cpu = 0; cpu < nr_cpus; cpu++) {
-		if (evlist->mmap[cpu].base != NULL) {
-			munmap(evlist->mmap[cpu].base, evlist->mmap_len);
-			evlist->mmap[cpu].base = NULL;
-		}
-	}
+	for (cpu = 0; cpu < nr_cpus; cpu++)
+		__perf_evlist__munmap(evlist, cpu);
 	return -1;
 }
 
@@ -517,12 +517,8 @@ static int perf_evlist__mmap_per_thread(struct perf_evlist *evlist, int prot, in
 	return 0;
 
 out_unmap:
-	for (thread = 0; thread < nr_threads; thread++) {
-		if (evlist->mmap[thread].base != NULL) {
-			munmap(evlist->mmap[thread].base, evlist->mmap_len);
-			evlist->mmap[thread].base = NULL;
-		}
-	}
+	for (thread = 0; thread < nr_threads; thread++)
+		__perf_evlist__munmap(evlist, thread);
 	return -1;
 }
 
-- 
1.7.11.7

