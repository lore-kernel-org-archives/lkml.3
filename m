Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760886Ab3BLABX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 19:01:23 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:57300 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760638Ab3BLABV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 19:01:21 -0500
Date: Mon, 11 Feb 2013 16:01:01 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Arjan van de Veen <arjan@infradead.org>, Paul Turner <pjt@google.com>,
        Richard Weinberger <rw@linutronix.de>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: Re: [patch 32/40] rcu: Convert rcutree to hotplug state machine
Message-ID: <20130212000100.GB2666@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130131120348.372374706@linutronix.de>
 <20130131120743.656655375@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130131120743.656655375@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13021200-9360-0000-0000-000010741C90
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 31, 2013 at 12:11:38PM -0000, Thomas Gleixner wrote:
> Do we really need so many states here ?

Well, all that RCU does for CPU_DYING is to do tracing, which could be
ditched.  Required changes called out inline below.

All that the CPU_ONLINE and CPU_DOWN_PREPARE notifiers do is set
up affinity for the RCU-boost kthreads.  These are unfortunately not
per-CPU kthreads, but perhaps something similar could be set up.  This is
strictly a performance optimization, so the CPU_ONLINE notifier could
be replaced by having the kthread check which of its CPUs was online.
Unfortunately, the same is not true of CPU_DOWN_PREPARE because if the
kthread was too slow about it, the scheduler would get annoyed about a
kthread being runnable only on offlined CPUs.

It is not clear that this is worthwhile.  Thoughts on other ways to
get this done?

							Thanx, Paul

> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> ---
>  include/linux/cpuhotplug.h |   18 ++++++++
>  kernel/cpu.c               |   12 +++++
>  kernel/rcutree.c           |   95 ++++++++++++++++++++-------------------------
>  3 files changed, 73 insertions(+), 52 deletions(-)
> 
> Index: linux-2.6/include/linux/cpuhotplug.h
> ===================================================================
> --- linux-2.6.orig/include/linux/cpuhotplug.h
> +++ linux-2.6/include/linux/cpuhotplug.h
> @@ -12,6 +12,7 @@ enum cpuhp_states {
>  	CPUHP_PERF_PREPARE,
>  	CPUHP_SCHED_MIGRATE_PREP,
>  	CPUHP_WORKQUEUE_PREP,
> +	CPUHP_RCUTREE_PREPARE,
>  	CPUHP_NOTIFY_PREPARE,
>  	CPUHP_NOTIFY_DEAD,
>  	CPUHP_CPUFREQ_DEAD,
> @@ -27,6 +28,7 @@ enum cpuhp_states {
>  	CPUHP_AP_ARM64_TIMER_STARTING,
>  	CPUHP_AP_KVM_STARTING,
>  	CPUHP_AP_NOTIFY_DYING,
> +	CPUHP_AP_RCUTREE_DYING,

Drop this.

>  	CPUHP_AP_X86_TBOOT_DYING,
>  	CPUHP_AP_S390_VTIME_DYING,
>  	CPUHP_AP_SCHED_NOHZ_DYING,
> @@ -39,6 +41,7 @@ enum cpuhp_states {
>  	CPUHP_SCHED_MIGRATE_ONLINE,
>  	CPUHP_WORKQUEUE_ONLINE,
>  	CPUHP_CPUFREQ_ONLINE,
> +	CPUHP_RCUTREE_ONLINE,
>  	CPUHP_NOTIFY_ONLINE,
>  	CPUHP_NOTIFY_DOWN_PREPARE,
>  	CPUHP_PERF_X86_UNCORE_ONLINE,
> @@ -147,4 +150,19 @@ int workqueue_prepare_cpu(unsigned int c
>  int workqueue_online_cpu(unsigned int cpu);
>  int workqueue_offline_cpu(unsigned int cpu);
> 
> +/* RCUtree hotplug events */
> +#if defined(CONFIG_TREE_RCU) || defined(CONFIG_TREE_PREEMPT_RCU)
> +int rcutree_prepare_cpu(unsigned int cpu);
> +int rcutree_online_cpu(unsigned int cpu);
> +int rcutree_offline_cpu(unsigned int cpu);
> +int rcutree_dead_cpu(unsigned int cpu);
> +int rcutree_dying_cpu(unsigned int cpu);

And this...

> +#else
> +#define rcutree_prepare_cpu	NULL
> +#define rcutree_online_cpu	NULL
> +#define rcutree_offline_cpu	NULL
> +#define rcutree_dead_cpu	NULL
> +#define rcutree_dying_cpu	NULL

And of course this.

> +#endif
> +
>  #endif
> Index: linux-2.6/kernel/cpu.c
> ===================================================================
> --- linux-2.6.orig/kernel/cpu.c
> +++ linux-2.6/kernel/cpu.c
> @@ -755,6 +755,10 @@ static struct cpuhp_step cpuhp_bp_states
>  		.startup = workqueue_prepare_cpu,
>  		.teardown = NULL,
>  	},
> +	[CPUHP_RCUTREE_PREPARE] = {
> +		.startup = rcutree_prepare_cpu,
> +		.teardown = rcutree_dead_cpu,
> +	},
>  	[CPUHP_NOTIFY_PREPARE] = {
>  		.startup = notify_prepare,
>  		.teardown = NULL,
> @@ -787,6 +791,10 @@ static struct cpuhp_step cpuhp_bp_states
>  		.startup = workqueue_online_cpu,
>  		.teardown = workqueue_offline_cpu,
>  	},
> +	[CPUHP_RCUTREE_ONLINE] = {
> +		.startup = rcutree_online_cpu,
> +		.teardown = rcutree_offline_cpu,
> +	},
>  	[CPUHP_NOTIFY_ONLINE] = {
>  		.startup = notify_online,
>  		.teardown = NULL,
> @@ -813,6 +821,10 @@ static struct cpuhp_step cpuhp_ap_states
>  		.startup = NULL,
>  		.teardown = notify_dying,
>  	},
> +	[CPUHP_AP_RCUTREE_DYING] = {
> +		.startup = NULL,
> +		.teardown = rcutree_dying_cpu,
> +	},
>  	[CPUHP_AP_SCHED_NOHZ_DYING] = {
>  		.startup = NULL,
>  		.teardown = nohz_balance_exit_idle,
> Index: linux-2.6/kernel/rcutree.c
> ===================================================================
> --- linux-2.6.orig/kernel/rcutree.c
> +++ linux-2.6/kernel/rcutree.c
> @@ -2787,67 +2787,59 @@ rcu_init_percpu_data(int cpu, struct rcu
>  	mutex_unlock(&rsp->onoff_mutex);
>  }
> 
> -static void __cpuinit rcu_prepare_cpu(int cpu)
> +int __cpuinit rcutree_prepare_cpu(unsigned int cpu)
>  {
>  	struct rcu_state *rsp;
> 
>  	for_each_rcu_flavor(rsp)
>  		rcu_init_percpu_data(cpu, rsp,
>  				     strcmp(rsp->name, "rcu_preempt") == 0);
> +	rcu_prepare_kthreads(cpu);
> +	return 0;
>  }
> 
> -/*
> - * Handle CPU online/offline notification events.
> - */
> -static int __cpuinit rcu_cpu_notify(struct notifier_block *self,
> -				    unsigned long action, void *hcpu)
> +int __cpuinit rcutree_dead_cpu(unsigned int cpu)
>  {
> -	long cpu = (long)hcpu;
> -	struct rcu_data *rdp = per_cpu_ptr(rcu_state->rda, cpu);
> -	struct rcu_node *rnp = rdp->mynode;
>  	struct rcu_state *rsp;
> -	int ret = NOTIFY_OK;
> 
> -	trace_rcu_utilization("Start CPU hotplug");
> -	switch (action) {
> -	case CPU_UP_PREPARE:
> -	case CPU_UP_PREPARE_FROZEN:
> -		rcu_prepare_cpu(cpu);
> -		rcu_prepare_kthreads(cpu);
> -		break;
> -	case CPU_ONLINE:
> -	case CPU_DOWN_FAILED:
> -		rcu_boost_kthread_setaffinity(rnp, -1);
> -		break;
> -	case CPU_DOWN_PREPARE:
> -		if (nocb_cpu_expendable(cpu))
> -			rcu_boost_kthread_setaffinity(rnp, cpu);
> -		else
> -			ret = NOTIFY_BAD;
> -		break;
> -	case CPU_DYING:
> -	case CPU_DYING_FROZEN:
> -		/*
> -		 * The whole machine is "stopped" except this CPU, so we can
> -		 * touch any data without introducing corruption. We send the
> -		 * dying CPU's callbacks to an arbitrarily chosen online CPU.
> -		 */
> -		for_each_rcu_flavor(rsp)
> -			rcu_cleanup_dying_cpu(rsp);
> -		rcu_cleanup_after_idle(cpu);
> -		break;
> -	case CPU_DEAD:
> -	case CPU_DEAD_FROZEN:
> -	case CPU_UP_CANCELED:
> -	case CPU_UP_CANCELED_FROZEN:
> -		for_each_rcu_flavor(rsp)
> -			rcu_cleanup_dead_cpu(cpu, rsp);
> -		break;
> -	default:
> -		break;
> -	}
> -	trace_rcu_utilization("End CPU hotplug");
> -	return ret;
> +	for_each_rcu_flavor(rsp)
> +		rcu_cleanup_dead_cpu(cpu, rsp);
> +	return 0;
> +}
> +
> +static void __cpuinit rcutree_affinity_setting(unsigned int cpu, int outgoing)
> +{
> +	struct rcu_data *rdp = per_cpu_ptr(rcu_state->rda, cpu);
> +
> +	rcu_boost_kthread_setaffinity(rdp->mynode, outgoing);
> +}
> +
> +int __cpuinit rcutree_online_cpu(unsigned int cpu)
> +{
> +	rcutree_affinity_setting(cpu, -1);
> +	return 0;
> +}
> +
> +int __cpuinit rcutree_offline_cpu(unsigned int cpu)
> +{
> +	if (!nocb_cpu_expendable(cpu))
> +		return -EINVAL;
> +	rcutree_affinity_setting(cpu, cpu);
> +	return 0;
> +}
> +
> +int __cpuinit rcutree_dying_cpu(unsigned int cpu)
> +{
> +	struct rcu_state *rsp;
> +	/*
> +	 * The whole machine is "stopped" except this CPU, so we can
> +	 * touch any data without introducing corruption. We send the
> +	 * dying CPU's callbacks to an arbitrarily chosen online CPU.
> +	 */
> +	for_each_rcu_flavor(rsp)
> +		rcu_cleanup_dying_cpu(rsp);
> +	rcu_cleanup_after_idle(cpu);
> +	return 0;
>  }

And rcu_dying_cpu() above, along with both definitions of
rcu_cleanup_dying_cpu().

>  /*
> @@ -3071,9 +3063,8 @@ void __init rcu_init(void)
>  	 * this is called early in boot, before either interrupts
>  	 * or the scheduler are operational.
>  	 */
> -	cpu_notifier(rcu_cpu_notify, 0);
>  	for_each_online_cpu(cpu)
> -		rcu_cpu_notify(NULL, CPU_UP_PREPARE, (void *)(long)cpu);
> +		rcutree_prepare_cpu(cpu);
>  	check_cpu_stall_init();
>  }
> 
> 
> 

