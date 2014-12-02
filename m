Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933005AbaLBUnJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 15:43:09 -0500
Received: from mail-qg0-f44.google.com ([209.85.192.44]:42195 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932199AbaLBUnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 15:43:08 -0500
Date: Tue, 2 Dec 2014 15:43:04 -0500
From: Tejun Heo <tj@kernel.org>
To: NeilBrown <neilb@suse.de>
Cc: Jan Kara <jack@suse.cz>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Dongsu Park <dongsu.park@profitbricks.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH - v3?] workqueue: allow rescuer thread to do more work.
Message-ID: <20141202204304.GR10918@htj.dyndns.org>
References: <20141029172608.39119c80@notabene.brown>
 <20141029143210.GA25226@htj.dyndns.org>
 <20141030101932.2241daa7@notabene.brown>
 <20141104142240.GD14459@htj.dyndns.org>
 <20141106165811.GA2338@gmail.com>
 <545C368C.5040704@cn.fujitsu.com>
 <20141110162848.6f2246bb@notabene.brown>
 <20141110085250.GB15948@quack.suse.cz>
 <20141111090402.35fa0700@notabene.brown>
 <20141118152754.60b0c75e@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141118152754.60b0c75e@notabene.brown>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Nov 18, 2014 at 03:27:54PM +1100, NeilBrown wrote:
> @@ -2253,26 +2253,36 @@ repeat:
>  					struct pool_workqueue, mayday_node);
>  		struct worker_pool *pool = pwq->pool;
>  		struct work_struct *work, *n;
> +		int still_needed;
>  
>  		__set_current_state(TASK_RUNNING);
> -		list_del_init(&pwq->mayday_node);
> -
> -		spin_unlock_irq(&wq_mayday_lock);
> -
> -		worker_attach_to_pool(rescuer, pool);
> -
> -		spin_lock_irq(&pool->lock);
> -		rescuer->pool = pool;
> -
> +		spin_lock(&pool->lock);
>  		/*
>  		 * Slurp in all works issued via this workqueue and
>  		 * process'em.
>  		 */
>  		WARN_ON_ONCE(!list_empty(&rescuer->scheduled));
> +		still_needed = need_to_create_worker(pool);
>  		list_for_each_entry_safe(work, n, &pool->worklist, entry)
>  			if (get_work_pwq(work) == pwq)
>  				move_linked_works(work, scheduled, &n);
>  
> +		if (!list_empty(scheduled))
> +			still_needed = 1;
> +		if (still_needed) {
> +			list_move_tail(&pwq->mayday_node, &wq->maydays);
> +			get_pwq(pwq);
> +		} else
> +			/* We can let go of this one now */
> +			list_del_init(&pwq->mayday_node);

This seems rather convoluted.  Why are we testing this before
executing the work item?  Can't we do this after?  Isn't that -
whether the wq still needs rescuing after rescuer went through it once
- what we wanna know anyway?  e.g. something like the following.

	for_each_pwq_on_mayday_list {
		try to fetch work items from pwq->pool;
		if (none was fetched)
			goto remove_pwq;

		execute the fetched work items;

		if (need_to_create_worker()) {
			move the pwq to the tail;
			continue;
		}

	remove_pwq:
		remove the pwq;
	}

> +
> +		spin_unlock(&pool->lock);
> +		spin_unlock_irq(&wq_mayday_lock);
> +
> +		worker_attach_to_pool(rescuer, pool);
> +
> +		spin_lock_irq(&pool->lock);
> +		rescuer->pool = pool;
>  		process_scheduled_works(rescuer);
>  
>  		/*
> @@ -2293,7 +2303,7 @@ repeat:
>  		spin_unlock_irq(&pool->lock);
>  
>  		worker_detach_from_pool(rescuer, pool);
> -
> +		cond_resched();

Also, why this addition?  process_one_work() already has
cond_resched_rcu_qs().

Thanks.

-- 
tejun
