Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758199AbaKUJbv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 04:31:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46933 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758146AbaKUJbs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 04:31:48 -0500
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
Subject: [PATCH 01/11] perf tools: Introduce perf_evsel__compute_deltas function
Date: Fri, 21 Nov 2014 10:31:05 +0100
Message-Id: <1416562275-12404-2-git-send-email-jolsa@kernel.org>
In-Reply-To: <1416562275-12404-1-git-send-email-jolsa@kernel.org>
References: <1416562275-12404-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Making compute_deltas functions global and renaming it
to perf_evsel__compute_deltas. It will be used in stat
command in later patch.

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
 tools/perf/util/evsel.c | 9 ++++-----
 tools/perf/util/evsel.h | 3 +++
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index f2dc91fb87fa..1c73bc4d57d3 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -876,9 +876,8 @@ void perf_evsel__delete(struct perf_evsel *evsel)
 	free(evsel);
 }
 
-static inline void compute_deltas(struct perf_evsel *evsel,
-				  int cpu,
-				  struct perf_counts_values *count)
+void perf_evsel__compute_deltas(struct perf_evsel *evsel, int cpu,
+				struct perf_counts_values *count)
 {
 	struct perf_counts_values tmp;
 
@@ -913,7 +912,7 @@ int __perf_evsel__read_on_cpu(struct perf_evsel *evsel,
 	if (readn(FD(evsel, cpu, thread), &count, nv * sizeof(u64)) < 0)
 		return -errno;
 
-	compute_deltas(evsel, cpu, &count);
+	perf_evsel__compute_deltas(evsel, cpu, &count);
 
 	if (scale) {
 		if (count.run == 0)
@@ -956,7 +955,7 @@ int __perf_evsel__read(struct perf_evsel *evsel,
 		}
 	}
 
-	compute_deltas(evsel, -1, aggr);
+	perf_evsel__compute_deltas(evsel, -1, aggr);
 
 	evsel->counts->scaled = 0;
 	if (scale) {
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 979790951bfb..746b7ea84589 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -110,6 +110,9 @@ struct thread_map;
 struct perf_evlist;
 struct record_opts;
 
+void perf_evsel__compute_deltas(struct perf_evsel *evsel, int cpu,
+				struct perf_counts_values *count);
+
 int perf_evsel__object_config(size_t object_size,
 			      int (*init)(struct perf_evsel *evsel),
 			      void (*fini)(struct perf_evsel *evsel));
-- 
1.9.3

