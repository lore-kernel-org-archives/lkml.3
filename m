Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645Ab3IZK41 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 06:56:27 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:56153 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755578Ab3IZK40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 06:56:26 -0400
MIME-Version: 1.0
In-Reply-To: <20130926095812.GR3081@twins.programming.kicks-ass.net>
References: <20130925075341.GB3081@twins.programming.kicks-ass.net>
 <1380099377.8523.9.camel@marge.simpson.net> <20130926095812.GR3081@twins.programming.kicks-ass.net>
From: Paul Turner <pjt@google.com>
Date: Thu, 26 Sep 2013 03:55:55 -0700
Message-ID: <CAPM31RL9RGX=ohUVag=tD41MbXs47dDgpndGfjBt68QeL-De7g@mail.gmail.com>
Subject: Re: [RFC][PATCH] sched: Avoid select_idle_sibling() for wake_affine(.sync=true)
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <bitbucket@online.de>, Ingo Molnar <mingo@kernel.org>,
        Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 26, 2013 at 2:58 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Wed, Sep 25, 2013 at 10:56:17AM +0200, Mike Galbraith wrote:
>> That will make pipe-test go fugly -> pretty, and help very fast/light
>> localhost network, but eat heavier localhost overlap recovery.  We need
>> a working (and cheap) overlap detector scheme, so we can know when there
>> is enough to be worth going after.
>
> We used to have an overlap detectoring thing.. It went away though.
>
> But see if you can make something like the below work?
>
> You could make it a general overlap thing and try without the sync too I
> suppose..
>
> ---
>  include/linux/sched.h |  3 +++
>  kernel/sched/fair.c   | 25 +++++++++++++++++++++++++
>  2 files changed, 28 insertions(+)
>
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index b5344de..5428016 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -974,6 +974,9 @@ struct sched_entity {
>         u64                     vruntime;
>         u64                     prev_sum_exec_runtime;
>
> +       u64                     last_sync_wakeup;
> +       u64                     avg_overlap;
> +
>         u64                     nr_migrations;
>
>  #ifdef CONFIG_SCHEDSTATS
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 2b89cd2..47b0d0f 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -2913,6 +2913,17 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
>         struct sched_entity *se = &p->se;
>         int task_sleep = flags & DEQUEUE_SLEEP;
>
> +       if (se->last_sync_wakeup) {
> +               u64 overlap;
> +               s64 diff;
> +
> +               overlap = rq->clock - se->last_sync_wakeup;
> +               se->last_sync_wakeup = 0;
> +
> +               diff = overlap - se->avg_overlap;
> +               se->avg_overlap += diff >> 8;
> +       }
> +
>         for_each_sched_entity(se) {
>                 cfs_rq = cfs_rq_of(se);
>                 dequeue_entity(cfs_rq, se, flags);
> @@ -3429,6 +3440,9 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
>         int want_affine = 0;
>         int sync = wake_flags & WF_SYNC;
>
> +       if (sync)
> +               p->se.last_sync_wakeup = sched_clock_cpu(cpu);
> +
>         if (p->nr_cpus_allowed == 1)
>                 return prev_cpu;
>
> @@ -3461,6 +3475,17 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
>                 if (cpu != prev_cpu && wake_affine(affine_sd, p, sync))
>                         prev_cpu = cpu;
>
> +               /*
> +                * Don't bother with select_idle_sibling() in the case of a sync wakeup
> +                * where we know the only running task will soon go-away. Going
> +                * through select_idle_sibling will only lead to pointless ping-pong.
> +                */
> +               if (sync && prev_cpu == cpu && cpu_rq(cpu)->nr_running == 1 &&

I've long thought of trying something like this.

I like the intent but I'd go a step further in that I think we want to
also implicitly extract WF_SYNC itself.  While pipe_test is a good
microbenchmark it's not entirely representative since, in reality,
overlap is most usefully applied to threads in the same process -- and
they rarely communicate using a pipe.

What we really then care about is predicting the overlap associated
with userspace synchronization objects, typically built on top of
futexes.  Unfortunately the existence/use of per-thread futexes
reduces how much state you could usefully associate with the futex.
One approach might be to hash (with some small saturating counter)
against rip.  But this gets more complicated quite quickly.

> +                   current->se.avg_overlap < 10000) {
> +                       new_cpu = cpu;
> +                       goto unlock;
> +               }
> +
>                 new_cpu = select_idle_sibling(p, prev_cpu);
>                 goto unlock;
>         }
