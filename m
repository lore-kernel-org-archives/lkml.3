Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717Ab3EFKS1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 06:18:27 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:35721 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061Ab3EFKS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 06:18:26 -0400
MIME-Version: 1.0
In-Reply-To: <5187760D.8060900@intel.com>
References: <1367804711-30308-1-git-send-email-alex.shi@intel.com>
 <1367804711-30308-4-git-send-email-alex.shi@intel.com> <CAPM31RJg7t8f1H-dZwzP1c-0HHb_=8twidX74gS2NfyQhHUhCw@mail.gmail.com>
 <5187760D.8060900@intel.com>
From: Paul Turner <pjt@google.com>
Date: Mon, 6 May 2013 03:17:54 -0700
Message-ID: <CAPM31RKiCfSZ=hJ9P7WOH6AC8uj6b06mEM6K0WCTYXC7OJAq7A@mail.gmail.com>
Subject: Re: [PATCH v5 3/7] sched: set initial value of runnable avg for new
 forked task
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
        Michael Wang <wangyun@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 6, 2013 at 2:21 AM, Alex Shi <alex.shi@intel.com> wrote:
> On 05/06/2013 04:19 PM, Paul Turner wrote:
>> On Sun, May 5, 2013 at 6:45 PM, Alex Shi <alex.shi@intel.com> wrote:
>>> We need initialize the se.avg.{decay_count, load_avg_contrib} for a
>>> new forked task.
>>> Otherwise random values of above variables cause mess when do new task
>>> enqueue:
>>>     enqueue_task_fair
>>>         enqueue_entity
>>>             enqueue_entity_load_avg
>>>
>>> and make forking balancing imbalance since incorrect load_avg_contrib.
>>>
>>> set avg.decay_count = 0, and avg.load_avg_contrib = se->load.weight to
>>> resolve such issues.
>>>
>>> Signed-off-by: Alex Shi <alex.shi@intel.com>
>>> ---
>>>  kernel/sched/core.c | 6 ++++++
>>>  kernel/sched/fair.c | 4 ++++
>>>  2 files changed, 10 insertions(+)
>>>
>>> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
>>> index c8db984..ecec7f1 100644
>>> --- a/kernel/sched/core.c
>>> +++ b/kernel/sched/core.c
>>> @@ -1566,6 +1566,7 @@ static void __sched_fork(struct task_struct *p)
>>>  #ifdef CONFIG_SMP
>>>         p->se.avg.runnable_avg_period = 0;
>>>         p->se.avg.runnable_avg_sum = 0;
>>> +       p->se.avg.decay_count = 0;
>>>  #endif
>>>  #ifdef CONFIG_SCHEDSTATS
>>>         memset(&p->se.statistics, 0, sizeof(p->se.statistics));
>>> @@ -1653,6 +1654,11 @@ void sched_fork(struct task_struct *p)
>>>                 p->sched_reset_on_fork = 0;
>>>         }
>>>
>>> +       /* New forked task assumed with full utilization */
>>> +#if defined(CONFIG_SMP)
>>> +       p->se.avg.load_avg_contrib = p->se.load.weight;
>>
>> This is missing a scale_load() right?  Further: Why not put this in
>> __sched_fork?
>
> scale_load is not working now. Anyway I can add this.
>
>>
>> We should also charge a minimum period to make the numbers a little
>> more kosher, e.g.:
>> +       p->se.avg.runnable_avg_period = 1024;
>> +       p->se.avg.runnable_avg_sum = 1024;
>>
>> Rather than exposing the representation of load_avg_contrib to
>> __sched_fork it might also be better to call:
>>   __update_task_entity_contrib(&p->se)
>> After the initialization above; this would also avoid potential bugs
>> like the missing scale_load() above.
>
> Above simple change can not work.

Could you provide additional detail here?  Note that the sum change I
was suggesting above was:

__sched_fork():
+       p->se.avg.decay_count = 0;
+       p->se.avg.runnable_avg_period = 1024;
+       p->se.avg.runnable_avg_sum = 1024;
+       __update_task_entity_contrib(&p->se);

[ Also: move __sched_fork() beyond p->sched_reset_on_fork in sched_fork(). ]

> We had talked this solution months ago. And get agreement on this patch.
> https://lkml.org/lkml/2013/2/20/48  :)

Yes, I made the same suggestion in the last round, see:
https://lkml.org/lkml/2013/2/19/176

Your reply there seems like an ack of my suggestion, the only
difference I'm seeing is that using __update_task_entity_contrib() as
originally suggested is safer since it keeps the representation of
load_avg_contrib opaque.

> --
> Thanks
>     Alex
