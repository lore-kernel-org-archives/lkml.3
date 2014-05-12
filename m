Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862AbaELV0P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 17:26:15 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:44351 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbaELV0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 17:26:14 -0400
Date: Mon, 12 May 2014 17:26:10 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/10 V2] workqueue: destroy worker directly in the idle
 timeout handler
Message-ID: <20140512212610.GD18959@mtj.dyndns.org>
References: <20140505150514.GI11231@htj.dyndns.org>
 <1399877792-13046-1-git-send-email-laijs@cn.fujitsu.com>
 <1399877792-13046-5-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399877792-13046-5-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 02:56:16PM +0800, Lai Jiangshan wrote:
> @@ -1867,8 +1859,7 @@ static void idle_worker_timeout(unsigned long __pool)
>  	struct worker_pool *pool = (void *)__pool;
>  
>  	spin_lock_irq(&pool->lock);
> -
> -	if (too_many_workers(pool)) {
> +	while (too_many_workers(pool)) {

Hey, I like the new line there.

>  		struct worker *worker;
>  		unsigned long expires;
>  
> @@ -1876,15 +1867,13 @@ static void idle_worker_timeout(unsigned long __pool)
>  		worker = list_entry(pool->idle_list.prev, struct worker, entry);
>  		expires = worker->last_active + IDLE_WORKER_TIMEOUT;
>  
> -		if (time_before(jiffies, expires))
> +		if (time_before(jiffies, expires)) {
>  			mod_timer(&pool->idle_timer, expires);
> -		else {
> -			/* it's been idle for too long, wake up manager */
> -			pool->flags |= POOL_MANAGE_WORKERS;
> -			wake_up_worker(pool);
> +			break;
>  		}
> -	}
>  
> +		destroy_worker(worker);
> +	}

here too.

Other than the above new line removals, looks great to me.

Thanks.

-- 
tejun
