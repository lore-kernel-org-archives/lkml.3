Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757212AbaJIO3a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 10:29:30 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:58983 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752189AbaJIO3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 10:29:24 -0400
MIME-Version: 1.0
In-Reply-To: <20141009141607.GR4750@worktop.programming.kicks-ass.net>
References: <1412684017-16595-1-git-send-email-vincent.guittot@linaro.org>
 <1412684017-16595-7-git-send-email-vincent.guittot@linaro.org> <20141009141607.GR4750@worktop.programming.kicks-ass.net>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Thu, 9 Oct 2014 16:28:58 +0200
Message-ID: <CAKfTPtAGq=zBHNeXZjijM0BxD7g+DYr53CDsF9Cyen1T0FbAMQ@mail.gmail.com>
Subject: Re: [PATCH v7 6/7] sched: replace capacity_factor by usage
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Rik van Riel <riel@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Paul Turner <pjt@google.com>, Benjamin Segall <bsegall@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 October 2014 16:16, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, Oct 07, 2014 at 02:13:36PM +0200, Vincent Guittot wrote:
>> @@ -6214,17 +6178,21 @@ static inline void update_sd_lb_stats(struct lb_env *env, struct sd_lb_stats *sd
>>
>>               /*
>>                * In case the child domain prefers tasks go to siblings
>> +              * first, lower the sg capacity to one so that we'll try
>>                * and move all the excess tasks away. We lower the capacity
>>                * of a group only if the local group has the capacity to fit
>> +              * these excess tasks, i.e. group_capacity > 0. The
>>                * extra check prevents the case where you always pull from the
>>                * heaviest group when it is already under-utilized (possible
>>                * with a large weight task outweighs the tasks on the system).
>>                */
>>               if (prefer_sibling && sds->local &&
>> +                 group_has_capacity(env, &sds->local_stat)) {
>> +                     if (sgs->sum_nr_running > 1)
>> +                             sgs->group_no_capacity = 1;
>> +                     sgs->group_capacity = min(sgs->group_capacity,
>> +                                             SCHED_CAPACITY_SCALE);
>> +             }
>>
>>               if (update_sd_pick_busiest(env, sds, sg, sgs)) {
>>                       sds->busiest = sg;
>
>> @@ -6490,8 +6460,8 @@ static struct sched_group *find_busiest_group(struct lb_env *env)
>>               goto force_balance;
>>
>>       /* SD_BALANCE_NEWIDLE trumps SMP nice when underutilized */
>> -     if (env->idle == CPU_NEWLY_IDLE && local->group_has_free_capacity &&
>> -         !busiest->group_has_free_capacity)
>> +     if (env->idle == CPU_NEWLY_IDLE && group_has_capacity(env, local) &&
>> +         busiest->group_no_capacity)
>>               goto force_balance;
>>
>>       /*
>
> This is two calls to group_has_capacity() on the local group. Why not
> compute once in update_sd_lb_stats()?

mainly because of the place in the code, so it is not always used
during load balance unlike group_no_capacity

Now that i have said that, i just noticed that it's better to move the
call to the last tested condition

 +     if (env->idle == CPU_NEWLY_IDLE && busiest->group_no_capacity &&
 +         group_has_capacity(env, local))
