Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933859AbbA1Bud (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 20:50:33 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:2236 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754965AbbA1Bua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:50:30 -0500
X-IronPort-AV: E=Sophos;i="5.04,848,1406563200"; 
   d="scan'208";a="56726975"
Message-ID: <54C840BA.7020207@cn.fujitsu.com>
Date: Wed, 28 Jan 2015 09:51:54 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
CC: <stable@vger.kernel.org>, Tejun Heo <tj@kernel.org>,
        Eric Sandeen <sandeen@sandeen.net>, Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH 3.18 11/61] workqueue: fix subtle pool management issue
 which can stall whole worker_pool
References: <20150128012636.936333725@linuxfoundation.org> <20150128012638.187292688@linuxfoundation.org>
In-Reply-To: <20150128012638.187292688@linuxfoundation.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2015 09:26 AM, Greg Kroah-Hartman wrote:
> 3.18-stable review patch.  If anyone has any objections, please let me know.


I don't think it is a bug-fix.
It is just a good cleanup.

> 
> ------------------
> 
> From: Tejun Heo <tj@kernel.org>
> 
> commit 29187a9eeaf362d8422e62e17a22a6e115277a49 upstream.
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
> 
> If this happens, manage_worker() could return false even with zero
> nr_idle making the worker, the last idle one, proceed to execute work
> items.  If then all workers of the pool end up blocking on a resource
> which can only be released by a work item which is pending on that
> pool, the whole pool can deadlock as there's no one to create more
> workers or summon the rescuers.
> 
> This patch fixes the problem by removing the early exit condition from
> maybe_create_worker() and making manage_workers() return false iff
> there's already another manager, which ensures that the last worker
> doesn't start executing work items.
> 
> We can leave the early exit condition alone and just ignore the return
> value but the only reason it was put there is because the
> manage_workers() used to perform both creations and destructions of
> workers and thus the function may be invoked while the pool is trying
> to reduce the number of workers.  Now that manage_workers() is called
> only when more workers are needed, the only case this early exit
> condition is triggered is rare race conditions rendering it pointless.
> 
> Tested with simulated workload and modified workqueue code which
> trigger the pool deadlock reliably without this patch.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Eric Sandeen <sandeen@sandeen.net>
> Link: http://lkml.kernel.org/g/54B019F4.8030009@sandeen.net
> Cc: Dave Chinner <david@fromorbit.com>
> Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---
>  kernel/workqueue.c |   25 ++++++++-----------------
>  1 file changed, 8 insertions(+), 17 deletions(-)
> 
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -1841,17 +1841,11 @@ static void pool_mayday_timeout(unsigned
>   * spin_lock_irq(pool->lock) which may be released and regrabbed
>   * multiple times.  Does GFP_KERNEL allocations.  Called only from
>   * manager.
> - *
> - * Return:
> - * %false if no action was taken and pool->lock stayed locked, %true
> - * otherwise.
>   */
> -static bool maybe_create_worker(struct worker_pool *pool)
> +static void maybe_create_worker(struct worker_pool *pool)
>  __releases(&pool->lock)
>  __acquires(&pool->lock)
>  {
> -	if (!need_to_create_worker(pool))
> -		return false;
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
> @@ -1919,12 +1910,12 @@ static bool manage_workers(struct worker
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
> 
> .
> 

