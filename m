Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965573Ab3FUCuf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 22:50:35 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:42568 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965335Ab3FUCue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 22:50:34 -0400
MIME-Version: 1.0
In-Reply-To: <51C3BCE1.1080405@gmail.com>
References: <1370589652-24549-1-git-send-email-alex.shi@intel.com>
	<1370589652-24549-5-git-send-email-alex.shi@intel.com>
	<CAPM31RLB6nN+qN8UNq0RXiRYKaFZ6GYVP-=kZMR8-rkP9831Bw@mail.gmail.com>
	<51BF2E37.5040400@intel.com>
	<CALZhoSSweOzTgjykRMxv_kha9TH-8EAKvuhinf8ADFyFDzDTuQ@mail.gmail.com>
	<CALZhoSSFr_HN9ccxNLK7HA-7O9soAU7VZ3njtKf=Ndw=_AbQRw@mail.gmail.com>
	<51C318D6.4090601@gmail.com>
	<CALZhoSQgO-V-vkOy+urL_H4cjcCE8YY3w+K=mS8hptWteKGcFw@mail.gmail.com>
	<51C3BCE1.1080405@gmail.com>
Date: Fri, 21 Jun 2013 10:50:32 +0800
Message-ID: <CALZhoSR8pLfqO+XfEfHB3-UuV5_xu=AV2mCf2BQgaaQoWd-tbw@mail.gmail.com>
Subject: Re: [patch v8 4/9] sched: fix slept time double counting in enqueue entity
From: Lei Wen <adrian.wenl@gmail.com>
To: Alex Shi <seakeel@gmail.com>
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

Alex,

On Fri, Jun 21, 2013 at 10:39 AM, Alex Shi <seakeel@gmail.com> wrote:
> On 06/21/2013 10:30 AM, Lei Wen wrote:
>> Hi Alex,
>>
>> On Thu, Jun 20, 2013 at 10:59 PM, Alex Shi <seakeel@gmail.com> wrote:
>>> On 06/20/2013 10:46 AM, Lei Wen wrote:
>>>>
>>>>
>>>> But here I have a question, there is another usage of __synchronzie_entity_decay
>>>> in current kernel, in the switched_from_fair function.
>>>>
>>>> If task being frequently switched between rt and fair class, would it
>>>> also bring the
>>>> redundant issue? Do we need patch like below?
>>>>
>>>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>>>> index b5408e1..9640c66 100644
>>>> --- a/kernel/sched/fair.c
>>>> +++ b/kernel/sched/fair.c
>>>> @@ -5856,7 +5856,7 @@ static void switched_from_fair(struct rq *rq,
>>>> struct task_struct *p)
>>>>         */
>>>>         if (p->se.avg.decay_count) {
>>>>                 struct cfs_rq *cfs_rq = cfs_rq_of(&p->se);
>>>> -               se->avg.last_runnable_update +=
>>>> +               p->se.avg.last_runnable_update +=
>>>
>>> what tree does this patch base on?
>>
>> I create the patch based on v3.9 kernel.
>> If it is ok, I could create a formal one based on latest kernel.
>
> In the linus tree, the first commit which introduced
> __synchronize_entity_decay(&p->se) here is
> 9ee474f55664ff63111c843099d365e7ecffb56f
> +
> +#if defined(CONFIG_FAIR_GROUP_SCHED) && defined(CONFIG_SMP)
> +       /*
> +       * Remove our load from contribution when we leave sched_fair
> +       * and ensure we don't carry in an old decay_count if we
> +       * switch back.
> +       */
> +       if (p->se.avg.decay_count) {
> +               struct cfs_rq *cfs_rq = cfs_rq_of(&p->se);
> +               __synchronize_entity_decay(&p->se);
> +               subtract_blocked_load_contrib(cfs_rq,
> +                               p->se.avg.load_avg_contrib);
> +       }
> +#endif
>  }
>
> And it is never changed from then on. So your code must based on a
> incorrect kernel. please do a double check.

I see your point... I made the mistake that update the wrong patch...
Please help check this one.

commit 5fc3d5c74f8359ef382d9a20ffe657ffc237c109
Author: Lei Wen <leiwen@marvell.com>
Date:   Thu Jun 20 10:43:59 2013 +0800

    sched: fix potential twice decay issue

    Signed-off-by: Lei Wen <leiwen@marvell.com>

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index c61a614..9640c66 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5856,7 +5856,8 @@ static void switched_from_fair(struct rq *rq,
struct task_struct *p)
        */
        if (p->se.avg.decay_count) {
                struct cfs_rq *cfs_rq = cfs_rq_of(&p->se);
-               __synchronize_entity_decay(&p->se);
+               p->se.avg.last_runnable_update +=
+                               __synchronize_entity_decay(&p->se);
                subtract_blocked_load_contrib(cfs_rq,
                                p->se.avg.load_avg_contrib);
        }

Thanks,
Lei


>>
>> Thanks,
>> Lei
>>
>>>>                                 __synchronize_entity_decay(&p->se);
>>>>                 subtract_blocked_load_contrib(cfs_rq,
>>>>                                 p->se.avg.load_avg_contrib);
>>>
>>>
>>> --
>>> Thanks
>>>     Alex
>
>
> --
> Thanks
>     Alex
