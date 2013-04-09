Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936036Ab3DIJG3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 05:06:29 -0400
Received: from mail-bk0-f44.google.com ([209.85.214.44]:52244 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935487Ab3DIJGR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 05:06:17 -0400
MIME-Version: 1.0
In-Reply-To: <1365497406.2609.162.camel@laptop>
References: <1365084959-28374-1-git-send-email-vincent.guittot@linaro.org>
	<1365497406.2609.162.camel@laptop>
Date: Tue, 9 Apr 2013 11:06:15 +0200
Message-ID: <CAKfTPtDJa5Am+jEHSzy+hhh+9=GcR9YXzKV-DAH3D3Hq6uMHog@mail.gmail.com>
Subject: Re: [PATCH v4] sched: fix wrong rq's runnable_avg update with rt tasks
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        Ingo Molnar <mingo@kernel.org>, Paul Turner <pjt@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 April 2013 10:50, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, 2013-04-04 at 16:15 +0200, Vincent Guittot wrote:
>> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
>> ---
>>  kernel/sched/fair.c      |   23 +++++++++++++++++++++--
>>  kernel/sched/idle_task.c |   10 ++++++++++
>>  kernel/sched/sched.h     |   12 ++++++++++++
>>  3 files changed, 43 insertions(+), 2 deletions(-)
>>
>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> index 0fcdbff..1851ca8 100644
>> --- a/kernel/sched/fair.c
>> +++ b/kernel/sched/fair.c
>> @@ -1562,6 +1562,27 @@ static inline void
>> dequeue_entity_load_avg(struct cfs_rq *cfs_rq,
>>                 se->avg.decay_count =
>> atomic64_read(&cfs_rq->decay_counter);
>>         } /* migrations, e.g. sleep=0 leave decay_count == 0 */
>>  }
>> +
>> +/*
>> + * Update the rq's load with the elapsed running time before entering
>> + * idle. if the last scheduled task is not a CFS task, idle_enter
>> will
>> + * be the only way to update the runnable statistic.
>> + */
>> +void idle_enter(struct rq *this_rq)
>> +{
>> +       update_rq_runnable_avg(this_rq, 1);
>> +}
>> +
>> +/*
>> + * Update the rq's load with the elapsed idle time before a task is
>> + * scheduled. if the newly scheduled task is not a CFS task,
>> idle_exit will
>> + * be the only way to update the runnable statistic.
>> + */
>> +void idle_exit(struct rq *this_rq)
>> +{
>> +       update_rq_runnable_avg(this_rq, 0);
>> +}
>
> These seem like fairly unfortunate names to expose to the global
> namespace, why not expose update_rq_runnable_avg() instead?

Just to gather in one place all cfs actions that should be done when
exiting idle even if we only have update_rq_runnable_avg right now. I
have distinguished that from idle_balance because this sequence can't
generate extra context switch like idle_balance and they would finally
not be called in the same time

>
>
