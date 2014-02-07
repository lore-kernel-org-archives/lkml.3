Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119AbaBGLpH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:45:07 -0500
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:48251 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105AbaBGLpD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:45:03 -0500
Message-ID: <52F4C666.4050308@linux.vnet.ibm.com>
Date: Fri, 07 Feb 2014 17:11:26 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Nicolas Pitre <nicolas.pitre@linaro.org>
CC: Lists linaro-kernel <linaro-kernel@lists.linaro.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 1/2] PPC: powernv: remove redundant cpuidle_idle_call()
References: <1391696188-14540-1-git-send-email-nicolas.pitre@linaro.org> <CAKnoXLxCAqKaniGOwegNcOarS4FpoNKDY5PxOhe6j4wdtUAkLQ@mail.gmail.com> <52F3BCFE.3010703@linux.vnet.ibm.com> <alpine.LFD.2.11.1402070105170.1906@knanqh.ubzr> <52F46EB3.5080403@linux.vnet.ibm.com> <alpine.LFD.2.11.1402071022490.1906@knanqh.ubzr>
In-Reply-To: <alpine.LFD.2.11.1402071022490.1906@knanqh.ubzr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14020711-5490-0000-0000-000004E84EC8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nicolas,

On 02/07/2014 04:18 PM, Nicolas Pitre wrote:
> On Fri, 7 Feb 2014, Preeti U Murthy wrote:
> 
>> Hi Nicolas,
>>
>> On 02/07/2014 06:47 AM, Nicolas Pitre wrote:
>>>
>>> What about creating arch_cpu_idle_enter() and arch_cpu_idle_exit() in 
>>> arch/powerpc/kernel/idle.c and calling ppc64_runlatch_off() and 
>>> ppc64_runlatch_on() respectively from there instead?  Would that work?  
>>> That would make the idle consolidation much easier afterwards.
>>
>> I would not suggest doing this. The ppc64_runlatch_*() routines need to
>> be called when we are sure that the cpu is about to enter or has exit an
>> idle state. Moving the ppc64_runlatch_on() routine to
>> arch_cpu_idle_enter() for instance is not a good idea because there are
>> places where the cpu can decide not to enter any idle state before the
>> call to cpuidle_idle_call() itself. In that case communicating
>> prematurely that we are in an idle state would not be a good idea.
>>
>> So its best to add the ppc64_runlatch_* calls in the powernv cpuidle
>> driver IMO. We could however create idle_loop_prologue/epilogue()
>> variants inside it so that in addition to the runlatch routines we could
>> potentially add more such similar routines that are powernv specific.
>>   If there are cases where there is work to be done prior to and post an
>> entry into an idle state common to both pseries and powernv, we will
>> probably put them in arch_cpu_idle_enter/exit(). But the runlatch
>> routines are not suitable to be moved there as far as I can see.
> 
> OK.
> 
> However, one thing we need to do as much as possible is to remove those 
> loops based on need_resched() from idle backend drivers.  A somewhat 
> common pattern is:
> 
> my_idle()
> {
> 	/* interrupts disabled on entry */
> 	while (!need_resched()) {
> 		lowpower_wait_for_interrupts();
> 		local_irq_enable();
> 		/* IRQ serviced from here */
> 		local_irq_disable();
> 	}
> 	local_irq_enable();
> 	/* interrupts enabled on exit */
> }
> 
> To be able to keep statistics on the actual idleness of the CPU we'd 
> need for all idle backends to always return to generic code on every 
> interrupt similar to this:
> 
> my_idle()
> {
> 	/* interrupts disabled on entry */
> 	lowpower_wait_for_interrupts();

You can do this for the idle states which do not have the polling
nature. IOW, these idle states are capable of doing what you describe as
"wait_for_interrupts". They do some kind of spinning at the hardware
level with interrupts enabled. A reschedule IPI or any other interrupt
will wake them up to enter the generic idle loop where they check for
the cause of the interrupt.

But observe the idle state "snooze" on powerpc. The power that this idle
state saves is through the lowering of the thread priority of the CPU.
After it lowers the thread priority, it is done. It cannot
"wait_for_interrupts". It will exit my_idle(). It is now upto the
generic idle loop to increase the thread priority if the need_resched
flag is set. Only an interrupt routine can increase the thread priority.
Else we will need to do it explicitly. And in such states which have a
polling nature, the cpu will not receive a reschedule IPI.

That is why in the snooze_loop() we poll on need_resched. If it is set
we up the priority of the thread using HMT_MEDIUM() and then exit the
my_idle() loop. In case of interrupts, the priority gets automatically
increased.

This might not be required to be done for similar idle routines on other
archs but this is the consequence of applying this idea of simplified
cpuidle backend driver on powerpc.

I would say you could let the backend cpuidle drivers be in this regard,
it could complicate the generic idle loop IMO depending on how the
polling states are implemented in each architecture.


> The generic code would be responsible for dealing with need_resched() 
> and call back into the backend right away if necessary after updating 
> some stats.
> 
> Do you see a problem with the runlatch calls happening around each 
> interrrupt from such a simplified idle backend?

The runlatch calls could be moved outside the loop.They do not need to
be called each time.

Thanks

Regards
Preeti U Murthy
> 
> 
> Nicolas
> 

