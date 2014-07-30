Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544AbaG3Abb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 20:31:31 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:33292 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750702AbaG3Aba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 20:31:30 -0400
X-IronPort-AV: E=Sophos;i="5.00,990,1396972800"; 
   d="scan'208";a="33934165"
Message-ID: <53D83D33.80101@cn.fujitsu.com>
Date: Wed, 30 Jul 2014 08:32:51 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC 2/2 V2] workqueue: use dedicated creater kthread for
 all pools
References: <20140729021643.GA22241@mtj.dyndns.org> <1406625376-19177-1-git-send-email-laijs@cn.fujitsu.com> <20140729150459.GE4791@htj.dyndns.org>
In-Reply-To: <20140729150459.GE4791@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2014 11:04 PM, Tejun Heo wrote:
> Hello,
> 
> On Tue, Jul 29, 2014 at 05:16:07PM +0800, Lai Jiangshan wrote:
> 
> First of all, the patch is too big.  This is a rather pervasive
> change.  Please split it up if at all possible.
> 
>> +/* Start the mayday timer and the creater when needed */
>> +static inline void start_creater_work(struct worker_pool *pool)
>> +{
>> +	if (pool->nr_idle || pool->creating || list_empty(&pool->worklist))
>> +		return;
> 
> pool->creating is an optimization around queue_kthread_work(), right?
> So that you don't have to grab the lock every time a work item is
> queued.  Please explain things like that explicitly.  Also, the
> condition itself needs explanation.  This is what guarantees that the
> queue is not stalled after all.
> 
> Hmmm... list_empty() is unnecessary when called from the queueing
> path.  Do we want to move that out of this function?
> 
>>  	/* we own @work, set data and link */
>>  	set_work_pwq(work, pwq, extra_flags);
>>  	list_add_tail(&work->entry, head);
>> +	start_creater_work(pool);
> 
> creator is spelled with an 'o' not 'e'.  Also, it'd be better if the
> name reflects that this is a kthread_work not a workqueue one.
> 
>> +static void create_worker(struct kthread_work *work)
>>  {
> ...
>>  fail:
>>  	if (id >= 0)
>>  		ida_simple_remove(&pool->worker_ida, id);
>>  	kfree(worker);
>> -	return NULL;
>> +
>> +	/* cool down before next create_worker() */
>> +	schedule_timeout_interruptible(CREATE_COOLDOWN);
>> +	del_timer_sync(&pool->mayday_timer);
>> +
>> +	spin_lock_irq(&pool->lock);
>> +	pool->creating = false;
>> +	start_creater_work(pool);
>> +	spin_unlock_irq(&pool->lock);
> 
> Why?  Just sleep and retry?  What's the point of requeueing?

Accepted your comments except this one which may need to discuss
for an additional round.  Requeueing passes the retry to the
kthread_worker and gives a change to the other pools which are also
creating worker.

This patch will be deferred until 3.19 due to some unbound patches
are ready soon.

Thanks!!
Lai

> 
>> -/**
>>   * process_one_work - process single work
>>   * @worker: self
>>   * @work: work to process
>> @@ -1991,6 +1905,7 @@ __acquires(&pool->lock)
>>  	work_color = get_work_color(work);
>>  
>>  	list_del_init(&work->entry);
>> +	start_creater_work(pool);
> 
> Should this be combined with wake_up_worker()?
> 
> Thanks.
> 

