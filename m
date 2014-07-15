Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758239AbaGOJ3O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 05:29:14 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:20076 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756689AbaGOJ3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 05:29:10 -0400
X-IronPort-AV: E=Sophos;i="5.00,895,1396972800"; 
   d="scan'208";a="33286395"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH RFC] workqueue: don't grab PENDING bit on some conditions
Date: Tue, 15 Jul 2014 17:30:10 +0800
Message-ID: <1405416610-12394-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mod_delayed_work_on() can't handle well when the work is being flushed.

Thread1				Thread2
	/* the delayed work is pending in timer. */
--------------------------------------------------------------------
/* flush it */			/* change to a smaller delay. */
flush_delayed_work();		mod_delayed_work_on();


Thread1 expects that, after flush_delayed_work() returns, the known pending
work is guaranteed finished. But if Thread2 is scheduled a little later than
Thread1, the known pending work is dequeued and re-queued, it is considered
as two different works in the workqueue subsystem and the guarantee expected
by Thread1 is broken.

The guarantee expected by Thread1/workqueue-user is reasonable for me,
the workqueue subsystem should provide this guarantee. In another aspect,
the flush_delayed_work() is still working when mod_delayed_work_on() returns,
it is more acceptable that the flush_delayed_work() beats the
mod_delayed_work_on().

It is achieved by introducing a KEEP_FLUSHED flag for try_to_grab_pending().
If the work is being flushed and KEEP_FLUSHED flags is set,
we disallow try_to_grab_pending() to grab the pending of the work.


And there is another condition that the user want to speed up a delayed work.

When the user use "mod_delayed_work_on(..., 0 /* zero delay */);", his
attention is to accelerate the work and queue the work immediately.

But the work does be slowed down when it is already queued on the worklist
due to the work is dequeued and re-queued. So we also disallow
try_to_grab_pending() to grab the pending of the work in this condition
by introducing KEEP_QUEUED flag.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   29 ++++++++++++++++++++++++-----
 1 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 338d418..3a0b055 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1141,10 +1141,16 @@ out_put:
 	put_pwq(pwq);
 }
 
+/* keep the work on the worklist if it is on the worklist */
+#define KEEP_QUEUED	1
+/* keep the work on the worklist if it is on the worklist and being flushed */
+#define KEEP_FLUSHED	2
+
 /**
  * try_to_grab_pending - steal work item from worklist and disable irq
  * @work: work item to steal
  * @is_dwork: @work is a delayed_work
+ * @keep_flags: don't grab PENDING bit for some conditions
  * @flags: place to store irq state
  *
  * Try to grab PENDING bit of @work.  This function can handle @work in any
@@ -1156,6 +1162,8 @@ out_put:
  *  -EAGAIN	if PENDING couldn't be grabbed at the moment, safe to busy-retry
  *  -ENOENT	if someone else is canceling @work, this state may persist
  *		for arbitrarily long
+ *  -EBUSY	@work is kept due to @work meets the requirement for
+ *		the keep_flags, see the comments for KEEP_XXXX
  *
  * Note:
  * On >= 0 return, the caller owns @work's PENDING bit.  To avoid getting
@@ -1169,7 +1177,7 @@ out_put:
  * This function is safe to call from any context including IRQ handler.
  */
 static int try_to_grab_pending(struct work_struct *work, bool is_dwork,
-			       unsigned long *flags)
+			       unsigned long keep_flags, unsigned long *flags)
 {
 	struct worker_pool *pool;
 	struct pool_workqueue *pwq;
@@ -1212,6 +1220,13 @@ static int try_to_grab_pending(struct work_struct *work, bool is_dwork,
 	 */
 	pwq = get_work_pwq(work);
 	if (pwq && pwq->pool == pool) {
+		if ((keep_flags | KEEP_QUEUED) ||
+		    ((keep_flags | KEEP_FLUSHED) &&
+		    (*work_data_bits(work) & WORK_STRUCT_LINKED))) {
+			spin_unlock_irqrestore(&pool->lock, *flags);
+			return -EBUSY;
+		}
+
 		debug_work_deactivate(work);
 
 		/*
@@ -1517,11 +1532,15 @@ EXPORT_SYMBOL(queue_delayed_work_on);
 bool mod_delayed_work_on(int cpu, struct workqueue_struct *wq,
 			 struct delayed_work *dwork, unsigned long delay)
 {
+	unsigned long keep = KEEP_FLUSHED;
 	unsigned long flags;
 	int ret;
 
+	if (!delay)
+		keep |= KEEP_QUEUED;
+
 	do {
-		ret = try_to_grab_pending(&dwork->work, true, &flags);
+		ret = try_to_grab_pending(&dwork->work, true, keep, &flags);
 	} while (unlikely(ret == -EAGAIN));
 
 	if (likely(ret >= 0)) {
@@ -1529,7 +1548,7 @@ bool mod_delayed_work_on(int cpu, struct workqueue_struct *wq,
 		local_irq_restore(flags);
 	}
 
-	/* -ENOENT from try_to_grab_pending() becomes %true */
+	/* -ENOENT or -EBUSY from try_to_grab_pending() becomes %true */
 	return ret;
 }
 EXPORT_SYMBOL_GPL(mod_delayed_work_on);
@@ -2773,7 +2792,7 @@ static bool __cancel_work_timer(struct work_struct *work, bool is_dwork)
 	int ret;
 
 	do {
-		ret = try_to_grab_pending(work, is_dwork, &flags);
+		ret = try_to_grab_pending(work, is_dwork, 0, &flags);
 		/*
 		 * If someone else is canceling, wait for the same event it
 		 * would be waiting for before retrying.
@@ -2859,7 +2878,7 @@ bool cancel_delayed_work(struct delayed_work *dwork)
 	int ret;
 
 	do {
-		ret = try_to_grab_pending(&dwork->work, true, &flags);
+		ret = try_to_grab_pending(&dwork->work, true, 0, &flags);
 	} while (unlikely(ret == -EAGAIN));
 
 	if (unlikely(ret < 0))
-- 
1.7.4.4

