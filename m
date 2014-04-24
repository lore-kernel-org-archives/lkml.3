Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757729AbaDXOhs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 10:37:48 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:36701 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756018AbaDXOhq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 10:37:46 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Christoph Lameter <cl@linux.com>,
        Kevin Hilman <khilman@linaro.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Mike Galbraith <bitbucket@online.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 2/4] workqueue: Split apply attrs code from its locking
Date: Thu, 24 Apr 2014 16:37:34 +0200
Message-Id: <1398350256-7834-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1398350256-7834-1-git-send-email-fweisbec@gmail.com>
References: <1398350256-7834-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to allow overriding the unbound wqs low-level cpumask, we
need to be able to call apply_workqueue_attr() on all workqueues in
the pool list.

Now since traversing the pool list require to lock it, we can't currently
call apply_workqueue_attr() under the pool traversal.

So lets provide a version of apply_workqueue_attrs() that can be
called when the pool is already locked.

Suggested-by: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Mike Galbraith <bitbucket@online.de>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/workqueue.c | 73 ++++++++++++++++++++++++++++++------------------------
 1 file changed, 41 insertions(+), 32 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index b456ed4..2c38e32 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3927,24 +3927,8 @@ static struct pool_workqueue *numa_pwq_tbl_install(struct workqueue_struct *wq,
 	return old_pwq;
 }
 
-/**
- * apply_workqueue_attrs - apply new workqueue_attrs to an unbound workqueue
- * @wq: the target workqueue
- * @attrs: the workqueue_attrs to apply, allocated with alloc_workqueue_attrs()
- *
- * Apply @attrs to an unbound workqueue @wq.  Unless disabled, on NUMA
- * machines, this function maps a separate pwq to each NUMA node with
- * possibles CPUs in @attrs->cpumask so that work items are affine to the
- * NUMA node it was issued on.  Older pwqs are released as in-flight work
- * items finish.  Note that a work item which repeatedly requeues itself
- * back-to-back will stay on its current pwq.
- *
- * Performs GFP_KERNEL allocations.
- *
- * Return: 0 on success and -errno on failure.
- */
-int apply_workqueue_attrs(struct workqueue_struct *wq,
-			  const struct workqueue_attrs *attrs)
+static int apply_workqueue_attrs_locked(struct workqueue_struct *wq,
+					const struct workqueue_attrs *attrs)
 {
 	struct workqueue_attrs *new_attrs, *tmp_attrs;
 	struct pool_workqueue **pwq_tbl, *dfl_pwq;
@@ -3976,15 +3960,6 @@ int apply_workqueue_attrs(struct workqueue_struct *wq,
 	copy_workqueue_attrs(tmp_attrs, new_attrs);
 
 	/*
-	 * CPUs should stay stable across pwq creations and installations.
-	 * Pin CPUs, determine the target cpumask for each node and create
-	 * pwqs accordingly.
-	 */
-	get_online_cpus();
-
-	mutex_lock(&wq_pool_mutex);
-
-	/*
 	 * If something goes wrong during CPU up/down, we'll fall back to
 	 * the default pwq covering whole @attrs->cpumask.  Always create
 	 * it even if we don't use it immediately.
@@ -4004,8 +3979,6 @@ int apply_workqueue_attrs(struct workqueue_struct *wq,
 		}
 	}
 
-	mutex_unlock(&wq_pool_mutex);
-
 	/* all pwqs have been created successfully, let's install'em */
 	mutex_lock(&wq->mutex);
 
@@ -4026,7 +3999,6 @@ int apply_workqueue_attrs(struct workqueue_struct *wq,
 		put_pwq_unlocked(pwq_tbl[node]);
 	put_pwq_unlocked(dfl_pwq);
 
-	put_online_cpus();
 	ret = 0;
 	/* fall through */
 out_free:
@@ -4040,14 +4012,51 @@ enomem_pwq:
 	for_each_node(node)
 		if (pwq_tbl && pwq_tbl[node] != dfl_pwq)
 			free_unbound_pwq(pwq_tbl[node]);
-	mutex_unlock(&wq_pool_mutex);
-	put_online_cpus();
 enomem:
 	ret = -ENOMEM;
 	goto out_free;
 }
 
 /**
+ * apply_workqueue_attrs - apply new workqueue_attrs to an unbound workqueue
+ * @wq: the target workqueue
+ * @attrs: the workqueue_attrs to apply, allocated with alloc_workqueue_attrs()
+ *
+ * Apply @attrs to an unbound workqueue @wq.  Unless disabled, on NUMA
+ * machines, this function maps a separate pwq to each NUMA node with
+ * possibles CPUs in @attrs->cpumask so that work items are affine to the
+ * NUMA node it was issued on.  Older pwqs are released as in-flight work
+ * items finish.  Note that a work item which repeatedly requeues itself
+ * back-to-back will stay on its current pwq.
+ *
+ * Performs GFP_KERNEL allocations.
+ *
+ * Return: 0 on success and -errno on failure.
+ */
+int apply_workqueue_attrs(struct workqueue_struct *wq,
+			  const struct workqueue_attrs *attrs)
+{
+	int ret;
+
+	/*
+	 * CPUs should stay stable across pwq creations and installations.
+	 * Pin CPUs, determine the target cpumask for each node and create
+	 * pwqs accordingly.
+	 */
+
+	get_online_cpus();
+	/*
+	 * Lock for alloc_unbound_pwq()
+	 */
+	mutex_lock(&wq_pool_mutex);
+	ret = apply_workqueue_attrs_locked(wq, attrs);
+	mutex_unlock(&wq_pool_mutex);
+	put_online_cpus();
+
+	return ret;
+}
+
+/**
  * wq_update_unbound_numa - update NUMA affinity of a wq for CPU hot[un]plug
  * @wq: the target workqueue
  * @cpu: the CPU coming up or going down
-- 
1.8.3.1

