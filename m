Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480Ab3GOI3E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 04:29:04 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33741 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754394Ab3GOI3C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 04:29:02 -0400
Date: Mon, 15 Jul 2013 10:28:53 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        devel@openvz.org, pjt@google.com
Subject: Re: [PATCH RFC] sched: move h_load calculation to task_h_load
Message-ID: <20130715082853.GM17211@twins.programming.kicks-ass.net>
References: <1373705235-22523-1-git-send-email-vdavydov@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373705235-22523-1-git-send-email-vdavydov@parallels.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 13, 2013 at 12:47:15PM +0400, Vladimir Davydov wrote:

> ---
>  kernel/sched/fair.c  |   56 ++++++++++++++++++++++----------------------------
>  kernel/sched/sched.h |    7 +++----
>  2 files changed, 28 insertions(+), 35 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index f77f9c5..de90690 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -4171,47 +4171,46 @@ static void update_blocked_averages(int cpu)
>  }
>  
>  /*
> + * Compute the hierarchical load factor for cfs_rq and all its ascendants.
>   * This needs to be done in a top-down fashion because the load of a child
>   * group is a fraction of its parents load.
>   */
> +static void update_cfs_rq_h_load(struct cfs_rq *cfs_rq)
>  {
> +	struct rq *rq = rq_of(cfs_rq);
> +	struct sched_entity *se = cfs_rq->tg->se[cpu_of(rq)];
>  	unsigned long load;
>  
> +	cfs_rq->h_load_next = NULL;
> +	for_each_sched_entity(se) {
> +		cfs_rq = cfs_rq_of(se);
> +		cfs_rq->h_load_next = se;
> +		if (cfs_rq->last_h_load_update == rq->clock)
> +			break;
>  	}
>  
> +	if (!se) {
> +		cfs_rq->h_load = rq->avg.load_avg_contrib;
> +		cfs_rq->last_h_load_update = rq->clock;
> +	}
>  
> +	while ((se = cfs_rq->h_load_next) != NULL) {
> +		load = cfs_rq->h_load;
> +		load = div64_ul(load * se->avg.load_avg_contrib,
> +				cfs_rq->runnable_load_avg + 1);
> +		cfs_rq = group_cfs_rq(se);
> +		cfs_rq->h_load = load;
> +		cfs_rq->last_h_load_update = rq->clock;
> +	}
>  }
>  
>  static unsigned long task_h_load(struct task_struct *p)
>  {
>  	struct cfs_rq *cfs_rq = task_cfs_rq(p);
>  
> +	if (cfs_rq->last_h_load_update != rq_of(cfs_rq)->clock)
> +		update_cfs_rq_h_load(cfs_rq);
> +
>  	return div64_ul(p->se.avg.load_avg_contrib * cfs_rq->h_load,
>  			cfs_rq->runnable_load_avg + 1);
>  }

OK, fair enough. It does somewhat rely on us getting the single
rq->clock update thing right, but that should be ok.

But yeah, when you have stupid many cgroups we quickly need less h_load
instances than there are cgroups.
