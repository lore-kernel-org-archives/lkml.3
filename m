Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672Ab3J1Nu7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 09:50:59 -0400
Received: from merlin.infradead.org ([205.233.59.134]:50934 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756613Ab3J1Nu6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 09:50:58 -0400
Date: Mon, 28 Oct 2013 14:50:43 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        Ingo Molnar <mingo@kernel.org>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Mike Galbraith <bitbucket@online.de>, Paul Turner <pjt@google.com>,
        Michael Neuling <mikey@neuling.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Anton Blanchard <anton@samba.org>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 1/3] sched: Fix nohz_kick_needed to consider the nr_busy
 of the parent domain's group
Message-ID: <20131028135043.GP19466@laptop.lan>
References: <20131021114002.13291.31478.stgit@drishya>
 <20131021114442.13291.99344.stgit@drishya>
 <20131022221138.GJ2490@laptop.programming.kicks-ass.net>
 <52679BD6.6090507@linux.vnet.ibm.com>
 <CAKfTPtAUFdmc7PasebNksYztMwRrWsGWPgN6JJJurddu+UP-hQ@mail.gmail.com>
 <5268D54A.9060604@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5268D54A.9060604@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 24, 2013 at 01:37:38PM +0530, Preeti U Murthy wrote:
>  kernel/sched/core.c  |    5 +++++
>  kernel/sched/fair.c  |   38 ++++++++++++++++++++------------------
>  kernel/sched/sched.h |    1 +
>  3 files changed, 26 insertions(+), 18 deletions(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index c06b8d3..c540392 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -5271,6 +5271,7 @@ DEFINE_PER_CPU(struct sched_domain *, sd_llc);
>  DEFINE_PER_CPU(int, sd_llc_size);
>  DEFINE_PER_CPU(int, sd_llc_id);
>  DEFINE_PER_CPU(struct sched_domain *, sd_numa);
> +DEFINE_PER_CPU(struct sched_domain *, sd_busy);
>  
>  static void update_top_cache_domain(int cpu)
>  {
> @@ -5290,6 +5291,10 @@ static void update_top_cache_domain(int cpu)
>  
>  	sd = lowest_flag_domain(cpu, SD_NUMA);
>  	rcu_assign_pointer(per_cpu(sd_numa, cpu), sd);
> +
> +	sd = highest_flag_domain(cpu, SD_SHARE_PKG_RESOURCES);
> +	if (sd)
> +		rcu_assign_pointer(per_cpu(sd_busy, cpu), sd->parent);
>  }
>  
>  /*
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index e9c9549..f66cfd9 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -6515,16 +6515,16 @@ static inline void nohz_balance_exit_idle(int cpu)
>  static inline void set_cpu_sd_state_busy(void)
>  {
>  	struct sched_domain *sd;
> +	int cpu = smp_processor_id();
>  
>  	rcu_read_lock();
> +	sd = rcu_dereference(per_cpu(sd_busy, cpu));
>  
>  	if (!sd || !sd->nohz_idle)
>  		goto unlock;
>  	sd->nohz_idle = 0;
>  
> +	atomic_inc(&sd->groups->sgp->nr_busy_cpus);
>  unlock:
>  	rcu_read_unlock();
>  }
> @@ -6532,16 +6532,16 @@ unlock:
>  void set_cpu_sd_state_idle(void)
>  {
>  	struct sched_domain *sd;
> +	int cpu = smp_processor_id();
>  
>  	rcu_read_lock();
> +	sd = rcu_dereference(per_cpu(sd_busy, cpu));
>  
>  	if (!sd || sd->nohz_idle)
>  		goto unlock;
>  	sd->nohz_idle = 1;
>  
> +	atomic_dec(&sd->groups->sgp->nr_busy_cpus);
>  unlock:
>  	rcu_read_unlock();
>  }

Oh nice, that gets rid of the multiple atomics, and it nicely splits
this nohz logic into per topology groups -- now if only we could split
the rest too :-)

> @@ -6748,6 +6748,8 @@ static inline int nohz_kick_needed(struct rq *rq, int cpu)
>  {
>  	unsigned long now = jiffies;
>  	struct sched_domain *sd;
> +	struct sched_group_power *sgp;
> +	int nr_busy;
>  
>  	if (unlikely(idle_cpu(cpu)))
>  		return 0;
> @@ -6773,22 +6775,22 @@ static inline int nohz_kick_needed(struct rq *rq, int cpu)
>  		goto need_kick;
>  
>  	rcu_read_lock();
> +	sd = rcu_dereference(per_cpu(sd_busy, cpu));
>  
> +	if (sd) {
> +		sgp = sd->groups->sgp;
> +		nr_busy = atomic_read(&sgp->nr_busy_cpus);
>  
> +		if (nr_busy > 1)
>  			goto need_kick_unlock;
>  	}

OK, so far so good.

> +
> +	sd = highest_flag_domain(cpu, SD_ASYM_PACKING);
> +
> +	if (sd && (cpumask_first_and(nohz.idle_cpus_mask,
> +				  sched_domain_span(sd)) < cpu))
> +		goto need_kick_unlock;
> +
>  	rcu_read_unlock();
>  	return 0;

This again is a bit sad; most archs will not have SD_ASYM_PACKING set at
all; this means that they all will do a complete (and pointless) sched
domain tree walk here.

It would be much better to also introduce sd_asym and do the analogous
thing to the new sd_busy.

