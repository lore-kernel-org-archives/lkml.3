Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866AbaJVKET (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 06:04:19 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:56616 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564AbaJVKEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 06:04:16 -0400
Date: Wed, 22 Oct 2014 12:04:11 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Yuyang Du <yuyang.du@intel.com>
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org, pjt@google.com,
        bsegall@google.com, arjan.van.de.ven@intel.com, len.brown@intel.com,
        rafael.j.wysocki@intel.com, alan.cox@intel.com, mark.gross@intel.com,
        fengguang.wu@intel.com
Subject: Re: [RESEND PATCH 2/3 v5] sched: Rewrite per entity runnable load
 average tracking
Message-ID: <20141022100411.GC23531@worktop.programming.kicks-ass.net>
References: <1412907717-2871-1-git-send-email-yuyang.du@intel.com>
 <1412907717-2871-3-git-send-email-yuyang.du@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412907717-2871-3-git-send-email-yuyang.du@intel.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2014 at 10:21:56AM +0800, Yuyang Du wrote:
> +/* Group cfs_rq's load_avg is used for task_h_load and update_cfs_share */
> +static inline int update_cfs_rq_load_avg(u64 now, struct cfs_rq *cfs_rq)
>  {
> +	int decayed;
>  
> +	if (atomic_long_read(&cfs_rq->removed_load_avg)) {
> +		long r = atomic_long_xchg(&cfs_rq->removed_load_avg, 0);
> +		cfs_rq->avg.load_avg = max_t(long, cfs_rq->avg.load_avg - r, 0);
> +		cfs_rq->avg.load_sum =
> +			max_t(s64, cfs_rq->avg.load_sum - r * LOAD_AVG_MAX, 0);
>  	}
>  
> +	decayed = __update_load_avg(now, &cfs_rq->avg, cfs_rq->load.weight);
>  
> +#ifndef CONFIG_64BIT
> +	smp_wmb();
> +	cfs_rq->load_last_update_time_copy = cfs_rq->avg.last_update_time;
> +#endif
>  
> -static inline u64 cfs_rq_clock_task(struct cfs_rq *cfs_rq);
> +	return decayed;
> +}


> +void remove_entity_load_avg(struct sched_entity *se)
>  {
> +	struct cfs_rq *cfs_rq = cfs_rq_of(se);
> +	u64 last_update_time;
> +
> +#ifndef CONFIG_64BIT
> +	u64 last_update_time_copy;
> +
> +	do {
> +		last_update_time_copy = cfs_rq->load_last_update_time_copy;
> +		smp_rmb();
> +		last_update_time = cfs_rq->avg.last_update_time;
> +	} while (last_update_time != last_update_time_copy);
> +#else
> +	last_update_time = cfs_rq->avg.last_update_time;
> +#endif
>  
> +	__update_load_avg(last_update_time, &se->avg, 0);
> +	atomic_long_add(se->avg.load_avg, &cfs_rq->removed_load_avg);
>  }


> +static void migrate_task_rq_fair(struct task_struct *p, int next_cpu)
>  {
>  	/*
> +	 * We are supposed to update the task to "current" time, then its up to date
> +	 * and ready to go to new CPU/cfs_rq. But we have difficulty in getting
> +	 * what current time is, so simply throw away the out-of-date time. This
> +	 * will result in the wakee task is less decayed, but giving the wakee more
> +	 * load sounds not bad.
>  	 */
> +	remove_entity_load_avg(&p->se);
> +
> +	/* Tell new CPU we are migrated */
> +	p->se.avg.last_update_time = 0;
>  
>  	/* We have migrated, no longer consider this task hot */
> +	p->se.exec_start = 0;
>  }


Because of:

  entity_tick()
    update_load_avg()
      update_cfs_rq_load_avg()

we're likely to only lag TICK_NSEC behind, right? And thus the
truncation we do in migrate_task_rq_fair() is of equal size.

Hmm,. one problem, cgroup cfs_rq can be idle for a long while and not
get get any ticks at all, so those can lag unbounded. Then again, this
appears to be a problem in the current code too, hmm..

Anybody?


