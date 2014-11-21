Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758223AbaKUJbw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 04:31:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43164 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758145AbaKUJbr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 04:31:47 -0500
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
Subject: [PATCH 02/11] perf tools: Introduce perf_counts_values__scale function
Date: Fri, 21 Nov 2014 10:31:06 +0100
Message-Id: <1416562275-12404-3-git-send-email-jolsa@kernel.org>
In-Reply-To: <1416562275-12404-1-git-send-email-jolsa@kernel.org>
References: <1416562275-12404-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Factoring out scale login into perf_counts_values__scale
function.

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
 tools/perf/util/evsel.c | 47 ++++++++++++++++++++++-------------------------
 tools/perf/util/evsel.h |  3 +++
 2 files changed, 25 insertions(+), 25 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 1c73bc4d57d3..6dc7a67e6d35 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -897,6 +897,26 @@ void perf_evsel__compute_deltas(struct perf_evsel *evsel, int cpu,
 	count->run = count->run - tmp.run;
 }
 
+void perf_counts_values__scale(struct perf_counts_values *count,
+			       bool scale, s8 *pscaled)
+{
+	s8 scaled = 0;
+
+	if (scale) {
+		if (count->run == 0) {
+			scaled = -1;
+			count->val = 0;
+		} else if (count->run < count->ena) {
+			scaled = 1;
+			count->val = (u64)((double) count->val * count->ena / count->run + 0.5);
+		}
+	} else
+		count->ena = count->run = 0;
+
+	if (pscaled)
+		*pscaled = scaled;
+}
+
 int __perf_evsel__read_on_cpu(struct perf_evsel *evsel,
 			      int cpu, int thread, bool scale)
 {
@@ -913,15 +933,7 @@ int __perf_evsel__read_on_cpu(struct perf_evsel *evsel,
 		return -errno;
 
 	perf_evsel__compute_deltas(evsel, cpu, &count);
-
-	if (scale) {
-		if (count.run == 0)
-			count.val = 0;
-		else if (count.run < count.ena)
-			count.val = (u64)((double)count.val * count.ena / count.run + 0.5);
-	} else
-		count.ena = count.run = 0;
-
+	perf_counts_values__scale(&count, scale, NULL);
 	evsel->counts->cpu[cpu] = count;
 	return 0;
 }
@@ -956,22 +968,7 @@ int __perf_evsel__read(struct perf_evsel *evsel,
 	}
 
 	perf_evsel__compute_deltas(evsel, -1, aggr);
-
-	evsel->counts->scaled = 0;
-	if (scale) {
-		if (aggr->run == 0) {
-			evsel->counts->scaled = -1;
-			aggr->val = 0;
-			return 0;
-		}
-
-		if (aggr->run < aggr->ena) {
-			evsel->counts->scaled = 1;
-			aggr->val = (u64)((double)aggr->val * aggr->ena / aggr->run + 0.5);
-		}
-	} else
-		aggr->ena = aggr->run = 0;
-
+	perf_counts_values__scale(aggr, scale, &evsel->counts->scaled);
 	return 0;
 }
 
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 746b7ea84589..7af0377ceb18 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -110,6 +110,9 @@ struct thread_map;
 struct perf_evlist;
 struct record_opts;
 
+void perf_counts_values__scale(struct perf_counts_values *count,
+			       bool scale, s8 *pscaled);
+
 void perf_evsel__compute_deltas(struct perf_evsel *evsel, int cpu,
 				struct perf_counts_values *count);
 
-- 
1.9.3

