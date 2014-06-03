Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932586AbaFCLlI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 07:41:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43437 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932491AbaFCLlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 07:41:05 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Tejun Heo <tj@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 047/138] workqueue: make rescuer_thread() empty wq->maydays list before exiting
Date: Tue,  3 Jun 2014 12:38:13 +0100
Message-Id: <1401795584-22664-48-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
References: <1401795584-22664-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lai Jiangshan <laijs@cn.fujitsu.com>

commit 4d595b866d2c653dc90a492b9973a834eabfa354 upstream.

After a @pwq is scheduled for emergency execution, other workers may
consume the affectd work items before the rescuer gets to them.  This
means that a workqueue many have pwqs queued on @wq->maydays list
while not having any work item pending or in-flight.  If
destroy_workqueue() executes in such condition, the rescuer may exit
without emptying @wq->maydays.

This currently doesn't cause any actual harm.  destroy_workqueue() can
safely destroy all the involved data structures whether @wq->maydays
is populated or not as nobody access the list once the rescuer exits.

However, this is nasty and makes future development difficult.  Let's
update rescuer_thread() so that it empties @wq->maydays after seeing
should_stop to guarantee that the list is empty on rescuer exit.

tj: Updated comment and patch description.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/workqueue.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index a8b0147f3a89..2b48572be9b3 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2369,6 +2369,7 @@ static int rescuer_thread(void *__rescuer)
 	struct worker *rescuer = __rescuer;
 	struct workqueue_struct *wq = rescuer->rescue_wq;
 	struct list_head *scheduled = &rescuer->scheduled;
+	bool should_stop;
 
 	set_user_nice(current, RESCUER_NICE_LEVEL);
 
@@ -2380,11 +2381,15 @@ static int rescuer_thread(void *__rescuer)
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
@@ -2430,6 +2435,12 @@ repeat:
 
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
-- 
1.9.1

