Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827AbaLDA6M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 19:58:12 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:30317 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752558AbaLDA6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 19:58:10 -0500
X-IronPort-AV: E=Sophos;i="5.04,848,1406563200"; 
   d="scan'208";a="44468458"
Message-ID: <547FB27E.5030904@cn.fujitsu.com>
Date: Thu, 4 Dec 2014 09:01:50 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: NeilBrown <neilb@suse.de>, Jan Kara <jack@suse.cz>,
        Dongsu Park <dongsu.park@profitbricks.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH - v3?] workqueue: allow rescuer thread to do more work.
References: <20141104142240.GD14459@htj.dyndns.org> <20141106165811.GA2338@gmail.com> <545C368C.5040704@cn.fujitsu.com> <20141110162848.6f2246bb@notabene.brown> <20141110085250.GB15948@quack.suse.cz> <20141111090402.35fa0700@notabene.brown> <20141118152754.60b0c75e@notabene.brown> <20141202204304.GR10918@htj.dyndns.org> <20141203114011.5d02dc43@notabene.brown> <20141203172010.GC5013@htj.dyndns.org> <20141203180241.GD5013@htj.dyndns.org>
In-Reply-To: <20141203180241.GD5013@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2014 02:02 AM, Tejun Heo wrote:
> So, something like the following.  Only compile tested.  I'll test it
> and post proper patches w/ due credits.
> 
> Thanks.
> 
> Index: work/kernel/workqueue.c
> ===================================================================
> --- work.orig/kernel/workqueue.c
> +++ work/kernel/workqueue.c
> @@ -1804,8 +1804,8 @@ static void pool_mayday_timeout(unsigned
>  	struct worker_pool *pool = (void *)__pool;
>  	struct work_struct *work;
>  
> -	spin_lock_irq(&wq_mayday_lock);		/* for wq->maydays */
> -	spin_lock(&pool->lock);
> +	spin_lock_irq(&pool->lock);
> +	spin_lock(&wq_mayday_lock);		/* for wq->maydays */
>  
>  	if (need_to_create_worker(pool)) {
>  		/*
> @@ -1818,8 +1818,8 @@ static void pool_mayday_timeout(unsigned
>  			send_mayday(work);
>  	}
>  
> -	spin_unlock(&pool->lock);
> -	spin_unlock_irq(&wq_mayday_lock);
> +	spin_unlock(&wq_mayday_lock);
> +	spin_unlock_irq(&pool->lock);
>  
>  	mod_timer(&pool->mayday_timer, jiffies + MAYDAY_INTERVAL);
>  }
> @@ -2248,12 +2248,29 @@ repeat:
>  		 * Slurp in all works issued via this workqueue and
>  		 * process'em.
>  		 */
> -		WARN_ON_ONCE(!list_empty(&rescuer->scheduled));
> +		WARN_ON_ONCE(!list_empty(scheduled));
>  		list_for_each_entry_safe(work, n, &pool->worklist, entry)
>  			if (get_work_pwq(work) == pwq)
>  				move_linked_works(work, scheduled, &n);
>  
> -		process_scheduled_works(rescuer);
> +		if (!list_empty(scheduled)) {
> +			process_scheduled_works(rescuer);
> +
> +			/*
> +			 * The above execution of rescued work items could
> +			 * have created more to rescue through
> +			 * pwq_activate_first_delayed() or chained
> +			 * queueing.  Let's put @pwq back on mayday list so
> +			 * that such back-to-back work items, which may be
> +			 * being used to relieve memory pressure, don't
> +			 * incur MAYDAY_INTERVAL delay inbetween.
> +			 */
> +			if (need_to_create_worker(pool)) {
> +				spin_lock(&wq_mayday_lock);
> +				list_move_tail(&pwq->mayday_node, &wq->maydays);

how about the pwq is empty now? and ...

> +				spin_unlock(&wq_mayday_lock);
> +			}
> +		}
>  
>  		/*
>  		 * Put the reference grabbed by send_mayday().  @pool won't

and the pwq is scheduled free here> 
> 

