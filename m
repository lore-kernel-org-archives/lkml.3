Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906AbaJWXFE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 19:05:04 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:56051 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718AbaJWXFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 19:05:02 -0400
Message-ID: <54498998.40707@gmail.com>
Date: Fri, 24 Oct 2014 07:04:56 +0800
From: Wanpeng Li <kernellwp@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Juri Lelli <juri.lelli@arm.com>, Kirill Tkhai <ktkhai@parallels.com>,
        Peter Zijlstra <peterz@infradead.org>
CC: Kirill Tkhai <tkhai@yandex.ru>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@gmail.com>
Subject: Re: [PATCH v2 2/3] sched/dl: Cleanup prio_changed_dl()
References: <20140930210412.5258.35299.stgit@localhost>	 <20140930210428.5258.32223.stgit@localhost>	 <20141002093600.GC2849@worktop.programming.kicks-ass.net> <1412243541.20287.28.camel@tkhai> <544688A1.7010403@arm.com>
In-Reply-To: <544688A1.7010403@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

10/22/14, 12:24 AM, Juri Lelli:
> Hi Kirill,
>
> On 02/10/14 10:52, Kirill Tkhai wrote:
>> В Чт, 02/10/2014 в 11:36 +0200, Peter Zijlstra пишет:
>>> On Wed, Oct 01, 2014 at 01:04:35AM +0400, Kirill Tkhai wrote:
>>>> From: Kirill Tkhai <ktkhai@parallels.com>
>>>>
>>>> rq->curr task can't be in "dequeued" state in prio_changed_dl().
>>>> (The only place we can have that is __schedule()). So, we delete
>>>> rq->curr check.
>>> the CBS timer can throttle it right?
>> Yeah, it's better to check for on_dl_rq():
>>
>> [PATCH]sched/dl: Cleanup prio_changed_dl()
>>      
>> rq->curr task can't be in "dequeued" state in prio_changed_dl().
>> (The only place we can have that is __schedule()). So, we delete
>> rq->curr check.
>>
>> We shouldn't do balancing if deadline task is throttled too.
>>
>> Also delete "else" branch which is dead code (switched_to_dl()
>> is not interested in dequeued tasks and we are not interested
>> in balancing in this case).
>>
> So, I agree that calling switched_to_dl() makes little sense,
> but don't we have to deal with updates to not running tasks as
> in rt.c? Something like this maybe?
>
>  From 75ee75a5fd76526baaed3ba8a58f3ff7daa89cd6 Mon Sep 17 00:00:00 2001
> From: Juri Lelli <juri.lelli@arm.com>
> Date: Tue, 21 Oct 2014 17:15:15 +0100
> Subject: [PATCH] sched/deadline: cleanup prio_changed_dl()
>
> ---
>   kernel/sched/deadline.c | 16 +++++++++++++---
>   1 file changed, 13 insertions(+), 3 deletions(-)
>
> diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
> index 28d6088..1e62e31 100644
> --- a/kernel/sched/deadline.c
> +++ b/kernel/sched/deadline.c
> @@ -1661,7 +1661,10 @@ static void switched_to_dl(struct rq *rq, struct task_struct *p)
>   static void prio_changed_dl(struct rq *rq, struct task_struct *p,
>   			    int oldprio)
>   {
> -	if (task_on_rq_queued(p) || rq->curr == p) {
> +	if (!on_dl_rq(&p->dl))

I'm not sure if this should be task_on_rq_queued() check. All 
check_class_changed() callsites dequeue entity if task_on_rq_queued() is 
true which leads to on_dl_rq(&p->dl) always return false.

Regards,
Wanpeng Li

> +		return;
> +
> +	if (rq->curr == p) {
>   #ifdef CONFIG_SMP
>   		/*
>   		 * This might be too much, but unfortunately
> @@ -1688,8 +1691,15 @@ static void prio_changed_dl(struct rq *rq, struct task_struct *p,
>   		 */
>   		resched_curr(rq);
>   #endif /* CONFIG_SMP */
> -	} else
> -		switched_to_dl(rq, p);
> +	} else {
> +		/*
> +		 * This task is not running, so if its deadline is
> +		 * now more imminent than that of the current running
> +		 * task then reschedule.
> +		 */
> +		if (dl_time_before(p->dl.deadline, rq->curr->dl.deadline))
> +			resched_curr(rq);
> +	}
>   }
>   
>   const struct sched_class dl_sched_class = {

