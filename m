Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172AbaLVJnN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 04:43:13 -0500
Received: from mga02.intel.com ([134.134.136.20]:10202 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753733AbaLVJnL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 04:43:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,622,1413270000"; 
   d="scan'208";a="658352147"
From: "Du, Yuyang" <yuyang.du@intel.com>
To: Vincent Guittot <vincent.guittot@linaro.org>,
        Morten Rasmussen <morten.rasmussen@arm.com>
CC: Peter Zijlstra <peterz@infradead.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Paul Turner <pjt@google.com>, Benjamin Segall <bsegall@google.com>,
        Michael Turquette <mturquette@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: RE: [RFC PATCH 08/10] sched: Track blocked utilization contributions
Thread-Topic: [RFC PATCH 08/10] sched: Track blocked utilization
 contributions
Thread-Index: AQHQDjpLXhoAuFGoFUG9y0Mp6Cqd05yS/90AgAh6b3A=
Date: Mon, 22 Dec 2014 09:43:05 +0000
Message-ID: <0DA73B5D686AEC4AAEF6054BE04DA1CD11CEB15A@shsmsx102.ccr.corp.intel.com>
References: <1417529192-11579-1-git-send-email-morten.rasmussen@arm.com>
 <1417529192-11579-9-git-send-email-morten.rasmussen@arm.com>
 <CAKfTPtDq7EpPWyw+=h+WKGeMPmbPdSrAyFFNssNhHczL3minZA@mail.gmail.com>
In-Reply-To: <CAKfTPtDq7EpPWyw+=h+WKGeMPmbPdSrAyFFNssNhHczL3minZA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks, Vincent. Then again ping Peter and PJT and Ben for the
rewrite patch v6, which has not been reviewed.

-----Original Message-----
From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Vincent Guittot
Sent: Wednesday, December 17, 2014 4:13 PM
To: Morten Rasmussen
Cc: Peter Zijlstra; mingo@redhat.com; Dietmar Eggemann; Paul Turner; Benjamin Segall; Michael Turquette; linux-kernel; linux-pm@vger.kernel.org
Subject: Re: [RFC PATCH 08/10] sched: Track blocked utilization contributions

On 2 December 2014 at 15:06, Morten Rasmussen <morten.rasmussen@arm.com> wrote:
> Introduces the blocked utilization, the utilization counter-part to 
> cfs_rq->utilization_load_avg. It is the sum of sched_entity 
> utilization contributions of entities that were recently on the cfs_rq 
> that are currently blocked. Combined with sum of contributions of 
> entities currently on the cfs_rq or currently running
> (cfs_rq->utilization_load_avg) this can provide a more stable average 
> view of the cpu usage.

I'm fully aligned with the interest of adding blocked tasks in the CPU's utilization. Now, instead of adding one more atomic data and it's manipulation, it might be worth to move on yuyang.du@intel.com
patchset: rewrites the per entity load tracking which includes blocked load.

>
> cc: Ingo Molnar <mingo@redhat.com>
> cc: Peter Zijlstra <peterz@infradead.org>
>
> Signed-off-by: Morten Rasmussen <morten.rasmussen@arm.com>
> ---
>  kernel/sched/fair.c  | 30 +++++++++++++++++++++++++++++-  
> kernel/sched/sched.h |  8 ++++++--
>  2 files changed, 35 insertions(+), 3 deletions(-)
>
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c index 
> 090223f..adf64df 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -2778,6 +2778,15 @@ static inline void subtract_blocked_load_contrib(struct cfs_rq *cfs_rq,
>                 cfs_rq->blocked_load_avg = 0;  }
>
> +static inline void subtract_utilization_blocked_contrib(struct cfs_rq *cfs_rq,
> +                                               long 
> +utilization_contrib) {
> +       if (likely(utilization_contrib < cfs_rq->utilization_blocked_avg))
> +               cfs_rq->utilization_blocked_avg -= utilization_contrib;
> +       else
> +               cfs_rq->utilization_blocked_avg = 0; }
> +
>  static inline u64 cfs_rq_clock_task(struct cfs_rq *cfs_rq);
>
>  /* Update a sched_entity's runnable average */ @@ -2813,6 +2822,8 @@ 
> static inline void update_entity_load_avg(struct sched_entity *se,
>                 cfs_rq->utilization_load_avg += utilization_delta;
>         } else {
>                 subtract_blocked_load_contrib(cfs_rq, -contrib_delta);
> +               subtract_utilization_blocked_contrib(cfs_rq,
> +                                                       
> + -utilization_delta);
>         }
>  }
>
> @@ -2830,14 +2841,20 @@ static void update_cfs_rq_blocked_load(struct cfs_rq *cfs_rq, int force_update)
>                 return;
>
>         if (atomic_long_read(&cfs_rq->removed_load)) {
> -               unsigned long removed_load;
> +               unsigned long removed_load, removed_utilization;
>                 removed_load = atomic_long_xchg(&cfs_rq->removed_load, 
> 0);
> +               removed_utilization =
> +                       atomic_long_xchg(&cfs_rq->removed_utilization, 
> + 0);
>                 subtract_blocked_load_contrib(cfs_rq, removed_load);
> +               subtract_utilization_blocked_contrib(cfs_rq,
> +                                                       
> + removed_utilization);
>         }
>
>         if (decays) {
>                 cfs_rq->blocked_load_avg = decay_load(cfs_rq->blocked_load_avg,
>                                                       decays);
> +               cfs_rq->utilization_blocked_avg =
> +                       decay_load(cfs_rq->utilization_blocked_avg, 
> + decays);
>                 atomic64_add(decays, &cfs_rq->decay_counter);
>                 cfs_rq->last_decay = now;
>         }
> @@ -2884,6 +2901,8 @@ static inline void enqueue_entity_load_avg(struct cfs_rq *cfs_rq,
>         /* migrated tasks did not contribute to our blocked load */
>         if (wakeup) {
>                 subtract_blocked_load_contrib(cfs_rq, 
> se->avg.load_avg_contrib);
> +               subtract_utilization_blocked_contrib(cfs_rq,
> +                                       
> + se->avg.utilization_avg_contrib);
>                 update_entity_load_avg(se, 0);
>         }
>
> @@ -2910,6 +2929,8 @@ static inline void dequeue_entity_load_avg(struct cfs_rq *cfs_rq,
>         cfs_rq->utilization_load_avg -= se->avg.utilization_avg_contrib;
>         if (sleep) {
>                 cfs_rq->blocked_load_avg += se->avg.load_avg_contrib;
> +               cfs_rq->utilization_blocked_avg +=
> +                                               
> + se->avg.utilization_avg_contrib;
>                 se->avg.decay_count = atomic64_read(&cfs_rq->decay_counter);
>         } /* migrations, e.g. sleep=0 leave decay_count == 0 */  } @@ 
> -4929,6 +4950,8 @@ migrate_task_rq_fair(struct task_struct *p, int next_cpu)
>                 se->avg.decay_count = -__synchronize_entity_decay(se);
>                 atomic_long_add(se->avg.load_avg_contrib,
>                                                 
> &cfs_rq->removed_load);
> +               atomic_long_add(se->avg.utilization_avg_contrib,
> +                                       &cfs_rq->removed_utilization);
>         }
>
>         /* We have migrated, no longer consider this task hot */ @@ 
> -7944,6 +7967,8 @@ static void switched_from_fair(struct rq *rq, struct task_struct *p)
>         if (se->avg.decay_count) {
>                 __synchronize_entity_decay(se);
>                 subtract_blocked_load_contrib(cfs_rq, 
> se->avg.load_avg_contrib);
> +               subtract_utilization_blocked_contrib(cfs_rq,
> +                                       
> + se->avg.utilization_avg_contrib);
>         }
>  #endif
>  }
> @@ -8003,6 +8028,7 @@ void init_cfs_rq(struct cfs_rq *cfs_rq)  #ifdef 
> CONFIG_SMP
>         atomic64_set(&cfs_rq->decay_counter, 1);
>         atomic_long_set(&cfs_rq->removed_load, 0);
> +       atomic_long_set(&cfs_rq->removed_utilization, 0);
>  #endif
>  }
>
> @@ -8055,6 +8081,8 @@ static void task_move_group_fair(struct task_struct *p, int queued)
>                  */
>                 se->avg.decay_count = atomic64_read(&cfs_rq->decay_counter);
>                 cfs_rq->blocked_load_avg += se->avg.load_avg_contrib;
> +               cfs_rq->utilization_blocked_avg +=
> +                                               
> + se->avg.utilization_avg_contrib;
>  #endif
>         }
>  }
> diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h index 
> e402133..208237f 100644
> --- a/kernel/sched/sched.h
> +++ b/kernel/sched/sched.h
> @@ -368,11 +368,15 @@ struct cfs_rq {
>          * the blocked sched_entities on the rq.
>          * utilization_load_avg is the sum of the average running time of the
>          * sched_entities on the rq.
> +        * utilization_blocked_avg is the utilization equivalent of
> +        * blocked_load_avg, i.e. the sum of running contributions of blocked
> +        * sched_entities associated with the rq.
>          */
> -       unsigned long runnable_load_avg, blocked_load_avg, utilization_load_avg;
> +       unsigned long runnable_load_avg, blocked_load_avg;
> +       unsigned long utilization_load_avg, utilization_blocked_avg;
>         atomic64_t decay_counter;
>         u64 last_decay;
> -       atomic_long_t removed_load;
> +       atomic_long_t removed_load, removed_utilization;
>
>  #ifdef CONFIG_FAIR_GROUP_SCHED
>         /* Required to track per-cpu representation of a task_group */
> --
> 1.9.1
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in the body of a message to majordomo@vger.kernel.org More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
