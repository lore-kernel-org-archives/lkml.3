Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751886AbaKUVZx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 16:25:53 -0500
Received: from mga11.intel.com ([192.55.52.93]:32981 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750969AbaKUVZv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 16:25:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,432,1413270000"; 
   d="scan'208";a="636133657"
Date: Fri, 21 Nov 2014 13:25:36 -0800 (PST)
From: Vikas Shivappa <vikas.shivappa@intel.com>
X-X-Sender: vikas@vshiva-Udesk
To: Vikas Shivappa <vikas.shivappa@linux.intel.com>
cc: linux-kernel@vger.kernel.org, vikas.shivappa@intel.com, hpa@zytor.com,
        tglx@linutronix.de, mingo@kernel.org, tj@kernel.org,
        Matt Fleming <matt.fleming@intel.com>,
        "Auld, Will" <will.auld@intel.com>, peterz@infradead.org
Subject: Re: [PATCH] x86: Intel Cache Allocation Technology support
In-Reply-To: <1416445539-24856-1-git-send-email-vikas.shivappa@linux.intel.com>
Message-ID: <alpine.DEB.2.10.1411211323520.30781@vshiva-Udesk>
References: <1416445539-24856-1-git-send-email-vikas.shivappa@linux.intel.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Correcting email address for Matt.

On Wed, 19 Nov 2014, Vikas Shivappa wrote:

> What is Cache Allocation Technology ( CAT )
> -------------------------------------------
>
> Cache Allocation Technology provides a way for the Software (OS/VMM) to
> restrict cache allocation to a defined 'subset' of cache which may be
> overlapping with other 'subsets'.  This feature is used when allocating
> a line in cache ie when pulling new data into the cache.  The
> programming of the h/w is done via programming  MSRs.
>
> The different cache subsets are identified by CLOS identifier (class of
> service) and each CLOS has a CBM (cache bit mask).  The CBM is a
> contiguous set of bits which defines the amount of cache resource that
> is available for each 'subset'.
>
> Why is CAT (cache allocation technology)  needed
> ------------------------------------------------
>
> The CAT  enables more cache resources to be made available for higher
> priority applications based on guidance from the execution
> environment.
>
> The architecture also allows dynamically changing these subsets during
> runtime to further optimize the performance of the higher priority
> application with minimal degradation to the low priority app.
> Additionally, resources can be rebalanced for system throughput benefit.
>
> This technique may be useful in managing large computer systems which
> large LLC. Examples may be large servers running  instances of
> webservers or database servers. In such complex systems, these subsets
> can be used for more careful placing of the available cache resources.
>
> The CAT kernel patch would provide a basic kernel framework for users to
> be able to implement such cache subsets.
>
> Kernel Implementation
> ---------------------
>
> This patch implements a cgroup subsystem to support cache allocation.
> Each cgroup has a CLOSid <-> CBM(cache bit mask) mapping.  A
> CLOS(Class of service) is represented by a CLOSid.CLOSid is internal
> to the kernel and not exposed to user.  Each cgroup would have one CBM
> and would just represent one cache 'subset'.
>
> The cgroup follows cgroup hierarchy ,mkdir and adding tasks to the
> cgroup never fails.  When a child cgroup is created it inherits the
> CLOSid and the CBM from its parent.  When a user changes the default
> CBM for a cgroup, a new CLOSid may be allocated if the CBM was not
> used before.  The changing of 'cbm' may fail with -ERRNOSPC once the
> kernel runs out of maximum CLOSids it can support.
> User can create as many cgroups as he wants but having different CBMs
> at the same time is restricted by the maximum number of CLOSids
> (multiple cgroups can have the same CBM).
> Kernel maintains a CLOSid<->cbm mapping which keeps reference counter
> for each cgroup using a CLOSid.
>
> The tasks in the cgroup would get to fill the LLC cache represented by
> the cgroup's 'cbm' file.
>
> Root directory would have all available  bits set in 'cbm' file by
> default.
>
> Assignment of CBM,CLOS
> ---------------------------------
>
> The 'cbm' needs to be a  subset of the parent node's 'cbm'.  Any
> contiguous subset of these bits(with a minimum of 2 bits) maybe set to
> indicate the cache mapping desired.  The 'cbm' between 2 directories can
> overlap. The 'cbm' would represent the cache 'subset' of the CAT cgroup.
> For ex: on a system with 16 bits of max cbm bits, if the directory has
> the least significant 4 bits set in its 'cbm' file(meaning the 'cbm' is
> just 0xf), it would be allocated the right quarter of the Last level
> cache which means the tasks belonging to this CAT cgroup can use the
> right quarter of the cache to fill. If it has the most significant 8
> bits set ,it would be allocated the left half of the cache(8 bits  out
> of 16 represents 50%).
>
> The cache portion defined in the CBM file is available to all tasks
> within the cgroup to fill and these task are not allowed to allocate
> space in other parts of the cache.
>
> Scheduling and Context Switch
> ------------------------------
>
> During context switch kernel implements this by writing the CLOSid
> (internally maintained by kernel) of the cgroup to which the task
> belongs to the CPU's IA32_PQR_ASSOC MSR.
>
> Reviewed-by: Matt Flemming <matt.flemming@intel.com>
> Tested-by: Priya Autee <priya.v.autee@intel.com>
> Signed-off-by: Vikas Shivappa <vikas.shivappa@linux.intel.com>
> ---
> arch/x86/include/asm/cacheqe.h    | 144 +++++++++++
> arch/x86/include/asm/cpufeature.h |   4 +
> arch/x86/include/asm/processor.h  |   5 +-
> arch/x86/kernel/cpu/Makefile      |   5 +
> arch/x86/kernel/cpu/cacheqe.c     | 487 ++++++++++++++++++++++++++++++++++++++
> arch/x86/kernel/cpu/common.c      |  21 ++
> include/linux/cgroup_subsys.h     |   5 +
> init/Kconfig                      |  22 ++
> kernel/sched/core.c               |   4 +-
> kernel/sched/sched.h              |  24 ++
> 10 files changed, 718 insertions(+), 3 deletions(-)
> create mode 100644 arch/x86/include/asm/cacheqe.h
> create mode 100644 arch/x86/kernel/cpu/cacheqe.c
>
> diff --git a/arch/x86/include/asm/cacheqe.h b/arch/x86/include/asm/cacheqe.h
> new file mode 100644
> index 0000000..91d175e
> --- /dev/null
> +++ b/arch/x86/include/asm/cacheqe.h
> @@ -0,0 +1,144 @@
> +#ifndef _CACHEQE_H_
> +#define _CACHEQE_H_
> +
> +#include <linux/cgroup.h>
> +#include <linux/slab.h>
> +#include <linux/percpu.h>
> +#include <linux/spinlock.h>
> +#include <linux/cpumask.h>
> +#include <linux/seq_file.h>
> +#include <linux/rcupdate.h>
> +#include <linux/kernel_stat.h>
> +#include <linux/err.h>
> +
> +#ifdef CONFIG_CGROUP_CACHEQE
> +
> +#define IA32_PQR_ASSOC				0xc8f
> +#define IA32_PQR_MASK(x)			(x << 32)
> +
> +/* maximum possible cbm length */
> +#define MAX_CBM_LENGTH			32
> +
> +#define IA32_CBMMAX_MASK(x)		(0xffffffff & (~((u64)(1 << x) - 1)))
> +
> +#define IA32_CBM_MASK				0xffffffff
> +#define IA32_L3_CBM_BASE			0xc90
> +#define CQECBMMSR(x)				(IA32_L3_CBM_BASE + x)
> +
> +#ifdef CONFIG_CACHEQE_DEBUG
> +#define CQE_DEBUG(X) do { pr_info X; } while (0)
> +#else
> +#define CQE_DEBUG(X)
> +#endif
> +
> +extern bool cqe_genable;
> +
> +struct cacheqe_subsys_info {
> +	unsigned long *closmap;
> +};
> +
> +struct cacheqe {
> +	struct cgroup_subsys_state css;
> +
> +	/* class of service for the group*/
> +	unsigned int clos;
> +	/* corresponding cache bit mask*/
> +	unsigned long *cbm;
> +
> +};
> +
> +struct closcbm_map {
> +	unsigned long cbm;
> +	unsigned int ref;
> +};
> +
> +extern struct cacheqe root_cqe_group;
> +
> +/*
> + * Return cacheqos group corresponding to this container.
> + */
> +static inline struct cacheqe *css_cacheqe(struct cgroup_subsys_state *css)
> +{
> +	return css ? container_of(css, struct cacheqe, css) : NULL;
> +}
> +
> +static inline struct cacheqe *parent_cqe(struct cacheqe *cq)
> +{
> +	return css_cacheqe(cq->css.parent);
> +}
> +
> +/*
> + * Return cacheqe group to which this task belongs.
> + */
> +static inline struct cacheqe *task_cacheqe(struct task_struct *task)
> +{
> +	return css_cacheqe(task_css(task, cacheqe_cgrp_id));
> +}
> +
> +static inline void cacheqe_sched_in(struct task_struct *task)
> +{
> +	struct cacheqe *cq;
> +	unsigned int clos;
> +	unsigned int l, h;
> +
> +	if (!cqe_genable)
> +		return;
> +
> +	rdmsr(IA32_PQR_ASSOC, l, h);
> +
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
> +	 * In unified scheduling , write the PQR each time.
> +	 */
> +	wrmsr(IA32_PQR_ASSOC, l, clos);
> +	rcu_read_unlock();
> +
> +	CQE_DEBUG(("schedule in clos :0x%x,task cpu:%u, currcpu: %u,pid:%u\n",
> +		       clos, task_cpu(task), smp_processor_id(), task->pid));
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
> +	 */
> +
> +	wrmsr(IA32_PQR_ASSOC, l, 0);
> +
> +	CQE_DEBUG(("schedule out done cpu :%u,curr cpu:%u, pid:%u\n",
> +			  task_cpu(task), smp_processor_id(), task->pid));
> +
> +}
> +
> +#else
> +static inline void cacheqe_sched_in(struct task_struct *task) {}
> +
> +static inline void cacheqe_sched_out(struct task_struct *task) {}
> +
> +#endif
> +#endif
> diff --git a/arch/x86/include/asm/cpufeature.h b/arch/x86/include/asm/cpufeature.h
> index 0bb1335..21290ac 100644
> --- a/arch/x86/include/asm/cpufeature.h
> +++ b/arch/x86/include/asm/cpufeature.h
> @@ -221,6 +221,7 @@
> #define X86_FEATURE_INVPCID	( 9*32+10) /* Invalidate Processor Context ID */
> #define X86_FEATURE_RTM		( 9*32+11) /* Restricted Transactional Memory */
> #define X86_FEATURE_MPX		( 9*32+14) /* Memory Protection Extension */
> +#define X86_FEATURE_CQE		(9*32+15) /* Cache QOS Enforcement */
> #define X86_FEATURE_AVX512F	( 9*32+16) /* AVX-512 Foundation */
> #define X86_FEATURE_RDSEED	( 9*32+18) /* The RDSEED instruction */
> #define X86_FEATURE_ADX		( 9*32+19) /* The ADCX and ADOX instructions */
> @@ -236,6 +237,9 @@
> #define X86_FEATURE_XGETBV1	(10*32+ 2) /* XGETBV with ECX = 1 */
> #define X86_FEATURE_XSAVES	(10*32+ 3) /* XSAVES/XRSTORS */
>
> +/* Intel-defined CPU features, CPUID level 0x0000000A:0 (ebx), word 10 */
> +#define X86_FEATURE_CQE_L3  (10*32 + 1)
> +
> /*
>  * BUG word(s)
>  */
> diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
> index eb71ec7..6be953f 100644
> --- a/arch/x86/include/asm/processor.h
> +++ b/arch/x86/include/asm/processor.h
> @@ -111,8 +111,11 @@ struct cpuinfo_x86 {
> 	int			x86_cache_alignment;	/* In bytes */
> 	int			x86_power;
> 	unsigned long		loops_per_jiffy;
> +	/* Cache QOS Enforement values */
> +	int			x86_cqe_cbmlength;
> +	int			x86_cqe_closs;
> 	/* cpuid returned max cores value: */
> -	u16			 x86_max_cores;
> +	u16			x86_max_cores;
> 	u16			apicid;
> 	u16			initial_apicid;
> 	u16			x86_clflush_size;
> diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
> index e27b49d..c2b0a6b 100644
> --- a/arch/x86/kernel/cpu/Makefile
> +++ b/arch/x86/kernel/cpu/Makefile
> @@ -8,6 +8,10 @@ CFLAGS_REMOVE_common.o = -pg
> CFLAGS_REMOVE_perf_event.o = -pg
> endif
>
> +ifdef CONFIG_CACHEQE_DEBUG
> +CFLAGS_cacheqe.o := -DDEBUG
> +endif
> +
> # Make sure load_percpu_segment has no stackprotector
> nostackp := $(call cc-option, -fno-stack-protector)
> CFLAGS_common.o		:= $(nostackp)
> @@ -47,6 +51,7 @@ obj-$(CONFIG_PERF_EVENTS_INTEL_UNCORE)	+= perf_event_intel_uncore.o \
> 					   perf_event_intel_uncore_nhmex.o
> endif
>
> +obj-$(CONFIG_CGROUP_CACHEQE) += cacheqe.o
>
> obj-$(CONFIG_X86_MCE)			+= mcheck/
> obj-$(CONFIG_MTRR)			+= mtrr/
> diff --git a/arch/x86/kernel/cpu/cacheqe.c b/arch/x86/kernel/cpu/cacheqe.c
> new file mode 100644
> index 0000000..2ac3d4e
> --- /dev/null
> +++ b/arch/x86/kernel/cpu/cacheqe.c
> @@ -0,0 +1,487 @@
> +
> +/*
> + *  kernel/cacheqe.c
> + *
> + * Processor Cache Allocation code
> + * (Also called cache quality enforcement - cqe)
> + *
> +  * Copyright (c) 2014, Intel Corporation.
> +  *
> + * 2014-10-15 Written by Vikas Shivappa
> +  *
> +  * This program is free software; you can redistribute it and/or modify it
> +  * under the terms and conditions of the GNU General Public License,
> +  * version 2, as published by the Free Software Foundation.
> +  *
> +  * This program is distributed in the hope it will be useful, but WITHOUT
> +  * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> +  * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> +  * more details.
> +  */
> +
> +#include <asm/cacheqe.h>
> +
> +struct cacheqe root_cqe_group;
> +static DEFINE_MUTEX(cqe_group_mutex);
> +
> +bool cqe_genable;
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
> +
> +/*DUMP the closid-cbm map.*/
> +
> +static inline void cbmmap_dump(void)
> +{
> +
> +	int i;
> +
> +	pr_debug("CBMMAP\n");
> +	for (i = 0; i < boot_cpu_data.x86_cqe_closs; i++)
> +		pr_debug("cbm: 0x%x,ref: %u\n",
> +		 (unsigned int)ccmap[i].cbm, ccmap[i].ref);
> +
> +}
> +
> +#else
> +
> +static inline void cbmmap_dump(void) {}
> +
> +#endif
> +
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
> +
> +	/*
> +	 * Need the cqe_genable hint helps decide if the
> +	 * kernel has enabled cache allocation.
> +	 */
> +
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
> +
> +		if (!cqess_info)
> +			return -ENOMEM;
> +
> +		sizeb = BITS_TO_LONGS(c->x86_cqe_closs) * sizeof(long);
> +		cqess_info->closmap =
> +				kzalloc(sizeb, GFP_KERNEL);
> +
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
> +
> +		/* Allocate the CLOS for root.*/
> +		set_bit(0, cqess_info->closmap);
> +		root_cqe_group.clos = 0;
> +
> +		/*
> +		 * The cbmlength expected be atleast 1.
> +		 * All bits are set for the root cbm.
> +		*/
> +
> +		ccmap[root_cqe_group.clos].cbm =
> +			(u32)((u64)(1 << c->x86_cqe_cbmlength) - 1);
> +		root_cqe_group.cbm = &ccmap[root_cqe_group.clos].cbm;
> +		ccmap[root_cqe_group.clos].ref++;
> +
> +		barrier();
> +		cqe_genable = true;
> +
> +		pr_info("CQE enabled cbmlength is %u\ncqe Closs : %u ",
> +				    c->x86_cqe_cbmlength, c->x86_cqe_closs);
> +
> +	}
> +
> +	return 0;
> +
> +}
> +
> +late_initcall(cqe_late_init);
> +
> +/*
> + * Allocates a new closid from unused list of closids.
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
> +	}
> +
> +	set_bit(tempid, cqess_info->closmap);
> +	ccmap[tempid].ref++;
> +	cq->clos = tempid;
> +
> +	pr_debug("cqe : Allocated a directory.closid:%u\n", cq->clos);
> +
> +	return 0;
> +
> +closidallocfail:
> +
> +	return err;
> +
> +}
> +
> +/*
> +* Called with the cqe_group_mutex held.
> +*/
> +
> +static void cqe_free_closid(struct cacheqe *cq)
> +{
> +
> +	pr_debug("cqe :Freeing closid:%u\n", cq->clos);
> +
> +	ccmap[cq->clos].ref--;
> +
> +	if (!ccmap[cq->clos].ref)
> +		clear_bit(cq->clos, cqess_info->closmap);
> +
> +	return;
> +
> +}
> +
> +/* Create a new cacheqe cgroup.*/
> +static struct cgroup_subsys_state *
> +cqe_css_alloc(struct cgroup_subsys_state *parent_css)
> +{
> +	struct cacheqe *parent = css_cacheqe(parent_css);
> +	struct cacheqe *cq;
> +
> +	/* This is the call before the feature is detected */
> +	if (!parent) {
> +		root_cqe_group.clos = 0;
> +		return &root_cqe_group.css;
> +	}
> +
> +	/* To check if cqe is enabled.*/
> +	if (!cqe_genable)
> +		return ERR_PTR(-ENODEV);
> +
> +	cq = kzalloc(sizeof(struct cacheqe), GFP_KERNEL);
> +	if (!cq)
> +		return ERR_PTR(-ENOMEM);
> +
> +	/*
> +	 * Child inherits the ClosId and cbm from parent.
> +	 */
> +
> +	cq->clos = parent->clos;
> +	mutex_lock(&cqe_group_mutex);
> +	ccmap[parent->clos].ref++;
> +	mutex_unlock(&cqe_group_mutex);
> +
> +	cq->cbm = parent->cbm;
> +
> +	pr_debug("cqe : Allocated cgroup closid:%u,ref:%u\n",
> +		     cq->clos, ccmap[parent->clos].ref);
> +
> +	return &cq->css;
> +
> +}
> +
> +/* Destroy an existing CAT cgroup.*/
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
> + */
> +
> +static void cqe_exit(struct cgroup_subsys_state *css,
> +			    struct cgroup_subsys_state *old_css,
> +			    struct task_struct *task)
> +{
> +
> +	cacheqe_sched_out(task);
> +
> +}
> +
> +static inline bool cbm_minbits(unsigned long var)
> +{
> +
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
> +
> +/*
> + * Tests if only contiguous bits are set.
> + */
> +
> +static inline bool cbm_iscontiguous(unsigned long var)
> +{
> +
> +	unsigned long i;
> +
> +	/* Reset the least significant bit.*/
> +	i = var & (var - 1);
> +
> +	/*
> +	 * We would have a set of non-contiguous bits when
> +	 * there is at least one zero
> +	 * between the most significant 1 and least significant 1.
> +	 * In the below '&' operation,(var <<1) would have zero in
> +	 * at least 1 bit position in var apart from least
> +	 * significant bit if it does not have contiguous bits.
> +	 * Multiple sets of contiguous bits wont succeed in the below
> +	 * case as well.
> +	 */
> +
> +	if (i != (var & (var << 1)))
> +		return false;
> +
> +	return true;
> +
> +}
> +
> +static int cqe_cbm_read(struct seq_file *m, void *v)
> +{
> +	struct cacheqe *cq = css_cacheqe(seq_css(m));
> +
> +	pr_debug("cqe : In cqe_cqemode_read\n");
> +	seq_printf(m, "0x%x\n", (unsigned int)*(cq->cbm));
> +
> +	return 0;
> +
> +}
> +
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
> +
> +	rcu_read_unlock();
> +
> +	return 0;
> +
> +}
> +
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
> +
> +	if (!cqe_genable)
> +		return -ENODEV;
> +
> +	if (cq == &root_cqe_group || !cq)
> +		return -EPERM;
> +
> +	/*
> +	* Need global mutex as cbm write may allocate the closid.
> +	*/
> +
> +	mutex_lock(&cqe_group_mutex);
> +	cbm = (cbmvalue & IA32_CBM_MASK);
> +
> +	if (bitmap_equal(&cbm, cq->cbm, MAX_CBM_LENGTH))
> +		goto cbmwriteend;
> +
> +	err = validate_cbm(cq, cbm);
> +	if (err)
> +		goto cbmwriteend;
> +
> +	/*
> +	 * Need to assign a CLOSid to the cgroup
> +	 * if it has a new cbm , or reuse.
> +	 * This takes care to allocate only
> +	 * the number of CLOSs available.
> +	 */
> +
> +	cqe_free_closid(cq);
> +
> +	if (cbm_search(cbm, &closid)) {
> +		cq->clos = closid;
> +		ccmap[cq->clos].ref++;
> +
> +	} else {
> +
> +		err = cqe_alloc_closid(cq);
> +
> +		if (err)
> +			goto cbmwriteend;
> +
> +		wrmsrl(CQECBMMSR(cq->clos), cbm);
> +
> +	}
> +
> +	/*
> +	 * Finally store the cbm in cbm map
> +	 * and store a reference in the cq.
> +	 */
> +
> +	ccmap[cq->clos].cbm = cbm;
> +	cq->cbm = &ccmap[cq->clos].cbm;
> +
> +	cbmmap_dump();
> +
> +cbmwriteend:
> +
> +	mutex_unlock(&cqe_group_mutex);
> +	return err;
> +
> +}
> +
> +static struct cftype cqe_files[] = {
> +	{
> +		.name = "cbm",
> +		.seq_show = cqe_cbm_read,
> +		.write_u64 = cqe_cbm_write,
> +		.mode = 0666,
> +	},
> +	{ }	/* terminate */
> +};
> +
> +struct cgroup_subsys cacheqe_cgrp_subsys = {
> +	.name			= "cacheqe",
> +	.css_alloc		= cqe_css_alloc,
> +	.css_free		= cqe_css_free,
> +	.exit			= cqe_exit,
> +	.base_cftypes	= cqe_files,
> +};
> diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
> index 4b4f78c..a9b277a 100644
> --- a/arch/x86/kernel/cpu/common.c
> +++ b/arch/x86/kernel/cpu/common.c
> @@ -633,6 +633,27 @@ void get_cpu_cap(struct cpuinfo_x86 *c)
> 		c->x86_capability[9] = ebx;
> 	}
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
> +
> +			cpuid_count(0x00000010, 1, &eax, &ebx, &ecx, &edx);
> +
> +			c->x86_cqe_closs = (edx & 0xffff) + 1;
> +			c->x86_cqe_cbmlength = (eax & 0xf) + 1;
> +
> +		}
> +
> +	}
> +
> 	/* Extended state features: level 0x0000000d */
> 	if (c->cpuid_level >= 0x0000000d) {
> 		u32 eax, ebx, ecx, edx;
> diff --git a/include/linux/cgroup_subsys.h b/include/linux/cgroup_subsys.h
> index 98c4f9b..a131c1e 100644
> --- a/include/linux/cgroup_subsys.h
> +++ b/include/linux/cgroup_subsys.h
> @@ -53,6 +53,11 @@ SUBSYS(hugetlb)
> #if IS_ENABLED(CONFIG_CGROUP_DEBUG)
> SUBSYS(debug)
> #endif
> +
> +#if IS_ENABLED(CONFIG_CGROUP_CACHEQE)
> +SUBSYS(cacheqe)
> +#endif
> +
> /*
>  * DO NOT ADD ANY SUBSYSTEM WITHOUT EXPLICIT ACKS FROM CGROUP MAINTAINERS.
>  */
> diff --git a/init/Kconfig b/init/Kconfig
> index 2081a4d..bec92a4 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -968,6 +968,28 @@ config CPUSETS
>
> 	  Say N if unsure.
>
> +config CGROUP_CACHEQE
> +  bool "Cache QoS Enforcement cgroup subsystem"
> +  depends on X86 || X86_64
> +  help
> +    This option provides framework to allocate Cache cache lines when
> +    applications fill cache.
> +    This can be used by users to configure how much cache that can be
> +    allocated to different PIDs.
> +
> +		Say N if unsure.
> +
> +config CACHEQE_DEBUG
> +  bool "Cache QoS Enforcement cgroup subsystem debug"
> +  depends on X86 || X86_64
> +  help
> +    This option provides framework to allocate Cache cache lines when
> +    applications fill cache.
> +    This can be used by users to configure how much cache that can be
> +    allocated to different PIDs.Enables debug
> +
> +		Say N if unsure.
> +
> config PROC_PID_CPUSET
> 	bool "Include legacy /proc/<pid>/cpuset file"
> 	depends on CPUSETS
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 240157c..afa2897 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -2215,7 +2215,7 @@ prepare_task_switch(struct rq *rq, struct task_struct *prev,
> 	perf_event_task_sched_out(prev, next);
> 	fire_sched_out_preempt_notifiers(prev, next);
> 	prepare_lock_switch(rq, next);
> -	prepare_arch_switch(next);
> +	prepare_arch_switch(prev);
> }
>
> /**
> @@ -2254,7 +2254,7 @@ static void finish_task_switch(struct rq *rq, struct task_struct *prev)
> 	 */
> 	prev_state = prev->state;
> 	vtime_task_switch(prev);
> -	finish_arch_switch(prev);
> +	finish_arch_switch(current);
> 	perf_event_task_sched_in(prev, current);
> 	finish_lock_switch(rq, prev);
> 	finish_arch_post_lock_switch();
> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index 24156c84..79b9ff6 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -965,12 +965,36 @@ static inline int task_on_rq_migrating(struct task_struct *p)
> 	return p->on_rq == TASK_ON_RQ_MIGRATING;
> }
>
> +#ifdef CONFIG_X86_64
> +#ifdef CONFIG_CGROUP_CACHEQE
> +
> +#include <asm/cacheqe.h>
> +
> +# define prepare_arch_switch(prev)		cacheqe_sched_out(prev)
> +# define finish_arch_switch(current)	cacheqe_sched_in(current)
> +
> +#else
> +
> #ifndef prepare_arch_switch
> # define prepare_arch_switch(next)	do { } while (0)
> #endif
> #ifndef finish_arch_switch
> # define finish_arch_switch(prev)	do { } while (0)
> #endif
> +
> +#endif
> +#else
> +
> +#ifndef prepare_arch_switch
> +# define prepare_arch_switch(prev)	do { } while (0)
> +#endif
> +
> +#ifndef finish_arch_switch
> +# define finish_arch_switch(current)	do { } while (0)
> +#endif
> +
> +#endif
> +
> #ifndef finish_arch_post_lock_switch
> # define finish_arch_post_lock_switch()	do { } while (0)
> #endif
> -- 
> 1.9.1
>
>
