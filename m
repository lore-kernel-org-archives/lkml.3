Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851Ab3GKILO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 04:11:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22193 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755602Ab3GKILI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 04:11:08 -0400
Date: Thu, 11 Jul 2013 11:10:25 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@redhat.com,
        glommer@parallels.com, tglx@linutronix.de, jeremy@goop.org,
        rostedt@goodmis.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove sched notifier for cross-cpu migrations
Message-ID: <20130711081025.GE5895@redhat.com>
References: <20130710103440.GO25631@dyad.programming.kicks-ass.net>
 <20130711012157.GA21489@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130711012157.GA21489@amt.cnet>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 10, 2013 at 10:21:57PM -0300, Marcelo Tosatti wrote:
> 
> Linux as a guest on KVM hypervisor, the only user of the pvclock      
> vsyscall interface, does not require notification on task migration 
> because:
> 
> 1. cpu ID number maps 1:1 to per-CPU pvclock time info.
> 2. per-CPU pvclock time info is updated if the
>    underlying CPU changes.
> 3. that version is increased whenever underlying CPU 
>    changes.
> 
Is this the case with KVM though? IIRC KVM does not updates kvmclock
on vcpu migration if host has synchronized TSC.

> Which is sufficient to guarantee nanoseconds counter
> is calculated properly.
> 
> Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
> 
> diff --git a/arch/x86/include/asm/pvclock.h b/arch/x86/include/asm/pvclock.h
> index 109a9dd..be8269b 100644
> --- a/arch/x86/include/asm/pvclock.h
> +++ b/arch/x86/include/asm/pvclock.h
> @@ -93,7 +93,6 @@ unsigned __pvclock_read_cycles(const struct pvclock_vcpu_time_info *src,
>  
>  struct pvclock_vsyscall_time_info {
>  	struct pvclock_vcpu_time_info pvti;
> -	u32 migrate_count;
>  } __attribute__((__aligned__(SMP_CACHE_BYTES)));
>  
>  #define PVTI_SIZE sizeof(struct pvclock_vsyscall_time_info)
> diff --git a/arch/x86/kernel/pvclock.c b/arch/x86/kernel/pvclock.c
> index 2cb9470..a16bae3 100644
> --- a/arch/x86/kernel/pvclock.c
> +++ b/arch/x86/kernel/pvclock.c
> @@ -128,46 +128,7 @@ void pvclock_read_wallclock(struct pvclock_wall_clock *wall_clock,
>  	set_normalized_timespec(ts, now.tv_sec, now.tv_nsec);
>  }
>  
> -static struct pvclock_vsyscall_time_info *pvclock_vdso_info;
> -
> -static struct pvclock_vsyscall_time_info *
> -pvclock_get_vsyscall_user_time_info(int cpu)
> -{
> -	if (!pvclock_vdso_info) {
> -		BUG();
> -		return NULL;
> -	}
> -
> -	return &pvclock_vdso_info[cpu];
> -}
> -
> -struct pvclock_vcpu_time_info *pvclock_get_vsyscall_time_info(int cpu)
> -{
> -	return &pvclock_get_vsyscall_user_time_info(cpu)->pvti;
> -}
> -
>  #ifdef CONFIG_X86_64
> -static int pvclock_task_migrate(struct notifier_block *nb, unsigned long l,
> -			        void *v)
> -{
> -	struct task_migration_notifier *mn = v;
> -	struct pvclock_vsyscall_time_info *pvti;
> -
> -	pvti = pvclock_get_vsyscall_user_time_info(mn->from_cpu);
> -
> -	/* this is NULL when pvclock vsyscall is not initialized */
> -	if (unlikely(pvti == NULL))
> -		return NOTIFY_DONE;
> -
> -	pvti->migrate_count++;
> -
> -	return NOTIFY_DONE;
> -}
> -
> -static struct notifier_block pvclock_migrate = {
> -	.notifier_call = pvclock_task_migrate,
> -};
> -
>  /*
>   * Initialize the generic pvclock vsyscall state.  This will allocate
>   * a/some page(s) for the per-vcpu pvclock information, set up a
> @@ -181,17 +142,12 @@ int __init pvclock_init_vsyscall(struct pvclock_vsyscall_time_info *i,
>  
>  	WARN_ON (size != PVCLOCK_VSYSCALL_NR_PAGES*PAGE_SIZE);
>  
> -	pvclock_vdso_info = i;
> -
>  	for (idx = 0; idx <= (PVCLOCK_FIXMAP_END-PVCLOCK_FIXMAP_BEGIN); idx++) {
>  		__set_fixmap(PVCLOCK_FIXMAP_BEGIN + idx,
>  			     __pa(i) + (idx*PAGE_SIZE),
>  			     PAGE_KERNEL_VVAR);
>  	}
>  
> -
> -	register_task_migration_notifier(&pvclock_migrate);
> -
>  	return 0;
>  }
>  #endif
> diff --git a/arch/x86/vdso/vclock_gettime.c b/arch/x86/vdso/vclock_gettime.c
> index c74436e..72074d5 100644
> --- a/arch/x86/vdso/vclock_gettime.c
> +++ b/arch/x86/vdso/vclock_gettime.c
> @@ -85,15 +85,18 @@ static notrace cycle_t vread_pvclock(int *mode)
>  	cycle_t ret;
>  	u64 last;
>  	u32 version;
> -	u32 migrate_count;
>  	u8 flags;
>  	unsigned cpu, cpu1;
>  
>  
>  	/*
> -	 * When looping to get a consistent (time-info, tsc) pair, we
> -	 * also need to deal with the possibility we can switch vcpus,
> -	 * so make sure we always re-fetch time-info for the current vcpu.
> +	 * Note: hypervisor must guarantee that:
> +	 * 1. cpu ID number maps 1:1 to per-CPU pvclock time info.
> +	 * 2. that per-CPU pvclock time info is updated if the
> +	 *    underlying CPU changes.
> +	 * 3. that version is increased whenever underlying CPU
> +	 *    changes.
> +	 *
>  	 */
>  	do {
>  		cpu = __getcpu() & VGETCPU_CPU_MASK;
> @@ -104,8 +107,6 @@ static notrace cycle_t vread_pvclock(int *mode)
>  
>  		pvti = get_pvti(cpu);
>  
> -		migrate_count = pvti->migrate_count;
> -
>  		version = __pvclock_read_cycles(&pvti->pvti, &ret, &flags);
>  
>  		/*
> @@ -117,8 +118,7 @@ static notrace cycle_t vread_pvclock(int *mode)
>  		cpu1 = __getcpu() & VGETCPU_CPU_MASK;
>  	} while (unlikely(cpu != cpu1 ||
>  			  (pvti->pvti.version & 1) ||
> -			  pvti->pvti.version != version ||
> -			  pvti->migrate_count != migrate_count));
> +			  pvti->pvti.version != version));
>  
>  	if (unlikely(!(flags & PVCLOCK_TSC_STABLE_BIT)))
>  		*mode = VCLOCK_NONE;
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 178a8d9..217ce4b 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -107,14 +107,6 @@ extern unsigned long this_cpu_load(void);
>  extern void calc_global_load(unsigned long ticks);
>  extern void update_cpu_load_nohz(void);
>  
> -/* Notifier for when a task gets migrated to a new CPU */
> -struct task_migration_notifier {
> -	struct task_struct *task;
> -	int from_cpu;
> -	int to_cpu;
> -};
> -extern void register_task_migration_notifier(struct notifier_block *n);
> -
>  extern unsigned long get_parent_ip(unsigned long addr);
>  
>  extern void dump_cpu_task(int cpu);
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index e8b3350..122e499 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -974,13 +974,6 @@ void check_preempt_curr(struct rq *rq, struct task_struct *p, int flags)
>  		rq->skip_clock_update = 1;
>  }
>  
> -static ATOMIC_NOTIFIER_HEAD(task_migration_notifier);
> -
> -void register_task_migration_notifier(struct notifier_block *n)
> -{
> -	atomic_notifier_chain_register(&task_migration_notifier, n);
> -}
> -
>  #ifdef CONFIG_SMP
>  void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
>  {
> @@ -1011,18 +1004,10 @@ void set_task_cpu(struct task_struct *p, unsigned int new_cpu)
>  	trace_sched_migrate_task(p, new_cpu);
>  
>  	if (task_cpu(p) != new_cpu) {
> -		struct task_migration_notifier tmn;
> -
>  		if (p->sched_class->migrate_task_rq)
>  			p->sched_class->migrate_task_rq(p, new_cpu);
>  		p->se.nr_migrations++;
>  		perf_sw_event(PERF_COUNT_SW_CPU_MIGRATIONS, 1, NULL, 0);
> -
> -		tmn.task = p;
> -		tmn.from_cpu = task_cpu(p);
> -		tmn.to_cpu = new_cpu;
> -
> -		atomic_notifier_call_chain(&task_migration_notifier, 0, &tmn);
>  	}
>  
>  	__set_task_cpu(p, new_cpu);
> 

--
			Gleb.
