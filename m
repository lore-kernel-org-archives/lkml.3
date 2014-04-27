Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191AbaD0EG3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 00:06:29 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:63710 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753057AbaD0EGA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 00:06:00 -0400
X-IronPort-AV: E=Sophos;i="4.97,936,1389715200"; 
   d="scan'208";a="29778325"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 09/10] workqueue: separate pool-binding code out from create_worker()
Date: Sun, 27 Apr 2014 12:09:04 +0800
Message-ID: <1398571754-12443-10-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1398571754-12443-1-git-send-email-laijs@cn.fujitsu.com>
References: <1398571754-12443-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code of pool-binding is unfolded in create_worker().
Separating this code out will make the codes more clear.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   53 ++++++++++++++++++++++++++++++++-------------------
 1 files changed, 33 insertions(+), 20 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 9e0e606..0c575b1 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -66,7 +66,7 @@ enum {
 	 *
 	 * Note that DISASSOCIATED should be flipped only while holding
 	 * bind_mutex to avoid changing binding state while
-	 * create_worker() is in progress.
+	 * worker_bind_pool() is in progress.
 	 */
 	POOL_DISASSOCIATED	= 1 << 2,	/* cpu can't serve workers */
 	POOL_FREEZING		= 1 << 3,	/* freeze in progress */
@@ -1668,6 +1668,37 @@ static struct worker *alloc_worker(void)
 }
 
 /**
+ * worker_bind_pool() - bind the worker to the pool
+ * @worker: worker to be bound
+ * @pool: the target pool
+ *
+ * bind the worker to the pool, thus the concurrency and cpu-binding of
+ * the worker are kept coordination with the pool across cpu-[un]hotplug.
+ */
+static void worker_bind_pool(struct worker *worker, struct worker_pool *pool)
+{
+	mutex_lock(&pool->bind_mutex);
+
+	/*
+	 * set_cpus_allowed_ptr() will fail if the cpumask doesn't have any
+	 * online CPUs.  It'll be re-applied when any of the CPUs come up.
+	 */
+	set_cpus_allowed_ptr(worker->task, pool->attrs->cpumask);
+
+	/*
+	 * The pool->bind_mutex ensures %POOL_DISASSOCIATED remains
+	 * stable across this function.  See the comments above the
+	 * flag definition for details.
+	 */
+	if (pool->flags & POOL_DISASSOCIATED)
+		worker->flags |= WORKER_UNBOUND;
+
+	list_add_tail(&worker->bind_entry, &pool->bind_list);
+
+	mutex_unlock(&pool->bind_mutex);
+}
+
+/**
  * worker_unbind_pool() - unbind the worker from the pool
  * @worker: worker which is bound to its pool
  *
@@ -1731,26 +1762,8 @@ static struct worker *create_worker(struct worker_pool *pool)
 	/* prevent userland from meddling with cpumask of workqueue workers */
 	worker->task->flags |= PF_NO_SETAFFINITY;
 
-	mutex_lock(&pool->bind_mutex);
-
-	/*
-	 * set_cpus_allowed_ptr() will fail if the cpumask doesn't have any
-	 * online CPUs.  It'll be re-applied when any of the CPUs come up.
-	 */
-	set_cpus_allowed_ptr(worker->task, pool->attrs->cpumask);
-
-	/*
-	 * The pool->bind_mutex ensures %POOL_DISASSOCIATED
-	 * remains stable across this function.  See the comments above the
-	 * flag definition for details.
-	 */
-	if (pool->flags & POOL_DISASSOCIATED)
-		worker->flags |= WORKER_UNBOUND;
-
 	/* successful, bind the worker to the pool */
-	list_add_tail(&worker->bind_entry, &pool->bind_list);
-
-	mutex_unlock(&pool->bind_mutex);
+	worker_bind_pool(worker, pool);
 
 	return worker;
 
-- 
1.7.4.4

