Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751500AbaJBKFW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 06:05:22 -0400
Received: from relay.parallels.com ([195.214.232.42]:43334 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751176AbaJBKFQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 06:05:16 -0400
Message-ID: <1412244310.20287.34.camel@tkhai>
Subject: Re: [PATCH v2 1/3] sched/dl: Implement cancel_dl_timer() to use in
 switched_from_dl()
From: Kirill Tkhai <ktkhai@parallels.com>
To: Peter Zijlstra <peterz@infradead.org>
CC: Kirill Tkhai <tkhai@yandex.ru>, <linux-kernel@vger.kernel.org>,
        "Ingo Molnar" <mingo@redhat.com>, Juri Lelli <juri.lelli@gmail.com>
Date: Thu, 2 Oct 2014 14:05:10 +0400
In-Reply-To: <20141002093408.GB2849@worktop.programming.kicks-ass.net>
References: <20140930210412.5258.35299.stgit@localhost>
	 <20141002093408.GB2849@worktop.programming.kicks-ass.net>
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

В Чт, 02/10/2014 в 11:34 +0200, Peter Zijlstra пишет:
> On Wed, Oct 01, 2014 at 01:04:22AM +0400, Kirill Tkhai wrote:
> > From: Kirill Tkhai <ktkhai@parallels.com>
> > 
> > hrtimer_try_to_cancel() may bring a suprise, its call may fail.
> 
> Well, not really a surprise that, its a _try_ operation after all.
> 
> > raw_spin_lock(&rq->lock)
> > ...                            dl_task_timer                 raw_spin_lock(&rq->lock)
> > ...                               raw_spin_lock(&rq->lock)   ...
> >    switched_from_dl()             ...                        ...
> >       hrtimer_try_to_cancel()     ...                        ...
> >    switched_to_fair()             ...                        ...
> > ...                               ...                        ...
> > ...                               ...                        ...
> > raw_spin_unlock(&rq->lock)        ...                        (asquired)
> > ...                               ...                        ...
> > ...                               ...                        ...
> > do_exit()                         ...                        ...
> >    schedule()                     ...                        ...
> >       raw_spin_lock(&rq->lock)    ...                        raw_spin_unlock(&rq->lock)
> >       ...                         ...                        ...
> >       raw_spin_unlock(&rq->lock)  ...                        raw_spin_lock(&rq->lock)
> >       ...                         ...                        (asquired)
> >       put_task_struct()           ...                        ...
> >           free_task_struct()      ...                        ...
> >       ...                         ...                        raw_spin_unlock(&rq->lock)
> > ...                               (asquired)                 ...
> > ...                               ...                        ...
> > ...                               Surprise!!!                ...
> > 
> > So, let's implement 100% guaranteed way to cancel the timer and let's
> > be sure we are safe even in very unlikely situations.
> > 
> > We do not create any problem with rq unlocking, because it already
> > may happed below in pull_dl_task(). No problem with deadline tasks
> > balancing too.
> 
> That doesn't sound right. pull_dl_task() is an entirely different
> callchain than switched_from(). Now it might still be fine, but you
> cannot compare it with pull_dl_task.

I mean that caller of switched_from_dl() already knows about this situation,
and we do not limit the area of its use.

Does this sound better?

[PATCH] sched/dl: Implement cancel_dl_timer() to use in switched_from_dl()
    
Currently used hrtimer_try_to_cancel() is racy:

raw_spin_lock(&rq->lock)
...                            dl_task_timer                 raw_spin_lock(&rq->lock)
...                               raw_spin_lock(&rq->lock)   ...
   switched_from_dl()             ...                        ...
      hrtimer_try_to_cancel()     ...                        ...
   switched_to_fair()             ...                        ...
...                               ...                        ...
...                               ...                        ...
raw_spin_unlock(&rq->lock)        ...                        (asquired)
...                               ...                        ...
...                               ...                        ...
do_exit()                         ...                        ...
   schedule()                     ...                        ...
      raw_spin_lock(&rq->lock)    ...                        raw_spin_unlock(&rq->lock)
      ...                         ...                        ...
      raw_spin_unlock(&rq->lock)  ...                        raw_spin_lock(&rq->lock)
      ...                         ...                        (asquired)
      put_task_struct()           ...                        ...
          free_task_struct()      ...                        ...
      ...                         ...                        raw_spin_unlock(&rq->lock)
...                               (asquired)                 ...
...                               ...                        ...
...                               (use after free)           ...

    
So, let's implement 100% guaranteed way to cancel the timer and let's
be sure we are safe even in very unlikely situations.

rq unlocking does not limit the area of switched_from_dl() use, because
it already was possible in pull_dl_task() below.

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index abfaf3d..63f8b4a 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -555,11 +555,6 @@ void init_dl_task_timer(struct sched_dl_entity *dl_se)
 {
 	struct hrtimer *timer = &dl_se->dl_timer;
 
-	if (hrtimer_active(timer)) {
-		hrtimer_try_to_cancel(timer);
-		return;
-	}
-
 	hrtimer_init(timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
 	timer->function = dl_task_timer;
 }
@@ -1567,10 +1562,34 @@ void init_sched_dl_class(void)
 
 #endif /* CONFIG_SMP */
 
+/*
+ *  Surely cancel task's dl_timer. May drop rq->lock.
+ */
+static void cancel_dl_timer(struct rq *rq, struct task_struct *p)
+{
+	struct hrtimer *dl_timer = &p->dl.dl_timer;
+
+	/* Nobody will change task's class if pi_lock is held */
+	lockdep_assert_held(&p->pi_lock);
+
+	if (hrtimer_active(dl_timer)) {
+		int ret = hrtimer_try_to_cancel(dl_timer);
+
+		if (unlikely(ret == -1)) {
+			/*
+			 * Note, p may migrate OR new deadline tasks
+			 * may appear in rq when we are unlocking it.
+			 */
+			raw_spin_unlock(&rq->lock);
+			hrtimer_cancel(dl_timer);
+			raw_spin_lock(&rq->lock);
+		}
+	}
+}
+
 static void switched_from_dl(struct rq *rq, struct task_struct *p)
 {
-	if (hrtimer_active(&p->dl.dl_timer) && !dl_policy(p->policy))
-		hrtimer_try_to_cancel(&p->dl.dl_timer);
+	cancel_dl_timer(rq, p);
 
 	__dl_clear_params(p);
 


