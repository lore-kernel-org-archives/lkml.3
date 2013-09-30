Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030Ab3I3LUN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 07:20:13 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:42677 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754555Ab3I3LT5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 07:19:57 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>
Subject: [PATCH 2/2] perf tool: don't print bogus data on -e cycles
Date: Mon, 30 Sep 2013 16:43:05 +0530
Message-Id: <1380539585-23859-3-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.4.477.g5d89aa9
In-Reply-To: <1380539585-23859-1-git-send-email-artagnon@gmail.com>
References: <1380539585-23859-1-git-send-email-artagnon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 tools/perf/builtin-stat.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index f686d5f..cc167ae 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -918,11 +918,10 @@ static void abs_printout(int cpu, int nr, struct perf_evsel *evsel, double avg)
 		print_stalled_cycles_backend(cpu, evsel, avg);
 	} else if (perf_evsel__match(evsel, HARDWARE, HW_CPU_CYCLES)) {
 		total = avg_stats(&runtime_nsecs_stats[cpu]);
-
-		if (total)
-			ratio = 1.0 * avg / total;
-
-		fprintf(output, " # %8.3f GHz                    ", ratio);
+		if (total) {
+			ratio = avg / total;
+			fprintf(output, " # %8.3f GHz                    ", ratio);
+		}
 	} else if (runtime_nsecs_stats[cpu].n != 0) {
 		char unit = 'M';
 
-- 
1.8.4.477.g5d89aa9

