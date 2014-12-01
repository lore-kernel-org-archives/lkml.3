Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933005AbaLAXKD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 18:10:03 -0500
Received: from mail.kernel.org ([198.145.19.201]:46768 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932990AbaLAXJ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 18:09:58 -0500
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
Subject: [PATCH 6/9] perf stat: Add support for snapshot counters
Date: Mon,  1 Dec 2014 20:09:21 -0300
Message-Id: <1417475364-27371-7-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1417475364-27371-1-git-send-email-acme@kernel.org>
References: <1417475364-27371-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

The .snapshot file indicates that the provided event value is a snapshot
value. Bypassing the delta computation logic for such event.

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
Link: http://lkml.kernel.org/r/1416562275-12404-12-git-send-email-jolsa@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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

