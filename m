Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711Ab3HVJFt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 05:05:49 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:44141 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167Ab3HVJFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 05:05:45 -0400
Message-ID: <5215D3CA.60402@linux.vnet.ibm.com>
Date: Thu, 22 Aug 2013 14:33:06 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: fweisbec@gmail.com, paul.gortmaker@windriver.com, paulus@samba.org,
        shangw@linux.vnet.ibm.com, galak@kernel.crashing.org,
        deepthi@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com, arnd@arndb.de,
        linux-pm@vger.kernel.org, rostedt@goodmis.org, rjw@sisk.pl,
        john.stultz@linaro.org, tglx@linutronix.de, chenhui.zhao@freescale.com,
        michael@ellerman.id.au, r58472@freescale.com, geoff@infradead.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, svaidy@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [RFC V2 PATCH 3/6] cpuidle/ppc: Add timer offload framework to
 support deep idle states
References: <20130814115311.5193.32212.stgit@preeti.in.ibm.com> <20130814115613.5193.43161.stgit@preeti.in.ibm.com> <1377142037.25016.272.camel@pasglop>
In-Reply-To: <1377142037.25016.272.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082208-8256-0000-0000-000008E502E0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

On 08/22/2013 08:57 AM, Benjamin Herrenschmidt wrote:
> On Wed, 2013-08-14 at 17:26 +0530, Preeti U Murthy wrote:
> 
>>  static irqreturn_t timer_action(int irq, void *data)
>>  {
>> -	timer_interrupt();
>> +	decrementer_timer_interrupt();
>>  	return IRQ_HANDLED;
>>  }
> 
> I don't completely understand what you are doing here, but ...
> 
>> @@ -223,7 +223,7 @@ irqreturn_t smp_ipi_demux(void)
>>  
>>  #ifdef __BIG_ENDIAN
>>  		if (all & (1 << (24 - 8 * PPC_MSG_TIMER)))
>> -			timer_interrupt();
>> +			decrementer_timer_interrupt();
> 
> Why call this decrementer_* since it's specifically *not* the
> decrementer ?
>
> Makes more sense to be called broadcast_timer_interrupt() no ?

A broadcast IPI is meant to trigger timer interrupt handling on the
target CPUs. In deep idle states, even though the local timers of CPUs
become non-functional, it should not make a difference to them because
of the broadcast framework's help.

The broadcast framework is meant to hide the fact that the CPUs in deep
idle states require external help to wakeup on their expired timer
events. So the CPUs should wake up to find themselves handling the
timers under such a scenario, although they woke up from an IPI.

This whole idea gets conveyed by naming the handler of the broadcast IPI
to decrementer_timer_interrupt().

That said, ideally it should have been called timer_interrupt(). But
since we already have the timer interrupt handler with the same name,
and also we cannot call it directly for reasons mentioned in the reply
to your review on PATCH 2/6, I named it decrementer_timer_interrupt() to
come close to conveying the idea. This calls only the timer interrupt
handler there.

> 
>>  		if (all & (1 << (24 - 8 * PPC_MSG_RESCHEDULE)))
>>  			scheduler_ipi();
>>  		if (all & (1 << (24 - 8 * PPC_MSG_CALL_FUNC_SINGLE)))
>> diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
>> index 65ab9e9..7e858e1 100644
>> --- a/arch/powerpc/kernel/time.c
>> +++ b/arch/powerpc/kernel/time.c
>> @@ -42,6 +42,7 @@
>>  #include <linux/timex.h>
>>  #include <linux/kernel_stat.h>
>>  #include <linux/time.h>
>> +#include <linux/timer.h>
>>  #include <linux/init.h>
>>  #include <linux/profile.h>
>>  #include <linux/cpu.h>
>> @@ -97,8 +98,11 @@ static struct clocksource clocksource_timebase = {
>>  
>>  static int decrementer_set_next_event(unsigned long evt,
>>  				      struct clock_event_device *dev);
>> +static int broadcast_set_next_event(unsigned long evt,
>> +				      struct clock_event_device *dev);
>>  static void decrementer_set_mode(enum clock_event_mode mode,
>>  				 struct clock_event_device *dev);
>> +static void decrementer_timer_broadcast(const struct cpumask *mask);
>>  
>>  struct clock_event_device decrementer_clockevent = {
>>  	.name           = "decrementer",
>> @@ -106,13 +110,26 @@ struct clock_event_device decrementer_clockevent = {
>>  	.irq            = 0,
>>  	.set_next_event = decrementer_set_next_event,
>>  	.set_mode       = decrementer_set_mode,
>> -	.features       = CLOCK_EVT_FEAT_ONESHOT,
>> +	.broadcast	= decrementer_timer_broadcast,
>> +	.features       = CLOCK_EVT_FEAT_C3STOP | CLOCK_EVT_FEAT_ONESHOT,
>>  };
>>  EXPORT_SYMBOL(decrementer_clockevent);
>>  
>> +struct clock_event_device broadcast_clockevent = {
>> +	.name           = "broadcast",
>> +	.rating         = 200,
>> +	.irq            = 0,
>> +	.set_next_event = broadcast_set_next_event,
>> +	.set_mode       = decrementer_set_mode,
> 
> Same here, why "decrementer" ? This event device is *not* the
> decrementer right ?

You are right. In this case it should have been broadcast_set_mode. This
is because this function is associated with the sender(the broadcast cpu).

> 
> Also, pardon my ignorance, by why do we need a separate
> clock_event_device ? Ie what does that do ? I am not familiar with the
> broadcast scheme and what .broadcast do in the "decrementer" one, so
> you need to provide me at least with better explanations.

The answer in short to why we need an additional clock event device is
that, in this patchset, we try to integrate the support for deep sleep
states in power, with the broadcast framework existent today in the
kernel without any changes to this broadcast framework and trying our
best to adapt to it. Let me now elaborate.

The broadcast framework kicks in if there is a broadcast clock event
device. We can double up the local timer/decrementer of a CPU as the
broadcast clock event device itself. But the broadcast framework
considers a clock event device an eligible candidate for broadcast, if
the feature CLOCK_EVT_FEAT_C3STOP is not associated with it. This
feature says that the clock event device stops in deep idle states. The
broadcast framework expects the clock event device which takes up the
responsibility of doing broadcast to be available and on at all points
in time.
  The decrementer clock event device however is susceptible to
non-availability in deep idle states.

Now the next question of why does a broadcast framework require a clock
event device? This clock event device is the equivalent of the local
timer of a CPU, except that this behaves like the global timer for all
CPUs whose local timers are non-functional. Of course this timer can
wakeup only one CPU on expiry. So the CPU chosen for this purpose will
effectively have two devices, the local clock event device and the
broadcast clock event device targeting their interrupts to it. When the
broadcast clock event device interrupts the CPU, the CPU sends an IPI to
those of the idling CPUs whose local timers have stopped, if required,
with an intention of waking them up to handle their local timer events.

The job of the broadcast framework is to find out which CPU, that has
its local timers switched off has to be woken up next. The important
thing to note here is that the local timers are not expected to be
switched off only in deep idle states. They can be non functional due to
whatever reason, at which time they come to broadcast framework seeking
help; to wake them up at their local timer events.

The broadcast framework puts the CPUs under such a category, into a mask
and each time a new CPU enters such a mask, it reprograms the broadcast
clock event device to the earliest of the new wakeup and the old. If the
local timer of a CPU was also used for this purpose, its original local
wakeup event would be overwritten.

On powerpc, since we do not have a physical clock event device
additionally to the local clock event devices, we need to have a pseudo
device so that we can activate the broadcast framework.

I will explain what the .broadcast in decrementer clock event device
does further down in the mail.

> 
>> +	.features       = CLOCK_EVT_FEAT_ONESHOT,
>> +};
>> +EXPORT_SYMBOL(broadcast_clockevent);
>> +
>>  DEFINE_PER_CPU(u64, decrementers_next_tb);
>>  static DEFINE_PER_CPU(struct clock_event_device, decrementers);
>> +static DEFINE_PER_CPU(struct clock_event_device, bc_timer);
> 
> Do we really need an additional per CPU here ? What does the bc_timer
> actually represent ? The sender (broadcaster) or receiver ? In the
> latter case, why does it have to differ from the decrementer ?

No we dont really need this to be per cpu. The PATCH 4/6 removes this
per_cpu instance, instead has one clock event device. The bc_timer is
the broadcast clock event device that is described above. So to answer
the above question it is associated with the sender. It needs to be
different from the decrementer for the reasons mentioned above.

> 
>> +int bc_cpu;
> 
> A global with that name ? Exported ? That's gross...

Sorry about this, ill take care of the implementation of this in the
next version by adding accessor functions to set/unset it.

> 
>>  #define XSEC_PER_SEC (1024*1024)
>>  
>>  #ifdef CONFIG_PPC64
>> @@ -487,6 +504,8 @@ void timer_interrupt(struct pt_regs * regs)
>>  	struct pt_regs *old_regs;
>>  	u64 *next_tb = &__get_cpu_var(decrementers_next_tb);
>>  	struct clock_event_device *evt = &__get_cpu_var(decrementers);
>> +	struct clock_event_device *bc_evt = &__get_cpu_var(bc_timer);
>> +	int cpu = smp_processor_id();
>>  	u64 now;
>>  
>>  	/* Ensure a positive value is written to the decrementer, or else
>> @@ -532,6 +551,10 @@ void timer_interrupt(struct pt_regs * regs)
>>  		*next_tb = ~(u64)0;
>>  		if (evt->event_handler)
>>  			evt->event_handler(evt);
>> +		if (cpu == bc_cpu && bc_evt->event_handler) {
>> +			bc_evt->event_handler(bc_evt);
>> +		}
>> +
> 
> So here, on a CPU that happens to be "bc_cpu", we call an additional
> "event_handler" on every timer interrupt ? What does that handler
> actually do ? How does it relate to the "broadcast" field in the
> original clock source ?

This handler is in charge of finding out which of the CPUs whose local
timers have been switched off, need to be woken up to enable them to
handle their expired timer events. The bc_cpu sends an IPI to such
sleeping CPUs.

The broadcast framework currently uses the *broadcast* function to send
IPIs to the CPUs in deep idle states. This function needs to be
associated with the local timers of the CPUs according to the current
design of the broadcast framework.

So the event handler of the broadcast clock event device, uses the
broadcast function to send IPIs to the CPUs required, in addition to
finding out who to send the IPIs and when the next wakeup of idling CPUs
should be handled.

> 
>>  	} else {
>>  		now = *next_tb - now;
>>  		if (now <= DECREMENTER_MAX)
>> @@ -806,6 +829,20 @@ static int decrementer_set_next_event(unsigned long evt,
>>  	return 0;
>>  }
>>  
>> +/*
>> + * We cannot program the decrementer of a remote CPU. Hence CPUs going into
>> + * deep idle states need to send IPIs to the broadcast CPU to program its
>> + * decrementer for their next local event so as to receive a broadcast IPI
>> + * for the same. In order to avoid the overhead of multiple CPUs from sending
>> + * IPIs, this function is a nop. Instead the broadcast CPU will handle the
>> + * wakeup of CPUs in deep idle states in each of its local timer interrupts.
>> + */
>> +static int broadcast_set_next_event(unsigned long evt,
>> +					struct clock_event_device *dev)
>> +{
>> +	return 0;
>> +}
>> +
>>  static void decrementer_set_mode(enum clock_event_mode mode,
>>  				 struct clock_event_device *dev)
>>  {
>> @@ -813,6 +850,20 @@ static void decrementer_set_mode(enum clock_event_mode mode,
>>  		decrementer_set_next_event(DECREMENTER_MAX, dev);
>>  }
>>  
>> +void decrementer_timer_interrupt(void)
>> +{
>> +	struct clock_event_device *evt;
>> +	evt = &per_cpu(decrementers, smp_processor_id());
>> +
>> +	if (evt->event_handler)
>> +		evt->event_handler(evt);
>> +}
> 
> So that's what happens when we receive the broadcast... it might need
> some stats ... and it's using the normal "decrementer" clock source,
> so I still have a problem understanding why you need another one.

So this is the receiver part of the broadcast. The sender needs to call
the event handler of the broadcast clock event device while the receiver
has to invoke the event handler of the decrementer clock event device so
as to handle its local timer events.
  But you are right, we are missing stats accumulation by doing the
above. I need to take care of this.

> 
>> +static void decrementer_timer_broadcast(const struct cpumask *mask)
>> +{
>> +	arch_send_tick_broadcast(mask);
>> +}
> 
> Ok, so far so good. But that's also hooked into the normal clock
> source...

This broadcast function has to be associated with the normal clock
source according to the implementation of the broadcast framework. I am
not too sure about the reason behind this.

So the current implementation has the broadcast event handler associated
with the broadcast clock event device(where cpus that have to be woken
up are selected and the broadcast clock event device reprogrammed), and
the actual job of broadcasting is associated with the normal clock
source(sending an IPI), i.e. the .broadcast fn.

And the broadcast IPI handler on the target CPUs has to invoke the timer
handler of the nromal clock source.

So only the broadcast event handler(tick_handle_oneshot_broadcast() and
tick_handle_periodic_broadcast()) is associated with the broadcast clock
source.

Regards
Preeti U Murthy

