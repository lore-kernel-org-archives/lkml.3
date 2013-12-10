Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755798Ab3LJSbH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 13:31:07 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:63035 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752710Ab3LJSbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 13:31:04 -0500
Message-ID: <52A75DE6.8090901@linaro.org>
Date: Tue, 10 Dec 2013 19:31:02 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Mike Galbraith <bitbucket@online.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Alex Shi <alex.shi@linaro.org>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [question] sched: idle_avg and migration latency
References: <52A6FB5C.7010706@linaro.org> <1386688302.6304.30.camel@marge.simpson.net>
In-Reply-To: <1386688302.6304.30.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2013 04:11 PM, Mike Galbraith wrote:
> On Tue, 2013-12-10 at 12:30 +0100, Daniel Lezcano wrote:
>> Hi All,
>>
>> I am trying to understand how is computed the idle_avg and how it is
>> used regarding the migration latency.
>>
>> 1. What is the sysctl_sched_migration_cost value ? It is initialized to
>> 500000UL. Is it an arbitrarily chosen value ? Could it change depending
>> on the hardware performances ?
>
> Yeah, it's a magic number.  We used to use boot time measurements.
>
>> 2. The idle_balance function checks:
>>
>>           if (this_rq->avg_idle < sysctl_sched_migration_cost)
>>                   return 0;
>>
>> IIUC, it is not worth to migrate a task to this cpu as we expect to run
>> another task before we can pull a task to the current cpu, right ?
>
> No, that's all about not beating living hell outta ourselves on every
> micro-idle.  As with all load balancing, it's usually too much balancing
> that creates a problem.  You need it, but it's really expensive, so less
> is more.
>
>> Then if there is no task to balance we will enter idle, thus we
>> initialize the idle_stamp to the current clock.
>>
>> When another task is woken up with the ttwu_do_wakeup, the duration of
>> the idle time is computed in there:
>>
>> 	if (rq->idle_stamp) {
>> 		u64 delta = rq_clock(rq) - rq->idle_stamp;
>> 		u64 max = 2*sysctl_sched_migration_cost;
>>
>> 		if (delta > max)
>> 			rq->avg_idle = max;
>> 		else
>> 			update_avg(&rq->avg_idle, delta);
>> 		rq->idle_stamp = 0;
>> 	}
>>
>> Why is the 'delta' leveraged by 'max' ?
>
> That has changed a little recently.  I originally slammed avg_idle
> itself straight to max to ensure that a bursty load would idle balance,
> and not use stale data.  If you start cross core switching at high
> frequency, you'll still shut idle balancing quickly.

Ok, thanks for the explanation.

I think I am a bit puzzled with the 'idle_avg' name. I am guessing the 
semantic of this variable is "how long this cpu has been idle".

The idle duration, with the no_hz, could be long, several seconds if the 
work queues have been migrated and if the timer affinity is set to 
another cpu. So if we fall in this case and there is a burst of activity 
+ micro-idle and idle_avg is not leverage to max, it will stay high 
during an amount of time, thus pulling tasks at each micro idle period, 
right ?

>> 3. And finally the function update_avg does:
>>
>> 	s64 diff = sample - *avg;
>> 	*avg += diff >> 3;
>>
>> Why is diff >> 3 used instead of the number of values ?
>
> Ingo's quick like bunny smooth average.

Yeah, average computation on-the-fly. But why 'divide by 8' ? (Cc'ed Ingo).

Thanks for taking the time to answer.

   -- Daniel

-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

