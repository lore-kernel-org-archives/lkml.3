Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739Ab3AaSpG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 13:45:06 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62130 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756433Ab3AaSlz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 13:41:55 -0500
X-IronPort-AV: E=Sophos;i="4.84,578,1355068800"; 
   d="scan'208";a="6672834"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 03/13] workqueue: don't set work cwq until we queued it on pool
Date: Fri, 1 Feb 2013 02:41:26 +0800
Message-Id: <1359657696-2767-4-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1359657696-2767-1-git-send-email-laijs@cn.fujitsu.com>
References: <1359657696-2767-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/01 02:40:44,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/01 02:40:44,
	Serialize complete at 2013/02/01 02:40:44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Setting cwq to work struct which it is timer-pending introduces
unneeded complex to __queue_delayed_work().

We introduce "struct workqueue_struct *wq;" to the big struct delayed_work
to reduce this complex. (If someone blame that I enlarge this struct,
I can encode @wq to delayed_work.work.entry, this patch and the later
two patches make this encoding possible.)

This is the first step of killing CWQ bit of the work which is not queued
on any pool.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 include/linux/workqueue.h |    1 +
 kernel/workqueue.c        |   32 +++-----------------------------
 2 files changed, 4 insertions(+), 29 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 2dcbacc..db1782b 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -110,6 +110,7 @@ struct delayed_work {
 	struct work_struct work;
 	struct timer_list timer;
 	int cpu;
+	struct workqueue_struct *wq;
 };
 
 static inline struct delayed_work *to_delayed_work(struct work_struct *work)
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index d474a6c..b12b30e 100644
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
 
@@ -1351,7 +1350,6 @@ static void __queue_delayed_work(int cpu, struct workqueue_struct *wq,
 {
 	struct timer_list *timer = &dwork->timer;
 	struct work_struct *work = &dwork->work;
-	unsigned int lcpu;
 
 	WARN_ON_ONCE(timer->function != delayed_work_timer_fn ||
 		     timer->data != (unsigned long)dwork);
@@ -1371,31 +1369,8 @@ static void __queue_delayed_work(int cpu, struct workqueue_struct *wq,
 
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
 	dwork->cpu = cpu;
+	dwork->wq = wq;
 	timer->expires = jiffies + delay;
 
 	if (unlikely(cpu != WORK_CPU_UNBOUND))
@@ -2944,8 +2919,7 @@ bool flush_delayed_work(struct delayed_work *dwork)
 {
 	local_irq_disable();
 	if (del_timer_sync(&dwork->timer))
-		__queue_work(dwork->cpu,
-			     get_work_cwq(&dwork->work)->wq, &dwork->work);
+		__queue_work(dwork->cpu, dwork->wq, &dwork->work);
 	local_irq_enable();
 	return flush_work(&dwork->work);
 }
-- 
1.7.7.6

