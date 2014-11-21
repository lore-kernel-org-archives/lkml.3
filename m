Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758503AbaKUJhi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 04:37:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43228 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758226AbaKUJcA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 04:32:00 -0500
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Andi Kleen <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Matt Fleming <matt.fleming@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 04/11] perf stat: Use perf_evsel__read_cb in read_counter
Date: Fri, 21 Nov 2014 10:31:08 +0100
Message-Id: <1416562275-12404-5-git-send-email-jolsa@kernel.org>
In-Reply-To: <1416562275-12404-1-git-send-email-jolsa@kernel.org>
References: <1416562275-12404-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replacing __perf_evsel__read_on_cpu function with perf_evsel__read_cb
function. The read_cb callback will be used later for global aggregation
counter values as well.

Cc: Andi Kleen <ak@linux.intel.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Matt Fleming <matt.fleming@intel.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/builtin-stat.c | 27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 055ce9232c9e..9cc0db1d7f06 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -388,6 +388,26 @@ static void update_shadow_stats(struct perf_evsel *counter, u64 *count)
 		update_stats(&runtime_itlb_cache_stats[0], count[0]);
 }
 
+static int read_cb(struct perf_evsel *evsel, int cpu, int thread __maybe_unused,
+		   struct perf_counts_values *count)
+{
+	switch (aggr_mode) {
+	case AGGR_CORE:
+	case AGGR_SOCKET:
+	case AGGR_NONE:
+		perf_evsel__compute_deltas(evsel, cpu, count);
+		perf_counts_values__scale(count, scale, NULL);
+		evsel->counts->cpu[cpu] = *count;
+		update_shadow_stats(evsel, count->values);
+		break;
+	case AGGR_GLOBAL:
+	default:
+		break;
+	}
+
+	return 0;
+}
+
 /*
  * Read out the results of a single counter:
  * aggregate counts across CPUs in system-wide mode
@@ -424,16 +444,11 @@ static int read_counter_aggr(struct perf_evsel *counter)
  */
 static int read_counter(struct perf_evsel *counter)
 {
-	u64 *count;
 	int cpu;
 
 	for (cpu = 0; cpu < perf_evsel__nr_cpus(counter); cpu++) {
-		if (__perf_evsel__read_on_cpu(counter, cpu, 0, scale) < 0)
+		if (perf_evsel__read_cb(counter, cpu, 0, read_cb))
 			return -1;
-
-		count = counter->counts->cpu[cpu].values;
-
-		update_shadow_stats(counter, count);
 	}
 
 	return 0;
-- 
1.9.3

