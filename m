Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934419Ab3CMX66 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 19:58:58 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:56088 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934450Ab3CMX6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 19:58:33 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: laijs@cn.fujitsu.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 5/6] workqueue: rename @id to @pi in for_each_each_pool()
Date: Wed, 13 Mar 2013 16:58:17 -0700
Message-Id: <1363219098-16083-6-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1363219098-16083-1-git-send-email-tj@kernel.org>
References: <1363219098-16083-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename @id argument of for_each_pool() to @pi so that it doesn't get
reused accidentally when for_each_pool() is used in combination with
other iterators.

This patch is purely cosmetic.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 248a1e9..147fc5a 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -283,7 +283,7 @@ EXPORT_SYMBOL_GPL(system_freezable_wq);
 /**
  * for_each_pool - iterate through all worker_pools in the system
  * @pool: iteration cursor
- * @id: integer used for iteration
+ * @pi: integer used for iteration
  *
  * This must be called either with workqueue_lock held or sched RCU read
  * locked.  If the pool needs to be used beyond the locking in effect, the
@@ -292,8 +292,8 @@ EXPORT_SYMBOL_GPL(system_freezable_wq);
  * The if/else clause exists only for the lockdep assertion and can be
  * ignored.
  */
-#define for_each_pool(pool, id)						\
-	idr_for_each_entry(&worker_pool_idr, pool, id)			\
+#define for_each_pool(pool, pi)						\
+	idr_for_each_entry(&worker_pool_idr, pool, pi)			\
 		if (({ assert_rcu_or_wq_lock(); false; })) { }		\
 		else
 
@@ -4354,7 +4354,7 @@ void freeze_workqueues_begin(void)
 	struct worker_pool *pool;
 	struct workqueue_struct *wq;
 	struct pool_workqueue *pwq;
-	int id;
+	int pi;
 
 	spin_lock_irq(&workqueue_lock);
 
@@ -4362,7 +4362,7 @@ void freeze_workqueues_begin(void)
 	workqueue_freezing = true;
 
 	/* set FREEZING */
-	for_each_pool(pool, id) {
+	for_each_pool(pool, pi) {
 		spin_lock(&pool->lock);
 		WARN_ON_ONCE(pool->flags & POOL_FREEZING);
 		pool->flags |= POOL_FREEZING;
@@ -4435,7 +4435,7 @@ void thaw_workqueues(void)
 	struct workqueue_struct *wq;
 	struct pool_workqueue *pwq;
 	struct worker_pool *pool;
-	int id;
+	int pi;
 
 	spin_lock_irq(&workqueue_lock);
 
@@ -4443,7 +4443,7 @@ void thaw_workqueues(void)
 		goto out_unlock;
 
 	/* clear FREEZING */
-	for_each_pool(pool, id) {
+	for_each_pool(pool, pi) {
 		spin_lock(&pool->lock);
 		WARN_ON_ONCE(!(pool->flags & POOL_FREEZING));
 		pool->flags &= ~POOL_FREEZING;
@@ -4457,7 +4457,7 @@ void thaw_workqueues(void)
 	}
 
 	/* kick workers */
-	for_each_pool(pool, id) {
+	for_each_pool(pool, pi) {
 		spin_lock(&pool->lock);
 		wake_up_worker(pool);
 		spin_unlock(&pool->lock);
-- 
1.8.1.4

