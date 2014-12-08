Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600AbaLHGwm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 01:52:42 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34835 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030AbaLHGwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 01:52:40 -0500
Date: Sun, 7 Dec 2014 22:52:20 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-a5a7fd76b55a6e6916ff22e5c8fdb39a8381be2c@git.kernel.org>
Cc: jolsa@kernel.org, eranian@google.com, acme@redhat.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, paulus@samba.org, matt.fleming@intel.com,
        cjashfor@linux.vnet.ibm.com, dsahern@gmail.com, ak@linux.intel.com,
        fweisbec@gmail.com, hpa@zytor.com, namhyung@kernel.org,
        mingo@kernel.org
Reply-To: mingo@kernel.org, namhyung@kernel.org, hpa@zytor.com,
        fweisbec@gmail.com, ak@linux.intel.com, dsahern@gmail.com,
        cjashfor@linux.vnet.ibm.com, matt.fleming@intel.com,
        linux-kernel@vger.kernel.org, paulus@samba.org, tglx@linutronix.de,
        a.p.zijlstra@chello.nl, eranian@google.com, acme@redhat.com,
        jolsa@kernel.org
In-Reply-To: <1416562275-12404-8-git-send-email-jolsa@kernel.org>
References: <1416562275-12404-8-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Remove perf_evsel__read interface
Git-Commit-ID: a5a7fd76b55a6e6916ff22e5c8fdb39a8381be2c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a5a7fd76b55a6e6916ff22e5c8fdb39a8381be2c
Gitweb:     http://git.kernel.org/tip/a5a7fd76b55a6e6916ff22e5c8fdb39a8381be2c
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Fri, 21 Nov 2014 10:31:11 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 1 Dec 2014 20:00:30 -0300

perf tools: Remove perf_evsel__read interface

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
index 2d26b7a..1e90c85 100644
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
index b18d58d..3207f48 100644
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
 
