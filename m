Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751296AbaJAHCk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 03:02:40 -0400
Received: from mail-oi0-f46.google.com ([209.85.218.46]:32826 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074AbaJAHCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 03:02:39 -0400
MIME-Version: 1.0
In-Reply-To: <20140930184129.GM4241@worktop.programming.kicks-ass.net>
References: <1412066468-4340-1-git-send-email-vincent.guittot@linaro.org> <20140930184129.GM4241@worktop.programming.kicks-ass.net>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Wed, 1 Oct 2014 09:02:18 +0200
Message-ID: <CAKfTPtCHAAFW+TCDL4X-fX3ZHjTb-Ybonb0d8W0P+AmO9YNwMg@mail.gmail.com>
Subject: Re: [PATCH] sched: fix spurious active migration
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, Rik van Riel <riel@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30 September 2014 20:41, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, Sep 30, 2014 at 10:41:08AM +0200, Vincent Guittot wrote:
>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> index 2a1e6ac..adad532 100644
>> --- a/kernel/sched/fair.c
>> +++ b/kernel/sched/fair.c
>> @@ -6425,13 +6425,14 @@ static struct sched_group *find_busiest_group(struct lb_env *env)
>>
>>       if (env->idle == CPU_IDLE) {
>>               /*
>> -              * This cpu is idle. If the busiest group load doesn't
>> -              * have more tasks than the number of available cpu's and
>> -              * there is no imbalance between this and busiest group
>> -              * wrt to idle cpu's, it is balanced.
>> +              * This cpu is idle. If the busiest group is not overloaded
>> +              * and there is no imbalance between this and busiest group
>> +              * wrt to idle cpus, it is balanced. The imbalance becomes
>> +              * significant if the diff is greater than 1 otherwise we
>> +              * might end up to just move the imbalance on another group
>>                */
>> -             if ((local->idle_cpus < busiest->idle_cpus) &&
>> -                 busiest->sum_nr_running <= busiest->group_weight)
>> +             if ((local->idle_cpus <= (busiest->idle_cpus + 1)) &&
>
> So I'm thick and I don't get this one.. In fact I don't seem to
> understand the existing code either.

My understand of the original code is that if a group is overloaded
(wrt capacity_factor) but has less tasks than CPUs (so overloaded
because of rt) and the local group has more idle CPUs then it's worth
balancing tasks and load.

I have changed it into : if the busiest group is overloaded or the
local has more than 1 idle CPU than the busiest, it makes sense to try
to balance tasks in order to balance the avg_load of the groups. But
if the local group has only 1 more idle CPU than the busiest, it's
probably not possible to leverage the average load load of the groups.
We will only move the imbalance from 1 group to another one

>
> If we're idle, and busiest is overloaded, we want to have tasks. Why
> would we care about number of idle cpus etc..
>
>> +                 !(busiest->group_type == group_overloaded))
>
> Would not: busiest->group_type != group_overloaded, read more natural?
> Also, would it make sense to make this the first condition?

that's fair for both remark

>
>>                       goto out_balanced;
>>       } else {
>
>
