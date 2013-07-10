Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755149Ab3GJTVH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 15:21:07 -0400
Received: from merlin.infradead.org ([205.233.59.134]:56886 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754941Ab3GJTUD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 15:20:03 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        Andi Kleen <ak@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Peter Zijlstra <peterz@infradead.org>, zheng.z.yan@intel.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 19/23] perf stat: Fix per-socket output bug for uncore events
Date: Wed, 10 Jul 2013 16:19:19 -0300
Message-Id: <1373483963-19277-20-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1373483963-19277-1-git-send-email-acme@infradead.org>
References: <1373483963-19277-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephane Eranian <eranian@google.com>

This patch fixes a problem reported by Andi Kleen on perf
stat when measuring uncore events:

 # perf stat --per-socket -e uncore_pcu/event=0x0/ -I1000  -a sleep 2

It would not report counts for the second socket. That was due to a
cpu mapping bug in print_aggr().

This patch also fixes the socket numbering bug for <not counted>
events.

Reported-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Stephane Eranian <eranian@google.com>
Tested-by: Andi Kleen <ak@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: zheng.z.yan@intel.com
Link: http://lkml.kernel.org/r/20130705170645.GA32519@quad
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-stat.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 95768af..352fbd7 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -924,7 +924,7 @@ static void abs_printout(int cpu, int nr, struct perf_evsel *evsel, double avg)
 static void print_aggr(char *prefix)
 {
 	struct perf_evsel *counter;
-	int cpu, s, s2, id, nr;
+	int cpu, cpu2, s, s2, id, nr;
 	u64 ena, run, val;
 
 	if (!(aggr_map || aggr_get_id))
@@ -936,7 +936,8 @@ static void print_aggr(char *prefix)
 			val = ena = run = 0;
 			nr = 0;
 			for (cpu = 0; cpu < perf_evsel__nr_cpus(counter); cpu++) {
-				s2 = aggr_get_id(evsel_list->cpus, cpu);
+				cpu2 = perf_evsel__cpus(counter)->map[cpu];
+				s2 = aggr_get_id(evsel_list->cpus, cpu2);
 				if (s2 != id)
 					continue;
 				val += counter->counts->cpu[cpu].val;
@@ -948,7 +949,7 @@ static void print_aggr(char *prefix)
 				fprintf(output, "%s", prefix);
 
 			if (run == 0 || ena == 0) {
-				aggr_printout(counter, cpu, nr);
+				aggr_printout(counter, id, nr);
 
 				fprintf(output, "%*s%s%*s",
 					csv_output ? 0 : 18,
-- 
1.8.1.4

