Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827Ab3EFIyS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 04:54:18 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:63661 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753745Ab3EFIyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 04:54:17 -0400
MIME-Version: 1.0
In-Reply-To: <1367804711-30308-7-git-send-email-alex.shi@intel.com>
References: <1367804711-30308-1-git-send-email-alex.shi@intel.com> <1367804711-30308-7-git-send-email-alex.shi@intel.com>
From: Paul Turner <pjt@google.com>
Date: Mon, 6 May 2013 01:53:44 -0700
Message-ID: <CAPM31RK71tBPdnXzLmr1o6nmFhbhU9+b_DqX9zNSbDc4EhC8FQ@mail.gmail.com>
Subject: Re: [PATCH v5 6/7] sched: consider runnable load average in move_tasks
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

On Sun, May 5, 2013 at 6:45 PM, Alex Shi <alex.shi@intel.com> wrote:
> Except using runnable load average in background, move_tasks is also
> the key functions in load balance. We need consider the runnable load
> average in it in order to the apple to apple load comparison.
>
> Signed-off-by: Alex Shi <alex.shi@intel.com>
> ---
>  kernel/sched/fair.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 0bf88e8..790e23d 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -3966,6 +3966,12 @@ static unsigned long task_h_load(struct task_struct *p);
>
>  static const unsigned int sched_nr_migrate_break = 32;
>
> +static unsigned long task_h_load_avg(struct task_struct *p)
> +{
> +       return div_u64(task_h_load(p) * (u64)p->se.avg.runnable_avg_sum,
> +                       p->se.avg.runnable_avg_period + 1);

Similarly, I think you also want to at least include blocked_load_avg here.

More fundamentally:
I suspect the instability from comparing these to an average taken on
them will not give a representative imbalance weight.  While we should
be no worse off than the present situation; we could be doing much
better.

Consider that by not consuming {runnable, blocked}_load_avg directly
you are "hiding" the movement from one load-balancer to the next.
> +}
> +
>  /*
>   * move_tasks tries to move up to imbalance weighted load from busiest to
>   * this_rq, as part of a balancing operation within domain "sd".
> @@ -4001,7 +4007,7 @@ static int move_tasks(struct lb_env *env)
>                 if (throttled_lb_pair(task_group(p), env->src_cpu, env->dst_cpu))
>                         goto next;
>
> -               load = task_h_load(p);
> +               load = task_h_load_avg(p);
>
>                 if (sched_feat(LB_MIN) && load < 16 && !env->sd->nr_balance_failed)
>                         goto next;
> --
> 1.7.12
>
