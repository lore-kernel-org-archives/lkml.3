Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965903AbaGPTRy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 15:17:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44164 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932127AbaGPTRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 15:17:49 -0400
Date: Wed, 16 Jul 2014 12:17:30 -0700
From: tip-bot for Stanislav Fomichev <tipbot@zytor.com>
Message-ID: <tip-a2ea67d7b5618c868c1fe15a50af71b858d36887@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, stfomichev@yandex-team.ru, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        stfomichev@yandex-team.ru, dsahern@gmail.com, tglx@linutronix.de
In-Reply-To: <1404842716-19190-1-git-send-email-stfomichev@yandex-team.ru>
References: <1404842716-19190-1-git-send-email-stfomichev@yandex-team.ru>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf trace: Add pagefault statistics
Git-Commit-ID: a2ea67d7b5618c868c1fe15a50af71b858d36887
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

Commit-ID:  a2ea67d7b5618c868c1fe15a50af71b858d36887
Gitweb:     http://git.kernel.org/tip/a2ea67d7b5618c868c1fe15a50af71b858d36887
Author:     Stanislav Fomichev <stfomichev@yandex-team.ru>
AuthorDate: Tue, 8 Jul 2014 22:05:16 +0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 8 Jul 2014 15:34:40 -0300

perf trace: Add pagefault statistics

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
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1404842716-19190-1-git-send-email-stfomichev@yandex-team.ru
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-trace.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/tools/perf/builtin-trace.c b/tools/perf/builtin-trace.c
index dc7a694..b94dffc 100644
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
 
