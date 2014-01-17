Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456AbaAQPGu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 10:06:50 -0500
Received: from mail-we0-f177.google.com ([74.125.82.177]:44868 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918AbaAQPGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 10:06:48 -0500
Message-ID: <52D94705.1000407@linaro.org>
Date: Fri, 17 Jan 2014 16:06:45 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@kernel.org, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, alex.shi@linaro.org
Subject: Re: [PATCH 4/4] sched: Idle task shortcut optimization
References: <1389949444-14821-1-git-send-email-daniel.lezcano@linaro.org> <1389949444-14821-4-git-send-email-daniel.lezcano@linaro.org> <20140117142644.GI11314@laptop.programming.kicks-ass.net>
In-Reply-To: <20140117142644.GI11314@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2014 03:26 PM, Peter Zijlstra wrote:
> On Fri, Jan 17, 2014 at 10:04:04AM +0100, Daniel Lezcano wrote:
>> @@ -2679,11 +2715,8 @@ need_resched:
>>
>>   	pre_schedule(rq, prev);
>>
>> -	if (unlikely(!rq->nr_running))
>> -		rq->idle_stamp = idle_balance(rq) ? 0 : rq_clock(rq);
>> -
>>   	put_prev_task(rq, prev);
>> -	next = pick_next_task(rq);
>> +	next = pick_next_task_or_idle(rq);
>>   	clear_tsk_need_resched(prev);
>>   	clear_preempt_need_resched();
>>   	rq->skip_clock_update = 0;
>
> I have vague memories that we need to have idle_balance() before
> put_prev_task(), but I can't recollect why this would be so.
>
> That said, if I resurrect these patches:
>
>    https://lkml.org/lkml/2012/6/14/271
>
> I suppose we could write something like:
>
> struct task_struct *pick_next_task(struct rq *rq, struct task_struct *prev)
> {
> 	const struct sched_class *class;
> 	struct task_struct *p;
>
> again:
> 	if (likely(rq->nr_running)) {
>
> 		if (likely(rq->nr_running == rq->cfs.h_nr_running))
> 			return fair_sched_class.pick_next_task(rq, prev);
>
> 		for_each_class(class) {
> 			p = class->pick_next_task(rq, prev);
> 			if (p)
> 				return p;
> 		}
> 	}
>
> 	if (idle_balance(rq))
> 		goto again;
>
> 	rq->idle_stamp = rq_clock(rq);
>
> 	return idle_sched_class.pick_next_task(rq, prev);
> }
>
> Which keeps idle_balance() before put_prev_task(), and by using
> idle_sched_clas.pick_next_task() doesn't rape the idle class interface
> like you did :-)

But put_prev_task is called before pick_next_task, so idle_balance() is 
called after now, no  ?


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

