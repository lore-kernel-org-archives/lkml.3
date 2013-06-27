Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296Ab3F0HuF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 03:50:05 -0400
Received: from mga11.intel.com ([192.55.52.93]:58424 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753180Ab3F0Htm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 03:49:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,950,1363158000"; 
   d="scan'208";a="361296213"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH V2 08/15] perf tools: tidy duplicated munmap code
Date: Thu, 27 Jun 2013 10:55:00 +0300
Message-Id: <1372319707-13892-9-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1372319707-13892-1-git-send-email-adrian.hunter@intel.com>
References: <1372319707-13892-1-git-send-email-adrian.hunter@intel.com>
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

