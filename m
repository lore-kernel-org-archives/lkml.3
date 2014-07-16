Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965377AbaGPPq2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 11:46:28 -0400
Received: from fw-tnat.austin.arm.com ([217.140.110.23]:10106 "EHLO
	collaborate-mta1.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933938AbaGPPq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 11:46:26 -0400
Date: Wed, 16 Jul 2014 16:46:14 +0100
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Yuyang Du <yuyang.du@intel.com>
Cc: "mingo@redhat.com" <mingo@redhat.com>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "pjt@google.com" <pjt@google.com>,
        "bsegall@google.com" <bsegall@google.com>,
        "arjan.van.de.ven@intel.com" <arjan.van.de.ven@intel.com>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "alan.cox@intel.com" <alan.cox@intel.com>,
        "mark.gross@intel.com" <mark.gross@intel.com>,
        "fengguang.wu@intel.com" <fengguang.wu@intel.com>,
        "umgwanakikbuti@gmail.com" <umgwanakikbuti@gmail.com>
Subject: Re: [PATCH 2/2 v3] sched: Rewrite per entity runnable load average
 tracking
Message-ID: <20140716154614.GP26542@e103034-lin>
References: <1405475447-7783-1-git-send-email-yuyang.du@intel.com>
 <1405475447-7783-3-git-send-email-yuyang.du@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1405475447-7783-3-git-send-email-yuyang.du@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 02:50:47AM +0100, Yuyang Du wrote:

[...]

> +/*
> + * Update load_avg of the cfs_rq along with its own se. They should get
> + * synchronized: group se's load_avg is used for task_h_load calc, and
> + * group cfs_rq's load_avg is used for task_h_load (and update_cfs_share
> + * calc).
> + */
> +static inline int update_cfs_rq_load_avg(u64 now, struct cfs_rq *cfs_rq)
>  {
> -       long old_contrib = se->avg.load_avg_contrib;
> +       int decayed;
> 
> -       if (entity_is_task(se)) {
> -               __update_task_entity_contrib(se);
> -       } else {
> -               __update_tg_runnable_avg(&se->avg, group_cfs_rq(se));
> -               __update_group_entity_contrib(se);
> +       if (atomic_long_read(&cfs_rq->removed_load_avg)) {
> +               long r = atomic_long_xchg(&cfs_rq->removed_load_avg, 0);
> +               cfs_rq->avg.load_avg = subtract_until_zero(cfs_rq->avg.load_avg, r);
> +               r *= LOAD_AVG_MAX;
> +               cfs_rq->avg.load_sum = subtract_until_zero(cfs_rq->avg.load_sum, r);
>         }
> 
> -       return se->avg.load_avg_contrib - old_contrib;
> -}
> +       decayed = __update_load_avg(now, &cfs_rq->avg, cfs_rq->load.weight);
> +#ifndef CONFIG_64BIT
> +       if (cfs_rq->avg.last_update_time != cfs_rq->load_last_update_time_copy)
> +               sa_q->last_update_time_copy = sa_q->last_update_time;

This doesn't build on 32 bit. You need:

-               sa_q->last_update_time_copy = sa_q->last_update_time;
+               cfs_rq->load_last_update_time_copy = cfs_rq->avg.last_update_time;

to make it build. But I'm not convinced that this synchronization is
right.

First let me say that I'm not an expert on synchronization. It seems to
me that there is nothing preventing reordering of the writes in
__update_load_avg() which sets cfs_rq->avg.last_update_time and the
update of cfs_rq->avg.load_last_update_time_copy.

> +#endif
> 
> -static inline void subtract_blocked_load_contrib(struct cfs_rq *cfs_rq,
> -                                                long load_contrib)
> -{
> -       if (likely(load_contrib < cfs_rq->blocked_load_avg))
> -               cfs_rq->blocked_load_avg -= load_contrib;
> -       else
> -               cfs_rq->blocked_load_avg = 0;
> +       return decayed;
>  }

[...]

> @@ -4551,18 +4381,34 @@ migrate_task_rq_fair(struct task_struct *p, int next_cpu)
>  {
>         struct sched_entity *se = &p->se;
>         struct cfs_rq *cfs_rq = cfs_rq_of(se);
> +       u64 last_update_time;
> 
>         /*
> -        * Load tracking: accumulate removed load so that it can be processed
> -        * when we next update owning cfs_rq under rq->lock.  Tasks contribute
> -        * to blocked load iff they have a positive decay-count.  It can never
> -        * be negative here since on-rq tasks have decay-count == 0.
> +        * Task on old CPU catches up with its old cfs_rq, and subtract itself from
> +        * the cfs_rq (task must be off the queue now).
>          */
> -       if (se->avg.decay_count) {
> -               se->avg.decay_count = -__synchronize_entity_decay(se);
> -               atomic_long_add(se->avg.load_avg_contrib,
> -                                               &cfs_rq->removed_load);
> -       }
> +#ifndef CONFIG_64BIT
> +       u64 last_update_time_copy;
> +
> +       do {
> +               last_update_time_copy = cfs_rq->load_last_update_time_copy;
> +               smp_rmb();
> +               last_update_time = cfs_rq->avg.last_update_time;
> +       } while (last_update_time != last_update_time_copy);

Here is the matching read side of the synchronization code. Since
reodering might happen on the write side (I believe), I'm not convinced
that this works.

Morten

> +#else
> +       last_update_time = cfs_rq->avg.last_update_time;
> +#endif
> +       __update_load_avg(last_update_time, &se->avg, 0);
> +       atomic_long_add(se->avg.load_avg, &cfs_rq->removed_load_avg);
> +
> +       /*
> +        * We are supposed to update the task to "current" time, then its up to date
> +        * and ready to go to new CPU/cfs_rq. But we have difficulty in getting
> +        * what current time is, so simply throw away the out-of-date time. This
> +        * will result in the wakee task is less decayed, but giving the wakee more
> +        * load sounds not bad.
> +        */
> +       se->avg.last_update_time = 0;
> 
>         /* We have migrated, no longer consider this task hot */
>         se->exec_start = 0;
> @@ -5399,36 +5245,6 @@ next:
>  }
