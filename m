Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753035AbaETJnJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 05:43:09 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:63309 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752936AbaETJnE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 05:43:04 -0400
X-IronPort-AV: E=Sophos;i="4.98,873,1392134400"; 
   d="scan'208";a="30762587"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH V3 07/10] workqueue: narrow the protection range of manager_mutex
Date: Tue, 20 May 2014 17:46:33 +0800
Message-ID: <1400579204-3647-8-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1400579204-3647-1-git-send-email-laijs@cn.fujitsu.com>
References: <1399877792-13046-1-git-send-email-laijs@cn.fujitsu.com>
 <1400579204-3647-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In create_worker(), pool->worker_ida is protected by idr subsystem via
using ida_simple_get()/ida_simple_put(), it doesn't need manager_mutex

struct worker allocation and kthread allocation are not visible by any one,
before attached, they don't need manager_mutex either.

The above operations are before the attaching operation which attach
the worker to the pool. And between attached and starting the worker,
the worker is already attached to the pool, the cpuhotplug will handle the
cpu-binding for the worker correctly since it is attached to the pool.
So we don't need the manager_mutex after attached.

The conclusion is that only the attaching operation needs manager_mutex,
so we narrow the protection section of manager_mutex in create_worker().

Some comments about manager_mutex are removed, due to we will rename it to
attach_mutex and add worker_attach_to_pool() later which is self-comments.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   35 +++++------------------------------
 1 files changed, 5 insertions(+), 30 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 637c244..4ae6a3c 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1725,8 +1725,6 @@ static struct worker *create_worker(struct worker_pool *pool)
 	int id = -1;
 	char id_buf[16];
 
-	lockdep_assert_held(&pool->manager_mutex);
-
 	/* ID is needed to determine kthread name. */
 	id = ida_simple_get(&pool->worker_ida, 0, 0, GFP_KERNEL);
 	if (id < 0)
@@ -1755,6 +1753,8 @@ static struct worker *create_worker(struct worker_pool *pool)
 	/* prevent userland from meddling with cpumask of workqueue workers */
 	worker->task->flags |= PF_NO_SETAFFINITY;
 
+	mutex_lock(&pool->manager_mutex);
+
 	/*
 	 * set_cpus_allowed_ptr() will fail if the cpumask doesn't have any
 	 * online CPUs.  It'll be re-applied when any of the CPUs come up.
@@ -1762,7 +1762,7 @@ static struct worker *create_worker(struct worker_pool *pool)
 	set_cpus_allowed_ptr(worker->task, pool->attrs->cpumask);
 
 	/*
-	 * The caller is responsible for ensuring %POOL_DISASSOCIATED
+	 * The pool->manager_mutex ensures %POOL_DISASSOCIATED
 	 * remains stable across this function.  See the comments above the
 	 * flag definition for details.
 	 */
@@ -1772,6 +1772,8 @@ static struct worker *create_worker(struct worker_pool *pool)
 	/* successful, attach the worker to the pool */
 	list_add_tail(&worker->node, &pool->workers);
 
+	mutex_unlock(&pool->manager_mutex);
+
 	return worker;
 
 fail:
@@ -1809,8 +1811,6 @@ static int create_and_start_worker(struct worker_pool *pool)
 {
 	struct worker *worker;
 
-	mutex_lock(&pool->manager_mutex);
-
 	worker = create_worker(pool);
 	if (worker) {
 		spin_lock_irq(&pool->lock);
@@ -1818,8 +1818,6 @@ static int create_and_start_worker(struct worker_pool *pool)
 		spin_unlock_irq(&pool->lock);
 	}
 
-	mutex_unlock(&pool->manager_mutex);
-
 	return worker ? 0 : -ENOMEM;
 }
 
@@ -2019,8 +2017,6 @@ static bool manage_workers(struct worker *worker)
 	bool ret = false;
 
 	/*
-	 * Managership is governed by two mutexes - manager_arb and
-	 * manager_mutex.  manager_arb handles arbitration of manager role.
 	 * Anyone who successfully grabs manager_arb wins the arbitration
 	 * and becomes the manager.  mutex_trylock() on pool->manager_arb
 	 * failure while holding pool->lock reliably indicates that someone
@@ -2029,33 +2025,12 @@ static bool manage_workers(struct worker *worker)
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
-- 
1.7.4.4

