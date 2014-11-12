Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752410AbaKLLhr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 06:37:47 -0500
Received: from casper.infradead.org ([85.118.1.10]:43463 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319AbaKLLhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 06:37:45 -0500
Date: Wed, 12 Nov 2014 12:37:37 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] sched/cputime: fix clock_nanosleep/clock_gettime
 inconsistency
Message-ID: <20141112113737.GI10476@twins.programming.kicks-ass.net>
References: <1415788168-3165-1-git-send-email-sgruszka@redhat.com>
 <20141112111553.GA21343@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141112111553.GA21343@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 12:15:53PM +0100, Peter Zijlstra wrote:
> On Wed, Nov 12, 2014 at 11:29:28AM +0100, Stanislaw Gruszka wrote:

> > Issue happens because on start in thread_group_cputimer() we initialize
> > sum_exec_runtime of cputimer with threads runtime not yet accounted and
> > then add the threads runtime again on scheduler tick. When cputimer
> > finish, it's sum_exec_runtime value is bigger than current sum counted
> > by iterating over the threads in thread_group_cputime().

I'm not seeing how that can happen. We iterate each task once, for each
task we grab sum_exec_runtime + whatever delta.

It doesnt matter if a later interrupt or whatever folds the delta into
sum_exec_runtime, we never look at it again.

What I did found is that we appear to add the delta for the calling task
twice, through:

  cpu_timer_sample_group()
    thread_group_cputimer()
      thread_group_cputime()
        times->sum_exec_runtime += task_sched_runtime();

    *sample = cputime.sum_exec_runtime + task_delta_exec();

Which would make the sample run ahead, making the sleep short. So would
something like the below not cure things?

---
 include/linux/kernel_stat.h    |  5 -----
 kernel/sched/core.c            | 13 -------------
 kernel/time/posix-cpu-timers.c |  2 +-
 3 files changed, 1 insertion(+), 19 deletions(-)

diff --git a/include/linux/kernel_stat.h b/include/linux/kernel_stat.h
index 8422b4ed6882..b9376cd5a187 100644
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
index 5df22f1da07d..85ff99db2591 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2481,19 +2481,6 @@ static u64 do_task_delta_exec(struct task_struct *p, struct rq *rq)
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
index 492b986195d5..a16b67859e2a 100644
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
