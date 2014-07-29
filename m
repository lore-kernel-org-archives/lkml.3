Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752298AbaG2BZX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 21:25:23 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:2558 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751771AbaG2BZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 21:25:14 -0400
X-IronPort-AV: E=Sophos;i="5.00,984,1396972800"; 
   d="scan'208";a="33889206"
Message-ID: <53D6F84B.6000000@cn.fujitsu.com>
Date: Tue, 29 Jul 2014 09:26:35 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] workqueue: use dedicated creater kthread for all
 pools
References: <1406343900-32423-1-git-send-email-laijs@cn.fujitsu.com> <1406343900-32423-3-git-send-email-laijs@cn.fujitsu.com> <20140728185536.GG7462@htj.dyndns.org>
In-Reply-To: <20140728185536.GG7462@htj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2014 02:55 AM, Tejun Heo wrote:
> Hello, Lai.
> 
> On Sat, Jul 26, 2014 at 11:04:50AM +0800, Lai Jiangshan wrote:
>> There are some problems with the managers:
>>   1) The last idle worker prefer managing to processing.
>>      It is better that the processing of work items should be the first
>>      priority to make the whole system make progress earlier.
>>   2) managers among different pools can be parallel, but actually
>>      their major work are serialized on the kernel thread "kthreadd".
>>      These managers are sleeping and wasted when the system is lack
>>      of memory.
> 
> It's a bit difficult to get excited about this patchset given that
> this is mostly churn without many actual benefits.  Sure, it
> consolidates one-per-pool managers into one kthread_worker but it was
> one-per-pool already.  That said, I don't hate it and it may be
> considered an improvement.  I don't know.

It prefers to processing works rather than creating worker without any
loss of the guarantee.

processing works makes directly progress for the system.
creating worker makes delay and indirectly progress.

> 
>> This patch introduces a dedicated creater kthread which offloads the
>> managing from the workers, thus every worker makes effort to process work
>> rather than create worker, and there is no manager wasting on sleeping
>> when the system is lack of memory.  This dedicated creater kthread causes
>> a little more work serialized than before, but it is acceptable.
> 
> I do dislike the idea of creating this sort of hard serialization
> among separate worker pools.  It's probably acceptable but why are we
> doing this?  


I was about to use per-cpu kthread_worker, but I changed to use single
global kthread_worker after I had noticed the kthread_create() is already
serialized in kthreadd.

> To save one thread per pool and shed 30 lines of code
> while adding 40 lines to kthread_worker?

Countings are different between us!
Simplicity was also my aim in this patchset and total LOC was reduced.

> 
>>   1) the creater_work
>> Every pool has a struct kthread_work creater_work to create worker, and
>> the dedicated creater kthread processes all these creater_works of
>> all pools. struct kthread_work has itself execution exclusion, so we don't
>> need the manager_arb to handle the creating exclusion any more.
> 
> This explanation can be a bit misleading, I think.  We just don't have
> multiple workers trying to become managers anymore.
> 
>> put_unbound_pool() uses the flush_kthread_work() to synchronize with
>> the creating rather than uses the manager_arb.
>>
>>   2) the cooldown timer
>> The cooldown timer is introduced to implement the cool-down mechanism
>> rather than to causes the creater to sleep.  When the create_worker()
>> fails, the cooldown timer is requested and it will restart the creater_work.
> 
> Why?  Why doesn't the creator sleep?
> 
> ...
>>   5) the routine of the creater_work
>> The creater_work creates a worker in these two conditions:
>>   A) pool->nr_idle == 0
>>      A new worker is needed to be created obviously even there is no
>>      work item pending.  The busy workers may sleep and the pool can't
>>      serves the future new work items if no new worker is standby or
>>      being created.
> 
> This is kinda silly when the duty of worker creation is served by an
> external entity.  Why would a pool need any idle worker?

The idle worker must be ready or being prepared for wq_worker_sleeping()
or chained-wake-up.

percpu-kthreadd can serve for wq_worker_sleeping() in this case, but it is
not a good idle to introduce percpu-kthreadd now since no other user.

> insert_work() may as well just queue worker creation on demand.

Yes, it can save some workers for idle-unbound-pool.

> 
>>   8) init_workqueues()
>> The struct kthread_worker kworker_creater is initialized earlier than
>> worker_pools in init_workqueues() so that kworker_creater_thread is
>> created than all early kworkers.  Although the early kworkers are not
>> depends on kworker_creater_thread, but this initialization order makes
>> the pid of kworker_creater_thread smaller than kworkers which
>> seems more smooth.
> 
> Just don't create idle workers?

It does a good idea.

Thanks for review and comments.
Lai
