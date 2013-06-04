Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751720Ab3FDIVL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 04:21:11 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:59048 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751264Ab3FDIVH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 04:21:07 -0400
MIME-Version: 1.0
In-Reply-To: <20130603224836.GA9388@somewhere>
References: <1369927385-7801-1-git-send-email-vincent.guittot@linaro.org>
	<20130603224836.GA9388@somewhere>
Date: Tue, 4 Jun 2013 10:21:06 +0200
Message-ID: <CAKfTPtCB_ftNWjgAM9s79dX_tuS4yevjdD0YxvKfKS4dxz=LLQ@mail.gmail.com>
Subject: Re: [PATCH] sched: fix clear NOHZ_BALANCE_KICK
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 June 2013 00:48, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> On Thu, May 30, 2013 at 05:23:05PM +0200, Vincent Guittot wrote:
>> I have faced a sequence where the Idle Load Balance was sometime not
>>  triggered for a while on my platform.
>>
>> CPU 0 and CPU 1 are running tasks and CPU 2 is idle
>>
>> CPU 1 kicks the Idle Load Balance
>> CPU 1 selects CPU 2 as the new Idle Load Balancer
>> CPU 1 sets NOHZ_BALANCE_KICK for CPU 2
>> CPU 1 sends a reschedule IPI to CPU 2
>> While CPU 2 wakes up, CPU 0 or CPU 1 migrates a waking task A on CPU 2
>> CPU 2 finally wakes up, runs task A and discards the Idle Load Balance
>> Task A quickly goes back to sleep (before a tick occurs on CPU 2)
>> CPU 2 goes back to idle with NOHZ_BALANCE_KICK set
>>
>> Whenever CPU 2 will be selected for the ILB, reschedule IPI will be not
>> sent to CPU2, which is idle, because NOHZ_BALANCE_KICK is already set
>> and no Idle Load Balance will be performed.
>>
>> We must wait for the sched softirq to be raised on CPU 2 thanks to
>> another part of the kernel to clear NOHZ_BALANCE_KICKand come back to
>> a normal situation.
>>
>> The proposed solution clears NOHZ_BALANCE_KICK in schedule_ipi if
>> we can't raise the sched_softirq for the Idle Load Balance.
>>
>> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
>> ---
>>  kernel/sched/core.c |    3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>> index 58453b8..51fc715 100644
>> --- a/kernel/sched/core.c
>> +++ b/kernel/sched/core.c
>> @@ -1420,7 +1420,8 @@ void scheduler_ipi(void)
>>       if (unlikely(got_nohz_idle_kick() && !need_resched())) {
>>               this_rq()->idle_balance = 1;
>>               raise_softirq_irqoff(SCHED_SOFTIRQ);
>> -     }
>> +     } else
>> +             clear_bit(NOHZ_BALANCE_KICK, nohz_flags(smp_processor_id()));
>
> But then do we reach this if the IPI happens while running the non-idle task in
> CPU 2? The first got_nohz_idle_kick() test would drop us out early from scheduler_ipi()
> due to the idle_cpu() test. So the flag doesn't get cleared in this case.

The 1st point is that only idle cpu can be selected for idle load
balance. But this doesn't prevent the cpu to wake up while it is
kicked for idle load balance.
I had added the clear_bit for the 1st got_nohz_idle_kick in the draft
version of this patch but the test of the emptiness of the wake_list,
the call to smp_send_reschedule in the various way to wake up the idle
cpu and the results of the tests have convinced me (may be wrongly)
that it was not necessary.

Vincent
