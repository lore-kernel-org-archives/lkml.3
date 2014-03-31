Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298AbaCaNMP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 09:12:15 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:36282 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753250AbaCaNMN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 09:12:13 -0400
X-IronPort-AV: E=Sophos;i="4.97,765,1389715200"; 
   d="scan'208";a="9800532"
Message-ID: <53396A6E.4030607@cn.fujitsu.com>
Date: Mon, 31 Mar 2014 21:15:26 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Christoph Lameter <cl@linux.com>,
        Kevin Hilman <khilman@linaro.org>,
        Mike Galbraith <bitbucket@online.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>, Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 4/4] workqueue: Include ordered workqueues in anon workqueue
 sysfs interface
References: <1395940862-31428-1-git-send-email-fweisbec@gmail.com> <1395940862-31428-5-git-send-email-fweisbec@gmail.com> <533964AE.9070503@cn.fujitsu.com>
In-Reply-To: <533964AE.9070503@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/31 21:08:41,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2014/03/31 21:08:42,
	Serialize complete at 2014/03/31 21:08:42
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2014 08:50 PM, Lai Jiangshan wrote:
> On 03/28/2014 01:21 AM, Frederic Weisbecker wrote:
>> Changing the cpu affinity of workqueues through the sysfs interface
>> is done with apply_workqueue_attrs() by replacing the old pwqs
>> of a workqueue with new ones tied to worker pools that are affine to the
>> new cpumask.
>>
>> We can't do that with ordered workqueues however because the serialization
>> of their works is enforced by keeping a single worker running. Replacing
>> it with a new pool of single worker may open a small race window where
>> two workers could run concurrently during the pwq replacement. Eventually
>> this can break the ordering guarantee.
>>
>> So ordered workqueues get a special treatment here. Since they run a
>> single pwq with a single pool containing a single worker that all
>> ordered workqueue should share, we simply change this worker affinity
>> to the new cpumask.
>>
>> Also just in case this behaviour change a bit in the future and some
>> ordered workqueues have their private worker, lets iterate the affinity
>> change over all ordered workqueue pools. This way it works in both cases:
>> whether a single worker is shared among all ordered workqueue pools or
>> some of them run their private one.
>>
>> Suggested-by: Tejun Heo <tj@kernel.org>
>> Cc: Christoph Lameter <cl@linux.com>
>> Cc: Kevin Hilman <khilman@linaro.org>
>> Cc: Mike Galbraith <bitbucket@online.de>
>> Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
>> Cc: Tejun Heo <tj@kernel.org>
>> Cc: Viresh Kumar <viresh.kumar@linaro.org>
>> Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
>> ---
>>  kernel/workqueue.c | 68 ++++++++++++++++++++++++++++++++++++++++++++----------
>>  1 file changed, 56 insertions(+), 12 deletions(-)
>>
>> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
>> index 2863c39..18807c7 100644
>> --- a/kernel/workqueue.c
>> +++ b/kernel/workqueue.c
>> @@ -3330,10 +3330,60 @@ static ssize_t wq_anon_cpumask_show(struct device *dev,
>>  	return written;
>>  }
>>  
>> -/* Must be called with wq_unbound_mutex held */
>> -static int wq_anon_cpumask_set(cpumask_var_t cpumask)
>> +static int wq_ordered_cpumask_set(struct workqueue_struct *wq, cpumask_var_t cpumask)
>> +{
>> +	struct pool_workqueue *pwq;
>> +	struct worker_pool *pool;
>> +	struct worker *worker;
>> +	int ret;
>> +	int wi;
>> +
>> +	mutex_lock(&wq_pool_mutex);
>> +	pwq = list_first_entry(&wq->pwqs, typeof(*pwq), pwqs_node);
>> +	pool = pwq->pool;
>> +
>> +	mutex_lock(&pool->manager_mutex);
>> +	for_each_pool_worker(worker, wi, pool) {
>> +		/* CHECKME: Should we hold pool->lock here? */
> 
> Don't need to hold pool->lock which is a spinlock.
> pool->manager_mutex is enough to apply cpumask setting
> (but we only do it in cpuhotplug callbacks now).
> 
>> +		ret = set_cpus_allowed_ptr(worker->task, cpumask);
> 
> no.
> 
> even the pwq(of ordered wq) shares the pool with other unbound pwq.
> we shouldn't change the worker's attr.


Sorry, I'm wrong.
Tejun had told there is only one default worker pool for ordered workqueues.

It is true. But this pool may share with other non-ordered workqueues which
maybe have WQ_SYSFS. we should split this pool into two pools.
one for ordered wqs, one for the rest.

> 
> Although we can change the ordered wq to use dedicated pool.
> But if we do so, I would recommend to remove the ordered wq from workqueue.c totally
> and ask the callers use queue_kthread_work() instead.
> 
> (dedicated or any)pool requires two workers at least, and requires much
> more other resource.
> 
>> +		if (ret)
>> +			break;
>> +	}
>> +	if (!ret) {
>> +		cpumask_copy(pool->attrs->cpumask, cpumask);
> 
> pool->attr should be constant (except initialization/destruction).
> 
>> +	}
>> +	mutex_unlock(&pool->manager_mutex);
>> +
>> +	if (!ret) {
>> +		mutex_lock(&wq->mutex);
>> +		cpumask_copy(wq->unbound_attrs->cpumask, cpumask);
>> +		mutex_unlock(&wq->mutex);
>> +	}
>> +
>> +	mutex_unlock(&wq_pool_mutex);
>> +
>> +	return ret;
>> +}
>> +
>> +static int wq_anon_cpumask_set(struct workqueue_struct *wq, cpumask_var_t cpumask)
>>  {
>>  	struct workqueue_attrs *attrs;
>> +	int ret;
>> +
>> +	attrs = wq_sysfs_prep_attrs(wq);
>> +	if (!attrs)
>> +		return -ENOMEM;
>> +
>> +	cpumask_copy(attrs->cpumask, cpumask);
>> +	ret = apply_workqueue_attrs(wq, attrs);
>> +	free_workqueue_attrs(attrs);
>> +
>> +	return ret;
>> +}
>> +
>> +/* Must be called with wq_unbound_mutex held */
>> +static int wq_anon_cpumask_set_all(cpumask_var_t cpumask)
>> +{
>>  	struct workqueue_struct *wq;
>>  	int ret;
>>  
>> @@ -3343,15 +3393,9 @@ static int wq_anon_cpumask_set(cpumask_var_t cpumask)
>>  			continue;
>>  		/* Ordered workqueues need specific treatment */
>>  		if (wq->flags & __WQ_ORDERED)
>> -			continue;
>> -
>> -		attrs = wq_sysfs_prep_attrs(wq);
>> -		if (!attrs)
>> -			return -ENOMEM;
>> -
>> -		cpumask_copy(attrs->cpumask, cpumask);
>> -		ret = apply_workqueue_attrs(wq, attrs);
>> -		free_workqueue_attrs(attrs);
>> +			ret = wq_ordered_cpumask_set(wq, cpumask);



After the pool is split. wq_ordered_cpumask_set() should only be called once.
once is enough for all ordered wqs.


>> +		else
>> +			ret = wq_anon_cpumask_set(wq, cpumask);
>>  		if (ret)
>>  			break;
>>  	}
>> @@ -3376,7 +3420,7 @@ static ssize_t wq_anon_cpumask_store(struct device *dev,
>>  	get_online_cpus();
>>  	if (cpumask_intersects(cpumask, cpu_online_mask)) {
>>  		mutex_lock(&wq_unbound_mutex);
>> -		ret = wq_anon_cpumask_set(cpumask);
>> +		ret = wq_anon_cpumask_set_all(cpumask);
>>  		if (!ret)
>>  			cpumask_copy(&wq_anon_cpumask, cpumask);
>>  		mutex_unlock(&wq_unbound_mutex);
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

