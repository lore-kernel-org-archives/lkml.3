Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828AbaI0H0v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 03:26:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41233 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752521AbaI0H0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 03:26:18 -0400
Date: Sat, 27 Sep 2014 00:24:41 -0700
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-da88c7f78d842a6938d9adde6af87a2ce262051d@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, namhyung@kernel.org, jolsa@redhat.com,
        ak@linux.intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, namhyung@kernel.org,
        jolsa@redhat.com, ak@linux.intel.com, tglx@linutronix.de
In-Reply-To: <1411591846-32736-1-git-send-email-andi@firstfloor.org>
References: <1411591846-32736-1-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf stat: Fix --per-core on multi socket systems
Git-Commit-ID: da88c7f78d842a6938d9adde6af87a2ce262051d
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

Commit-ID:  da88c7f78d842a6938d9adde6af87a2ce262051d
Gitweb:     http://git.kernel.org/tip/da88c7f78d842a6938d9adde6af87a2ce262051d
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Wed, 24 Sep 2014 13:50:46 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 26 Sep 2014 10:17:13 -0300

perf stat: Fix --per-core on multi socket systems

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
index 5fe0edb..b22c62f 100644
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
