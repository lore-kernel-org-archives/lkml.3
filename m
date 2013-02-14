Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756807Ab3BND1M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 22:27:12 -0500
Received: from mail-vc0-f173.google.com ([209.85.220.173]:56950 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753055Ab3BND1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 22:27:10 -0500
Date: Wed, 13 Feb 2013 19:27:05 -0800
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 2/2 wq/for-3.9] workqueue: reimplement is_chained_work()
 using current_wq_worker()
Message-ID: <20130214032705.GG9057@htj.dyndns.org>
References: <20130214032633.GF9057@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130214032633.GF9057@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

is_chained_work() was added before current_wq_worker() and implemented
its own ham-fisted way of finding out whether %current is a workqueue
worker - it iterates through all possible workers.

Drop the custom implementation and reimplement using
current_wq_worker().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c |   33 ++++++++-------------------------
 1 file changed, 8 insertions(+), 25 deletions(-)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1159,35 +1159,18 @@ static void insert_work(struct cpu_workq
 
 /*
  * Test whether @work is being queued from another work executing on the
- * same workqueue.  This is rather expensive and should only be used from
- * cold paths.
+ * same workqueue.
  */
 static bool is_chained_work(struct workqueue_struct *wq)
 {
-	unsigned long flags;
-	unsigned int cpu;
+	struct worker *worker;
 
-	for_each_cwq_cpu(cpu, wq) {
-		struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
-		struct worker_pool *pool = cwq->pool;
-		struct worker *worker;
-		struct hlist_node *pos;
-		int i;
-
-		spin_lock_irqsave(&pool->lock, flags);
-		for_each_busy_worker(worker, i, pos, pool) {
-			if (worker->task != current)
-				continue;
-			spin_unlock_irqrestore(&pool->lock, flags);
-			/*
-			 * I'm @worker, no locking necessary.  See if @work
-			 * is headed to the same workqueue.
-			 */
-			return worker->current_cwq->wq == wq;
-		}
-		spin_unlock_irqrestore(&pool->lock, flags);
-	}
-	return false;
+	worker = current_wq_worker();
+	/*
+	 * Return %true iff I'm a worker execuing a work item on @wq.  If
+	 * I'm @worker, it's safe to dereference it without locking.
+	 */
+	return worker && worker->current_cwq->wq == wq;
 }
 
 static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
