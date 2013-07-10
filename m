Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166Ab3GJCMx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 22:12:53 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:41062 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753627Ab3GJCMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 22:12:52 -0400
Message-ID: <51DCC31B.7010805@linux.vnet.ibm.com>
Date: Wed, 10 Jul 2013 10:12:43 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Sam Ben <sam.bennn@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
        Alex Shi <alex.shi@intel.com>, Namhyung Kim <namhyung@kernel.org>,
        Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH v3 1/2] sched: smart wake-affine foundation
References: <51D50024.10902@linux.vnet.ibm.com> <51D50057.9000809@linux.vnet.ibm.com> <51D8C4F7.2010603@gmail.com> <51DA25A4.2050803@linux.vnet.ibm.com> <51DCBE49.9000806@gmail.com>
In-Reply-To: <51DCBE49.9000806@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13071002-3864-0000-0000-000009013CF5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2013 09:52 AM, Sam Ben wrote:
> On 07/08/2013 10:36 AM, Michael Wang wrote:
>> Hi, Sam
>>
>> On 07/07/2013 09:31 AM, Sam Ben wrote:
>>> On 07/04/2013 12:55 PM, Michael Wang wrote:
>>>> wake-affine stuff is always trying to pull wakee close to waker, by
>>>> theory,
>>>> this will bring benefit if waker's cpu cached hot data for wakee, or
>>>> the
>>>> extreme ping-pong case.
>>> What's the meaning of ping-pong case?
>> PeterZ explained it well in here:
>>
>>     https://lkml.org/lkml/2013/3/7/332
>>
>> And you could try to compare:
>>     taskset 1 perf bench sched pipe
>> with
>>     perf bench sched pipe
> 
> Why sched pipe is special?

I think the link already explained the reason well, or you can read the
code of that pipe implementation, and you will find out there is a high
chances to match the ping-pong cases :)

Regards,
Michael Wang

> 
>>
>> to confirm it ;-)
>>
>> Regards,
>> Michael Wang
>>
>>>> And testing show it could benefit hackbench 15% at most.
>>>>
>>>> However, the whole stuff is somewhat blindly and time-consuming, some
>>>> workload therefore suffer.
>>>>
>>>> And testing show it could damage pgbench 50% at most.
>>>>
>>>> Thus, wake-affine stuff should be more smart, and realise when to stop
>>>> it's thankless effort.
>>>>
>>>> This patch introduced 'nr_wakee_switch', which will be increased each
>>>> time the task switch it's wakee.
>>>>
>>>> So a high 'nr_wakee_switch' means the task has more than one wakee, and
>>>> bigger the number, higher the wakeup frequency.
>>>>
>>>> Now when making the decision on whether to pull or not, pay
>>>> attention on
>>>> the wakee with a high 'nr_wakee_switch', pull such task may benefit
>>>> wakee,
>>>> but also imply that waker will face cruel competition later, it
>>>> could be
>>>> very cruel or very fast depends on the story behind 'nr_wakee_switch',
>>>> whatever, waker therefore suffer.
>>>>
>>>> Furthermore, if waker also has a high 'nr_wakee_switch', imply that
>>>> multiple
>>>> tasks rely on it, then waker's higher latency will damage all of them,
>>>> pull
>>>> wakee seems to be a bad deal.
>>>>
>>>> Thus, when 'waker->nr_wakee_switch / wakee->nr_wakee_switch' become
>>>> higher
>>>> and higher, the deal seems to be worse and worse.
>>>>
>>>> The patch therefore help wake-affine stuff to stop it's work when:
>>>>
>>>>      wakee->nr_wakee_switch > factor &&
>>>>      waker->nr_wakee_switch > (factor * wakee->nr_wakee_switch)
>>>>
>>>> The factor here is the node-size of current-cpu, so bigger node will
>>>> lead
>>>> to more pull since the trial become more severe.
>>>>
>>>> After applied the patch, pgbench show 40% improvement at most.
>>>>
>>>> Test:
>>>>      Tested with 12 cpu X86 server and tip 3.10.0-rc7.
>>>>
>>>>      pgbench            base    smart
>>>>
>>>>      | db_size | clients |  tps  |    |  tps  |
>>>>      +---------+---------+-------+   +-------+
>>>>      | 22 MB   |       1 | 10598 |   | 10796 |
>>>>      | 22 MB   |       2 | 21257 |   | 21336 |
>>>>      | 22 MB   |       4 | 41386 |   | 41622 |
>>>>      | 22 MB   |       8 | 51253 |   | 57932 |
>>>>      | 22 MB   |      12 | 48570 |   | 54000 |
>>>>      | 22 MB   |      16 | 46748 |   | 55982 | +19.75%
>>>>      | 22 MB   |      24 | 44346 |   | 55847 | +25.93%
>>>>      | 22 MB   |      32 | 43460 |   | 54614 | +25.66%
>>>>      | 7484 MB |       1 |  8951 |   |  9193 |
>>>>      | 7484 MB |       2 | 19233 |   | 19240 |
>>>>      | 7484 MB |       4 | 37239 |   | 37302 |
>>>>      | 7484 MB |       8 | 46087 |   | 50018 |
>>>>      | 7484 MB |      12 | 42054 |   | 48763 |
>>>>      | 7484 MB |      16 | 40765 |   | 51633 | +26.66%
>>>>      | 7484 MB |      24 | 37651 |   | 52377 | +39.11%
>>>>      | 7484 MB |      32 | 37056 |   | 51108 | +37.92%
>>>>      | 15 GB   |       1 |  8845 |   |  9104 |
>>>>      | 15 GB   |       2 | 19094 |   | 19162 |
>>>>      | 15 GB   |       4 | 36979 |   | 36983 |
>>>>      | 15 GB   |       8 | 46087 |   | 49977 |
>>>>      | 15 GB   |      12 | 41901 |   | 48591 |
>>>>      | 15 GB   |      16 | 40147 |   | 50651 | +26.16%
>>>>      | 15 GB   |      24 | 37250 |   | 52365 | +40.58%
>>>>      | 15 GB   |      32 | 36470 |   | 50015 | +37.14%
>>>>
>>>> CC: Ingo Molnar <mingo@kernel.org>
>>>> CC: Peter Zijlstra <peterz@infradead.org>
>>>> CC: Mike Galbraith <efault@gmx.de>
>>>> Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
>>>> ---
>>>>    include/linux/sched.h |    3 +++
>>>>    kernel/sched/fair.c   |   47
>>>> +++++++++++++++++++++++++++++++++++++++++++++++
>>>>    2 files changed, 50 insertions(+), 0 deletions(-)
>>>>
>>>> diff --git a/include/linux/sched.h b/include/linux/sched.h
>>>> index 178a8d9..1c996c7 100644
>>>> --- a/include/linux/sched.h
>>>> +++ b/include/linux/sched.h
>>>> @@ -1041,6 +1041,9 @@ struct task_struct {
>>>>    #ifdef CONFIG_SMP
>>>>        struct llist_node wake_entry;
>>>>        int on_cpu;
>>>> +    struct task_struct *last_wakee;
>>>> +    unsigned long nr_wakee_switch;
>>>> +    unsigned long last_switch_decay;
>>>>    #endif
>>>>        int on_rq;
>>>>    diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>>>> index c61a614..a4ddbf5 100644
>>>> --- a/kernel/sched/fair.c
>>>> +++ b/kernel/sched/fair.c
>>>> @@ -2971,6 +2971,23 @@ static unsigned long cpu_avg_load_per_task(int
>>>> cpu)
>>>>        return 0;
>>>>    }
>>>>    +static void record_wakee(struct task_struct *p)
>>>> +{
>>>> +    /*
>>>> +     * Rough decay(wiping) for cost saving, don't worry
>>>> +     * about the boundary, really active task won't care
>>>> +     * the loose.
>>>> +     */
>>>> +    if (jiffies > current->last_switch_decay + HZ) {
>>>> +        current->nr_wakee_switch = 0;
>>>> +        current->last_switch_decay = jiffies;
>>>> +    }
>>>> +
>>>> +    if (current->last_wakee != p) {
>>>> +        current->last_wakee = p;
>>>> +        current->nr_wakee_switch++;
>>>> +    }
>>>> +}
>>>>      static void task_waking_fair(struct task_struct *p)
>>>>    {
>>>> @@ -2991,6 +3008,7 @@ static void task_waking_fair(struct
>>>> task_struct *p)
>>>>    #endif
>>>>          se->vruntime -= min_vruntime;
>>>> +    record_wakee(p);
>>>>    }
>>>>      #ifdef CONFIG_FAIR_GROUP_SCHED
>>>> @@ -3109,6 +3127,28 @@ static inline unsigned long
>>>> effective_load(struct task_group *tg, int cpu,
>>>>      #endif
>>>>    +static int wake_wide(struct task_struct *p)
>>>> +{
>>>> +    int factor = nr_cpus_node(cpu_to_node(smp_processor_id()));
>>>> +
>>>> +    /*
>>>> +     * Yeah, it's the switching-frequency, could means many wakee or
>>>> +     * rapidly switch, use factor here will just help to automatically
>>>> +     * adjust the loose-degree, so bigger node will lead to more pull.
>>>> +     */
>>>> +    if (p->nr_wakee_switch > factor) {
>>>> +        /*
>>>> +         * wakee is somewhat hot, it needs certain amount of cpu
>>>> +         * resource, so if waker is far more hot, prefer to leave
>>>> +         * it alone.
>>>> +         */
>>>> +        if (current->nr_wakee_switch > (factor * p->nr_wakee_switch))
>>>> +            return 1;
>>>> +    }
>>>> +
>>>> +    return 0;
>>>> +}
>>>> +
>>>>    static int wake_affine(struct sched_domain *sd, struct task_struct
>>>> *p, int sync)
>>>>    {
>>>>        s64 this_load, load;
>>>> @@ -3118,6 +3158,13 @@ static int wake_affine(struct sched_domain *sd,
>>>> struct task_struct *p, int sync)
>>>>        unsigned long weight;
>>>>        int balanced;
>>>>    +    /*
>>>> +     * If we wake multiple tasks be careful to not bounce
>>>> +     * ourselves around too much.
>>>> +     */
>>>> +    if (wake_wide(p))
>>>> +        return 0;
>>>> +
>>>>        idx      = sd->wake_idx;
>>>>        this_cpu  = smp_processor_id();
>>>>        prev_cpu  = task_cpu(p);
>>> -- 
>>> To unsubscribe from this list: send the line "unsubscribe
>>> linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
>>>
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

