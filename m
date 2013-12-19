Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769Ab3LSXh0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 18:37:26 -0500
Received: from mail-qe0-f52.google.com ([209.85.128.52]:51441 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756459Ab3LSXhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 18:37:24 -0500
Date: Thu, 19 Dec 2013 18:37:20 -0500
From: Tejun Heo <tj@kernel.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Nigel Cunningham <nigel@nigelcunningham.com.au>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jens Axboe <axboe@kernel.dk>, tomaz.solc@tablix.org,
        aaron.lu@intel.com, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        David Howells <dhowells@redhat.com>
Subject: [PATCH wq/for-3.14 2/2] workqueue: implement @drain for
 workqueue_set_max_active()
Message-ID: <20131219233720.GE22725@htj.dyndns.org>
References: <20131213174932.GA27070@htj.dyndns.org>
 <20131218213936.GA8218@mtj.dyndns.org>
 <20131218214128.GB8218@mtj.dyndns.org>
 <1735137.dNmBz0IqxU@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1735137.dNmBz0IqxU@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Rafael.

If this looks good to you, I'll commit it to wq/for-3.14 and we can at
least start to clean up things.

Thanks!

------- 8< -------
>From 6b5182f3f193d0ff9296f53a4665a55b6477aa77 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Thu, 19 Dec 2013 18:33:12 -0500

workqueue_set_max_active() currently doesn't wait for the number of
in-flight work items to fall under the new @max_active.  This patch
adds @drain paramter to workqueue_set_max_active(), if set, the
function sleeps until nr_active on each pool_workqueue of the target
workqueue drops below the current saved_max_active.

This is planned to replace freezable workqueues.  It is determined
that kernel freezables - both kthreads and workqueues - aren't
necessary and just add to the confusion and unnecessary deadlocks.
There are only a handful which actually need to stop processing for
system power events and they can be converted to use
workqueue_set_max_active(WQ_FROZEN_ACTIVE) instead of freezable
workqueues.  Ultimately, all other uses of freezables will be dropped
and the whole system freezer machinery will be excised.  Well, that's
the plan anyway.

The implementation is fairly straight-forward.  As this is expected to
be used by only a handful and most likely not concurrently, a single
wait queue is used.  set_max_active drainers wait on it as necessary
and pwq_dec_nr_in_flight() triggers it if nr_active == max_active
after nr_active is decremented.  This unfortunately adds on unlikely
branch to the work item execution path but this is extremely unlikely
to be noticeable and I think it's worthwhile to avoid polling here as
there may be multiple calls to this function in succession during
suspend and some platforms use suspend quite frequently.

Signed-off-by: Tejun Heo <tj@kernel.org>
Link: http://lkml.kernel.org/g/20131218213936.GA8218@mtj.dyndns.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: David Howells <dhowells@redhat.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
---
 fs/fscache/main.c         |  2 +-
 include/linux/workqueue.h |  2 +-
 kernel/workqueue.c        | 58 ++++++++++++++++++++++++++++++++++++++++++++---
 3 files changed, 57 insertions(+), 5 deletions(-)

diff --git a/fs/fscache/main.c b/fs/fscache/main.c
index 9d5a716..e2837f2 100644
--- a/fs/fscache/main.c
+++ b/fs/fscache/main.c
@@ -67,7 +67,7 @@ static int fscache_max_active_sysctl(struct ctl_table *table, int write,
 	if (*datap < 1)
 		return -EINVAL;
 
-	workqueue_set_max_active(*wqp, *datap);
+	workqueue_set_max_active(*wqp, *datap, false);
 	return 0;
 }
 
diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 334daa3..8b9c628 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -488,7 +488,7 @@ extern bool cancel_delayed_work(struct delayed_work *dwork);
 extern bool cancel_delayed_work_sync(struct delayed_work *dwork);
 
 extern void workqueue_set_max_active(struct workqueue_struct *wq,
-				     int max_active);
+				     int max_active, bool drain);
 extern bool current_is_workqueue_rescuer(void);
 extern bool workqueue_congested(int cpu, struct workqueue_struct *wq);
 extern unsigned int work_busy(struct work_struct *work);
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 6748fbf..f18c35b 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -293,6 +293,12 @@ static DEFINE_SPINLOCK(wq_mayday_lock);	/* protects wq->maydays list */
 static LIST_HEAD(workqueues);		/* PL: list of all workqueues */
 static bool workqueue_freezing;		/* PL: have wqs started freezing? */
 
+/*
+ * Wait for nr_active to drain after max_active adjustment.  This is a cold
+ * path and not expected to have many users.  A global waitq should do.
+ */
+static DECLARE_WAIT_QUEUE_HEAD(wq_nr_active_drain_waitq);
+
 /* the per-cpu worker pools */
 static DEFINE_PER_CPU_SHARED_ALIGNED(struct worker_pool [NR_STD_WORKER_POOLS],
 				     cpu_worker_pools);
@@ -1123,6 +1129,14 @@ static void pwq_dec_nr_in_flight(struct pool_workqueue *pwq, int color)
 	pwq->nr_in_flight[color]--;
 
 	pwq->nr_active--;
+
+	/*
+	 * This can happen only after max_active is lowered.  Tell the
+	 * waiters that draining might be complete.
+	 */
+	if (unlikely(pwq->nr_active == pwq->max_active))
+		wake_up_all(&wq_nr_active_drain_waitq);
+
 	if (!list_empty(&pwq->delayed_works)) {
 		/* one down, submit a delayed one */
 		if (pwq->nr_active < pwq->max_active)
@@ -3140,7 +3154,7 @@ static ssize_t max_active_store(struct device *dev,
 	if (sscanf(buf, "%d", &val) != 1 || val <= 0)
 		return -EINVAL;
 
-	workqueue_set_max_active(wq, val);
+	workqueue_set_max_active(wq, val, false);
 	return count;
 }
 static DEVICE_ATTR_RW(max_active);
@@ -4339,16 +4353,22 @@ EXPORT_SYMBOL_GPL(destroy_workqueue);
  * workqueue_set_max_active - adjust max_active of a workqueue
  * @wq: target workqueue
  * @max_active: new max_active value.
+ * @drain: wait until the actual level of concurrency becomes <= @max_active
  *
- * Set max_active of @wq to @max_active.
+ * Set max_active of @wq to @max_active.  If @drain is true, wait until the
+ * in-flight work items are drained to the new level.
  *
  * CONTEXT:
  * Don't call from IRQ context.
  */
-void workqueue_set_max_active(struct workqueue_struct *wq, int max_active)
+void workqueue_set_max_active(struct workqueue_struct *wq, int max_active,
+			      bool drain)
 {
+	DEFINE_WAIT(wait);
 	struct pool_workqueue *pwq;
 
+	might_sleep_if(drain);
+
 	/* disallow meddling with max_active for ordered workqueues */
 	if (WARN_ON(wq->flags & __WQ_ORDERED))
 		return;
@@ -4363,6 +4383,38 @@ void workqueue_set_max_active(struct workqueue_struct *wq, int max_active)
 		pwq_adjust_max_active(pwq);
 
 	mutex_unlock(&wq->mutex);
+
+	/*
+	 * If we have increased max_active, pwq_dec_nr_in_flight() might
+	 * not trigger for other instances of this function waiting for
+	 * drain.  Force them to check.
+	 */
+	wake_up_all(&wq_nr_active_drain_waitq);
+
+	if (!drain)
+		return;
+
+	/* let's wait for the drain to complete */
+restart:
+	mutex_lock(&wq->mutex);
+	prepare_to_wait(&wq_nr_active_drain_waitq, &wait, TASK_UNINTERRUPTIBLE);
+
+	for_each_pwq(pwq, wq) {
+		/*
+		 * nr_active should be monotonously decreasing as long as
+		 * it's over max_active, so no need to grab pool lock.
+		 * Also, test against saved_max_active in case multiple
+		 * instances and/or system freezer are racing.
+		 */
+		if (pwq->nr_active > wq->saved_max_active) {
+			mutex_unlock(&wq->mutex);
+			schedule();
+			goto restart;
+		}
+	}
+
+	finish_wait(&wq_nr_active_drain_waitq, &wait);
+	mutex_unlock(&wq->mutex);
 }
 EXPORT_SYMBOL_GPL(workqueue_set_max_active);
 
-- 
1.8.4.2

