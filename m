Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146AbaKYNXD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 08:23:03 -0500
Received: from mail.kernel.org ([198.145.19.201]:35804 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753222AbaKYNW7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 08:22:59 -0500
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
Subject: [PATCH 09/12] perf evsel: Introduce perf_counts_values__scale function
Date: Tue, 25 Nov 2014 10:22:07 -0300
Message-Id: <1416921730-5063-10-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1416921730-5063-1-git-send-email-acme@kernel.org>
References: <1416921730-5063-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

Factoring out scale login into perf_counts_values__scale function.

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
Link: http://lkml.kernel.org/r/1416562275-12404-3-git-send-email-jolsa@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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

