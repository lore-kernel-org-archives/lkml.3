Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751539AbaAPS1e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 13:27:34 -0500
Received: from mail-yh0-f43.google.com ([209.85.213.43]:47369 "EHLO
	mail-yh0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333AbaAPS1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 13:27:31 -0500
From: bsegall@google.com
To: Waiman Long <Waiman.Long@hp.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Scott J Norton <scott.norton@hp.com>
Subject: Re: [PATCH v2] sched: reduce contention on tg's load_avg & runnable_avg
References: <1389838956-56574-1-git-send-email-Waiman.Long@hp.com>
Date: Thu, 16 Jan 2014 10:21:17 -0800
In-Reply-To: <1389838956-56574-1-git-send-email-Waiman.Long@hp.com> (Waiman
	Long's message of "Wed, 15 Jan 2014 21:22:36 -0500")
Message-ID: <xm26k3dzlrdu.fsf@sword-of-the-dawn.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Waiman Long <Waiman.Long@hp.com> writes:

> It was found that with a perf profile of a compute workload (at 1500
> users) of the AIM7 benchmark running on a glueless 4-socket 40-core
> Westmere-EX system (HT on) on a 3.13-rc8 kernel that the scheduling
> tick related functions account for quite a significant portion of
> the total kernel cpu cycles.
>
>   0.62%  reaim  [kernel.kallsyms]  [k] update_cfs_rq_blocked_load
>   0.47%  reaim  [kernel.kallsyms]  [k] entity_tick
>   0.10%  reaim  [kernel.kallsyms]  [k] update_cfs_shares
>   0.03%  reaim  [kernel.kallsyms]  [k] update_curr
>
> The scheduling tick functions account for about 1.22% of the total
> CPU cycles. Of the top 2 function in the above list, the reading
> and writing of the tg->load_avg variable account for over 90% of the
> CPU cycles:
>
>   atomic_long_add(tg_contrib, &tg->load_avg);
>   atomic_long_read(&tg->load_avg) + 1);
>
> This patch reduces the contention on the load_avg variable (and
> secondarily on the runnable_avg variable) by the following 2 measures:
>
> 1. Make the load_avg and runnable_avg fields of the task_group
>    structure sit in their own cacheline without sharing it with others.
>    This only applies if the kernel is built for NUMA systems with
>    multiple sockets.

How much of the benefit comes from this (and how much for load_avg vs
runnable_avg vs just one separate cache_line for the pair)?
>
> 2. Use atomic_long_add_return() to update the fields and save the
>    returned value in a temporary location in the cfs structure to
>    be used later instead of reading the fields directly.
>

This is safe for tg->runnable_avg, as it only lasts for one line of
__update_entity_load_avg_contrib, and is never used for rq->cfs. That
said, given that it is such a short and contained duration it seems
simpler to just pass it around in __update_entity_load_avg_contrib
rather than make a new field on cfs_rq.

> The second change does require some changes in the ordering of how
> some of the average counts are being computed and hence may have a
> slight effect on their behavior.
>
> With these 2 changes, the perf profile becomes:
>
>   0.42%   reaim  [kernel.kallsyms]  [k] update_cfs_rq_blocked_load
>   0.05%   reaim  [kernel.kallsyms]  [k] update_cfs_shares
>   0.04%   reaim  [kernel.kallsyms]  [k] update_curr
>   0.04%   reaim  [kernel.kallsyms]  [k] entity_tick
>
> The %CPU cycle is reduced to about 0.55%. It is not a big change,
> but it did improve the compute benchmark slightly from 398509 JPM
> (Jobs/Minute) to 405803 JPM which is about 2% improvement and reduced
> the reported systime from 50.03s to 48.37s.
>
> Signed-off-by: Waiman Long <Waiman.Long@hp.com>
> ---
>  kernel/sched/fair.c  |   29 ++++++++++++++++++++++-------
>  kernel/sched/sched.h |   14 ++++++++++++--
>  2 files changed, 34 insertions(+), 9 deletions(-)
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index c7395d9..c4aa86d 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -1868,7 +1868,10 @@ static inline long calc_tg_weight(struct task_group *tg, struct cfs_rq *cfs_rq)
>  	 * to gain a more accurate current total weight. See
>  	 * update_cfs_rq_load_contribution().
>  	 */
> -	tg_weight = atomic_long_read(&tg->load_avg);
> +	/* Use the saved version of tg's load_avg, if available */
> +	tg_weight = cfs_rq->tg_load_save;
> +	if (!tg_weight)
> +		tg_weight = atomic_long_read(&tg->load_avg);
>  	tg_weight -= cfs_rq->tg_load_contrib;
>  	tg_weight += cfs_rq->load.weight;
>  
> @@ -2155,7 +2158,8 @@ static inline void __update_cfs_rq_tg_load_contrib(struct cfs_rq *cfs_rq,
>  	tg_contrib -= cfs_rq->tg_load_contrib;
>  
>  	if (force_update || abs(tg_contrib) > cfs_rq->tg_load_contrib / 8) {
> -		atomic_long_add(tg_contrib, &tg->load_avg);
> +		cfs_rq->tg_load_save =
> +			atomic_long_add_return(tg_contrib, &tg->load_avg);
>  		cfs_rq->tg_load_contrib += tg_contrib;
>  	}
>  }
> @@ -2176,7 +2180,8 @@ static inline void __update_tg_runnable_avg(struct sched_avg *sa,
>  	contrib -= cfs_rq->tg_runnable_contrib;
>  
>  	if (abs(contrib) > cfs_rq->tg_runnable_contrib / 64) {
> -		atomic_add(contrib, &tg->runnable_avg);
> +		cfs_rq->tg_runnable_save =
> +			atomic_add_return(contrib, &tg->runnable_avg);
>  		cfs_rq->tg_runnable_contrib += contrib;
>  	}
>  }
> @@ -2186,12 +2191,19 @@ static inline void __update_group_entity_contrib(struct sched_entity *se)
>  	struct cfs_rq *cfs_rq = group_cfs_rq(se);
>  	struct task_group *tg = cfs_rq->tg;
>  	int runnable_avg;
> +	long load_avg;
>  
>  	u64 contrib;
>  
>  	contrib = cfs_rq->tg_load_contrib * tg->shares;
> -	se->avg.load_avg_contrib = div_u64(contrib,
> -				     atomic_long_read(&tg->load_avg) + 1);
> +	/*
> +	 * Retrieve & clear the saved tg's load_avg and use it if not 0
> +	 */
> +	load_avg = cfs_rq->tg_load_save;
> +	cfs_rq->tg_load_save = 0;
> +	if (unlikely(!load_avg))
> +		load_avg = atomic_long_read(&tg->load_avg);
> +	se->avg.load_avg_contrib = div_u64(contrib, load_avg + 1);
>  
>  	/*
>  	 * For group entities we need to compute a correction term in the case
> @@ -2216,7 +2228,10 @@ static inline void __update_group_entity_contrib(struct sched_entity *se)
>  	 * of consequential size guaranteed to see n_i*w_i quickly converge to
>  	 * our upper bound of 1-cpu.
>  	 */
> -	runnable_avg = atomic_read(&tg->runnable_avg);
> +	runnable_avg = cfs_rq->tg_runnable_save;
> +	cfs_rq->tg_runnable_save = 0;
> +	if (unlikely(!runnable_avg))
> +		runnable_avg = atomic_read(&tg->runnable_avg);
>  	if (runnable_avg < NICE_0_LOAD) {
>  		se->avg.load_avg_contrib *= runnable_avg;
>  		se->avg.load_avg_contrib >>= NICE_0_SHIFT;
> @@ -2823,9 +2838,9 @@ entity_tick(struct cfs_rq *cfs_rq, struct sched_entity *curr, int queued)
>  	/*
>  	 * Ensure that runnable average is periodically updated.
>  	 */
> -	update_entity_load_avg(curr, 1);
>  	update_cfs_rq_blocked_load(cfs_rq, 1);
>  	update_cfs_shares(cfs_rq);
> +	update_entity_load_avg(curr, 1);
You've confused group_cfs_rq(curr) and cfs_rq=cfs_rq_of(curr) here -
there is no need to do this accuracy-reducing reordering.
update_cfs_rq_blocked_load would set cfs_rq->tg_load_save, and then
entity_tick(curr->parent) called this same tick would read this value,
the same way enqueue/dequeue will do what you wanted.


That said, there is still a problem that tg_load_save could escape in
cases where __update_entity_load_avg_contrib gets skipped, either via
__update_entity_load_avg_contrib not crossing a boundary or
enqueue/dequeue aborting early due to cfs_rq_throttled. Worst case
should be accessing a value ~1ms old though, which might be acceptable.
