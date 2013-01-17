Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758316Ab3AQBnD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 20:43:03 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:41638 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758290Ab3AQBnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 20:43:00 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 04/17] workqueue: make GCWQ_FREEZING a pool flag
Date: Wed, 16 Jan 2013 17:42:36 -0800
Message-Id: <1358386969-945-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.0.2
In-Reply-To: <1358386969-945-1-git-send-email-tj@kernel.org>
References: <1358386969-945-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make GCWQ_FREEZING a pool flag POOL_FREEZING.  This patch doesn't
change locking - FREEZING on both pools of a CPU are set or clear
together while holding gcwq->lock.  It shouldn't cause any functional
difference.

This leaves gcwq->flags w/o any flags.  Removed.

While at it, convert BUG_ON()s in freeze_workqueue_begin() and
thaw_workqueues() to WARN_ON_ONCE().

This is part of an effort to remove global_cwq and make worker_pool
the top level abstraction, which in turn will help implementing worker
pools with user-specified attributes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 8feef7e..6e8bad6 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -47,11 +47,6 @@
 
 enum {
 	/*
-	 * global_cwq flags
-	 */
-	GCWQ_FREEZING		= 1 << 1,	/* freeze in progress */
-
-	/*
 	 * worker_pool flags
 	 *
 	 * A bound pool is either associated or disassociated with its CPU.
@@ -70,6 +65,7 @@ enum {
 	POOL_MANAGE_WORKERS	= 1 << 0,	/* need to manage workers */
 	POOL_MANAGING_WORKERS   = 1 << 1,       /* managing workers */
 	POOL_DISASSOCIATED	= 1 << 2,	/* cpu can't serve workers */
+	POOL_FREEZING		= 1 << 3,	/* freeze in progress */
 
 	/* worker flags */
 	WORKER_STARTED		= 1 << 0,	/* started */
@@ -179,7 +175,6 @@ struct worker_pool {
 struct global_cwq {
 	spinlock_t		lock;		/* the gcwq lock */
 	unsigned int		cpu;		/* I: the associated cpu */
-	unsigned int		flags;		/* L: GCWQ_* flags */
 
 	/* workers are chained either in busy_hash or pool idle_list */
 	DECLARE_HASHTABLE(busy_hash, BUSY_WORKER_HASH_ORDER);
@@ -3389,13 +3384,15 @@ void workqueue_set_max_active(struct workqueue_struct *wq, int max_active)
 	wq->saved_max_active = max_active;
 
 	for_each_cwq_cpu(cpu, wq) {
-		struct global_cwq *gcwq = get_gcwq(cpu);
+		struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
+		struct worker_pool *pool = cwq->pool;
+		struct global_cwq *gcwq = pool->gcwq;
 
 		spin_lock_irq(&gcwq->lock);
 
 		if (!(wq->flags & WQ_FREEZABLE) ||
-		    !(gcwq->flags & GCWQ_FREEZING))
-			cwq_set_max_active(get_cwq(gcwq->cpu, wq), max_active);
+		    !(pool->flags & POOL_FREEZING))
+			cwq_set_max_active(cwq, max_active);
 
 		spin_unlock_irq(&gcwq->lock);
 	}
@@ -3685,12 +3682,15 @@ void freeze_workqueues_begin(void)
 
 	for_each_gcwq_cpu(cpu) {
 		struct global_cwq *gcwq = get_gcwq(cpu);
+		struct worker_pool *pool;
 		struct workqueue_struct *wq;
 
 		spin_lock_irq(&gcwq->lock);
 
-		BUG_ON(gcwq->flags & GCWQ_FREEZING);
-		gcwq->flags |= GCWQ_FREEZING;
+		for_each_worker_pool(pool, gcwq) {
+			WARN_ON_ONCE(pool->flags & POOL_FREEZING);
+			pool->flags |= POOL_FREEZING;
+		}
 
 		list_for_each_entry(wq, &workqueues, list) {
 			struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
@@ -3776,8 +3776,10 @@ void thaw_workqueues(void)
 
 		spin_lock_irq(&gcwq->lock);
 
-		BUG_ON(!(gcwq->flags & GCWQ_FREEZING));
-		gcwq->flags &= ~GCWQ_FREEZING;
+		for_each_worker_pool(pool, gcwq) {
+			WARN_ON_ONCE(!(pool->flags & POOL_FREEZING));
+			pool->flags &= ~POOL_FREEZING;
+		}
 
 		list_for_each_entry(wq, &workqueues, list) {
 			struct cpu_workqueue_struct *cwq = get_cwq(cpu, wq);
-- 
1.8.0.2

