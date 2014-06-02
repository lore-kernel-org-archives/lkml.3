Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093AbaFBRHI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 13:07:08 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:62630 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbaFBRHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 13:07:05 -0400
MIME-Version: 1.0
In-Reply-To: <20140530062937.GA11096@twins.programming.kicks-ass.net>
References: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org>
 <1400860385-14555-11-git-send-email-vincent.guittot@linaro.org>
 <20140529095024.GF11074@laptop.programming.kicks-ass.net> <CAKfTPtCHhxyugMOCeS0hZoEXWhgRec4uOBexZ2aB2A+Eycgi8w@mail.gmail.com>
 <20140530062937.GA11096@twins.programming.kicks-ass.net>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Mon, 2 Jun 2014 19:06:44 +0200
Message-ID: <CAKfTPtBXddNFXDuL5YNNtcW7e1Un=LqHU8bgaejJwPObSGoBhg@mail.gmail.com>
Subject: Re: [PATCH v2 10/11] sched: move cfs task on a CPU with higher capacity
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

On 30 May 2014 08:29, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, May 29, 2014 at 09:37:39PM +0200, Vincent Guittot wrote:
>> On 29 May 2014 11:50, Peter Zijlstra <peterz@infradead.org> wrote:
>> > On Fri, May 23, 2014 at 05:53:04PM +0200, Vincent Guittot wrote:
>> >> If the CPU is used for handling lot of IRQs, trig a load balance to check if
>> >> it's worth moving its tasks on another CPU that has more capacity
>> >>
>> >> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
>> >> ---
>> >>  kernel/sched/fair.c | 13 +++++++++++++
>> >>  1 file changed, 13 insertions(+)
>> >>
>> >> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> >> index e8a30f9..2501e49 100644
>> >> --- a/kernel/sched/fair.c
>> >> +++ b/kernel/sched/fair.c
>> >> @@ -5948,6 +5948,13 @@ static bool update_sd_pick_busiest(struct lb_env *env,
>> >>       if (sgs->sum_nr_running > sgs->group_capacity)
>> >>               return true;
>> >>
>> >> +     /*
>> >> +      * The group capacity is reduced probably because of activity from other
>> >> +      * sched class or interrupts which use part of the available capacity
>> >> +      */
>> >> +     if ((sg->sgp->power_orig * 100) > (sgs->group_power * env->sd->imbalance_pct))
>> >> +             return true;
>> >> +
>> >>       if (sgs->group_imb)
>> >>               return true;
>> >>
>> >
>> > But we should already do this because the load numbers are scaled with
>> > the power/capacity figures. If one CPU gets significant less time to run
>> > fair tasks, its effective load would spike and it'd get to be selected
>> > here anyway.
>> >
>> > Or am I missing something?
>>
>> The CPU could have been picked when the capacity becomes null (which
>> occurred when the cpu_power goes below half the default
>> SCHED_POWER_SCALE). And even after that, there were some conditions in
>> find_busiest_group that was bypassing this busiest group
>
> Could you detail those conditions? FWIW those make excellent Changelog
> material.

I have looked back into my tests and traces:

In a 1st test, the capacity of the CPU was still above half default
value (power=538) unlike what i remembered. So it's some what "normal"
to keep the task on CPU0 which also handles IRQ because sg_capacity
still returns 1.

In a 2nd test,the main task runs (most of the time) on CPU0 whereas
the max power of the latter is only 623 and the cpu_power goes below
512 (power=330) during the use case. So the sg_capacity of CPU0 is
null but the main task still stays on CPU0.
The use case (scp transfer) is made of a long running task (ssh) and a
periodic short task (scp). ssh runs on CPU0 and scp runs each 6ms on
CPU1. The newly idle load balance on CPU1 doesn't pull the long
running task although sg_capacity is null because of
sd->nr_balance_failed is never incremented and load_balance doesn't
trig an active load_balance. When an idle balance occurs in the middle
of the newly idle balance, the ssh long task migrates on CPU1 but as
soon as it sleeps and wakes up, it goes back on CPU0 because of the
wake affine which migrates it back on CPU0 (issue solved by patch 09).

Vincent
