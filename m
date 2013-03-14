Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934492Ab3CNC7G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 22:59:06 -0400
Received: from mail-qe0-f49.google.com ([209.85.128.49]:64613 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964793Ab3CNC5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 22:57:38 -0400
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: laijs@cn.fujitsu.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 3/7] workqueue: better define locking rules around worker creation / destruction
Date: Wed, 13 Mar 2013 19:57:21 -0700
Message-Id: <1363229845-6831-4-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1363229845-6831-1-git-send-email-tj@kernel.org>
References: <1363229845-6831-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a manager creates or destroys workers, the operations are always
done with the manager_mutex held; however, initial worker creation or
worker destruction during pool release don't grab the mutex.  They are
still correct as initial worker creation doesn't require
synchronization and grabbing manager_arb provides enough exclusion for
pool release path.

Still, let's make everyone follow the same rules for consistency and
such that lockdep annotations can be added.

Update create_and_start_worker() and put_unbound_pool() to grab
manager_mutex around thread creation and destruction respectively and
add lockdep assertions to create_worker() and destroy_worker().

This patch doesn't introduce any visible behavior changes.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/workqueue.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index cac7106..ce1ab06 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1715,6 +1715,8 @@ static struct worker *create_worker(struct worker_pool *pool)
 	struct worker *worker = NULL;
 	int id = -1;
 
+	lockdep_assert_held(&pool->manager_mutex);
+
 	spin_lock_irq(&pool->lock);
 	while (ida_get_new(&pool->worker_ida, &id)) {
 		spin_unlock_irq(&pool->lock);
@@ -1796,12 +1798,14 @@ static void start_worker(struct worker *worker)
  * create_and_start_worker - create and start a worker for a pool
  * @pool: the target pool
  *
- * Create and start a new worker for @pool.
+ * Grab the managership of @pool and create and start a new worker for it.
  */
 static int create_and_start_worker(struct worker_pool *pool)
 {
 	struct worker *worker;
 
+	mutex_lock(&pool->manager_mutex);
+
 	worker = create_worker(pool);
 	if (worker) {
 		spin_lock_irq(&pool->lock);
@@ -1809,6 +1813,8 @@ static int create_and_start_worker(struct worker_pool *pool)
 		spin_unlock_irq(&pool->lock);
 	}
 
+	mutex_unlock(&pool->manager_mutex);
+
 	return worker ? 0 : -ENOMEM;
 }
 
@@ -1826,6 +1832,9 @@ static void destroy_worker(struct worker *worker)
 	struct worker_pool *pool = worker->pool;
 	int id = worker->id;
 
+	lockdep_assert_held(&pool->manager_mutex);
+	lockdep_assert_held(&pool->lock);
+
 	/* sanity check frenzy */
 	if (WARN_ON(worker->current_work) ||
 	    WARN_ON(!list_empty(&worker->scheduled)))
@@ -3531,6 +3540,7 @@ static void put_unbound_pool(struct worker_pool *pool)
 	 * manager_mutex.
 	 */
 	mutex_lock(&pool->manager_arb);
+	mutex_lock(&pool->manager_mutex);
 	spin_lock_irq(&pool->lock);
 
 	while ((worker = first_worker(pool)))
@@ -3538,6 +3548,7 @@ static void put_unbound_pool(struct worker_pool *pool)
 	WARN_ON(pool->nr_workers || pool->nr_idle);
 
 	spin_unlock_irq(&pool->lock);
+	mutex_unlock(&pool->manager_mutex);
 	mutex_unlock(&pool->manager_arb);
 
 	/* shut down the timers */
-- 
1.8.1.4

