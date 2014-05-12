Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752111AbaELWFK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 18:05:10 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:53593 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751254AbaELWFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 18:05:08 -0400
Date: Mon, 12 May 2014 18:05:05 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/10 V2] workqueue: use generic attach/detach routine
 for rescuers
Message-ID: <20140512220505.GI18959@mtj.dyndns.org>
References: <20140505150514.GI11231@htj.dyndns.org>
 <1399877792-13046-1-git-send-email-laijs@cn.fujitsu.com>
 <1399877792-13046-11-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399877792-13046-11-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 12, 2014 at 02:56:22PM +0800, Lai Jiangshan wrote:
> There are several problems with the code that rescuers bind itself to the pool'
> cpumask
>   1) It uses a way different from the normal workers to bind to the cpumask
>      So we can't maintain the normal/rescuer workers under the same framework.
>   2) The the code of cpu-binding for rescuer is complicated
>   3) If one or more cpuhotplugs happen while the rescuer processes the
>      scheduled works, the rescuer may not be correctly bound to the cpumask of
>      the pool. This is allowed behavior, but is not good. It will be better
>      if the cpumask of the rescuer is always kept coordination with the pool
>      across any cpuhotplugs.
> 
> Using generic attach/detach routine will solve the above problems,
> and result much more simple code.
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
>  static struct worker *alloc_worker(void)
>  {
>  	struct worker *worker;
> @@ -2343,8 +2279,9 @@ repeat:
>  
>  		spin_unlock_irq(&wq_mayday_lock);
>  
> -		/* migrate to the target cpu if possible */
> -		worker_maybe_bind_and_lock(pool);
> +		worker_attach_to_pool(rescuer, pool);
> +
> +		spin_lock_irq(&pool->lock);
>  		rescuer->pool = pool;
>  
>  		/*
> @@ -2357,6 +2294,11 @@ repeat:
>  				move_linked_works(work, scheduled, &n);
>  
>  		process_scheduled_works(rescuer);
> +		spin_unlock_irq(&pool->lock);
> +
> +		worker_detach_from_pool(rescuer, pool);
> +
> +		spin_lock_irq(&pool->lock);

Ah, right, this is how it's used.  Yeah, it makes sense.  In a long
patchset, it usually helps to mention your intentions when structuring
functions tho.  When you're separating out detach_from_pool, just
mention that the function will later be used to make rescuers use the
same attach/detach framework as normal workers.

How has this been tested?

Thanks.

-- 
tejun
