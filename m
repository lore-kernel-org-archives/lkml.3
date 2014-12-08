Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624AbaLHGw6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 01:52:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34863 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754030AbaLHGwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 01:52:55 -0500
Date: Sun, 7 Dec 2014 22:52:36 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-779d0b997e0787fc5f80110159b6c18ae0fae395@git.kernel.org>
Cc: namhyung@kernel.org, eranian@google.com, tglx@linutronix.de,
        paulus@samba.org, cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com,
        mingo@kernel.org, dsahern@gmail.com, hpa@zytor.com,
        matt.fleming@intel.com, jolsa@kernel.org, acme@redhat.com,
        ak@linux.intel.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl
Reply-To: dsahern@gmail.com, matt.fleming@intel.com, hpa@zytor.com,
        jolsa@kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, ak@linux.intel.com, namhyung@kernel.org,
        paulus@samba.org, tglx@linutronix.de, eranian@google.com,
        cjashfor@linux.vnet.ibm.com, fweisbec@gmail.com, mingo@kernel.org
In-Reply-To: <1416562275-12404-11-git-send-email-jolsa@kernel.org>
References: <1416562275-12404-11-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf stat: Add support for per-pkg counters
Git-Commit-ID: 779d0b997e0787fc5f80110159b6c18ae0fae395
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  779d0b997e0787fc5f80110159b6c18ae0fae395
Gitweb:     http://git.kernel.org/tip/779d0b997e0787fc5f80110159b6c18ae0fae395
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Fri, 21 Nov 2014 10:31:14 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 1 Dec 2014 20:00:30 -0300

perf stat: Add support for per-pkg counters

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
index b24a7a0..860e8ad 100644
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
index 3207f48..3862274 100644
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
