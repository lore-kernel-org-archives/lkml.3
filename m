Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327Ab3FGAE5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 20:04:57 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:64232 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752944Ab3FGAEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 20:04:55 -0400
Date: Thu, 6 Jun 2013 17:04:52 -0700
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@openvz.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>, devel@openvz.org
Subject: Re: [PATCH v7 09/11] sched: record per-cgroup number of context
 switches
Message-ID: <20130607000452.GS5045@htj.dyndns.org>
References: <1369825402-31046-1-git-send-email-glommer@openvz.org>
 <1369825402-31046-10-git-send-email-glommer@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369825402-31046-10-git-send-email-glommer@openvz.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Maybe we should break off addition of switch stats to a separate set?
They are two separate things.

On Wed, May 29, 2013 at 03:03:20PM +0400, Glauber Costa wrote:
> @@ -3642,6 +3642,8 @@ pick_next_task_fair(struct rq *rq, struct task_struct *prev)
>  		prev->sched_class->put_prev_task(rq, prev);
>  
>  	do {
> +		if (likely(prev))
> +			cfs_rq->nr_switches++;
>  		se = pick_next_entity(cfs_rq);
>  		set_next_entity(cfs_rq, se);
>  		cfs_rq = group_cfs_rq(se);
> @@ -3651,6 +3653,22 @@ pick_next_task_fair(struct rq *rq, struct task_struct *prev)
>  	if (hrtick_enabled(rq))
>  		hrtick_start_fair(rq, p);
>  
> +	/*
> +	 * This condition is extremely unlikely, and most of the time will just
> +	 * consist of this unlikely branch, which is extremely cheap. But we
> +	 * still need to have it, because when we first loop through cfs_rq's,
> +	 * we can't possibly know which task we will pick. The call to
> +	 * set_next_entity above is not meant to mess up the tree in this case,
> +	 * so this should give us the same chain, in the same order.
> +	 */
> +	if (unlikely(p == prev)) {
> +		se = &p->se;
> +		for_each_sched_entity(se) {
> +			cfs_rq = cfs_rq_of(se);
> +			cfs_rq->nr_switches--;
> +		}
> +	}
> +

This concern may be fringe but the above breaks the monotonically
increasing property of the stat.  Depending on the timing, a very
unlucky consumer of the stat may see the counter going backward which
can lead to nasty things.  I'm not sure whether the fact that it'd be
very difficult to trigger is a pro or con.

Thanks.

-- 
tejun
