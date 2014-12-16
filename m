Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751512AbaLPExQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 23:53:16 -0500
Received: from mail-ob0-f175.google.com ([209.85.214.175]:37918 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915AbaLPExO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 23:53:14 -0500
MIME-Version: 1.0
In-Reply-To: <20141215234443.GA23297@lerouge>
References: <20141211194204.GA19083@wfg-t540p.sh.intel.com>
	<CAKohpokEw6f5+u8J_AoV76sOAQO=J8dGhX1eZb=QZOuE+Jhq_A@mail.gmail.com>
	<548E8D01.9050707@linux.vnet.ibm.com>
	<CAKohpo=C8Jv-+CtmDO+QJ-_=3dNwsk6_W0gtRRHmtSQ8_LgObQ@mail.gmail.com>
	<20141215234443.GA23297@lerouge>
Date: Tue, 16 Dec 2014 10:23:14 +0530
Message-ID: <CAKohpokOuOqvpNt4_y2tHPTM8nKLyEg=-gN4NDe1_mqpy=Vrow@mail.gmail.com>
Subject: Re: [nohz] 2a16fc93d2c: kernel lockup on idle injection
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, LKP <lkp@01.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ Peter from Jacob's mail ..

On 16 December 2014 at 05:14, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> So to summarize: I see it enqueues a timer then it loops on that timer expiration.
> On that loop we stop the CPU and we expect the timer to fire and wake the thread up.
> But if the delayed tick fires too early, before the timer actually
> expires, then we go to sleep again because we haven't yet reached the delay,
> but since tick_nohz_irq_exit() is only called on idle tasks and not for threads
> like powerclamp, the tick isn't rescheduled to handle the remaining timer slice
> so we sleep forever.

Perfect !!

> Hence if we really want to stop the tick when we mimic idle from powerclamp driver,
> we must call tick_nohz_irq_exit() on irq exit to do it correctly.
>
> It happened to work by accident before the commit because we were rescheduling the
> tick from itself without tick_nohz_irq_exit() to cancel anything. And that restored
> the periodic behaviour necessary to complete the delay.
>
> So the above change is rather a hack than a solution.
>
> We have several choices:
>
> 1) Revert the commit. But this has to be a temporary solution really. Powerclamp has
> to be fixed and handle tick_nohz_irq_exit().
>
> 2) Remove powerclamp tick stop until somebody fixes it to handle nohz properly.
>
> 2) Fix it directly. But I believe there is a release that is going to miss the fix
> and suffer the regression. Does the regression matter for anybody? Is powerclamp
> meant for anything else than testing (I have no idea what it's used for)?
>
> So to fix powerclamp to handle nohz correctly, tick_nohz_irq_exit() must be called
> for both idle tasks and powerclamp kthreads. Checking ts->inidle can be a good way to match
> both. That means we might need to use a reduced part of idle_cpu() to avoid redundant checks.
> tick_irq_enter() must be called as well for powerclamp, in case it's the only CPU running, it
> has to fixup the timekeeping alone.

Yeah, you can call my fix a Hacky one. I agree..

But I don't know if calling tick_nohz_irq_exit() from these threads wouldn't
be hacky as well. And ofcourse my knowledge wouldn't be adequate here to
judge that :)

It looked a bit odd to me. Why should we call irq-exit from the threads working
with idle? And that's not what we do even for the real-idle loop as well ..

Also from Jacob's referenced patch, we would be moving to a consolidated
idle-loop for both real idle and threads like powerclamp, and this part may be
tricky then..

Untested, but what about something like this?

diff --git a/kernel/softirq.c b/kernel/softirq.c
index 5918d227730f..5e4bfc367735 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -321,7 +321,7 @@ asmlinkage __visible void do_softirq(void)
 void irq_enter(void)
 {
        rcu_irq_enter();
-       if (is_idle_task(current) && !in_interrupt()) {
+       if (tick_idle_active() && !in_interrupt()) {
                /*
                 * Prevent raise_softirq from needlessly waking up ksoftirqd
                 * here, as softirq will be serviced on return from interrupt.
@@ -363,7 +363,7 @@ static inline void tick_irq_exit(void)
        int cpu = smp_processor_id();

        /* Make sure that timer wheel updates are propagated */
-       if ((idle_cpu(cpu) && !need_resched()) || tick_nohz_full_cpu(cpu)) {
+       if ((tick_idle_active() && !need_resched()) ||
tick_nohz_full_cpu(cpu)) {
                if (!in_interrupt())
                        tick_nohz_irq_exit();
        }
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index 07c2bad0afce..e52b76037c0a 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -46,6 +46,13 @@ struct tick_sched *tick_get_tick_sched(int cpu)
        return &per_cpu(tick_cpu_sched, cpu);
 }

+bool tick_idle_active(void)
+{
+       struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
+
+       return ts->idle_active;
+}
+
 /*
  * Must be called with interrupts disabled !
  */


I am not sure of the purpose of the idle-checks in the irq-paths.
All I understood from git logs is, these are to check if we
came out of dynticks mode and need to start/stop ticks again..

Then why not handle these idle mimicking threads as well?
We just need to check ts->idle_active which will take care of both
the cases, real idle and these threads..

Sorry, if this will break things further :(

--
viresh
