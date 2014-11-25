Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755136AbaKYNW5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 08:22:57 -0500
Received: from mail.kernel.org ([198.145.19.201]:35783 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755114AbaKYNWy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 08:22:54 -0500
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
Subject: [PATCH 08/12] perf evsel: Introduce perf_evsel__compute_deltas function
Date: Tue, 25 Nov 2014 10:22:06 -0300
Message-Id: <1416921730-5063-9-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1416921730-5063-1-git-send-email-acme@kernel.org>
References: <1416921730-5063-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

Making compute_deltas functions global and renaming it to
perf_evsel__compute_deltas.

It will be used in stat command in later patch.

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
Link: http://lkml.kernel.org/r/1416562275-12404-2-git-send-email-jolsa@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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

