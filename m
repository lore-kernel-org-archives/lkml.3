Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760313Ab3DCBXx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 21:23:53 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:64507 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758124Ab3DCBXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 21:23:52 -0400
MIME-Version: 1.0
In-Reply-To: <515B7F99.3000407@intel.com>
References: <1364654108-16307-1-git-send-email-alex.shi@intel.com>
 <1364654108-16307-4-git-send-email-alex.shi@intel.com> <CAKfTPtArivjSsVn=Xc_421oqo+mXUfMaXhfyATK+s=xXO+P3eA@mail.gmail.com>
 <515B7F99.3000407@intel.com>
From: Paul Turner <pjt@google.com>
Date: Tue, 2 Apr 2013 18:23:19 -0700
Message-ID: <CAPM31RKSUManoOO9QO5CafVGUHZGafekstF8Xx06pdBL+E93sQ@mail.gmail.com>
Subject: Re: [patch v6 03/21] sched: only count runnable avg on cfs_rq's nr_running
To: Alex Shi <alex.shi@intel.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>, Namhyung Kim <namhyung@kernel.org>,
        Mike Galbraith <efault@gmx.de>, gregkh@linuxfoundation.org,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nack:
Vincent is correct, rq->avg is supposed to be the average time that an
rq is runnable; this includes (for example) SCHED_RT.

It's intended to be more useful as a hint towards something like a
power governor which wants to know how busy the CPU is in general.

> On the other side, periodic LB balance on combined the cfs/rt load, but
> removed the RT utilisation in cpu_power.

This I don't quite understand; these inputs are already time scaled (by decay).

Stated alternatively, what you want is:
  "average load" / "available power", which is:
  (rq->cfs.runnable_load_avg + rq->cfs.blocked_load_avg) / (cpu power
scaled for rt)

Where do you propose mixing rq->avg into that?


On Tue, Apr 2, 2013 at 6:02 PM, Alex Shi <alex.shi@intel.com> wrote:
> On 04/02/2013 10:30 PM, Vincent Guittot wrote:
>> On 30 March 2013 15:34, Alex Shi <alex.shi@intel.com> wrote:
>>> Old function count the runnable avg on rq's nr_running even there is
>>> only rt task in rq. That is incorrect, so correct it to cfs_rq's
>>> nr_running.
>>>
>>> Signed-off-by: Alex Shi <alex.shi@intel.com>
>>> ---
>>>  kernel/sched/fair.c | 2 +-
>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
>>> index 2881d42..026e959 100644
>>> --- a/kernel/sched/fair.c
>>> +++ b/kernel/sched/fair.c
>>> @@ -2829,7 +2829,7 @@ enqueue_task_fair(struct rq *rq, struct task_struct *p, int flags)
>>>         }
>>>
>>>         if (!se) {
>>> -               update_rq_runnable_avg(rq, rq->nr_running);
>>> +               update_rq_runnable_avg(rq, rq->cfs.nr_running);
>>
>> A RT task that preempts your CFS task will be accounted in the
>> runnable_avg fields. So whatever you do, RT task will impact your
>> runnable_avg statistics. Instead of trying to get only CFS tasks, you
>> should take into account all tasks activity in the rq.
>
> Thanks for comments, Vincent!
>
> Yes, I know some rt task time was counted into cfs, but now we have no
> good idea to remove them clearly. So I just want to a bit more precise
> cfs runnable load here.
> On the other side, periodic LB balance on combined the cfs/rt load, but
> removed the RT utilisation in cpu_power.
>
> So, PJT, Peter, what's your idea of this point?
>>
>> Vincent
>>>                 inc_nr_running(rq);
>>>         }
>>>         hrtick_update(rq);
>>> --
>>> 1.7.12
>>>
>
>
> --
> Thanks Alex
