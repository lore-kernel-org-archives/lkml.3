Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030254Ab3BGA2W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 19:28:22 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:49112 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030214Ab3BGA2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 19:28:12 -0500
Date: Wed, 6 Feb 2013 16:28:06 -0800
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH wq/for-3.9 workqueue]: add delayed_work->wq to simplify
 reentrancy handling
Message-ID: <20130207002806.GG2875@htj.dyndns.org>
References: <1359657696-2767-1-git-send-email-laijs@cn.fujitsu.com>
 <1359657696-2767-4-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359657696-2767-4-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

To avoid executing the same work item from multiple CPUs concurrently,
a work_struct records the last pool it was on in its ->data so that,
on the next queueing, the pool can be queried to determine whether the
work item is still executing or not.

A delayed_work goes through timer before actually being queued on the
target workqueue and the timer needs to know the target workqueue and
CPU.  This is currently achieved by modifying delayed_work->work.data
such that it points to the cwq which points to the target workqueue
and the last CPU the work item was on.  __queue_delayed_work()
extracts the last CPU from delayed_work->work.data and then combines
it with the target workqueue to create new work.data.

The only thing this rather ugly hack achieves is encoding the target
workqueue into delayed_work->work.data without using a separate field,
which could be a trade off one can make; unfortunately, this entangles
work->data management between regular workqueue and delayed_work code
by setting cwq pointer before the work item is actually queued and
becomes a hindrance for further improvements of work->data handling.

This can be easily made sane by adding a target workqueue field to
delayed_work.  While delayed_work is used widely in the kernel and
this does make it a bit larger (<5%), I think this is the right
trade-off especially given the prospect of much saner handling of
work->data which currently involves quite tricky memory barrier
dancing, and don't expect to see any measureable effect.

Add delayed_work->wq and drop the delayed_work->work.data overloading.

tj: Rewrote the description.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/workqueue.h |    3 +++
 kernel/workqueue.c        |   32 +++-----------------------------
 2 files changed, 6 insertions(+), 29 deletions(-)

--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -109,6 +109,9 @@ struct work_struct {
 struct delayed_work {
 	struct work_struct work;
 	struct timer_list timer;
+
+	/* target workqueue and CPU ->timer uses to queue ->work */
+	struct workqueue_struct *wq;
 	int cpu;
 };
 
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1339,10 +1339,9 @@ EXPORT_SYMBOL_GPL(queue_work);
 void delayed_work_timer_fn(unsigned long __data)
 {
 	struct delayed_work *dwork = (struct delayed_work *)__data;
-	struct cpu_workqueue_struct *cwq = get_work_cwq(&dwork->work);
 
 	/* should have been called from irqsafe timer with irq already off */
-	__queue_work(dwork->cpu, cwq->wq, &dwork->work);
+	__queue_work(dwork->cpu, dwork->wq, &dwork->work);
 }
 EXPORT_SYMBOL_GPL(delayed_work_timer_fn);
 
@@ -1351,7 +1350,6 @@ static void __queue_delayed_work(int cpu
 {
 	struct timer_list *timer = &dwork->timer;
 	struct work_struct *work = &dwork->work;
-	unsigned int lcpu;
 
 	WARN_ON_ONCE(timer->function != delayed_work_timer_fn ||
 		     timer->data != (unsigned long)dwork);
@@ -1371,30 +1369,7 @@ static void __queue_delayed_work(int cpu
 
 	timer_stats_timer_set_start_info(&dwork->timer);
 
-	/*
-	 * This stores cwq for the moment, for the timer_fn.  Note that the
-	 * work's pool is preserved to allow reentrance detection for
-	 * delayed works.
-	 */
-	if (!(wq->flags & WQ_UNBOUND)) {
-		struct worker_pool *pool = get_work_pool(work);
-
-		/*
-		 * If we cannot get the last pool from @work directly,
-		 * select the last CPU such that it avoids unnecessarily
-		 * triggering non-reentrancy check in __queue_work().
-		 */
-		lcpu = cpu;
-		if (pool)
-			lcpu = pool->cpu;
-		if (lcpu == WORK_CPU_UNBOUND)
-			lcpu = raw_smp_processor_id();
-	} else {
-		lcpu = WORK_CPU_UNBOUND;
-	}
-
-	set_work_cwq(work, get_cwq(lcpu, wq), 0);
-
+	dwork->wq = wq;
 	dwork->cpu = cpu;
 	timer->expires = jiffies + delay;
 
@@ -2944,8 +2919,7 @@ bool flush_delayed_work(struct delayed_w
 {
 	local_irq_disable();
 	if (del_timer_sync(&dwork->timer))
-		__queue_work(dwork->cpu,
-			     get_work_cwq(&dwork->work)->wq, &dwork->work);
+		__queue_work(dwork->cpu, dwork->wq, &dwork->work);
 	local_irq_enable();
 	return flush_work(&dwork->work);
 }
