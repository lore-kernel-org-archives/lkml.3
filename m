Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535AbaJ0OlB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 10:41:01 -0400
Received: from relay.parallels.com ([195.214.232.42]:49111 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274AbaJ0Ok7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 10:40:59 -0400
Message-ID: <1414420852.19914.186.camel@tkhai>
Subject: [PATCH v3] sched/dl: Implement cancel_dl_timer() to use in
 switched_from_dl()
From: Kirill Tkhai <ktkhai@parallels.com>
To: <linux-kernel@vger.kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Kirill Tkhai <tkhai@yandex.ru>
Date: Mon, 27 Oct 2014 17:40:52 +0300
Organization: Parallels
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5-2+b3 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.26.172]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


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
this has already been possible in pull_dl_task() below.

Let's consider the safety of of this unlocking. New code in the patch
is working when hrtimer_try_to_cancel() fails. This means the callback
is running. In this case hrtimer_cancel() is just waiting till the
callback is finished. Two

1)Since we are in switched_from_dl(), new class is not dl_sched_class and
new prio is not less MAX_DL_PRIO. So, the callback returns early; it's
right after !dl_task() check. After that hrtimer_cancel() returns back too.

The above is:

raw_spin_lock(rq->lock);                  ...
...                                       dl_task_timer()
...                                          raw_spin_lock(rq->lock);
   switched_from_dl()                        ...
       hrtimer_try_to_cancel()               ...
          raw_spin_unlock(rq->lock);         ...
          hrtimer_cancel()                   ...
          ...                                raw_spin_unlock(rq->lock);
          ...                                return HRTIMER_NORESTART;
          ...                             ...
          raw_spin_lock(rq->lock);        ...

2)But the below is also possible:
                                   dl_task_timer()
                                      raw_spin_lock(rq->lock);
                                      ...
                                      raw_spin_unlock(rq->lock);
raw_spin_lock(rq->lock);              ...
   switched_from_dl()                 ...
       hrtimer_try_to_cancel()        ...
       ...                            return HRTIMER_NORESTART;
       raw_spin_unlock(rq->lock);  ...
       hrtimer_cancel();           ...
       raw_spin_lock(rq->lock);    ...

In this case hrtimer_cancel() returns immediately. Very unlikely case,
just to mention.


Nobody can manipulate the task, because check_class_changed() is
always called with pi_lock locked. Nobody can force the task to
participate in (concurrent) priority inheritance schemes (the same reason).

All concurrent task operations require pi_lock, which is held by us.
No deadlocks with dl_task_timer() are possible, because it returns
right after !dl_task() check (it does nothing).

If we receive a new dl_task during the time of unlocked rq, we just
don't have to do pull_dl_task() in switched_from_dl() further.

Signed-off-by: Kirill Tkhai <ktkhai@parallels.com>
---
 kernel/sched/deadline.c |   34 +++++++++++++++++++++++++++-------
 1 file changed, 27 insertions(+), 7 deletions(-)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 256e577..9435e05 100644
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
@@ -1567,10 +1562,35 @@ void init_sched_dl_class(void)
 
 #endif /* CONFIG_SMP */
 
+/*
+ *  Ensure p's dl_timer is cancelled. May drop rq->lock for a while.
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
+			 * A caller of us must be fine with that.
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
 



