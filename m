Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761986Ab3ECMeh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 08:34:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47748 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761785Ab3ECMef (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 08:34:35 -0400
Message-ID: <5183AECF.4070709@redhat.com>
Date: Fri, 03 May 2013 08:34:23 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: LKML <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Yinghai Lu <yhlu.kernel@gmail.com>,
        Dave Jones <davej@codemonkey.org.uk>
Subject: Re: [PATCH] NOHZ, check to see if tick device is initialized in IRQ
 handling path
References: <1367325415-32283-1-git-send-email-prarit@redhat.com> <alpine.LFD.2.02.1305030054530.2891@ionos> <alpine.LFD.2.02.1305030923300.2886@ionos>
In-Reply-To: <alpine.LFD.2.02.1305030923300.2886@ionos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 05/03/2013 04:10 AM, Thomas Gleixner wrote:
> On Fri, 3 May 2013, Thomas Gleixner wrote:
> 
>> On Tue, 30 Apr 2013, Prarit Bhargava wrote:
>>
>>> 2nd try at this ... going with a more global cc.
>>>
>>> I think the linux.git "system hang" isn't really a hang.  For some reason the
>>> panic text wasn't displayed on the console.  I've seen this behaviour a few
>>> times now ... maybe there's a bug in the panic output path?
>>>
>>> It seems that the power interrupt is an error with the CPU exceeded the
>>> OSes current requested frequency on the package.  If I disable on demand
>>> cpu frequency, the problem goes away.
>>
>> Huch?
>>  
>>> Anyhoo, here's a patch...
>>>
>>> ----8<----
>>>
>>> When adding a CPU there is a small window in which interrupts are enabled and
>>> the clock tick device has not been initialized.  If an interrupt occurs in
>>
>> What's that small window and why does it exist?
>>
>>> this window, irq_exit() will be called which calls tick_nohz_irq_exit() which
>>> in turn calls __tick_nohz_idle_enter().
>>>
>>> __tick_nohz_idle() enter assumes that the tick has been initialized.  In the
>>> above case, however, it has not and this leads to what appears to be a system
>>> hang on latest linux.git or a the following panic on RHEL6:
>>>
>>> Pid: 0, comm: swapper Not tainted 2.6.32-358.el6.x86_64 #1
>>> RIP: 0010:[<ffffffff810a89e5>]  [<ffffffff810a89e5>] tick_nohz_stop_sched_tick+0x2a5/0x3e0
>>> RSP: 0018:ffff88089c503f38  EFLAGS: 00010046
>>> RAX: ffffffff81c07520 RBX: ffff88089c5116a0 RCX: 000002f04bb18cd8
>>> RDX: 0000000000000000 RSI: 000000000000a1b5 RDI: 000002f04bb0eb23
>>> RBP: ffff88089c503f88 R08: ffff88089c50e060 R09: 0000000000000000
>>> R10: 0000000000000001 R11: 0000000000000000 R12: 0000000000000017
>>> R13: 000002f04bb17dd5 R14: 0000000000000000 R15: 0000000000000092
>>> FS:  0000000000000000(0000) GS:ffff88089c500000(0000) knlGS:0000000000000000
>>> CS:  0010 DS: 0018 ES: 0018 CR0: 000000008005003b
>>> CR2: 0000000000000078 CR3: 0000000001a85000 CR4: 00000000001406e0
>>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>>> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>>> Process swapper (pid: 0, threadinfo ffff8810745c0000, task ffff8808740f2080)
>>> Stack:
>>>  00000000000116a0 0000000000000087 ffff88089c503f78 0000000000000046
>>> <d> ffff88089c503f98 0000000000000000 0000000000000000 0000000000000000
>>> <d> 0000000000000000 0000000000000000 ffff88089c503f98 ffffffff81076d86
>>> Call Trace:
>>>  <IRQ>
>>>  [<ffffffff81076d86>] irq_exit+0x76/0x90
>>>  [<ffffffff81028dd6>] smp_thermal_interrupt+0x26/0x40
>>>  [<ffffffff8100bcf3>] thermal_interrupt+0x13/0x20
>>>  <EOI>
>>>  [<ffffffff81506997>] ? start_secondary+0x127/0x2ef
>>>  [<ffffffff81506990>] ? start_secondary+0x120/0x2ef
>>>
>>> The code currently assumes that the tick device is initialized when
>>> irq_enter() and irq_exit() are called.  This is not correct and a check must
>>> be performed prior to entering the tick code through these code paths to
>>> ensure that the tick device is initialized and running.
>>>
>>> I've only seen this occur on a few systems.  I've tested with and without the
>>> patch and as far as I can tell this patch resolves the problem on
>>> linux.git top of tree.
>>>
>>> Signed-off-by: Prarit Bhargava <prarit@redhat.com>
>>> Cc: Thomas Gleixner <tglx@linutronix.de>
>>> Cc: John Stultz <john.stultz@linaro.org>
>>> ---
>>>  kernel/time/tick-sched.c |   12 ++++++++++++
>>>  1 file changed, 12 insertions(+)
>>>
>>> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
>>> index a19a399..5027187 100644
>>> --- a/kernel/time/tick-sched.c
>>> +++ b/kernel/time/tick-sched.c
>>> @@ -567,6 +567,12 @@ EXPORT_SYMBOL_GPL(tick_nohz_idle_enter);
>>>  void tick_nohz_irq_exit(void)
>>>  {
>>>  	struct tick_sched *ts = &__get_cpu_var(tick_cpu_sched);
>>> +	struct clock_event_device *dev =
>>> +				     __get_cpu_var(tick_cpu_device).evtdev;
>>> +
>>> +	/* Has the tick been initialized yet? */
>>> +	if (unlikely(!dev || dev->mode == CLOCK_EVT_MODE_UNUSED))
>>> +		return;
>>>  
>>>  	if (!ts->inidle)
>>>  		return;
> 
> This does not make any sense at all.
> 
> If ts->inidle is set, then the cpu has entered the idle loop. The
> local apic timer is registered _BEFORE_ the idle loop is reached. So
> how would dev end up being NULL?

I see ... AFAICT the cpu hasn't even hit the idle loop in this case and we take
a thermal interrupt (see explanation below).

> 
> So even if an interrupt hits right before we register the local APIC
> timer, ts->inidle cannot be set.
> 
> The same is true for tick_check_idle(). The cpu cannot be in the
> broadcast mask _BEFORE_ it went deep idle (from the idle loop) and
> neither ts->idle_active nor ts->tick_stopped can be set.
> 
> So there is something else wrong and you're just papering over the the
> underlying issue.
> 
> Can you please instrument the order of events (apic registration etc),
> so we can see what goes wrong.

Sorry, I should have done that in the original submit.  The sequence of events
is this ...

Down a cpu and then bring it back up.

On the cpu_up sequence, start_secondary() is called.  The cpu is set up is
marked online, etc..

In start_secondary() at arch/x86/kernel/smpboot.c: line 279 we enable interrupts
on the cpu, and then at arch/x86/kernel/smpboot.c: line 284 we setup the tick
device and initialize evtdev.

In between these two, if the CPU takes an interrupt (in my case it appears to be
a non-fatal power warning interrupt, see
arch/x86/kernel/cpu/mcheck/therm_throt.c) the IRQ handling code is called.

Since we're handling an IRQ, on the exit path, irq_exit() will be called, which
does the following at kernel/softirq.c,

#ifdef CONFIG_NO_HZ
        /* Make sure that timer wheel updates are propagated */
        if (idle_cpu(smp_processor_id()) && !in_interrupt() && !need_resched())
                tick_nohz_irq_exit();
#endif

tick_nohz_irq_exit() calls __tick_nohz_idle_enter(), which calls
tick_nohz_stop_sched_tick() and then uses the evtdev ... which again, AFAICT
from the stack trace is NULL.

This "feels" like a race between taking an interrupt and setting up the tick
device.

I think I understand your point about ts->inidle -- I wonder if this is some odd
situation with stale data when we bring the cpu down and then back up?  I'll go
take instrument the code and see what happens.

Obviously I'm willing to hear other suggestions on debugging -- tglx, if you
have any please let me know ...

P.




> 
> Thanks,
> 
> 	tglx
> 
> 
