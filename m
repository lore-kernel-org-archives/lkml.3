Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756368Ab3C1GpU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 02:45:20 -0400
Received: from mail-qe0-f45.google.com ([209.85.128.45]:62347 "EHLO
	mail-qe0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756294Ab3C1GpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 02:45:14 -0400
From: Tejun Heo <tj@kernel.org>
To: laijs@cn.fujitsu.com
Cc: axboe@kernel.dk, jack@suse.cz, fengguang.wu@intel.com, jmoyer@redhat.com,
        zab@redhat.com, linux-kernel@vger.kernel.org,
        herbert@gondor.hengli.com.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 14/14] workqueue: update sysfs interface to reflect NUMA awareness and a kernel param to disable NUMA affinity
Date: Wed, 27 Mar 2013 23:43:40 -0700
Message-Id: <1364453020-2829-15-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1364453020-2829-1-git-send-email-tj@kernel.org>
References: <1364453020-2829-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unbound workqueues are now NUMA aware.  Let's add some control knobs
and update sysfs interface accordingly.

* Add kernel param workqueue.numa_disable which disables NUMA affinity
  globally.

* Replace sysfs file "pool_id" with "pool_ids" which contain
  node:pool_id pairs.  This change is userland-visible but "pool_id"
  hasn't seen a release yet, so this is okay.

* Add a new sysf files "numa" which can toggle NUMA affinity on
  individual workqueues.  This is implemented as attrs->no_numa whichn
  is special in that it isn't part of a pool's attributes.  It only
  affects how apply_workqueue_attrs() picks which pools to use.

After "pool_ids" change, first_pwq() doesn't have any user left.
Removed.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 Documentation/kernel-parameters.txt |  9 ++++
 include/linux/workqueue.h           |  5 +++
 kernel/workqueue.c                  | 82 ++++++++++++++++++++++++++-----------
 3 files changed, 73 insertions(+), 23 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 4609e81..c75ea0b 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -3222,6 +3222,15 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			or other driver-specific files in the
 			Documentation/watchdog/ directory.
 
+	workqueue.disable_numa
+			By default, all work items queued to unbound
+			workqueues are affine to the NUMA nodes they're
+			issued on, which results in better behavior in
+			general.  If NUMA affinity needs to be disabled for
+			whatever reason, this option can be used.  Note
+			that this also can be controlled per-workqueue for
+			workqueues visible under /sys/bus/workqueue/.
+
 	x2apic_phys	[X86-64,APIC] Use x2apic physical mode instead of
 			default x2apic cluster mode on platforms
 			supporting x2apic.
diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index 835d12b..7179756 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -119,10 +119,15 @@ struct delayed_work {
 /*
  * A struct for workqueue attributes.  This can be used to change
  * attributes of an unbound workqueue.
+ *
+ * Unlike other fields, ->no_numa isn't a property of a worker_pool.  It
+ * only modifies how apply_workqueue_attrs() select pools and thus doesn't
+ * participate in pool hash calculations or equality comparisons.
  */
 struct workqueue_attrs {
 	int			nice;		/* nice level */
 	cpumask_var_t		cpumask;	/* allowed CPUs */
+	bool			no_numa;	/* disable NUMA affinity */
 };
 
 static inline struct delayed_work *to_delayed_work(struct work_struct *work)
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 637debe..0b6a3b0 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -268,6 +268,9 @@ static int wq_numa_tbl_len;		/* highest possible NUMA node id + 1 */
 static cpumask_var_t *wq_numa_possible_cpumask;
 					/* possible CPUs of each node */
 
+static bool wq_disable_numa;
+module_param_named(disable_numa, wq_disable_numa, bool, 0444);
+
 static bool wq_numa_enabled;		/* unbound NUMA affinity enabled */
 
 /* buf for wq_update_unbound_numa_attrs(), protected by CPU hotplug exclusion */
@@ -517,21 +520,6 @@ static int worker_pool_assign_id(struct worker_pool *pool)
 }
 
 /**
- * first_pwq - return the first pool_workqueue of the specified workqueue
- * @wq: the target workqueue
- *
- * This must be called either with wq->mutex held or sched RCU read locked.
- * If the pwq needs to be used beyond the locking in effect, the caller is
- * responsible for guaranteeing that the pwq stays online.
- */
-static struct pool_workqueue *first_pwq(struct workqueue_struct *wq)
-{
-	assert_rcu_or_wq_mutex(wq);
-	return list_first_or_null_rcu(&wq->pwqs, struct pool_workqueue,
-				      pwqs_node);
-}
-
-/**
  * unbound_pwq_by_node - return the unbound pool_workqueue for the given node
  * @wq: the target workqueue
  * @node: the node ID
@@ -3114,16 +3102,21 @@ static struct device_attribute wq_sysfs_attrs[] = {
 	__ATTR_NULL,
 };
 
-static ssize_t wq_pool_id_show(struct device *dev,
-			       struct device_attribute *attr, char *buf)
+static ssize_t wq_pool_ids_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
 {
 	struct workqueue_struct *wq = dev_to_wq(dev);
-	struct worker_pool *pool;
-	int written;
+	const char *delim = "";
+	int node, written = 0;
 
 	rcu_read_lock_sched();
-	pool = first_pwq(wq)->pool;
-	written = scnprintf(buf, PAGE_SIZE, "%d\n", pool->id);
+	for_each_node(node) {
+		written += scnprintf(buf + written, PAGE_SIZE - written,
+				     "%s%d:%d", delim, node,
+				     unbound_pwq_by_node(wq, node)->pool->id);
+		delim = " ";
+	}
+	written += scnprintf(buf + written, PAGE_SIZE - written, "\n");
 	rcu_read_unlock_sched();
 
 	return written;
@@ -3212,10 +3205,46 @@ static ssize_t wq_cpumask_store(struct device *dev,
 	return ret ?: count;
 }
 
+static ssize_t wq_numa_show(struct device *dev, struct device_attribute *attr,
+			    char *buf)
+{
+	struct workqueue_struct *wq = dev_to_wq(dev);
+	int written;
+
+	mutex_lock(&wq->mutex);
+	written = scnprintf(buf, PAGE_SIZE, "%d\n",
+			    !wq->unbound_attrs->no_numa);
+	mutex_unlock(&wq->mutex);
+
+	return written;
+}
+
+static ssize_t wq_numa_store(struct device *dev, struct device_attribute *attr,
+			     const char *buf, size_t count)
+{
+	struct workqueue_struct *wq = dev_to_wq(dev);
+	struct workqueue_attrs *attrs;
+	int v, ret;
+
+	attrs = wq_sysfs_prep_attrs(wq);
+	if (!attrs)
+		return -ENOMEM;
+
+	ret = -EINVAL;
+	if (sscanf(buf, "%d", &v) == 1) {
+		attrs->no_numa = !v;
+		ret = apply_workqueue_attrs(wq, attrs);
+	}
+
+	free_workqueue_attrs(attrs);
+	return ret ?: count;
+}
+
 static struct device_attribute wq_sysfs_unbound_attrs[] = {
-	__ATTR(pool_id, 0444, wq_pool_id_show, NULL),
+	__ATTR(pool_ids, 0444, wq_pool_ids_show, NULL),
 	__ATTR(nice, 0644, wq_nice_show, wq_nice_store),
 	__ATTR(cpumask, 0644, wq_cpumask_show, wq_cpumask_store),
+	__ATTR(numa, 0644, wq_numa_show, wq_numa_store),
 	__ATTR_NULL,
 };
 
@@ -3750,7 +3779,7 @@ static void free_unbound_pwq(struct pool_workqueue *pwq)
 static bool wq_calc_node_cpumask(const struct workqueue_attrs *attrs, int node,
 				 int cpu_going_down, cpumask_t *cpumask)
 {
-	if (!wq_numa_enabled)
+	if (!wq_numa_enabled || attrs->no_numa)
 		goto use_dfl;
 
 	/* does @node have any online CPUs @attrs wants? */
@@ -3940,6 +3969,8 @@ static void wq_update_unbound_numa(struct workqueue_struct *wq, int cpu,
 	cpumask = target_attrs->cpumask;
 retry:
 	mutex_lock(&wq->mutex);
+	if (wq->unbound_attrs->no_numa)
+		goto out_unlock;
 
 	copy_workqueue_attrs(target_attrs, wq->unbound_attrs);
 	pwq = unbound_pwq_by_node(wq, node);
@@ -4757,6 +4788,11 @@ static void __init wq_numa_init(void)
 	if (num_possible_nodes() <= 1)
 		return;
 
+	if (wq_disable_numa) {
+		pr_info("workqueue: NUMA affinity support disabled\n");
+		return;
+	}
+
 	wq_update_unbound_numa_attrs_buf = alloc_workqueue_attrs(GFP_KERNEL);
 	BUG_ON(!wq_update_unbound_numa_attrs_buf);
 
-- 
1.8.1.4

