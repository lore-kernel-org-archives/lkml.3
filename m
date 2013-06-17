Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610Ab3FQXBE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 19:01:04 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:38642 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751361Ab3FQXBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 19:01:02 -0400
MIME-Version: 1.0
In-Reply-To: <51BF15C4.1090906@intel.com>
References: <1370589652-24549-1-git-send-email-alex.shi@intel.com>
 <1370589652-24549-7-git-send-email-alex.shi@intel.com> <CAPM31RKwNUh+nNcsEftD4pyP+gdwXhRK7wCRNWa8Y0sE0hf-DQ@mail.gmail.com>
 <CAPM31R+DBFt1wr10GCGEHDW_J_-79imdTCYEBF7YiKdFc1V7iQ@mail.gmail.com> <51BF15C4.1090906@intel.com>
From: Paul Turner <pjt@google.com>
Date: Mon, 17 Jun 2013 16:00:30 -0700
Message-ID: <CAPM31RKHtEYsNV+kzxFpH=55dLaFn1jcQcWD4qYAdHrW_xN+8A@mail.gmail.com>
Subject: Re: [patch v8 6/9] sched: compute runnable load avg in cpu_load and cpu_avg_load_per_task
To: Alex Shi <alex.shi@intel.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
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

On Mon, Jun 17, 2013 at 6:57 AM, Alex Shi <alex.shi@intel.com> wrote:
> On 06/17/2013 08:17 PM, Paul Turner wrote:
>> On Mon, Jun 17, 2013 at 3:51 AM, Paul Turner <pjt@google.com> wrote:
>>> On Fri, Jun 7, 2013 at 12:20 AM, Alex Shi <alex.shi@intel.com> wrote:
>>>> They are the base values in load balance, update them with rq runnable
>>>> load average, then the load balance will consider runnable load avg
>>>> naturally.
>>>>
>>>> We also try to include the blocked_load_avg as cpu load in balancing,
>>>> but that cause kbuild performance drop 6% on every Intel machine, and
>>>> aim7/oltp drop on some of 4 CPU sockets machines.
>>>>
>>>
>>> This looks fine.
>>>
>>> Did you try including blocked_load_avg in only get_rq_runnable_load()
>>> [ and not weighted_cpuload() which is called by new-idle ]?
>>
>> Looking at this more this feels less correct since you're taking
>> averages of averages.
>>
>> This was previously discussed at:
>>   https://lkml.org/lkml/2013/5/6/109
>>
>> And  you later replied suggesting this didn't seem to hurt; what's the
>> current status there?
>
> Yes, your example show the blocked_load_avg value.
> So I had given a patch for review at that time before do detailed
> testing. https://lkml.org/lkml/2013/5/7/66
>
> But in detailed testing, the patch cause a big performance regression.
> When I look into for details. I found some cpu in kbuild just had a big
> blocked_load_avg, with a very small runnable_load_avg value.
>
> Seems accumulating current blocked_load_avg into cpu load isn't a good
> idea. Because:

So I think this describes an alternate implementation to the one suggested in:
  https://lkml.org/lkml/2013/5/7/66

Specifically, we _don't_ want to accumulate into cpu-load.  Taking an
"average of the average" loses the mobility that the new
representation allows.

> 1, The blocked_load_avg is decayed same as runnable load, sometime is
> far bigger than runnable load, that drive tasks to other idle or slight
> load cpu, than cause both performance and power issue. But if the
> blocked load is decayed too fast, it lose its effect.

This is why the idea would be to use an instantaneous load in
weighted_cpuload() and one that incorporated averages on (wants a
rename) get_rq_runnable_load().

For non-instaneous load-indexes we're pulling for stability.

> 2, Another issue of blocked load is that when waking up task, we can not
> know blocked load proportion of the task on rq. So, the blocked load is
> meaningless in wake affine decision.

I think this is confusing two things:

(a) A wake-idle wake-up
(b) A wake-affine wake-up

In (a) we do not care about the blocked load proportion, only whether
a cpu is idle.

But once (a) has failed we should absolutely care how much load is
blocked in (b) as:
- We know we're going to queue for bandwidth on the cpu [ otherwise
we'd be in (a) ]
- Blocked load predicts how much _other_ work is expected to also
share the queue with us during the quantum

>
> According to above problem, I give up to enable blocked_load_avg in balance.
>
>
>>
>>
>>>
>>>> Signed-off-by: Alex Shi <alex.shi@intel.com>
>>>> ---
>>>>  kernel/sched/fair.c |  5 +++--
>>>>  kernel/sched/proc.c | 17 +++++++++++++++--
>>>>  2 files changed, 18 insertions(+), 4 deletions(-)
>>>>
>>>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>>>> index 42c7be0..eadd2e7 100644
>>>> --- a/kernel/sched/fair.c
>>>> +++ b/kernel/sched/fair.c
>>>> @@ -2962,7 +2962,7 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
>>>>  /* Used instead of source_load when we know the type == 0 */
>>>>  static unsigned long weighted_cpuload(const int cpu)
>>>>  {
>>>> -       return cpu_rq(cpu)->load.weight;
>>>> +       return cpu_rq(cpu)->cfs.runnable_load_avg;
>>>>  }
>>>>
>>>>  /*
>>>> @@ -3007,9 +3007,10 @@ static unsigned long cpu_avg_load_per_task(int cpu)
>>>>  {
>>>>         struct rq *rq = cpu_rq(cpu);
>>>>         unsigned long nr_running = ACCESS_ONCE(rq->nr_running);
>>>> +       unsigned long load_avg = rq->cfs.runnable_load_avg;
>>>>
>>>>         if (nr_running)
>>>> -               return rq->load.weight / nr_running;
>>>> +               return load_avg / nr_running;
>>>>
>>>>         return 0;
>>>>  }
>>>> diff --git a/kernel/sched/proc.c b/kernel/sched/proc.c
>>>> index bb3a6a0..ce5cd48 100644
>>>> --- a/kernel/sched/proc.c
>>>> +++ b/kernel/sched/proc.c
>>>> @@ -501,6 +501,18 @@ static void __update_cpu_load(struct rq *this_rq, unsigned long this_load,
>>>>         sched_avg_update(this_rq);
>>>>  }
>>>>
>>>> +#ifdef CONFIG_SMP
>>>> +unsigned long get_rq_runnable_load(struct rq *rq)
>>>> +{
>>>> +       return rq->cfs.runnable_load_avg;
>>>> +}
>>>> +#else
>>>> +unsigned long get_rq_runnable_load(struct rq *rq)
>>>> +{
>>>> +       return rq->load.weight;
>>>> +}
>>>> +#endif
>>>> +
>>>>  #ifdef CONFIG_NO_HZ_COMMON
>>>>  /*
>>>>   * There is no sane way to deal with nohz on smp when using jiffies because the
>>>> @@ -522,7 +534,7 @@ static void __update_cpu_load(struct rq *this_rq, unsigned long this_load,
>>>>  void update_idle_cpu_load(struct rq *this_rq)
>>>>  {
>>>>         unsigned long curr_jiffies = ACCESS_ONCE(jiffies);
>>>> -       unsigned long load = this_rq->load.weight;
>>>> +       unsigned long load = get_rq_runnable_load(this_rq);
>>>>         unsigned long pending_updates;
>>>>
>>>>         /*
>>>> @@ -568,11 +580,12 @@ void update_cpu_load_nohz(void)
>>>>   */
>>>>  void update_cpu_load_active(struct rq *this_rq)
>>>>  {
>>>> +       unsigned long load = get_rq_runnable_load(this_rq);
>>>>         /*
>>>>          * See the mess around update_idle_cpu_load() / update_cpu_load_nohz().
>>>>          */
>>>>         this_rq->last_load_update_tick = jiffies;
>>>> -       __update_cpu_load(this_rq, this_rq->load.weight, 1);
>>>> +       __update_cpu_load(this_rq, load, 1);
>>>>
>>>>         calc_load_account_active(this_rq);
>>>>  }
>>>> --
>>>> 1.7.12
>>>>
>
>
> --
> Thanks
>     Alex
