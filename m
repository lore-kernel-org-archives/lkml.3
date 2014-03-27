Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757081AbaC0RWF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 13:22:05 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:45848 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756991AbaC0RVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 13:21:15 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Christoph Lameter <cl@linux.com>,
        Kevin Hilman <khilman@linaro.org>,
        Mike Galbraith <bitbucket@online.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 4/4] workqueue: Include ordered workqueues in anon workqueue sysfs interface
Date: Thu, 27 Mar 2014 18:21:02 +0100
Message-Id: <1395940862-31428-5-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1395940862-31428-1-git-send-email-fweisbec@gmail.com>
References: <1395940862-31428-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changing the cpu affinity of workqueues through the sysfs interface
is done with apply_workqueue_attrs() by replacing the old pwqs
of a workqueue with new ones tied to worker pools that are affine to the
new cpumask.

We can't do that with ordered workqueues however because the serialization
of their works is enforced by keeping a single worker running. Replacing
it with a new pool of single worker may open a small race window where
two workers could run concurrently during the pwq replacement. Eventually
this can break the ordering guarantee.

So ordered workqueues get a special treatment here. Since they run a
single pwq with a single pool containing a single worker that all
ordered workqueue should share, we simply change this worker affinity
to the new cpumask.

Also just in case this behaviour change a bit in the future and some
ordered workqueues have their private worker, lets iterate the affinity
change over all ordered workqueue pools. This way it works in both cases:
whether a single worker is shared among all ordered workqueue pools or
some of them run their private one.

Suggested-by: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: Mike Galbraith <bitbucket@online.de>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/workqueue.c | 68 ++++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 56 insertions(+), 12 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 2863c39..18807c7 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3330,10 +3330,60 @@ static ssize_t wq_anon_cpumask_show(struct device *dev,
 	return written;
 }
 
-/* Must be called with wq_unbound_mutex held */
-static int wq_anon_cpumask_set(cpumask_var_t cpumask)
+static int wq_ordered_cpumask_set(struct workqueue_struct *wq, cpumask_var_t cpumask)
+{
+	struct pool_workqueue *pwq;
+	struct worker_pool *pool;
+	struct worker *worker;
+	int ret;
+	int wi;
+
+	mutex_lock(&wq_pool_mutex);
+	pwq = list_first_entry(&wq->pwqs, typeof(*pwq), pwqs_node);
+	pool = pwq->pool;
+
+	mutex_lock(&pool->manager_mutex);
+	for_each_pool_worker(worker, wi, pool) {
+		/* CHECKME: Should we hold pool->lock here? */
+		ret = set_cpus_allowed_ptr(worker->task, cpumask);
+		if (ret)
+			break;
+	}
+	if (!ret) {
+		cpumask_copy(pool->attrs->cpumask, cpumask);
+	}
+	mutex_unlock(&pool->manager_mutex);
+
+	if (!ret) {
+		mutex_lock(&wq->mutex);
+		cpumask_copy(wq->unbound_attrs->cpumask, cpumask);
+		mutex_unlock(&wq->mutex);
+	}
+
+	mutex_unlock(&wq_pool_mutex);
+
+	return ret;
+}
+
+static int wq_anon_cpumask_set(struct workqueue_struct *wq, cpumask_var_t cpumask)
 {
 	struct workqueue_attrs *attrs;
+	int ret;
+
+	attrs = wq_sysfs_prep_attrs(wq);
+	if (!attrs)
+		return -ENOMEM;
+
+	cpumask_copy(attrs->cpumask, cpumask);
+	ret = apply_workqueue_attrs(wq, attrs);
+	free_workqueue_attrs(attrs);
+
+	return ret;
+}
+
+/* Must be called with wq_unbound_mutex held */
+static int wq_anon_cpumask_set_all(cpumask_var_t cpumask)
+{
 	struct workqueue_struct *wq;
 	int ret;
 
@@ -3343,15 +3393,9 @@ static int wq_anon_cpumask_set(cpumask_var_t cpumask)
 			continue;
 		/* Ordered workqueues need specific treatment */
 		if (wq->flags & __WQ_ORDERED)
-			continue;
-
-		attrs = wq_sysfs_prep_attrs(wq);
-		if (!attrs)
-			return -ENOMEM;
-
-		cpumask_copy(attrs->cpumask, cpumask);
-		ret = apply_workqueue_attrs(wq, attrs);
-		free_workqueue_attrs(attrs);
+			ret = wq_ordered_cpumask_set(wq, cpumask);
+		else
+			ret = wq_anon_cpumask_set(wq, cpumask);
 		if (ret)
 			break;
 	}
@@ -3376,7 +3420,7 @@ static ssize_t wq_anon_cpumask_store(struct device *dev,
 	get_online_cpus();
 	if (cpumask_intersects(cpumask, cpu_online_mask)) {
 		mutex_lock(&wq_unbound_mutex);
-		ret = wq_anon_cpumask_set(cpumask);
+		ret = wq_anon_cpumask_set_all(cpumask);
 		if (!ret)
 			cpumask_copy(&wq_anon_cpumask, cpumask);
 		mutex_unlock(&wq_unbound_mutex);
-- 
1.8.3.1

