Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759943Ab3BKUKs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 15:10:48 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:60588 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759692Ab3BKUKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 15:10:47 -0500
Date: Mon, 11 Feb 2013 12:09:58 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Arjan van de Veen <arjan@infradead.org>, Paul Turner <pjt@google.com>,
        Richard Weinberger <rw@linutronix.de>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [patch 07/40] cpu: hotplug: Convert to a state machine for the
 control processor
Message-ID: <20130211200958.GW2666@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130131120348.372374706@linutronix.de>
 <20130131120741.961629869@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130131120741.961629869@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13021120-5806-0000-0000-00001F7BB1F5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2013 at 12:11:17PM -0000, Thomas Gleixner wrote:
> Move the split out steps into a callback array and let the cpu_up/down
> code iterate through the array functions. For now most of the
> callbacks are asymetric to resemble the current hotplug maze.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  include/linux/cpu.h        |    4 +
>  include/linux/cpuhotplug.h |   16 ++++
>  init/main.c                |   15 ---
>  kernel/cpu.c               |  180 ++++++++++++++++++++++++++++++++++++---------
>  kernel/smpboot.c           |    6 +
>  kernel/smpboot.h           |    4 -
>  6 files changed, 173 insertions(+), 52 deletions(-)
> 
> Index: linux-2.6/include/linux/cpu.h
> ===================================================================
> --- linux-2.6.orig/include/linux/cpu.h
> +++ linux-2.6/include/linux/cpu.h
> @@ -26,6 +26,9 @@ struct cpu {
>  	struct device dev;
>  };
> 
> +extern void boot_cpu_init(void);
> +extern void boot_cpu_state_init(void);
> +
>  extern int register_cpu(struct cpu *cpu, int num);
>  extern struct device *get_cpu_device(unsigned cpu);
>  extern bool cpu_is_hotpluggable(unsigned cpu);
> @@ -112,6 +115,7 @@ enum {
> 
> 
>  #ifdef CONFIG_SMP
> +extern bool cpuhp_tasks_frozen;
>  /* Need to know about CPUs going up/down? */
>  #if defined(CONFIG_HOTPLUG_CPU) || !defined(MODULE)
>  #define cpu_notifier(fn, pri) {					\
> Index: linux-2.6/include/linux/cpuhotplug.h
> ===================================================================
> --- /dev/null
> +++ linux-2.6/include/linux/cpuhotplug.h
> @@ -0,0 +1,16 @@
> +#ifndef __CPUHOTPLUG_H
> +#define __CPUHOTPLUG_H
> +
> +enum cpuhp_states {
> +	CPUHP_OFFLINE,
> +	CPUHP_CREATE_THREADS,
> +	CPUHP_NOTIFY_PREPARE,
> +	CPUHP_NOTIFY_DEAD,
> +	CPUHP_BRINGUP_CPU,
> +	CPUHP_TEARDOWN_CPU,
> +	CPUHP_PERCPU_THREADS,
> +	CPUHP_NOTIFY_ONLINE,
> +	CPUHP_NOTIFY_DOWN_PREPARE,
> +	CPUHP_MAX,
> +};
> +#endif
> Index: linux-2.6/init/main.c
> ===================================================================
> --- linux-2.6.orig/init/main.c
> +++ linux-2.6/init/main.c
> @@ -424,20 +424,6 @@ void __init parse_early_param(void)
>  	done = 1;
>  }
> 
> -/*
> - *	Activate the first processor.
> - */
> -
> -static void __init boot_cpu_init(void)
> -{
> -	int cpu = smp_processor_id();
> -	/* Mark the boot cpu "present", "online" etc for SMP and UP case */
> -	set_cpu_online(cpu, true);
> -	set_cpu_active(cpu, true);
> -	set_cpu_present(cpu, true);
> -	set_cpu_possible(cpu, true);
> -}
> -
>  void __init __weak smp_setup_processor_id(void)
>  {
>  }
> @@ -502,6 +488,7 @@ asmlinkage void __init start_kernel(void
>  	setup_command_line(command_line);
>  	setup_nr_cpu_ids();
>  	setup_per_cpu_areas();
> +	boot_cpu_state_init();
>  	smp_prepare_boot_cpu();	/* arch-specific boot-cpu hooks */
> 
>  	build_all_zonelists(NULL, NULL);
> Index: linux-2.6/kernel/cpu.c
> ===================================================================
> --- linux-2.6.orig/kernel/cpu.c
> +++ linux-2.6/kernel/cpu.c
> @@ -19,13 +19,24 @@
>  #include <linux/mutex.h>
>  #include <linux/gfp.h>
>  #include <linux/suspend.h>
> +#include <linux/cpuhotplug.h>
> 
>  #include "smpboot.h"
> 
> +/* CPU state */
> +static DEFINE_PER_CPU(enum cpuhp_states, cpuhp_state);
> +
> +struct cpuhp_step {
> +	int (*startup)(unsigned int cpu);
> +	int (*teardown)(unsigned int cpu);
> +};
> +
> +static struct cpuhp_step cpuhp_bp_states[];
> +
>  #ifdef CONFIG_SMP
>  /* Serializes the updates to cpu_online_mask, cpu_present_mask */
>  static DEFINE_MUTEX(cpu_add_remove_lock);
> -static bool cpuhp_tasks_frozen;
> +bool cpuhp_tasks_frozen;
> 
>  /*
>   * The following two API's must be used when attempting
> @@ -310,13 +321,10 @@ static int __ref take_cpu_down(void *_pa
> 
>  static int takedown_cpu(unsigned int cpu)
>  {
> -	int err;
> +	int err = __stop_machine(take_cpu_down, NULL, cpumask_of(cpu));
> 
> -	smpboot_park_threads(cpu);
> -	err = __stop_machine(take_cpu_down, NULL, cpumask_of(cpu));
>  	if (err) {
>  		/* CPU didn't die: tell everyone.  Can't complain. */
> -		smpboot_unpark_threads(cpu);
>  		cpu_notify_nofail(CPU_DOWN_FAILED, cpu);
>  		return err;
>  	}
> @@ -345,10 +353,32 @@ static int notify_dead(unsigned int cpu)
>  	return 0;
>  }
> 
> +#else
> +#define notify_down_prepare	NULL
> +#define takedown_cpu		NULL
> +#define notify_dead		NULL
> +#endif
> +
> +#ifdef CONFIG_HOTPLUG_CPU
> +static void undo_cpu_down(unsigned int cpu, int step)
> +{
> +	while (step++ < CPUHP_MAX) {
> +		/*
> +		 * Transitional check. Will be removed when we have a
> +		 * fully symetric mechanism
> +		 */
> +		if (!cpuhp_bp_states[step].teardown)
> +			continue;
> +
> +		if (cpuhp_bp_states[step].startup)
> +			cpuhp_bp_states[step].startup(cpu);
> +	}
> +}
> +
>  /* Requires cpu_add_remove_lock to be held */
>  static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
>  {
> -	int err;
> +	int ret = 0, step;
> 
>  	if (num_online_cpus() == 1)
>  		return -EBUSY;
> @@ -360,20 +390,23 @@ static int __ref _cpu_down(unsigned int 
> 
>  	cpuhp_tasks_frozen = tasks_frozen;
> 
> -	err = notify_down_prepare(cpu);
> -	if (err)
> -		goto out_release;
> -	err = takedown_cpu(cpu);
> -	if (err)
> -		goto out_release;
> -
> -	notify_dead(cpu);
> +	for (step = per_cpu(cpuhp_state, cpu); step > 0; step--) {
> +		if (cpuhp_bp_states[step].teardown) {
> +			ret = cpuhp_bp_states[step].teardown(cpu);
> +			if (ret) {
> +				undo_cpu_down(cpu, step + 1);
> +				step = CPUHP_MAX;
> +				break;
> +			}
> +		}
> +	}
> +	/* Store the current cpu state */
> +	per_cpu(cpuhp_state, cpu) = step;
> 
> -out_release:
>  	cpu_hotplug_done();
> -	if (!err)
> +	if (!ret)
>  		cpu_notify_nofail(CPU_POST_DEAD, cpu);
> -	return err;
> +	return ret;
>  }
> 
>  int __ref cpu_down(unsigned int cpu)
> @@ -396,11 +429,25 @@ out:
>  EXPORT_SYMBOL(cpu_down);
>  #endif /*CONFIG_HOTPLUG_CPU*/
> 
> +static void undo_cpu_up(unsigned int cpu, int step)
> +{
> +	while (step--) {
> +		/*
> +		 * Transitional check. Will be removed when we have a
> +		 * fully symetric mechanism
> +		 */
> +		if (!cpuhp_bp_states[step].startup)
> +			continue;
> +		if (cpuhp_bp_states[step].teardown)
> +			cpuhp_bp_states[step].teardown(cpu);
> +	}
> +}
> +
>  /* Requires cpu_add_remove_lock to be held */
>  static int __cpuinit _cpu_up(unsigned int cpu, int tasks_frozen)
>  {
> +	int ret = 0, step;
>  	struct task_struct *idle;
> -	int ret;
> 
>  	cpu_hotplug_begin();
> 
> @@ -409,6 +456,7 @@ static int __cpuinit _cpu_up(unsigned in
>  		goto out;
>  	}
> 
> +	/* Let it fail before we try to bring the cpu up */
>  	idle = idle_thread_get(cpu);
>  	if (IS_ERR(idle)) {
>  		ret = PTR_ERR(idle);
> @@ -417,24 +465,20 @@ static int __cpuinit _cpu_up(unsigned in
> 
>  	cpuhp_tasks_frozen = tasks_frozen;
> 
> -	ret = smpboot_create_threads(cpu);
> -	if (ret)
> -		goto out;
> -
> -	ret = notify_prepare(cpu);
> -	if (ret)
> -		goto out;
> -
> -	ret = bringup_cpu(cpu);
> -	if (ret)
> -		goto out;
> -
> -	/* Wake the per cpu threads */
> -	smpboot_unpark_threads(cpu);
> -	notify_online(cpu);
> +	for (step = per_cpu(cpuhp_state, cpu); step < CPUHP_MAX; step++) {
> +		if (cpuhp_bp_states[step].startup) {
> +			ret = cpuhp_bp_states[step].startup(cpu);
> +			if (ret) {
> +				undo_cpu_up(cpu, step - 1);
> +				step = 0;
> +				break;
> +			}
> +		}
> +	}
> +	/* Store the current cpu state */
> +	per_cpu(cpuhp_state, cpu) = step;
>  out:
>  	cpu_hotplug_done();
> -
>  	return ret;
>  }
> 
> @@ -674,6 +718,52 @@ void __cpuinit notify_cpu_starting(unsig
> 
>  #endif /* CONFIG_SMP */
> 
> +/* Boot processor state steps */
> +static struct cpuhp_step cpuhp_bp_states[] = {
> +	[CPUHP_OFFLINE] = {
> +		.startup = NULL,
> +		.teardown = NULL,
> +	},
> +#ifdef CONFIG_SMP
> +	[CPUHP_CREATE_THREADS] = {
> +		.startup = smpboot_create_threads,
> +		.teardown = NULL,
> +	},
> +	[CPUHP_NOTIFY_PREPARE] = {
> +		.startup = notify_prepare,
> +		.teardown = NULL,
> +	},
> +	[CPUHP_NOTIFY_DEAD] = {
> +		.startup = NULL,
> +		.teardown = notify_dead,
> +	},
> +	[CPUHP_BRINGUP_CPU] = {
> +		.startup = bringup_cpu,
> +		.teardown = NULL,
> +	},
> +	[CPUHP_TEARDOWN_CPU] = {
> +		.startup = NULL,
> +		.teardown = takedown_cpu,
> +	},
> +	[CPUHP_PERCPU_THREADS] = {
> +		.startup = smpboot_unpark_threads,
> +		.teardown = smpboot_park_threads,
> +	},
> +	[CPUHP_NOTIFY_ONLINE] = {
> +		.startup = notify_online,
> +		.teardown = NULL,
> +	},
> +	[CPUHP_NOTIFY_DOWN_PREPARE] = {
> +		.startup = NULL,
> +		.teardown = notify_down_prepare,
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
> @@ -769,3 +859,25 @@ void init_cpu_online(const struct cpumas
>  {
>  	cpumask_copy(to_cpumask(cpu_online_bits), src);
>  }
> +
> +/*
> + * Activate the first processor.
> + */
> +void __init boot_cpu_init(void)
> +{
> +	int cpu = smp_processor_id();
> +
> +	/* Mark the boot cpu "present", "online" etc for SMP and UP case */
> +	set_cpu_online(cpu, true);
> +	set_cpu_active(cpu, true);
> +	set_cpu_present(cpu, true);
> +	set_cpu_possible(cpu, true);
> +}
> +
> +/*
> + * Must be called _AFTER_ setting up the per_cpu areas
> + */
> +void __init boot_cpu_state_init(void)
> +{
> +	per_cpu(cpuhp_state, smp_processor_id()) = CPUHP_MAX;
> +}
> Index: linux-2.6/kernel/smpboot.c
> ===================================================================
> --- linux-2.6.orig/kernel/smpboot.c
> +++ linux-2.6/kernel/smpboot.c
> @@ -212,7 +212,7 @@ static void smpboot_unpark_thread(struct
>  	kthread_unpark(tsk);
>  }
> 
> -void smpboot_unpark_threads(unsigned int cpu)
> +int smpboot_unpark_threads(unsigned int cpu)
>  {
>  	struct smp_hotplug_thread *cur;
> 
> @@ -220,6 +220,7 @@ void smpboot_unpark_threads(unsigned int
>  	list_for_each_entry(cur, &hotplug_threads, list)
>  		smpboot_unpark_thread(cur, cpu);
>  	mutex_unlock(&smpboot_threads_lock);
> +	return 0;
>  }
> 
>  static void smpboot_park_thread(struct smp_hotplug_thread *ht, unsigned int cpu)
> @@ -230,7 +231,7 @@ static void smpboot_park_thread(struct s
>  		kthread_park(tsk);
>  }
> 
> -void smpboot_park_threads(unsigned int cpu)
> +int smpboot_park_threads(unsigned int cpu)
>  {
>  	struct smp_hotplug_thread *cur;
> 
> @@ -238,6 +239,7 @@ void smpboot_park_threads(unsigned int c
>  	list_for_each_entry_reverse(cur, &hotplug_threads, list)
>  		smpboot_park_thread(cur, cpu);
>  	mutex_unlock(&smpboot_threads_lock);
> +	return 0;
>  }
> 
>  static void smpboot_destroy_threads(struct smp_hotplug_thread *ht)
> Index: linux-2.6/kernel/smpboot.h
> ===================================================================
> --- linux-2.6.orig/kernel/smpboot.h
> +++ linux-2.6/kernel/smpboot.h
> @@ -14,7 +14,7 @@ static inline void idle_threads_init(voi
>  #endif
> 
>  int smpboot_create_threads(unsigned int cpu);
> -void smpboot_park_threads(unsigned int cpu);
> -void smpboot_unpark_threads(unsigned int cpu);
> +int smpboot_park_threads(unsigned int cpu);
> +int smpboot_unpark_threads(unsigned int cpu);
> 
>  #endif
> 
> 

