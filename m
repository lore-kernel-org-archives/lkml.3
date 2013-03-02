Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716Ab3CBDZE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 22:25:04 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:41101 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752249Ab3CBDYl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 22:24:41 -0500
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com
Cc: axboe@kernel.dk, jmoyer@redhat.com, zab@redhat.com,
        Tejun Heo <tj@kernel.org>
Subject: [PATCH 07/31] workqueue: restructure pool / pool_workqueue iterations in freeze/thaw functions
Date: Fri,  1 Mar 2013 19:23:58 -0800
Message-Id: <1362194662-2344-8-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362194662-2344-1-git-send-email-tj@kernel.org>
References: <1362194662-2344-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The three freeze/thaw related functions - freeze_workqueues_begin(),
freeze_workqueues_busy() and thaw_workqueues() - need to iterate
through all pool_workqueues of all freezable workqueues.  They did it
by first iterating pools and then visiting all pwqs (pool_workqueues)
of all workqueues and process it if its pwq->pool matches the current
pool.  This is rather backwards and done this way partly because
workqueue didn't have fitting iteration helpers and partly to avoid
the number of lock operations on pool->lock.

Workqueue now has fitting iterators and the locking operation overhead
isn't anything to worry about - those locks are unlikely to be
contended and the same CPU visiting the same set of locks multiple
times isn't expensive.

Restructure the three functions such that the flow better matches the
logical steps and pwq iteration is done using for_each_pwq() inside
workqueue iteration.

* freeze_workqueues_begin(): Setting of FREEZING is moved into a
  separate for_each_pool() iteration.  pwq iteration for clearing
  max_active is updated as described above.

* freeze_workqueues_busy(): pwq iteration updated as described above.

* thaw_workqueues(): The single for_each_wq_cpu() iteration is broken
  into three discrete steps - clearing FREEZING, restoring max_active,
  and kicking workers.  The first and last steps use for_each_pool()
  and the second step uses pwq iteration described above.

This makes the code easier to understand and removes the use of
for_each_wq_cpu() for walking pwqs, which can't support multiple
unbound pwqs which will be needed to implement unbound workqueues with
custom attributes.

This patch doesn't introduce any visible behavior changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c | 87 ++++++++++++++++++++++++++++--------------------------
 1 file changed, 45 insertions(+), 42 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 869dbcc..9f195aa 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3598,6 +3598,8 @@ EXPORT_SYMBOL_GPL(work_on_cpu);
 void freeze_workqueues_begin(void)
 {
 	struct worker_pool *pool;
+	struct workqueue_struct *wq;
+	struct pool_workqueue *pwq;
 	int id;
 
 	spin_lock_irq(&workqueue_lock);
@@ -3605,23 +3607,24 @@ void freeze_workqueues_begin(void)
 	WARN_ON_ONCE(workqueue_freezing);
 	workqueue_freezing = true;
 
+	/* set FREEZING */
 	for_each_pool(pool, id) {
-		struct workqueue_struct *wq;
-
 		spin_lock(&pool->lock);
-
 		WARN_ON_ONCE(pool->flags & POOL_FREEZING);
 		pool->flags |= POOL_FREEZING;
+		spin_unlock(&pool->lock);
+	}
 
-		list_for_each_entry(wq, &workqueues, list) {
-			struct pool_workqueue *pwq = get_pwq(pool->cpu, wq);
+	/* suppress further executions by setting max_active to zero */
+	list_for_each_entry(wq, &workqueues, list) {
+		if (!(wq->flags & WQ_FREEZABLE))
+			continue;
 
-			if (pwq && pwq->pool == pool &&
-			    (wq->flags & WQ_FREEZABLE))
-				pwq->max_active = 0;
+		for_each_pwq(pwq, wq) {
+			spin_lock(&pwq->pool->lock);
+			pwq->max_active = 0;
+			spin_unlock(&pwq->pool->lock);
 		}
-
-		spin_unlock(&pool->lock);
 	}
 
 	spin_unlock_irq(&workqueue_lock);
@@ -3642,25 +3645,22 @@ void freeze_workqueues_begin(void)
  */
 bool freeze_workqueues_busy(void)
 {
-	unsigned int cpu;
 	bool busy = false;
+	struct workqueue_struct *wq;
+	struct pool_workqueue *pwq;
 
 	spin_lock_irq(&workqueue_lock);
 
 	WARN_ON_ONCE(!workqueue_freezing);
 
-	for_each_wq_cpu(cpu) {
-		struct workqueue_struct *wq;
+	list_for_each_entry(wq, &workqueues, list) {
+		if (!(wq->flags & WQ_FREEZABLE))
+			continue;
 		/*
 		 * nr_active is monotonically decreasing.  It's safe
 		 * to peek without lock.
 		 */
-		list_for_each_entry(wq, &workqueues, list) {
-			struct pool_workqueue *pwq = get_pwq(cpu, wq);
-
-			if (!pwq || !(wq->flags & WQ_FREEZABLE))
-				continue;
-
+		for_each_pwq(pwq, wq) {
 			WARN_ON_ONCE(pwq->nr_active < 0);
 			if (pwq->nr_active) {
 				busy = true;
@@ -3684,40 +3684,43 @@ out_unlock:
  */
 void thaw_workqueues(void)
 {
-	unsigned int cpu;
+	struct workqueue_struct *wq;
+	struct pool_workqueue *pwq;
+	struct worker_pool *pool;
+	int id;
 
 	spin_lock_irq(&workqueue_lock);
 
 	if (!workqueue_freezing)
 		goto out_unlock;
 
-	for_each_wq_cpu(cpu) {
-		struct worker_pool *pool;
-		struct workqueue_struct *wq;
-
-		for_each_std_worker_pool(pool, cpu) {
-			spin_lock(&pool->lock);
-
-			WARN_ON_ONCE(!(pool->flags & POOL_FREEZING));
-			pool->flags &= ~POOL_FREEZING;
-
-			list_for_each_entry(wq, &workqueues, list) {
-				struct pool_workqueue *pwq = get_pwq(cpu, wq);
-
-				if (!pwq || pwq->pool != pool ||
-				    !(wq->flags & WQ_FREEZABLE))
-					continue;
-
-				/* restore max_active and repopulate worklist */
-				pwq_set_max_active(pwq, wq->saved_max_active);
-			}
+	/* clear FREEZING */
+	for_each_pool(pool, id) {
+		spin_lock(&pool->lock);
+		WARN_ON_ONCE(!(pool->flags & POOL_FREEZING));
+		pool->flags &= ~POOL_FREEZING;
+		spin_unlock(&pool->lock);
+	}
 
-			wake_up_worker(pool);
+	/* restore max_active and repopulate worklist */
+	list_for_each_entry(wq, &workqueues, list) {
+		if (!(wq->flags & WQ_FREEZABLE))
+			continue;
 
-			spin_unlock(&pool->lock);
+		for_each_pwq(pwq, wq) {
+			spin_lock(&pwq->pool->lock);
+			pwq_set_max_active(pwq, wq->saved_max_active);
+			spin_unlock(&pwq->pool->lock);
 		}
 	}
 
+	/* kick workers */
+	for_each_pool(pool, id) {
+		spin_lock(&pool->lock);
+		wake_up_worker(pool);
+		spin_unlock(&pool->lock);
+	}
+
 	workqueue_freezing = false;
 out_unlock:
 	spin_unlock_irq(&workqueue_lock);
-- 
1.8.1.2

