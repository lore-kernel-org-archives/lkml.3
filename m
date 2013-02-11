Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932869Ab3BKXqQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 18:46:16 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:41448 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932675Ab3BKXqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 18:46:14 -0500
Date: Mon, 11 Feb 2013 15:46:07 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Arjan van de Veen <arjan@infradead.org>, Paul Turner <pjt@google.com>,
        Richard Weinberger <rw@linutronix.de>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [patch 10/40] sched: Convert to state machine callbacks
Message-ID: <20130211234607.GA2666@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130131120348.372374706@linutronix.de>
 <20130131120742.160047181@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130131120742.160047181@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13021123-2876-0000-0000-0000052E1960
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2013 at 12:11:19PM -0000, Thomas Gleixner wrote:
> The scheduler sports quite a bunch of hotplug notifiers. One reason
> for multiple notifiers is the fact, that the startup and teardown
> process are asymetric. Now the scheduler wants to be called early on
> startup and late on teardown. That requires to install two different
> notifiers for the same issue.
> 
> With the state machine implementation we can register a callback pair
> for startup and teardown at the appropriate spot.
> 
> This patch converts the notifiers which are setup with special
> priorities and combines CPU_PRI_SCHED and CPU_PRI_CPUSET notifiers to
> a single callback. They run back to back anyway and we can make sure
> in the callbacks that the ordering inside the scheduler is
> correct. These notifiers are installed in sched_init_smp() as we can't
> run them during the bringup of the non boot cpus because the smp
> scheduler is setup after that. It would be nice if we just could
> compile them in, but that needs a larger surgery to the scheduler code
> and is beyond the scope of this patch.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

> ---
>  include/linux/cpu.h        |   16 ----
>  include/linux/cpuhotplug.h |    6 +
>  kernel/cpu.c               |    4 +
>  kernel/sched/core.c        |  154 +++++++++++++++++----------------------------
>  4 files changed, 69 insertions(+), 111 deletions(-)
> 
> Index: linux-2.6/include/linux/cpu.h
> ===================================================================
> --- linux-2.6.orig/include/linux/cpu.h
> +++ linux-2.6/include/linux/cpu.h
> @@ -58,22 +58,6 @@ extern ssize_t arch_print_cpu_modalias(s
>   * CPU notifier priorities.
>   */
>  enum {
> -	/*
> -	 * SCHED_ACTIVE marks a cpu which is coming up active during
> -	 * CPU_ONLINE and CPU_DOWN_FAILED and must be the first
> -	 * notifier.  CPUSET_ACTIVE adjusts cpuset according to
> -	 * cpu_active mask right after SCHED_ACTIVE.  During
> -	 * CPU_DOWN_PREPARE, SCHED_INACTIVE and CPUSET_INACTIVE are
> -	 * ordered in the similar way.
> -	 *
> -	 * This ordering guarantees consistent cpu_active mask and
> -	 * migration behavior to all cpu notifiers.
> -	 */
> -	CPU_PRI_SCHED_ACTIVE	= INT_MAX,
> -	CPU_PRI_CPUSET_ACTIVE	= INT_MAX - 1,
> -	CPU_PRI_SCHED_INACTIVE	= INT_MIN + 1,
> -	CPU_PRI_CPUSET_INACTIVE	= INT_MIN,
> -
>  	/* migration should happen before other stuff but after perf */
>  	CPU_PRI_PERF		= 20,
>  	CPU_PRI_MIGRATION	= 10,
> Index: linux-2.6/include/linux/cpuhotplug.h
> ===================================================================
> --- linux-2.6.orig/include/linux/cpuhotplug.h
> +++ linux-2.6/include/linux/cpuhotplug.h
> @@ -6,13 +6,16 @@ enum cpuhp_states {
>  	CPUHP_CREATE_THREADS,
>  	CPUHP_NOTIFY_PREPARE,
>  	CPUHP_NOTIFY_DEAD,
> +	CPUHP_SCHED_DEAD,
>  	CPUHP_BRINGUP_CPU,
>  	CPUHP_AP_OFFLINE,
> +	CPUHP_AP_SCHED_STARTING,
>  	CPUHP_AP_NOTIFY_STARTING,
>  	CPUHP_AP_NOTIFY_DYING,
>  	CPUHP_AP_MAX,
>  	CPUHP_TEARDOWN_CPU,
>  	CPUHP_PERCPU_THREADS,
> +	CPUHP_SCHED_ONLINE,
>  	CPUHP_NOTIFY_ONLINE,
>  	CPUHP_NOTIFY_DOWN_PREPARE,
>  	CPUHP_MAX,
> @@ -87,4 +90,7 @@ static inline void cpuhp_remove_state_no
>  	__cpuhp_remove_state(state, false);
>  }
> 
> +/* Compiled in scheduler hotplug functions */
> +int sched_starting_cpu(unsigned int cpu);
> +
>  #endif
> Index: linux-2.6/kernel/cpu.c
> ===================================================================
> --- linux-2.6.orig/kernel/cpu.c
> +++ linux-2.6/kernel/cpu.c
> @@ -788,6 +788,10 @@ static struct cpuhp_step cpuhp_bp_states
>  /* Application processor state steps */
>  static struct cpuhp_step cpuhp_ap_states[] = {
>  #ifdef CONFIG_SMP
> +	[CPUHP_AP_SCHED_STARTING] = {
> +		.startup = sched_starting_cpu,
> +		.teardown = NULL,
> +	},
>  	[CPUHP_AP_NOTIFY_STARTING] = {
>  		.startup = notify_starting,
>  		.teardown = NULL,
> Index: linux-2.6/kernel/sched/core.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched/core.c
> +++ linux-2.6/kernel/sched/core.c
> @@ -5167,31 +5167,6 @@ static struct notifier_block __cpuinitda
>  	.priority = CPU_PRI_MIGRATION,
>  };
> 
> -static int __cpuinit sched_cpu_active(struct notifier_block *nfb,
> -				      unsigned long action, void *hcpu)
> -{
> -	switch (action & ~CPU_TASKS_FROZEN) {
> -	case CPU_STARTING:
> -	case CPU_DOWN_FAILED:
> -		set_cpu_active((long)hcpu, true);
> -		return NOTIFY_OK;
> -	default:
> -		return NOTIFY_DONE;
> -	}
> -}
> -
> -static int __cpuinit sched_cpu_inactive(struct notifier_block *nfb,
> -					unsigned long action, void *hcpu)
> -{
> -	switch (action & ~CPU_TASKS_FROZEN) {
> -	case CPU_DOWN_PREPARE:
> -		set_cpu_active((long)hcpu, false);
> -		return NOTIFY_OK;
> -	default:
> -		return NOTIFY_DONE;
> -	}
> -}
> -
>  static int __init migration_init(void)
>  {
>  	void *cpu = (void *)(long)smp_processor_id();
> @@ -5203,10 +5178,6 @@ static int __init migration_init(void)
>  	migration_call(&migration_notifier, CPU_ONLINE, cpu);
>  	register_cpu_notifier(&migration_notifier);
> 
> -	/* Register cpu active notifiers */
> -	cpu_notifier(sched_cpu_active, CPU_PRI_SCHED_ACTIVE);
> -	cpu_notifier(sched_cpu_inactive, CPU_PRI_SCHED_INACTIVE);
> -
>  	return 0;
>  }
>  early_initcall(migration_init);
> @@ -6292,42 +6263,12 @@ static void sched_domains_numa_masks_cle
>  	}
>  }
> 
> -/*
> - * Update sched_domains_numa_masks[level][node] array when new cpus
> - * are onlined.
> - */
> -static int sched_domains_numa_masks_update(struct notifier_block *nfb,
> -					   unsigned long action,
> -					   void *hcpu)
> -{
> -	int cpu = (long)hcpu;
> -
> -	switch (action & ~CPU_TASKS_FROZEN) {
> -	case CPU_ONLINE:
> -		sched_domains_numa_masks_set(cpu);
> -		break;
> -
> -	case CPU_DEAD:
> -		sched_domains_numa_masks_clear(cpu);
> -		break;
> -
> -	default:
> -		return NOTIFY_DONE;
> -	}
> -
> -	return NOTIFY_OK;
> -}
>  #else
> -static inline void sched_init_numa(void)
> -{
> -}
> -
> -static int sched_domains_numa_masks_update(struct notifier_block *nfb,
> -					   unsigned long action,
> -					   void *hcpu)
> -{
> -	return 0;
> -}
> +static inline void sched_init_numa(void) { }
> +#ifdef CONFIG_HOTPLUG_CPU
> +static void sched_domains_numa_masks_set(int cpu) { }
> +static void sched_domains_numa_masks_clear(int cpu) { }
> +#endif
>  #endif /* CONFIG_NUMA */
> 
>  static int __sdt_alloc(const struct cpumask *cpu_map)
> @@ -6696,6 +6637,7 @@ match2:
>  	mutex_unlock(&sched_domains_mutex);
>  }
> 
> +#ifdef CONFIG_HOTPLUG_CPU
>  static int num_cpus_frozen;	/* used to mark begin/end of suspend/resume */
> 
>  /*
> @@ -6706,13 +6648,9 @@ static int num_cpus_frozen;	/* used to m
>   * If we come here as part of a suspend/resume, don't touch cpusets because we
>   * want to restore it back to its original state upon resume anyway.
>   */
> -static int cpuset_cpu_active(struct notifier_block *nfb, unsigned long action,
> -			     void *hcpu)
> +static void cpuset_cpu_active(void)
>  {
> -	switch (action) {
> -	case CPU_ONLINE_FROZEN:
> -	case CPU_DOWN_FAILED_FROZEN:
> -
> +	if (cpuhp_tasks_frozen) {
>  		/*
>  		 * num_cpus_frozen tracks how many CPUs are involved in suspend
>  		 * resume sequence. As long as this is not the last online
> @@ -6722,40 +6660,62 @@ static int cpuset_cpu_active(struct noti
>  		num_cpus_frozen--;
>  		if (likely(num_cpus_frozen)) {
>  			partition_sched_domains(1, NULL, NULL);
> -			break;
> +			return;
>  		}
> -
>  		/*
>  		 * This is the last CPU online operation. So fall through and
>  		 * restore the original sched domains by considering the
>  		 * cpuset configurations.
>  		 */
> -
> -	case CPU_ONLINE:
> -	case CPU_DOWN_FAILED:
> -		cpuset_update_active_cpus(true);
> -		break;
> -	default:
> -		return NOTIFY_DONE;
>  	}
> -	return NOTIFY_OK;
> +	cpuset_update_active_cpus(true);
>  }
> 
> -static int cpuset_cpu_inactive(struct notifier_block *nfb, unsigned long action,
> -			       void *hcpu)
> +static void cpuset_cpu_inactive(void)
>  {
> -	switch (action) {
> -	case CPU_DOWN_PREPARE:
> -		cpuset_update_active_cpus(false);
> -		break;
> -	case CPU_DOWN_PREPARE_FROZEN:
> +	if (cpuhp_tasks_frozen) {
>  		num_cpus_frozen++;
>  		partition_sched_domains(1, NULL, NULL);
> -		break;
> -	default:
> -		return NOTIFY_DONE;
> -	}
> -	return NOTIFY_OK;
> +	} else
> +		cpuset_update_active_cpus(false);
> +}
> +
> +static int sched_dead_cpu(unsigned int cpu)
> +{
> +	sched_domains_numa_masks_clear(cpu);
> +	return 0;
> +}
> +
> +static int sched_online_cpu(unsigned int cpu)
> +{
> +	/* Looks redundant, but we need it in case of down canceled */
> +	set_cpu_active(cpu, true);
> +	/*
> +	 * Asymetric to sched_dead_cpu, but this just fiddles with
> +	 * bits. Sigh
> +	 */
> +	sched_domains_numa_masks_set(cpu);
> +	/* This is actually symetric */
> +	cpuset_cpu_active();
> +	return 0;
> +}
> +
> +static int sched_offline_cpu(unsigned int cpu)
> +{
> +	set_cpu_active(cpu, false);
> +	cpuset_cpu_inactive();
> +	return 0;
> +}
> +#else
> +#define sched_dead_cpu		NULL
> +#define sched_online_cpu	NULL
> +#define sched_offline_cpu	NULL
> +#endif
> +
> +int __cpuinit sched_starting_cpu(unsigned int cpu)
> +{
> +	set_cpu_active(cpu, true);
> +	return 0;
>  }
> 
>  void __init sched_init_smp(void)
> @@ -6776,9 +6736,13 @@ void __init sched_init_smp(void)
>  	mutex_unlock(&sched_domains_mutex);
>  	put_online_cpus();
> 
> -	hotcpu_notifier(sched_domains_numa_masks_update, CPU_PRI_SCHED_ACTIVE);
> -	hotcpu_notifier(cpuset_cpu_active, CPU_PRI_CPUSET_ACTIVE);
> -	hotcpu_notifier(cpuset_cpu_inactive, CPU_PRI_CPUSET_INACTIVE);
> +	/*
> +	 * Note: These callbacks are installed late because we init
> +	 * numa and sched domains after we brought up the cpus.
> +	 */
> +	cpuhp_setup_state_nocalls(CPUHP_SCHED_DEAD, NULL, sched_dead_cpu);
> +	cpuhp_setup_state_nocalls(CPUHP_SCHED_ONLINE, sched_online_cpu,
> +				  sched_offline_cpu);
> 
>  	/* RT runtime code needs to handle some hotplug events */
>  	hotcpu_notifier(update_runtime, 0);
> 
> 

