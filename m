Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933041Ab3JNUau (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:30:50 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38897 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757649Ab3JNUDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:03:03 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Ramkumar Ramachandra <artagnon@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 115/161] perf stat: Don't print bogus data on -e cycles
Date: Mon, 14 Oct 2013 17:01:44 -0300
Message-Id: <1381780950-25642-116-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ramkumar Ramachandra <artagnon@gmail.com>

When only the cycles event is requested:

$ perf stat -e cycles dd if=/dev/zero of=/dev/null count=1000000
1000000+0 records in
1000000+0 records out
512000000 bytes (512 MB) copied, 0.26123 s, 2.0 GB/s

 Performance counter stats for 'dd if=/dev/zero of=/dev/null count=1000000':

       911,626,453 cycles                    #    0.000 GHz

       0.262113350 seconds time elapsed

The 0.000 GHz comment in the output is totally bogus and misleading. It
happens because update_shadow_stats() doesn't touch runtime_nsecs_stats;
it is only written when a requested counter matches a SW_TASK_CLOCK. In
our case, since we have only requested HW_CPU_CYCLES,
runtime_nsecs_stats is unavailable. So, omit printing the comment
altogether.

Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1380539585-23859-3-git-send-email-artagnon@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-stat.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 700b47849101..ce2266c5cd52 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -997,10 +997,10 @@ static void abs_printout(int cpu, int nr, struct perf_evsel *evsel, double avg)
 	} else if (perf_evsel__match(evsel, HARDWARE, HW_CPU_CYCLES)) {
 		total = avg_stats(&runtime_nsecs_stats[cpu]);
 
-		if (total)
-			ratio = 1.0 * avg / total;
-
-		fprintf(output, " # %8.3f GHz                    ", ratio);
+		if (total) {
+			ratio = avg / total;
+			fprintf(output, " # %8.3f GHz                    ", ratio);
+		}
 	} else if (transaction_run &&
 		   perf_evsel__cmp(evsel, nth_evsel(T_CYCLES_IN_TX))) {
 		total = avg_stats(&runtime_cycles_stats[cpu]);
-- 
1.8.1.4

