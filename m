Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754614Ab3KKQEJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 11:04:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63728 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753799Ab3KKQEB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 11:04:01 -0500
Date: Mon, 11 Nov 2013 11:03:29 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [seqcount] INFO: trying to register non-static key.
Message-ID: <20131111160328.GC11547@redhat.com>
References: <20131111012927.GA404@localhost>
 <20131111154551.GJ19203@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131111154551.GJ19203@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 11, 2013 at 04:45:51PM +0100, Peter Zijlstra wrote:
> On Mon, Nov 11, 2013 at 09:29:27AM +0800, Fengguang Wu wrote:
> > Greetings,
> > 
> > I got the below dmesg and the first bad commit is
> > 
> > commit 1ca7d67cf5d5a2aef26a8d9afd789006fa098347
> > Author: John Stultz <john.stultz@linaro.org>
> > Date:   Mon Oct 7 15:51:59 2013 -0700
> > 
> >     seqcount: Add lockdep functionality to seqcount/seqlock structures
> >
> 
> > [    4.124336] uli526x: ULi M5261/M5263 net driver, version 0.9.3 (2005-7-29)
> > [    4.128027] Call Trace:
> > [    4.128027]  [<7908e744>] ? console_unlock+0x353/0x380
> > [    4.128027]  [<79dc7cf2>] dump_stack+0x48/0x60
> > [    4.128027]  [<7908953e>] __lock_acquire.isra.26+0x7e3/0xceb
> > [    4.128027]  [<7908a1c5>] lock_acquire+0x71/0x9a
> > [    4.128027]  [<794079aa>] ? blk_throtl_bio+0x1c3/0x485
> > [    4.128027]  [<7940658b>] throtl_update_dispatch_stats+0x7c/0x153
> 
> The below seems to compile with i386-defconfig + CONFIG_CFQ_GROUP_IOSCHED=y
> 
> No idea if it runs properly or not; I seem to have misplaced my i386
> root filesystem.

This patch looks good to me. Also CCing Tejun.

Vivek

> 
> ---
> Subject: block: Employ u64_stats_init()
> 
> Now that seqcounts are lockdep tracked thingies, we need to properly
> initialize them, otherwise bad stuff happens.
> 
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Cc: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> ---
>  block/blk-cgroup.h  | 10 ++++++++++
>  block/cfq-iosched.c | 25 +++++++++++++++++++++++++
>  2 files changed, 35 insertions(+)
> 
> diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
> index ae6969a7ffd4..1610b22edf09 100644
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
> diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
> index 434944cbd761..4d5cec1ad80d 100644
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
