Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756286Ab3ANI0o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 03:26:44 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:63604 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705Ab3ANI0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 03:26:43 -0500
X-AuditID: 9c930179-b7b0cae0000065b4-7c-50f3c1403520
From: Namhyung Kim <namhyung@kernel.org>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Tejun Heo <tj@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH 1/2] sched: schedule balance map foundation
References: <50EFCA29.8020801@linux.vnet.ibm.com>
	<50EFCAA7.8080302@linux.vnet.ibm.com>
Date: Mon, 14 Jan 2013 17:26:40 +0900
In-Reply-To: <50EFCAA7.8080302@linux.vnet.ibm.com> (Michael Wang's message of
	"Fri, 11 Jan 2013 16:17:43 +0800")
Message-ID: <87libwnpa7.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On Fri, 11 Jan 2013 16:17:43 +0800, Michael Wang wrote:
> In order to get rid of the complex code in select_task_rq_fair(),
> approach to directly get sd on each level with proper flag is
> required.
>
> Schedule balance map is the solution, which record the sd according
> to it's flag and level.
>
> For example, cpu_sbm->sd[wake][l] will locate the sd of cpu which
> support wake up on level l.
>
> In order to quickly locate the lower sd while changing the base cpu,
> the level with empty sd in map will be filled with the lower sd.
>
> Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
> ---
>  kernel/sched/core.c  |   61 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  kernel/sched/sched.h |   28 +++++++++++++++++++++++
>  2 files changed, 89 insertions(+), 0 deletions(-)
>
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 2d8927f..80810a3 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -5497,6 +5497,55 @@ static void update_top_cache_domain(int cpu)
>  	per_cpu(sd_llc_id, cpu) = id;
>  }
>  
> +DEFINE_PER_CPU_SHARED_ALIGNED(struct sched_balance_map, sbm_array);
> +
> +static void build_sched_balance_map(int cpu)
> +{
> +	struct sched_balance_map *sbm = &per_cpu(sbm_array, cpu);
> +	struct sched_domain *sd = cpu_rq(cpu)->sd;
> +	struct sched_domain *top_sd = NULL;
> +	int i, type, level = 0;
> +
> +	while (sd) {
> +		if (sd->flags & SD_LOAD_BALANCE) {
> +			if (sd->flags & SD_BALANCE_EXEC) {
> +				sbm->top_level[SBM_EXEC_TYPE] = sd->level;
> +				sbm->sd[SBM_EXEC_TYPE][sd->level] = sd;
> +			}
> +
> +			if (sd->flags & SD_BALANCE_FORK) {
> +				sbm->top_level[SBM_FORK_TYPE] = sd->level;
> +				sbm->sd[SBM_FORK_TYPE][sd->level] = sd;
> +			}
> +
> +			if (sd->flags & SD_BALANCE_WAKE) {
> +				sbm->top_level[SBM_WAKE_TYPE] = sd->level;
> +				sbm->sd[SBM_WAKE_TYPE][sd->level] = sd;
> +			}
> +
> +			if (sd->flags & SD_WAKE_AFFINE) {
> +				for_each_cpu(i, sched_domain_span(sd)) {
> +					if (!sbm->affine_map[i])
> +						sbm->affine_map[i] = sd;
> +				}
> +			}
> +		}
> +		sd = sd->parent;
> +	}

It seems that it can be done like:

	for_each_domain(cpu, sd) {
		if (!(sd->flags & SD_LOAD_BALANCE))
                	continue;

		if (sd->flags & SD_BALANCE_EXEC)
		...
	}


> +
> +	/*
> +	 * fill the hole to get lower level sd easily.
> +	 */
> +	for (type = 0; type < SBM_MAX_TYPE; type++) {
> +		level = sbm->top_level[type];
> +		top_sd = sbm->sd[type][level];
> +		if ((++level != SBM_MAX_LEVEL) && top_sd) {
> +			for (; level < SBM_MAX_LEVEL; level++)
> +				sbm->sd[type][level] = top_sd;
> +		}
> +	}
> +}
[snip]
> +#ifdef CONFIG_SCHED_SMT
> +#define SBM_MAX_LEVEL	4
> +#else
> +#ifdef CONFIG_SCHED_MC
> +#define SBM_MAX_LEVEL	3
> +#else
> +#ifdef CONFIG_SCHED_BOOK
> +#define SBM_MAX_LEVEL	2
> +#else
> +#define SBM_MAX_LEVEL	1
> +#endif
> +#endif
> +#endif

Looks like this fixed level constants does not consider NUMA domains.
Doesn't accessing sbm->sd[type][level] in the above while loop cause a
problem on big NUMA machines?

Thanks,
Namhyung

> +
> +enum {
> +	SBM_EXEC_TYPE,
> +	SBM_FORK_TYPE,
> +	SBM_WAKE_TYPE,
> +	SBM_MAX_TYPE
> +};
> +
> +struct sched_balance_map {
> +	struct sched_domain *sd[SBM_MAX_TYPE][SBM_MAX_LEVEL];
> +	int top_level[SBM_MAX_TYPE];
> +	struct sched_domain *affine_map[NR_CPUS];
> +};
> +
>  #endif /* CONFIG_SMP */
>  
>  /*
> @@ -403,6 +430,7 @@ struct rq {
>  #ifdef CONFIG_SMP
>  	struct root_domain *rd;
>  	struct sched_domain *sd;
> +	struct sched_balance_map *sbm;
>  
>  	unsigned long cpu_power;
