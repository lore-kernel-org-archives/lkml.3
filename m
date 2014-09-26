Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756131AbaIZUUD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 16:20:03 -0400
Received: from mail.kernel.org ([198.145.19.201]:52639 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756096AbaIZUT7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 16:19:59 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 01/10] perf stat: Fix --per-core on multi socket systems
Date: Fri, 26 Sep 2014 17:19:38 -0300
Message-Id: <1411762787-26113-2-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1411762787-26113-1-git-send-email-acme@kernel.org>
References: <1411762787-26113-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

On systems with more than one socket perf stat --per-core would either
segfault or stop before outputting all cores.

The problem was that the output code referenced the id including the
socket number in the higher bits, which is far beyond any per cpu array.

Mask out the socket number before referencing cpus in abs_printout.

I also renamed the variable in nsec_printout to be clear what it is,
even though it doesn't reference cpus.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Stephane Eranian <eranian@google.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1411591846-32736-1-git-send-email-andi@firstfloor.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-stat.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 5fe0edb1de5d..b22c62f80078 100644
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

