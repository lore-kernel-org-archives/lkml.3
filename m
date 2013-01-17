Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758621Ab3AQBox (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 20:44:53 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:57184 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758366Ab3AQBnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 20:43:14 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 12/17] workqueue: make freezing/thawing per-pool
Date: Wed, 16 Jan 2013 17:42:44 -0800
Message-Id: <1358386969-945-13-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1358386969-945-1-git-send-email-tj@kernel.org>
References: <1358386969-945-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of holding locks from both pools and then processing the pools
together, make freezing/thwaing per-pool - grab locks of one pool,
process it, release it and then proceed to the next pool.

While this patch changes processing order across pools, order within
each pool remains the same.  As each pool is independent, this
shouldn't break anything.

This is part of an effort to remove global_cwq and make worker_pool
the top level abstraction, which in turn will help implementing worker
pools with user-specified attributes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c | 46 ++++++++++++++++++++--------------------------
 1 file changed, 20 insertions(+), 26 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 92e4d99..766ca67 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3695,25 +3695,22 @@ void freeze_workqueues_begin(void)
 		struct worker_pool *pool;
 		struct workqueue_struct *wq;
 
-		local_irq_disable();
-
 		for_each_worker_pool(pool, gcwq) {
-			spin_lock_nested(&pool->lock, pool - gcwq->pools);
+			spin_lock_irq(&pool->lock);
 
 			WARN_ON_ONCE(pool->flags & POOL_FREEZING);
 			pool->flags |= POOL_FREEZING;
-		}
 
-		list_for_each_entry(wq, &workqueues, list) {
-			struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
+			list_for_each_entry(wq, &workqueues, list) {
+				struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
 
-			if (cwq && wq->flags & WQ_FREEZABLE)
-				cwq->max_active = 0;
-		}
+				if (cwq && cwq->pool == pool &&
+				    (wq->flags & WQ_FREEZABLE))
+					cwq->max_active = 0;
+			}
 
-		for_each_worker_pool(pool, gcwq)
-			spin_unlock(&pool->lock);
-		local_irq_enable();
+			spin_unlock_irq(&pool->lock);
+		}
 	}
 
 	spin_unlock(&workqueue_lock);
@@ -3788,30 +3785,27 @@ void thaw_workqueues(void)
 		struct worker_pool *pool;
 		struct workqueue_struct *wq;
 
-		local_irq_disable();
-
 		for_each_worker_pool(pool, gcwq) {
-			spin_lock_nested(&pool->lock, pool - gcwq->pools);
+			spin_lock_irq(&pool->lock);
 
 			WARN_ON_ONCE(!(pool->flags & POOL_FREEZING));
 			pool->flags &= ~POOL_FREEZING;
-		}
 
-		list_for_each_entry(wq, &workqueues, list) {
-			struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
+			list_for_each_entry(wq, &workqueues, list) {
+				struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
 
-			if (!cwq || !(wq->flags & WQ_FREEZABLE))
-				continue;
+				if (!cwq || cwq->pool != pool ||
+				    !(wq->flags & WQ_FREEZABLE))
+					continue;
 
-			/* restore max_active and repopulate worklist */
-			cwq_set_max_active(cwq, wq->saved_max_active);
-		}
+				/* restore max_active and repopulate worklist */
+				cwq_set_max_active(cwq, wq->saved_max_active);
+			}
 
-		for_each_worker_pool(pool, gcwq) {
 			wake_up_worker(pool);
-			spin_unlock(&pool->lock);
+
+			spin_unlock_irq(&pool->lock);
 		}
-		local_irq_enable();
 	}
 
 	workqueue_freezing = false;
-- 
1.8.0.2

