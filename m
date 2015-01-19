Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911AbbASCO3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 21:14:29 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:28086 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751200AbbASCO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 21:14:28 -0500
X-IronPort-AV: E=Sophos;i="5.04,848,1406563200"; 
   d="scan'208";a="56242268"
Message-ID: <54BC68CD.7020809@cn.fujitsu.com>
Date: Mon, 19 Jan 2015 10:15:41 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, Eric Sandeen <sandeen@sandeen.net>
CC: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH workqueue wq/for-3.19-fixes] workqueue: fix subtle pool
 management issue which can stall whole worker_pool
References: <54B429EB.9050807@sandeen.net> <20150112225314.GC22156@htj.dyndns.org> <54B454E2.70707@sandeen.net> <20150112233755.GD22156@htj.dyndns.org> <54B56D2B.6090401@sandeen.net> <20150113201900.GA9489@htj.dyndns.org> <54B58041.9070502@sandeen.net> <20150113204633.GC9489@htj.dyndns.org> <54B5A313.2030300@sandeen.net> <20150113233552.GH9489@htj.dyndns.org> <20150116193239.GA3715@htj.dyndns.org>
In-Reply-To: <20150116193239.GA3715@htj.dyndns.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2015 03:32 AM, Tejun Heo wrote:
>>From 29187a9eeaf362d8422e62e17a22a6e115277a49 Mon Sep 17 00:00:00 2001
> From: Tejun Heo <tj@kernel.org>
> Date: Fri, 16 Jan 2015 14:21:16 -0500
> 
> A worker_pool's forward progress is guaranteed by the fact that the
> last idle worker assumes the manager role to create more workers and
> summon the rescuers if creating workers doesn't succeed in timely
> manner before proceeding to execute work items.
> 
> This manager role is implemented in manage_workers(), which indicates
> whether the worker may proceed to work item execution with its return
> value.  This is necessary because multiple workers may contend for the
> manager role, and, if there already is a manager, others should
> proceed to work item execution.
> 
> Unfortunately, the function also indicates that the worker may proceed
> to work item execution if need_to_create_worker() is false at the head
> of the function.  need_to_create_worker() tests the following
> conditions.
> 
> 	pending work items && !nr_running && !nr_idle

> 
> The first and third conditions are protected by pool->lock and thus
> won't change while holding pool->lock; however, nr_running can change
> asynchronously as other workers block and resume and while it's likely
> to be zero, as someone woke this worker up in the first place, some
> other workers could have become runnable inbetween making it non-zero.

I had sent a patch similar:
https://lkml.org/lkml/2014/7/10/446

It was shame for me that I did not think deep enough that time.

> 
> If this happens, manage_worker() could return false even with zero
> nr_idle making the worker, the last idle one, proceed to execute work
> items.  If then all workers of the pool end up blocking on a resource
> which can only be released by a work item which is pending on that
> pool, the whole pool can deadlock as there's no one to create more
> workers or summon the rescuers.

How nr_running is decreased to zero in this case?

( The decreasing of nr_running is also protected by "X" )

( I just checked the cpu-hotplug code again ... find no suspect)

> -static bool maybe_create_worker(struct worker_pool *pool)
> +static void maybe_create_worker(struct worker_pool *pool)
>  __releases(&pool->lock)
>  __acquires(&pool->lock)
>  {
> -	if (!need_to_create_worker(pool))
> -		return false;


It only returns false here, if there ware bug, the bug would be here.
But it still holds the pool->lock and no releasing form the beginning to here)

My doubt might be wrong, but at least it is a good cleanup
Acked-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Thanks
Lai

>  restart:
>  	spin_unlock_irq(&pool->lock);
>  
> @@ -1877,7 +1871,6 @@ restart:
>  	 */
>  	if (need_to_create_worker(pool))
>  		goto restart;
> -	return true;
>  }
>  
>  /**
> @@ -1897,16 +1890,14 @@ restart:
>   * multiple times.  Does GFP_KERNEL allocations.
>   *
>   * Return:
> - * %false if the pool don't need management and the caller can safely start
> - * processing works, %true indicates that the function released pool->lock
> - * and reacquired it to perform some management function and that the
> - * conditions that the caller verified while holding the lock before
> - * calling the function might no longer be true.
> + * %false if the pool doesn't need management and the caller can safely
> + * start processing works, %true if management function was performed and
> + * the conditions that the caller verified before calling the function may
> + * no longer be true.
>   */
>  static bool manage_workers(struct worker *worker)
>  {
>  	struct worker_pool *pool = worker->pool;
> -	bool ret = false;
>  
>  	/*
>  	 * Anyone who successfully grabs manager_arb wins the arbitration
> @@ -1919,12 +1910,12 @@ static bool manage_workers(struct worker *worker)
>  	 * actual management, the pool may stall indefinitely.
>  	 */
>  	if (!mutex_trylock(&pool->manager_arb))
> -		return ret;
> +		return false;
>  
> -	ret |= maybe_create_worker(pool);
> +	maybe_create_worker(pool);
>  
>  	mutex_unlock(&pool->manager_arb);
> -	return ret;
> +	return true;
>  }
>  
>  /**
> 

