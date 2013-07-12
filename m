Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757741Ab3GLIxB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 04:53:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54918 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757724Ab3GLIw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 04:52:56 -0400
Date: Fri, 12 Jul 2013 01:52:15 -0700
From: tip-bot for Stephane Eranian <tipbot@zytor.com>
Message-ID: <tip-582ec0829b3dd74d8c0f58403a3f9df8cbaa9c7d@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        namhyung.kim@lge.com, jolsa@redhat.com, ak@linux.intel.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        namhyung.kim@lge.com, jolsa@redhat.com, ak@linux.intel.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20130705170645.GA32519@quad>
References: <20130705170645.GA32519@quad>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf stat:
  Fix per-socket output bug for uncore events
Git-Commit-ID: 582ec0829b3dd74d8c0f58403a3f9df8cbaa9c7d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 12 Jul 2013 01:52:21 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  582ec0829b3dd74d8c0f58403a3f9df8cbaa9c7d
Gitweb:     http://git.kernel.org/tip/582ec0829b3dd74d8c0f58403a3f9df8cbaa9c7d
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Fri, 5 Jul 2013 19:06:45 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 8 Jul 2013 18:01:46 -0300

perf stat: Fix per-socket output bug for uncore events

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
