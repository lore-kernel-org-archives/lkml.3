Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933367AbaFIIzJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 04:55:09 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58606 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932279AbaFIIv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 04:51:27 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 104/146] workqueue: make rescuer_thread() empty wq->maydays list before exiting
Date: Mon,  9 Jun 2014 10:50:39 +0200
Message-Id: <f685a411abe17727fbb1608d62845fdfec72e11a.1402303821.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 kernel/workqueue.c | 21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index c0b6eb1e0b83..cea58300f650 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2389,6 +2389,7 @@ static int rescuer_thread(void *__rescuer)
 	struct worker *rescuer = __rescuer;
 	struct workqueue_struct *wq = rescuer->rescue_wq;
 	struct list_head *scheduled = &rescuer->scheduled;
+	bool should_stop;
 
 	set_user_nice(current, RESCUER_NICE_LEVEL);
 
@@ -2400,11 +2401,15 @@ static int rescuer_thread(void *__rescuer)
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
@@ -2456,6 +2461,12 @@ repeat:
 
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
1.9.3

