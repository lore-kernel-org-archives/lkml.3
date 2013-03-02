Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665Ab3CBDZA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 22:25:00 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:33563 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752246Ab3CBDYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 22:24:40 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com
Cc: axboe@kernel.dk, jmoyer@redhat.com, zab@redhat.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 06/31] workqueue: introduce for_each_pool()
Date: Fri,  1 Mar 2013 19:23:57 -0800
Message-Id: <1362194662-2344-7-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362194662-2344-1-git-send-email-tj@kernel.org>
References: <1362194662-2344-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the scheduled unbound pools with custom attributes, there will be
multiple unbound pools, so it wouldn't be able to use
for_each_wq_cpu() + for_each_std_worker_pool() to iterate through all
pools.

Introduce for_each_pool() which iterates through all pools using
worker_pool_idr and use it instead of for_each_wq_cpu() +
for_each_std_worker_pool() combination in freeze_workqueues_begin().

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c | 36 +++++++++++++++++++++---------------
 1 file changed, 21 insertions(+), 15 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 0055a31..869dbcc 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -295,6 +295,14 @@ static inline int __next_wq_cpu(int cpu, const struct cpumask *mask,
 	     (cpu) = __next_wq_cpu((cpu), cpu_online_mask, 3))
 
 /**
+ * for_each_pool - iterate through all worker_pools in the system
+ * @pool: iteration cursor
+ * @id: integer used for iteration
+ */
+#define for_each_pool(pool, id)						\
+	idr_for_each_entry(&worker_pool_idr, pool, id)
+
+/**
  * for_each_pwq - iterate through all pool_workqueues of the specified workqueue
  * @pwq: iteration cursor
  * @wq: the target workqueue
@@ -3589,33 +3597,31 @@ EXPORT_SYMBOL_GPL(work_on_cpu);
  */
 void freeze_workqueues_begin(void)
 {
-	unsigned int cpu;
+	struct worker_pool *pool;
+	int id;
 
 	spin_lock_irq(&workqueue_lock);
 
 	WARN_ON_ONCE(workqueue_freezing);
 	workqueue_freezing = true;
 
-	for_each_wq_cpu(cpu) {
-		struct worker_pool *pool;
+	for_each_pool(pool, id) {
 		struct workqueue_struct *wq;
 
-		for_each_std_worker_pool(pool, cpu) {
-			spin_lock(&pool->lock);
-
-			WARN_ON_ONCE(pool->flags & POOL_FREEZING);
-			pool->flags |= POOL_FREEZING;
+		spin_lock(&pool->lock);
 
-			list_for_each_entry(wq, &workqueues, list) {
-				struct pool_workqueue *pwq = get_pwq(cpu, wq);
+		WARN_ON_ONCE(pool->flags & POOL_FREEZING);
+		pool->flags |= POOL_FREEZING;
 
-				if (pwq && pwq->pool == pool &&
-				    (wq->flags & WQ_FREEZABLE))
-					pwq->max_active = 0;
-			}
+		list_for_each_entry(wq, &workqueues, list) {
+			struct pool_workqueue *pwq = get_pwq(pool->cpu, wq);
 
-			spin_unlock(&pool->lock);
+			if (pwq && pwq->pool == pool &&
+			    (wq->flags & WQ_FREEZABLE))
+				pwq->max_active = 0;
 		}
+
+		spin_unlock(&pool->lock);
 	}
 
 	spin_unlock_irq(&workqueue_lock);
-- 
1.8.1.2

