Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751312AbaLPO2H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 09:28:07 -0500
Received: from relay.parallels.com ([195.214.232.42]:56551 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbaLPO2G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 09:28:06 -0500
Message-ID: <1418740080.6074.16.camel@tkhai>
Subject: Re: [PATCH] sched/fair: Make cfs_rq::decay_counter non-atomic
From: Kirill Tkhai <ktkhai@parallels.com>
To: <linux-kernel@vger.kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Ben Segall <bsegall@google.com>, Kirill Tkhai <tkhai@yandex.ru>
Date: Tue, 16 Dec 2014 17:28:00 +0300
In-Reply-To: <1418739933.6074.15.camel@tkhai>
References: <1418739933.6074.15.camel@tkhai>
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This should go on top of yesterday's "sched/fair:
Fix sched_entity::avg::decay_count initialization"

В Вт, 16/12/2014 в 17:25 +0300, Kirill Tkhai пишет:
> We update decay_counter in update_cfs_rq_blocked_load()
> only. This function is always called with rq lock locked,
> so we can kill atomic actions.
> 
> Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
> ---
>  kernel/sched/fair.c  |   11 ++++++-----
>  kernel/sched/sched.h |    2 +-
>  2 files changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 5f3b5a7..af990c4 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -2570,7 +2570,7 @@ static __always_inline int __update_entity_runnable_avg(u64 now,
>  static inline u64 __synchronize_entity_decay(struct sched_entity *se)
>  {
>  	struct cfs_rq *cfs_rq = cfs_rq_of(se);
> -	u64 decays = atomic64_read(&cfs_rq->decay_counter);
> +	u64 decays = ACCESS_ONCE(cfs_rq->decay_counter);
>  
>  	decays -= se->avg.decay_count;
>  	if (!decays)
> @@ -2767,7 +2767,8 @@ static void update_cfs_rq_blocked_load(struct cfs_rq *cfs_rq, int force_update)
>  	if (decays) {
>  		cfs_rq->blocked_load_avg = decay_load(cfs_rq->blocked_load_avg,
>  						      decays);
> -		atomic64_add(decays, &cfs_rq->decay_counter);
> +		lockdep_assert_held(&rq_of(cfs_rq)->lock);
> +		cfs_rq->decay_counter += decays;
>  		cfs_rq->last_decay = now;
>  	}
>  
> @@ -2837,7 +2838,7 @@ static inline void dequeue_entity_load_avg(struct cfs_rq *cfs_rq,
>  	cfs_rq->runnable_load_avg -= se->avg.load_avg_contrib;
>  	if (sleep) {
>  		cfs_rq->blocked_load_avg += se->avg.load_avg_contrib;
> -		se->avg.decay_count = atomic64_read(&cfs_rq->decay_counter);
> +		se->avg.decay_count = ACCESS_ONCE(cfs_rq->decay_counter);
>  	} /* migrations, e.g. sleep=0 leave decay_count == 0 */
>  }
>  
> @@ -7876,7 +7877,7 @@ void init_cfs_rq(struct cfs_rq *cfs_rq)
>  	cfs_rq->min_vruntime_copy = cfs_rq->min_vruntime;
>  #endif
>  #ifdef CONFIG_SMP
> -	atomic64_set(&cfs_rq->decay_counter, 1);
> +	cfs_rq->decay_counter = 1;
>  	atomic_long_set(&cfs_rq->removed_load, 0);
>  #endif
>  }
> @@ -7928,7 +7929,7 @@ static void task_move_group_fair(struct task_struct *p, int queued)
>  		 * contribution, but we must synchronize for ongoing future
>  		 * decay.
>  		 */
> -		se->avg.decay_count = atomic64_read(&cfs_rq->decay_counter);
> +		se->avg.decay_count = ACCESS_ONCE(cfs_rq->decay_counter);
>  		cfs_rq->blocked_load_avg += se->avg.load_avg_contrib;
>  #endif
>  	}
> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index 9a2a45c..672f120 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -364,7 +364,7 @@ struct cfs_rq {
>  	 * the FAIR_GROUP_SCHED case).
>  	 */
>  	unsigned long runnable_load_avg, blocked_load_avg;
> -	atomic64_t decay_counter;
> +	u64 decay_counter;
>  	u64 last_decay;
>  	atomic_long_t removed_load;
>  
> 
> 


