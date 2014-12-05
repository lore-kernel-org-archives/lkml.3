Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933516AbaLECFm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 21:05:42 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:16226 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751838AbaLECFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 21:05:41 -0500
X-IronPort-AV: E=Sophos;i="5.04,848,1406563200"; 
   d="scan'208";a="44534212"
Message-ID: <548113DC.9040409@cn.fujitsu.com>
Date: Fri, 5 Dec 2014 10:09:32 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: NeilBrown <neilb@suse.de>, Jan Kara <jack@suse.cz>,
        Dongsu Park <dongsu.park@profitbricks.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH workqueue/for-3.18-fixes 1/2] workqueue: invert the order
 between pool->lock and wq_mayday_lock
References: <20141106165811.GA2338@gmail.com> <545C368C.5040704@cn.fujitsu.com> <20141110162848.6f2246bb@notabene.brown> <20141110085250.GB15948@quack.suse.cz> <20141111090402.35fa0700@notabene.brown> <20141118152754.60b0c75e@notabene.brown> <20141202204304.GR10918@htj.dyndns.org> <20141203114011.5d02dc43@notabene.brown> <20141203172010.GC5013@htj.dyndns.org> <20141203180241.GD5013@htj.dyndns.org> <20141204151104.GD15219@htj.dyndns.org>
In-Reply-To: <20141204151104.GD15219@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2014 11:11 PM, Tejun Heo wrote:
> Currently, pool->lock nests inside pool->lock.  There's no inherent
> reason for this order.  The only place where the two locks are held
> together is pool_mayday_timeout() and it just got decided that way.
> 
> This nesting order turns out to complicate things with the planned
> rescuer_thread() update.  Let's invert them.  This doesn't cause any
> behavior differences.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: NeilBrown <neilb@suse.de>
> Cc: Dongsu Park <dongsu.park@profitbricks.com>
> Cc: Lai Jiangshan <laijs@cn.fujitsu.com>

Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>

> ---
>  kernel/workqueue.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
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
> 

