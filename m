Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751064Ab3FWJ3l (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 05:29:41 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:36165 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab3FWJ3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 05:29:39 -0400
MIME-Version: 1.0
In-Reply-To: <51BEB05C.7040802@linux.vnet.ibm.com>
References: <1371435692-18831-1-git-send-email-leiwen@marvell.com>
	<51BE8213.4000701@linux.vnet.ibm.com>
	<CALZhoSR7pB8qJjT_9_naxp2cgtuz=UR0DzLk_J-_CVNaO55jyA@mail.gmail.com>
	<51BEB05C.7040802@linux.vnet.ibm.com>
Date: Sun, 23 Jun 2013 17:29:38 +0800
Message-ID: <CALZhoSTne47rndKYw_tv_fBPpNvtk_R0fWMXaMqZEGU+tkykLQ@mail.gmail.com>
Subject: Re: [PATCH] sched: add heuristic logic to pick idle peers
From: Lei Wen <adrian.wenl@gmail.com>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: Lei Wen <leiwen@marvell.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, mingo@redhat.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On Mon, Jun 17, 2013 at 2:44 PM, Michael Wang
<wangyun@linux.vnet.ibm.com> wrote:
> On 06/17/2013 01:08 PM, Lei Wen wrote:
>> Hi Michael,
>>
>> On Mon, Jun 17, 2013 at 11:27 AM, Michael Wang
>> <wangyun@linux.vnet.ibm.com> wrote:
>>> Hi, Lei
>>>
>>> On 06/17/2013 10:21 AM, Lei Wen wrote:
>>>> nr_busy_cpus in sched_group_power structure cannot present the purpose
>>>> for judging below statement:
>>>> "this cpu's scheduler group has multiple busy cpu's exceeding
>>>>  the group's power."
>>>>
>>>> But only could tell how many cpus is doing their jobs for currently.
>>>
>>> AFAIK, this nr_busy_cpus presents how many cpus in local group are not
>>> idle, the logical here in nohz_kick_needed() is:
>>>
>>>         if domain cpus share resources and at least 2 cpus in
>>>         local group are not idle, prefer to do balance.
>>>
>>
>> Seems reasonable for me. But this comment is conflicted with current documented
>> one. Do we need to modify the comment anyway, as previous says nr_busy>1 is
>> "scheduler group has multiple busy cpu;s exceeding the group's power"?
>
> I agree it doesn't make sense (to me), the logical here only make sure
> there are at least 2 non-idle cpus in local group, we may need some more
> powerful folks to confirm that point.
>
>>
>>> And the idea behind is, we catch the timing when there are idle-cpu and
>>> busy-group and task-moving may cost low.
>>
>> Since there is only one task over runqueue now, then why we could need the
>> load balance any way?...
>
> IMHO, this is just shot in the darkness... like 'I think in such cases
> the chances of requiring a balance will be high', but the problem is,
> the logical is already in mainline for some reasons, if we want to say
> that is wrong, then we need to collect enough proof...
>
>>
>>>
>>> Your change will remove this timing for balance, I think you may need
>>> some test to prove that this patch will make things better.
>>
>> I see. Yes, test data is always good. :)
>> Do you have any suggestion like using what kind of test program to
>> collect this data?
>
> Any workload which require a good balance to check whether the patch
> cause damage, any workload which is latency-sensitive to check whether
> the patch bring benefit, what about kernbench with enough threads firstly?
>
> Actually all the popular benchmark worth a try, until some improvement
> was found, if after all the test, still no benefit located, then the
> idea may have to be dropped...

I try several benchmark, like cyclictest, sysbench...
But seems the score it report shows get benefit little.

However, since this change is applying towards idle path, the benchmark maybe
wrong direction to illustrate its correctness.

Suppose we are having two cpu socket/cluster, and two cpus in each
socket/cluster.
And socket 0's two cpus are idle, socket 1's  one cpu has two pined
task, another is also idle.

In such case, scheduler would keep wake the cpu0 in socket 0, and let
it do the nohz balance.
But for two tasks in socket1/cpu0 is pined, so it cannot be moved.
So result is socket 0 would be waken up at least every scheduler tick.

If in such scenario, scheduler choose socket1/cpu1 with the patch
applied, the whole system's power
could be reduced, since waking up cpu0 over socket0 would increase
addition socket/cluster power.

Could it be one proof to support this patch?

Thanks,
Lei

>
> Regards,
> Michael Wang
>
>>
>> Thanks,
>> Lei
>>
>>>
>>> Regards,
>>> Michael Wang
>>>
>>>>
>>>> However, the original purpose to add this logic still looks good.
>>>> So we move this kind of logic to find_new_ilb, so that we could pick
>>>> out peer from our sharing resource domain whenever possible.
>>>>
>>>> Signed-off-by: Lei Wen <leiwen@marvell.com>
>>>> ---
>>>>  kernel/sched/fair.c |   28 ++++++++++++++++++++++------
>>>>  1 file changed, 22 insertions(+), 6 deletions(-)
>>>>
>>>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>>>> index c61a614..64f9120 100644
>>>> --- a/kernel/sched/fair.c
>>>> +++ b/kernel/sched/fair.c
>>>> @@ -5368,10 +5368,31 @@ static struct {
>>>>       unsigned long next_balance;     /* in jiffy units */
>>>>  } nohz ____cacheline_aligned;
>>>>
>>>> +/*
>>>> + * Add the heuristic logic to try waking up idle cpu from
>>>> + * those peers who share resources with us, so that the
>>>> + * cost would be brought to minimum.
>>>> + */
>>>>  static inline int find_new_ilb(int call_cpu)
>>>>  {
>>>> -     int ilb = cpumask_first(nohz.idle_cpus_mask);
>>>> +     int ilb = nr_cpu_ids;
>>>> +     struct sched_domain *sd;
>>>> +
>>>> +     rcu_read_lock();
>>>> +     for_each_domain(call_cpu, sd) {
>>>> +             /* We loop till sched_domain no longer share resource */
>>>> +             if (!(sd->flags & SD_SHARE_PKG_RESOURCES)) {
>>>> +                     ilb = cpumask_first(nohz.idle_cpus_mask);
>>>> +                     break;
>>>> +             }
>>>>
>>>> +             /* else, we would try to pick the idle cpu from peers first */
>>>> +             ilb = cpumask_first_and(nohz.idle_cpus_mask,
>>>> +                             sched_domain_span(sd));
>>>> +             if (ilb < nr_cpu_ids)
>>>> +                     break;
>>>> +     }
>>>> +     rcu_read_unlock();
>>>>       if (ilb < nr_cpu_ids && idle_cpu(ilb))
>>>>               return ilb;
>>>>
>>>> @@ -5620,8 +5641,6 @@ end:
>>>>   * Current heuristic for kicking the idle load balancer in the presence
>>>>   * of an idle cpu is the system.
>>>>   *   - This rq has more than one task.
>>>> - *   - At any scheduler domain level, this cpu's scheduler group has multiple
>>>> - *     busy cpu's exceeding the group's power.
>>>>   *   - For SD_ASYM_PACKING, if the lower numbered cpu's in the scheduler
>>>>   *     domain span are idle.
>>>>   */
>>>> @@ -5659,9 +5678,6 @@ static inline int nohz_kick_needed(struct rq *rq, int cpu)
>>>>               struct sched_group_power *sgp = sg->sgp;
>>>>               int nr_busy = atomic_read(&sgp->nr_busy_cpus);
>>>>
>>>> -             if (sd->flags & SD_SHARE_PKG_RESOURCES && nr_busy > 1)
>>>> -                     goto need_kick_unlock;
>>>> -
>>>>               if (sd->flags & SD_ASYM_PACKING && nr_busy != sg->group_weight
>>>>                   && (cpumask_first_and(nohz.idle_cpus_mask,
>>>>                                         sched_domain_span(sd)) < cpu))
>>>>
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>
