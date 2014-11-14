Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161581AbaKNRVt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 12:21:49 -0500
Received: from mail-qa0-f44.google.com ([209.85.216.44]:47975 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161017AbaKNRVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 12:21:48 -0500
Date: Fri, 14 Nov 2014 12:21:45 -0500
From: Tejun Heo <tj@kernel.org>
To: NeilBrown <neilb@suse.de>
Cc: Jan Kara <jack@suse.cz>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Dongsu Park <dongsu.park@profitbricks.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC] workqueue: allow rescuer thread to do more work.
Message-ID: <20141114172145.GE25889@htj.dyndns.org>
References: <20141029172608.39119c80@notabene.brown>
 <20141029143210.GA25226@htj.dyndns.org>
 <20141030101932.2241daa7@notabene.brown>
 <20141104142240.GD14459@htj.dyndns.org>
 <20141106165811.GA2338@gmail.com>
 <545C368C.5040704@cn.fujitsu.com>
 <20141110162848.6f2246bb@notabene.brown>
 <20141110085250.GB15948@quack.suse.cz>
 <20141111090402.35fa0700@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141111090402.35fa0700@notabene.brown>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Nov 11, 2014 at 09:04:02AM +1100, NeilBrown wrote:
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 09b685daee3d..f2db6073c498 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -2235,11 +2235,6 @@ repeat:
>  		struct work_struct *work, *n;
>  
>  		__set_current_state(TASK_RUNNING);
> -		list_del_init(&pwq->mayday_node);
> -
> -		spin_unlock_irq(&wq_mayday_lock);
> -
> -		worker_attach_to_pool(rescuer, pool);
>  
>  		spin_lock_irq(&pool->lock);
>  		rescuer->pool = pool;
> @@ -2253,8 +2248,16 @@ repeat:
>  			if (get_work_pwq(work) == pwq)
>  				move_linked_works(work, scheduled, &n);
>  
> -		process_scheduled_works(rescuer);
> +		if (list_empty(scheduled) || !need_to_create_worker(pool))
> +			/* We can let go of this one  now */
> +			list_del_init(&pwq->mayday_node);

We prolly want to rotate the processed one to the back of the list too
so that the rescuer round robins across multiple mayday requests?

Thanks.

-- 
tejun
