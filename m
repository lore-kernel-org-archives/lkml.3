Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932973AbaLAXJx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 18:09:53 -0500
Received: from mail.kernel.org ([198.145.19.201]:46728 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932625AbaLAXJu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 18:09:50 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Matt Fleming <matt.fleming@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4/9] perf tools: Remove perf_evsel__read interface
Date: Mon,  1 Dec 2014 20:09:19 -0300
Message-Id: <1417475364-27371-5-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1417475364-27371-1-git-send-email-acme@kernel.org>
References: <1417475364-27371-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

Removing the perf_evsel__read interfaces because we replaced the only
user in the stat command code.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Matt Fleming <matt.fleming@intel.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1416562275-12404-8-git-send-email-jolsa@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evsel.c | 34 ----------------------------------
 tools/perf/util/evsel.h | 29 -----------------------------
 2 files changed, 63 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 2d26b7ad6fe0..1e90c8557ede 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -954,40 +954,6 @@ int __perf_evsel__read_on_cpu(struct perf_evsel *evsel,
 	return 0;
 }
 
-int __perf_evsel__read(struct perf_evsel *evsel,
-		       int ncpus, int nthreads, bool scale)
-{
-	size_t nv = scale ? 3 : 1;
-	int cpu, thread;
-	struct perf_counts_values *aggr = &evsel->counts->aggr, count;
-
-	if (evsel->system_wide)
-		nthreads = 1;
-
-	aggr->val = aggr->ena = aggr->run = 0;
-
-	for (cpu = 0; cpu < ncpus; cpu++) {
-		for (thread = 0; thread < nthreads; thread++) {
-			if (FD(evsel, cpu, thread) < 0)
-				continue;
-
-			if (readn(FD(evsel, cpu, thread),
-				  &count, nv * sizeof(u64)) < 0)
-				return -errno;
-
-			aggr->val += count.val;
-			if (scale) {
-				aggr->ena += count.ena;
-				aggr->run += count.run;
-			}
-		}
-	}
-
-	perf_evsel__compute_deltas(evsel, -1, aggr);
-	perf_counts_values__scale(aggr, scale, &evsel->counts->scaled);
-	return 0;
-}
-
 static int get_group_fd(struct perf_evsel *evsel, int cpu, int thread)
 {
 	struct perf_evsel *leader = evsel->leader;
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index b18d58da580b..3207f4861038 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -271,35 +271,6 @@ static inline int perf_evsel__read_on_cpu_scaled(struct perf_evsel *evsel,
 	return __perf_evsel__read_on_cpu(evsel, cpu, thread, true);
 }
 
-int __perf_evsel__read(struct perf_evsel *evsel, int ncpus, int nthreads,
-		       bool scale);
-
-/**
- * perf_evsel__read - Read the aggregate results on all CPUs
- *
- * @evsel - event selector to read value
- * @ncpus - Number of cpus affected, from zero
- * @nthreads - Number of threads affected, from zero
- */
-static inline int perf_evsel__read(struct perf_evsel *evsel,
-				    int ncpus, int nthreads)
-{
-	return __perf_evsel__read(evsel, ncpus, nthreads, false);
-}
-
-/**
- * perf_evsel__read_scaled - Read the aggregate results on all CPUs, scaled
- *
- * @evsel - event selector to read value
- * @ncpus - Number of cpus affected, from zero
- * @nthreads - Number of threads affected, from zero
- */
-static inline int perf_evsel__read_scaled(struct perf_evsel *evsel,
-					  int ncpus, int nthreads)
-{
-	return __perf_evsel__read(evsel, ncpus, nthreads, true);
-}
-
 int perf_evsel__parse_sample(struct perf_evsel *evsel, union perf_event *event,
 			     struct perf_sample *sample);
 
-- 
1.9.3

