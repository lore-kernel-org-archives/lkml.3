Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752954AbaBYOPB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 09:15:01 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:63949 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505AbaBYOO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 09:14:59 -0500
Date: Tue, 25 Feb 2014 15:15:15 +0100
From: Juri Lelli <juri.lelli@gmail.com>
To: tkhai@yandex.ru
Cc: Peter Zijlstra <peterz@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [RFC] sched/deadline: Prevent rt_time growth to infinity
Message-Id: <20140225151515.617714e2f2cd6c558531ba61@gmail.com>
In-Reply-To: <5307F5DB.3000705@yandex.ru>
References: <230991392848160@web13m.yandex.ru>
	<20140221103715.GP9987@twins.programming.kicks-ass.net>
	<20140221173641.a060b3d6c0993c21e77f29c2@gmail.com>
	<5307F5DB.3000705@yandex.ru>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Feb 2014 04:56:59 +0400
Kirill Tkhai <tkhai@yandex.ru> wrote:

> On 21.02.2014 20:36, Juri Lelli wrote:
> > On Fri, 21 Feb 2014 11:37:15 +0100
> > Peter Zijlstra <peterz@infradead.org> wrote:
> > 
> >> On Thu, Feb 20, 2014 at 02:16:00AM +0400, Kirill Tkhai wrote:
> >>> Since deadline tasks share rt bandwidth, we must care about
> >>> bandwidth timer set. Otherwise rt_time may grow up to infinity
> >>> in update_curr_dl(), if there are no other available RT tasks
> >>> on top level bandwidth.
> >>>
> >>> I'm going to decide the problem the way below. Almost untested
> >>> because of I skipped almost all of recent patches which haveto be applied from lkml.
> >>>
> >>> Please say, if I skipped anything in idea. Maybe better put
> >>> start_top_rt_bandwidth() into set_curr_task_dl()?
> >>
> >> How about we only increment rt_time when there's an RT bandwidth timer
> >> active?
> >>
> >>
> >> ---
> >> --- a/kernel/sched/rt.c
> >> +++ b/kernel/sched/rt.c
> >> @@ -568,6 +568,12 @@ static inline struct rt_bandwidth *sched
> >>  
> >>  #endif /* CONFIG_RT_GROUP_SCHED */
> >>  
> >> +bool sched_rt_bandwidth_active(struct rt_rq *rt_rq)
> >> +{
> >> +	struct rt_bandwidth *rt_b = sched_rt_bandwidth(rt_rq);
> >> +	return hrtimer_active(&rt_b->rt_period_timer);
> >> +}
> >> +
> >>  #ifdef CONFIG_SMP
> >>  /*
> >>   * We ran out of runtime, see if we can borrow some from our neighbours.
> >> --- a/kernel/sched/deadline.c
> >> +++ b/kernel/sched/deadline.c
> >> @@ -587,6 +587,8 @@ int dl_runtime_exceeded(struct rq *rq, s
> >>  	return 1;
> >>  }
> >>  
> >> +extern bool sched_rt_bandwidth_active(struct rt_rq *rt_rq);
> >> +
> >>  /*
> >>   * Update the current task's runtime statistics (provided it is still
> >>   * a -deadline task and has not been removed from the dl_rq).
> >> @@ -650,11 +652,13 @@ static void update_curr_dl(struct rq *rq
> >>  		struct rt_rq *rt_rq = &rq->rt;
> >>  
> >>  		raw_spin_lock(&rt_rq->rt_runtime_lock);
> >> -		rt_rq->rt_time += delta_exec;
> >>  		/*
> >>  		 * We'll let actual RT tasks worry about the overflow here, we
> >> -		 * have our own CBS to keep us inline -- see above.
> >> +		 * have our own CBS to keep us inline; only account when RT
> >> +		 * bandwidth is relevant.
> >>  		 */
> >> +		if (sched_rt_bandwidth_active(rt_rq))
> >> +			rt_rq->rt_time += delta_exec;
> >>  		raw_spin_unlock(&rt_rq->rt_runtime_lock);
> >>  	}
> >>  }
> > 
> > So, I ran some tests with the above and I'd like to share with you what
> > I've found. You can find here a trace-cmd trace that should be feeded
> > to kernelshark to be able to understand what follows (or feel free to
> > reproduce same scenario :)):
> > http://retis.sssup.it/~jlelli/traces/trace_rt_time.dat
> > 
> > Here you have a DL task (4/10) and a while(1) RT task, both running
> > inside a rt_bw of 0.5. RT tasks is activated 500ms after DL. As I
> > filtered in sched_rt_period_timer(), you can search for time instants
> > when the rt_bw is replenished. It is evident that the first time after
> > rt timer is activated back (search for start_bandwidth_timer), we can
> > eat some bw to FAIR tasks (if any). This is due to the fact that we
> > reset rt_bw budget at this time, start decrementing rt_time for both DL
> > and RT tasks, throttle RT tasks when rt_time > runtime, but, since DL
> > tasks acually executes inside their own server, they don't care about
> > rt_bw. Good news is that steady state is ok: keeping track of overruns
> > we are able to stop eating bw to other guys.
> > 
> > My thougths:
> > 
> >  - Peter's patch is an easy fix to Kirill's problem (RT tasks were
> >    throttled too early);
> >  - something to add to this solution could be to pre-calculate bw of
> >    ready DL tasks and subtract it to rt_bw at replenishment time, but
> >    it sounds quite awkward, pessimistic, and I'm not sure it is gonna
> >    work;
> >  - we are stealing bw to best-effort tasks, and just at the beginning
> >    of the transistion, is it really a problem?
> >  - I mean, if you want guarantees make your tasks DL! :);
> >  - in the long run we are gonna have RT tasks scheduled inside CBS
> >    servers, and all this will be properly fixed up.
> > 
> > Comments?
> > 
> > BTW, rt timer activation/deactivation should probably be fixed for
> > !RT_GROUP_SCHED with something like this:
> > 
> > ---
> >  kernel/sched/rt.c |   10 +++++++---
> >  1 file changed, 7 insertions(+), 3 deletions(-)
> > 
> > diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
> > index 6161de8..274f992 100644
> > --- a/kernel/sched/rt.c
> > +++ b/kernel/sched/rt.c
> > @@ -86,12 +86,12 @@ void init_rt_rq(struct rt_rq *rt_rq, struct rq *rq)
> >  	raw_spin_lock_init(&rt_rq->rt_runtime_lock);
> >  }
> >  
> > -#ifdef CONFIG_RT_GROUP_SCHED
> >  static void destroy_rt_bandwidth(struct rt_bandwidth *rt_b)
> >  {
> >  	hrtimer_cancel(&rt_b->rt_period_timer);
> >  }
> >  
> > +#ifdef CONFIG_RT_GROUP_SCHED
> >  #define rt_entity_is_task(rt_se) (!(rt_se)->my_q)
> >  
> >  static inline struct task_struct *rt_task_of(struct sched_rt_entity *rt_se)
> > @@ -1017,8 +1017,12 @@ inc_rt_group(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
> >  	start_rt_bandwidth(&def_rt_bandwidth);
> >  }
> >  
> > -static inline
> > -void dec_rt_group(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq) {}
> > +static void
> > +dec_rt_group(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
> > +{
> > +	if (!rt_rq->rt_nr_running)
> > +		destroy_rt_bandwidth(&def_rt_bandwidth);
> > +}
> >  
> >  #endif /* CONFIG_RT_GROUP_SCHED */
> >  
> 
> It looks with both patches applied, we may get into a situation,
> when all CPU time is shared between RT and DL tasks:
> 
> rt_runtime = n
> rt_period  = 2n
> 
> | RT working, DL sleeping  | DL working, RT sleeping      |
> -----------------------------------------------------------
> | (1)     duration = n     | (2)     duration = n         | (repeat)
> |--------------------------|------------------------------|
> | (rt_bw timer is running) | (rt_bw timer is not running) |
> 
> No time for fair tasks at all.

Ok, this situation is pathological. DL bandwidth is guaranteed at
admission control, while RT isn't. In this case RT tasks are doomed by
construction. Still you'd like to let FAIR tasks execute :).

I argumented on a slightly different solution in what follows, what you
think?

Thanks,

- Juri

>From e44fe2eef34433a7799cfc153f467f7c62813596 Mon Sep 17 00:00:00 2001
From: Juri Lelli <juri.lelli@gmail.com>
Date: Fri, 21 Feb 2014 11:37:15 +0100
Subject: [PATCH] sched/deadline: Prevent rt_time growth to infinity

Kirill Tkhai noted:
Since deadline tasks share rt bandwidth, we must care about
bandwidth timer set. Otherwise rt_time may grow up to infinity
in update_curr_dl(), if there are no other available RT tasks
on top level bandwidth.

RT task were in fact throttled right after they got enqueued,
and never executed again (rt_time never again went below rt_runtime).

Peter than proposed to accrue DL execution on rt_time only when
rt timer is active, and proposed a patch (this patch is a slight
modification of that) to implement that behavior. While this
solves Kirill problem, it has a drawback.

Indeed, Kirill noted again:
It looks we may get into a situation, when all CPU time is shared
between RT and DL tasks:

rt_runtime = n
rt_period  = 2n

| RT working, DL sleeping  | DL working, RT sleeping      |
-----------------------------------------------------------
| (1)     duration = n     | (2)     duration = n         | (repeat)
|--------------------------|------------------------------|
| (rt_bw timer is running) | (rt_bw timer is not running) |

No time for fair tasks at all.

While this can happen during the first period, if rq is always backlogged,
RT tasks won't have the opportunity to execute anymore: rt_time reached
rt_runtime during (1), suppose after (2) RT is enqueued back, it gets
throttled since rt timer didn't fire, replenishment is from now on eaten up
by DL tasks that accrue their execution on rt_time (while rt timer is
active - we have an RT task waiting for replenishment). FAIR tasks are
not touched after this first period. Ok, this is not ideal, and the situation
is even worse!

What above (the nice case), practically never happens in reality, where
your rt timer is not aligned to tasks periods, tasks are in general not
periodic, etc.. Long story short, you always risk to overload your system.

This patch is based on Peter's idea, but exploits an additional fact:
if you don't have RT tasks enqueued, it makes little sense to continue
incrementing rt_time once you reached the upper limit (DL tasks have their
own mechanism for throttling).

This cures both problems:

 - no matter how many DL instances in the past, you'll have an rt_time
   slightly above rt_runtime when an RT task is enqueued, and from that
   point on (after the first replenishment), the task will normally execute;

 - you can still eat up all bandwidth during the first period, but not
   anymore after that, remember that DL execution will increment rt_time
   till the upper limit is reached.

The situation is still not perfect! But, we have a simple solution for now,
that limits how much you can jeopardize your system, as we keep working
towards the right answer: RT groups scheduled using deadline servers.

Signed-off-by: Juri Lelli <juri.lelli@gmail.com>
---
 kernel/sched/deadline.c |    8 ++++++--
 kernel/sched/rt.c       |    8 ++++++++
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 15cbc17..f59d774 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -564,6 +564,8 @@ int dl_runtime_exceeded(struct rq *rq, struct sched_dl_entity *dl_se)
 	return 1;
 }
 
+extern bool sched_rt_bandwidth_account(struct rt_rq *rt_rq);
+
 /*
  * Update the current task's runtime statistics (provided it is still
  * a -deadline task and has not been removed from the dl_rq).
@@ -627,11 +629,13 @@ static void update_curr_dl(struct rq *rq)
 		struct rt_rq *rt_rq = &rq->rt;
 
 		raw_spin_lock(&rt_rq->rt_runtime_lock);
-		rt_rq->rt_time += delta_exec;
 		/*
 		 * We'll let actual RT tasks worry about the overflow here, we
-		 * have our own CBS to keep us inline -- see above.
+		 * have our own CBS to keep us inline; only account when RT
+		 * bandwidth is relevant.
 		 */
+		if (sched_rt_bandwidth_account(rt_rq))
+			rt_rq->rt_time += delta_exec;
 		raw_spin_unlock(&rt_rq->rt_runtime_lock);
 	}
 }
diff --git a/kernel/sched/rt.c b/kernel/sched/rt.c
index 7dba25a..7f372e1 100644
--- a/kernel/sched/rt.c
+++ b/kernel/sched/rt.c
@@ -538,6 +538,14 @@ static inline struct rt_bandwidth *sched_rt_bandwidth(struct rt_rq *rt_rq)
 
 #endif /* CONFIG_RT_GROUP_SCHED */
 
+bool sched_rt_bandwidth_account(struct rt_rq *rt_rq)
+{
+	struct rt_bandwidth *rt_b = sched_rt_bandwidth(rt_rq);
+
+	return (hrtimer_active(&rt_b->rt_period_timer) ||
+		rt_rq->rt_time < rt_b->rt_runtime);
+}
+
 #ifdef CONFIG_SMP
 /*
  * We ran out of runtime, see if we can borrow some from our neighbours.
-- 
1.7.9.5
