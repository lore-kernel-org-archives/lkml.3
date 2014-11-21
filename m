Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758464AbaKUJep (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 04:34:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46700 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758255AbaKUJcM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 04:32:12 -0500
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
Subject: [PATCH 06/11] perf stat: Use read_counter in read_counter_aggr
Date: Fri, 21 Nov 2014 10:31:10 +0100
Message-Id: <1416562275-12404-7-git-send-email-jolsa@kernel.org>
In-Reply-To: <1416562275-12404-1-git-send-email-jolsa@kernel.org>
References: <1416562275-12404-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the read_counter function as the values retrieval
function for aggr counter values thus eliminating
the use of __perf_evsel__read function.

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
 tools/perf/builtin-stat.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 2511d3aae708..b24a7a08bd1d 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -391,6 +391,8 @@ static void update_shadow_stats(struct perf_evsel *counter, u64 *count)
 static int read_cb(struct perf_evsel *evsel, int cpu, int thread __maybe_unused,
 		   struct perf_counts_values *count)
 {
+	struct perf_counts_values *aggr = &evsel->counts->aggr;
+
 	switch (aggr_mode) {
 	case AGGR_CORE:
 	case AGGR_SOCKET:
@@ -401,6 +403,11 @@ static int read_cb(struct perf_evsel *evsel, int cpu, int thread __maybe_unused,
 		update_shadow_stats(evsel, count->values);
 		break;
 	case AGGR_GLOBAL:
+		aggr->val += count->val;
+		if (scale) {
+			aggr->ena += count->ena;
+			aggr->run += count->run;
+		}
 	default:
 		break;
 	}
@@ -408,20 +415,27 @@ static int read_cb(struct perf_evsel *evsel, int cpu, int thread __maybe_unused,
 	return 0;
 }
 
+static int read_counter(struct perf_evsel *counter);
+
 /*
  * Read out the results of a single counter:
  * aggregate counts across CPUs in system-wide mode
  */
 static int read_counter_aggr(struct perf_evsel *counter)
 {
+	struct perf_counts_values *aggr = &counter->counts->aggr;
 	struct perf_stat *ps = counter->priv;
 	u64 *count = counter->counts->aggr.values;
 	int i;
 
-	if (__perf_evsel__read(counter, perf_evsel__nr_cpus(counter),
-			       thread_map__nr(evsel_list->threads), scale) < 0)
+	aggr->val = aggr->ena = aggr->run = 0;
+
+	if (read_counter(counter))
 		return -1;
 
+	perf_evsel__compute_deltas(counter, -1, aggr);
+	perf_counts_values__scale(aggr, scale, &counter->counts->scaled);
+
 	for (i = 0; i < 3; i++)
 		update_stats(&ps->res_stats[i], count[i]);
 
-- 
1.9.3

