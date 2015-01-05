Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754142AbbAEXPL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 18:15:11 -0500
Received: from forward3l.mail.yandex.net ([84.201.143.136]:45043 "EHLO
	forward3l.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024AbbAEXPJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 18:15:09 -0500
X-Greylist: delayed 464 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Jan 2015 18:15:09 EST
Authentication-Results: smtp13.mail.yandex.net; dkim=pass header.i=@yandex.ru
Message-ID: <1420499241.3361.14.camel@yandex.ru>
Subject: Re: Another SCHED_DEADLINE bug (with bisection and possible fix)
From: Kirill Tkhai <tkhai@yandex.ru>
Reply-To: tkhai@yandex.ru
To: Luca Abeni <luca.abeni@unitn.it>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Juri Lelli <juri.lelli@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 06 Jan 2015 02:07:21 +0300
In-Reply-To: <54AAABFB.3060109@unitn.it>
References: <20141230002738.6c12db31@utopia>
	 <2629881420411885@web9m.yandex.ru> <54AAABFB.3060109@unitn.it>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.9-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Пн, 2015-01-05 at 16:21 +0100, Luca Abeni wrote:
> Hi Kirill,
> 
> On 01/04/2015 11:51 PM, Kirill Tkhai wrote:
> > Hi, Luca,
> >
> > I've just notived this.
> [...]
> > I think we should do something like below.
> >
> > hrtimer_init() is already called in sched_fork(), so we shouldn't do this
> > twice. Also, we shouldn't reinit dl_throttled etc if timer is pending,
> > and we should prevent a race here.
> Thanks for the comments (I did not notice that hrtimer_init() was called twice)
> and for the patch. I'll test it in the next days.
> 
> For reference, I attach the patch I am using locally (based on what I suggested
> in my previous mail) and seems to work fine here.
> 
> Based on your comments, I suspect my patch can be further simplified by moving
> the call to init_dl_task_timer() in __sched_fork().

It seems this way has problems. The first one is that task may become throttled
again, and we will start dl_timer again. The second is that it's better to minimize
number of combination of situations we have. Let's keep only one combination:
timer is set <-> task is throttled. This makes easier the further development
(just makes less of combinations we have to keep in mind).

> [...]
> > @@ -3250,16 +3251,19 @@ static void
> >   __setparam_dl(struct task_struct *p, const struct sched_attr *attr)
> >   {
> >   	struct sched_dl_entity *dl_se = &p->dl;
> > +        struct hrtimer *timer = &dl_se->dl_timer;
> > +
> > +	if (!hrtimer_active(timer) || hrtimer_try_to_cancel(timer) != -1) {
> Just for the sake of curiosity, why trying to cancel the timer
> ("|| hrtimer_try_to_cancel(timer)") here? If it is active, cannot we leave it
> active (without touching dl_throttled, dl_new and dl_yielded)?
> 
> I mean: if I try to change the parameters of a task when it is throttled, I'd like
> it to stay throttled until the end of the reservation period... Or am I missing
> something?

I think that when people change task's parameters, they want the kernel reacts
on this immediately. For example, you want to kill throttled deadline task.
You change parameters, but nothing happens. I think all developers had this
use case when they were debugging deadline class.

> 
> 
> 				Thanks,
> 					Luca
> 
> > +		dl_se->dl_throttled = 0;
> > +		dl_se->dl_new = 1;
> > +		dl_se->dl_yielded = 0;
> > +	}
> >
> > -	init_dl_task_timer(dl_se);
> >   	dl_se->dl_runtime = attr->sched_runtime;
> >   	dl_se->dl_deadline = attr->sched_deadline;
> >   	dl_se->dl_period = attr->sched_period ?: dl_se->dl_deadline;
> >   	dl_se->flags = attr->sched_flags;
> >   	dl_se->dl_bw = to_ratio(dl_se->dl_period, dl_se->dl_runtime);
> > -	dl_se->dl_throttled = 0;
> > -	dl_se->dl_new = 1;
> > -	dl_se->dl_yielded = 0;
> >   }
> >
> >   /*
> > diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
> > index e5db8c6..8649bd6 100644
> > --- a/kernel/sched/deadline.c
> > +++ b/kernel/sched/deadline.c
> > @@ -500,7 +500,7 @@ static int start_dl_timer(struct sched_dl_entity *dl_se, bool boosted)
> >    * updating (and the queueing back to dl_rq) will be done by the
> >    * next call to enqueue_task_dl().
> >    */
> > -static enum hrtimer_restart dl_task_timer(struct hrtimer *timer)
> > +enum hrtimer_restart dl_task_timer(struct hrtimer *timer)
> >   {
> >   	struct sched_dl_entity *dl_se = container_of(timer,
> >   						     struct sched_dl_entity,
> > @@ -559,14 +559,6 @@ static enum hrtimer_restart dl_task_timer(struct hrtimer *timer)
> >   	return HRTIMER_NORESTART;
> >   }
> >
> > -void init_dl_task_timer(struct sched_dl_entity *dl_se)
> > -{
> > -	struct hrtimer *timer = &dl_se->dl_timer;
> > -
> > -	hrtimer_init(timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
> > -	timer->function = dl_task_timer;
> > -}
> > -
> >   static
> >   int dl_runtime_exceeded(struct rq *rq, struct sched_dl_entity *dl_se)
> >   {
> > diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
> > index 9a2a45c..ad3a2f0 100644
> > --- a/kernel/sched/sched.h
> > +++ b/kernel/sched/sched.h
> > @@ -1257,7 +1257,6 @@ extern void init_rt_bandwidth(struct rt_bandwidth *rt_b, u64 period, u64 runtime
> >
> >   extern struct dl_bandwidth def_dl_bandwidth;
> >   extern void init_dl_bandwidth(struct dl_bandwidth *dl_b, u64 period, u64 runtime);
> > -extern void init_dl_task_timer(struct sched_dl_entity *dl_se);
> >
> >   unsigned long to_ratio(u64 period, u64 runtime);
> >
> >
> 

Please, try this one instead of the patch I sent yesterday.

[PATCH]sched/dl: Prevent initialization of already set dl_timer

__setparam_dl() may be called for a task which is already of
deadline class. If the task is throttled, we corrupt its dl_timer
when we are doing hrtimer_init() in init_dl_task_timer().

It seems that__setparam_dl() is not the place where we want
to use cancel_dl_timer(). It may unlock rq while the call chain
is long, and some of previous functions in the chain may be
unhappy for this reason (now and in the future). So, we just
try to cancel the timer, and in some situations we fail to do that.

If hrtimer_try_to_cancel() fails, than the handler is being
executed on other processor, and it's waiting for rq->lock.
The most probably the handler will take the lock right after
we release it.

So, let's pass the actions, which we do here usually here,
to the handler. It will unthrottle and queue us properly.

Reported-by: Luca Abeni <luca.abeni@unitn.it>
Fixes: 67dfa1b756f2 "sched/deadline: Implement cancel_dl_timer() to use ..."
Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>

 include/linux/sched/deadline.h |  2 ++
 kernel/sched/core.c            | 21 +++++++++++++++++----
 kernel/sched/deadline.c        | 10 +---------
 kernel/sched/sched.h           |  1 -
 4 files changed, 20 insertions(+), 14 deletions(-)

diff --git a/include/linux/sched/deadline.h b/include/linux/sched/deadline.h
index 9d303b8..c70a7fc 100644
--- a/include/linux/sched/deadline.h
+++ b/include/linux/sched/deadline.h
@@ -21,4 +21,6 @@ static inline int dl_task(struct task_struct *p)
 	return dl_prio(p->prio);
 }
 
+extern enum hrtimer_restart dl_task_timer(struct hrtimer *timer);
+
 #endif /* _SCHED_DEADLINE_H */
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index c0accc0..8fc8a2d 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1840,6 +1840,7 @@ static void __sched_fork(unsigned long clone_flags, struct task_struct *p)
 
 	RB_CLEAR_NODE(&p->dl.rb_node);
 	hrtimer_init(&p->dl.dl_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	p->dl.dl_timer.function = dl_task_timer;
 	__dl_clear_params(p);
 
 	INIT_LIST_HEAD(&p->rt.run_list);
@@ -3250,16 +3251,28 @@ static void
 __setparam_dl(struct task_struct *p, const struct sched_attr *attr)
 {
 	struct sched_dl_entity *dl_se = &p->dl;
+        struct hrtimer *timer = &dl_se->dl_timer;
+	struct rq *rq = task_rq(p);
+
+	/*
+	 * There may be a race with dl_task_timer. If it's pending and
+	 * we've failed to cancel it, timer's handler will unthrottle
+	 * the task right after p's rq is unlocked.
+	 */
+	if (!hrtimer_active(timer) || hrtimer_try_to_cancel(timer) != -1) {
+		dl_se->dl_throttled = 0;
+		dl_se->dl_new = 1;
+		dl_se->dl_yielded = 0;
+	} else {
+		dl_se->deadline = rq_clock(rq) + attr->sched_deadline;
+		dl_se->runtime = attr->sched_runtime;
+	}
 
-	init_dl_task_timer(dl_se);
 	dl_se->dl_runtime = attr->sched_runtime;
 	dl_se->dl_deadline = attr->sched_deadline;
 	dl_se->dl_period = attr->sched_period ?: dl_se->dl_deadline;
 	dl_se->flags = attr->sched_flags;
 	dl_se->dl_bw = to_ratio(dl_se->dl_period, dl_se->dl_runtime);
-	dl_se->dl_throttled = 0;
-	dl_se->dl_new = 1;
-	dl_se->dl_yielded = 0;
 }
 
 /*
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index e5db8c6..8649bd6 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -500,7 +500,7 @@ static int start_dl_timer(struct sched_dl_entity *dl_se, bool boosted)
  * updating (and the queueing back to dl_rq) will be done by the
  * next call to enqueue_task_dl().
  */
-static enum hrtimer_restart dl_task_timer(struct hrtimer *timer)
+enum hrtimer_restart dl_task_timer(struct hrtimer *timer)
 {
 	struct sched_dl_entity *dl_se = container_of(timer,
 						     struct sched_dl_entity,
@@ -559,14 +559,6 @@ static enum hrtimer_restart dl_task_timer(struct hrtimer *timer)
 	return HRTIMER_NORESTART;
 }
 
-void init_dl_task_timer(struct sched_dl_entity *dl_se)
-{
-	struct hrtimer *timer = &dl_se->dl_timer;
-
-	hrtimer_init(timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
-	timer->function = dl_task_timer;
-}
-
 static
 int dl_runtime_exceeded(struct rq *rq, struct sched_dl_entity *dl_se)
 {
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index 9a2a45c..ad3a2f0 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1257,7 +1257,6 @@ extern void init_rt_bandwidth(struct rt_bandwidth *rt_b, u64 period, u64 runtime
 
 extern struct dl_bandwidth def_dl_bandwidth;
 extern void init_dl_bandwidth(struct dl_bandwidth *dl_b, u64 period, u64 runtime);
-extern void init_dl_task_timer(struct sched_dl_entity *dl_se);
 
 unsigned long to_ratio(u64 period, u64 runtime);
 


