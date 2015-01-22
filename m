Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817AbbAVGHk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 01:07:40 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:46504 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829AbbAVGHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 01:07:33 -0500
Message-ID: <54C09391.9080202@linux.vnet.ibm.com>
Date: Thu, 22 Jan 2015 11:37:13 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: aik@ozlabs.ru, shreyas@linux.vnet.ibm.com,
        LKML <linux-kernel@vger.kernel.org>, michael@ellerman.id.au,
        Anton Blanchard <anton@samba.org>, svaidy@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH V3] tick/broadcast: Make movement of broadcast hrtimer
 robust against hotplug
References: <20150120103559.8430.50933.stgit@preeti.in.ibm.com> <alpine.DEB.2.11.1501211243270.5526@nanos>
In-Reply-To: <alpine.DEB.2.11.1501211243270.5526@nanos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012206-0029-0000-0000-000001C342EC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2015 05:16 PM, Thomas Gleixner wrote:
> On Tue, 20 Jan 2015, Preeti U Murthy wrote:
>> diff --git a/kernel/time/clockevents.c b/kernel/time/clockevents.c
>> index 5544990..f3907c9 100644
>> --- a/kernel/time/clockevents.c
>> +++ b/kernel/time/clockevents.c
>> @@ -568,6 +568,7 @@ int clockevents_notify(unsigned long reason, void *arg)
>>  
>>  	case CLOCK_EVT_NOTIFY_CPU_DYING:
>>  		tick_handover_do_timer(arg);
>> +		tick_shutdown_broadcast_oneshot(arg);
>>  		break;
>>  
>>  	case CLOCK_EVT_NOTIFY_SUSPEND:
>> @@ -580,7 +581,6 @@ int clockevents_notify(unsigned long reason, void *arg)
>>  		break;
>>  
>>  	case CLOCK_EVT_NOTIFY_CPU_DEAD:
>> -		tick_shutdown_broadcast_oneshot(arg);
>>  		tick_shutdown_broadcast(arg);
>>  		tick_shutdown(arg);
>>  		/*
>> diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
>> index 066f0ec..f983983 100644
>> --- a/kernel/time/tick-broadcast.c
>> +++ b/kernel/time/tick-broadcast.c
>> @@ -675,8 +675,11 @@ static void broadcast_move_bc(int deadcpu)
>>  
>>  	if (!bc || !broadcast_needs_cpu(bc, deadcpu))
>>  		return;
>> -	/* This moves the broadcast assignment to this cpu */
>> -	clockevents_program_event(bc, bc->next_event, 1);
>> +	/* Since a cpu with the earliest wakeup is nominated as the 
>> +	 * standby cpu, the next cpu to invoke BROADCAST_ENTER
>> +	 * will now automatically take up the duty of broadcasting.
>> +	 */
>> +	bc->next_event.tv64 = KTIME_MAX;
> 
> So that relies on the fact, that cpu_down() currently forces ALL cpus
> into stop_machine(). Of course this is not in any way obvious and any
> change to this will cause even more hard to debug issues.

Hmm.. true this is a concern.
> 
> And to be honest, the clever 'set next_event to KTIME_MAX' is even
> more nonobvious because it's only relevant for your hrtimer based
> broadcasting magic. Any real broadcast device does not care about this
> at all.

bc->next_event is set to max only if CLOCK_EVT_FEATURE_HRTIMER is true.
It does not affect the usual broadcast logic.

> 
> This whole random notifier driven hotplug business is just a
> trainwreck. I'm still trying to convert this to a well documented
> state machine, so I rather prefer to make this an explicit take over
> rather than a completely undocumented 'works today' mechanism.
> 
> What about the patch below?
> 
> Thanks,
> 
> 	tglx
> ----
> diff --git a/kernel/cpu.c b/kernel/cpu.c
> index 5d220234b3ca..7a9b1ae4a945 100644
> --- a/kernel/cpu.c
> +++ b/kernel/cpu.c
> @@ -16,6 +16,7 @@
>  #include <linux/bug.h>
>  #include <linux/kthread.h>
>  #include <linux/stop_machine.h>
> +#include <linux/clockchips.h>
>  #include <linux/mutex.h>
>  #include <linux/gfp.h>
>  #include <linux/suspend.h>
> @@ -421,6 +422,12 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
>  	while (!idle_cpu(cpu))
>  		cpu_relax();
> 
> +	/*
> +	 * Before waiting for the cpu to enter DEAD state, take over
> +	 * any tick related duties
> +	 */
> +	clockevents_notify(CLOCK_EVT_NOTIFY_CPU_DEAD, &cpu);
> +
>  	/* This actually kills the CPU. */
>  	__cpu_die(cpu);
> 
> diff --git a/kernel/time/hrtimer.c b/kernel/time/hrtimer.c
> index 37e50aadd471..3c1bfd0f7074 100644
> --- a/kernel/time/hrtimer.c
> +++ b/kernel/time/hrtimer.c
> @@ -1721,11 +1721,8 @@ static int hrtimer_cpu_notify(struct notifier_block *self,
>  		break;
>  	case CPU_DEAD:
>  	case CPU_DEAD_FROZEN:
> -	{
> -		clockevents_notify(CLOCK_EVT_NOTIFY_CPU_DEAD, &scpu);
>  		migrate_hrtimers(scpu);
>  		break;
> -	}
>  #endif
> 
>  	default:
> 


How about when the cpu that is going offline receives a timer interrupt
just before setting its state to CPU_DEAD ? That is still possible right
given that its clock devices may not have been shutdown and it is
capable of receiving interrupts for a short duration. Even with the
above patch, is the following scenario possible ?

                CPU0                                  CPU1
t0         Receives timer interrupt

t1         Sees that there are hrtimers
           to be serviced (hrtimers are not yet migrated)

t2         calls hrtimer_interrupt()

t3         tick_program_event()                   CPU_DEAD notifiers
                                                CPU0's td->evtdev = NULL

t4         clockevent_program_event()
           references NULL tick device pointer

So my concern is that since the CLOCK_EVT_NOTIFY_CPU_DEAD callback
handles shutting down of devices besides moving tick related duties.
it's functions may race with the hotplug cpu still handling tick events.

We do check on powerpc if the timer interrupt has arrived on an offline
cpu, but that is to avoid an entirely different scenario and not one
like the above. I would not expect the arch to check if a timer
interrupt arrived on an offline cpu. A timer interrupt may be serviced
as long as the tick device is alive.

Regards
Preeti U Murthy

