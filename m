Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300AbaFCMcA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 08:32:00 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:41281 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233AbaFCMb6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 08:31:58 -0400
MIME-Version: 1.0
In-Reply-To: <20140603111532.GW11096@twins.programming.kicks-ass.net>
References: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org>
 <1400860385-14555-11-git-send-email-vincent.guittot@linaro.org>
 <20140529095024.GF11074@laptop.programming.kicks-ass.net> <CAKfTPtCHhxyugMOCeS0hZoEXWhgRec4uOBexZ2aB2A+Eycgi8w@mail.gmail.com>
 <20140530062937.GA11096@twins.programming.kicks-ass.net> <CAKfTPtBXddNFXDuL5YNNtcW7e1Un=LqHU8bgaejJwPObSGoBhg@mail.gmail.com>
 <20140603111532.GW11096@twins.programming.kicks-ass.net>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Tue, 3 Jun 2014 14:31:38 +0200
Message-ID: <CAKfTPtBRkWY1hTBqd9cQKetFbWEVvJVo-wKUz9MN-ZfZLq4TuA@mail.gmail.com>
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

On 3 June 2014 13:15, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, Jun 02, 2014 at 07:06:44PM +0200, Vincent Guittot wrote:
>> > Could you detail those conditions? FWIW those make excellent Changelog
>> > material.
>>
>> I have looked back into my tests and traces:
>>
>> In a 1st test, the capacity of the CPU was still above half default
>> value (power=538) unlike what i remembered. So it's some what "normal"
>> to keep the task on CPU0 which also handles IRQ because sg_capacity
>> still returns 1.
>
> OK, so I suspect that once we move to utilization based capacity stuff
> we'll do the migration IF the task indeed requires more cpu than can be
> provided by the reduced, one, right?

The current version of the patchset only checks if the capacity of a
CPU has significantly reduced that we should look for another CPU. But
we effectively could also add compare the remaining capacity with the
task load

>
>> In a 2nd test,the main task runs (most of the time) on CPU0 whereas
>> the max power of the latter is only 623 and the cpu_power goes below
>> 512 (power=330) during the use case. So the sg_capacity of CPU0 is
>> null but the main task still stays on CPU0.
>> The use case (scp transfer) is made of a long running task (ssh) and a
>> periodic short task (scp). ssh runs on CPU0 and scp runs each 6ms on
>> CPU1. The newly idle load balance on CPU1 doesn't pull the long
>> running task although sg_capacity is null because of
>> sd->nr_balance_failed is never incremented and load_balance doesn't
>> trig an active load_balance. When an idle balance occurs in the middle
>> of the newly idle balance, the ssh long task migrates on CPU1 but as
>> soon as it sleeps and wakes up, it goes back on CPU0 because of the
>> wake affine which migrates it back on CPU0 (issue solved by patch 09).
>
> OK, so there's two problems here, right?
>  1) we don't migrate away from cpu0
>  2) if we do, we get pulled back.
>
> And patch 9 solves 2, so maybe enhance its changelog to mention this
> slightly more explicit.
>
> Which leaves us with 1.. interesting problem. I'm just not sure
> endlessly kicking a low capacity cpu is the right fix for that.

What prevent us to migrate the task directly is the fact that
nr_balance_failed is not incremented for newly idle and it's the only
condition for active migration (except asym feature)

We could add a additional test in need_active_balance for newly_idle
load balance. Something like:

if ((sd->flags & SD_SHARE_PKG_RESOURCES)
 && (senv->rc_rq->cpu_power_orig * 100) > (env->src_rq->group_power *
env->sd->imbalance_pct))
return 1;

>
>
