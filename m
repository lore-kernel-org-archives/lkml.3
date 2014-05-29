Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932785AbaE2T4q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 15:56:46 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:49696 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755215AbaE2T4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 15:56:45 -0400
MIME-Version: 1.0
In-Reply-To: <20140529140204.GH11074@laptop.programming.kicks-ass.net>
References: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org>
 <1400860385-14555-12-git-send-email-vincent.guittot@linaro.org> <20140529140204.GH11074@laptop.programming.kicks-ass.net>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Thu, 29 May 2014 21:56:24 +0200
Message-ID: <CAKfTPtACXf+c01O+dCU2ZTc-Mrs+nTKYsu0_aBt8awxSg5WD=g@mail.gmail.com>
Subject: Re: [PATCH v2 11/11] sched: replace capacity by activity
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Mike Galbraith <efault@gmx.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 May 2014 16:02, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, May 23, 2014 at 05:53:05PM +0200, Vincent Guittot wrote:
>> @@ -6052,8 +6006,8 @@ static inline void update_sd_lb_stats(struct lb_env *env, struct sd_lb_stats *sd
>>                * with a large weight task outweighs the tasks on the system).
>>                */
>>               if (prefer_sibling && sds->local &&
>> -                 sds->local_stat.group_has_capacity)
>> -                     sgs->group_capacity = min(sgs->group_capacity, 1U);
>> +                 sds->local_stat.group_capacity > 0)
>> +                     sgs->group_capacity = min(sgs->group_capacity, 1L);
>>
>>               if (update_sd_pick_busiest(env, sds, sg, sgs)) {
>>                       sds->busiest = sg;
>> @@ -6228,7 +6182,7 @@ static inline void calculate_imbalance(struct lb_env *env, struct sd_lb_stats *s
>>                * have to drop below capacity to reach cpu-load equilibrium.
>>                */
>>               load_above_capacity =
>> -                     (busiest->sum_nr_running - busiest->group_capacity);
>> +                     (busiest->sum_nr_running - busiest->group_weight);
>>
>>               load_above_capacity *= (SCHED_LOAD_SCALE * SCHED_POWER_SCALE);
>>               load_above_capacity /= busiest->group_power;
>
> I think you just broke PREFER_SIBLING here..

you mean by replacing the capacity which was reflecting the number of
core for SMT by the group_weight ?

>
> So we want PREFER_SIBLING to work on nr_running, not utilization because
> we want to spread single tasks around, regardless of their utilization.
>
