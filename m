Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816AbaF0M5l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 08:57:41 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:42605 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752537AbaF0M5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 08:57:39 -0400
Message-ID: <1403873856.5827.56.camel@marge.simpson.net>
Subject: Re: Filesystem lockup with CONFIG_PREEMPT_RT
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Austin Schuh <austin@peloton-tech.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        rt-users <linux-rt-users@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>
Date: Fri, 27 Jun 2014 14:57:36 +0200
In-Reply-To: <CANGgnMa+qtgJ3wwg_h5Rynw5vEvZpQZ6PvaUfXNQ8+Y3Yu5U0g@mail.gmail.com>
References: <CANGgnMbHckBQdKGN_N5Q6qEKc9n1CenxvMpeXog1NbSdL8UrTw@mail.gmail.com>
	 <CANGgnMYDXerOUDOO9-RHMJKadKACA2KBGskZwoP-1ZwAhDEfVA@mail.gmail.com>
	 <CAFLxGvxfBt7OvW=a2Kz08GLHSEiiOZsN-vB19CXnQiwqFxqMsA@mail.gmail.com>
	 <CANGgnMYVoP-Z0Bv-VDEkJnvfa7Fi4-zY2F4A0PhMewGvwo3VVw@mail.gmail.com>
	 <alpine.DEB.2.10.1406270027300.5170@nanos>
	 <CANGgnMa+qtgJ3wwg_h5Rynw5vEvZpQZ6PvaUfXNQ8+Y3Yu5U0g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-06-26 at 17:07 -0700, Austin Schuh wrote:

> I'm not sure where to go from there.  Any changes to the workpool to
> try to fix that will be hard, or could affect latency significantly.

Oh what the hell, I'm out of frozen shark, may as well stock up.  Nobody
else has posted spit yet.  I _know_ Steven has some shark, I saw tglx
toss him a chunk.

It's the same root cause as -rt letting tasks schedule off with plugged
IO, leading to deadlock scenarios.  Extending the way I dealt with that
to deal with workqueue forward progress requirements.. works.. though it
could perhaps use a face lift, tummy tuck.. and minor body-ectomy.

Subject: rtmutex: move pre/post schedule() progress guarantees to before we schedule

Queued IO can lead to IO deadlock should a task require wakeup from as task
which is blocked on that queued IO, which is why we usually pull the plug
while scheduling off.  In RT, pulling the plug could lead us to block on
a contended sleeping lock while n the process of blocking.  Bad idea, so
we don't, but that leaves us with various flavors of IO stall like below.

ext3: dbench1 queues a buffer, blocks on journal mutex, it's plug is not
pulled.  dbench2 mutex owner is waiting for kjournald, who is waiting for
the buffer queued by dbench1.  Game over.

The exact same situation can occur with workqueues.  We must notify the
workqueue management that a worker is blocking, as if we don't, we can
lock the box up completely.  It's too late to do that once we have arrived
in schedule(), as we can't take a sleeping lock.

Therefore, move progress guarantee work up to before we reach the point of
no return, and tell the scheduler that we're handling it early.

Signed-off-by: Mike Galbraith <umgwanakikbuti@gmail.com>
---
 include/linux/sched.h    |    2 +
 kernel/locking/rtmutex.c |   59 +++++++++++++++++++++++++++++++++++++++++++----
 kernel/sched/core.c      |   19 +++++++++++----
 3 files changed, 72 insertions(+), 8 deletions(-)

--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1256,6 +1256,8 @@ struct task_struct {
 	/* Revert to default priority/policy when forking */
 	unsigned sched_reset_on_fork:1;
 	unsigned sched_contributes_to_load:1;
+	unsigned sched_presched:1;
+	unsigned rtmutex_presched:1;
 
 	pid_t pid;
 	pid_t tgid;
--- a/kernel/locking/rtmutex.c
+++ b/kernel/locking/rtmutex.c
@@ -23,6 +23,7 @@
 #include <linux/sched/deadline.h>
 #include <linux/timer.h>
 #include <linux/ww_mutex.h>
+#include <linux/blkdev.h>
 
 #include "rtmutex_common.h"
 
@@ -782,6 +783,41 @@ void rt_mutex_adjust_pi(struct task_stru
 }
 
 #ifdef CONFIG_PREEMPT_RT_FULL
+#include "../workqueue_internal.h"
+
+static inline void rt_mutex_presched(struct task_struct *tsk)
+{
+	/* Recursive handling of presched work is a very bad idea. */
+	if (tsk->rtmutex_presched || tsk->sched_presched)
+		return;
+
+	/* Tell the scheduler we handle pre/post schedule() work. */
+	tsk->rtmutex_presched = 1;
+
+	/*
+	 * If a worker went to sleep, notify and ask workqueue whether
+	 * it wants to wake up a task to maintain concurrency.
+	 */
+	if (tsk->flags & PF_WQ_WORKER)
+		wq_worker_sleeping(tsk);
+
+	/*
+	 * If we are going to sleep and we have plugged IO queued,
+	 * make sure to submit it to avoid deadlocks.
+	 */
+	if (blk_needs_flush_plug(tsk))
+		blk_schedule_flush_plug(tsk);
+}
+
+static inline void rt_mutex_postsched(struct task_struct *tsk)
+{
+	if (!tsk->rtmutex_presched)
+		return;
+	if (tsk->flags & PF_WQ_WORKER)
+		wq_worker_running(tsk);
+	tsk->rtmutex_presched = 0;
+}
+
 /*
  * preemptible spin_lock functions:
  */
@@ -857,13 +893,23 @@ static void  noinline __sched rt_spin_lo
 	struct rt_mutex_waiter waiter, *top_waiter;
 	int ret;
 
+	/*
+	 * We can't do presched work if we're already holding a lock
+	 * else we can deadlock.  eg, if we're holding slab_lock,
+	 * ksoftirqd can block while processing BLOCK_SOFTIRQ after
+	 * having acquired q->queue_lock.  If _we_ then block on
+	 * that q->queue_lock while flushing our plug, deadlock.
+	 */
+	if (__migrate_disabled(self) < 2)
+		rt_mutex_presched(self);
+
 	rt_mutex_init_waiter(&waiter, true);
 
 	raw_spin_lock(&lock->wait_lock);
 
 	if (__try_to_take_rt_mutex(lock, self, NULL, STEAL_LATERAL)) {
 		raw_spin_unlock(&lock->wait_lock);
-		return;
+		goto out;
 	}
 
 	BUG_ON(rt_mutex_owner(lock) == self);
@@ -928,6 +974,8 @@ static void  noinline __sched rt_spin_lo
 	raw_spin_unlock(&lock->wait_lock);
 
 	debug_rt_mutex_free_waiter(&waiter);
+out:
+	rt_mutex_postsched(self);
 }
 
 /*
@@ -1274,18 +1322,20 @@ rt_mutex_slowlock(struct rt_mutex *lock,
 		  int detect_deadlock, struct ww_acquire_ctx *ww_ctx)
 {
 	struct rt_mutex_waiter waiter;
+	struct task_struct *self = current;
 	int ret = 0;
 
+	rt_mutex_presched(self);
 	rt_mutex_init_waiter(&waiter, false);
 
 	raw_spin_lock(&lock->wait_lock);
 
 	/* Try to acquire the lock again: */
-	if (try_to_take_rt_mutex(lock, current, NULL)) {
+	if (try_to_take_rt_mutex(lock, self, NULL)) {
 		if (ww_ctx)
 			ww_mutex_account_lock(lock, ww_ctx);
 		raw_spin_unlock(&lock->wait_lock);
-		return 0;
+		goto out;
 	}
 
 	set_current_state(state);
@@ -1322,7 +1372,8 @@ rt_mutex_slowlock(struct rt_mutex *lock,
 		hrtimer_cancel(&timeout->timer);
 
 	debug_rt_mutex_free_waiter(&waiter);
-
+out:
+	rt_mutex_postsched(self);
 	return ret;
 }
 
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2915,11 +2915,18 @@ static void __sched __schedule(void)
 		goto need_resched;
 }
 
-static inline void sched_submit_work(struct task_struct *tsk)
+static inline void sched_presched_work(struct task_struct *tsk)
 {
+	/* It's being handled by rtmutex code */
+	if (tsk->rtmutex_presched)
+		return;
+
 	if (!tsk->state || tsk_is_pi_blocked(tsk))
 		return;
 
+	/* Tell rtmutex presched code that we're handling it. */
+	tsk->sched_presched = 1;
+
 	/*
 	 * If a worker went to sleep, notify and ask workqueue whether
 	 * it wants to wake up a task to maintain concurrency.
@@ -2935,19 +2942,23 @@ static inline void sched_submit_work(str
 		blk_schedule_flush_plug(tsk);
 }
 
-static inline void sched_update_worker(struct task_struct *tsk)
+static inline void sched_postsched_work(struct task_struct *tsk)
 {
+	/* It's being handled by rtmutex code */
+	if (tsk->rtmutex_presched)
+		return;
 	if (tsk->flags & PF_WQ_WORKER)
 		wq_worker_running(tsk);
+	tsk->sched_presched = 0;
 }
 
 asmlinkage void __sched schedule(void)
 {
 	struct task_struct *tsk = current;
 
-	sched_submit_work(tsk);
+	sched_presched_work(tsk);
 	__schedule();
-	sched_update_worker(tsk);
+	sched_postsched_work(tsk);
 }
 EXPORT_SYMBOL(schedule);
 


