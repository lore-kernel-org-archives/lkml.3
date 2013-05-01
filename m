Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760582Ab3EALuu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 07:50:50 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:38854 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751422Ab3EALuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 07:50:44 -0400
MIME-Version: 1.0
In-Reply-To: <20130501110047.GD28253@dyad.programming.kicks-ass.net>
References: <1367291838-5490-1-git-send-email-kosaki.motohiro@gmail.com>
 <1367291838-5490-10-git-send-email-kosaki.motohiro@gmail.com> <20130501110047.GD28253@dyad.programming.kicks-ass.net>
From: Paul Turner <pjt@google.com>
Date: Wed, 1 May 2013 04:50:12 -0700
Message-ID: <CAPM31RJ0HWQCU=oDnd=iTyEZzsTS3xSe89rmgVK8cd8umAC5BQ@mail.gmail.com>
Subject: Re: [PATCH 09/10] sched: task_sched_runtime introduce micro optimization
To: Peter Zijlstra <peterz@infradead.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Olivier Langlois <olivier@trillion01.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Miller <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 1, 2013 at 4:00 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, Apr 29, 2013 at 11:17:17PM -0400, kosaki.motohiro@gmail.com wrote:
>> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>>
>> rq lock in task_sched_runtime() is necessary for two reasons. 1)
>> accessing se.sum_exec_runtime is inatomic on 32bit and 2)
>> do_task_delta_exec() require it.
>>
>> And then, 64bit can avoid holds rq lock when add_delta is false.
>>
>> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
>> ---
>>  kernel/sched/core.c |    6 ++++++
>>  1 files changed, 6 insertions(+), 0 deletions(-)
>>
>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>> index b817e6d..24ba1c6 100644
>> --- a/kernel/sched/core.c
>> +++ b/kernel/sched/core.c
>> @@ -2657,6 +2657,12 @@ unsigned long long task_sched_runtime(struct task_struct *p, bool add_delta)
>>       struct rq *rq;
>>       u64 ns = 0;
>>
>> +     /* Micro optimization. */
>
> Instead of the above; how about something like:
>
>   /* 64-bit doesn't need locks to atomically read a 64bit value */
>
>> +#ifdef CONFIG_64BIT
>> +     if (!add_delta)
>> +             return p->se.sum_exec_runtime;
>> +#endif


Stronger:

+#ifdef CONFIG_64BIT
+       if (!p->on_cpu)
+               return p->se.sum_exec_runtime;
+#endif

[ Or !p->on_cpu || !add_delta ].

We can take the racy read versus p->on_cpu since:
  If we race with it leaving cpu: we take lock, we're correct
  If we race with it entering cpu: unaccounted time ---> 0, this is
indistinguishable from the read occurring a few cycles earlier.

>>
>>       rq = task_rq_lock(p, &flags);
>>       ns = p->se.sum_exec_runtime;
>>       if (add_delta)
>> --
>> 1.7.1
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
