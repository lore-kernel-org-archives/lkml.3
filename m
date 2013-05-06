Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379Ab3EFIqw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 04:46:52 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:41419 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933Ab3EFIqv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 04:46:51 -0400
MIME-Version: 1.0
In-Reply-To: <1367804711-30308-6-git-send-email-alex.shi@intel.com>
References: <1367804711-30308-1-git-send-email-alex.shi@intel.com> <1367804711-30308-6-git-send-email-alex.shi@intel.com>
From: Paul Turner <pjt@google.com>
Date: Mon, 6 May 2013 01:46:19 -0700
Message-ID: <CAPM31RLJe19FH+RYipwm4kwtzmFHoS2xGTx4iZ9+qwDJZ_pf3A@mail.gmail.com>
Subject: Re: [PATCH v5 5/7] sched: compute runnable load avg in cpu_load and cpu_avg_load_per_task
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
> They are the base values in load balance, update them with rq runnable
> load average, then the load balance will consider runnable load avg
> naturally.
>
> Signed-off-by: Alex Shi <alex.shi@intel.com>
> ---
>  kernel/sched/core.c | 4 ++--
>  kernel/sched/fair.c | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 33bcebf..2f51636 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -2536,7 +2536,7 @@ static void __update_cpu_load(struct rq *this_rq, unsigned long this_load,
>  void update_idle_cpu_load(struct rq *this_rq)
>  {
>         unsigned long curr_jiffies = ACCESS_ONCE(jiffies);
> -       unsigned long load = this_rq->load.weight;
> +       unsigned long load = (unsigned long)this_rq->cfs.runnable_load_avg;

We should be minimizing:
  Variance[ for all i ]{ cfs_rq[i]->runnable_load_avg +
cfs_rq[i]->blocked_load_avg }

blocked_load_avg is the expected "to wake" contribution from tasks
already assigned to this rq.

e.g. this could be:
  load = this_rq->cfs.runnable_load_avg + this_rq->cfs.blocked_load_avg;

Although, in general I have a major concern with the current implementation:

The entire reason for stability with the bottom up averages is that
when load migrates between cpus we are able to migrate it between the
tracked sums.

Stuffing observed averages of these into the load_idxs loses that
mobility; we will have to stall (as we do today for idx > 0) before we
can recognize that a cpu's load has truly left it; this is a very
similar problem to the need to stably track this for group shares
computation.

To that end, I would rather see the load_idx disappear completely:
 (a) We can calculate the imbalance purely from delta (runnable_avg +
blocked_avg)
 (b) It eliminates a bad tunable.

>         unsigned long pending_updates;
>
>         /*
> @@ -2586,7 +2586,7 @@ static void update_cpu_load_active(struct rq *this_rq)
>          * See the mess around update_idle_cpu_load() / update_cpu_load_nohz().
>          */
>         this_rq->last_load_update_tick = jiffies;
> -       __update_cpu_load(this_rq, this_rq->load.weight, 1);
> +       __update_cpu_load(this_rq, this_rq->cfs.runnable_load_avg, 1);
>
>         calc_load_account_active(this_rq);
>  }
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 2881d42..0bf88e8 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -2900,7 +2900,7 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
>  /* Used instead of source_load when we know the type == 0 */
>  static unsigned long weighted_cpuload(const int cpu)
>  {
> -       return cpu_rq(cpu)->load.weight;
> +       return (unsigned long)cpu_rq(cpu)->cfs.runnable_load_avg;

Isn't this going to truncate on the 32-bit case?

>  }
>
>  /*
> @@ -2947,7 +2947,7 @@ static unsigned long cpu_avg_load_per_task(int cpu)
>         unsigned long nr_running = ACCESS_ONCE(rq->nr_running);
>
>         if (nr_running)
> -               return rq->load.weight / nr_running;
> +               return (unsigned long)rq->cfs.runnable_load_avg / nr_running;
>
>         return 0;
>  }
> --
> 1.7.12
>
