Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753089AbaA3MSb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 07:18:31 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:63391 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799AbaA3MSa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 07:18:30 -0500
MIME-Version: 1.0
In-Reply-To: <20140128171948.287518863@infradead.org>
References: <20140128171634.974847076@infradead.org> <20140128171948.287518863@infradead.org>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Thu, 30 Jan 2014 13:18:09 +0100
Message-ID: <CAKfTPtAgR5xdr-Vj14t+RRVoLACrvTsHw_mXgimUDKsuNBUKJA@mail.gmail.com>
Subject: Re: [PATCH 7/9] sched/fair: Optimize cgroup pick_next_task_fair
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Paul Turner <pjt@google.com>, Benjamin Segall <bsegall@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mike Galbraith <bitbucket@online.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28 January 2014 18:16, Peter Zijlstra <peterz@infradead.org> wrote:

[snip]

>
> @@ -4662,9 +4682,86 @@ static void check_preempt_wakeup(struct
>  static struct task_struct *
>  pick_next_task_fair(struct rq *rq, struct task_struct *prev)
>  {
> -       struct task_struct *p;
>         struct cfs_rq *cfs_rq = &rq->cfs;
>         struct sched_entity *se;
> +       struct task_struct *p;
> +
> +#ifdef CONFIG_FAIR_GROUP_SCHED
> +       if (!cfs_rq->nr_running)
> +               return NULL;

Couldn't you move the test above out of the CONFIG_FAIR_GROUP_SCHED
and remove the same test that is done after the simple label

Vincent

> +
> +       if (prev->sched_class != &fair_sched_class)
> +               goto simple;
> +
> +       /*
> +        * Because of the set_next_buddy() in dequeue_task_fair() it is rather
> +        * likely that a next task is from the same cgroup as the current.
> +        *
> +        * Therefore attempt to avoid putting and setting the entire cgroup
> +        * hierarchy, only change the part that actually changes.
> +        */
> +
> +       do {
> +               struct sched_entity *curr = cfs_rq->curr;
> +
> +               /*
> +                * Since we got here without doing put_prev_entity() we also
> +                * have to consider cfs_rq->curr. If it is still a runnable
> +                * entity, update_curr() will update its vruntime, otherwise
> +                * forget we've ever seen it.
> +                */
> +               if (curr && curr->on_rq)
> +                       update_curr(cfs_rq);
> +               else
> +                       curr = NULL;
> +
> +               /*
> +                * This call to check_cfs_rq_runtime() will do the throttle and
> +                * dequeue its entity in the parent(s). Therefore the 'simple'
> +                * nr_running test will indeed be correct.
> +                */
> +               if (unlikely(check_cfs_rq_runtime(cfs_rq)))
> +                       goto simple;
> +
> +               se = pick_next_entity(cfs_rq, curr);
> +               cfs_rq = group_cfs_rq(se);
> +       } while (cfs_rq);
> +
> +       p = task_of(se);
> +
> +       /*
> +        * Since we haven't yet done put_prev_entity and if the selected task
> +        * is a different task than we started out with, try and touch the
> +        * least amount of cfs_rqs.
> +        */
> +       if (prev != p) {
> +               struct sched_entity *pse = &prev->se;
> +
> +               while (!(cfs_rq = is_same_group(se, pse))) {
> +                       int se_depth = se->depth;
> +                       int pse_depth = pse->depth;
> +
> +                       if (se_depth <= pse_depth) {
> +                               put_prev_entity(cfs_rq_of(pse), pse);
> +                               pse = parent_entity(pse);
> +                       }
> +                       if (se_depth >= pse_depth) {
> +                               set_next_entity(cfs_rq_of(se), se);
> +                               se = parent_entity(se);
> +                       }
> +               }
> +
> +               put_prev_entity(cfs_rq, pse);
> +               set_next_entity(cfs_rq, se);
> +       }
> +
> +       if (hrtick_enabled(rq))
> +               hrtick_start_fair(rq, p);
> +
> +       return p;
> +simple:
> +       cfs_rq = &rq->cfs;
> +#endif
>
>         if (!cfs_rq->nr_running)
>                 return NULL;
> @@ -4672,12 +4769,13 @@ pick_next_task_fair(struct rq *rq, struc
>         prev->sched_class->put_prev_task(rq, prev);
>
>         do {
> -               se = pick_next_entity(cfs_rq);
> +               se = pick_next_entity(cfs_rq, NULL);
>                 set_next_entity(cfs_rq, se);
>                 cfs_rq = group_cfs_rq(se);
>         } while (cfs_rq);
>
>         p = task_of(se);
> +
>         if (hrtick_enabled(rq))
>                 hrtick_start_fair(rq, p);
>
>
>
