Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751630AbaIXUuz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 16:50:55 -0400
Received: from mga01.intel.com ([192.55.52.88]:35223 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750725AbaIXUux (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 16:50:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="391141998"
From: Andi Kleen <andi@firstfloor.org>
To: jolsa@redhat.com
Cc: linux-kernel@vger.kernel.org, namhyung@kernel.org, acme@kernel.org,
        Andi Kleen <ak@linux.intel.com>, eranian@google.com
Subject: [PATCH] perf, tools: Fix perf stat --per-core on multi socket systems
Date: Wed, 24 Sep 2014 13:50:46 -0700
Message-Id: <1411591846-32736-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

On systems with more than one socket perf stat --per-core
would either segfault or stop before outputting all cores.
The problem was that the output code referenced the
id including the socket number in the higher bits, which
is far beyond any per cpu array.

Mask out the socket number before referencing cpus
in abs_printout.

I also renamed the variable in nsec_printout to be clear
what it is, even though it doesn't reference cpus.

Cc: eranian@google.com
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/builtin-stat.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 3e80aa1..6e636b9 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -732,7 +732,7 @@ static void aggr_printout(struct perf_evsel *evsel, int id, int nr)
 	}
 }
 
-static void nsec_printout(int cpu, int nr, struct perf_evsel *evsel, double avg)
+static void nsec_printout(int id, int nr, struct perf_evsel *evsel, double avg)
 {
 	double msecs = avg / 1e6;
 	const char *fmt_v, *fmt_n;
@@ -741,7 +741,7 @@ static void nsec_printout(int cpu, int nr, struct perf_evsel *evsel, double avg)
 	fmt_v = csv_output ? "%.6f%s" : "%18.6f%s";
 	fmt_n = csv_output ? "%s" : "%-25s";
 
-	aggr_printout(evsel, cpu, nr);
+	aggr_printout(evsel, id, nr);
 
 	scnprintf(name, sizeof(name), "%s%s",
 		  perf_evsel__name(evsel), csv_output ? "" : " (msec)");
@@ -947,11 +947,12 @@ static void print_ll_cache_misses(int cpu,
 	fprintf(output, " of all LL-cache hits   ");
 }
 
-static void abs_printout(int cpu, int nr, struct perf_evsel *evsel, double avg)
+static void abs_printout(int id, int nr, struct perf_evsel *evsel, double avg)
 {
 	double total, ratio = 0.0, total2;
 	double sc =  evsel->scale;
 	const char *fmt;
+	int cpu = cpu_map__id_to_cpu(id);
 
 	if (csv_output) {
 		fmt = sc != 1.0 ?  "%.2f%s" : "%.0f%s";
@@ -962,7 +963,7 @@ static void abs_printout(int cpu, int nr, struct perf_evsel *evsel, double avg)
 			fmt = sc != 1.0 ? "%18.2f%s" : "%18.0f%s";
 	}
 
-	aggr_printout(evsel, cpu, nr);
+	aggr_printout(evsel, id, nr);
 
 	if (aggr_mode == AGGR_GLOBAL)
 		cpu = 0;
-- 
1.9.3

