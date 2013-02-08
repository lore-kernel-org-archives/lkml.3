Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946772Ab3BHRJk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 12:09:40 -0500
Received: from mail-bk0-f44.google.com ([209.85.214.44]:57780 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946596Ab3BHRJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 12:09:39 -0500
MIME-Version: 1.0
In-Reply-To: <CAFTL4hzriJm1mK1A_9U5kX9Z0RCMGpxy8M3gKuzFtt9Bky5htQ@mail.gmail.com>
References: <1359455940-1710-1-git-send-email-vincent.guittot@linaro.org>
	<1359455940-1710-2-git-send-email-vincent.guittot@linaro.org>
	<CAFTL4hzboD8Mv_-pRDHc+39QwXGWiT3MGtL8gJ=_ajnHdDCBcA@mail.gmail.com>
	<CAKfTPtD2jRke2CUXiJdmaYYki_Voi4eTqJKgsyTnRpna7p8mJg@mail.gmail.com>
	<CAFTL4hzriJm1mK1A_9U5kX9Z0RCMGpxy8M3gKuzFtt9Bky5htQ@mail.gmail.com>
Date: Fri, 8 Feb 2013 18:09:37 +0100
Message-ID: <CAKfTPtCWudftS2XSM1OC2sR050mYvcAU6Fkt0vjV=C2V+w84Ew@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] sched: fix init NOHZ_IDLE flag
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        peterz@infradead.org, mingo@kernel.org, Mike Galbraith <efault@gmx.de>,
        Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 February 2013 16:35, Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 2013/2/4 Vincent Guittot <vincent.guittot@linaro.org>:
>> On 1 February 2013 19:03, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>>>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>>>> index 257002c..fd41924 100644
>>>> --- a/kernel/sched/core.c
>>>> +++ b/kernel/sched/core.c
>>>> @@ -5884,6 +5884,7 @@ static void init_sched_groups_power(int cpu, struct sched_domain *sd)
>>>>
>>>>         update_group_power(sd, cpu);
>>>>         atomic_set(&sg->sgp->nr_busy_cpus, sg->group_weight);
>>>> +       clear_bit(NOHZ_IDLE, nohz_flags(cpu));
>>>
>>> So that's a real issue indeed.  nr_busy_cpus was never correct.
>>>
>>> Now I'm still a bit worried with this solution. What if an idle task
>>> started in smp_init() has not yet stopped its tick, but is about to do
>>> so? The domains are not yet available to the task but the nohz flags
>>> are. When it later restarts the tick, it's going to erroneously
>>> increase nr_busy_cpus.
>>
>> My 1st idea was to clear NOHZ_IDLE flag and nr_busy_cpus in
>> init_sched_groups_power instead of setting them as it is done now. If
>> a CPU enters idle during the init sequence, the flag is already
>> cleared, and nohz_flags and nr_busy_cpus will stay synced and cleared
>> while a NULL sched_domain is attached to the CPU thanks to patch 2.
>> This should solve all use cases ?
>
> This may work on smp_init(). But the per cpu domain can be changed concurrently
> anytime on cpu hotplug, with a new sched group power struct, right?

During a cpu hotplug, a null domain is attached to each CPU of the
partition because we have to build new sched_domains so we have a
similar behavior than smp_init.
So if we clear  NOHZ_IDLE flag and nr_busy_cpus in
init_sched_groups_power, we should be safe for init and hotplug.

More generally speaking, if the sched_domains of a group of CPUs must
be rebuilt, a NULL sched_domain is attached to these CPUs during the
build

>
> What if the following happen (inventing function names but you get the idea):
>
> CPU 0                                           CPU 1
>
> dom = new_domain(...) {
>            nr_cpus_busy = 0;
>            set_idle(CPU 1);                  old_dom =get_dom()
>                                                      clear_idle(CPU 1)
> }
> rcu_assign_pointer(cpu1_dom, dom);
>
>
> Can this scenario happen?

This scenario will be:

 CPU 0                                           CPU 1

 detach_and_destroy_domain {
            rcu_assign_pointer(cpu1_dom, NULL);
 }

 dom = new_domain(...) {
            nr_cpus_busy = 0;
            set_idle(CPU 1);                  old_dom =get_dom()
                                                      old_dom is null
                                                      //clear_idle(CPU
1) can't happen because a null domain is attached so we will never
call nohz_kick_needed which is the only place where we can clear_idle
 }
 rcu_assign_pointer(cpu1_dom, dom);

>
>
>>>
>>> It probably won't happen in practice. But then there is more: sched
>>> domains can be concurrently rebuild anytime, right?  So what if we
>>> call set_cpu_sd_state_idle() and decrease nr_busy_cpus while the
>>> domain is switched concurrently. Are we having a new sched group along
>>> the way? If so we have a bug here as well because we can have
>>> NOHZ_IDLE set but nr_busy_cpus accounting the CPU.
>>
>> When the sched_domain are rebuilt, we set a null sched_domain during
>> the rebuild sequence and a new sched_group_power is created as well
>
> So at that time we may race with a CPU setting/clearing its NOHZ_IDLE flag
> as in my above scenario?

Unless i have missed a use case, we always have a null domain attached
to a CPU while we build the new one. So the patch 2/2 should protect
us against clearing the NOHZ_IDLE whereas the new nr_busy_cpus is not
yet attached.

I'm going to send a new version which set the NOHZ_IDLE bit and clear
nr_busy_cpus during the built of a sched_domain

Vincent
