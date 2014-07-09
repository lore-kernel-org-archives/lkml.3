Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603AbaGIQDH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 12:03:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61135 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845AbaGIQDE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 12:03:04 -0400
Message-ID: <53BD677B.9050907@redhat.com>
Date: Wed, 09 Jul 2014 12:02:03 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        tglx@linutronix.de
Subject: Re: [tip:sched/core] sched/numa: Use effective_load() to balance
 NUMA loads
References: <1403538378-31571-3-git-send-email-riel@redhat.com> <tip-6dc1a672ab15604947361dcd02e459effa09bad5@git.kernel.org>
In-Reply-To: <tip-6dc1a672ab15604947361dcd02e459effa09bad5@git.kernel.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2014 06:44 AM, tip-bot for Rik van Riel wrote:
> Commit-ID:  6dc1a672ab15604947361dcd02e459effa09bad5
> Gitweb:     http://git.kernel.org/tip/6dc1a672ab15604947361dcd02e459effa09bad5
> Author:     Rik van Riel <riel@redhat.com>
> AuthorDate: Mon, 23 Jun 2014 11:46:14 -0400
> Committer:  Ingo Molnar <mingo@kernel.org>
> CommitDate: Sat, 5 Jul 2014 11:17:35 +0200
> 
> sched/numa: Use effective_load() to balance NUMA loads
> 
> When CONFIG_FAIR_GROUP_SCHED is enabled, the load that a task places
> on a CPU is determined by the group the task is in. The active groups
> on the source and destination CPU can be different, resulting in a
> different load contribution by the same task at its source and at its
> destination. As a result, the load needs to be calculated separately
> for each CPU, instead of estimated once with task_h_load().
> 
> Getting this calculation right allows some workloads to converge,
> where previously the last thread could get stuck on another node,
> without being able to migrate to its final destination.

Self-NAK

This patch should be reverted.

It turns out that the tree I am working on was missing
changeset a003a25b227d59ded9197ced109517f037d01c27,
which makes weighted_cpuload and update_numa_stats use
p->se.avg.load_avg_contrib instead of p->se.load.weight.

This means using effective_load, which operates on the
load.weight is inappropriate.

Sorry for the noise.

> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index f287d0b..d6526d2 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -1151,6 +1151,7 @@ static void task_numa_compare(struct task_numa_env *env,
>  	struct rq *src_rq = cpu_rq(env->src_cpu);
>  	struct rq *dst_rq = cpu_rq(env->dst_cpu);
>  	struct task_struct *cur;
> +	struct task_group *tg;
>  	long src_load, dst_load;
>  	long load;
>  	long imp = (groupimp > 0) ? groupimp : taskimp;
> @@ -1225,14 +1226,21 @@ static void task_numa_compare(struct task_numa_env *env,
>  	 * In the overloaded case, try and keep the load balanced.
>  	 */
>  balance:
> -	load = task_h_load(env->p);
> -	dst_load = env->dst_stats.load + load;
> -	src_load = env->src_stats.load - load;
> +	src_load = env->src_stats.load;
> +	dst_load = env->dst_stats.load;
> +
> +	/* Calculate the effect of moving env->p from src to dst. */
> +	load = env->p->se.load.weight;
> +	tg = task_group(env->p);
> +	src_load += effective_load(tg, env->src_cpu, -load, -load);
> +	dst_load += effective_load(tg, env->dst_cpu, load, load);
>  
>  	if (cur) {
> -		load = task_h_load(cur);
> -		dst_load -= load;
> -		src_load += load;
> +		/* Cur moves in the opposite direction. */
> +		load = cur->se.load.weight;
> +		tg = task_group(cur);
> +		src_load += effective_load(tg, env->src_cpu, load, load);
> +		dst_load += effective_load(tg, env->dst_cpu, -load, -load);
>  	}
>  
>  	if (load_too_imbalanced(src_load, dst_load, env))
> 

