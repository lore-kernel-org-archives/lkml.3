Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752962AbbADW7r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2015 17:59:47 -0500
Received: from forward2m.mail.yandex.net ([37.140.138.2]:55808 "EHLO
	forward2m.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789AbbADW7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2015 17:59:45 -0500
X-Greylist: delayed 495 seconds by postgrey-1.27 at vger.kernel.org; Sun, 04 Jan 2015 17:59:45 EST
From: Kirill Tkhai <tkhai@yandex.ru>
To: luca abeni <luca.abeni@unitn.it>, Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, Juri Lelli <juri.lelli@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20141230002738.6c12db31@utopia>
References: <20141230002738.6c12db31@utopia>
Subject: Re: Another SCHED_DEADLINE bug (with bisection and possible fix)
MIME-Version: 1.0
Message-Id: <2629881420411885@web9m.yandex.ru>
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Date: Mon, 05 Jan 2015 01:51:25 +0300
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Luca,

I've just notived this.

30.12.2014, 02:27, "luca abeni" <luca.abeni@unitn.it>:
> Hi all,
>
> when running some experiments on current git master, I noticed a
> regression respect to version 3.18 of the kernel: when invoking
> sched_setattr() to change the SCHED_DEADLINE parameters of a task that
> is already scheduled by SCHED_DEADLINE, it is possible to crash the
> system.
>
> The bug can be reproduced with this testcase:
> http://disi.unitn.it/~abeni/reclaiming/bug-test.tgz
> Uncompress it, enter the "Bug-Test" directory, and type "make test".
> After few cycles, my test machine (a laptop with an intel i7 CPU)
> becomes unusable, and freezes.
>
> Since I know that 3.18 is not affected by this bug, I tried a bisect,
> that pointed to commit 67dfa1b756f250972bde31d65e3f8fde6aeddc5b
> (sched/deadline: Implement cancel_dl_timer() to use in
> switched_from_dl()).
> By looking at that commit, I suspect the problem is that it removes the
> following lines from init_dl_task_timer():
> - ššššššif (hrtimer_active(timer)) {
> - ššššššššššššššhrtimer_try_to_cancel(timer);
> - ššššššššššššššreturn;
> - šššššš}
>
> As a result, when changing the parameters of a SCHED_DEADLINE task
> init_dl_task_timer() is invoked again, and it can initialize a pending
> timer (not sure why, but this seems to be the cause of the freezes I am
> seeing).
>
> So, I modified core.c::__setparam_dl() to invoke init_dl_task_timer()
> only if the task is not already scheduled by SCHED_DEADLINE...
> Basically, I changed
> ššššššššinit_dl_task_timer(dl_se);
> into
> ššššššššif (p->sched_class != &dl_sched_class) {
> ššššššššššššššššinit_dl_task_timer(dl_se);
> šššššššš}
>
> I am not sure if this is the correct fix, but with this change the
> kernel survives my test script (mentioned above), and arrives to 500
> cycles (without my patch, it crashes after 2 or 3 cycles).
>
> What do you think? Is my patch correct, or should I fix the issue in a
> different way?

I think we should do something like below.

hrtimer_init() is already called in sched_fork(), so we shouldn't do this
twice. Also, we shouldn't reinit dl_throttled etc if timer is pending,
and we should prevent a race here.

This passes your test (I waited for 30 cycles), but there's no SOB,
because I need a little time to check everything once again.

 include/linux/sched/deadline.h |  2 ++
 kernel/sched/core.c            | 12 ++++++++----
 kernel/sched/deadline.c        | 10 +---------
 kernel/sched/sched.h           |  1 -
 4 files changed, 11 insertions(+), 14 deletions(-)
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
index c0accc0..a388cc8 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1840,6 +1840,7 @@ static void __sched_fork(unsigned long clone_flags, struct task_struct *p)
 
 	RB_CLEAR_NODE(&p->dl.rb_node);
 	hrtimer_init(&p->dl.dl_timer, CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	p->dl.dl_timer.function = dl_task_timer;
 	__dl_clear_params(p);
 
 	INIT_LIST_HEAD(&p->rt.run_list);
@@ -3250,16 +3251,19 @@ static void
 __setparam_dl(struct task_struct *p, const struct sched_attr *attr)
 {
 	struct sched_dl_entity *dl_se = &p->dl;
+        struct hrtimer *timer = &dl_se->dl_timer;
+
+	if (!hrtimer_active(timer) || hrtimer_try_to_cancel(timer) != -1) {
+		dl_se->dl_throttled = 0;
+		dl_se->dl_new = 1;
+		dl_se->dl_yielded = 0;
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
 
