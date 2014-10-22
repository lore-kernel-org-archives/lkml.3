Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932734AbaJVJeB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 05:34:01 -0400
Received: from service87.mimecast.com ([91.220.42.44]:51367 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932450AbaJVJdu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 05:33:50 -0400
Message-ID: <544779FB.8000005@arm.com>
Date: Wed, 22 Oct 2014 10:33:47 +0100
From: Juri Lelli <juri.lelli@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Kirill Tkhai <ktkhai@parallels.com>
CC: Peter Zijlstra <peterz@infradead.org>, Kirill Tkhai <tkhai@yandex.ru>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@gmail.com>
Subject: Re: [PATCH v2 2/3] sched/dl: Cleanup prio_changed_dl()
References: <20140930210412.5258.35299.stgit@localhost>		 <20140930210428.5258.32223.stgit@localhost>		 <20141002093600.GC2849@worktop.programming.kicks-ass.net>	 <1412243541.20287.28.camel@tkhai> <544688A1.7010403@arm.com> <1413909224.19914.126.camel@tkhai>
In-Reply-To: <1413909224.19914.126.camel@tkhai>
X-OriginalArrivalTime: 22 Oct 2014 09:33:46.0090 (UTC) FILETIME=[46F1B4A0:01CFEDDB]
X-MC-Unique: 114102210334806301
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/10/14 17:33, Kirill Tkhai wrote:
> В Вт, 21/10/2014 в 17:24 +0100, Juri Lelli пишет:
>> Hi Kirill,
>>
>> On 02/10/14 10:52, Kirill Tkhai wrote:
>>> В Чт, 02/10/2014 в 11:36 +0200, Peter Zijlstra пишет:
>>>> On Wed, Oct 01, 2014 at 01:04:35AM +0400, Kirill Tkhai wrote:
>>>>> From: Kirill Tkhai <ktkhai@parallels.com>
>>>>>
>>>>> rq->curr task can't be in "dequeued" state in prio_changed_dl().
>>>>> (The only place we can have that is __schedule()). So, we delete
>>>>> rq->curr check.
>>>>
>>>> the CBS timer can throttle it right?
>>>
>>> Yeah, it's better to check for on_dl_rq():
>>>
>>> [PATCH]sched/dl: Cleanup prio_changed_dl()
>>>     
>>> rq->curr task can't be in "dequeued" state in prio_changed_dl().
>>> (The only place we can have that is __schedule()). So, we delete
>>> rq->curr check.
>>>
>>> We shouldn't do balancing if deadline task is throttled too.
>>>
>>> Also delete "else" branch which is dead code (switched_to_dl()
>>> is not interested in dequeued tasks and we are not interested
>>> in balancing in this case).
>>>
>>
>> So, I agree that calling switched_to_dl() makes little sense,
>> but don't we have to deal with updates to not running tasks as
>> in rt.c? Something like this maybe?
> 
> Looks good. No objections from me.
>

Ok, thanks Kirill. I'll send out a proper patch soon.

Best,

- Juri

>>
>> From 75ee75a5fd76526baaed3ba8a58f3ff7daa89cd6 Mon Sep 17 00:00:00 2001
>> From: Juri Lelli <juri.lelli@arm.com>
>> Date: Tue, 21 Oct 2014 17:15:15 +0100
>> Subject: [PATCH] sched/deadline: cleanup prio_changed_dl()
>>
>> ---
>>  kernel/sched/deadline.c | 16 +++++++++++++---
>>  1 file changed, 13 insertions(+), 3 deletions(-)
>>
>> diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
>> index 28d6088..1e62e31 100644
>> --- a/kernel/sched/deadline.c
>> +++ b/kernel/sched/deadline.c
>> @@ -1661,7 +1661,10 @@ static void switched_to_dl(struct rq *rq, struct task_struct *p)
>>  static void prio_changed_dl(struct rq *rq, struct task_struct *p,
>>  			    int oldprio)
>>  {
>> -	if (task_on_rq_queued(p) || rq->curr == p) {
>> +	if (!on_dl_rq(&p->dl))
>> +		return;
>> +
>> +	if (rq->curr == p) {
>>  #ifdef CONFIG_SMP
>>  		/*
>>  		 * This might be too much, but unfortunately
>> @@ -1688,8 +1691,15 @@ static void prio_changed_dl(struct rq *rq, struct task_struct *p,
>>  		 */
>>  		resched_curr(rq);
>>  #endif /* CONFIG_SMP */
>> -	} else
>> -		switched_to_dl(rq, p);
>> +	} else {
>> +		/*
>> +		 * This task is not running, so if its deadline is
>> +		 * now more imminent than that of the current running
>> +		 * task then reschedule.
>> +		 */
>> +		if (dl_time_before(p->dl.deadline, rq->curr->dl.deadline))
>> +			resched_curr(rq);
>> +	}
>>  }
>>  
>>  const struct sched_class dl_sched_class = {
> 
> 
> 

