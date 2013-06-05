Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259Ab3FETLS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 15:11:18 -0400
Received: from mail.candelatech.com ([208.74.158.172]:52879 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757017Ab3FETLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 15:11:16 -0400
Message-ID: <51AF8D4B.4090407@candelatech.com>
Date: Wed, 05 Jun 2013 12:11:07 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Rusty Russell <rusty@rustcorp.com.au>,
        Joe Lawrence <joe.lawrence@stratus.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: Please add to stable:  module: don't unlink the module until
 we've removed all exposure.
References: <alpine.DEB.2.02.1306031012460.22652@jlaw-desktop.mno.stratus.com> <51ACBD6A.1030304@candelatech.com> <51ACC60B.8090504@candelatech.com> <87d2s2to4z.fsf@rustcorp.com.au> <20130604100744.7cdf8777@jlaw-desktop.mno.stratus.com> <51AE1B81.20900@candelatech.com> <51AE27D5.7050202@candelatech.com> <87sj0xry1k.fsf@rustcorp.com.au> <20130605071539.GA3429@mtj.dyndns.org> <51AF6E54.3050108@candelatech.com> <20130605184807.GD10693@mtj.dyndns.org>
In-Reply-To: <20130605184807.GD10693@mtj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2013 11:48 AM, Tejun Heo wrote:
> Hello, Ben.
>
> On Wed, Jun 05, 2013 at 09:59:00AM -0700, Ben Greear wrote:
>> One pattern I notice repeating for at least most of the hangs is that all but one
>> CPU thread has irqs disabled and is in state 2.  But, there will be one thread
>> in state 1 that still has IRQs enabled and it is reported to be in soft-lockup
>> instead of hard-lockup.  In 'sysrq l' it always shows some IRQ processing,
>> but typically that of the sysrq itself.  I added printk that would always
>> print if the thread notices that smdata->state != curstate, and the soft-lockup
>> thread (cpu 2 below) never shows that message.
>
> It sounds like one of the cpus get live-locked by IRQs.  I can't tell
> why the situation is made worse by other CPUs being tied up.  Do you
> ever see CPUs being live locked by IRQs during normal operation?

No, I have not noticed any live locks aside from this, at least in
the 3.9 kernels.

>> I thought it might be because it was reading stale smdata->state, so I changed
>> that to atomic_t hoping that would mitigate that.  I also tried adding smp_rmb()
>> below the cpu_relax().  Neither had any affect, so I am left assuming that the
>
> I looked at the code again and the memory accesses seem properly
> interlocked.  It's a bit tricky and should probably have used spinlock
> instead considering it's already a hugely expensive path anyway, but
> it does seem correct to me.
>
>> thread instead is stuck handling IRQs and never gets out of the IRQ handler.
>
> Seems that way to me too.
>
>> Maybe since I have 2 real cores, and 3 processes busy-spinning on their CPU cores,
>> the remaining process can just never handle all the IRQs and get back to the
>> cpu shutdown state machine?  The various soft-hang stacks below show at least slightly
>> different stacks, so I assume that thread is doing at least something.
>
> What's the source of all those IRQs tho?  I don't think the IRQs are
> from actual events.  The system is quiesced.  Even if it's from
> receiving packets, it's gonna quiet down pretty quickly.  The hang
> doesn't go away if you disconnect the network cable while hung, right?
>
> What could be happening is that IRQ handling is handled by a thread
> but the IRQ handler itself doesn't clear the IRQ properly and depends
> on the handling thread to clear the condition.  If no CPU is available
> for scheduling, it might end up raising and re-reraising IRQs for the
> same condition without ever being handled.  If that's the case, such
> lockup could happen on a normally functioning UP machine or if the IRQ
> is pinned to a single CPU which happens to be running the handling
> thread.  At any rate, it'd be a plain live-lock bug on the driver
> side.
>
> Can you please try to confirm the specific interrupt being
> continuously raised?  Detecting the hang shouldn't be too difficult.
> Just recording the starting jiffies and if progress hasn't been made
> for, say, ten seconds, it can set a flag and then print the IRQs being
> handled if the flag is set.  If it indeed is the ath device, we
> probably wanna get the driver maintainer involved.

I am not sure how to tell which IRQ is being handled.  Do the
stack traces (showing smp_apic_timer_interrupt, for instance)
indicate potential culprits, or is that more a symptom of just
when the soft-lockup check is called?


Where should I add code to print out irqs?  In the lockup state,
the thread (probably) stuck handling irqs isn't executing any code in
the stop_machine file as far as I can tell.

Maybe I need to instrument the __do_softirq or similar method?

For what it's worth, previous debugging appears to show that jiffies
stops incrementing in many of these lockups.

Also, I have been trying for 20+ minutes to reproduce the lockup
with the ath9k module removed (and my user-space app that uses it
stopped), and I have not reproduced it yet.  So, possibly it is
related to ath9k, but my user-space app pokes at lots of other
stuff and starts loads of dhcp client processes and such too,
so not sure yet.


Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

