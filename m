Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153AbaAWOji (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 09:39:38 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:61211 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225AbaAWOjh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 09:39:37 -0500
Message-ID: <52E129A8.5050503@linaro.org>
Date: Thu, 23 Jan 2014 15:39:36 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
CC: mingo@kernel.org, pjt@google.com, bsegall@google.com,
        Jason Low <jason.low2@hp.com>
Subject: Re: [PATCH 3/9] sched: Move idle_stamp up to the core
References: <20140121111754.580142558@infradead.org> <20140121112258.410353740@infradead.org> <20140123125822.GX31570@twins.programming.kicks-ass.net>
In-Reply-To: <20140123125822.GX31570@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2014 01:58 PM, Peter Zijlstra wrote:
> On Tue, Jan 21, 2014 at 12:17:57PM +0100, Peter Zijlstra wrote:
>> From: Daniel Lezcano <daniel.lezcano@linaro.org>
>>
>> The idle_balance modifies the idle_stamp field of the rq, making this
>> information to be shared across core.c and fair.c. As we can know if the
>> cpu is going to idle or not with the previous patch, let's encapsulate the
>> idle_stamp information in core.c by moving it up to the caller. The
>> idle_balance function returns true in case a balancing occured and the cpu
>> won't be idle, false if no balance happened and the cpu is going idle.
>>
>> Cc: alex.shi@linaro.org
>> Cc: peterz@infradead.org
>> Cc: mingo@kernel.org
>> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
>> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
>> Link: http://lkml.kernel.org/r/1389949444-14821-3-git-send-email-daniel.lezcano@linaro.org
>> ---
>>   kernel/sched/core.c  |    2 +-
>>   kernel/sched/fair.c  |   14 ++++++--------
>>   kernel/sched/sched.h |    2 +-
>>   3 files changed, 8 insertions(+), 10 deletions(-)
>>
>> --- a/kernel/sched/core.c
>> +++ b/kernel/sched/core.c
>> @@ -2680,7 +2680,7 @@ static void __sched __schedule(void)
>>   	pre_schedule(rq, prev);
>>
>>   	if (unlikely(!rq->nr_running))
>> -		idle_balance(rq);
>> +		rq->idle_stamp = idle_balance(rq) ? 0 : rq_clock(rq);
>
> OK, spotted a problem here..
>
> So previously idle_stamp was set _before_ actually doing idle_balance(),
> and that was RIGHT, because that way we include the cost of actually
> doing idle_balance() into the idle time.
>
> By not including the cost of idle_balance() you underestimate the 'idle'
> time in that if idle_balance() filled the entire idle time we account 0
> idle, even though we had 'plenty' of time to run the entire thing.
>
> This leads to not running idle_balance() even though we have the time
> for it.

Good catch. How did you notice that ?

> So we very much want something like:
>
>
>    if (!rq->nr_running)
>    	rq->idle_stamp = rq_clock(rq);
>
>    p = pick_next_task(rq, prev);
>
>    if (!is_idle_task(p))
>    	rq->idle_stamp = 0;

Is this code assuming idle_balance() is in pick_next_task ?

For this specific patch 3/9, will be ok the following ?

+       if (unlikely(!rq->nr_running)) {
+               rq->idle_stamp = rq_clock(rq);
+               if (idle_balance(rq))
+                       rq->idle_stamp = 0;
+       }

So the patch 9/9 is wrong also because it does not fill idle_stamp 
before idle_balance, the fix would be.

  kernel/sched/core.c |    8 +++++---
  1 file changed, 5 insertions(+), 3 deletions(-)

Index: cpuidle-next/kernel/sched/core.c
===================================================================
--- cpuidle-next.orig/kernel/sched/core.c
+++ cpuidle-next/kernel/sched/core.c
@@ -2579,15 +2579,17 @@ again:
  		}
  	}

+	rq->idle_stamp = rq_clock(rq);
+
  	/*
  	 * If there is a task balanced on this cpu, pick the next task,
  	 * otherwise fall in the optimization by picking the idle task
  	 * directly.
  	 */
-	if (idle_balance(rq))
+	if (idle_balance(rq)) {
+		rq->idle_stamp = 0;
  		goto again;
-
-	rq->idle_stamp = rq_clock(rq);
+	}

  	return idle_sched_class.pick_next_task(rq, prev);
  }


> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

