Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087AbaIADCZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 23:02:25 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:31472 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751668AbaIADCY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 23:02:24 -0400
X-IronPort-AV: E=Sophos;i="5.04,439,1406563200"; 
   d="scan'208";a="35319825"
Message-ID: <5403E237.2000708@cn.fujitsu.com>
Date: Mon, 1 Sep 2014 11:04:23 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: <jjherne@linux.vnet.ibm.com>, Sasha Levin <sasha.levin@oracle.com>,
        "Tejun Heo" <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: workqueue: WARN at at kernel/workqueue.c:2176
References: <53849EB7.9090302@linux.vnet.ibm.com> <20140527142637.GB19143@laptop.programming.kicks-ass.net> <53875F09.3090607@linux.vnet.ibm.com> <538DB076.4090704@cn.fujitsu.com> <20140603141659.GO30445@twins.programming.kicks-ass.net> <538E840D.2040300@cn.fujitsu.com> <20140604064946.GF30445@twins.programming.kicks-ass.net> <538ED7EB.5050303@cn.fujitsu.com> <20140604093907.GC11096@twins.programming.kicks-ass.net> <53904C6B.90001@cn.fujitsu.com> <20140606133629.GP13930@laptop.programming.kicks-ass.net>
In-Reply-To: <20140606133629.GP13930@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Peter

Could you make a patch for it, please? Jason J. Herne's test showed we
addressed the bug.  But the fix is not in kernel yet.  Some new highly
related reports are come up again.

I don't want to argue any more, no matter how the patch will be,
I will accept.  And please add the following tags in your patch:

Reported-by: Sasha Levin <sasha.levin@oracle.com>
Reported-by: Jason J. Herne <jjherne@linux.vnet.ibm.com>
Tested-by: Jason J. Herne <jjherne@linux.vnet.ibm.com>
Acked-by: Lai Jiangshan <laijs@cn.fujitsu.com>


Thanks,
Lai

On 06/06/2014 09:36 PM, Peter Zijlstra wrote:
> On Thu, Jun 05, 2014 at 06:54:35PM +0800, Lai Jiangshan wrote:
>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>> index 268a45e..d05a5a1 100644
>> --- a/kernel/sched/core.c
>> +++ b/kernel/sched/core.c
>> @@ -1474,20 +1474,24 @@ static int ttwu_remote(struct task_struct *p, int wake_flags)
>>  }
>>  
>>  #ifdef CONFIG_SMP
>> -static void sched_ttwu_pending(void)
>> +static void sched_ttwu_pending_locked(struct rq *rq)
>>  {
>> -	struct rq *rq = this_rq();
>>  	struct llist_node *llist = llist_del_all(&rq->wake_list);
>>  	struct task_struct *p;
>>  
>> -	raw_spin_lock(&rq->lock);
>> -
>>  	while (llist) {
>>  		p = llist_entry(llist, struct task_struct, wake_entry);
>>  		llist = llist_next(llist);
>>  		ttwu_do_activate(rq, p, 0);
>>  	}
>> +}
>>  
>> +static void sched_ttwu_pending(void)
>> +{
>> +	struct rq *rq = this_rq();
>> +
>> +	raw_spin_lock(&rq->lock);
>> +	sched_ttwu_pending_locked(rq);
>>  	raw_spin_unlock(&rq->lock);
>>  }
> 
> OK, so this won't apply to a recent kernel.
> 
>> @@ -4530,6 +4534,11 @@ int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask)
>>  		goto out;
>>  
>>  	dest_cpu = cpumask_any_and(cpu_active_mask, new_mask);
>> +
>> +	/* Ensure it is on rq for migration if it is waking */
>> +	if (p->state == TASK_WAKING)
>> +		sched_ttwu_pending_locked(rq);
> 
> So I would really rather like to avoid this if possible, its doing full
> remote queueing, exactly what we tried to avoid.
> 
>> +
>>  	if (p->on_rq) {
>>  		struct migration_arg arg = { p, dest_cpu };
>>  		/* Need help from migration thread: drop lock and wait. */
>> @@ -4576,6 +4585,10 @@ static int __migrate_task(struct task_struct *p, int src_cpu, int dest_cpu)
>>  	if (!cpumask_test_cpu(dest_cpu, tsk_cpus_allowed(p)))
>>  		goto fail;
>>  
>> +	/* Ensure it is on rq for migration if it is waking */
>> +	if (p->state == TASK_WAKING)
>> +		sched_ttwu_pending_locked(rq_src);
>> +
>>  	/*
>>  	 * If we're not on a rq, the next wake-up will ensure we're
>>  	 * placed properly.
> 
> Oh man, another variant.. why did you change it again? And without
> explanation for why you changed it.
> 
> I don't see a reason to call sched_ttwu_pending() with rq->lock held,
> seeing as how we append to that list without it held.
> 
> I'm still thinking the previous version is good, can you explain why you
> changed it?
> 
> 
> 
> 
> 
> 
> .
> 

