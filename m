Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755991AbaHZXYj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 19:24:39 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:38296 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831AbaHZXYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 19:24:38 -0400
MIME-Version: 1.0
In-Reply-To: <1409094682.29189.23.camel@j-VirtualBox>
References: <1409094682.29189.23.camel@j-VirtualBox>
From: Paul Turner <pjt@google.com>
Date: Tue, 26 Aug 2014 16:24:07 -0700
Message-ID: <CAPM31RJcYakzwo9mByoadw6DGcg5SfYDOdX79NPo08hBP5PGjA@mail.gmail.com>
Subject: Re: [PATCH v2] sched: Reduce contention in update_cfs_rq_blocked_load
To: Jason Low <jason.low2@hp.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Ben Segall <bsegall@google.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 26, 2014 at 4:11 PM, Jason Low <jason.low2@hp.com> wrote:
> Based on perf profiles, the update_cfs_rq_blocked_load function constantly
> shows up as taking up a noticeable % of system run time. This is especially
> apparent on larger numa systems.
>
> Much of the contention is in __update_cfs_rq_tg_load_contrib when we're
> updating the tg load contribution stats. However, it was noticed that the
> values often don't get modified by much. In fact, much of the time, they
> don't get modified at all. However, the update can always get attempted due
> to force_update.
>
> In this patch, we remove the force_update in only the
> __update_cfs_rq_tg_load_contrib. Thus the tg load contrib stats now get
> modified only if the delta is large enough (in the current code, they get
> updated when the delta is larger than 12.5%). This is a way to rate-limit
> the updates while largely keeping the values accurate.
>
> When testing this change with AIM7 workloads, we found that it was able to
> reduce the overhead of the function by up to a factor of 20x.

Looks reasonable.

>
> Cc: Yuyang Du <yuyang.du@intel.com>
> Cc: Waiman Long <Waiman.Long@hp.com>
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Mike Galbraith <umgwanakikbuti@gmail.com>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: Aswin Chandramouleeswaran <aswin@hp.com>
> Cc: Chegu Vinod <chegu_vinod@hp.com>
> Cc: Scott J Norton <scott.norton@hp.com>
> Signed-off-by: Jason Low <jason.low2@hp.com>
> ---
>  kernel/sched/fair.c |   10 ++++------
>  1 files changed, 4 insertions(+), 6 deletions(-)
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index fea7d33..7a6e18b 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -2352,8 +2352,7 @@ static inline u64 __synchronize_entity_decay(struct sched_entity *se)
>  }
>
>  #ifdef CONFIG_FAIR_GROUP_SCHED
> -static inline void __update_cfs_rq_tg_load_contrib(struct cfs_rq *cfs_rq,
> -                                                int force_update)
> +static inline void __update_cfs_rq_tg_load_contrib(struct cfs_rq *cfs_rq)
>  {
>         struct task_group *tg = cfs_rq->tg;
>         long tg_contrib;
> @@ -2361,7 +2360,7 @@ static inline void __update_cfs_rq_tg_load_contrib(struct cfs_rq *cfs_rq,
>         tg_contrib = cfs_rq->runnable_load_avg + cfs_rq->blocked_load_avg;
>         tg_contrib -= cfs_rq->tg_load_contrib;
>
> -       if (force_update || abs(tg_contrib) > cfs_rq->tg_load_contrib / 8) {

Another option with slightly higher accuracy would be to increase the
sensitivity here when force_update == 1.

E.g.:
    abs(tg_contrib) > cfs_rq->tg_load_contrib / (8 * (1 + force_update))) { ...

Alternatively we could bound total inaccuracy:
   int divisor = force_update ? NR_CPUS : 8;
   if (abs(tg_contrib) > cfs_rq->tg_load_contrib / divisor) { ...


[ And probably rename force_update to want_update ]


> +       if (abs(tg_contrib) > cfs_rq->tg_load_contrib / 8) {
>                 atomic_long_add(tg_contrib, &tg->load_avg);
>                 cfs_rq->tg_load_contrib += tg_contrib;
>         }
> @@ -2436,8 +2435,7 @@ static inline void update_rq_runnable_avg(struct rq *rq, int runnable)
>         __update_tg_runnable_avg(&rq->avg, &rq->cfs);
>  }
>  #else /* CONFIG_FAIR_GROUP_SCHED */
> -static inline void __update_cfs_rq_tg_load_contrib(struct cfs_rq *cfs_rq,
> -                                                int force_update) {}
> +static inline void __update_cfs_rq_tg_load_contrib(struct cfs_rq *cfs_rq) {}
>  static inline void __update_tg_runnable_avg(struct sched_avg *sa,
>                                                   struct cfs_rq *cfs_rq) {}
>  static inline void __update_group_entity_contrib(struct sched_entity *se) {}
> @@ -2537,7 +2535,7 @@ static void update_cfs_rq_blocked_load(struct cfs_rq *cfs_rq, int force_update)
>                 cfs_rq->last_decay = now;
>         }
>
> -       __update_cfs_rq_tg_load_contrib(cfs_rq, force_update);
> +       __update_cfs_rq_tg_load_contrib(cfs_rq);
>  }
>
>  /* Add the load generated by se into cfs_rq's child load-average */
> --
> 1.7.1
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
