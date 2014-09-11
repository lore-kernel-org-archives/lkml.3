Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753304AbaIKTCg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 15:02:36 -0400
Received: from mail-qg0-f51.google.com ([209.85.192.51]:47134 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452AbaIKTCf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 15:02:35 -0400
Date: Thu, 11 Sep 2014 15:02:27 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Vincent Guittot <vincent.guittot@linaro.org>
cc: peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        preeti@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, riel@redhat.com,
        Morten.Rasmussen@arm.com, efault@gmx.de,
        linaro-kernel@lists.linaro.org, daniel.lezcano@linaro.org,
        dietmar.eggemann@arm.com
Subject: Re: [PATCH v5 06/12] sched: add per rq cpu_capacity_orig
In-Reply-To: <1409051215-16788-7-git-send-email-vincent.guittot@linaro.org>
Message-ID: <alpine.LFD.2.11.1409111455320.16533@knanqh.ubzr>
References: <1409051215-16788-1-git-send-email-vincent.guittot@linaro.org> <1409051215-16788-7-git-send-email-vincent.guittot@linaro.org>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Aug 2014, Vincent Guittot wrote:

> This new field cpu_capacity_orig reflects the available capacity of a CPUs

s/a CPUs/a CPU/

> unlike the cpu_capacity which reflects the current capacity that can be altered
> by frequency and rt tasks.

Shouldn't this be described as the "highest possible capacity" instead 
of only "available capacity" to make it clearer?  In which case, 
shouldn't it be called capacity_max instead of capacity_orig?  With 
"orig" we may think "origin" as the capacity that was available at boot 
time or the like.  If for example the CPU was booted with a low P-state 
then its max capacity is different from the original one.


> 
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> ---
>  kernel/sched/core.c  | 2 +-
>  kernel/sched/fair.c  | 1 +
>  kernel/sched/sched.h | 1 +
>  3 files changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index a394f99..7c3b237 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -7003,7 +7003,7 @@ void __init sched_init(void)
>  #ifdef CONFIG_SMP
>  		rq->sd = NULL;
>  		rq->rd = NULL;
> -		rq->cpu_capacity = SCHED_CAPACITY_SCALE;
> +		rq->cpu_capacity = rq->cpu_capacity_orig = SCHED_CAPACITY_SCALE;
>  		rq->post_schedule = 0;
>  		rq->active_balance = 0;
>  		rq->next_balance = jiffies;
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 8176bda..17c16cc 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -5756,6 +5756,7 @@ static void update_cpu_capacity(struct sched_domain *sd, int cpu)
>  
>  	capacity >>= SCHED_CAPACITY_SHIFT;
>  
> +	cpu_rq(cpu)->cpu_capacity_orig = capacity;
>  	sdg->sgc->capacity_orig = capacity;
>  
>  	if (sched_feat(ARCH_CAPACITY))
> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index aa0f73b..7c0a74e 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -575,6 +575,7 @@ struct rq {
>  	struct sched_domain *sd;
>  
>  	unsigned long cpu_capacity;
> +	unsigned long cpu_capacity_orig;
>  
>  	unsigned char idle_balance;
>  	/* For active balancing */
> -- 
> 1.9.1
> 
> 
