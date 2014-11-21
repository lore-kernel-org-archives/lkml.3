Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758266AbaKUJcM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 04:32:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46269 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758145AbaKUJcK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 04:32:10 -0500
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
Subject: [PATCH 05/11] perf stat: Make read_counter work over the thread dimension
Date: Fri, 21 Nov 2014 10:31:09 +0100
Message-Id: <1416562275-12404-6-git-send-email-jolsa@kernel.org>
In-Reply-To: <1416562275-12404-1-git-send-email-jolsa@kernel.org>
References: <1416562275-12404-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The read function will be used laster for both aggr and cpu
counters, so we need to make it work over threads as well.

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
 tools/perf/builtin-stat.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 9cc0db1d7f06..2511d3aae708 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -444,11 +444,18 @@ static int read_counter_aggr(struct perf_evsel *counter)
  */
 static int read_counter(struct perf_evsel *counter)
 {
-	int cpu;
+	int nthreads = thread_map__nr(evsel_list->threads);
+	int ncpus = perf_evsel__nr_cpus(counter);
+	int cpu, thread;
 
-	for (cpu = 0; cpu < perf_evsel__nr_cpus(counter); cpu++) {
-		if (perf_evsel__read_cb(counter, cpu, 0, read_cb))
-			return -1;
+	if (counter->system_wide)
+		nthreads = 1;
+
+	for (thread = 0; thread < nthreads; thread++) {
+		for (cpu = 0; cpu < ncpus; cpu++) {
+			if (perf_evsel__read_cb(counter, cpu, thread, read_cb))
+				return -1;
+		}
 	}
 
 	return 0;
-- 
1.9.3

