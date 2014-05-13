Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751766AbaEMG2n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 02:28:43 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:42761 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750743AbaEMG2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 02:28:42 -0400
X-IronPort-AV: E=Sophos;i="4.97,1040,1389715200"; 
   d="scan'208";a="30438765"
Message-ID: <5371BC94.5080507@cn.fujitsu.com>
Date: Tue, 13 May 2014 14:32:52 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 03/10 V2] workqueue: async worker destruction
References: <20140505150514.GI11231@htj.dyndns.org> <1399877792-13046-1-git-send-email-laijs@cn.fujitsu.com> <1399877792-13046-4-git-send-email-laijs@cn.fujitsu.com> <20140512212022.GC18959@mtj.dyndns.org>
In-Reply-To: <20140512212022.GC18959@mtj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2014 05:20 AM, Tejun Heo wrote:
> On Mon, May 12, 2014 at 02:56:15PM +0800, Lai Jiangshan wrote:
>>  /**
>> + * worker_detach_from_pool() - detach the worker from the pool
>> + * @worker: worker which is attached to its pool
>> + * @pool: attached pool
>> + *
>> + * Undo the attaching which had been done in create_worker().
>> + * The caller worker shouldn't access to the pool after detached
>> + * except it has other reference to the pool.
>> + */
>> +static void worker_detach_from_pool(struct worker *worker,
>> +				    struct worker_pool *pool)
>> +{
>> +	struct completion *detach_completion = NULL;
>> +
>> +	mutex_lock(&pool->manager_mutex);
>> +	idr_remove(&pool->worker_idr, worker->id);
>> +	if (idr_is_empty(&pool->worker_idr))
>> +		detach_completion = pool->detach_completion;
>> +	mutex_unlock(&pool->manager_mutex);
>> +
>> +	if (detach_completion)
>> +		complete(detach_completion);
>> +}
> 
> Are we gonna use this function from somewhere else too?

it is called from worker_thread().

I don't want to unfold it into worker_thread(), it is better
readability when it is wrapped and it will be called in patch10
for rescuer.

> 
>> @@ -2289,6 +2298,10 @@ woke_up:
>>  		spin_unlock_irq(&pool->lock);
>>  		WARN_ON_ONCE(!list_empty(&worker->entry));
>>  		worker->task->flags &= ~PF_WQ_WORKER;
>> +
>> +		set_task_comm(worker->task, "kworker_dying");
> 
> Given how other kworkers are named, maybe a better name is
> "kworker/dying" or "kworker/detached"?
> 
>> +		worker_detach_from_pool(worker, pool);
>> +		kfree(worker);
>>  		return 0;
>>  	}
>>  
>> @@ -3561,6 +3574,7 @@ static void rcu_free_pool(struct rcu_head *rcu)
>>  static void put_unbound_pool(struct worker_pool *pool)
>>  {
>>  	struct worker *worker;
>> +	DECLARE_COMPLETION_ONSTACK(detach_completion);
> 
> I think it's conventional to put initialized ones (especially the ones
> require initializing macros) before uninitialized vars.
> 
>> @@ -3579,19 +3593,24 @@ static void put_unbound_pool(struct worker_pool *pool)
>>  
>>  	/*
>>  	 * Become the manager and destroy all workers.  Grabbing
>> -	 * manager_arb prevents @pool's workers from blocking on
>> -	 * manager_mutex.
>> +	 * manager_arb ensures manage_workers() finish and enter idle.
> 
> I don't follow what the above comment update is trying to say.

If a pool is destroying, the worker will not call manage_workers().
but the existing manage_workers() may be still running.

mutex_lock(&manager_arb) in put_unbound_pool() should wait this manage_workers()
finished due to the manager-worker (non-idle-worker) can't be destroyed.

> 
> Thanks.
> 

