Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759651Ab3D3C1I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 22:27:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3830 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759573Ab3D3C1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 22:27:05 -0400
X-Authority-Analysis: v=2.0 cv=GtrACzJC c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=wom5GMh1gUkA:10 a=4bvjvOMZgvAA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=iKh5NY0ZyaEA:10 a=9isDrUItAAAA:8 a=VwQbUJbxAAAA:8 a=W0vUJOdyAAAA:8 a=qS4xpuJKPdtHozgDJ7wA:9 a=CjuIK1q_8ugA:10 a=x8gzFH9gYPwA:10 a=LqrUb4H50BYA:10 a=QHEOuCK4B7c6IWbR:21 a=Wi4DYqJ1M4pGHS1D:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Date: Mon, 29 Apr 2013 22:27:03 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: David VomLehn <David.VomLehn@spacex.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] Msleep_interruptible() on a dual processor system may
 wait a long time.
Message-ID: <20130430022703.GA9583@home.goodmis.org>
References: <20130430012015.GB1504@dvomlehn-z8.spacex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130430012015.GB1504@dvomlehn-z8.spacex.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This should have been Cc'd to the scheduler maintainers.

-- Steve

On Mon, Apr 29, 2013 at 06:20:28PM -0700, David VomLehn wrote:
> Msleep_interruptible() on a dual processor system may wait a long time.
> 
> On some reboots, calling msleep_interruptible() from CPU 1 on a dual
> processor system will not return for seconds or even minutes. This happens
> because ksoftirqd/1 migrates to CPU 0, which is allowed because its
> cpus_allowed mask is 0x3. Since ksoftirqd daemons only process the timer queue
> for their current CPU, no timer_list entries will be processed on CPU 1 until
> the ksoftirqd/1 migrates back to that CPU, which depends on system load and
> may take an arbitrary amount of time. The task associated with the
> msleep_interruptible() call may thus hang quite a while.
> 
> The root cause appears to be to a race condition between select_fallback_rq(),
> which selects a runqueue for a task, and set_cpu_active(), which sets the
> corresponding bit in cpu_active_mask for a newly active CPU. When ksoftirqd/1
> is run for the first time, its cpus_allowed mask is set to 0x2, i.e. it is
> restricted to CPU 1. The function select_task_rq() will be called, which calls
> select_task_rq_fair(). This will return a 0 for the CPU on which to run the
> task. When select_task_rq() finds the task is not allowed to run on CPU 0,
> it calls select_fallback_rq() to choose a new CPU. There are two cases:
> 
> o	If set_cpu_active() ran for CPU 1 before select_fallback_rq(), the
> 	corresponding bit in cpu_active_mask will be set, allowing ksoftirqd/1
> 	to run on that CPU.
> o	If the order of calls was reversed, select_fallback_rq() will call
> 	cpuset_cpus_allowed_fallback(), which will replace the task's
> 	cpus_allowed_mask with cpu_possible_mask, allowing ksoftirqd/1 to
> 	run on any CPU. It will also choose any CPU from the active CPUs. 
> 
> In the second case, ksoftirqd/1 will be able to roam freely across the
> system's CPUs, neglecting its responsibility to the timer queue.
> 
> Signed-off-by: David VomLehn <dvomlehn@spacex.com>
> ---
>  include/linux/cpu.h |    4 ++++
>  include/linux/smp.h |    3 +++
>  kernel/cpu.c        |    5 +----
>  kernel/sched.c      |    4 ++++
>  kernel/smp.c        |   22 ++++++++++++++++++++--
>  5 files changed, 32 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/cpu.h b/include/linux/cpu.h
> index c692acc..9679dfe 100644
> --- a/include/linux/cpu.h
> +++ b/include/linux/cpu.h
> @@ -138,6 +138,7 @@ int cpu_up(unsigned int cpu);
>  void notify_cpu_starting(unsigned int cpu);
>  extern void cpu_maps_update_begin(void);
>  extern void cpu_maps_update_done(void);
> +extern int cpu_notify(unsigned long val, void *v);
>  
>  #else	/* CONFIG_SMP */
>  
> @@ -160,6 +161,9 @@ static inline void cpu_maps_update_done(void)
>  {
>  }
>  
> +static inline int cpu_notify(unsigned long val, void *v)
> +{
> +}
>  #endif /* CONFIG_SMP */
>  extern struct sysdev_class cpu_sysdev_class;
>  
> diff --git a/include/linux/smp.h b/include/linux/smp.h
> index 8cc38d3..1065d73 100644
> --- a/include/linux/smp.h
> +++ b/include/linux/smp.h
> @@ -37,6 +37,9 @@ int smp_call_function_single(int cpuid, smp_call_func_t func, void *info,
>  #include <linux/thread_info.h>
>  #include <asm/smp.h>
>  
> +/* Number of CPUs we kicked that we are waiting to become active */
> +extern atomic_t active_cpu_pending;
> +
>  /*
>   * main cross-CPU interfaces, handles INIT, TLB flush, STOP, etc.
>   * (defined in asm header):
> diff --git a/kernel/cpu.c b/kernel/cpu.c
> index 563f136..4a11f33 100644
> --- a/kernel/cpu.c
> +++ b/kernel/cpu.c
> @@ -150,7 +150,7 @@ static int __cpu_notify(unsigned long val, void *v, int nr_to_call,
>  	return notifier_to_errno(ret);
>  }
>  
> -static int cpu_notify(unsigned long val, void *v)
> +int cpu_notify(unsigned long val, void *v)
>  {
>  	return __cpu_notify(val, v, -1, NULL);
>  }
> @@ -315,9 +315,6 @@ static int __cpuinit _cpu_up(unsigned int cpu, int tasks_frozen)
>  		goto out_notify;
>  	BUG_ON(!cpu_online(cpu));
>  
> -	/* Now call notifier in preparation. */
> -	cpu_notify(CPU_ONLINE | mod, hcpu);
> -
>  out_notify:
>  	if (ret != 0)
>  		__cpu_notify(CPU_UP_CANCELED | mod, hcpu, nr_calls, NULL);
> diff --git a/kernel/sched.c b/kernel/sched.c
> index fcc893f..907d166 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -2539,6 +2539,10 @@ static int select_fallback_rq(int cpu, struct task_struct *p)
>  	int dest_cpu;
>  	const struct cpumask *nodemask = cpumask_of_node(cpu_to_node(cpu));
>  
> +	/* Loop because preempt we may be disabled or in atomic context */
> +	while (atomic_read(&active_cpu_pending) != 0)
> +		;
> +
>  	/* Look for allowed, online CPU in same node. */
>  	for_each_cpu_and(dest_cpu, nodemask, cpu_active_mask)
>  		if (cpumask_test_cpu(dest_cpu, tsk_cpus_allowed(p)))
> diff --git a/kernel/smp.c b/kernel/smp.c
> index db197d6..d9635af 100644
> --- a/kernel/smp.c
> +++ b/kernel/smp.c
> @@ -42,6 +42,17 @@ struct call_single_queue {
>  
>  static DEFINE_PER_CPU_SHARED_ALIGNED(struct call_single_queue, call_single_queue);
>  
> +/*
> + * Declarations to support waiting until the cpu_up() functions are all
> + * called before trying to wake up associated softirqds. Note that
> + * active_cpu_pending is initialized to one to prevent waiters from
> + * trying to do things before we get to smp_init().
> + */
> +atomic_t active_cpu_pending = ATOMIC_INIT(1);
> +static __initdata DECLARE_BITMAP(cpu_notify_pending_bits, CONFIG_NR_CPUS);
> +struct __initdata cpumask * const cpu_notify_pending_mask =
> +	to_cpumask(cpu_notify_pending_bits);
> +
>  static int
>  hotplug_cfd(struct notifier_block *nfb, unsigned long action, void *hcpu)
>  {
> @@ -673,10 +684,17 @@ void __init smp_init(void)
>  	for_each_present_cpu(cpu) {
>  		if (num_online_cpus() >= setup_max_cpus)
>  			break;
> -		if (!cpu_online(cpu))
> -			cpu_up(cpu);
> +		if (!cpu_online(cpu) && cpu_up(cpu) == 0)
> +			cpumask_set_cpu(cpu, cpu_notify_pending_mask);
>  	}
>  
> +	/* Release anyone waiting for active CPUs to be identified */
> +	atomic_set(&active_cpu_pending, 0);
> +
> +	/* Now call notifier in preparation. */
> +	for_each_cpu(cpu, cpu_notify_pending_mask)
> +		cpu_notify(CPU_ONLINE, (void *)(long)cpu);
> +
>  	/* Any cleanup work */
>  	printk(KERN_INFO "Brought up %ld CPUs\n", (long)num_online_cpus());
>  	smp_cpus_done(setup_max_cpus);
> -- 
> David VL
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
