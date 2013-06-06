Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754888Ab3FFCTY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 22:19:24 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:35596 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753347Ab3FFCTW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 22:19:22 -0400
Message-ID: <51AFF19F.4010604@linux.vnet.ibm.com>
Date: Thu, 06 Jun 2013 10:19:11 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Paul Turner <pjt@google.com>
Subject: Re: [PATCH v2 1/3] sched: don't repeat the initialization in sched_init()
References: <51AD87A8.6080608@linux.vnet.ibm.com> <51AD87D0.7020300@linux.vnet.ibm.com> <51AEA152.1050609@linux.vnet.ibm.com> <20130605110657.GZ8923@twins.programming.kicks-ass.net>
In-Reply-To: <20130605110657.GZ8923@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13060602-5816-0000-0000-0000084C28E3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2013 07:06 PM, Peter Zijlstra wrote:
> On Wed, Jun 05, 2013 at 10:24:18AM +0800, Michael Wang wrote:
>> v2:
>> 	Move comments back before init_tg_cfs_entry(). (Thanks for the notify from pjt)
>>
>> In sched_init(), there is no need to initialize 'root_task_group.shares' and
>> 'root_task_group.cfs_bandwidth' repeatedly.
>>
>> CC: Paul Tuner <pjt@google.com>
>> CC: Ingo Molnar <mingo@kernel.org>
>> CC: Peter Zijlstra <peterz@infradead.org>
>> Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
>> ---
>>  kernel/sched/core.c |    7 +++++--
>>  1 files changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>> index 58453b8..96f69da 100644
>> --- a/kernel/sched/core.c
>> +++ b/kernel/sched/core.c
>> @@ -6955,6 +6955,11 @@ void __init sched_init(void)
>>  
>>  #endif /* CONFIG_CGROUP_SCHED */
>>  
>> +#ifdef CONFIG_FAIR_GROUP_SCHED
>> +	root_task_group.shares = ROOT_TASK_GROUP_LOAD;
>> +	init_cfs_bandwidth(&root_task_group.cfs_bandwidth);
>> +#endif
>> +
>>  	for_each_possible_cpu(i) {
>>  		struct rq *rq;
>>  
>> @@ -6966,7 +6971,6 @@ void __init sched_init(void)
>>  		init_cfs_rq(&rq->cfs);
>>  		init_rt_rq(&rq->rt, rq);
>>  #ifdef CONFIG_FAIR_GROUP_SCHED
>> -		root_task_group.shares = ROOT_TASK_GROUP_LOAD;
>>  		INIT_LIST_HEAD(&rq->leaf_cfs_rq_list);
>>  		/*
>>  		 * How much cpu bandwidth does root_task_group get?
>> @@ -6987,7 +6991,6 @@ void __init sched_init(void)
>>  		 * We achieve this by letting root_task_group's tasks sit
>>  		 * directly in rq->cfs (i.e root_task_group->se[] = NULL).
>>  		 */
>> -		init_cfs_bandwidth(&root_task_group.cfs_bandwidth);
>>  		init_tg_cfs_entry(&root_task_group, &rq->cfs, NULL, i, NULL);
>>  #endif /* CONFIG_FAIR_GROUP_SCHED */
> 
> I would actually like a patch reducing the #ifdef forest there, not
> adding to it.

I see :)

> 
> There's no actual harm in doing the initialization mutliple times,
> right?

Yeah, it's safe to redo the init, cost some cycles but not so expensive.

Regards,
Michael Wang

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

