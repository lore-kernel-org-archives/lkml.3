Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754407Ab3AVI4b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 03:56:31 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:39241 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221Ab3AVI43 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 03:56:29 -0500
Message-ID: <50FE5433.1070801@linux.vnet.ibm.com>
Date: Tue, 22 Jan 2013 16:56:19 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Mike Galbraith <bitbucket@online.de>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, peterz@infradead.org,
        mingo@kernel.org, a.p.zijlstra@chello.nl
Subject: Re: [RFC PATCH 0/2] sched: simplify the select_task_rq_fair()
References: <1356588535-23251-1-git-send-email-wangyun@linux.vnet.ibm.com> <50ED384C.1030301@linux.vnet.ibm.com> <1357977704.6796.47.camel@marge.simpson.net> <1357985943.6796.55.camel@marge.simpson.net> <1358155290.5631.19.camel@marge.simpson.net> <50F79256.1010900@linux.vnet.ibm.com> <1358654997.5743.17.camel@marge.simpson.net> <50FCACE3.5000706@linux.vnet.ibm.com> <1358743128.4994.33.camel@marge.simpson.net> <50FCCCF5.30504@linux.vnet.ibm.com> <1358750523.4994.55.camel@marge.simpson.net> <1358752180.4994.65.camel@marge.simpson.net> <50FCF212.3010504@linux.vnet.ibm.com> <1358759355.4994.108.camel@marge.simpson.net> <50FD08E1.8000302@linux.vnet.ibm.com> <1358761496.4994.118.camel@marge.simpson.net> <50FE0ADC.6060701@linux.vnet.ibm.com> <1358841795.5782.255.camel@marge.simpson.net>
In-Reply-To: <1358841795.5782.255.camel@marge.simpson.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13012208-4790-0000-0000-00000694469A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2013 04:03 PM, Mike Galbraith wrote:
[snip]
> ... 
>>>
>>> That was with your change backed out, and the q/d below applied.
>>
>> So that change will help to solve the issue? good to know :)
>>
>> But it will invoke wake_affine() with out any delay, the benefit
>> of the patch set will be reduced a lot...
> 
> Yeah, I used size large hammer.
> 
>> I think this change help to solve the issue because it avoid jump
>> into balance path when wakeup for any cases, I think we can do
>> some change like below to achieve this and meanwhile gain benefit
>> from delay wake_affine().
> 
> Yup, I killed it all the way dead.  I'll see what below does.
> 
> I don't really see the point of the wake_affine() change in this set
> though.  Its purpose is to decide if a pull is ok or not.  If we don't
> need its opinion when we look for an (momentarily?) idle core in
> this_domain, we shouldn't need it at all, and could just delete it.

I have a question here, so wake_affine() is:
A. check whether it is balance to pull.
B. check whether it's better to pull than not.

I suppose it's A, so my logical is:
1. find idle cpu in prev domain.
2. if failed and affine, find idle cpu in current domain.
3. if find idle cpu in current domain, check whether it is balance to
pull by wake_affine().
4. if all failed, two choice, go to balance path or directly return
prev_cpu.

So I still need wake_affine() for a final check, but to be honest, I
really doubt about whether it worth to care about balance while waking
up, if the task just run several ns then sleep again, it's totally
worthless...

> If we ever enter balance_path, we can't possibly induce imbalance without
> there being something broken in that path, no?

So your opinion is, some thing broken in the new balance path?

> 
> BTW, it could well be that an unpatched kernel will collapse as well if
> WAKE_BALANCE is turned on.  I've never tried that on a largish box, as
> doing any of the wakeup time optional stuff used to make tbench scream.
> 
>> Since the issue could not been reproduced on my side, I don't know
>> whether the patch benefit or not, so if you are willing to send out
>> a formal patch, I would be glad to include it in my patch set ;-)
> 
> Just changing to scan prev_cpu before considering pulling would put a
> big dent in the bouncing cow problem, but that's the intriguing thing
> about this set.. 

So that's my first question, if wake_affine() return 1 means it's better
to pull than not, then the new way may be harmful, but if it's just told
us, pull won't break the balance, then I still think, current domain is
just a backup, not the candidate of first choice.

can we have the tbench and pgbench big box gain without
> a lot of pain to go with it?  Small boxen will surely benefit, pretty
> much can't be hurt, but what about all those fast/light tasks that won't
> hop across nodes to red hot data?

I don't get it... a task won't hop means a task always been selected to
run on prev_cpu?

We will assign idle cpu if we found, but if not, we can use prev_cpu or
go to balance path and find one, so what's the problem here?

> 
> No formal patch is likely to result from any testing I do atm at least.
> I'm testing your patches because I see potential, I really want it to
> work out, but have to see it do that with my own two beady eyeballs ;-)

Got it.

> 
>> And another patch below below is a debug one, which will print out
>> all the sbm info, so we could check whether it was initialized
>> correctly, just use command "dmesg | grep WYT" to show the map.

What about this patch? May be the wrong map is the killer on balance
path, should we check it? ;-)

Regards,
Michael Wang

>>
>> Regards,
>> Michael Wang
>>
>> ---
>>  kernel/sched/fair.c |   42 +++++++++++++++++++++++++-----------------
>>  1 files changed, 25 insertions(+), 17 deletions(-)
>>
>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>> index 2aa26c1..4361333 100644
>> --- a/kernel/sched/fair.c
>> +++ b/kernel/sched/fair.c
>> @@ -3250,7 +3250,7 @@ find_idlest_cpu(struct sched_group *group, struct task_struct *p, int this_cpu)
>>  }
>>
>>  /*
>> - * Try and locate an idle CPU in the sched_domain.
>> + * Try and locate an idle CPU in the sched_domain, return -1 if failed.
>>   */
>>  static int select_idle_sibling(struct task_struct *p, int target)
>>  {
>> @@ -3292,13 +3292,13 @@ static int select_idle_sibling(struct task_struct *p, int target)
>>
>>                         target = cpumask_first_and(sched_group_cpus(sg),
>>                                         tsk_cpus_allowed(p));
>> -                       goto done;
>> +                       return target;
>>  next:
>>                         sg = sg->next;
>>                 } while (sg != sd->groups);
>>         }
>> -done:
>> -       return target;
>> +
>> +       return -1;
>>  }
>>
>>  /*
>> @@ -3342,40 +3342,48 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
>>                  * may has already been cached on prev_cpu, and usually
>>                  * they require low latency.
>>                  *
>> -                * So firstly try to locate an idle cpu shared the cache
>> +                * Therefor, balance path in such case will cause damage
>> +                * and bring benefit synchronously, wakeup on prev_cpu
>> +                * may better than wakeup on a new lower load cpu for the
>> +                * cached memory, and we never know.
>> +                *
>> +                * So the principle is, try to find an idle cpu as close to
>> +                * prev_cpu as possible, if failed, just take prev_cpu.
>> +                *
>> +                * Firstly try to locate an idle cpu shared the cache
>>                  * with prev_cpu, it has the chance to break the load
>>                  * balance, fortunately, select_idle_sibling() will search
>>                  * from top to bottom, which help to reduce the chance in
>>                  * some cases.
>>                  */
>>                 new_cpu = select_idle_sibling(p, prev_cpu);
>> -               if (idle_cpu(new_cpu))
>> +               if (new_cpu != -1)
>>                         goto unlock;
>>
>>                 /*
>>                  * No idle cpu could be found in the topology of prev_cpu,
>> -                * before jump into the slow balance_path, try search again
>> -                * in the topology of current cpu if it is the affine of
>> -                * prev_cpu.
>> +                * before take the prev_cpu, try search again in the
>> +                * topology of current cpu if it is the affine of prev_cpu.
>>                  */
>> -               if (cpu == prev_cpu ||
>> -                               !sbm->affine_map[prev_cpu] ||
>> +               if (cpu == prev_cpu || !sbm->affine_map[prev_cpu] ||
>>                                 !cpumask_test_cpu(cpu, tsk_cpus_allowed(p)))
>> -                       goto balance_path;
>> +                       goto take_prev;
>>
>>                 new_cpu = select_idle_sibling(p, cpu);
>> -               if (!idle_cpu(new_cpu))
>> -                       goto balance_path;
>> -
>>                 /*
>>                  * Invoke wake_affine() finally since it is no doubt a
>>                  * performance killer.
>>                  */
>> -               if (wake_affine(sbm->affine_map[prev_cpu], p, sync))
>> +               if ((new_cpu != -1) &&
>> +                       wake_affine(sbm->affine_map[prev_cpu], p, sync))
>>                         goto unlock;
>> +
>> +take_prev:
>> +               new_cpu = prev_cpu;
>> +               goto unlock;
>>         }
>>
>> -balance_path:
>> +       /* Balance path. */
>>         new_cpu = (sd_flag & SD_BALANCE_WAKE) ? prev_cpu : cpu;
>>         sd = sbm->sd[type][sbm->top_level[type]];
>>
>> -- 
>> 1.7.4.1
>>
>> DEBUG PATCH:
>>
>> ---
>>  kernel/sched/core.c |   30 ++++++++++++++++++++++++++++++
>>  1 files changed, 30 insertions(+), 0 deletions(-)
>>
>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>> index 0c63303..f251f29 100644
>> --- a/kernel/sched/core.c
>> +++ b/kernel/sched/core.c
>> @@ -5578,6 +5578,35 @@ static void update_top_cache_domain(int cpu)
>>  static int sbm_max_level;
>>  DEFINE_PER_CPU_SHARED_ALIGNED(struct sched_balance_map, sbm_array);
>>
>> +static void debug_sched_balance_map(int cpu)
>> +{
>> +       int i, type, level = 0;
>> +       struct sched_balance_map *sbm = &per_cpu(sbm_array, cpu);
>> +
>> +       printk("WYT: sbm of cpu %d\n", cpu);
>> +
>> +       for (type = 0; type < SBM_MAX_TYPE; type++) {
>> +               if (type == SBM_EXEC_TYPE)
>> +                       printk("WYT: \t exec map\n");
>> +               else if (type == SBM_FORK_TYPE)
>> +                       printk("WYT: \t fork map\n");
>> +               else if (type == SBM_WAKE_TYPE)
>> +                       printk("WYT: \t wake map\n");
>> +
>> +               for (level = 0; level < sbm_max_level; level++) {
>> +                       if (sbm->sd[type][level])
>> +                               printk("WYT: \t\t sd %x, idx %d, level %d, weight %d\n", sbm->sd[type][level], level, sbm->sd[type][level]->level, sbm->sd[type][level]->span_weight);
>> +               }
>> +       }
>> +
>> +       printk("WYT: \t affine map\n");
>> +
>> +       for_each_possible_cpu(i) {
>> +               if (sbm->affine_map[i])
>> +                       printk("WYT: \t\t affine with cpu %x in sd %x, weight %d\n", i, sbm->affine_map[i], sbm->affine_map[i]->span_weight);
>> +       }
>> +}
>> +
>>  static void build_sched_balance_map(int cpu)
>>  {
>>         struct sched_balance_map *sbm = &per_cpu(sbm_array, cpu);
>> @@ -5688,6 +5717,7 @@ cpu_attach_domain(struct sched_domain *sd, struct root_domain *rd, int cpu)
>>          * destroy_sched_domains() already do the work.
>>          */
>>         build_sched_balance_map(cpu);
>> +       debug_sched_balance_map(cpu);
>>         rcu_assign_pointer(rq->sbm, sbm);
>>  }
>>
> 
> 

