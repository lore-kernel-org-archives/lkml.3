Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958Ab3CJKH3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 06:07:29 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:53004 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752799Ab3CJKH0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 06:07:26 -0400
X-IronPort-AV: E=Sophos;i="4.84,818,1355068800"; 
   d="scan'208";a="6844190"
Message-ID: <513C5BE2.8090409@cn.fujitsu.com>
Date: Sun, 10 Mar 2013 18:09:38 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, axboe@kernel.dk, jmoyer@redhat.com,
        zab@redhat.com
Subject: Re: [PATCH 14/31] workqueue: replace POOL_MANAGING_WORKERS flag with
 worker_pool->manager_mutex
References: <1362194662-2344-1-git-send-email-tj@kernel.org> <1362194662-2344-15-git-send-email-tj@kernel.org>
In-Reply-To: <1362194662-2344-15-git-send-email-tj@kernel.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/10 18:06:15,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/03/10 18:06:15,
	Serialize complete at 2013/03/10 18:06:15
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/13 11:24, Tejun Heo wrote:
> POOL_MANAGING_WORKERS is used to synchronize the manager role.
> Synchronizing among workers doesn't need blocking and that's why it's
> implemented as a flag.
> 
> It got converted to a mutex a while back to add blocking wait from CPU
> hotplug path - 6037315269 ("workqueue: use mutex for global_cwq
> manager exclusion").  Later it turned out that synchronization among
> workers and cpu hotplug need to be done separately.  Eventually,
> POOL_MANAGING_WORKERS is restored and workqueue->manager_mutex got
> morphed into workqueue->assoc_mutex - 552a37e936 ("workqueue: restore
> POOL_MANAGING_WORKERS") and b2eb83d123 ("workqueue: rename
> manager_mutex to assoc_mutex").
> 
> Now, we're gonna need to be able to lock out managers from
> destroy_workqueue() to support multiple unbound pools with custom
> attributes making it again necessary to be able to block on the
> manager role.  This patch replaces POOL_MANAGING_WORKERS with
> worker_pool->manager_mutex.
> 
> This patch doesn't introduce any behavior changes.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> ---
>  kernel/workqueue.c | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 2645218..68b3443 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -64,7 +64,6 @@ enum {
>  	 * create_worker() is in progress.
>  	 */
>  	POOL_MANAGE_WORKERS	= 1 << 0,	/* need to manage workers */
> -	POOL_MANAGING_WORKERS   = 1 << 1,       /* managing workers */
>  	POOL_DISASSOCIATED	= 1 << 2,	/* cpu can't serve workers */
>  	POOL_FREEZING		= 1 << 3,	/* freeze in progress */
>  
> @@ -145,6 +144,7 @@ struct worker_pool {
>  	DECLARE_HASHTABLE(busy_hash, BUSY_WORKER_HASH_ORDER);
>  						/* L: hash of busy workers */
>  
> +	struct mutex		manager_mutex;	/* the holder is the manager */
>  	struct mutex		assoc_mutex;	/* protect POOL_DISASSOCIATED */
>  	struct ida		worker_ida;	/* L: for worker IDs */
>  
> @@ -702,7 +702,7 @@ static bool need_to_manage_workers(struct worker_pool *pool)
>  /* Do we have too many workers and should some go away? */
>  static bool too_many_workers(struct worker_pool *pool)
>  {
> -	bool managing = pool->flags & POOL_MANAGING_WORKERS;
> +	bool managing = mutex_is_locked(&pool->manager_mutex);
>  	int nr_idle = pool->nr_idle + managing; /* manager is considered idle */
>  	int nr_busy = pool->nr_workers - nr_idle;
>  
> @@ -2027,15 +2027,13 @@ static bool manage_workers(struct worker *worker)
>  	struct worker_pool *pool = worker->pool;
>  	bool ret = false;
>  
> -	if (pool->flags & POOL_MANAGING_WORKERS)
> +	if (!mutex_trylock(&pool->manager_mutex))
>  		return ret;
>  
> -	pool->flags |= POOL_MANAGING_WORKERS;


if mutex_trylock(&pool->manager_mutex) fails, it does not mean
the pool is managing workers. (although current code does).
so I recommend to keep POOL_MANAGING_WORKERS.

I suggest that you reuse assoc_mutex for your purpose(later patches).
(and rename assoc_mutex back to manager_mutex)


> -
>  	/*
>  	 * To simplify both worker management and CPU hotplug, hold off
>  	 * management while hotplug is in progress.  CPU hotplug path can't
> -	 * grab %POOL_MANAGING_WORKERS to achieve this because that can
> +	 * grab @pool->manager_mutex to achieve this because that can
>  	 * lead to idle worker depletion (all become busy thinking someone
>  	 * else is managing) which in turn can result in deadlock under
>  	 * extreme circumstances.  Use @pool->assoc_mutex to synchronize
> @@ -2075,8 +2073,8 @@ static bool manage_workers(struct worker *worker)
>  	ret |= maybe_destroy_workers(pool);
>  	ret |= maybe_create_worker(pool);
>  
> -	pool->flags &= ~POOL_MANAGING_WORKERS;
>  	mutex_unlock(&pool->assoc_mutex);
> +	mutex_unlock(&pool->manager_mutex);
>  	return ret;
>  }
>  
> @@ -3805,6 +3803,7 @@ static int __init init_workqueues(void)
>  			setup_timer(&pool->mayday_timer, pool_mayday_timeout,
>  				    (unsigned long)pool);
>  
> +			mutex_init(&pool->manager_mutex);
>  			mutex_init(&pool->assoc_mutex);
>  			ida_init(&pool->worker_ida);
>  

