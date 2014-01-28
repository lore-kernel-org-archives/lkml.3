Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754732AbaA1Ki1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 05:38:27 -0500
Received: from mail-wg0-f51.google.com ([74.125.82.51]:48662 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbaA1KiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 05:38:25 -0500
Message-ID: <52E7889E.9030706@gmail.com>
Date: Tue, 28 Jan 2014 11:38:22 +0100
From: Juri Lelli <juri.lelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Kirill Tkhai <ktkhai@parallels.com>, linux-kernel@vger.kernel.org
CC: peterz@infradead.org, mingo@kernel.org, devel@openvz.org
Subject: Re: [PATCH v2 -tip] sched/deadline: switched_to_dl() -- skip if task
 is current
References: <20140128072421.32315.25300.stgit@tkhai>
In-Reply-To: <20140128072421.32315.25300.stgit@tkhai>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/28/2014 08:26 AM, Kirill Tkhai wrote:
> v2: Changed comment
> 
> When p is current and it's not of dl class, then there are no other
> dl taks in the rq. If we had had pushable tasks in some other rq,
       ^ tasks

> they would have been pushed earlier. So, skip "p == rq->curr" case.
> 
> [This is confirmed by Juri Lelli and LKML was CC'ed, but
>  unfotunately I can't find direct link on lkml.org]
> 

This was the story:

> On 01/08/2014 10:00 AM, Juri Lelli wrote:
>> On 12/18/2013 04:00 PM, Kirill Tkhai wrote:
>>> 17.12.2013, 16:48, "Peter Zijlstra" <peterz@infradead.org>:
>>> From: Dario Faggioli <raistlin@linux.it>
>>>
>>> Introduces the data structures, constants and symbols needed for
>>> SCHED_DEADLINE implementation.
>>
>> [snipped]
>>
>>> +static void switched_to_dl(struct rq *rq, struct task_struct *p)
>>> +{
>>> +	/*
>>> +	 * If p is throttled, don't consider the possibility
>>> +	 * of preempting rq->curr, the check will be done right
>>> +	 * after its runtime will get replenished.
>>> +	 */
>>> +	if (unlikely(p->dl.dl_throttled))
>>> +		return;
>>> +
>>> +	if (!p->on_rq || rq->curr != p) {
>>> +		if (task_has_dl_policy(rq->curr))
>>> +			check_preempt_curr_dl(rq, p, 0);
>>> +		else
>>> +			resched_task(rq->curr);
>>> +	}
>>> +}
>>
>> The second if() looks a little strange. Why is "!p->on_rq ||" here? RT class
>> has another logic.
>>
>
> You are right, good catch! :)
>
> This has to be changed in
>
>   if (p->on_rq && rq->curr != p)
>
> as in RT.
>
> Thanks,
>
> - Juri

> Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
> CC: Juri Lelli <juri.lelli@gmail.com>
> CC: Peter Zijlstra <peterz@infradead.org>
> CC: Ingo Molnar <mingo@kernel.org>
> ---
>  kernel/sched/deadline.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
> index 0de2482..dd19d6d 100644
> --- a/kernel/sched/deadline.c
> +++ b/kernel/sched/deadline.c
> @@ -1559,7 +1559,7 @@ static void switched_to_dl(struct rq *rq, struct task_struct *p)
>  	if (unlikely(p->dl.dl_throttled))
>  		return;
>  
> -	if (p->on_rq || rq->curr != p) {
> +	if (p->on_rq && rq->curr != p) {
>  #ifdef CONFIG_SMP
>  		if (rq->dl.overloaded && push_dl_task(rq) && rq != task_rq(p))
>  			/* Only reschedule if pushing failed */
> 

So the patch looks good. Not sure about the changelog, though :).

Thanks,

- Juri
