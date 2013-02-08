Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946462Ab3BHPF5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 10:05:57 -0500
Received: from mail-bk0-f50.google.com ([209.85.214.50]:48330 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759956Ab3BHPF4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 10:05:56 -0500
MIME-Version: 1.0
In-Reply-To: <1360334778.2621.106.camel@gandalf.local.home>
References: <1360321887-18251-1-git-send-email-vincent.guittot@linaro.org>
	<1360334778.2621.106.camel@gandalf.local.home>
Date: Fri, 8 Feb 2013 16:05:54 +0100
Message-ID: <CAKfTPtB3u6yFj_mKY4OMRuX9SuRcSWC0e8DzyMp3BVBDymAb0w@mail.gmail.com>
Subject: Re: [PATCH] sched: fix wrong rq's runnable_avg update with rt task
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        peterz@infradead.org, mingo@kernel.org, pjt@google.com,
        fweisbec@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 February 2013 15:46, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Fri, 2013-02-08 at 12:11 +0100, Vincent Guittot wrote:
>> When a RT task is scheduled on an idle CPU, the update of the rq's load is
>> not done because CFS's functions are not called. Then, the idle_balance,
>> which is called just before entering the idle function, updates the
>> rq's load and makes the assumption that the elapsed time since the last
>> update, was only running time.
>>
>> The rq's load of a CPU that only runs a periodic RT task, is close to
>> LOAD_AVG_MAX whatever the running duration of the RT task is.
>>
>> A new idle_exit function is called when the prev task is the idle function
>> so the elapsed time will be accounted as idle time in the rq's load.
>>
>> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
>> ---
>>  kernel/sched/core.c  |    3 +++
>>  kernel/sched/fair.c  |   10 ++++++++++
>>  kernel/sched/sched.h |    5 +++++
>>  3 files changed, 18 insertions(+)
>>
>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>> index 26058d0..592e06c 100644
>> --- a/kernel/sched/core.c
>> +++ b/kernel/sched/core.c
>> @@ -2927,6 +2927,9 @@ need_resched:
>>
>>       pre_schedule(rq, prev);
>>
>> +     if (unlikely(prev == rq->idle))
>> +             idle_exit(cpu, rq);
>> +
>
> Let's get rid of the added junk in the core code that should be isolated
> in the idle code.
>

i agree

> I posted these patches before, and I'm about to post again:
>
> https://lkml.org/lkml/2012/12/21/378
> https://lkml.org/lkml/2012/12/21/377
>
> I'm working to clean these patches up today and post them again. Would
> working on top of these work for you?

yes for sure.
I will move that code in pre_schedule

Vincent

>
> -- Steve
>
>
>>       if (unlikely(!rq->nr_running))
>>               idle_balance(cpu, rq);
>>
>
>
