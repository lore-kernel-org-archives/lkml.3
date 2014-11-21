Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758582AbaKUMgv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 07:36:51 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:36625 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758347AbaKUMgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 07:36:50 -0500
Date: Fri, 21 Nov 2014 12:37:33 +0000
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: "peterz@infradead.org" <peterz@infradead.org>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "preeti@linux.vnet.ibm.com" <preeti@linux.vnet.ibm.com>,
        "kamalesh@linux.vnet.ibm.com" <kamalesh@linux.vnet.ibm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "riel@redhat.com" <riel@redhat.com>, "efault@gmx.de" <efault@gmx.de>,
        "nicolas.pitre@linaro.org" <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Subject: Re: [PATCH v9 10/10] sched: move cfs task on a CPU with higher
 capacity
Message-ID: <20141121123733.GI23177@e105550-lin.cambridge.arm.com>
References: <1415033687-23294-1-git-send-email-vincent.guittot@linaro.org>
 <1415033687-23294-11-git-send-email-vincent.guittot@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415033687-23294-11-git-send-email-vincent.guittot@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2014 at 04:54:47PM +0000, Vincent Guittot wrote:
> When a CPU is used to handle a lot of IRQs or some RT tasks, the remaining
> capacity for CFS tasks can be significantly reduced. Once we detect such
> situation by comparing cpu_capacity_orig and cpu_capacity, we trig an idle
> load balance to check if it's worth moving its tasks on an idle CPU.
> 
> Once the idle load_balance has selected the busiest CPU, it will look for an
> active load balance for only two cases :
> - there is only 1 task on the busiest CPU.
> - we haven't been able to move a task of the busiest rq.
> 
> A CPU with a reduced capacity is included in the 1st case, and it's worth to
> actively migrate its task if the idle CPU has got full capacity. This test has
> been added in need_active_balance.
> 
> As a sidenote, this will note generate more spurious ilb because we already
> trig an ilb if there is more than 1 busy cpu. If this cpu is the only one that
> has a task, we will trig the ilb once for migrating the task.
> 
> The nohz_kick_needed function has been cleaned up a bit while adding the new
> test
> 
> env.src_cpu and env.src_rq must be set unconditionnally because they are used
> in need_active_balance which is called even if busiest->nr_running equals 1
> 
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> ---
>  kernel/sched/fair.c | 74 ++++++++++++++++++++++++++++++++++++++---------------
>  1 file changed, 53 insertions(+), 21 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index db392a6..02e8f7f 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -6634,6 +6634,28 @@ static int need_active_balance(struct lb_env *env)
>  			return 1;
>  	}
>  
> +	/*
> +	 * The dst_cpu is idle and the src_cpu CPU has only 1 CFS task.
> +	 * It's worth migrating the task if the src_cpu's capacity is reduced
> +	 * because of other sched_class or IRQs whereas capacity stays
> +	 * available on dst_cpu.
> +	 */
> +	if ((env->idle != CPU_NOT_IDLE) &&
> +			(env->src_rq->cfs.h_nr_running == 1)) {
> +		unsigned long src_eff_capacity, dst_eff_capacity;
> +
> +		dst_eff_capacity = 100;
> +		dst_eff_capacity *= capacity_of(env->dst_cpu);
> +		dst_eff_capacity *= capacity_orig_of(env->src_cpu);
> +
> +		src_eff_capacity = sd->imbalance_pct;
> +		src_eff_capacity *= capacity_of(env->src_cpu);
> +		src_eff_capacity *= capacity_orig_of(env->dst_cpu);

Do we need to scale by capacity_orig? Shouldn't the absolute capacity be
better?

if (capacity_of(env->src) * sd->imbalance_pct < capacity_of(env->dst) *
100) ?

Isn't it the absolute available capacity that matters? For SMP
capacity_orig is the same and cancels out and doesn't change anything.
For big.LITTLE we would rather have the task run on a big where rt/irq
eats 30% than a little cpu where rq/irq eats 5%, assuming big capacity
is much bigger than little capacity so the absolute available capacity
(~cycles/time) is larger on the big cpu.
