Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965061Ab3GRT7a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 15:59:30 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41669 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759468Ab3GRTu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 15:50:28 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 45/76] perf evlist: Tidy duplicated munmap code
Date: Thu, 18 Jul 2013 16:49:32 -0300
Message-Id: <1374177003-3706-46-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1374177003-3706-1-git-send-email-acme@infradead.org>
References: <1374177003-3706-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

The same lines of code are used in three places.  Make it a new function
'__perf_evlist__munmap()'.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1372944040-32690-8-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evlist.c | 32 ++++++++++++++------------------
 1 file changed, 14 insertions(+), 18 deletions(-)

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index d8f34e0..42ea4e9 100644
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
1.8.1.4

