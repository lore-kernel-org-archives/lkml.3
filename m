Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756296AbaFEARV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 20:17:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40225 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237AbaFDXWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:22:38 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 3.14 155/228] workqueue: make rescuer_thread() empty wq->maydays list before exiting
Date: Wed,  4 Jun 2014 16:23:04 -0700
Message-Id: <20140604232352.997143504@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232347.966798903@linuxfoundation.org>
References: <20140604232347.966798903@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/workqueue.c |   21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2397,6 +2397,7 @@ static int rescuer_thread(void *__rescue
 	struct worker *rescuer = __rescuer;
 	struct workqueue_struct *wq = rescuer->rescue_wq;
 	struct list_head *scheduled = &rescuer->scheduled;
+	bool should_stop;
 
 	set_user_nice(current, RESCUER_NICE_LEVEL);
 
@@ -2408,11 +2409,15 @@ static int rescuer_thread(void *__rescue
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
@@ -2464,6 +2469,12 @@ repeat:
 
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


