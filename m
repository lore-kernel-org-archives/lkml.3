Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754886AbaKDQLG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 11:11:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59475 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754034AbaKDQLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 11:11:03 -0500
Date: Tue, 4 Nov 2014 08:09:54 -0800
From: tip-bot for Kirill Tkhai <tipbot@zytor.com>
Message-ID: <tip-67dfa1b756f250972bde31d65e3f8fde6aeddc5b@git.kernel.org>
Cc: ktkhai@parallels.com, hpa@zytor.com, peterz@infradead.org,
        tglx@linutronix.de, mingo@kernel.org, linux-kernel@vger.kernel.org,
        juri.lelli@arm.com, torvalds@linux-foundation.org
Reply-To: linux-kernel@vger.kernel.org, mingo@kernel.org,
        torvalds@linux-foundation.org, juri.lelli@arm.com,
        peterz@infradead.org, tglx@linutronix.de, hpa@zytor.com,
        ktkhai@parallels.com
In-Reply-To: <1414420852.19914.186.camel@tkhai>
References: <1414420852.19914.186.camel@tkhai>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched/deadline: Implement cancel_dl_timer()
  to use in switched_from_dl()
Git-Commit-ID: 67dfa1b756f250972bde31d65e3f8fde6aeddc5b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  67dfa1b756f250972bde31d65e3f8fde6aeddc5b
Gitweb:     http://git.kernel.org/tip/67dfa1b756f250972bde31d65e3f8fde6aeddc5b
Author:     Kirill Tkhai <ktkhai@parallels.com>
AuthorDate: Mon, 27 Oct 2014 17:40:52 +0300
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 4 Nov 2014 07:17:50 +0100

sched/deadline: Implement cancel_dl_timer() to use in switched_from_dl()

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

1) Since we are in switched_from_dl(), new class is not dl_sched_class and
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

2) But the below is also possible:
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
[ Added comments]
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Juri Lelli <juri.lelli@arm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1414420852.19914.186.camel@tkhai
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/core.c     |  4 ++++
 kernel/sched/deadline.c | 34 +++++++++++++++++++++++++++-------
 kernel/sched/sched.h    |  5 +++++
 3 files changed, 36 insertions(+), 7 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 0cd34e6..379cb87 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1008,6 +1008,9 @@ inline int task_curr(const struct task_struct *p)
 	return cpu_curr(task_cpu(p)) == p;
 }
 
+/*
+ * Can drop rq->lock because from sched_class::switched_from() methods drop it.
+ */
 static inline void check_class_changed(struct rq *rq, struct task_struct *p,
 				       const struct sched_class *prev_class,
 				       int oldprio)
@@ -1015,6 +1018,7 @@ static inline void check_class_changed(struct rq *rq, struct task_struct *p,
 	if (prev_class != p->sched_class) {
 		if (prev_class->switched_from)
 			prev_class->switched_from(rq, p);
+		/* Possble rq->lock 'hole'.  */
 		p->sched_class->switched_to(rq, p);
 	} else if (oldprio != p->prio || dl_task(p))
 		p->sched_class->prio_changed(rq, p, oldprio);
diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 2e31a30..9d483e8 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -563,11 +563,6 @@ void init_dl_task_timer(struct sched_dl_entity *dl_se)
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
@@ -1610,10 +1605,35 @@ void init_sched_dl_class(void)
 
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
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index ec3917c..49b941f 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -1157,6 +1157,11 @@ struct sched_class {
 	void (*task_fork) (struct task_struct *p);
 	void (*task_dead) (struct task_struct *p);
 
+	/*
+	 * The switched_from() call is allowed to drop rq->lock, therefore we
+	 * cannot assume the switched_from/switched_to pair is serliazed by
+	 * rq->lock. They are however serialized by p->pi_lock.
+	 */
 	void (*switched_from) (struct rq *this_rq, struct task_struct *task);
 	void (*switched_to) (struct rq *this_rq, struct task_struct *task);
 	void (*prio_changed) (struct rq *this_rq, struct task_struct *task,
