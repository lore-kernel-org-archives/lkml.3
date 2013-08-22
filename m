Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab3HVD2k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 23:28:40 -0400
Received: from gate.crashing.org ([63.228.1.57]:50235 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752415Ab3HVD2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 23:28:39 -0400
Message-ID: <1377142037.25016.272.camel@pasglop>
Subject: Re: [RFC V2 PATCH 3/6] cpuidle/ppc: Add timer offload framework to
 support deep idle states
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: fweisbec@gmail.com, paul.gortmaker@windriver.com, paulus@samba.org,
        shangw@linux.vnet.ibm.com, galak@kernel.crashing.org,
        deepthi@linux.vnet.ibm.com, paulmck@linux.vnet.ibm.com, arnd@arndb.de,
        linux-pm@vger.kernel.org, rostedt@goodmis.org, rjw@sisk.pl,
        john.stultz@linaro.org, tglx@linutronix.de, chenhui.zhao@freescale.com,
        michael@ellerman.id.au, r58472@freescale.com, geoff@infradead.org,
        linux-kernel@vger.kernel.org, srivatsa.bhat@linux.vnet.ibm.com,
        schwidefsky@de.ibm.com, svaidy@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org
Date: Thu, 22 Aug 2013 13:27:17 +1000
In-Reply-To: <20130814115613.5193.43161.stgit@preeti.in.ibm.com>
References: <20130814115311.5193.32212.stgit@preeti.in.ibm.com>
	 <20130814115613.5193.43161.stgit@preeti.in.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-08-14 at 17:26 +0530, Preeti U Murthy wrote:

>  static irqreturn_t timer_action(int irq, void *data)
>  {
> -	timer_interrupt();
> +	decrementer_timer_interrupt();
>  	return IRQ_HANDLED;
>  }

I don't completely understand what you are doing here, but ...

> @@ -223,7 +223,7 @@ irqreturn_t smp_ipi_demux(void)
>  
>  #ifdef __BIG_ENDIAN
>  		if (all & (1 << (24 - 8 * PPC_MSG_TIMER)))
> -			timer_interrupt();
> +			decrementer_timer_interrupt();

Why call this decrementer_* since it's specifically *not* the
decrementer ?

Makes more sense to be called broadcast_timer_interrupt() no ?

>  		if (all & (1 << (24 - 8 * PPC_MSG_RESCHEDULE)))
>  			scheduler_ipi();
>  		if (all & (1 << (24 - 8 * PPC_MSG_CALL_FUNC_SINGLE)))
> diff --git a/arch/powerpc/kernel/time.c b/arch/powerpc/kernel/time.c
> index 65ab9e9..7e858e1 100644
> --- a/arch/powerpc/kernel/time.c
> +++ b/arch/powerpc/kernel/time.c
> @@ -42,6 +42,7 @@
>  #include <linux/timex.h>
>  #include <linux/kernel_stat.h>
>  #include <linux/time.h>
> +#include <linux/timer.h>
>  #include <linux/init.h>
>  #include <linux/profile.h>
>  #include <linux/cpu.h>
> @@ -97,8 +98,11 @@ static struct clocksource clocksource_timebase = {
>  
>  static int decrementer_set_next_event(unsigned long evt,
>  				      struct clock_event_device *dev);
> +static int broadcast_set_next_event(unsigned long evt,
> +				      struct clock_event_device *dev);
>  static void decrementer_set_mode(enum clock_event_mode mode,
>  				 struct clock_event_device *dev);
> +static void decrementer_timer_broadcast(const struct cpumask *mask);
>  
>  struct clock_event_device decrementer_clockevent = {
>  	.name           = "decrementer",
> @@ -106,13 +110,26 @@ struct clock_event_device decrementer_clockevent = {
>  	.irq            = 0,
>  	.set_next_event = decrementer_set_next_event,
>  	.set_mode       = decrementer_set_mode,
> -	.features       = CLOCK_EVT_FEAT_ONESHOT,
> +	.broadcast	= decrementer_timer_broadcast,
> +	.features       = CLOCK_EVT_FEAT_C3STOP | CLOCK_EVT_FEAT_ONESHOT,
>  };
>  EXPORT_SYMBOL(decrementer_clockevent);
>  
> +struct clock_event_device broadcast_clockevent = {
> +	.name           = "broadcast",
> +	.rating         = 200,
> +	.irq            = 0,
> +	.set_next_event = broadcast_set_next_event,
> +	.set_mode       = decrementer_set_mode,

Same here, why "decrementer" ? This event device is *not* the
decrementer right ?

Also, pardon my ignorance, by why do we need a separate
clock_event_device ? Ie what does that do ? I am not familiar with the
broadcast scheme and what .broadcast do in the "decrementer" one, so
you need to provide me at least with better explanations.

> +	.features       = CLOCK_EVT_FEAT_ONESHOT,
> +};
> +EXPORT_SYMBOL(broadcast_clockevent);
> +
>  DEFINE_PER_CPU(u64, decrementers_next_tb);
>  static DEFINE_PER_CPU(struct clock_event_device, decrementers);
> +static DEFINE_PER_CPU(struct clock_event_device, bc_timer);

Do we really need an additional per CPU here ? What does the bc_timer
actually represent ? The sender (broadcaster) or receiver ? In the
latter case, why does it have to differ from the decrementer ?

> +int bc_cpu;

A global with that name ? Exported ? That's gross...

>  #define XSEC_PER_SEC (1024*1024)
>  
>  #ifdef CONFIG_PPC64
> @@ -487,6 +504,8 @@ void timer_interrupt(struct pt_regs * regs)
>  	struct pt_regs *old_regs;
>  	u64 *next_tb = &__get_cpu_var(decrementers_next_tb);
>  	struct clock_event_device *evt = &__get_cpu_var(decrementers);
> +	struct clock_event_device *bc_evt = &__get_cpu_var(bc_timer);
> +	int cpu = smp_processor_id();
>  	u64 now;
>  
>  	/* Ensure a positive value is written to the decrementer, or else
> @@ -532,6 +551,10 @@ void timer_interrupt(struct pt_regs * regs)
>  		*next_tb = ~(u64)0;
>  		if (evt->event_handler)
>  			evt->event_handler(evt);
> +		if (cpu == bc_cpu && bc_evt->event_handler) {
> +			bc_evt->event_handler(bc_evt);
> +		}
> +

So here, on a CPU that happens to be "bc_cpu", we call an additional
"event_handler" on every timer interrupt ? What does that handler
actually do ? How does it relate to the "broadcast" field in the
original clock source ?

>  	} else {
>  		now = *next_tb - now;
>  		if (now <= DECREMENTER_MAX)
> @@ -806,6 +829,20 @@ static int decrementer_set_next_event(unsigned long evt,
>  	return 0;
>  }
>  
> +/*
> + * We cannot program the decrementer of a remote CPU. Hence CPUs going into
> + * deep idle states need to send IPIs to the broadcast CPU to program its
> + * decrementer for their next local event so as to receive a broadcast IPI
> + * for the same. In order to avoid the overhead of multiple CPUs from sending
> + * IPIs, this function is a nop. Instead the broadcast CPU will handle the
> + * wakeup of CPUs in deep idle states in each of its local timer interrupts.
> + */
> +static int broadcast_set_next_event(unsigned long evt,
> +					struct clock_event_device *dev)
> +{
> +	return 0;
> +}
> +
>  static void decrementer_set_mode(enum clock_event_mode mode,
>  				 struct clock_event_device *dev)
>  {
> @@ -813,6 +850,20 @@ static void decrementer_set_mode(enum clock_event_mode mode,
>  		decrementer_set_next_event(DECREMENTER_MAX, dev);
>  }
>  
> +void decrementer_timer_interrupt(void)
> +{
> +	struct clock_event_device *evt;
> +	evt = &per_cpu(decrementers, smp_processor_id());
> +
> +	if (evt->event_handler)
> +		evt->event_handler(evt);
> +}

So that's what happens when we receive the broadcast... it might need
some stats ... and it's using the normal "decrementer" clock source,
so I still have a problem understanding why you need another one.

> +static void decrementer_timer_broadcast(const struct cpumask *mask)
> +{
> +	arch_send_tick_broadcast(mask);
> +}

Ok, so far so good. But that's also hooked into the normal clock
source...

>  static void register_decrementer_clockevent(int cpu)
>  {
>  	struct clock_event_device *dec = &per_cpu(decrementers, cpu);
> @@ -826,6 +877,20 @@ static void register_decrementer_clockevent(int cpu)
>  	clockevents_register_device(dec);
>  }
>  
> +static void register_broadcast_clockevent(int cpu)
> +{
> +	struct clock_event_device *bc_evt = &per_cpu(bc_timer, cpu);
> +
> +	*bc_evt = broadcast_clockevent;
> +	bc_evt->cpumask = cpumask_of(cpu);
> +
> +	printk_once(KERN_DEBUG "clockevent: %s mult[%x] shift[%d] cpu[%d]\n",
> +		    bc_evt->name, bc_evt->mult, bc_evt->shift, cpu);
> +
> +	clockevents_register_device(bc_evt);
> +	bc_cpu = cpu;
> +}
> +
>  static void __init init_decrementer_clockevent(void)
>  {
>  	int cpu = smp_processor_id();
> @@ -840,6 +905,19 @@ static void __init init_decrementer_clockevent(void)
>  	register_decrementer_clockevent(cpu);
>  }
>  
> +static void __init init_broadcast_clockevent(void)
> +{
> +	int cpu = smp_processor_id();
> +
> +	clockevents_calc_mult_shift(&broadcast_clockevent, ppc_tb_freq, 4);
> +
> +	broadcast_clockevent.max_delta_ns =
> +		clockevent_delta2ns(DECREMENTER_MAX, &broadcast_clockevent);
> +	broadcast_clockevent.min_delta_ns =
> +		clockevent_delta2ns(2, &broadcast_clockevent);
> +	register_broadcast_clockevent(cpu);
> +}
> +
>  void secondary_cpu_time_init(void)
>  {
>  	/* Start the decrementer on CPUs that have manual control
> @@ -916,6 +994,7 @@ void __init time_init(void)
>  	clocksource_init();
>  
>  	init_decrementer_clockevent();
> +	init_broadcast_clockevent();
>  }
>  
> 
> diff --git a/arch/powerpc/platforms/powernv/Kconfig b/arch/powerpc/platforms/powernv/Kconfig
> index ace2d22..e1a96eb 100644
> --- a/arch/powerpc/platforms/powernv/Kconfig
> +++ b/arch/powerpc/platforms/powernv/Kconfig
> @@ -6,6 +6,7 @@ config PPC_POWERNV
>  	select PPC_ICP_NATIVE
>  	select PPC_P7_NAP
>  	select PPC_PCI_CHOICE if EMBEDDED
> +	select GENERIC_CLOCKEVENTS_BROADCAST
>  	select EPAPR_BOOT
>  	default y
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


