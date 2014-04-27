Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226AbaD0EHX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 00:07:23 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:23482 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752992AbaD0EFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 00:05:54 -0400
X-IronPort-AV: E=Sophos;i="4.97,936,1389715200"; 
   d="scan'208";a="29778318"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 07/10] workqueue: narrow the protection range of manager_mutex
Date: Sun, 27 Apr 2014 12:09:02 +0800
Message-ID: <1398571754-12443-8-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1398571754-12443-1-git-send-email-laijs@cn.fujitsu.com>
References: <1398571754-12443-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In create_worker(), pool->worker_ida is protected by idr subsystem via
using ida_simple_get()/ida_simple_put(), it dozn't need manager_mutex

struct worker allocation and kthread allocation are not visible by any one,
they don't need manager_mutex either.

The above operations are before the pool-binding operation which bind
the worker to the pool. And after the pool-binding(start_worker()...etc),
the worker is already bound to the pool, the cpuhotplug will handle the
cpu-binding for the worker correctly since it is pool-bound to the pool.
So we don't need the manager_mutex after the pool-binding.

The conclusion is that only the pool-binding needs manager_mutex,
so we narrow the protection section of manager_mutex in create_worker().

Some comments about manager_mutex are removed, due to we will add
bind_mutex and worker_bind_pool() later which have [self-]comments.

In put_unbound_pool(), we also narrow the protection of manager_mutex
due to destroy_worker() doesn't need manager_mutex.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   42 ++++++++----------------------------------
 1 files changed, 8 insertions(+), 34 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 7a181ce..ff6ec9a 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1703,8 +1703,6 @@ static struct worker *create_worker(struct worker_pool *pool)
 	int id = -1;
 	char id_buf[16];
 
-	lockdep_assert_held(&pool->manager_mutex);
-
 	/* ID is needed to determine kthread name. */
 	id = ida_simple_get(&pool->worker_ida, 0, 0, GFP_KERNEL);
 	if (id < 0)
@@ -1733,6 +1731,8 @@ static struct worker *create_worker(struct worker_pool *pool)
 	/* prevent userland from meddling with cpumask of workqueue workers */
 	worker->task->flags |= PF_NO_SETAFFINITY;
 
+	mutex_lock(&pool->manager_mutex);
+
 	/*
 	 * set_cpus_allowed_ptr() will fail if the cpumask doesn't have any
 	 * online CPUs.  It'll be re-applied when any of the CPUs come up.
@@ -1740,7 +1740,7 @@ static struct worker *create_worker(struct worker_pool *pool)
 	set_cpus_allowed_ptr(worker->task, pool->attrs->cpumask);
 
 	/*
-	 * The caller is responsible for ensuring %POOL_DISASSOCIATED
+	 * The pool->manager_mutex ensures %POOL_DISASSOCIATED
 	 * remains stable across this function.  See the comments above the
 	 * flag definition for details.
 	 */
@@ -1750,6 +1750,8 @@ static struct worker *create_worker(struct worker_pool *pool)
 	/* successful, bind the worker to the pool */
 	list_add_tail(&worker->bind_entry, &pool->bind_list);
 
+	mutex_unlock(&pool->manager_mutex);
+
 	return worker;
 
 fail:
@@ -1787,8 +1789,6 @@ static int create_and_start_worker(struct worker_pool *pool)
 {
 	struct worker *worker;
 
-	mutex_lock(&pool->manager_mutex);
-
 	worker = create_worker(pool);
 	if (worker) {
 		spin_lock_irq(&pool->lock);
@@ -1796,8 +1796,6 @@ static int create_and_start_worker(struct worker_pool *pool)
 		spin_unlock_irq(&pool->lock);
 	}
 
-	mutex_unlock(&pool->manager_mutex);
-
 	return worker ? 0 : -ENOMEM;
 }
 
@@ -1996,8 +1994,6 @@ static bool manage_workers(struct worker *worker)
 	bool ret = false;
 
 	/*
-	 * Managership is governed by two mutexes - manager_arb and
-	 * manager_mutex.  manager_arb handles arbitration of manager role.
 	 * Anyone who successfully grabs manager_arb wins the arbitration
 	 * and becomes the manager.  mutex_trylock() on pool->manager_arb
 	 * failure while holding pool->lock reliably indicates that someone
@@ -2006,33 +2002,12 @@ static bool manage_workers(struct worker *worker)
 	 * grabbing manager_arb is responsible for actually performing
 	 * manager duties.  If manager_arb is grabbed and released without
 	 * actual management, the pool may stall indefinitely.
-	 *
-	 * manager_mutex is used for exclusion of actual management
-	 * operations.  The holder of manager_mutex can be sure that none
-	 * of management operations, including creation and destruction of
-	 * workers, won't take place until the mutex is released.  Because
-	 * manager_mutex doesn't interfere with manager role arbitration,
-	 * it is guaranteed that the pool's management, while may be
-	 * delayed, won't be disturbed by someone else grabbing
-	 * manager_mutex.
 	 */
 	if (!mutex_trylock(&pool->manager_arb))
 		return ret;
 
-	/*
-	 * With manager arbitration won, manager_mutex would be free in
-	 * most cases.  trylock first without dropping @pool->lock.
-	 */
-	if (unlikely(!mutex_trylock(&pool->manager_mutex))) {
-		spin_unlock_irq(&pool->lock);
-		mutex_lock(&pool->manager_mutex);
-		spin_lock_irq(&pool->lock);
-		ret = true;
-	}
-
 	ret |= maybe_create_worker(pool);
 
-	mutex_unlock(&pool->manager_mutex);
 	mutex_unlock(&pool->manager_arb);
 	return ret;
 }
@@ -3518,22 +3493,21 @@ static void put_unbound_pool(struct worker_pool *pool)
 	 * manager_mutex.
 	 */
 	mutex_lock(&pool->manager_arb);
-	mutex_lock(&pool->manager_mutex);
-	spin_lock_irq(&pool->lock);
 
+	spin_lock_irq(&pool->lock);
 	WARN_ON(pool->nr_workers != pool->nr_idle);
 	while ((worker = first_worker(pool)))
 		destroy_worker(worker);
 	WARN_ON(pool->nr_workers || pool->nr_idle);
-
 	spin_unlock_irq(&pool->lock);
 
+	mutex_lock(&pool->manager_mutex);
 	wait_event_cmd(pool->workers_unbound,
 		       list_empty(&pool->bind_list),
 		       mutex_unlock(&pool->manager_mutex),
 		       mutex_lock(&pool->manager_mutex));
-
 	mutex_unlock(&pool->manager_mutex);
+
 	mutex_unlock(&pool->manager_arb);
 
 	/* shut down the timers */
-- 
1.7.4.4

