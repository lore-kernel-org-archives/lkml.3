Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757715AbaEPQRe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 12:17:34 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:60357 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757637AbaEPQRQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 12:17:16 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Christoph Lameter <cl@linux.com>,
        Kevin Hilman <khilman@linaro.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Mike Galbraith <bitbucket@online.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 5/5] workqueue: Allow modifying low level unbound workqueue cpumask
Date: Fri, 16 May 2014 18:16:55 +0200
Message-Id: <1400257015-28222-6-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1400257015-28222-1-git-send-email-fweisbec@gmail.com>
References: <1400257015-28222-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allow to modify the low-level unbound workqueues cpumask through
sysfs. This is performed by traversing the entire workqueue list
and calling apply_workqueue_attrs() on the unbound workqueues with
the low level mask passed in.

Cc: Christoph Lameter <cl@linux.com>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Mike Galbraith <bitbucket@online.de>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/workqueue.c | 81 ++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 78 insertions(+), 3 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 2aa296d..2a12f00 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -293,7 +293,7 @@ static DEFINE_SPINLOCK(wq_mayday_lock);	/* protects wq->maydays list */
 static LIST_HEAD(workqueues);		/* PL: list of all workqueues */
 static bool workqueue_freezing;		/* PL: have wqs started freezing? */
 
-static cpumask_var_t wq_unbound_cpumask;
+static cpumask_var_t wq_unbound_cpumask; /* PL: low level cpumask for all unbound wqs */
 
 /* the per-cpu worker pools */
 static DEFINE_PER_CPU_SHARED_ALIGNED(struct worker_pool [NR_STD_WORKER_POOLS],
@@ -3643,6 +3643,7 @@ static int apply_workqueue_attrs_locked(struct workqueue_struct *wq,
 {
 	struct workqueue_attrs *new_attrs, *tmp_attrs;
 	struct pool_workqueue **pwq_tbl, *dfl_pwq;
+	cpumask_var_t saved_cpumask;
 	int node, ret;
 
 	/* only unbound workqueues can change attributes */
@@ -3653,15 +3654,25 @@ static int apply_workqueue_attrs_locked(struct workqueue_struct *wq,
 	if (WARN_ON((wq->flags & __WQ_ORDERED) && !attrs->no_numa))
 		return -EINVAL;
 
+	if (!alloc_cpumask_var(&saved_cpumask, GFP_KERNEL))
+		goto enomem;
+
 	pwq_tbl = kzalloc(wq_numa_tbl_len * sizeof(pwq_tbl[0]), GFP_KERNEL);
 	new_attrs = alloc_workqueue_attrs(GFP_KERNEL);
 	tmp_attrs = alloc_workqueue_attrs(GFP_KERNEL);
+
 	if (!pwq_tbl || !new_attrs || !tmp_attrs)
 		goto enomem;
 
 	/* make a copy of @attrs and sanitize it */
 	copy_workqueue_attrs(new_attrs, attrs);
-	cpumask_and(new_attrs->cpumask, new_attrs->cpumask, unbounds_cpumask);
+
+	/*
+	 * Apply unbounds_cpumask on the new attrs for pwq and worker pools
+	 * creation but save the wq proper cpumask for unbound attrs backup.
+	 */
+	cpumask_and(saved_cpumask, new_attrs->cpumask, cpu_possible_mask);
+	cpumask_and(new_attrs->cpumask, saved_cpumask, unbounds_cpumask);
 
 	/*
 	 * We may create multiple pwqs with differing cpumasks.  Make a
@@ -3693,6 +3704,7 @@ static int apply_workqueue_attrs_locked(struct workqueue_struct *wq,
 	/* all pwqs have been created successfully, let's install'em */
 	mutex_lock(&wq->mutex);
 
+	cpumask_copy(new_attrs->cpumask, saved_cpumask);
 	copy_workqueue_attrs(wq->unbound_attrs, new_attrs);
 
 	/* save the previous pwq and install the new one */
@@ -3713,6 +3725,7 @@ static int apply_workqueue_attrs_locked(struct workqueue_struct *wq,
 	ret = 0;
 	/* fall through */
 out_free:
+	free_cpumask_var(saved_cpumask);
 	free_workqueue_attrs(tmp_attrs);
 	free_workqueue_attrs(new_attrs);
 	kfree(pwq_tbl);
@@ -3817,6 +3830,7 @@ static void wq_update_unbound_numa(struct workqueue_struct *wq, int cpu,
 		goto out_unlock;
 
 	copy_workqueue_attrs(target_attrs, wq->unbound_attrs);
+	cpumask_and(target_attrs->cpumask, target_attrs->cpumask, wq_unbound_cpumask);
 	pwq = unbound_pwq_by_node(wq, node);
 
 	/*
@@ -4084,19 +4098,80 @@ static struct bus_type wq_subsys = {
 	.dev_groups			= wq_sysfs_groups,
 };
 
+static int unbounds_cpumask_apply(cpumask_var_t cpumask)
+{
+	struct workqueue_struct *wq;
+	int ret;
+
+	lockdep_assert_held(&wq_pool_mutex);
+
+	list_for_each_entry(wq, &workqueues, list) {
+		struct workqueue_attrs *attrs;
+
+		if (!(wq->flags & WQ_UNBOUND))
+			continue;
+
+		attrs = wq_sysfs_prep_attrs(wq);
+		if (!attrs)
+			return -ENOMEM;
+
+		ret = apply_workqueue_attrs_locked(wq, attrs, cpumask);
+		free_workqueue_attrs(attrs);
+		if (ret)
+			break;
+	}
+
+	return 0;
+}
+
+static ssize_t unbounds_cpumask_store(struct device *dev,
+				      struct device_attribute *attr,
+				      const char *buf, size_t count)
+{
+	cpumask_var_t cpumask;
+	int ret = -EINVAL;
+
+	if (!zalloc_cpumask_var(&cpumask, GFP_KERNEL))
+		return -ENOMEM;
+
+	ret = cpumask_parse(buf, cpumask);
+	if (ret)
+		goto out;
+
+	get_online_cpus();
+	if (cpumask_intersects(cpumask, cpu_online_mask)) {
+		mutex_lock(&wq_pool_mutex);
+		ret = unbounds_cpumask_apply(cpumask);
+		if (ret < 0) {
+			/* Warn if rollback itself fails */
+			WARN_ON_ONCE(unbounds_cpumask_apply(wq_unbound_cpumask));
+		} else {
+			cpumask_copy(wq_unbound_cpumask, cpumask);
+		}
+		mutex_unlock(&wq_pool_mutex);
+	}
+	put_online_cpus();
+out:
+	free_cpumask_var(cpumask);
+	return ret ? ret : count;
+}
+
 static ssize_t unbounds_cpumask_show(struct device *dev,
 				     struct device_attribute *attr, char *buf)
 {
 	int written;
 
+	mutex_lock(&wq_pool_mutex);
 	written = cpumask_scnprintf(buf, PAGE_SIZE, wq_unbound_cpumask);
+	mutex_unlock(&wq_pool_mutex);
+
 	written += scnprintf(buf + written, PAGE_SIZE - written, "\n");
 
 	return written;
 }
 
 static struct device_attribute wq_sysfs_cpumask_attr =
-	__ATTR(cpumask, 0444, unbounds_cpumask_show, NULL);
+	__ATTR(cpumask, 0644, unbounds_cpumask_show, unbounds_cpumask_store);
 
 static int __init wq_sysfs_init(void)
 {
-- 
1.8.3.1

