Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933407AbaJ2OcQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 10:32:16 -0400
Received: from mail-qg0-f49.google.com ([209.85.192.49]:51250 "EHLO
	mail-qg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932834AbaJ2OcO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 10:32:14 -0400
Date: Wed, 29 Oct 2014 10:32:10 -0400
From: Tejun Heo <tj@kernel.org>
To: NeilBrown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC] workqueue: allow rescuer thread to do more work.
Message-ID: <20141029143210.GA25226@htj.dyndns.org>
References: <20141029172608.39119c80@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141029172608.39119c80@notabene.brown>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Neil.

On Wed, Oct 29, 2014 at 05:26:08PM +1100, NeilBrown wrote:
> Hi Tejun,
>   I haven't tested this patch yet so this really is an 'RFC'.
> In general ->nr_active should only be accessed under the pool->lock,
> but a miss-read here will at most cause a very occasional 100ms delay so
> shouldn't be a big problem.  The only thread likely to change ->nr_active is
> this thread, so such a delay would be extremely unlikely.
> 
> Thanks,
> NeilBrown
> 
> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 09b685daee3d..d0a8b101c5d9 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -2244,16 +2244,18 @@ repeat:
>  		spin_lock_irq(&pool->lock);
>  		rescuer->pool = pool;
>  
> -		/*
> -		 * Slurp in all works issued via this workqueue and
> -		 * process'em.
> -		 */
> -		WARN_ON_ONCE(!list_empty(&rescuer->scheduled));
> -		list_for_each_entry_safe(work, n, &pool->worklist, entry)
> -			if (get_work_pwq(work) == pwq)
> -				move_linked_works(work, scheduled, &n);
> +		do {
> +			/*
> +			 * Slurp in all works issued via this workqueue and
> +			 * process'em.
> +			 */
> +			WARN_ON_ONCE(!list_empty(&rescuer->scheduled));
> +			list_for_each_entry_safe(work, n, &pool->worklist, entry)
> +				if (get_work_pwq(work) == pwq)
> +					move_linked_works(work, scheduled, &n);
>  
> -		process_scheduled_works(rescuer);
> +			process_scheduled_works(rescuer);
> +		} while (need_more_worker(pool) && pwq->nr_active);

need_more_worker(pool) is always true for unbound pools as long as
there are work items queued, so the above condition may stay true
longer than it needs to.  Given that workder depletion is pool-wide
event, maybe it'd make sense to trigger rescuers immediately while
workers are in short supply?  e.g. while there's a manager stuck in
maybe_create_worker() with the mayday timer already triggered?

Thanks.

-- 
tejun
