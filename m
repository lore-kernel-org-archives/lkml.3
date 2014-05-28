Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754003AbaE1GuB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 02:50:01 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:59436 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873AbaE1GuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 02:50:00 -0400
MIME-Version: 1.0
In-Reply-To: <CAKfTPtCZx4i5HFnma3EFYjxVHojUAkezSS7jL7KDTgwvKEVFwQ@mail.gmail.com>
References: <1400860385-14555-1-git-send-email-vincent.guittot@linaro.org>
 <1400860385-14555-3-git-send-email-vincent.guittot@linaro.org>
 <20140527124848.GQ30445@twins.programming.kicks-ass.net> <CAKfTPtAbnDdQ=C6oABtwUPr7ADhHo1qsdzt5GFsuVMncA9Q=Qw@mail.gmail.com>
 <20140527153937.GE19143@laptop.programming.kicks-ass.net> <CAKfTPtCZx4i5HFnma3EFYjxVHojUAkezSS7jL7KDTgwvKEVFwQ@mail.gmail.com>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Wed, 28 May 2014 08:49:39 +0200
Message-ID: <CAKfTPtB_4bQxBOUJ4tCFRVqzHDRVXj3YPkyzyTv_h-sgm8NwEQ@mail.gmail.com>
Subject: Re: [PATCH v2 02/11] sched: remove a wake_affine condition
To: Peter Zijlstra <peterz@infradead.org>, npiggin@gmail.com
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

Using another email address for Nick

On 27 May 2014 18:14, Vincent Guittot <vincent.guittot@linaro.org> wrote:
> On 27 May 2014 17:39, Peter Zijlstra <peterz@infradead.org> wrote:
>> On Tue, May 27, 2014 at 05:19:02PM +0200, Vincent Guittot wrote:
>>> On 27 May 2014 14:48, Peter Zijlstra <peterz@infradead.org> wrote:
>>> > On Fri, May 23, 2014 at 05:52:56PM +0200, Vincent Guittot wrote:
>>> >> I have tried to understand the meaning of the condition :
>>> >>  (this_load <= load &&
>>> >>   this_load + target_load(prev_cpu, idx) <= tl_per_task)
>>> >> but i failed to find a use case that can take advantage of it and i haven't
>>> >> found description of it in the previous commits' log.
>>> >
>>> > commit 2dd73a4f09beacadde827a032cf15fd8b1fa3d48
>>> >
>>> >     int try_to_wake_up():
>>> >
>>> >     in this function the value SCHED_LOAD_BALANCE is used to represent the load
>>> >     contribution of a single task in various calculations in the code that
>>> >     decides which CPU to put the waking task on.  While this would be a valid
>>> >     on a system where the nice values for the runnable tasks were distributed
>>> >     evenly around zero it will lead to anomalous load balancing if the
>>> >     distribution is skewed in either direction.  To overcome this problem
>>> >     SCHED_LOAD_SCALE has been replaced by the load_weight for the relevant task
>>> >     or by the average load_weight per task for the queue in question (as
>>> >     appropriate).
>>> >
>>> >                         if ((tl <= load &&
>>> > -                               tl + target_load(cpu, idx) <= SCHED_LOAD_SCALE) ||
>>> > -                               100*(tl + SCHED_LOAD_SCALE) <= imbalance*load) {
>>> > +                               tl + target_load(cpu, idx) <= tl_per_task) ||
>>> > +                               100*(tl + p->load_weight) <= imbalance*load) {
>>>
>>> The oldest patch i had found was: https://lkml.org/lkml/2005/2/24/34
>>> where task_hot had been replaced by
>>> + if ((tl <= load &&
>>> + tl + target_load(cpu, idx) <= SCHED_LOAD_SCALE) ||
>>> + 100*(tl + SCHED_LOAD_SCALE) <= imbalance*load) {
>>>
>>> but as explained, i haven't found a clear explanation of this condition
>>
>> Yeah, that's the commit I had below; but I suppose we could ask Nick if
>> we really want, I've heard he still replies to email, even though he's
>> locked up in a basement somewhere :-)

ok, I have added him in the list

Nick,

While doing some rework on the wake affine part of the scheduler, i
failed to catch the use case that takes advantage of a condition that
you added some while ago with the commit
a3f21bce1fefdf92a4d1705e888d390b10f3ac6f

Could you help us to clarify the 2 first lines of the test that you added ?
+                       if ((tl <= load &&
+                               tl + target_load(cpu, idx) <=
SCHED_LOAD_SCALE) ||
+                               100*(tl + SCHED_LOAD_SCALE) <= imbalance*load) {

Regards,
Vincent
>
>>
>>> > commit a3f21bce1fefdf92a4d1705e888d390b10f3ac6f
>>> >
>>> >
>>> > +                       if ((tl <= load &&
>>> > +                               tl + target_load(cpu, idx) <= SCHED_LOAD_SCALE) ||
>>> > +                               100*(tl + SCHED_LOAD_SCALE) <= imbalance*load) {
>>> >
>>> >
>>> > So back when the code got introduced, it read:
>>> >
>>> >         target_load(prev_cpu, idx) - sync*SCHED_LOAD_SCALE < source_load(this_cpu, idx) &&
>>> >         target_load(prev_cpu, idx) - sync*SCHED_LOAD_SCALE + target_load(this_cpu, idx) < SCHED_LOAD_SCALE
>>> >
>>> > So while the first line makes some sense, the second line is still
>>> > somewhat challenging.
>>> >
>>> > I read the second line something like: if there's less than one full
>>> > task running on the combined cpus.
>>>
>>> ok. your explanation makes sense
>>
>> Maybe, its still slightly weird :-)
>>
>>> >
>>> > Now for idx==0 this is hard, because even when sync=1 you can only make
>>> > it true if both cpus are completely idle, in which case you really want
>>> > to move to the waking cpu I suppose.
>>>
>>> This use case is already taken into account by
>>>
>>> if (this_load > 0)
>>> ..
>>> else
>>>  balance = true
>>
>> Agreed.
>>
>>> > One task running will have it == SCHED_LOAD_SCALE.
>>> >
>>> > But for idx>0 this can trigger in all kinds of situations of light load.
>>>
>>> target_load is the max between load for idx == 0 and load for the
>>> selected idx so we have even less chance to match the condition : both
>>> cpu are completely idle
>>
>> Ah, yes, I forgot to look at the target_load() thing and missed the max,
>> yes that all makes it entirely less likely.
