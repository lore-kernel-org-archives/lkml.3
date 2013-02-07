Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422628Ab3BGVNN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 16:13:13 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:46474 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759281Ab3BGVNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 16:13:12 -0500
Date: Thu, 7 Feb 2013 13:13:06 -0800
From: Tejun Heo <tj@kernel.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH wq/for-3.9] workqueue: pick cwq instead of pool in
 __queue_work()
Message-ID: <20130207211306.GV2875@htj.dyndns.org>
References: <1359657696-2767-1-git-send-email-laijs@cn.fujitsu.com>
 <1359657696-2767-8-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359657696-2767-8-git-send-email-laijs@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lai Jiangshan <laijs@cn.fujitsu.com>

Currently, __queue_work() chooses the pool to queue a work item to and
then determines cwq from the target wq and the chosen pool.  This is a
bit backwards in that we can determine cwq first and simply use
cwq->pool.  This way, we can skip get_std_worker_pool() in queueing
path which will be a hurdle when implementing custom worker pools.

Update __queue_work() such that it chooses the target cwq and then use
cwq->pool instead of the other way around.  While at it, add missing
{} in an if statement.

This patch doesn't introduce any functional changes.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c |   29 +++++++++++++----------------
 1 file changed, 13 insertions(+), 16 deletions(-)

--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1193,8 +1193,6 @@ static bool is_chained_work(struct workq
 static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
 			 struct work_struct *work)
 {
-	bool highpri = wq->flags & WQ_HIGHPRI;
-	struct worker_pool *pool;
 	struct cpu_workqueue_struct *cwq;
 	struct list_head *worklist;
 	unsigned int work_flags;
@@ -1215,7 +1213,7 @@ static void __queue_work(unsigned int cp
 	    WARN_ON_ONCE(!is_chained_work(wq)))
 		return;
 
-	/* determine pool to use */
+	/* determine the cwq to use */
 	if (!(wq->flags & WQ_UNBOUND)) {
 		struct worker_pool *last_pool;
 
@@ -1228,37 +1226,36 @@ static void __queue_work(unsigned int cp
 		 * work needs to be queued on that cpu to guarantee
 		 * non-reentrancy.
 		 */
-		pool = get_std_worker_pool(cpu, highpri);
+		cwq = get_cwq(cpu, wq);
 		last_pool = get_work_pool(work);
 
-		if (last_pool && last_pool != pool) {
+		if (last_pool && last_pool != cwq->pool) {
 			struct worker *worker;
 
 			spin_lock(&last_pool->lock);
 
 			worker = find_worker_executing_work(last_pool, work);
 
-			if (worker && worker->current_cwq->wq == wq)
-				pool = last_pool;
-			else {
+			if (worker && worker->current_cwq->wq == wq) {
+				cwq = get_cwq(last_pool->cpu, wq);
+			} else {
 				/* meh... not running there, queue here */
 				spin_unlock(&last_pool->lock);
-				spin_lock(&pool->lock);
+				spin_lock(&cwq->pool->lock);
 			}
 		} else {
-			spin_lock(&pool->lock);
+			spin_lock(&cwq->pool->lock);
 		}
 	} else {
-		pool = get_std_worker_pool(WORK_CPU_UNBOUND, highpri);
-		spin_lock(&pool->lock);
+		cwq = get_cwq(WORK_CPU_UNBOUND, wq);
+		spin_lock(&cwq->pool->lock);
 	}
 
-	/* pool determined, get cwq and queue */
-	cwq = get_cwq(pool->cpu, wq);
+	/* cwq determined, queue */
 	trace_workqueue_queue_work(req_cpu, cwq, work);
 
 	if (WARN_ON(!list_empty(&work->entry))) {
-		spin_unlock(&pool->lock);
+		spin_unlock(&cwq->pool->lock);
 		return;
 	}
 
@@ -1276,7 +1273,7 @@ static void __queue_work(unsigned int cp
 
 	insert_work(cwq, work, worklist, work_flags);
 
-	spin_unlock(&pool->lock);
+	spin_unlock(&cwq->pool->lock);
 }
 
 /**
