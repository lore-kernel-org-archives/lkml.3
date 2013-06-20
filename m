Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935596Ab3FTCqd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 22:46:33 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:43962 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935506Ab3FTCqc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 22:46:32 -0400
MIME-Version: 1.0
In-Reply-To: <CALZhoSSweOzTgjykRMxv_kha9TH-8EAKvuhinf8ADFyFDzDTuQ@mail.gmail.com>
References: <1370589652-24549-1-git-send-email-alex.shi@intel.com>
	<1370589652-24549-5-git-send-email-alex.shi@intel.com>
	<CAPM31RLB6nN+qN8UNq0RXiRYKaFZ6GYVP-=kZMR8-rkP9831Bw@mail.gmail.com>
	<51BF2E37.5040400@intel.com>
	<CALZhoSSweOzTgjykRMxv_kha9TH-8EAKvuhinf8ADFyFDzDTuQ@mail.gmail.com>
Date: Thu, 20 Jun 2013 10:46:30 +0800
Message-ID: <CALZhoSSFr_HN9ccxNLK7HA-7O9soAU7VZ3njtKf=Ndw=_AbQRw@mail.gmail.com>
Subject: Re: [patch v8 4/9] sched: fix slept time double counting in enqueue entity
From: Lei Wen <adrian.wenl@gmail.com>
To: Alex Shi <alex.shi@intel.com>
Cc: Paul Turner <pjt@google.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Namhyung Kim <namhyung@kernel.org>,
        Mike Galbraith <efault@gmx.de>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Michael Wang <wangyun@linux.vnet.ibm.com>,
        Jason Low <jason.low2@hp.com>,
        Changlong Xie <changlongx.xie@intel.com>, sgruszka@redhat.com,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 20, 2013 at 9:43 AM, Lei Wen <adrian.wenl@gmail.com> wrote:
> Hi Alex,
>
> On Mon, Jun 17, 2013 at 11:41 PM, Alex Shi <alex.shi@intel.com> wrote:
>> On 06/17/2013 07:51 PM, Paul Turner wrote:
>>> Can you add something like:
>>>
>>> +               /*
>>> +                * Task re-woke on same cpu (or else
>>> migrate_task_rq_fair()
>>> +                * would have made count negative); we must be careful
>>> to avoid
>>> +                * double-accounting blocked time after synchronizing
>>> decays.
>>> +                */
>>>
>>>
>>> Reviewed-by: Paul Turner <pjt@google.com>
>>
>> thanks for review!
>> ---
>>
>> From 24d9b43e7a269e6ffee5b874d39812b83812a809 Mon Sep 17 00:00:00 2001
>> From: Alex Shi <alex.shi@intel.com>
>> Date: Thu, 9 May 2013 10:54:13 +0800
>> Subject: [PATCH] sched: fix slept time double counting in enqueue entity
>>
>> The wakeuped migrated task will __synchronize_entity_decay(se); in
>> migrate_task_fair, then it needs to set
>
> Should be migrate_task_rq_fair, right? :)
>
>> `se->avg.last_runnable_update -= (-se->avg.decay_count) << 20'
>> before update_entity_load_avg, in order to avoid slept time is updated
>> twice for se.avg.load_avg_contrib in both __syncchronize and
>> update_entity_load_avg.
>>
>> but if the slept task is waked up from self cpu, it miss the
>> last_runnable_update before update_entity_load_avg(se, 0, 1), then the
>> slept time was used twice in both functions.
>> So we need to remove the double slept time counting.
>>
>> Signed-off-by: Alex Shi <alex.shi@intel.com>
>> Reviewed-by: Paul Turner <pjt@google.com>
>> ---
>>  kernel/sched/fair.c |    8 +++++++-
>>  1 files changed, 7 insertions(+), 1 deletions(-)
>>
>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> index df5b8a9..1e5a5e6 100644
>> --- a/kernel/sched/fair.c
>> +++ b/kernel/sched/fair.c
>> @@ -1571,7 +1571,13 @@ static inline void enqueue_entity_load_avg(struct cfs_rq *cfs_rq,
>>                 }
>>                 wakeup = 0;
>>         } else {
>> -               __synchronize_entity_decay(se);
>> +               /*
>> +                * Task re-woke on same cpu (or else migrate_task_rq_fair()
>> +                * would have made count negative); we must be careful to avoid
>> +                * double-accounting blocked time after synchronizing decays.
>> +                */
>> +               se->avg.last_runnable_update += __synchronize_entity_decay(se)
>> +                                                       << 20;
>
> I'm kind of getting confused at here, since migrate_task_rq_fair use
> below equation to
> avoid sleep time be accounted for twice.
>  `se->avg.last_runnable_update -= (-se->avg.decay_count) << 20'
>
> Why here we need to use "+=", which the reversed version comparing
> with previous?

Here is my understanding for this reversed behavior, not sure am I right?...
1. in migrate_task_rq_fair case, it performs the decay operation directly
over load_avg_contrib, but not update runnable_avg_sum and runnable_avg_period
accordingly. Thus when the task migrated to different runqueue, it
make its previous
decayed result can be reflected over the new runqueue, since load_avg_contrib
would be calculated with original runnable_avg_sum and
runnable_avg_period value,
it would mean the migrated task lost the decay in this process, as
avg.last_runnable_update is aligned with new runqueue's clock_task.

So we need "-=" in the migrated case.

2. For the normal wake up case, since we run over local queue continuously,
our avg.last_runnable_update is not changed, thus if we do nothing, we could
get the another decay in __update_entity_runnable_avg. Since we already get
one over __synchronzie_entity_decay, it should bring us a redundant one.

Thus it is right to add a "+=" here.


But here I have a question, there is another usage of __synchronzie_entity_decay
in current kernel, in the switched_from_fair function.

If task being frequently switched between rt and fair class, would it
also bring the
redundant issue? Do we need patch like below?

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index b5408e1..9640c66 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5856,7 +5856,7 @@ static void switched_from_fair(struct rq *rq,
struct task_struct *p)
        */
        if (p->se.avg.decay_count) {
                struct cfs_rq *cfs_rq = cfs_rq_of(&p->se);
-               se->avg.last_runnable_update +=
+               p->se.avg.last_runnable_update +=
                                __synchronize_entity_decay(&p->se);
                subtract_blocked_load_contrib(cfs_rq,
                                p->se.avg.load_avg_contrib);


Thanks,
Lei


>
> Thanks,
> Lei
>
>>         }
>>
>>         /* migrated tasks did not contribute to our blocked load */
>> --
>> 1.7.5.4
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
