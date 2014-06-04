Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753973AbaFDBnX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 21:43:23 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:50115 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753902AbaFDBnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 21:43:22 -0400
X-IronPort-AV: E=Sophos;i="4.98,969,1392134400"; 
   d="scan'208";a="31413651"
Message-ID: <538E7ACB.3010704@cn.fujitsu.com>
Date: Wed, 4 Jun 2014 09:47:55 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: <jjherne@linux.vnet.ibm.com>, Sasha Levin <sasha.levin@oracle.com>,
        Tejun Heo <tj@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: workqueue: WARN at at kernel/workqueue.c:2176
References: <53739F3B.4060608@linux.vnet.ibm.com> <53758B12.8060609@cn.fujitsu.com> <20140516115737.GP11096@twins.programming.kicks-ass.net> <CACvQF52-jUMzK32uoDCb8zn0RZsiC9uzUOq+ZBRXK22esYKS0g@mail.gmail.com> <20140516162945.GZ11096@twins.programming.kicks-ass.net> <53849EB7.9090302@linux.vnet.ibm.com> <20140527142637.GB19143@laptop.programming.kicks-ass.net> <53875F09.3090607@linux.vnet.ibm.com> <538DB076.4090704@cn.fujitsu.com> <538DC373.9@cn.fujitsu.com> <20140603142845.GP30445@twins.programming.kicks-ass.net>
In-Reply-To: <20140603142845.GP30445@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/03/2014 10:28 PM, Peter Zijlstra wrote:
> On Tue, Jun 03, 2014 at 08:45:39PM +0800, Lai Jiangshan wrote:
>>
>> Hi, Peter,
>>
>> I rewrote the analyse. (scheduler_ipi() must be called before stopper-task,
>> so the part for workqueue of the old analyse maybe be wrong.)
> 
> But I don't think there is any guarantee we'll do the wakeup before
> running the stop work.

You are right, but the race window in my old analyse is too narrow to
hit the WARN_ON(). so I rewrote the new analyse showing a much bigger window
which can hit the WARN_ON() in workqueue.c

> 
> Suppose the initial task gets queued, and the thing gets send the
> interrupt, meanwhile we'll do the stopper work wakeup !queueing, the
> set_cpus_allowed_ptr() isn't crossing llc boundaries.
> 
> Now, the remote cpu preempts/schedules before the interrupt hits and
> runs the stop task.
> 
> At which point we'll run __migrate_task() while the task is still queued
> on the wake list.
> 
>> ---
>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>> index 268a45e..1a198a5 100644
>> --- a/kernel/sched/core.c
>> +++ b/kernel/sched/core.c
>> @@ -4530,7 +4530,7 @@ int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask)
>>  		goto out;
>>  
>>  	dest_cpu = cpumask_any_and(cpu_active_mask, new_mask);
>> -	if (p->on_rq) {
>> +	if (p->on_rq || p->state == TASK_WAKING) {
>>  		struct migration_arg arg = { p, dest_cpu };
>>  		/* Need help from migration thread: drop lock and wait. */
>>  		task_rq_unlock(rq, p, &flags);
> 
> So while this will close the window somewhat, I don't think its entirely
> closed.

