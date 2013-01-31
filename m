Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756754Ab3AaSoO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 13:44:14 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:16627 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756640Ab3AaSmA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 13:42:00 -0500
X-IronPort-AV: E=Sophos;i="4.84,578,1355068800"; 
   d="scan'208";a="6672839"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 08/13] workqueue: add lock_pool_executing_work()
Date: Fri, 1 Feb 2013 02:41:31 +0800
Message-Id: <1359657696-2767-9-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1359657696-2767-1-git-send-email-laijs@cn.fujitsu.com>
References: <1359657696-2767-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/01 02:40:49,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/01 02:40:50,
	Serialize complete at 2013/02/01 02:40:50
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Extract the lock code from __queue_work() and name it lock_pool_executing_work().
It makes the code better readability and make __queue_work() shorter,

And this new function can be reused by others(later patches).

Add/Use proper locking API.

This patch has a little bad side effect for __queue_work():
even worker_pool_by_id(pool_id) == get_cwq(cpu, wq)->pool,
It will still call find_worker_executing_work() unconditionally, but it is
it is a very small overhead compared to the lockings and worker_pool_by_id(),
and this overhead will be reduced later.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   72 +++++++++++++++++++++++++++++++++++----------------
 1 files changed, 49 insertions(+), 23 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index a138844..6e92f18 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -934,6 +934,43 @@ static struct worker *find_worker_executing_work(struct worker_pool *pool,
 	return NULL;
 }
 
+/** lock_pool_executing_work - lock the pool a given offq work is running on
+ * @work: work of interest
+ * @worker: return the worker which is executing @work if found
+ *
+ * CONTEXT:
+ * local_irq_disable()
+ *
+ * RETURNS:
+ * Pointer to work pool(and locked) on which @work is running if found,
+ * NULL otherwise.
+ */
+static struct worker_pool *lock_pool_executing_work(struct work_struct *work,
+						    struct worker **worker)
+{
+	unsigned long pool_id = offq_work_pool_id(work);
+	struct worker_pool *pool;
+	struct worker *exec;
+
+	if (pool_id == WORK_OFFQ_POOL_NONE)
+		return NULL;
+
+	pool = worker_pool_by_id(pool_id);
+	if (!pool)
+		return NULL;
+
+	spin_lock(&pool->lock);
+	exec = find_worker_executing_work(pool, work);
+	if (exec) {
+		BUG_ON(pool != exec->pool);
+		*worker = exec;
+		return pool;
+	}
+	spin_unlock(&pool->lock);
+
+	return NULL;
+}
+
 /**
  * move_linked_works - move linked works to a list
  * @work: start of series of works to be scheduled
@@ -1235,35 +1272,24 @@ static void __queue_work(unsigned int cpu, struct workqueue_struct *wq,
 
 	/* determine pool to use */
 	if (!(wq->flags & WQ_UNBOUND)) {
-		struct worker_pool *last_pool;
+		struct worker *worker;
 
 		if (cpu == WORK_CPU_UNBOUND)
 			cpu = raw_smp_processor_id();
 
 		/*
-		 * It's multi cpu.  If @work was previously on a different
-		 * cpu, it might still be running there, in which case the
-		 * work needs to be queued on that cpu to guarantee
-		 * non-reentrancy.
+		 * It's multi cpu and pool. If @work is still running on a pool,
+		 * in which case the work needs to be queued on that pool
+		 * to guarantee non-reentrancy.
 		 */
-		pool = get_cwq(cpu, wq)->pool;
-		last_pool = get_work_pool(work);
-
-		if (last_pool && last_pool != pool) {
-			struct worker *worker;
-
-			spin_lock(&last_pool->lock);
-
-			worker = find_worker_executing_work(last_pool, work);
-
-			if (worker && worker->current_cwq->wq == wq)
-				pool = last_pool;
-			else {
-				/* meh... not running there, queue here */
-				spin_unlock(&last_pool->lock);
-				spin_lock(&pool->lock);
-			}
-		} else {
+		BUG_ON(get_work_cwq(work));
+		pool = lock_pool_executing_work(work, &worker);
+		if (pool && worker->current_cwq->wq != wq) {
+			spin_unlock(&pool->lock);
+			pool = NULL;
+		}
+		if (!pool) {
+			pool = get_cwq(cpu, wq)->pool;
 			spin_lock(&pool->lock);
 		}
 	} else {
-- 
1.7.7.6

