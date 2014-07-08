Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345AbaGHSFd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 14:05:33 -0400
Received: from forward-corp1e.mail.yandex.net ([77.88.60.199]:52511 "EHLO
	forward-corp1e.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755293AbaGHSF3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 14:05:29 -0400
X-Yandex-Uniq: 78a35862-b5cc-4a76-93b4-d93f5edb43a2
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@kernel.org, dsahern@gmail.com, stfomichev@yandex-team.ru
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] perf trace: add pagefault statistics
Date: Tue,  8 Jul 2014 22:05:16 +0400
Message-Id: <1404842716-19190-1-git-send-email-stfomichev@yandex-team.ru>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'perf trace' can show summary of events using -S option. This commit
also reports number of major/minor pagefault events in this summary.

$ perf trace -s --pf all -- sleep 1

 Summary of events:

 sleep (18604), 275 events, 99.6%, 197 minfaults, 0.000 msec

   syscall            calls      min       avg       max      stddev
                               (msec)    (msec)    (msec)        (%)
   --------------- -------- --------- --------- ---------     ------
   read                   2     0.000     0.001     0.002    100.00%
   open                   3     0.004     0.005     0.007     21.13%
   close                  3     0.001     0.001     0.001      1.37%
   fstat                  3     0.001     0.002     0.002     10.66%
   mmap                   8     0.002     0.004     0.006     10.69%
   mprotect               4     0.003     0.005     0.008     24.68%
   munmap                 1     0.005     0.005     0.005      0.00%
   brk                    3     0.001     0.002     0.003     28.08%
   access                 3     0.002     0.003     0.005     24.48%
   nanosleep              1  1000.747  1000.747  1000.747      0.00%
   execve                 8     0.000     0.033     0.246     91.00%
   arch_prctl             1     0.001     0.001     0.001      0.00%

Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
---
 tools/perf/builtin-trace.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index dc7a694b61fe..b94dffc5fa85 100644
--- a/tools/perf/builtin-trace.c
+++ b/tools/perf/builtin-trace.c
@@ -1133,6 +1133,7 @@ struct thread_trace {
 	u64		  exit_time;
 	bool		  entry_pending;
 	unsigned long	  nr_events;
+	unsigned long	  pfmaj, pfmin;
 	char		  *entry_str;
 	double		  runtime_ms;
 	struct {
@@ -1804,8 +1805,20 @@ static int trace__pgfault(struct trace *trace,
 	u8 cpumode = event->header.misc & PERF_RECORD_MISC_CPUMODE_MASK;
 	struct addr_location al;
 	char map_type = 'd';
+	struct thread_trace *ttrace;
 
 	thread = machine__findnew_thread(trace->host, sample->pid, sample->tid);
+	ttrace = thread__trace(thread, trace->output);
+	if (ttrace == NULL)
+		return -1;
+
+	if (evsel->attr.config == PERF_COUNT_SW_PAGE_FAULTS_MAJ)
+		ttrace->pfmaj++;
+	else
+		ttrace->pfmin++;
+
+	if (trace->summary_only)
+		return 0;
 
 	thread__find_addr_location(thread, trace->host, cpumode, MAP__FUNCTION,
 			      sample->ip, &al);
@@ -2346,6 +2359,10 @@ static int trace__fprintf_one_thread(struct thread *thread, void *priv)
 	printed += fprintf(fp, " %s (%d), ", thread__comm_str(thread), thread->tid);
 	printed += fprintf(fp, "%lu events, ", ttrace->nr_events);
 	printed += fprintf(fp, "%.1f%%", ratio);
+	if (ttrace->pfmaj)
+		printed += fprintf(fp, ", %lu majfaults", ttrace->pfmaj);
+	if (ttrace->pfmin)
+		printed += fprintf(fp, ", %lu minfaults", ttrace->pfmin);
 	printed += fprintf(fp, ", %.3f msec\n", ttrace->runtime_ms);
 	printed += thread__dump_stats(ttrace, trace, fp);
 
-- 
1.9.1

