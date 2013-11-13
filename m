Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759117Ab3KMOUB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 09:20:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51416 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754881Ab3KMOUA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 09:20:00 -0500
Date: Wed, 13 Nov 2013 09:19:29 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, Fengguang Wu <fengguang.wu@intel.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] block: Employ u64_stats_init()
Message-ID: <20131113141929.GC7613@redhat.com>
References: <1384314134-6895-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384314134-6895-1-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 07:42:14PM -0800, John Stultz wrote:
> From: Peter Zijlstra <peterz@infradead.org>
> 
> Now that seqcounts are lockdep enabled objects, we need to properly
> initialize them.
> 
> Without this patch, Fengguang was seeing:
> [    4.127282] INFO: trying to register non-static key.
> [    4.128027] the code is fine but needs lockdep annotation.
> [    4.128027] turning off the locking correctness validator.
> [    4.128027] CPU: 0 PID: 96 Comm: kworker/u4:1 Not tainted 3.12.0-next-20131108-10601-gbad570d #2
> [    4.128027] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [    4.128027] Workqueue: events_unbound async_run_entry_fn
> [    4.128027]  7908e744 00000000 78019968 79dc7cf2 7a80e0a8 780199a0 7908953e 7a1b7f4d
> [    4.128027]  7a1b7fa7 7a1b7f7d 7f368608 00000000 00000011 44374011 0000a805 7f368110
> [    4.128027]  7f368110 85bf2a70 00000000 780199cc 7908a1c5 00000000 00000001 00000000
> [    4.128027] Call Trace:
> [    4.128027]  [<7908e744>] ? console_unlock+0x353/0x380
> [    4.128027]  [<79dc7cf2>] dump_stack+0x48/0x60
> [    4.128027]  [<7908953e>] __lock_acquire.isra.26+0x7e3/0xceb
> [    4.128027]  [<7908a1c5>] lock_acquire+0x71/0x9a
> [    4.128027]  [<794079aa>] ? blk_throtl_bio+0x1c3/0x485
> [    4.128027]  [<7940658b>] throtl_update_dispatch_stats+0x7c/0x153
> [    4.128027]  [<794079aa>] ? blk_throtl_bio+0x1c3/0x485
> [    4.128027]  [<794079aa>] blk_throtl_bio+0x1c3/0x485
> ...
> 
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: Fengguang Wu <fengguang.wu@intel.com>
> Cc: Ingo Molnar <mingo@kernel.org>
> Reported-by: Fengguang Wu <fengguang.wu@intel.com>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> [jstultz: Folded in another fix from the mailing list as well as a fix
> to that fix. Tweaked commit message.]
> Signed-off-by: John Stultz <john.stultz@linaro.org>

Looks good to me.

Acked-by: Vivek Goyal <vgoyal@redhat.com>

Vivek

> ---
>  block/blk-cgroup.h   | 10 ++++++++++
>  block/blk-throttle.c | 10 ++++++++++
>  block/cfq-iosched.c  | 25 +++++++++++++++++++++++++
>  3 files changed, 45 insertions(+)
> 
> diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
> index ae6969a..1610b22 100644
> --- a/block/blk-cgroup.h
> +++ b/block/blk-cgroup.h
> @@ -402,6 +402,11 @@ struct request_list *__blk_queue_next_rl(struct request_list *rl,
>  #define blk_queue_for_each_rl(rl, q)	\
>  	for ((rl) = &(q)->root_rl; (rl); (rl) = __blk_queue_next_rl((rl), (q)))
>  
> +static inline void blkg_stat_init(struct blkg_stat *stat)
> +{
> +	u64_stats_init(&stat->syncp);
> +}
> +
>  /**
>   * blkg_stat_add - add a value to a blkg_stat
>   * @stat: target blkg_stat
> @@ -458,6 +463,11 @@ static inline void blkg_stat_merge(struct blkg_stat *to, struct blkg_stat *from)
>  	blkg_stat_add(to, blkg_stat_read(from));
>  }
>  
> +static inline void blkg_rwstat_init(struct blkg_rwstat *rwstat)
> +{
> +	u64_stats_init(&rwstat->syncp);
> +}
> +
>  /**
>   * blkg_rwstat_add - add a value to a blkg_rwstat
>   * @rwstat: target blkg_rwstat
> diff --git a/block/blk-throttle.c b/block/blk-throttle.c
> index 8331aba..0653404 100644
> --- a/block/blk-throttle.c
> +++ b/block/blk-throttle.c
> @@ -256,6 +256,12 @@ static struct throtl_data *sq_to_td(struct throtl_service_queue *sq)
>  	}								\
>  } while (0)
>  
> +static void tg_stats_init(struct tg_stats_cpu *tg_stats)
> +{
> +	blkg_rwstat_init(&tg_stats->service_bytes);
> +	blkg_rwstat_init(&tg_stats->serviced);
> +}
> +
>  /*
>   * Worker for allocating per cpu stat for tgs. This is scheduled on the
>   * system_wq once there are some groups on the alloc_list waiting for
> @@ -269,12 +275,16 @@ static void tg_stats_alloc_fn(struct work_struct *work)
>  
>  alloc_stats:
>  	if (!stats_cpu) {
> +		int cpu;
> +
>  		stats_cpu = alloc_percpu(struct tg_stats_cpu);
>  		if (!stats_cpu) {
>  			/* allocation failed, try again after some time */
>  			schedule_delayed_work(dwork, msecs_to_jiffies(10));
>  			return;
>  		}
> +		for_each_possible_cpu(cpu)
> +			tg_stats_init(per_cpu_ptr(stats_cpu, cpu));
>  	}
>  
>  	spin_lock_irq(&tg_stats_alloc_lock);
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index 434944c..4d5cec1 100644
> --- a/block/cfq-iosched.c
> +++ b/block/cfq-iosched.c
> @@ -1508,6 +1508,29 @@ static void cfq_init_cfqg_base(struct cfq_group *cfqg)
>  }
>  
>  #ifdef CONFIG_CFQ_GROUP_IOSCHED
> +static void cfqg_stats_init(struct cfqg_stats *stats)
> +{
> +	blkg_rwstat_init(&stats->service_bytes);
> +	blkg_rwstat_init(&stats->serviced);
> +	blkg_rwstat_init(&stats->merged);
> +	blkg_rwstat_init(&stats->service_time);
> +	blkg_rwstat_init(&stats->wait_time);
> +	blkg_rwstat_init(&stats->queued);
> +
> +	blkg_stat_init(&stats->sectors);
> +	blkg_stat_init(&stats->time);
> +
> +#ifdef CONFIG_DEBUG_BLK_CGROUP
> +	blkg_stat_init(&stats->unaccounted_time);
> +	blkg_stat_init(&stats->avg_queue_size_sum);
> +	blkg_stat_init(&stats->avg_queue_size_samples);
> +	blkg_stat_init(&stats->dequeue);
> +	blkg_stat_init(&stats->group_wait_time);
> +	blkg_stat_init(&stats->idle_time);
> +	blkg_stat_init(&stats->empty_time);
> +#endif
> +}
> +
>  static void cfq_pd_init(struct blkcg_gq *blkg)
>  {
>  	struct cfq_group *cfqg = blkg_to_cfqg(blkg);
> @@ -1515,6 +1538,8 @@ static void cfq_pd_init(struct blkcg_gq *blkg)
>  	cfq_init_cfqg_base(cfqg);
>  	cfqg->weight = blkg->blkcg->cfq_weight;
>  	cfqg->leaf_weight = blkg->blkcg->cfq_leaf_weight;
> +	cfqg_stats_init(&cfqg->stats);
> +	cfqg_stats_init(&cfqg->dead_stats);
>  }
>  
>  static void cfq_pd_offline(struct blkcg_gq *blkg)
> -- 
> 1.8.3.2
