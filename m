Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933001Ab3DDCGC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 22:06:02 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:9928 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932779Ab3DDCF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 22:05:58 -0400
X-IronPort-AV: E=Sophos;i="4.87,404,1363104000"; 
   d="scan'208";a="6998070"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 3/7] workqueue: rename rebind_workers() to associate_cpu_pool()
Date: Thu, 4 Apr 2013 10:05:34 +0800
Message-Id: <1365041143-3088-3-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1365041143-3088-1-git-send-email-laijs@cn.fujitsu.com>
References: <1365041143-3088-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/04 10:04:56,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/04 10:04:56,
	Serialize complete at 2013/04/04 10:04:56
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

merge the code of clearing POOL_DISASSOCIATED to rebind_workers(), and
rename rebind_workers() to associate_cpu_pool().

It merges high related code together and simplify
workqueue_cpu_up_callback().

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   21 ++++++++++-----------
 1 files changed, 10 insertions(+), 11 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 66a9d71..b4369de 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2270,7 +2270,7 @@ recheck:
 	 * worker or that someone else has already assumed the manager
 	 * role.  This is where @worker starts participating in concurrency
 	 * management if applicable and concurrency management is restored
-	 * after being rebound.  See rebind_workers() for details.
+	 * after being rebound.  See associate_cpu_pool() for details.
 	 */
 	worker_clr_flags(worker, WORKER_PREP | WORKER_REBOUND);
 
@@ -4431,12 +4431,13 @@ static void wq_unbind_fn(struct work_struct *work)
 }
 
 /**
- * rebind_workers - rebind all workers of a pool to the associated CPU
+ * associate_cpu_pool - rebind all workers of a pool to the associated CPU
  * @pool: pool of interest
  *
- * @pool->cpu is coming online.  Rebind all workers to the CPU.
+ * @pool->cpu is coming online.  Rebind all workers to the CPU and
+ * set the pool associated
  */
-static void rebind_workers(struct worker_pool *pool)
+static void associate_cpu_pool(struct worker_pool *pool)
 {
 	struct worker *worker;
 	int wi;
@@ -4451,8 +4452,9 @@ static void rebind_workers(struct worker_pool *pool)
 	 * from CPU_ONLINE, the following shouldn't fail.
 	 */
 	for_each_pool_worker(worker, wi, pool)
-		WARN_ON_ONCE(set_cpus_allowed_ptr(worker->task,
-						  pool->attrs->cpumask) < 0);
+		if (WARN_ON_ONCE(set_cpus_allowed_ptr(worker->task,
+				pool->attrs->cpumask) < 0))
+			return;
 
 	spin_lock_irq(&pool->lock);
 
@@ -4491,6 +4493,7 @@ static void rebind_workers(struct worker_pool *pool)
 		ACCESS_ONCE(worker->flags) = worker_flags;
 	}
 
+	pool->flags &= ~POOL_DISASSOCIATED;
 	spin_unlock_irq(&pool->lock);
 }
 
@@ -4558,11 +4561,7 @@ static int __cpuinit workqueue_cpu_up_callback(struct notifier_block *nfb,
 			mutex_lock(&pool->manager_mutex);
 
 			if (pool->cpu == cpu) {
-				spin_lock_irq(&pool->lock);
-				pool->flags &= ~POOL_DISASSOCIATED;
-				spin_unlock_irq(&pool->lock);
-
-				rebind_workers(pool);
+				associate_cpu_pool(pool);
 			} else if (pool->cpu < 0) {
 				restore_unbound_workers_cpumask(pool, cpu);
 			}
-- 
1.7.7.6

