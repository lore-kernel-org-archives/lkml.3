Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964963Ab3GERGg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 13:06:36 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:38436 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249Ab3GERGf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 13:06:35 -0400
Date: Fri, 5 Jul 2013 19:06:45 +0200
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, jolsa@redhat.com, ak@linux.intel.com,
        zheng.z.yan@intel.com, namhyung.kim@lge.com
Subject: [PATCH] perf stat: fix per-socket output bug for uncore events
Message-ID: <20130705170645.GA32519@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch fixes a problem reported by Andi Kleen on perf
stat when measuring uncore events:

 # perf stat --per-socket -e uncore_pcu/event=0x0/ -I1000  -a sleep 2

It would not report counts for the second socket. That was due to a
cpu mapping bug in print_aggr().

This patch also fixes the socket numbering bug for <not counted>
events.

Reported-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 7e910ba..128e168 100644
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
