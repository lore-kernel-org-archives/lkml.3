Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757351Ab3GOOOj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 10:14:39 -0400
Received: from forward4.mail.yandex.net ([77.88.46.9]:51455 "EHLO
	forward4.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757139Ab3GOOOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 10:14:38 -0400
From: Kirill Tkhai <tkhai@yandex.ru>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>
In-Reply-To: <20130715063150.GL17211@twins.programming.kicks-ass.net>
References: <1517081373730349@web23d.yandex.ru> <20130715063150.GL17211@twins.programming.kicks-ass.net>
Subject: Re: [PATCH] sched: Add logic to handle parallel try_to_wake_up() of the same task
MIME-Version: 1.0
Message-Id: <449471373897674@web23d.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Mon, 15 Jul 2013 18:14:34 +0400
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Peter,

15.07.2013, 10:32, "Peter Zijlstra" <peterz@infradead.org>:
> On Sat, Jul 13, 2013 at 07:45:49PM +0400, Kirill Tkhai wrote:
>
>> š---
>> ššinclude/linux/sched.h | ššš1 +
>> šškernel/sched/core.c šš| šš29 +++++++++++++++++++++++++----
>> šškernel/sched/debug.c š| ššš7 +++++++
>> šškernel/sched/stats.h š| šš16 ++++++++++++++++
>> šš4 files changed, 49 insertions(+), 4 deletions(-)
>> šdiff --git a/include/linux/sched.h b/include/linux/sched.h
>> šindex fc09d21..235a466 100644
>> š--- a/include/linux/sched.h
>> š+++ b/include/linux/sched.h
>> š@@ -964,6 +964,7 @@ struct sched_statistics {
>> ššššššššššu64 nr_wakeups_affine_attempts;
>> ššššššššššu64 nr_wakeups_passive;
>> ššššššššššu64 nr_wakeups_idle;
>> š+ atomic_t nr_wakeups_parallel;
>
> bad idea.. atomics are expensive and stats aren't generally _that_
> important.
>
>> šš};
>> šš#endif
>>
>> šdiff --git a/kernel/sched/core.c b/kernel/sched/core.c
>> šindex 9d06ad6..1e1475f 100644
>> š--- a/kernel/sched/core.c
>> š+++ b/kernel/sched/core.c
>> š@@ -1336,6 +1336,11 @@ ttwu_do_wakeup(struct rq *rq, struct task_struct *p, int wake_flags)
>>
>> ššššššššššp->state = TASK_RUNNING;
>> šš#ifdef CONFIG_SMP
>> š+ /*
>> š+ * Pair bracket with TASK_WAKING check it try_to_wake_up()
>> š+ */
>> š+ smp_wmb();
>> š+
>
> Like Mike said, you're making the common case more expensive, this is
> not appreciated.
>
>> ššššššššššif (p->sched_class->task_woken)
>> ššššššššššššššššššp->sched_class->task_woken(rq, p);
>>
>> š@@ -1487,20 +1492,37 @@ static int
>> šštry_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
>> šš{
>> ššššššššššunsigned long flags;
>> š- int cpu, success = 0;
>> š+ int cpu, success = 1;
>>
>> š+ /*
>> š+ * See commentary for commit 04e2f1741d235ba599037734878d72e57cb302b5.
>
> That must be the worst barrier comment ever.. If you want it there, just
> copy/paste the commit log here. It is also completely unrelated to the
> rest of the patch.
>
>> š+ */
>> ššššššššššsmp_wmb();
>> š+#ifdef CONFIG_SMP
>> š+ if (p->state == TASK_WAKING) {
>> š+ /*
>> š+ * Pairs with sets of p->state: below and in ttwu_do_wakeup().
>> š+ */
>> š+ smp_rmb();
>> š+ inc_nr_parallel_wakeups(p);
>> š+ return success;
>
> This is wrong, you didn't change p->state, therefore returning 1 is not
> an option. If you want to do something like this, treat it like waking
> an already running task.
>
> Also, the barrier comments fail to explain the exact problem they're
> solving.
>
>> š+ }
>> š+#endif
>> ššššššššššraw_spin_lock_irqsave(&p->pi_lock, flags);
>> š- if (!(p->state & state))
>> š+ if (!(p->state & state)) {
>> š+ success = 0;
>> ššššššššššššššššššgoto out;
>> š+ }
>>
>> š- success = 1; /* we're going to change ->state */
>> ššššššššššcpu = task_cpu(p);
>>
>> ššššššššššif (p->on_rq && ttwu_remote(p, wake_flags))
>> ššššššššššššššššššgoto stat;
>>
>> šš#ifdef CONFIG_SMP
>> š+ p->state = TASK_WAKING;
>> š+ smp_wmb();
>> š+
>
> This too is broken; the loop below needs to be completed first,
> otherwise we change p->state while the task is still on the CPU and it
> might read the wrong p->state.

This place is below (on_rq && ttwu_remote) check, so the task
either 'dequeued and on_cpu == 0'
or it's in the middle of schedule() on arch, which wants unlocked
context switch.

Nobody scheduler's probes p->state between prepare_lock_switch() and
finish_lock_switch(). Archs with unlocked ctx switch (mips and ia64)
don't change or probe state of previous process during context_switch.

The only exception is TASK_DEAD case, but it is handled above
in 'p->state & state' check. Nobody passes TASK_DEAD to try_to_wake_up().

p->state might be changed outside from the scheduler. It's ptrace.
But, it doesn't look be touched by earlier TASK_WAKING set.

So, I don't see any problem with it. Peter, what do you really mean?

Other problems is easy to be fixed, all except common case overhead.
If it's really considerable in terms of scheduler, I'll be account this fact
in the future.

>> šššššššššš/*
>> ššššššššššš* If the owning (remote) cpu is still in the middle of schedule() with
>> ššššššššššš* this task as prev, wait until its done referencing the task.
>> š@@ -1513,7 +1535,6 @@ try_to_wake_up(struct task_struct *p, unsigned int state, int wake_flags)
>> ššššššššššsmp_rmb();
>>
>> ššššššššššp->sched_contributes_to_load = !!task_contributes_to_load(p);
>> š- p->state = TASK_WAKING;
>>
>> ššššššššššif (p->sched_class->task_waking)
>> ššššššššššššššššššp->sched_class->task_waking(p);
