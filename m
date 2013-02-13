Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964782Ab3BMRIr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 12:08:47 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61170 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756481Ab3BMRIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 12:08:46 -0500
MIME-Version: 1.0
In-Reply-To: <CAPM31RJbcd3Dcm0EK4VqNTgo8AN+=sMoi0aTF=OthxrGBFXoTg@mail.gmail.com>
References: <1360745669-7996-1-git-send-email-vincent.guittot@linaro.org>
	<CAPM31RJbcd3Dcm0EK4VqNTgo8AN+=sMoi0aTF=OthxrGBFXoTg@mail.gmail.com>
Date: Wed, 13 Feb 2013 18:08:43 +0100
Message-ID: <CAKfTPtAx=u6a53-QqfM1Babtik0QSJp2Re7NSyXL-PyQBpc3zQ@mail.gmail.com>
Subject: Re: [PATCH v3] sched: fix wrong rq's runnable_avg update with rt task
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        peterz@infradead.org, mingo@kernel.org, fweisbec@gmail.com,
        rostedt@goodmis.org, efault@gmx.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 February 2013 16:28, Paul Turner <pjt@google.com> wrote:
> On Wed, Feb 13, 2013 at 12:54 AM, Vincent Guittot
> <vincent.guittot@linaro.org> wrote:
>> When a RT task is scheduled on an idle CPU, the update of the rq's load is
>> not done because CFS's functions are not called. Then, the idle_balance,
>> which is called just before entering the idle function, updates the
>> rq's load and makes the assumption that the elapsed time since the last
>> update, was only running time.
>
> So an interesting point here is we intrinsically treat RT time
> differently in our discount of the CPU power.  It doesn't affect
> anything in this patch per-say; but it should be kept in mind for
> consistency when you do anything with the rq based numbers.
>
>>
>> The rq's load of a CPU that only runs a periodic RT task, is close to
>> LOAD_AVG_MAX whatever the running duration of the RT task is.
>>
>> A new idle_exit function is called when the prev task is the idle function
>> so the elapsed time will be accounted as idle time in the rq's load.
>>
>> Changes since V2:
>> - remove useless definition for UP platform
>> - rebased on top of Steven Rostedt's patches :
>> https://lkml.org/lkml/2013/2/12/558
>>
>> Changes since V1:
>> - move code out of schedule function and create a pre_schedule callback for
>>   idle class instead.
>>
>> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
>> ---
>>  kernel/sched/fair.c      |   10 ++++++++++
>>  kernel/sched/idle_task.c |    7 +++++++
>>  kernel/sched/sched.h     |    1 +
>>  3 files changed, 18 insertions(+)
>>
>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> index 0fcdbff..6af5db3 100644
>> --- a/kernel/sched/fair.c
>> +++ b/kernel/sched/fair.c
>> @@ -1562,6 +1562,16 @@ static inline void dequeue_entity_load_avg(struct cfs_rq *cfs_rq,
>>                 se->avg.decay_count = atomic64_read(&cfs_rq->decay_counter);
>>         } /* migrations, e.g. sleep=0 leave decay_count == 0 */
>>  }
>> +
>> +/*
>> + * Update the rq's load with the elapsed idle time before a task is
>> + * scheduled. if the newly scheduled task is not a CFS task, idle_exit will
>> + * be the only way to update the runnable statistic.
>> + */
>> +void idle_exit(int this_cpu, struct rq *this_rq)
>> +{
>> +       update_rq_runnable_avg(this_rq, 0);
>> +}
>
> This does creates a somewhat sneaky dependency CONFIG_FAIR_GROUP_SCHED
> bits and sched-idle; and it kind of hides the problem by making the
> subsequent update a nop.

yes but this is a temporary dependency until per task load tracking is
used by default in the scheduler, isn't it ? Or there is another
dependency ?

>
> Is the root of the problem perhaps that we assume we were previously
> runnable in idle_balance in the first place?  Hmmm; this should
> actually be essentially torn down by the dequeue of the last task in
> the first place.  I'd have to think about it carefully but arguably we
> might be able to just remove the update_rq_runnable_avg from
> idle_balance entirely.

Furthermore, this update in idle_balance is not always done.
In this situation, we will only monitor cfs tasks on the rq.

>
> We'd still need to make sure we pushed updates against rq->avg to
> cover RT task time (something you correctly point out is currently not
> accounted, and which entry/exit from idle-task seems a reasonable
> place); but this can then be independent of all the cgroup specific
> bits.

I'm not sure to catch the dependency with cgroup that you mentioned

Vincent

>
>
>>  #else
>>  static inline void update_entity_load_avg(struct sched_entity *se,
>>                                           int update_cfs_rq) {}
>> diff --git a/kernel/sched/idle_task.c b/kernel/sched/idle_task.c
>> index 66b5220..6e7e63c 100644
>> --- a/kernel/sched/idle_task.c
>> +++ b/kernel/sched/idle_task.c
>> @@ -14,6 +14,12 @@ select_task_rq_idle(struct task_struct *p, int sd_flag, int flags)
>>         return task_cpu(p); /* IDLE tasks as never migrated */
>>  }
>>
>> +static void pre_schedule_idle(struct rq *rq, struct task_struct *prev)
>> +{
>> +       /* Update rq's load with elapsed idle time */
>> +       idle_exit(smp_processor_id(), rq);
>> +}
>> +
>>  static void post_schedule_idle(struct rq *rq)
>>  {
>>         idle_balance(smp_processor_id(), rq);
>> @@ -95,6 +101,7 @@ const struct sched_class idle_sched_class = {
>>
>>  #ifdef CONFIG_SMP
>>         .select_task_rq         = select_task_rq_idle,
>> +       .pre_schedule           = pre_schedule_idle,
>>         .post_schedule          = post_schedule_idle,
>>  #endif
>>
>> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
>> index fc88644..5f26c93f 100644
>> --- a/kernel/sched/sched.h
>> +++ b/kernel/sched/sched.h
>> @@ -877,6 +877,7 @@ extern const struct sched_class idle_sched_class;
>>
>>  extern void trigger_load_balance(struct rq *rq, int cpu);
>>  extern void idle_balance(int this_cpu, struct rq *this_rq);
>> +extern void idle_exit(int this_cpu, struct rq *this_rq);
>>
>>  #else  /* CONFIG_SMP */
>>
>> --
>> 1.7.9.5
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
