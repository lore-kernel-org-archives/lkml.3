Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881AbaIBQuI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 12:50:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51111 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753524AbaIBQuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 12:50:06 -0400
Date: Tue, 2 Sep 2014 18:47:14 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Kautuk Consul <consul.kautuk@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, David Rientjes <rientjes@google.com>,
        Ionut Alexa <ionut.m.alexa@gmail.com>,
        Guillaume Morin <guillaume@morinfr.org>, linux-kernel@vger.kernel.org,
        Kirill Tkhai <tkhai@yandex.ru>
Subject: Re: [PATCH 1/1] do_exit(): Solve possibility of BUG() due to race
	with try_to_wake_up()
Message-ID: <20140902164714.GA17033@redhat.com>
References: <1408964064-21447-1-git-send-email-consul.kautuk@gmail.com> <20140825155738.GA5944@redhat.com> <20140901153935.GQ27892@worktop.ger.corp.intel.com> <20140901175851.GA15210@redhat.com> <20140901190931.GD5806@worktop.ger.corp.intel.com> <20140902155208.GA28668@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140902155208.GA28668@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02, Oleg Nesterov wrote:
>
> OK. So this patch should probably work. But let me think again and send
> it tommorrow. Because today (and yesterday) I didn't really sleep ;)

But since I already wrote v2 yesterday, let me show it anyway. Perhaps
you will notice something wrong immediately...

So, once again, this patch adds the ugly "goto" into schedule(). OTOH,
it removes the ugly spin_unlock_wait(pi_lock).

TASK_DEAD can die. The only valid user is schedule_debug(), trivial to
change. The usage of TASK_DEAD in task_numa_fault() is wrong in any case.

In fact, I think that the next change can change exit_schedule() to use
PREEMPT_ACTIVE, and then we can simply remove the TASK_DEAD check in
schedule_debug().

Oleg.


diff --git a/include/linux/sched.h b/include/linux/sched.h
index 857ba40..ef47159 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2407,6 +2407,7 @@ extern int copy_thread(unsigned long, unsigned long, unsigned long,
 			struct task_struct *);
 extern void flush_thread(void);
 extern void exit_thread(void);
+extern void exit_schedule(void) __noreturn;
 
 extern void exit_files(struct task_struct *);
 extern void __cleanup_sighand(struct sighand_struct *);
diff --git a/kernel/exit.c b/kernel/exit.c
index 32c58f7..75c994f 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -815,29 +815,8 @@ void do_exit(long code)
 		__this_cpu_add(dirty_throttle_leaks, tsk->nr_dirtied);
 	exit_rcu();
 
-	/*
-	 * The setting of TASK_RUNNING by try_to_wake_up() may be delayed
-	 * when the following two conditions become true.
-	 *   - There is race condition of mmap_sem (It is acquired by
-	 *     exit_mm()), and
-	 *   - SMI occurs before setting TASK_RUNINNG.
-	 *     (or hypervisor of virtual machine switches to other guest)
-	 *  As a result, we may become TASK_RUNNING after becoming TASK_DEAD
-	 *
-	 * To avoid it, we have to wait for releasing tsk->pi_lock which
-	 * is held by try_to_wake_up()
-	 */
-	smp_mb();
-	raw_spin_unlock_wait(&tsk->pi_lock);
-
-	/* causes final put_task_struct in finish_task_switch(). */
-	tsk->state = TASK_DEAD;
 	tsk->flags |= PF_NOFREEZE;	/* tell freezer to ignore us */
-	schedule();
-	BUG();
-	/* Avoid "noreturn function does return".  */
-	for (;;)
-		cpu_relax();	/* For when BUG is null */
+	exit_schedule();
 }
 EXPORT_SYMBOL_GPL(do_exit);
 
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index eee12b3..0a422e6 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2205,22 +2205,11 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	__releases(rq->lock)
 {
 	struct mm_struct *mm = rq->prev_mm;
-	long prev_state;
+	bool prev_dead = rq->prev_dead;
 
 	rq->prev_mm = NULL;
+	rq->prev_dead = false;
 
-	/*
-	 * A task struct has one reference for the use as "current".
-	 * If a task dies, then it sets TASK_DEAD in tsk->state and calls
-	 * schedule one last time. The schedule call will never return, and
-	 * the scheduled task must drop that reference.
-	 * The test for TASK_DEAD must occur while the runqueue locks are
-	 * still held, otherwise prev could be scheduled on another cpu, die
-	 * there before we look at prev->state, and then the reference would
-	 * be dropped twice.
-	 *		Manfred Spraul <manfred@colorfullife.com>
-	 */
-	prev_state = prev->state;
 	vtime_task_switch(prev);
 	finish_arch_switch(prev);
 	perf_event_task_sched_in(prev, current);
@@ -2230,7 +2219,7 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
 	fire_sched_in_preempt_notifiers(current);
 	if (mm)
 		mmdrop(mm);
-	if (unlikely(prev_state == TASK_DEAD)) {
+	if (unlikely(prev_dead)) {
 		if (prev->sched_class->task_dead)
 			prev->sched_class->task_dead(prev);
 
@@ -2771,10 +2760,14 @@ need_resched:
 	raw_spin_lock_irq(&rq->lock);
 
 	switch_count = &prev->nivcsw;
+	if (unlikely(rq->prev_dead))
+		goto deactivate;
+
 	if (prev->state && !(preempt_count() & PREEMPT_ACTIVE)) {
 		if (unlikely(signal_pending_state(prev->state, prev))) {
 			prev->state = TASK_RUNNING;
 		} else {
+deactivate:
 			deactivate_task(rq, prev, DEQUEUE_SLEEP);
 			prev->on_rq = 0;
 
@@ -2826,6 +2819,14 @@ need_resched:
 		goto need_resched;
 }
 
+void exit_schedule(void)
+{
+	current->state = TASK_DEAD; /* TODO: kill TASK_DEAD altogether */
+	task_rq(current)->prev_dead = true;
+	__schedule();
+	BUG();
+}
+
 static inline void sched_submit_work(struct task_struct *tsk)
 {
 	if (!tsk->state || tsk_is_pi_blocked(tsk))
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 579712f..b97f98e 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -560,6 +560,7 @@ struct rq {
 	struct task_struct *curr, *idle, *stop;
 	unsigned long next_balance;
 	struct mm_struct *prev_mm;
+	bool prev_dead;
 
 	u64 clock;
 	u64 clock_task;

