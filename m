Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753870AbaELGxh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 02:53:37 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:32387 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753343AbaELGxJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 02:53:09 -0400
X-IronPort-AV: E=Sophos;i="4.97,1033,1389715200"; 
   d="scan'208";a="30389421"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 09/10 V2] workqueue: separate pool-attaching code out from create_worker()
Date: Mon, 12 May 2014 14:56:21 +0800
Message-ID: <1399877792-13046-10-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1399877792-13046-1-git-send-email-laijs@cn.fujitsu.com>
References: <20140505150514.GI11231@htj.dyndns.org>
 <1399877792-13046-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code of attaching is unfolded in create_worker().
Separating this code out will make the codes more clear.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   54 ++++++++++++++++++++++++++++++++-------------------
 1 files changed, 34 insertions(+), 20 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index e6d9725..0ea0152 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -66,7 +66,7 @@ enum {
 	 *
 	 * Note that DISASSOCIATED should be flipped only while holding
 	 * attach_mutex to avoid changing binding state while
-	 * create_worker() is in progress.
+	 * worker_attach_to_pool() is in progress.
 	 */
 	POOL_DISASSOCIATED	= 1 << 2,	/* cpu can't serve workers */
 	POOL_FREEZING		= 1 << 3,	/* freeze in progress */
@@ -1668,6 +1668,38 @@ static struct worker *alloc_worker(void)
 }
 
 /**
+ * worker_attach_to_pool() - attach the worker to the pool
+ * @worker: worker to be attached
+ * @pool: the target pool
+ *
+ * attach the worker to the pool, thus the concurrency and cpu-binding of
+ * the worker are kept coordination with the pool across cpu-[un]hotplug.
+ */
+static void worker_attach_to_pool(struct worker *worker,
+				   struct worker_pool *pool)
+{
+	mutex_lock(&pool->attach_mutex);
+
+	/*
+	 * set_cpus_allowed_ptr() will fail if the cpumask doesn't have any
+	 * online CPUs.  It'll be re-applied when any of the CPUs come up.
+	 */
+	set_cpus_allowed_ptr(worker->task, pool->attrs->cpumask);
+
+	/*
+	 * The pool->attach_mutex ensures %POOL_DISASSOCIATED remains
+	 * stable across this function.  See the comments above the
+	 * flag definition for details.
+	 */
+	if (pool->flags & POOL_DISASSOCIATED)
+		worker->flags |= WORKER_UNBOUND;
+
+	list_add_tail(&worker->node, &pool->workers);
+
+	mutex_unlock(&pool->attach_mutex);
+}
+
+/**
  * worker_detach_from_pool() - detach the worker from the pool
  * @worker: worker which is attached to its pool
  * @pool: attached pool
@@ -1738,26 +1770,8 @@ static struct worker *create_worker(struct worker_pool *pool)
 	/* prevent userland from meddling with cpumask of workqueue workers */
 	worker->task->flags |= PF_NO_SETAFFINITY;
 
-	mutex_lock(&pool->attach_mutex);
-
-	/*
-	 * set_cpus_allowed_ptr() will fail if the cpumask doesn't have any
-	 * online CPUs.  It'll be re-applied when any of the CPUs come up.
-	 */
-	set_cpus_allowed_ptr(worker->task, pool->attrs->cpumask);
-
-	/*
-	 * The pool->attach_mutex ensures %POOL_DISASSOCIATED
-	 * remains stable across this function.  See the comments above the
-	 * flag definition for details.
-	 */
-	if (pool->flags & POOL_DISASSOCIATED)
-		worker->flags |= WORKER_UNBOUND;
-
 	/* successful, attach the worker to the pool */
-	list_add_tail(&worker->node, &pool->workers);
-
-	mutex_unlock(&pool->attach_mutex);
+	worker_attach_to_pool(worker, pool);
 
 	return worker;
 
-- 
1.7.4.4

