Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755658AbaELSVs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 14:21:48 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:59153 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753483AbaELSVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 14:21:46 -0400
Date: Mon, 12 May 2014 14:21:42 -0400
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [GIT PULL] workqueue fixes for v3.15-rc5
Message-ID: <20140512182142.GH1421@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Linus.

Fixes for two bugs in workqueue.  One is existing with internal mutex
held in a failure path of wq_update_unbound_numa().  The other is
subtle and unlikely use-after-possible-last-put in the rescuer logic.
Both have been around for quite some time now and are unlikely to have
triggered noticeably often.  All patches are marked for -stable
backport.

The following changes since commit c9eaa447e77efe77b7fa4c953bd62de8297fd6c5:

  Linux 3.15-rc1 (2014-04-13 14:18:35 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/wq.git for-3.15-fixes

for you to fetch changes up to 77668c8b559e4fe2acf2a0749c7c83cde49a5025:

  workqueue: fix a possible race condition between rescuer and pwq-release (2014-04-18 12:33:29 -0400)

Thanks.

----------------------------------------------------------------
Daeseok Youn (1):
      workqueue: fix bugs in wq_update_unbound_numa() failure path

Lai Jiangshan (2):
      workqueue: make rescuer_thread() empty wq->maydays list before exiting
      workqueue: fix a possible race condition between rescuer and pwq-release

 kernel/workqueue.c | 36 ++++++++++++++++++++++++++++++------
 1 file changed, 30 insertions(+), 6 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 0ee63af..8edc871 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1916,6 +1916,12 @@ static void send_mayday(struct work_struct *work)
 
 	/* mayday mayday mayday */
 	if (list_empty(&pwq->mayday_node)) {
+		/*
+		 * If @pwq is for an unbound wq, its base ref may be put at
+		 * any time due to an attribute change.  Pin @pwq until the
+		 * rescuer is done with it.
+		 */
+		get_pwq(pwq);
 		list_add_tail(&pwq->mayday_node, &wq->maydays);
 		wake_up_process(wq->rescuer->task);
 	}
@@ -2398,6 +2404,7 @@ static int rescuer_thread(void *__rescuer)
 	struct worker *rescuer = __rescuer;
 	struct workqueue_struct *wq = rescuer->rescue_wq;
 	struct list_head *scheduled = &rescuer->scheduled;
+	bool should_stop;
 
 	set_user_nice(current, RESCUER_NICE_LEVEL);
 
@@ -2409,11 +2416,15 @@ static int rescuer_thread(void *__rescuer)
 repeat:
 	set_current_state(TASK_INTERRUPTIBLE);
 
-	if (kthread_should_stop()) {
-		__set_current_state(TASK_RUNNING);
-		rescuer->task->flags &= ~PF_WQ_WORKER;
-		return 0;
-	}
+	/*
+	 * By the time the rescuer is requested to stop, the workqueue
+	 * shouldn't have any work pending, but @wq->maydays may still have
+	 * pwq(s) queued.  This can happen by non-rescuer workers consuming
+	 * all the work items before the rescuer got to them.  Go through
+	 * @wq->maydays processing before acting on should_stop so that the
+	 * list is always empty on exit.
+	 */
+	should_stop = kthread_should_stop();
 
 	/* see whether any pwq is asking for help */
 	spin_lock_irq(&wq_mayday_lock);
@@ -2445,6 +2456,12 @@ repeat:
 		process_scheduled_works(rescuer);
 
 		/*
+		 * Put the reference grabbed by send_mayday().  @pool won't
+		 * go away while we're holding its lock.
+		 */
+		put_pwq(pwq);
+
+		/*
 		 * Leave this pool.  If keep_working() is %true, notify a
 		 * regular worker; otherwise, we end up with 0 concurrency
 		 * and stalling the execution.
@@ -2459,6 +2476,12 @@ repeat:
 
 	spin_unlock_irq(&wq_mayday_lock);
 
+	if (should_stop) {
+		__set_current_state(TASK_RUNNING);
+		rescuer->task->flags &= ~PF_WQ_WORKER;
+		return 0;
+	}
+
 	/* rescuers should never participate in concurrency management */
 	WARN_ON_ONCE(!(rescuer->flags & WORKER_NOT_RUNNING));
 	schedule();
@@ -4100,7 +4123,8 @@ static void wq_update_unbound_numa(struct workqueue_struct *wq, int cpu,
 	if (!pwq) {
 		pr_warning("workqueue: allocation failed while updating NUMA affinity of \"%s\"\n",
 			   wq->name);
-		goto out_unlock;
+		mutex_lock(&wq->mutex);
+		goto use_dfl_pwq;
 	}
 
 	/*
