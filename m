Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757009AbaEPLBA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 07:01:00 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:63494 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756583AbaEPLA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 07:00:59 -0400
Date: Fri, 16 May 2014 13:01:53 +0200
From: Juri Lelli <juri.lelli@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [REGRESSION] funny sched_domain build failure during resume
Message-Id: <20140516130153.7064f895a282055b3e28533a@gmail.com>
In-Reply-To: <20140516104336.GR13658@twins.programming.kicks-ass.net>
References: <20140509160455.GA4486@htj.dyndns.org>
	<20140514140034.GM30445@twins.programming.kicks-ass.net>
	<20140515104055.e91844a5b75529edc560349a@gmail.com>
	<20140515085156.GG30445@twins.programming.kicks-ass.net>
	<20140516104336.GR13658@twins.programming.kicks-ass.net>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 May 2014 12:43:36 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> 
> OK I made that..
> 

Are the comments I proposed to add overdoing?

Apart from this,

Acked-by: Juri Lelli <juri.lelli@gmail.com>

Thanks!

- Juri

> ---
> 
> Subject: sched/cpudl: Replace NR_CPUS arrays
> From: Peter Zijlstra <peterz@infradead.org>
> Date: Wed May 14 16:13:56 CEST 2014
> 
> Tejun reported that his resume was failing due to order-3 allocations
> from sched_domain building.
> 
> Replace the NR_CPUS arrays in there with a dynamically allocated
> array.
> 
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Juri Lelli <juri.lelli@gmail.com>
> Reported-by: Tejun Heo <tj@kernel.org>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> ---
>  kernel/sched/cpudeadline.c |   33 ++++++++++++++++++++++++---------
>  kernel/sched/cpudeadline.h |    6 +++---
>  2 files changed, 27 insertions(+), 12 deletions(-)
> 
> --- a/kernel/sched/cpudeadline.c
> +++ b/kernel/sched/cpudeadline.c
> @@ -13,6 +13,7 @@
>  
>  #include <linux/gfp.h>
>  #include <linux/kernel.h>
> +#include <linux/slab.h>
>  #include "cpudeadline.h"
>  
>  static inline int parent(int i)
> @@ -39,8 +40,10 @@ static void cpudl_exchange(struct cpudl
>  {
>  	int cpu_a = cp->elements[a].cpu, cpu_b = cp->elements[b].cpu;
>  
> -	swap(cp->elements[a], cp->elements[b]);
> -	swap(cp->cpu_to_idx[cpu_a], cp->cpu_to_idx[cpu_b]);
> +	swap(cp->elements[a].cpu, cp->elements[b].cpu);
> +	swap(cp->elements[a].dl , cp->elements[b].dl );
> +
> +	swap(cp->elements[cpu_a].idx, cp->elements[cpu_b].idx);
>  }
>  
>  static void cpudl_heapify(struct cpudl *cp, int idx)
> @@ -140,7 +143,7 @@ void cpudl_set(struct cpudl *cp, int cpu
>  	WARN_ON(!cpu_present(cpu));
>  
>  	raw_spin_lock_irqsave(&cp->lock, flags);
> -	old_idx = cp->cpu_to_idx[cpu];
> +	old_idx = cp->elements[cpu].idx;
>  	if (!is_valid) {
>  		/* remove item */
>  		if (old_idx == IDX_INVALID) {
> @@ -155,8 +158,8 @@ void cpudl_set(struct cpudl *cp, int cpu
>  		cp->elements[old_idx].dl = cp->elements[cp->size - 1].dl;
>  		cp->elements[old_idx].cpu = new_cpu;
>  		cp->size--;
> -		cp->cpu_to_idx[new_cpu] = old_idx;
> -		cp->cpu_to_idx[cpu] = IDX_INVALID;
> +		cp->elements[new_cpu].idx = old_idx;
> +		cp->elements[cpu].idx = IDX_INVALID;
>  		while (old_idx > 0 && dl_time_before(
>  				cp->elements[parent(old_idx)].dl,
>  				cp->elements[old_idx].dl)) {
> @@ -173,7 +176,7 @@ void cpudl_set(struct cpudl *cp, int cpu
>  		cp->size++;
>  		cp->elements[cp->size - 1].dl = 0;
>  		cp->elements[cp->size - 1].cpu = cpu;
> -		cp->cpu_to_idx[cpu] = cp->size - 1;
> +		cp->elements[cpu].idx = cp->size - 1;
>  		cpudl_change_key(cp, cp->size - 1, dl);
>  		cpumask_clear_cpu(cpu, cp->free_cpus);
>  	} else {
> @@ -195,10 +198,21 @@ int cpudl_init(struct cpudl *cp)
>  	memset(cp, 0, sizeof(*cp));
>  	raw_spin_lock_init(&cp->lock);
>  	cp->size = 0;
> -	for (i = 0; i < NR_CPUS; i++)
> -		cp->cpu_to_idx[i] = IDX_INVALID;
> -	if (!alloc_cpumask_var(&cp->free_cpus, GFP_KERNEL))
> +
> +	cp->elements = kcalloc(nr_cpu_ids,
> +			       sizeof(struct cpudl_item),
> +			       GFP_KERNEL);
> +	if (!cp->elements)
> +		return -ENOMEM;
> +
> +	if (!alloc_cpumask_var(&cp->free_cpus, GFP_KERNEL)) {
> +		kfree(cp->elements);
>  		return -ENOMEM;
> +	}
> +
> +	for_each_possible_cpu(i)
> +		cp->elements[i].idx = IDX_INVALID;
> +
>  	cpumask_setall(cp->free_cpus);
>  
>  	return 0;
> @@ -211,4 +225,5 @@ int cpudl_init(struct cpudl *cp)
>  void cpudl_cleanup(struct cpudl *cp)
>  {
>  	free_cpumask_var(cp->free_cpus);
> +	kfree(cp->elements);
>  }
> --- a/kernel/sched/cpudeadline.h
> +++ b/kernel/sched/cpudeadline.h
> @@ -5,17 +5,17 @@
>  
>  #define IDX_INVALID     -1
>  
> -struct array_item {
> +struct cpudl_item {
>  	u64 dl;
>  	int cpu;
> +	int idx;
>  };
>  
>  struct cpudl {
>  	raw_spinlock_t lock;
>  	int size;
> -	int cpu_to_idx[NR_CPUS];
> -	struct array_item elements[NR_CPUS];
>  	cpumask_var_t free_cpus;
> +	struct cpudl_item *elements;
>  };
>  
>  
> 
