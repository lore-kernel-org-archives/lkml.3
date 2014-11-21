Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757176AbaKUOTz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 09:19:55 -0500
Received: from www.linutronix.de ([62.245.132.108]:57386 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751175AbaKUOTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 09:19:53 -0500
Date: Fri, 21 Nov 2014 15:19:52 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Vikas Shivappa <vikas.shivappa@linux.intel.com>
cc: linux-kernel@vger.kernel.org, vikas.shivappa@intel.com, hpa@zytor.com,
        mingo@kernel.org, tj@kernel.org, matt.flemming@intel.com,
        will.auld@intel.com, peterz@infradead.org
Subject: Re: [PATCH] x86: Intel Cache Allocation Technology support
In-Reply-To: <1416445539-24856-1-git-send-email-vikas.shivappa@linux.intel.com>
Message-ID: <alpine.DEB.2.11.1411211224070.6439@nanos>
References: <1416445539-24856-1-git-send-email-vikas.shivappa@linux.intel.com>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001,URIBL_BLOCKED=0.001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Nov 2014, Vikas Shivappa wrote:

> +/* maximum possible cbm length */
> +#define MAX_CBM_LENGTH                 32
> +
> +#define IA32_CBMMAX_MASK(x)            (0xffffffff & (~((u64)(1 << x) - 1)))

Unused define.

> +
> +#define IA32_CBM_MASK                          0xffffffff

  (~0U) ?

> @@ -0,0 +1,144 @@
> +static inline void cacheqe_sched_in(struct task_struct *task)
> +{
> +	struct cacheqe *cq;
> +	unsigned int clos;
> +	unsigned int l, h;

These variable names suck. You say in the comment below: 
      
      write the PQR for the proc.

So what is it now? clos or pqr or what?

IA32_PQR_ASSOC is the MSR name and bit 0-9 is RMID and bit 32-63 is
COS

But you create random names just because it makes it harder to map the
code to the SDM or is there some other sensible reason I'm missing
here?

> +
> +	if (!cqe_genable)
> +		return;

This wants to be a static key.

> +	rdmsr(IA32_PQR_ASSOC, l, h);

Why on earth do we want to read an MSR on every context switch? What's
wrong with having

DEFINE_PER_CPU(u64, cacheqe_pqr);

	u64 next_pqr, cur_pqr = this_cpu_read(cacheqe_pqr);

	cq = task_cacheqe(task);
	next_pqr = cq ? cq->pqr : 0;

	if (next_pqr != cur_pqr) {
	   	wrmsrl(IA32_PQR_ASSOC, next_pqr);
		this_cpu_write(cacheqe_pqr, next_pqr);
	}

That saves the whole idiocity of reading MSRs on schedule in and
schedule out. In fact it makes the schedule_out part completely
superfluous.

> +	rcu_read_lock();
> +	cq = task_cacheqe(task);
> +
> +	if (cq == NULL || cq->clos == h) {
> +		rcu_read_unlock();
> +		return;
> +	}
> +
> +	clos = cq->clos;
> +
> +	/*
> +	 * After finding the cacheqe of the task , write the PQR for the proc.
> +	 * We are assuming the current core is the one its scheduled to.

You are in the middle of the scheduler. So what needs to be assumed
here?

> +	 * In unified scheduling , write the PQR each time.

What the heck is unified scheduling?

> +	 */
> +	wrmsr(IA32_PQR_ASSOC, l, clos);
> +	rcu_read_unlock();
> +
> +	CQE_DEBUG(("schedule in clos :0x%x,task cpu:%u, currcpu: %u,pid:%u\n",
> +		       clos, task_cpu(task), smp_processor_id(), task->pid));

A printk in the guts of the sched_switch function? Ever heard about
trace points?

> +
> +}
> +
> +static inline void cacheqe_sched_out(struct task_struct *task)
> +{
> +	unsigned int l, h;
> +
> +	if (!cqe_genable)
> +		return;
> +
> +	rdmsr(IA32_PQR_ASSOC, l, h);
> +
> +	if (h == 0)
> +		return;
> +
> +	/*
> +	  *After finding the cacheqe of the task , write the PQR for the proc.
> +	 * We are assuming the current core is the one its scheduled to.
> +	 * Write zero when scheduling out so that we get a more accurate
> +	 * cache allocation.

This comment makes no sense at all. But well, this does not make sense
anyway.

> +ifdef CONFIG_CACHEQE_DEBUG
> +CFLAGS_cacheqe.o := -DDEBUG
> +endif

Certainly NOT!

> +++ b/arch/x86/kernel/cpu/cacheqe.c
> @@ -0,0 +1,487 @@
> +
> +/*
> + *  kernel/cacheqe.c

What's the point of the file name here? Especially if the file is not
there at all.

> +#include <asm/cacheqe.h>
> +
> +struct cacheqe root_cqe_group;
> +static DEFINE_MUTEX(cqe_group_mutex);
> +
> +bool cqe_genable;

This wants to be readmostly, if it's a global, but we really want a
static key for this.

> +
> +/* ccmap maintains 1:1 mapping between CLOSid and cbm.*/
> +
> +static struct closcbm_map *ccmap;
> +static struct cacheqe_subsys_info *cqess_info;
> +
> +char hsw_brandstrs[5][64] = {
> +			"Intel(R) Xeon(R)  CPU E5-2658 v3  @  2.20GHz",
> +			"Intel(R) Xeon(R)  CPU E5-2648L v3  @  1.80GHz",
> +			"Intel(R) Xeon(R)  CPU E5-2628L v3  @  2.00GHz",
> +			"Intel(R) Xeon(R)  CPU E5-2618L v3  @  2.30GHz",
> +			"Intel(R) Xeon(R)  CPU E5-2608L v3  @  2.00GHz"
> +};
> +
> +#define cacheqe_for_each_child(child_cq, pos_css, parent_cq)		\
> +	css_for_each_child((pos_css),	\
> +	&(parent_cq)->css)
> +
> +#if CONFIG_CACHEQE_DEBUG

We really do NOT need another config option for this. See above.

> +/*DUMP the closid-cbm map.*/

Wow that comment is really informative.

> +static inline bool cqe_enabled(struct cpuinfo_x86 *c)
> +{
> +
> +	int i;
> +
> +	if (cpu_has(c, X86_FEATURE_CQE_L3))
> +		return true;
> +
> +	/*
> +	 * Hard code the checks and values for HSW SKUs.
> +	 * Unfortunately! have to check against only these brand name strings.
> +	 */

You must be kidding.

> +
> +	for (i = 0; i < 5; i++)
> +		if (!strcmp(hsw_brandstrs[i], c->x86_model_id)) {
> +			c->x86_cqe_closs = 4;
> +			c->x86_cqe_cbmlength = 20;
> +			return true;
> +		}
> +
> +	return false;
> +
> +}
> +
> +
> +static int __init cqe_late_init(void)
> +{
> +
> +	struct cpuinfo_x86 *c = &boot_cpu_data;
> +	size_t sizeb;
> +	int maxid = boot_cpu_data.x86_cqe_closs;
> +
> +	cqe_genable = false;

Right, we need to initialize bss storage.

> +
> +	/*
> +	 * Need the cqe_genable hint helps decide if the
> +	 * kernel has enabled cache allocation.
> +	 */

What hint? 

> +	if (!cqe_enabled(c)) {
> +
> +		root_cqe_group.css.ss->disabled = 1;
> +		return -ENODEV;
> +
> +	} else {
> +
> +		cqess_info =
> +				kzalloc(sizeof(struct cacheqe_subsys_info),
> +						 GFP_KERNEL);

Can you add a few more newlines so the code gets better readable?

> +
> +		if (!cqess_info)
> +			return -ENOMEM;
> +
> +		sizeb = BITS_TO_LONGS(c->x86_cqe_closs) * sizeof(long);
> +		cqess_info->closmap =
> +				kzalloc(sizeb, GFP_KERNEL);

Sigh.

> +		if (!cqess_info->closmap) {
> +			kfree(cqess_info);
> +			return -ENOMEM;
> +		}
> +
> +		sizeb = maxid * sizeof(struct closcbm_map);
> +		ccmap = kzalloc(sizeb, GFP_KERNEL);
> +
> +		if (!ccmap)
> +			return -ENOMEM;

Leaks closmap and cqess_info.

> +		barrier();
> +		cqe_genable = true;

What's the exact point of that barrier?

> +}
> +

Stray newline. checkpatch.pl is optional, right?

> +late_initcall(cqe_late_init);
> +
> +/*
> + * Allocates a new closid from unused list of closids.

There is no unused list.

> + * Called with the cqe_group_mutex held.
> + */
> +
> +static int cqe_alloc_closid(struct cacheqe *cq)
> +{
> +	unsigned int tempid;
> +	unsigned int maxid;
> +	int err;
> +
> +	maxid = boot_cpu_data.x86_cqe_closs;
> +
> +	tempid = find_next_zero_bit(cqess_info->closmap, maxid, 0);
> +
> +	if (tempid == maxid) {
> +		err = -ENOSPC;
> +		goto closidallocfail;

What's the point of the goto? What's wrong with 'return -ENOSPC;' ?

> +	}
> +
> +	set_bit(tempid, cqess_info->closmap);
> +	ccmap[tempid].ref++;
> +	cq->clos = tempid;
> +
> +	pr_debug("cqe : Allocated a directory.closid:%u\n", cq->clos);

And of course we have no idea whatfor this closid got allocated. Your
debug info is just useless.

> +static void cqe_free_closid(struct cacheqe *cq)
> +{
> +
> +	pr_debug("cqe :Freeing closid:%u\n", cq->clos);
> +
> +	ccmap[cq->clos].ref--;

This wants a sanity check to catch ref == 0.

> +/* Create a new cacheqe cgroup.*/
> +static struct cgroup_subsys_state *
> +cqe_css_alloc(struct cgroup_subsys_state *parent_css)
> +{
> +	struct cacheqe *parent = css_cacheqe(parent_css);
> +	struct cacheqe *cq;
> +
> +	/* This is the call before the feature is detected */

Huch? We know at early boot that this is available. So why do you need
this? The first call to this should never happen before the whole
thing is initialized. If it happens, it's a design failure.

> +	if (!parent) {
> +		root_cqe_group.clos = 0;
> +		return &root_cqe_group.css;
> +	}
> +
> +	/* To check if cqe is enabled.*/
> +	if (!cqe_genable)
> +		return ERR_PTR(-ENODEV);

So we first check for !parent and return &root_cqe_group.css and later
we return an error pointer? Really consistent behaviour.

> +/* Destroy an existing CAT cgroup.*/

If you would spend some time on providing real comments instead of
documenting the obvious ...

> +static void cqe_css_free(struct cgroup_subsys_state *css)
> +{
> +	struct cacheqe *cq = css_cacheqe(css);
> +	int len = boot_cpu_data.x86_cqe_cbmlength;
> +
> +	pr_debug("cqe : In cacheqe_css_free\n");
> +
> +	mutex_lock(&cqe_group_mutex);
> +
> +	/* Reset the CBM for the cgroup.Should be all 1s by default !*/
> +
> +	wrmsrl(CQECBMMSR(cq->clos), ((1 << len) - 1));

So that's writing to IA32_L3_MASK_n, right? Pretty obvious name:
CQECBMMSR.

And the write should set ALL bits to 1 not just the enabled ones if I
understand the SDM correctly and what you said in your own comment
above.

Aside of that what guarantees that all references to this L3_MASK are
gone? You allow the sharing of COS ids. Your whole refcounting scheme
is a trainwreck. And when the COS id is not longer in use, there is no
point in writing the MSR at all. It does not matter whats in there if
nothing ever uses it.

> +	cqe_free_closid(cq);
> +	kfree(cq);
> +
> +	mutex_unlock(&cqe_group_mutex);
> +
> +}
> +
> +/*
> + * Called during do_exit() syscall during a task exit.
> + * This assumes that the thread is running on the current
> + * cpu.

Your assumptions about running on current cpu are interesting. On
which CPU is a task supposed to run, when it is on a CPU? Surely on
some other cpu, right?

> + */
> +
> +static void cqe_exit(struct cgroup_subsys_state *css,
> +			    struct cgroup_subsys_state *old_css,
> +			    struct task_struct *task)
> +{
> +
> +	cacheqe_sched_out(task);

And whats the point here? Nothing at all. You need to clean the
associated data and then the exit schedule will clean up the PQR
automatically.

> +
> +}
> +
> +static inline bool cbm_minbits(unsigned long var)
> +{
> +

Your supply of useless newlines is endless.

> +	unsigned long i;
> +
> +	/*Minimum of 2 bits must be set.*/
> +
> +	i = var & (var - 1);
> +	if (!i || !var)
> +		return false;
> +
> +	return true;
> +
> +}

What's wrong with using bitmap functions consistently? So this test
would simply become:

      bitmap_weight(map, nrbits) < 2

> +
> +/*
> + * Tests if only contiguous bits are set.
> + */
> +
> +static inline bool cbm_iscontiguous(unsigned long var)
> +{

This one here can be implemented with existing bitmap functions as
well.

Would be too simple and too obvious to understand, right?

> +static int cqe_cbm_read(struct seq_file *m, void *v)
> +{
> +	struct cacheqe *cq = css_cacheqe(seq_css(m));
> +
> +	pr_debug("cqe : In cqe_cqemode_read\n");

We really need a debug printk for a seqfile read function, right?

> +	seq_printf(m, "0x%x\n", (unsigned int)*(cq->cbm));

seq_bitmap()

> +static int validate_cbm(struct cacheqe *cq, unsigned long cbmvalue)
> +{
> +	struct cacheqe *par, *c;
> +	struct cgroup_subsys_state *css;
> +
> +	if (!cbm_minbits(cbmvalue) || !cbm_iscontiguous(cbmvalue)) {
> +		pr_info("CQE error: minimum bits not set or non contiguous mask\n");
> +		return -EINVAL;
> +	}
> +
> +	/*
> +	 * Needs to be a subset of its parent.
> +	 */
> +	par = parent_cqe(cq);
> +
> +	if (!bitmap_subset(&cbmvalue, par->cbm, MAX_CBM_LENGTH))
> +		return -EINVAL;
> +
> +	rcu_read_lock();
> +
> +	/*
> +	 * Each of children should be a subset of the mask.
> +	 */
> +
> +	cacheqe_for_each_child(c, css, cq) {
> +		c = css_cacheqe(css);
> +		if (!bitmap_subset(c->cbm, &cbmvalue, MAX_CBM_LENGTH)) {
> +			pr_debug("cqe : Children's cbm not a subset\n");
> +			return -EINVAL;
> +		}
> +	}

So now you have 3 error exits here. One with pr_info, one with out and
one with pr_debug. And of course the most obvious to figure out has a
pr_info. Useful.

> +static bool cbm_search(unsigned long cbm, int *closid)
> +{
> +
> +	int maxid = boot_cpu_data.x86_cqe_closs;
> +	unsigned int i;
> +
> +	for (i = 0; i < maxid; i++)
> +		if (bitmap_equal(&cbm, &ccmap[i].cbm, MAX_CBM_LENGTH)) {
> +			*closid = i;
> +			return true;
> +		}
> +
> +	return false;
> +
> +}
> +
> +static int cqe_cbm_write(struct cgroup_subsys_state *css,
> +				 struct cftype *cft, u64 cbmvalue)
> +{
> +	struct cacheqe *cq = css_cacheqe(css);
> +	ssize_t err = 0;
> +	unsigned long cbm;
> +	unsigned int closid;
> +
> +	pr_debug("cqe : In cqe_cbm_write\n");

Groan.

> +	if (!cqe_genable)
> +		return -ENODEV;
> +
> +	if (cq == &root_cqe_group || !cq)
> +		return -EPERM;
> +
> +	/*
> +	* Need global mutex as cbm write may allocate the closid.

You need to protect against changes on all ends, not only allocating a
closid.

> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index 4b4f78c..a9b277a 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -633,6 +633,27 @@ void get_cpu_cap(struct cpuinfo_x86 *c)
>  		c->x86_capability[9] = ebx;
>  	}
>  
> +/* Additional Intel-defined flags: level 0x00000010 */
> +	if (c->cpuid_level >= 0x00000010) {
> +		u32 eax, ebx, ecx, edx;
> +
> +		cpuid_count(0x00000010, 0, &eax, &ebx, &ecx, &edx);
> +
> +		c->x86_capability[10] = ebx;
> +
> +		if (cpu_has(c, X86_FEATURE_CQE_L3)) {
> +
> +			u32 eax, ebx, ecx, edx;

If you add another indentation level, you can define the same
variables once more.

> +
> +			cpuid_count(0x00000010, 1, &eax, &ebx, &ecx, &edx);
> +
> +			c->x86_cqe_closs = (edx & 0xffff) + 1;
> +			c->x86_cqe_cbmlength = (eax & 0xf) + 1;
> +config CACHEQE_DEBUG
> +  bool "Cache QoS Enforcement cgroup subsystem debug"

This needs to go away. The debugging you provide is beyond useless. We
want proper tracepoints for that not random debug printks with no value.

> +  depends on X86 || X86_64
> +  help
> +    This option provides framework to allocate Cache cache lines when
> +    applications fill cache.
> +    This can be used by users to configure how much cache that can be
> +    allocated to different PIDs.Enables debug

Copy and paste is wonderful, right?

> +		Say N if unsure.
> +
>  config PROC_PID_CPUSET
>  	bool "Include legacy /proc/<pid>/cpuset file"
>  	depends on CPUSETS
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 240157c..afa2897 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -2215,7 +2215,7 @@ prepare_task_switch(struct rq *rq, struct task_struct *prev,
>  	perf_event_task_sched_out(prev, next);
>  	fire_sched_out_preempt_notifiers(prev, next);
>  	prepare_lock_switch(rq, next);
> -	prepare_arch_switch(next);
> +	prepare_arch_switch(prev);

Great. You just broke all architectures which implement
prepare_arch_switch(). Congratulations!

>  }
>  
>  /**
> @@ -2254,7 +2254,7 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
>  	 */
>  	prev_state = prev->state;
>  	vtime_task_switch(prev);
> -	finish_arch_switch(prev);
> +	finish_arch_switch(current);

Ditto.

>  	perf_event_task_sched_in(prev, current);
>  	finish_lock_switch(rq, prev);
>  	finish_arch_post_lock_switch();
> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index 24156c84..79b9ff6 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -965,12 +965,36 @@ static inline int task_on_rq_migrating(struct task_struct *p)
>  	return p->on_rq == TASK_ON_RQ_MIGRATING;
>  }
>  
> +#ifdef CONFIG_X86_64
> +#ifdef CONFIG_CGROUP_CACHEQE
> +
> +#include <asm/cacheqe.h>

We surely not put x86 specific nonsense in the core scheduler
code. Did you ever come up with the idea to look how this is used by
other architectures? Obviously not.

I have no idea how Matts reviewed tag got onto this masterpiece of trainwreck engineering and I better dont want to know.

Thanks,

	tglx





