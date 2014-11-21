Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758350AbaKUJcr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 04:32:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46858 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758332AbaKUJcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 04:32:42 -0500
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
Subject: [PATCH 11/11] perf stat: Add support for snapshot counters
Date: Fri, 21 Nov 2014 10:31:15 +0100
Message-Id: <1416562275-12404-12-git-send-email-jolsa@kernel.org>
In-Reply-To: <1416562275-12404-1-git-send-email-jolsa@kernel.org>
References: <1416562275-12404-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The .snapshot file indicates that the provided event value is a
snapshot value. Bypassing the delta computation logic for such
event.

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
 tools/perf/builtin-stat.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 860e8ad06616..891086376381 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -443,7 +443,8 @@ static int read_cb(struct perf_evsel *evsel, int cpu, int thread __maybe_unused,
 	case AGGR_CORE:
 	case AGGR_SOCKET:
 	case AGGR_NONE:
-		perf_evsel__compute_deltas(evsel, cpu, count);
+		if (!evsel->snapshot)
+			perf_evsel__compute_deltas(evsel, cpu, count);
 		perf_counts_values__scale(count, scale, NULL);
 		evsel->counts->cpu[cpu] = *count;
 		update_shadow_stats(evsel, count->values);
@@ -479,7 +480,8 @@ static int read_counter_aggr(struct perf_evsel *counter)
 	if (read_counter(counter))
 		return -1;
 
-	perf_evsel__compute_deltas(counter, -1, aggr);
+	if (!counter->snapshot)
+		perf_evsel__compute_deltas(counter, -1, aggr);
 	perf_counts_values__scale(aggr, scale, &counter->counts->scaled);
 
 	for (i = 0; i < 3; i++)
-- 
1.9.3

