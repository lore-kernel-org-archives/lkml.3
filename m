Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404Ab3IZCuZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 22:50:25 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:49424 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283Ab3IZCuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 22:50:24 -0400
Message-ID: <5243A0E9.4060802@linux.vnet.ibm.com>
Date: Thu, 26 Sep 2013 10:50:17 +0800
From: Michael wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Mike Galbraith <bitbucket@online.de>,
        Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, Paul Turner <pjt@google.com>,
        Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] sched: Avoid select_idle_sibling() for wake_affine(.sync=true)
References: <20130925075341.GB3081@twins.programming.kicks-ass.net> <1380099377.8523.9.camel@marge.simpson.net>
In-Reply-To: <1380099377.8523.9.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092602-5816-0000-0000-00000A14E873
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2013 04:56 PM, Mike Galbraith wrote:
> On Wed, 2013-09-25 at 09:53 +0200, Peter Zijlstra wrote: 
>> Subject: sched: Avoid select_idle_sibling() for wake_affine(.sync=true)
>> From: Peter Zijlstra <peterz@infradead.org>
>> Date: Wed Sep 25 08:28:39 CEST 2013
>>
>> When a task is the only running task and does a sync wakeup; avoid
>> going through select_idle_sibling() as it doesn't know the current CPU
>> is going to be idle shortly.
>>
>> Without this two sync wakers will ping-pong between CPUs for no
>> reason.
> 
> That will make pipe-test go fugly -> pretty, and help very fast/light
> localhost network, but eat heavier localhost overlap recovery.  We need
> a working (and cheap) overlap detector scheme, so we can know when there
> is enough to be worth going after.
> 
> (I sent you some lmbench numbers offline a while back showing the
> two-faced little <b-word> in action, doing both good and evil)

It seems like the choice between the overhead and a little possibility
to balance the load :)

Like the case when we have:

	core0 sg		core1 sg
	cpu0	cpu1		cpu2	cpu3
	waker	busy		idle	idle

If the sync wakeup was on cpu0, we can:

1. choose cpu in core1 sg like we did usually
   some overhead but tend to make the load a little balance
	core0 sg		core1 sg
	cpu0	cpu1		cpu2	cpu3
	idle	busy		wakee	idle

2. choose cpu0 like the patch proposed
   no overhead but tend to make the load a little more unbalance
	core0 sg		core1 sg
	cpu0	cpu1		cpu2	cpu3
	wakee	busy		idle	idle

May be we should add a higher scope load balance check in wake_affine(),
but that means higher overhead which is just what the patch want to
reduce...

What about some discount for sync case inside select_idle_sibling()?
For example we consider sync cpu as idle and prefer it more than the others?

Regards,
Michael Wang


>> Suggested-by: Rik van Riel <riel@redhat.com>
>> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
>> ---
>>  kernel/sched/fair.c |   10 ++++++++++
>>  1 file changed, 10 insertions(+)
>>
>> --- a/kernel/sched/fair.c
>> +++ b/kernel/sched/fair.c
>> @@ -3461,6 +3461,16 @@ select_task_rq_fair(struct task_struct *
>>  		if (cpu != prev_cpu && wake_affine(affine_sd, p, sync))
>>  			prev_cpu = cpu;
>>  
>> +		/*
>> +		 * Don't bother with select_idle_sibling() in the case of a sync wakeup
>> +		 * where we know the only running task will soon go away. Going
>> +		 * through select_idle_sibling will only lead to pointless ping-pong.
>> +		 */
>> +		if (sync && prev_cpu == cpu && cpu_rq(cpu)->nr_running == 1) {
>> +			new_cpu = cpu;
>> +			goto unlock;
>> +		}
>> +
>>  		new_cpu = select_idle_sibling(p, prev_cpu);
>>  		goto unlock;
>>  	}
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

