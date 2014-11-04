Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752407AbaKDQqB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 11:46:01 -0500
Received: from mail-oi0-f50.google.com ([209.85.218.50]:53224 "EHLO
	mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751104AbaKDQp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 11:45:59 -0500
MIME-Version: 1.0
In-Reply-To: <011901cff833$b49afb30$1dd0f190$@alibaba-inc.com>
References: <011001cff827$f14b9870$d3e2c950$@alibaba-inc.com>
 <CAKfTPtD6TZ4iHv9wtg-KCkGZriU79ySSxEV3nao2qQacveKAxA@mail.gmail.com>
 <011801cff82e$78cd2c90$6a6785b0$@alibaba-inc.com> <CAKfTPtCwLobjq6RVsB=61D_4amMtnLCmfUcpPo50Z7kzWgy5Hw@mail.gmail.com>
 <011901cff833$b49afb30$1dd0f190$@alibaba-inc.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Tue, 4 Nov 2014 17:45:38 +0100
Message-ID: <CAKfTPtDYF91q3AQJaO3w-bPOrMGHTOj44yR7NnSsVXAGHnLmaw@mail.gmail.com>
Subject: Re: [PATCH v8 03/10] sched: move cfs task on a CPU with higher capacity
To: Hillf Danton <hillf.zj@alibaba-inc.com>
Cc: Wanpeng Li <kernellwp@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 November 2014 14:31, Hillf Danton <hillf.zj@alibaba-inc.com> wrote:
>> >> > I wonder if you can please shed light on the case that
>> >> > the dst_cpu is newly idle.
>> >>
>> >> The main problem if we do the test only for newly idle case, is that
>> >> we are not sure to move the task because we must rely on the
>> >> wakeup/sleep sequence of other tasks on an idle CPU in order to trig
>> >> the migration (periodic background task as an example). So we might
>> >> never move the task whereas idle CPUs are available
>> >>
>> > So no task is migrated in the newly idle case, if I understand the
>> > above correctly.
>>
>> A task can be moved in both idle and newly idle. If we rely only on
>> newly idle and we  have only idle CPUs, we can never move task. In the
>> same way, if we rely only on idle case and a CPU never stays idle long
>> enough to trig the idle load balance, we will never move the task. I
>> agree that for the latter, we might wonder if it's worth moving the
>> task. This is your concern ?
>>
> I concern if the only-one cfs task is migrated to a newly-idle CPU in
> your code:
> +       /*
> +        * The dst_cpu is idle and the src_cpu CPU has only 1 CFS task.
> +        * It's worth migrating the task if the src_cpu's capacity is reduced
> +        * because of other sched_class or IRQs whereas capacity stays
> +        * available on dst_cpu.
> +        */
> +       if ((env->idle != CPU_NOT_IDLE) &&
> +                       (env->src_rq->cfs.h_nr_running == 1)) {
> +
> due to the comment:
>                 /*
>                  * Increment the failure counter only on periodic balance.
>                  * We do not want newidle balance, which can be very
>                  * frequent, pollute the failure counter causing
>                  * excessive cache_hot migrations and active balances.
>                  */
>                 if (idle != CPU_NEWLY_IDLE)
>                         sd->nr_balance_failed++;
>

I understand the code above as only idle CPU increases the
nr_balance_failed and can generate an active load balance but newly
idle CPUs don't increase it because it can occur quite often and would
generate excessive active migration.
This patch will not pollute nr_balance_failed as it will clear it once
the task has moved on another CPU with full capacity. If a newly idle
load balance occurs before, the nr_balance_failed will also be cleared

Vincent

> Hillf
>
