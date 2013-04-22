Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874Ab3DVL7w (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 07:59:52 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35904 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752472Ab3DVL7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 07:59:50 -0400
Message-ID: <1366631987.4443.12.camel@laptop>
Subject: Re: [PATCH v2 3/6] sched: don't consider other cpus in our group in
 case of NEWLY_IDLE
From: Peter Zijlstra <peterz@infradead.org>
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Date: Mon, 22 Apr 2013 13:59:47 +0200
In-Reply-To: <1364277700-7509-4-git-send-email-iamjoonsoo.kim@lge.com>
References: <1364277700-7509-1-git-send-email-iamjoonsoo.kim@lge.com>
	 <1364277700-7509-4-git-send-email-iamjoonsoo.kim@lge.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-26 at 15:01 +0900, Joonsoo Kim wrote:
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
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 9d693d0..3f8c4f2 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -5007,8 +5007,17 @@ static int load_balance(int this_cpu, struct rq *this_rq,
>  		.cpus		= cpus,
>  	};
>  
> +	/* For NEWLY_IDLE load_balancing, we don't need to consider
> +	 * other cpus in our group */
> +	if (idle == CPU_NEWLY_IDLE) {
> +		env.dst_grpmask = NULL;
> +		/* we don't care max_lb_iterations in this case,
> +		 * in following patch, this will be removed */

This comment violates coding style; comments looks like:

  /* this is a single-line comment */

or

  /*
   * this is a multi-
   *                 line comment.
   */

Luckily you're deleting these offensive lines again in patch 6 :-)

> +		max_lb_iterations = 0;
> +	} else {
> +		max_lb_iterations = cpumask_weight(env.dst_grpmask);
> +	}
>  	cpumask_copy(cpus, cpu_active_mask);
> -	max_lb_iterations = cpumask_weight(env.dst_grpmask);
>  
>  	schedstat_inc(sd, lb_count[idle]);
>  


