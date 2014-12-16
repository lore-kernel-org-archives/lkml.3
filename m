Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751341AbaLPJgp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 04:36:45 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:46111 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbaLPJgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 04:36:42 -0500
Message-ID: <548FFD20.1040102@linux.vnet.ibm.com>
Date: Tue, 16 Dec 2014 15:06:32 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Viresh Kumar <viresh.kumar@linaro.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        "Pan, Jacob jun" <jacob.jun.pan@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, LKP <lkp@01.org>
Subject: Re: [nohz] 2a16fc93d2c: kernel lockup on idle injection
References: <20141211194204.GA19083@wfg-t540p.sh.intel.com> <CAKohpokEw6f5+u8J_AoV76sOAQO=J8dGhX1eZb=QZOuE+Jhq_A@mail.gmail.com> <548E8D01.9050707@linux.vnet.ibm.com> <CAKohpo=C8Jv-+CtmDO+QJ-_=3dNwsk6_W0gtRRHmtSQ8_LgObQ@mail.gmail.com> <20141215234443.GA23297@lerouge> <CAKohpokOuOqvpNt4_y2tHPTM8nKLyEg=-gN4NDe1_mqpy=Vrow@mail.gmail.com>
In-Reply-To: <CAKohpokOuOqvpNt4_y2tHPTM8nKLyEg=-gN4NDe1_mqpy=Vrow@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14121609-0009-0000-0000-0000072F89A0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/16/2014 10:23 AM, Viresh Kumar wrote:
> + Peter from Jacob's mail ..
> 
> On 16 December 2014 at 05:14, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>> So to summarize: I see it enqueues a timer then it loops on that timer expiration.
>> On that loop we stop the CPU and we expect the timer to fire and wake the thread up.
>> But if the delayed tick fires too early, before the timer actually
>> expires, then we go to sleep again because we haven't yet reached the delay,
>> but since tick_nohz_irq_exit() is only called on idle tasks and not for threads
>> like powerclamp, the tick isn't rescheduled to handle the remaining timer slice
>> so we sleep forever.
> 
> Perfect !!
> 
>> Hence if we really want to stop the tick when we mimic idle from powerclamp driver,
>> we must call tick_nohz_irq_exit() on irq exit to do it correctly.
>>
>> It happened to work by accident before the commit because we were rescheduling the
>> tick from itself without tick_nohz_irq_exit() to cancel anything. And that restored
>> the periodic behaviour necessary to complete the delay.
>>
>> So the above change is rather a hack than a solution.
>>
>> We have several choices:
>>
>> 1) Revert the commit. But this has to be a temporary solution really. Powerclamp has
>> to be fixed and handle tick_nohz_irq_exit().
>>
>> 2) Remove powerclamp tick stop until somebody fixes it to handle nohz properly.
>>
>> 2) Fix it directly. But I believe there is a release that is going to miss the fix
>> and suffer the regression. Does the regression matter for anybody? Is powerclamp
>> meant for anything else than testing (I have no idea what it's used for)?
>>
>> So to fix powerclamp to handle nohz correctly, tick_nohz_irq_exit() must be called
>> for both idle tasks and powerclamp kthreads. Checking ts->inidle can be a good way to match

As far as I can see, the primary purpose of tick_nohz_irq_enter()/exit()
paths was to take care of *tick stopped* cases.

Before handling interrupts we would want jiffies to be updated, which is
done in tick_nohz_irq_enter(). And after handling interrupts we need to
verify if any timers/RCU callbacks were queued during an interrupt.
Both of these will not be handled properly
*only when the tick is stopped* right?

If so, the checks which permit entry into these functions should at a
minimum include a check on ts->tick_stopped(). The rest of the checks
around if the CPU is idle/need_resched() may be needed in conjunction,
but will not be complete without checking if ticks are stopped. I see
that tick_nohz_irq_enter() has a check on ts->tick_stopped, which is
correct, but tick_noz_irq_exit() does not.

Adding this check to tick_nohz_irq_exit() will not only solve this
regression but is probably a fix to a long standing bug in the
conditional check in tick_nohz_irq_exit().

>> both. That means we might need to use a reduced part of idle_cpu() to avoid redundant checks.
>> tick_irq_enter() must be called as well for powerclamp, in case it's the only CPU running, it
>> has to fixup the timekeeping alone.
> 
> Yeah, you can call my fix a Hacky one. I agree..
> 
> But I don't know if calling tick_nohz_irq_exit() from these threads wouldn't
> be hacky as well. And ofcourse my knowledge wouldn't be adequate here to
> judge that :)
> 
> It looked a bit odd to me. Why should we call irq-exit from the threads working
> with idle? And that's not what we do even for the real-idle loop as well ..
> 
> Also from Jacob's referenced patch, we would be moving to a consolidated
> idle-loop for both real idle and threads like powerclamp, and this part may be
> tricky then..
> 
> Untested, but what about something like this?
> 
> diff --git a/kernel/softirq.c b/kernel/softirq.c
> index 5918d227730f..5e4bfc367735 100644
> --- a/kernel/softirq.c
> +++ b/kernel/softirq.c
> @@ -321,7 +321,7 @@ asmlinkage __visible void do_softirq(void)
>  void irq_enter(void)
>  {
>         rcu_irq_enter();
> -       if (is_idle_task(current) && !in_interrupt()) {
> +       if (tick_idle_active() && !in_interrupt()) {
>                 /*
>                  * Prevent raise_softirq from needlessly waking up ksoftirqd
>                  * here, as softirq will be serviced on return from interrupt.
> @@ -363,7 +363,7 @@ static inline void tick_irq_exit(void)
>         int cpu = smp_processor_id();
> 
>         /* Make sure that timer wheel updates are propagated */
> -       if ((idle_cpu(cpu) && !need_resched()) || tick_nohz_full_cpu(cpu)) {
> +       if ((tick_idle_active() && !need_resched()) ||

For reasons mentioned above, this check alone will not do. It may solve
this regression,but the check is incomplete.

IMO it should simply be :
if (tick_nohz_tick_stopped() || tick_nohz_full_cpu())

Regards
Preeti U Murthy


