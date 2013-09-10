Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195Ab3IJAeA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 20:34:00 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:24757 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755756Ab3IJAd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 20:33:59 -0400
Message-ID: <522E68DD.2040500@huawei.com>
Date: Tue, 10 Sep 2013 08:33:33 +0800
From: Libin <huawei.libin@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <wangyijing@huawei.com>,
        <guohanjun@huawei.com>
Subject: Re: [PATCH] workqueue: fix potential reentrancy issue
References: <1378703534-4496-1-git-send-email-huawei.libin@huawei.com> <20130909141430.GD25434@htj.dyndns.org>
In-Reply-To: <20130909141430.GD25434@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.57]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Tejun,
On 2013/9/9 22:14, Tejun Heo wrote:
> On Mon, Sep 09, 2013 at 01:12:14PM +0800, Libin wrote:
>> From: Li Bin <huawei.libin@huawei.com>
>>
>> When one work starts execution, the high bits of work's data contain
>> pool ID. It can represent a maximum of WORK_OFFQ_POOL_NONE. Pool ID
>> is assigned WORK_OFFQ_POOL_NONE when the work being initialized
>> indicating that no pool is associated and get_work_pool() uses it to
>> check the associated pool. So if worker_pool_assign_id() assigns a
>> ID greater than or equal WORK_OFFQ_POOL_NONE to a pool, it may break
>> the non-reentrance guarantee.
>>
>> This patch fix this issue by modifying the worker_pool_assign_id()
>> function to add the WORK_OFFQ_POOL_NONE check condition.
>>
>> Signed-off-by: Li Bin <huawei.libin@huawei.com>
>> ---
>>  kernel/workqueue.c | 11 ++++++++++-
>>  1 file changed, 10 insertions(+), 1 deletion(-)
>>
>> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
>> index 41019b1..97d9ff7 100644
>> --- a/kernel/workqueue.c
>> +++ b/kernel/workqueue.c
>> @@ -518,7 +518,14 @@ static inline void debug_work_activate(struct work_struct *work) { }
>>  static inline void debug_work_deactivate(struct work_struct *work) { }
>>  #endif
>>  
>> -/* allocate ID and assign it to @pool */
>> +/**
>> + * worker_pool_assign_id - allocate ID and assing it to @pool
>> + * @pool: the pool pointer of interest
>> + *
>> + * Return 0 if ID assigned successful.
>> + * Return non-zero if the allocation fails or the ID number out of
>> + * %WORK_OFFQ_POOL_NONE range.
>> + */
>>  static int worker_pool_assign_id(struct worker_pool *pool)
>>  {
>>  	int ret;
>> @@ -526,6 +533,8 @@ static int worker_pool_assign_id(struct worker_pool *pool)
>>  	lockdep_assert_held(&wq_pool_mutex);
>>  
>>  	ret = idr_alloc(&worker_pool_idr, pool, 0, 0, GFP_KERNEL);
>> +	if (ret >= WORK_OFFQ_POOL_NONE)
>> +		return ret;
> 
> Hmmm.... this would leak the allocated ID.  Just setting @end param to
> idr_alloc to WORK_OFFQ_POOL_NONE would work, right?
> 

Yes, I will update it with the last patch.
Thanks!
Libin

> Thanks.
> 


