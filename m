Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932595AbaKRWmJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 17:42:09 -0500
Received: from mga11.intel.com ([192.55.52.93]:16968 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753595AbaKRWmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 17:42:07 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,412,1413270000"; 
   d="scan'208";a="624511932"
Date: Wed, 19 Nov 2014 06:21:14 +0800
From: Wanpeng Li <wanpeng.li@linux.intel.com>
To: Juri Lelli <juri.lelli@arm.com>
Cc: Wanpeng Li <wanpeng.li@linux.intel.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Kirill Tkhai <ktkhai@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched/rt: fix rt runtime corrupt when dl refuse a
 smaller bandwidth
Message-ID: <20141118222114.GA11950@kernel>
Reply-To: Wanpeng Li <wanpeng.li@linux.intel.com>
References: <1415868459-7043-1-git-send-email-wanpeng.li@linux.intel.com>
 <546B8934.5040100@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <546B8934.5040100@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Juri,
On Tue, Nov 18, 2014 at 06:00:20PM +0000, Juri Lelli wrote:
>Hi,
>
>On 13/11/14 08:47, Wanpeng Li wrote:
>> Dl class will refuse the bandwidth being set to some value smaller 
>> than the currently allocated bandwidth in any of the root_domains 
>> through sched_rt_runtime_us and sched_rt_period_us. RT runtime will 
>> be set according to sched_rt_runtime_us before dl class verify if 
>> the new bandwidth is suitable in the case of !CONFIG_RT_GROUP_SCHED.
>> 
>> However, rt runtime will be corrupt if dl refuse the new bandwidth 
>> since there is no undo to reset the rt runtime to the old value. 
>> 
>
>Can't we just move sched_dl_global_constraints() before
>sched_rt_global_constraints(), and change the name of the
>former to sched_dl_global_validate() ?

Good idea, I will send out the next version later. ;-)

Regards,
Wanpeng Li

>
>Thanks,
>
>- Juri
>
>> This patch fix it by setting rt runtime after all kinds of rational 
>> checking in the case of !CONFIG_RT_GROUP_SCHED.
>> 
>> Signed-off-by: Wanpeng Li <wanpeng.li@linux.intel.com>
>> ---
>>  kernel/sched/core.c | 30 ++++++++++++++++--------------
>>  1 file changed, 16 insertions(+), 14 deletions(-)
>> 
>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>> index 2e7578a..355dde3 100644
>> --- a/kernel/sched/core.c
>> +++ b/kernel/sched/core.c
>> @@ -7795,20 +7795,7 @@ static int sched_rt_can_attach(struct task_group *tg, struct task_struct *tsk)
>>  #else /* !CONFIG_RT_GROUP_SCHED */
>>  static int sched_rt_global_constraints(void)
>>  {
>> -	unsigned long flags;
>> -	int i, ret = 0;
>> -
>> -	raw_spin_lock_irqsave(&def_rt_bandwidth.rt_runtime_lock, flags);
>> -	for_each_possible_cpu(i) {
>> -		struct rt_rq *rt_rq = &cpu_rq(i)->rt;
>> -
>> -		raw_spin_lock(&rt_rq->rt_runtime_lock);
>> -		rt_rq->rt_runtime = global_rt_runtime();
>> -		raw_spin_unlock(&rt_rq->rt_runtime_lock);
>> -	}
>> -	raw_spin_unlock_irqrestore(&def_rt_bandwidth.rt_runtime_lock, flags);
>> -
>> -	return ret;
>> +	return 0;
>>  }
>>  #endif /* CONFIG_RT_GROUP_SCHED */
>>  
>> @@ -7890,6 +7877,21 @@ static int sched_rt_global_validate(void)
>>  
>>  static void sched_rt_do_global(void)
>>  {
>> +#ifndef CONFIG_RT_GROUP_SCHED
>> +	unsigned long flags;
>> +	int i;
>> +
>> +	raw_spin_lock_irqsave(&def_rt_bandwidth.rt_runtime_lock, flags);
>> +	for_each_possible_cpu(i) {
>> +		struct rt_rq *rt_rq = &cpu_rq(i)->rt;
>> +
>> +		raw_spin_lock(&rt_rq->rt_runtime_lock);
>> +		rt_rq->rt_runtime = global_rt_runtime();
>> +		raw_spin_unlock(&rt_rq->rt_runtime_lock);
>> +	}
>> +	raw_spin_unlock_irqrestore(&def_rt_bandwidth.rt_runtime_lock, flags);
>> +#endif
>> +
>>  	def_rt_bandwidth.rt_runtime = global_rt_runtime();
>>  	def_rt_bandwidth.rt_period = ns_to_ktime(global_rt_period());
>>  }
>> 
