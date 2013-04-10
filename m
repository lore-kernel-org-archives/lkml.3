Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935862Ab3DJGzl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 02:55:41 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:45964 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725Ab3DJGzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 02:55:39 -0400
MIME-Version: 1.0
In-Reply-To: <51650185.9060905@linux.vnet.ibm.com>
References: <1364873008-3169-1-git-send-email-alex.shi@intel.com>
	<1364873008-3169-7-git-send-email-alex.shi@intel.com>
	<CAKfTPtBoV3KoSHuTnZVrvPdCM+5ckFGXfM11oCB1Le_Zmy1hYQ@mail.gmail.com>
	<51650185.9060905@linux.vnet.ibm.com>
Date: Wed, 10 Apr 2013 08:55:37 +0200
Message-ID: <CAKfTPtDUfLTXuYcROhWmzqu6_QY0LM8EvmYoRtJw9wneK0yyCw@mail.gmail.com>
Subject: Re: [patch v3 6/8] sched: consider runnable load average in move_tasks
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Michael Wang <wangyun@linux.vnet.ibm.com>, Alex Shi <alex.shi@intel.com>
Cc: "mingo@redhat.com" <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>, Paul Turner <pjt@google.com>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        gregkh@linuxfoundation.org,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Len Brown <len.brown@intel.com>, rafael.j.wysocki@intel.com,
        jkosina@suse.cz, Clark Williams <clark.williams@gmail.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>, keescook@chromium.org,
        Mel Gorman <mgorman@suse.de>, riel@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10 April 2013 08:07, Michael Wang <wangyun@linux.vnet.ibm.com> wrote:
> On 04/09/2013 03:08 PM, Vincent Guittot wrote:
>> On 2 April 2013 05:23, Alex Shi <alex.shi@intel.com> wrote:
>>> Except using runnable load average in background, move_tasks is also
>>> the key functions in load balance. We need consider the runnable load
>>> average in it in order to the apple to apple load comparison.
>>>
>>> Signed-off-by: Alex Shi <alex.shi@intel.com>
>>> ---
>>>  kernel/sched/fair.c | 11 ++++++++++-
>>>  1 file changed, 10 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>>> index 1f9026e..bf4e0d4 100644
>>> --- a/kernel/sched/fair.c
>>> +++ b/kernel/sched/fair.c
>>> @@ -3966,6 +3966,15 @@ static unsigned long task_h_load(struct task_struct *p);
>>>
>>>  static const unsigned int sched_nr_migrate_break = 32;
>>>
>>> +static unsigned long task_h_load_avg(struct task_struct *p)
>>> +{
>>> +       u32 period = p->se.avg.runnable_avg_period;
>>> +       if (!period)
>>> +               return 0;
>>> +
>>> +       return task_h_load(p) * p->se.avg.runnable_avg_sum / period;
>>
>> How do you ensure that runnable_avg_period and runnable_avg_sum are
>> coherent ? an update of the statistic can occur in the middle of your
>> sequence.
>
> Hi, Vincent
>
> Don't we have the 'rq->lock' to protect it?
>
> move_tasks() was invoked with double locked, for all the se on src and
> dst rq, no update should happen, isn't it?

you're right, the double lock protect against concurrent access my
remark doesn't apply here

Regards,
Vincent

>
> Regards,
> Michael Wang
>
>>
>> Vincent
>>
>>> +}
>>> +
>>>  /*
>>>   * move_tasks tries to move up to imbalance weighted load from busiest to
>>>   * this_rq, as part of a balancing operation within domain "sd".
>>> @@ -4001,7 +4010,7 @@ static int move_tasks(struct lb_env *env)
>>>                 if (throttled_lb_pair(task_group(p), env->src_cpu, env->dst_cpu))
>>>                         goto next;
>>>
>>> -               load = task_h_load(p);
>>> +               load = task_h_load_avg(p);
>>>
>>>                 if (sched_feat(LB_MIN) && load < 16 && !env->sd->nr_balance_failed)
>>>                         goto next;
>>> --
>>> 1.7.12
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
