Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011AbaA3M4t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 07:56:49 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:33439 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752666AbaA3M4s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 07:56:48 -0500
MIME-Version: 1.0
In-Reply-To: <20140130123710.GA2936@laptop.programming.kicks-ass.net>
References: <20140128171634.974847076@infradead.org> <20140128171948.287518863@infradead.org>
 <CAKfTPtAgR5xdr-Vj14t+RRVoLACrvTsHw_mXgimUDKsuNBUKJA@mail.gmail.com> <20140130123710.GA2936@laptop.programming.kicks-ass.net>
From: Vincent Guittot <vincent.guittot@linaro.org>
Date: Thu, 30 Jan 2014 13:56:28 +0100
Message-ID: <CAKfTPtAbZ-nGM-UXLKF_AZ8DKQJEV8axeu7mcwSQ=e++Pjqgqg@mail.gmail.com>
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

On 30 January 2014 13:37, Peter Zijlstra <peterz@infradead.org> wrote:
> On Thu, Jan 30, 2014 at 01:18:09PM +0100, Vincent Guittot wrote:
>> On 28 January 2014 18:16, Peter Zijlstra <peterz@infradead.org> wrote:
>>
>> [snip]
>>
>> >
>> > @@ -4662,9 +4682,86 @@ static void check_preempt_wakeup(struct
>> >  static struct task_struct *
>> >  pick_next_task_fair(struct rq *rq, struct task_struct *prev)
>> >  {
>> > -       struct task_struct *p;
>> >         struct cfs_rq *cfs_rq = &rq->cfs;
>> >         struct sched_entity *se;
>> > +       struct task_struct *p;
>> > +
>> > +#ifdef CONFIG_FAIR_GROUP_SCHED
>> > +       if (!cfs_rq->nr_running)
>> > +               return NULL;
>>
>> Couldn't you move the test above out of the CONFIG_FAIR_GROUP_SCHED
>> and remove the same test that is done after the simple label
>
> No, we have to check it twice because..
>>
>> > +
>> > +       if (prev->sched_class != &fair_sched_class)
>> > +               goto simple;
>> > +
>> > +       /*
>> > +        * Because of the set_next_buddy() in dequeue_task_fair() it is rather
>> > +        * likely that a next task is from the same cgroup as the current.
>> > +        *
>> > +        * Therefore attempt to avoid putting and setting the entire cgroup
>> > +        * hierarchy, only change the part that actually changes.
>> > +        */
>> > +
>> > +       do {
>> > +               struct sched_entity *curr = cfs_rq->curr;
>> > +
>> > +               /*
>> > +                * Since we got here without doing put_prev_entity() we also
>> > +                * have to consider cfs_rq->curr. If it is still a runnable
>> > +                * entity, update_curr() will update its vruntime, otherwise
>> > +                * forget we've ever seen it.
>> > +                */
>> > +               if (curr && curr->on_rq)
>> > +                       update_curr(cfs_rq);
>> > +               else
>> > +                       curr = NULL;
>> > +
>> > +               /*
>> > +                * This call to check_cfs_rq_runtime() will do the throttle and
>> > +                * dequeue its entity in the parent(s). Therefore the 'simple'
>> > +                * nr_running test will indeed be correct.
>> > +                */
>> > +               if (unlikely(check_cfs_rq_runtime(cfs_rq)))
>> > +                       goto simple;
>
> ... here if you read the comment above, we could have modified the
> nr_running.

ok, i missed this point

>
>> > +               se = pick_next_entity(cfs_rq, curr);
>> > +               cfs_rq = group_cfs_rq(se);
>> > +       } while (cfs_rq);
>> > +
>> > +       p = task_of(se);
>> > +
>> > +       /*
>> > +        * Since we haven't yet done put_prev_entity and if the selected task
>> > +        * is a different task than we started out with, try and touch the
>> > +        * least amount of cfs_rqs.
>> > +        */
>> > +       if (prev != p) {
>> > +               struct sched_entity *pse = &prev->se;
>> > +
>> > +               while (!(cfs_rq = is_same_group(se, pse))) {
>> > +                       int se_depth = se->depth;
>> > +                       int pse_depth = pse->depth;
>> > +
>> > +                       if (se_depth <= pse_depth) {
>> > +                               put_prev_entity(cfs_rq_of(pse), pse);
>> > +                               pse = parent_entity(pse);
>> > +                       }
>> > +                       if (se_depth >= pse_depth) {
>> > +                               set_next_entity(cfs_rq_of(se), se);
>> > +                               se = parent_entity(se);
>> > +                       }
>> > +               }
>> > +
>> > +               put_prev_entity(cfs_rq, pse);
>> > +               set_next_entity(cfs_rq, se);
>> > +       }
>> > +
>> > +       if (hrtick_enabled(rq))
>> > +               hrtick_start_fair(rq, p);
>> > +
>> > +       return p;
>> > +simple:
>> > +       cfs_rq = &rq->cfs;
>> > +#endif
>> >
>> >         if (!cfs_rq->nr_running)
>> >                 return NULL;
>
> And therefore this test needs to stay.
