Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756270Ab3CSOVL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 10:21:11 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:54871
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755134Ab3CSOVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 10:21:09 -0400
Message-ID: <1363702857.22553.50.camel@laptop>
Subject: Re: [PATCH 3/8] sched: don't consider other cpus in our group in
 case of NEWLY_IDLE
From: Peter Zijlstra <peterz@infradead.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Ingo Molnar <mingo@redhat.com>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 19 Mar 2013 15:20:57 +0100
In-Reply-To: <1360820921-2513-4-git-send-email-iamjoonsoo.kim@lge.com>
References: <1360820921-2513-1-git-send-email-iamjoonsoo.kim@lge.com>
	 <1360820921-2513-4-git-send-email-iamjoonsoo.kim@lge.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-14 at 14:48 +0900, Joonsoo Kim wrote:
> Commit 88b8dac0 makes load_balance() consider other cpus in its group,
> regardless of idle type. When we do NEWLY_IDLE balancing, we should not
> consider it, because a motivation of NEWLY_IDLE balancing is to turn
> this cpu to non idle state if needed. This is not the case of other cpus.
> So, change code not to consider other cpus for NEWLY_IDLE balancing.
> 
> With this patch, assign 'if (pulled_task) this_rq->idle_stamp = 0'
> in idle_balance() is corrected, because NEWLY_IDLE balancing doesn't
> consider other cpus. Assigning to 'this_rq->idle_stamp' is now valid.
> 
> Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>

Fair enough, good catch.

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 0c6aaf6..97498f4 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -5016,8 +5016,15 @@ static int load_balance(int this_cpu, struct rq *this_rq,
>  		.cpus		= cpus,
>  	};
>  
> +	/* For NEWLY_IDLE load_balancing, we don't need to consider
> +	 * other cpus in our group */
> +	if (idle == CPU_NEWLY_IDLE) {
> +		env.dst_grpmask = NULL;
> +		max_lb_iterations = 0;

Just a small nit; I don't think we'll ever get to evaluate
max_lb_iterations when !dst_grpmask. So strictly speaking its
superfluous to touch it.

> +	} else {
> +		max_lb_iterations = cpumask_weight(env.dst_grpmask);
> +	}
>  	cpumask_copy(cpus, cpu_active_mask);
> -	max_lb_iterations = cpumask_weight(env.dst_grpmask);
>  
>  	schedstat_inc(sd, lb_count[idle]);
>  


