Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932324Ab3BKUXM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 15:23:12 -0500
Received: from e32.co.us.ibm.com ([32.97.110.150]:50732 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759705Ab3BKUXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 15:23:11 -0500
Date: Mon, 11 Feb 2013 12:17:14 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Arjan van de Veen <arjan@infradead.org>, Paul Turner <pjt@google.com>,
        Richard Weinberger <rw@linutronix.de>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [patch 08/40] cpu: hotplug: Convert the hotplugged processor
 work to a state machine
Message-ID: <20130211201714.GX2666@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130131120348.372374706@linutronix.de>
 <20130131120742.037117020@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130131120742.037117020@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13021120-5406-0000-0000-0000052F0838
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2013 at 12:11:18PM -0000, Thomas Gleixner wrote:
> Move the functions which need to run on the hotplugged processor into
> a state machine array and let the code iterate through these functions.
> 
> In a later state, this will grow synchronization points between the
> control processor and the hotplugged processor, so we can move the
> various architecture implementations of the synchronizations to the
> core.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  include/linux/cpuhotplug.h |    4 ++
>  kernel/cpu.c               |   70 +++++++++++++++++++++++++++++++++++----------
>  2 files changed, 59 insertions(+), 15 deletions(-)
> 
> Index: linux-2.6/include/linux/cpuhotplug.h
> ===================================================================
> --- linux-2.6.orig/include/linux/cpuhotplug.h
> +++ linux-2.6/include/linux/cpuhotplug.h
> @@ -7,6 +7,10 @@ enum cpuhp_states {
>  	CPUHP_NOTIFY_PREPARE,
>  	CPUHP_NOTIFY_DEAD,
>  	CPUHP_BRINGUP_CPU,
> +	CPUHP_AP_OFFLINE,
> +	CPUHP_AP_NOTIFY_STARTING,
> +	CPUHP_AP_NOTIFY_DYING,
> +	CPUHP_AP_MAX,
>  	CPUHP_TEARDOWN_CPU,
>  	CPUHP_PERCPU_THREADS,
>  	CPUHP_NOTIFY_ONLINE,
> Index: linux-2.6/kernel/cpu.c
> ===================================================================
> --- linux-2.6.orig/kernel/cpu.c
> +++ linux-2.6/kernel/cpu.c
> @@ -32,6 +32,7 @@ struct cpuhp_step {
>  };
> 
>  static struct cpuhp_step cpuhp_bp_states[];
> +static struct cpuhp_step cpuhp_ap_states[];
> 
>  #ifdef CONFIG_SMP
>  /* Serializes the updates to cpu_online_mask, cpu_present_mask */
> @@ -216,6 +217,12 @@ static int bringup_cpu(unsigned int cpu)
>  	return 0;
>  }
> 
> +static int notify_starting(unsigned int cpu)
> +{
> +	cpu_notify(CPU_STARTING, cpu);
> +	return 0;
> +}
> +
>  #ifdef CONFIG_HOTPLUG_CPU
>  EXPORT_SYMBOL(register_cpu_notifier);
> 
> @@ -303,17 +310,26 @@ static int notify_down_prepare(unsigned 
>  	return err;
>  }
> 
> +static int notify_dying(unsigned int cpu)
> +{
> +	cpu_notify(CPU_DYING, cpu);
> +	return 0;
> +}
> +
>  /* Take this CPU down. */
>  static int __ref take_cpu_down(void *_param)
>  {
> -	int err, cpu = smp_processor_id();
> +	int step, err, cpu = smp_processor_id();
> 
>  	/* Ensure this CPU doesn't handle any more interrupts. */
>  	err = __cpu_disable();
>  	if (err < 0)
>  		return err;
> 
> -	cpu_notify(CPU_DYING, cpu);
> +	for (step = CPUHP_AP_MAX; step >= CPUHP_AP_OFFLINE; step--) {
> +		if (cpuhp_ap_states[step].teardown)
> +			cpuhp_ap_states[step].teardown(cpu);
> +	}
>  	/* Park the stopper thread */
>  	kthread_park(current);
>  	return 0;
> @@ -357,6 +373,7 @@ static int notify_dead(unsigned int cpu)
>  #define notify_down_prepare	NULL
>  #define takedown_cpu		NULL
>  #define notify_dead		NULL
> +#define notify_dying		NULL
>  #endif
> 
>  #ifdef CONFIG_HOTPLUG_CPU
> @@ -429,6 +446,24 @@ out:
>  EXPORT_SYMBOL(cpu_down);
>  #endif /*CONFIG_HOTPLUG_CPU*/
> 
> +/**
> + * notify_cpu_starting(cpu) - call the CPU_STARTING notifiers
> + * @cpu: cpu that just started
> + *
> + * This function calls the cpu_chain notifiers with CPU_STARTING.
> + * It must be called by the arch code on the new cpu, before the new cpu
> + * enables interrupts and before the "boot" cpu returns from __cpu_up().
> + */
> +void notify_cpu_starting(unsigned int cpu)
> +{
> +	int step;
> +
> +	for (step = CPUHP_AP_OFFLINE; step <  CPUHP_AP_MAX; step++) {
> +		if (cpuhp_ap_states[step].startup)
> +			cpuhp_ap_states[step].startup(cpu);
> +	}
> +}
> +
>  static void undo_cpu_up(unsigned int cpu, int step)
>  {
>  	while (step--) {
> @@ -703,19 +738,6 @@ core_initcall(cpu_hotplug_pm_sync_init);
> 
>  #endif /* CONFIG_PM_SLEEP_SMP */
> 
> -/**
> - * notify_cpu_starting(cpu) - call the CPU_STARTING notifiers
> - * @cpu: cpu that just started
> - *
> - * This function calls the cpu_chain notifiers with CPU_STARTING.
> - * It must be called by the arch code on the new cpu, before the new cpu
> - * enables interrupts and before the "boot" cpu returns from __cpu_up().
> - */
> -void __cpuinit notify_cpu_starting(unsigned int cpu)
> -{
> -	cpu_notify(CPU_STARTING, cpu);
> -}
> -
>  #endif /* CONFIG_SMP */
> 
>  /* Boot processor state steps */
> @@ -764,6 +786,24 @@ static struct cpuhp_step cpuhp_bp_states
>  	},
>  };
> 
> +/* Application processor state steps */
> +static struct cpuhp_step cpuhp_ap_states[] = {
> +#ifdef CONFIG_SMP
> +	[CPUHP_AP_NOTIFY_STARTING] = {
> +		.startup = notify_starting,
> +		.teardown = NULL,
> +	},
> +	[CPUHP_AP_NOTIFY_DYING] = {
> +		.startup = NULL,
> +		.teardown = notify_dying,
> +	},
> +#endif
> +	[CPUHP_MAX] = {
> +		.startup = NULL,
> +		.teardown = NULL,
> +	},
> +};
> +
>  /*
>   * cpu_bit_bitmap[] is a special, "compressed" data structure that
>   * represents all NR_CPUS bits binary values of 1<<nr.
> 
> 

