Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490Ab3IYMvL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 08:51:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:34970 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755330Ab3IYMvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 08:51:08 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 02/21] perf tools: Separate sys_perf_event_open call into evsel_open
Date: Wed, 25 Sep 2013 14:50:28 +0200
Message-Id: <1380113447-17144-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1380113447-17144-1-git-send-email-jolsa@redhat.com>
References: <1380113447-17144-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Separating sys_perf_event_open call and its setup into
new evsel_open function.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evsel.c | 48 ++++++++++++++++++++++++++++--------------------
 1 file changed, 28 insertions(+), 20 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 0ce9feb..95590fe 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -1000,23 +1000,40 @@ static size_t perf_event_attr__fprintf(struct perf_event_attr *attr, FILE *fp)
 	return ret;
 }
 
+static int evsel_open(struct perf_evsel *evsel,
+		      struct thread_map *threads, struct cpu_map *cpus,
+		      int thread, int cpu)
+{
+	int group_fd, pid = -1;
+	unsigned long flags = 0;
+
+	/* cgroup config */
+	if (evsel->cgrp) {
+		flags = PERF_FLAG_PID_CGROUP;
+		pid = evsel->cgrp->fd;
+	} else
+		pid = threads->map[thread];
+
+	/* group config */
+	group_fd = get_group_fd(evsel, cpu, thread);
+
+	pr_debug2("perf_event_open: pid %d  cpu %d  group_fd %d  flags %#lx\n",
+		  pid, cpus->map[cpu], group_fd, flags);
+
+	return sys_perf_event_open(&evsel->attr, pid, cpus->map[cpu],
+				   group_fd, flags);
+}
+
 static int __perf_evsel__open(struct perf_evsel *evsel, struct cpu_map *cpus,
 			      struct thread_map *threads)
 {
-	int cpu, thread;
-	unsigned long flags = 0;
-	int pid = -1, err;
+	int cpu, thread, err;
 	enum { NO_CHANGE, SET_TO_MAX, INCREASED_MAX } set_rlimit = NO_CHANGE;
 
 	if (evsel->fd == NULL &&
 	    perf_evsel__alloc_fd(evsel, cpus->nr, threads->nr) < 0)
 		return -ENOMEM;
 
-	if (evsel->cgrp) {
-		flags = PERF_FLAG_PID_CGROUP;
-		pid = evsel->cgrp->fd;
-	}
-
 fallback_missing_features:
 	if (perf_missing_features.mmap2)
 		evsel->attr.mmap2 = 0;
@@ -1032,20 +1049,11 @@ retry_sample_id:
 	for (cpu = 0; cpu < cpus->nr; cpu++) {
 
 		for (thread = 0; thread < threads->nr; thread++) {
-			int group_fd;
 
-			if (!evsel->cgrp)
-				pid = threads->map[thread];
-
-			group_fd = get_group_fd(evsel, cpu, thread);
 retry_open:
-			pr_debug2("perf_event_open: pid %d  cpu %d  group_fd %d  flags %#lx\n",
-				  pid, cpus->map[cpu], group_fd, flags);
-
-			FD(evsel, cpu, thread) = sys_perf_event_open(&evsel->attr,
-								     pid,
-								     cpus->map[cpu],
-								     group_fd, flags);
+			FD(evsel, cpu, thread) = evsel_open(evsel,
+							    threads, cpus,
+							    thread, cpu);
 			if (FD(evsel, cpu, thread) < 0) {
 				err = -errno;
 				goto try_fallback;
-- 
1.7.11.7

