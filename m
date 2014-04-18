Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271AbaDRPGL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 11:06:11 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:43141 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751197AbaDRPGG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 11:06:06 -0400
Date: Fri, 18 Apr 2014 11:06:01 -0400
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] workqueue: make rescuer_thread() empty wq->maydays list
 before exiting
Message-ID: <20140418150601.GA12515@htj.dyndns.org>
References: <20140417162720.GQ15326@htj.dyndns.org>
 <1397827555-19641-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1397827555-19641-1-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Applied to wq/for-3.15-fixes w/ comment and description updates.

Thanks.
------- 8< -------
>From 4d595b866d2c653dc90a492b9973a834eabfa354 Mon Sep 17 00:00:00 2001
From: Lai Jiangshan <laijs@cn.fujitsu.com>
Date: Fri, 18 Apr 2014 11:04:16 -0400

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
Cc: stable@vger.kernel.org # v3.10+
---
 kernel/workqueue.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 3150b21..6ba0c60 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2398,6 +2398,7 @@ static int rescuer_thread(void *__rescuer)
 	struct worker *rescuer = __rescuer;
 	struct workqueue_struct *wq = rescuer->rescue_wq;
 	struct list_head *scheduled = &rescuer->scheduled;
+	bool should_stop;
 
 	set_user_nice(current, RESCUER_NICE_LEVEL);
 
@@ -2409,11 +2410,15 @@ static int rescuer_thread(void *__rescuer)
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
@@ -2459,6 +2464,12 @@ repeat:
 
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
1.9.0

