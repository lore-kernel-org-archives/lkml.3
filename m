Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313Ab3EIJY6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 05:24:58 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:48053 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225Ab3EIJYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 05:24:54 -0400
MIME-Version: 1.0
In-Reply-To: <518B5CC8.6070601@intel.com>
References: <1367804711-30308-1-git-send-email-alex.shi@intel.com>
 <1367804711-30308-4-git-send-email-alex.shi@intel.com> <CAPM31RJg7t8f1H-dZwzP1c-0HHb_=8twidX74gS2NfyQhHUhCw@mail.gmail.com>
 <5187760D.8060900@intel.com> <CAPM31RKiCfSZ=hJ9P7WOH6AC8uj6b06mEM6K0WCTYXC7OJAq7A@mail.gmail.com>
 <51886460.3020009@intel.com> <CAPM31RLsip-PMY73oq58gyi42EQ+-upmPpMQFkukVBX6LTwtCw@mail.gmail.com>
 <20130507095715.GE4068@e103034-lin> <5188DFEF.6010403@intel.com>
 <CAPM31R+x3h0b_r4uFkg_SMnkp0AWA6QRAQuDRducycHnFdG5Xw@mail.gmail.com>
 <20130508113442.GB6803@dyad.programming.kicks-ass.net> <518B5CC8.6070601@intel.com>
From: Paul Turner <pjt@google.com>
Date: Thu, 9 May 2013 02:24:23 -0700
Message-ID: <CAPM31RKQ0dXTWK6qgMPd6u_0nsQ3jodSo6QdUNEc4T0S9dCu_Q@mail.gmail.com>
Subject: Re: [PATCH v5 3/7] sched: set initial value of runnable avg for new
 forked task
To: Alex Shi <alex.shi@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>, Namhyung Kim <namhyung@kernel.org>,
        Mike Galbraith <efault@gmx.de>,
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

On Thu, May 9, 2013 at 1:22 AM, Alex Shi <alex.shi@intel.com> wrote:
> On 05/08/2013 07:34 PM, Peter Zijlstra wrote:
>>> > If we wanted to be more exacting about it we could just give them a
>>> > sched_slice() worth; this would have a few obvious "nice" properties
>>> > (pun intended).
>> Oh I see I misunderstood again :/ Its not about the effective load but weight
>> of the initial effective load wrt adjustment.
>>
>> Previous schedulers didn't have this aspect at all, so no experience from me
>> here. Paul would be the one, since he's ran longest with this stuff.
>>
>> That said, I would tend to keep it shorter rather than longer so that it would
>> adjust quicker to whatever it really wanted to be.
>>
>> Morten says the load is unstable specifically on loaded systems. I would think
>> this is because we'd experience scheduling latency, we're runnable more pushing
>> things up. But if we're really an idle task at heart we'd not run again for a
>> long while, pushing things down again.
>>
>> So on that point Paul's suggestion of maybe starting with __sched_slice() might
>> make sense because it increases the weight of the initial avg with nr_running.
>>
>> Not sure really, we'll have to play and see what works best for a number of
>> workloads.
>
>
> The patch of using sched_slice for review, I am testing the benchmarks
>
> ---
> From da40ffa90ec1de520bd7e92f5653734a964e3bb2 Mon Sep 17 00:00:00 2001
> From: Alex Shi <alex.shi@intel.com>
> Date: Thu, 9 May 2013 15:28:34 +0800
> Subject: [PATCH 4/8] sched: set initial runnable avg for new task
>
> ---
>  kernel/sched/core.c  |  2 ++
>  kernel/sched/fair.c  | 15 +++++++++++++++
>  kernel/sched/sched.h |  2 ++
>  3 files changed, 19 insertions(+)
>
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index ecec7f1..c17925b 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -1716,6 +1716,8 @@ void wake_up_new_task(struct task_struct *p)
>         set_task_cpu(p, select_task_rq(p, SD_BALANCE_FORK, 0));
>  #endif
>
> +       /* Give new task a start runnable time */
> +       set_task_runnable_avg(p);
>         rq = __task_rq_lock(p);
>         activate_task(rq, p, 0);
>         p->on_rq = 1;
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 2881d42..4ec5f29 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -661,6 +661,21 @@ static u64 sched_vslice(struct cfs_rq *cfs_rq, struct sched_entity *se)
>         return calc_delta_fair(sched_slice(cfs_rq, se), se);
>  }
>
> +#ifdef CONFIG_SMP
> +void set_task_runnable_avg(struct task_struct *p)
> +{
> +       u64 slice;
> +
> +       slice = sched_slice(task_cfs_rq(p), &p->se);
> +       p->se.avg.runnable_avg_sum = slice;
> +       p->se.avg.runnable_avg_period = slice;

This needs to be >> 10 right?  sched_slice is in ns.

We also still want to set load_avg_contrib right?

> +}
> +#else
> +void set_task_runnable_avg(struct task_struct *p)
> +{
> +}
> +#endif
> +
>  /*
>   * Update the current task's runtime statistics. Skip current tasks that
>   * are not in our scheduling class.
> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> index c6634f1..518f3d8a 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -900,6 +900,8 @@ extern void init_rt_bandwidth(struct rt_bandwidth *rt_b, u64 period, u64 runtime
>
>  extern void update_idle_cpu_load(struct rq *this_rq);
>
> +extern void set_task_runnable_avg(struct task_struct *p);
> +
>  #ifdef CONFIG_CGROUP_CPUACCT
>  #include <linux/cgroup.h>
>  /* track cpu usage of a group of tasks and its child groups */
> --
> 1.7.12
>
> --
> Thanks
>     Alex
