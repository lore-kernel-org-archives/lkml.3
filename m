Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541AbaKLMwJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 07:52:09 -0500
Received: from casper.infradead.org ([85.118.1.10]:43875 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271AbaKLMwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 07:52:08 -0500
Date: Wed, 12 Nov 2014 13:51:58 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Oleg Nesterov <oleg@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] sched/cputime: fix clock_nanosleep/clock_gettime
 inconsistency
Message-ID: <20141112125158.GB21343@twins.programming.kicks-ass.net>
References: <1415788168-3165-1-git-send-email-sgruszka@redhat.com>
 <20141112111553.GA21343@twins.programming.kicks-ass.net>
 <20141112122155.GA3250@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141112122155.GA3250@redhat.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 01:21:56PM +0100, Stanislaw Gruszka wrote:
> > Why only these two thread_group_cputime() calls and not all others?
> 
> On other cases here we do not utilize sum_exec_runtime, but only utime
> and stime, which are not updated by update_curr().

That's one fragile ass interface. That's just asking for trouble, the
next person to want to use sum_exec_runtime will forget to add this call
and then we'll spend another few months/years until we figure out wtf
happened.

> I can fix 32 bit problem by introducing seq_lock around reading/writing 
> task sum_exec_runtime on 32 bits arches. And fix other issues you pointed.

No, that makes updating the sum_exec_runtime far more expensive than it
already is, and 99.9% of the time nobody cares.

> What do you think ?

I don't particularly like running the entirety of update_curr remotely,
but the NOHZ_FULL people need the same thing so we might as well do it
here.

Something like the below should then cure your issue without doing
horrible things.

---
 include/linux/kernel_stat.h    |  5 -----
 kernel/sched/core.c            | 49 +++++++++---------------------------------
 kernel/sched/deadline.c        |  2 ++
 kernel/sched/fair.c            |  7 ++++++
 kernel/sched/rt.c              |  2 ++
 kernel/sched/sched.h           |  2 ++
 kernel/time/posix-cpu-timers.c |  2 +-
 7 files changed, 24 insertions(+), 45 deletions(-)

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
index 5df22f1da07d..b708c4b1a02a 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2457,44 +2457,6 @@ EXPORT_PER_CPU_SYMBOL(kstat);
 EXPORT_PER_CPU_SYMBOL(kernel_cpustat);
 
 /*
- * Return any ns on the sched_clock that have not yet been accounted in
- * @p in case that task is currently running.
- *
- * Called with task_rq_lock() held on @rq.
- */
-static u64 do_task_delta_exec(struct task_struct *p, struct rq *rq)
-{
-	u64 ns = 0;
-
-	/*
-	 * Must be ->curr _and_ ->on_rq.  If dequeued, we would
-	 * project cycles that may never be accounted to this
-	 * thread, breaking clock_gettime().
-	 */
-	if (task_current(rq, p) && task_on_rq_queued(p)) {
-		update_rq_clock(rq);
-		ns = rq_clock_task(rq) - p->se.exec_start;
-		if ((s64)ns < 0)
-			ns = 0;
-	}
-
-	return ns;
-}
-
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
-/*
  * Return accounted runtime for the task.
  * In case the task is currently running, return the runtime plus current's
  * pending runtime that have not been accounted yet.
@@ -2522,7 +2484,16 @@ unsigned long long task_sched_runtime(struct task_struct *p)
 #endif
 
 	rq = task_rq_lock(p, &flags);
-	ns = p->se.sum_exec_runtime + do_task_delta_exec(p, rq);
+	/*
+	 * Must be ->curr _and_ ->on_rq.  If dequeued, we would
+	 * project cycles that may never be accounted to this
+	 * thread, breaking clock_gettime().
+	 */
+	if (task_current(rq, p) && task_on_rq_queued(p)) {
+		update_rq_clock(rq);
+		p->sched_class->update_curr(rq);
+	}
+	ns = p->se.sum_exec_runtime;
 	task_rq_unlock(rq, p, &flags);
 
 	return ns;
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index f3d7776656ee..b0911797422f 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -1747,6 +1747,8 @@ const struct sched_class dl_sched_class = {
 	.prio_changed           = prio_changed_dl,
 	.switched_from		= switched_from_dl,
 	.switched_to		= switched_to_dl,
+
+	.update_curr		= update_curr_dl,
 };
 
 #ifdef CONFIG_SCHED_DEBUG
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 826fdf326683..faa482ed264c 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -726,6 +726,11 @@ static void update_curr(struct cfs_rq *cfs_rq)
 	account_cfs_rq_runtime(cfs_rq, delta_exec);
 }
 
+static void update_curr_fair(struct rq *rq)
+{
+	update_curr(&rq->cfs);
+}
+
 static inline void
 update_stats_wait_start(struct cfs_rq *cfs_rq, struct sched_entity *se)
 {
@@ -8137,6 +8142,8 @@ const struct sched_class fair_sched_class = {
 
 	.get_rr_interval	= get_rr_interval_fair,
 
+	.update_curr		= update_curr_fair,
+
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	.task_move_group	= task_move_group_fair,
 #endif
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 3d14312db7ea..f1bb92fcc532 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -2134,6 +2134,8 @@ const struct sched_class rt_sched_class = {
 
 	.prio_changed		= prio_changed_rt,
 	.switched_to		= switched_to_rt,
+
+	.update_curr		= update_curr_rt,
 };
 
 #ifdef CONFIG_SCHED_DEBUG
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 31f1e4d2996a..9a2a45c970e7 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1177,6 +1177,8 @@ struct sched_class {
 	unsigned int (*get_rr_interval) (struct rq *rq,
 					 struct task_struct *task);
 
+	void (*update_curr) (struct rq *rq);
+
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	void (*task_move_group) (struct task_struct *p, int on_rq);
 #endif
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
