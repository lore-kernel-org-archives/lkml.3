Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757772AbaDXOhy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 10:37:54 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:59988 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757732AbaDXOht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 10:37:49 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Christoph Lameter <cl@linux.com>,
        Kevin Hilman <khilman@linaro.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Mike Galbraith <bitbucket@online.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 4/4] workqueue: Handle ordered workqueues on cpumask_unbounds change
Date: Thu, 24 Apr 2014 16:37:36 +0200
Message-Id: <1398350256-7834-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1398350256-7834-1-git-send-email-fweisbec@gmail.com>
References: <1398350256-7834-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ordered unbound workqueues need some special care if we want to
modify their CPU affinity. These can't be simply handled through
apply_workqueue_attrs() since it works by hot plugging worker pools
which has parallelism side effects and this would break ordering.

The way we solve this is to change the affinity of the (presumaly
unique) worker backing the ordered workqueues.

NOTE: Now like Lai said, there may be bad side effects on this because
ordered wq may share their worker pool with non-ordered workqueues.
So changing the affinity of the worker itself is not a nice solution.
This patch is very likely to be replaced by Lai's patch
"workqueue: allow changing attributions of ordered workqueue"
https://lkml.org/lkml/2014/4/15/181

Cc: Christoph Lameter <cl@linux.com>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Mike Galbraith <bitbucket@online.de>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/workqueue.c | 76 +++++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 67 insertions(+), 9 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 387ce38..564e034 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3328,26 +3328,84 @@ static struct bus_type wq_subsys = {
 static int apply_workqueue_attrs_locked(struct workqueue_struct *wq,
 					const struct workqueue_attrs *attrs);
 
+static int unbounds_cpumask_apply_ordered(struct workqueue_struct *wq,
+					  cpumask_var_t cpumask)
+{
+	struct pool_workqueue *pwq;
+	struct worker_pool *pool;
+	struct worker *worker;
+	int ret = 0;
+	int wi;
+
+	/* Ordered wq have a single pool */
+	pwq = list_first_entry(&wq->pwqs, typeof(*pwq), pwqs_node);
+	pool = pwq->pool;
+
+	mutex_lock(&pool->manager_mutex);
+	/* There is a single worker on that pool, but the iterator is convenient */
+	for_each_pool_worker(worker, wi, pool) {
+		ret = set_cpus_allowed_ptr(worker->task, cpumask);
+		if (ret)
+			goto fail;
+	}
+
+	cpumask_copy(pool->attrs->cpumask, cpumask);
+	mutex_unlock(&pool->manager_mutex);
+
+	mutex_lock(&wq->mutex);
+	cpumask_copy(wq->unbound_attrs->cpumask, cpumask);
+	mutex_unlock(&wq->mutex);
+
+	return 0;
+
+fail:
+	mutex_unlock(&pool->manager_mutex);
+	return ret;
+}
+
+static int unbounds_cpumask_apply(struct workqueue_struct *wq,
+				  cpumask_var_t cpumask)
+{
+	struct workqueue_attrs *attrs;
+	int ret;
+
+	attrs = wq_sysfs_prep_attrs(wq);
+	if (!attrs)
+		return -ENOMEM;
+
+	/*
+	 * TODO: this works well when the cpumask is schrinked
+	 * but more plumbing is needed to handle cpumask value
+	 * expansion
+	 */
+	ret = apply_workqueue_attrs_locked(wq, attrs);
+	free_workqueue_attrs(attrs);
+
+	return ret;
+}
+
 /* Must be called with wq_unbound_mutex held */
 static int unbounds_cpumask_apply_all(cpumask_var_t cpumask)
 {
 	struct workqueue_struct *wq;
 
 	list_for_each_entry(wq, &workqueues, list) {
-		struct workqueue_attrs *attrs;
+		int ret;
 
 		if (!(wq->flags & WQ_UNBOUND))
 			continue;
 		/* Ordered workqueues need specific treatment */
 		if (wq->flags & __WQ_ORDERED)
-			continue;
-
-		attrs = wq_sysfs_prep_attrs(wq);
-		if (!attrs)
-			return -ENOMEM;
-
-		WARN_ON_ONCE(apply_workqueue_attrs_locked(wq, attrs));
-		free_workqueue_attrs(attrs);
+			/*
+			 * Calling unbounds_cpumask_apply_ordered() once on
+			 * the first ordered wq we meet should be enough because
+			 * all ordered workqueues all share the same single worker pool.
+			 * But this detail might change in the future
+			 */
+			ret = unbounds_cpumask_apply_ordered(wq, cpumask);
+		else
+			ret = unbounds_cpumask_apply(wq, cpumask);
+		WARN_ON_ONCE(ret);
 	}
 
 	return 0;
-- 
1.8.3.1

