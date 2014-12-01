Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932989AbaLAXJ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 18:09:58 -0500
Received: from mail.kernel.org ([198.145.19.201]:46747 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932625AbaLAXJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 18:09:54 -0500
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
Subject: [PATCH 5/9] perf stat: Add support for per-pkg counters
Date: Mon,  1 Dec 2014 20:09:20 -0300
Message-Id: <1417475364-27371-6-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1417475364-27371-1-git-send-email-acme@kernel.org>
References: <1417475364-27371-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

The .per-pkg file indicates that all but one value per socket should be
discarded. Adding the logic of skipping the rest of the socket once
first value was read.

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
Link: http://lkml.kernel.org/r/1416562275-12404-11-git-send-email-jolsa@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-stat.c | 49 +++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/evsel.h   |  1 +
 2 files changed, 50 insertions(+)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index b24a7a08bd1d..860e8ad06616 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -388,10 +388,56 @@ static void update_shadow_stats(struct perf_evsel *counter, u64 *count)
 		update_stats(&runtime_itlb_cache_stats[0], count[0]);
 }
 
+static void zero_per_pkg(struct perf_evsel *counter)
+{
+	if (counter->per_pkg_mask)
+		memset(counter->per_pkg_mask, 0, MAX_NR_CPUS);
+}
+
+static int check_per_pkg(struct perf_evsel *counter, int cpu, bool *skip)
+{
+	unsigned long *mask = counter->per_pkg_mask;
+	struct cpu_map *cpus = perf_evsel__cpus(counter);
+	int s;
+
+	*skip = false;
+
+	if (!counter->per_pkg)
+		return 0;
+
+	if (cpu_map__empty(cpus))
+		return 0;
+
+	if (!mask) {
+		mask = zalloc(MAX_NR_CPUS);
+		if (!mask)
+			return -ENOMEM;
+
+		counter->per_pkg_mask = mask;
+	}
+
+	s = cpu_map__get_socket(cpus, cpu);
+	if (s < 0)
+		return -1;
+
+	*skip = test_and_set_bit(s, mask) == 1;
+	return 0;
+}
+
 static int read_cb(struct perf_evsel *evsel, int cpu, int thread __maybe_unused,
 		   struct perf_counts_values *count)
 {
 	struct perf_counts_values *aggr = &evsel->counts->aggr;
+	static struct perf_counts_values zero;
+	bool skip = false;
+
+	if (check_per_pkg(evsel, cpu, &skip)) {
+		pr_err("failed to read per-pkg counter\n");
+		return -1;
+	}
+
+	if (skip)
+		count = &zero;
 
 	switch (aggr_mode) {
 	case AGGR_CORE:
@@ -465,6 +511,9 @@ static int read_counter(struct perf_evsel *counter)
 	if (counter->system_wide)
 		nthreads = 1;
 
+	if (counter->per_pkg)
+		zero_per_pkg(counter);
+
 	for (thread = 0; thread < nthreads; thread++) {
 		for (cpu = 0; cpu < ncpus; cpu++) {
 			if (perf_evsel__read_cb(counter, cpu, thread, read_cb))
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 3207f4861038..38622747d130 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -93,6 +93,7 @@ struct perf_evsel {
 	bool			system_wide;
 	bool			tracking;
 	bool			per_pkg;
+	unsigned long		*per_pkg_mask;
 	/* parse modifier helper */
 	int			exclude_GH;
 	int			nr_members;
-- 
1.9.3

