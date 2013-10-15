Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933195Ab3JOF3g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:29:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33417 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933174Ab3JOF3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:29:32 -0400
Date: Mon, 14 Oct 2013 22:29:16 -0700
From: tip-bot for Ramkumar Ramachandra <tipbot@zytor.com>
Message-ID: <tip-c458fe62ca31496664c1211a7906d261220b18f9@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, artagnon@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, artagnon@gmail.com
In-Reply-To: <1380539585-23859-3-git-send-email-artagnon@gmail.com>
References: <1380539585-23859-3-git-send-email-artagnon@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf stat: Don't print bogus data on -e cycles
Git-Commit-ID: c458fe62ca31496664c1211a7906d261220b18f9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:29:23 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c458fe62ca31496664c1211a7906d261220b18f9
Gitweb:     http://git.kernel.org/tip/c458fe62ca31496664c1211a7906d261220b18f9
Author:     Ramkumar Ramachandra <artagnon@gmail.com>
AuthorDate: Mon, 30 Sep 2013 16:43:05 +0530
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 11 Oct 2013 12:17:33 -0300

perf stat: Don't print bogus data on -e cycles

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
index 700b478..ce2266c 100644
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
