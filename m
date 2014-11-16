Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755359AbaKPJvL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 04:51:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34408 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755309AbaKPJvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 04:51:09 -0500
Date: Sun, 16 Nov 2014 01:50:31 -0800
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-23cfa361f3e54a3e184a5e126bbbdd95f984881a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, cl@linux.com,
        tglx@linutronix.de, fweisbec@gmail.com, mingo@kernel.org,
        hpa@zytor.com, kosaki.motohiro@jp.fujitsu.com, riel@redhat.com,
        oleg@redhat.com, sgruszka@redhat.com, tj@kernel.org,
        torvalds@linux-foundation.org
Reply-To: linux-kernel@vger.kernel.org, peterz@infradead.org, cl@linux.com,
        tglx@linutronix.de, fweisbec@gmail.com, mingo@kernel.org,
        oleg@redhat.com, riel@redhat.com, kosaki.motohiro@jp.fujitsu.com,
        hpa@zytor.com, torvalds@linux-foundation.org, sgruszka@redhat.com,
        tj@kernel.org
In-Reply-To: <20141112113737.GI10476@twins.programming.kicks-ass.net>
References: <20141112113737.GI10476@twins.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched/cputime: Fix cpu_timer_sample_group()
  double accounting
Git-Commit-ID: 23cfa361f3e54a3e184a5e126bbbdd95f984881a
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

Commit-ID:  23cfa361f3e54a3e184a5e126bbbdd95f984881a
Gitweb:     http://git.kernel.org/tip/23cfa361f3e54a3e184a5e126bbbdd95f984881a
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Wed, 12 Nov 2014 12:37:37 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 16 Nov 2014 10:04:18 +0100

sched/cputime: Fix cpu_timer_sample_group() double accounting

While looking over the cpu-timer code I found that we appear to add
the delta for the calling task twice, through:

  cpu_timer_sample_group()
    thread_group_cputimer()
      thread_group_cputime()
        times->sum_exec_runtime += task_sched_runtime();

    *sample = cputime.sum_exec_runtime + task_delta_exec();

Which would make the sample run ahead, making the sleep short.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rik van Riel <riel@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Link: http://lkml.kernel.org/r/20141112113737.GI10476@twins.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/kernel_stat.h    |  5 -----
 kernel/sched/core.c            | 13 -------------
 kernel/time/posix-cpu-timers.c |  2 +-
 3 files changed, 1 insertion(+), 19 deletions(-)

diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index 8422b4e..b9376cd 100644
--- a/include/linux/kernel_stat.h
+++ b/include/linux/kernel_stat.h
@@ -77,11 +77,6 @@ static inline unsigned int kstat_cpu_irqs_sum(unsigned int cpu)
 	return kstat_cpu(cpu).irqs_sum;
 }
 
-/*
- * Lock/unlock the current runqueue - to extract task statistics:
- */
-extern unsigned long long task_delta_exec(struct task_struct *);
-
 extern void account_user_time(struct task_struct *, cputime_t, cputime_t);
 extern void account_system_time(struct task_struct *, int, cputime_t, cputime_t);
 extern void account_steal_time(cputime_t);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 5f12ca6..797a6c8 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2499,19 +2499,6 @@ static u64 do_task_delta_exec(struct task_struct *p, struct rq *rq)
 	return ns;
 }
 
-unsigned long long task_delta_exec(struct task_struct *p)
-{
-	unsigned long flags;
-	struct rq *rq;
-	u64 ns = 0;
-
-	rq = task_rq_lock(p, &flags);
-	ns = do_task_delta_exec(p, rq);
-	task_rq_unlock(rq, p, &flags);
-
-	return ns;
-}
-
 /*
  * Return accounted runtime for the task.
  * In case the task is currently running, return the runtime plus current's
diff --git a/kernel/time/posix-cpu-timers.c b/kernel/time/posix-cpu-timers.c
index 492b986..a16b678 100644
--- a/kernel/time/posix-cpu-timers.c
+++ b/kernel/time/posix-cpu-timers.c
@@ -553,7 +553,7 @@ static int cpu_timer_sample_group(const clockid_t which_clock,
 		*sample = cputime_to_expires(cputime.utime);
 		break;
 	case CPUCLOCK_SCHED:
-		*sample = cputime.sum_exec_runtime + task_delta_exec(p);
+		*sample = cputime.sum_exec_runtime;
 		break;
 	}
 	return 0;
