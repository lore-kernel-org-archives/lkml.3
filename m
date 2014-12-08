Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754573AbaLHGwb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 01:52:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34822 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052AbaLHGw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 01:52:29 -0500
Date: Sun, 7 Dec 2014 22:52:02 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-1971f59f1a1e0e7f3efc25ce0597505626d9f7ed@git.kernel.org>
Cc: tglx@linutronix.de, mingo@kernel.org, ak@linux.intel.com, acme@redhat.com,
        eranian@google.com, paulus@samba.org, cjashfor@linux.vnet.ibm.com,
        namhyung@kernel.org, linux-kernel@vger.kernel.org, jolsa@kernel.org,
        hpa@zytor.com, matt.fleming@intel.com, fweisbec@gmail.com,
        dsahern@gmail.com, a.p.zijlstra@chello.nl
Reply-To: hpa@zytor.com, jolsa@kernel.org, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, dsahern@gmail.com, matt.fleming@intel.com,
        fweisbec@gmail.com, ak@linux.intel.com, mingo@kernel.org,
        tglx@linutronix.de, namhyung@kernel.org, paulus@samba.org,
        cjashfor@linux.vnet.ibm.com, eranian@google.com, acme@redhat.com
In-Reply-To: <1416562275-12404-7-git-send-email-jolsa@kernel.org>
References: <1416562275-12404-7-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf stat: Use read_counter in read_counter_aggr
Git-Commit-ID: 1971f59f1a1e0e7f3efc25ce0597505626d9f7ed
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

Commit-ID:  1971f59f1a1e0e7f3efc25ce0597505626d9f7ed
Gitweb:     http://git.kernel.org/tip/1971f59f1a1e0e7f3efc25ce0597505626d9f7ed
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Fri, 21 Nov 2014 10:31:10 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 1 Dec 2014 20:00:30 -0300

perf stat: Use read_counter in read_counter_aggr

Use the read_counter function as the values retrieval function for aggr
counter values thus eliminating the use of __perf_evsel__read function.

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
Link: http://lkml.kernel.org/r/1416562275-12404-7-git-send-email-jolsa@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-stat.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 2511d3a..b24a7a0 100644
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
 
