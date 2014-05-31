Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756483AbaEaLwb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 07:52:31 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:47328 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754682AbaEaLw3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 07:52:29 -0400
Date: Sat, 31 May 2014 07:52:16 -0400
From: Tejun Heo <tj@kernel.org>
To: Paolo Valente <paolo.valente@unimore.it>
Cc: Jens Axboe <axboe@kernel.dk>, Li Zefan <lizefan@huawei.com>,
        Fabio Checconi <fchecconi@gmail.com>,
        Arianna Avanzini <avanzini.arianna@gmail.com>,
        Paolo Valente <posta_paolo@yahoo.it>, linux-kernel@vger.kernel.org,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org
Subject: Re: [PATCH RFC - TAKE TWO - 11/12] block, bfq: boost the throughput
 on NCQ-capable flash-based devices
Message-ID: <20140531115216.GB5057@htj.dyndns.org>
References: <20140528221929.GG1419@htj.dyndns.org>
 <1401354343-5527-1-git-send-email-paolo.valente@unimore.it>
 <1401354343-5527-12-git-send-email-paolo.valente@unimore.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401354343-5527-12-git-send-email-paolo.valente@unimore.it>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Paolo.

So, I've actually looked at the code.  Here are some questions.

On Thu, May 29, 2014 at 11:05:42AM +0200, Paolo Valente wrote:
> + * 1) all active queues have the same weight,
> + * 2) all active groups at the same level in the groups tree have the same
> + *    weight,
> + * 3) all active groups at the same level in the groups tree have the same
> + *    number of children.

3) basically disables it whenever blkcg is used.  Might as well just
skip the whole thing if there are any !root cgroups.  It's only
theoretically interesting.

>  static inline bool bfq_bfqq_must_not_expire(struct bfq_queue *bfqq)
>  {
>  	struct bfq_data *bfqd = bfqq->bfqd;

	bool symmetric_scenario, expire_non_wr;

> +#ifdef CONFIG_CGROUP_BFQIO
> +#define symmetric_scenario	  (!bfqd->active_numerous_groups && \
> +				   !bfq_differentiated_weights(bfqd))

	symmetric_scenario = xxx;

> +#else
> +#define symmetric_scenario	  (!bfq_differentiated_weights(bfqd))

	symmetric_scenario = yyy;

> +#endif
>  /*
>   * Condition for expiring a non-weight-raised queue (and hence not idling
>   * the device).
>   */
>  #define cond_for_expiring_non_wr  (bfqd->hw_tag && \
> -				   bfqd->wr_busy_queues > 0)
> +				   (bfqd->wr_busy_queues > 0 || \
> +				    (symmetric_scenario && \
> +				     blk_queue_nonrot(bfqd->queue))))

	expire_non_wr = zzz;

>  
>  	return bfq_bfqq_sync(bfqq) && (
>  		bfqq->wr_coeff > 1 ||
>  /**
> + * struct bfq_weight_counter - counter of the number of all active entities
> + *                             with a given weight.
> + * @weight: weight of the entities that this counter refers to.
> + * @num_active: number of active entities with this weight.
> + * @weights_node: weights tree member (see bfq_data's @queue_weights_tree
> + *                and @group_weights_tree).
> + */
> +struct bfq_weight_counter {
> +	short int weight;
> +	unsigned int num_active;
> +	struct rb_node weights_node;
> +};

This is way over-engineered.  In most cases, the only time you get the
same weight on all IO issuers would be when everybody is on the
default ioprio so might as well simply count the number of non-default
ioprios.  It'd be one integer instead of a tree of counters.

> @@ -306,6 +322,22 @@ enum bfq_device_speed {
>   * @rq_pos_tree: rbtree sorted by next_request position, used when
>   *               determining if two or more queues have interleaving
>   *               requests (see bfq_close_cooperator()).
> + * @active_numerous_groups: number of bfq_groups containing more than one
> + *                          active @bfq_entity.

You can safely assume that on any system which uses blkcg, the above
counter is >1.

This optimization may be theoretically interesting but doesn't seem
practical at all and would make the sytem behave distinctively
differently depending on something which is extremely subtle and seems
completely unrelated.  Furthermore, on any system which uses blkcg,
ext4, btrfs or has any task which has non-zero nice value, it won't
make any difference.  Its value is only theoretical.

Another thing to consider is that virtually all remotely modern
devices, rotational or not, are queued.  At this point, it's rather
pointless to design one behavior for !queued and another for queued.
Things should just be designed for queued devices.  I don't know what
the solution is but given that the benefits of NCQ for rotational
devices is extremely limited, sticking with single request model in
most cases and maybe allowing queued operation for specific workloads
might be a better approach.  As for ssds, just do something simple.
It's highly likely that most ssds won't travel this code path in the
near future anyway.

Thanks.

-- 
tejun
