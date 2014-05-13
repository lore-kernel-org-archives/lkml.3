Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801AbaEMGvK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 02:51:10 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:23408 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753113AbaEMGvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 02:51:08 -0400
X-IronPort-AV: E=Sophos;i="4.97,1041,1389715200"; 
   d="scan'208";a="30439707"
Message-ID: <5371C1DC.8030102@cn.fujitsu.com>
Date: Tue, 13 May 2014 14:55:24 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 10/10 V2] workqueue: use generic attach/detach routine
 for rescuers
References: <20140505150514.GI11231@htj.dyndns.org> <1399877792-13046-1-git-send-email-laijs@cn.fujitsu.com> <1399877792-13046-11-git-send-email-laijs@cn.fujitsu.com> <20140512220505.GI18959@mtj.dyndns.org>
In-Reply-To: <20140512220505.GI18959@mtj.dyndns.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2014 06:05 AM, Tejun Heo wrote:
> On Mon, May 12, 2014 at 02:56:22PM +0800, Lai Jiangshan wrote:
>> There are several problems with the code that rescuers bind itself to the pool'
>> cpumask
>>   1) It uses a way different from the normal workers to bind to the cpumask
>>      So we can't maintain the normal/rescuer workers under the same framework.
>>   2) The the code of cpu-binding for rescuer is complicated
>>   3) If one or more cpuhotplugs happen while the rescuer processes the
>>      scheduled works, the rescuer may not be correctly bound to the cpumask of
>>      the pool. This is allowed behavior, but is not good. It will be better
>>      if the cpumask of the rescuer is always kept coordination with the pool
>>      across any cpuhotplugs.
>>
>> Using generic attach/detach routine will solve the above problems,
>> and result much more simple code.
>>
>> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
>>  static struct worker *alloc_worker(void)
>>  {
>>  	struct worker *worker;
>> @@ -2343,8 +2279,9 @@ repeat:
>>  
>>  		spin_unlock_irq(&wq_mayday_lock);
>>  
>> -		/* migrate to the target cpu if possible */
>> -		worker_maybe_bind_and_lock(pool);
>> +		worker_attach_to_pool(rescuer, pool);
>> +
>> +		spin_lock_irq(&pool->lock);
>>  		rescuer->pool = pool;
>>  
>>  		/*
>> @@ -2357,6 +2294,11 @@ repeat:
>>  				move_linked_works(work, scheduled, &n);
>>  
>>  		process_scheduled_works(rescuer);
>> +		spin_unlock_irq(&pool->lock);
>> +
>> +		worker_detach_from_pool(rescuer, pool);
>> +
>> +		spin_lock_irq(&pool->lock);
> 
> Ah, right, this is how it's used.  Yeah, it makes sense.  In a long
> patchset, it usually helps to mention your intentions when structuring
> functions tho.  When you're separating out detach_from_pool, just
> mention that the function will later be used to make rescuers use the

In patch3, the intention for separating out detach_from_pool() is
only for aync-destruction and it is used for worker_thread().
