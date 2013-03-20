Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757674Ab3CTABS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 20:01:18 -0400
Received: from mail-vc0-f175.google.com ([209.85.220.175]:40162 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933081Ab3CTABN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 20:01:13 -0400
From: Tejun Heo <tj@kernel.org>
To: laijs@cn.fujitsu.com
Cc: axboe@kernel.dk, jack@suse.cz, fengguang.wu@intel.com, jmoyer@redhat.com,
        zab@redhat.com, linux-kernel@vger.kernel.org,
        herbert@gondor.hengli.com.au, davem@davemloft.net,
        linux-crypto@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 10/10] workqueue: update sysfs interface to reflect NUMA awareness and a kernel param to disable NUMA affinity
Date: Tue, 19 Mar 2013 17:00:29 -0700
Message-Id: <1363737629-16745-11-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1363737629-16745-1-git-send-email-tj@kernel.org>
References: <1363737629-16745-1-git-send-email-tj@kernel.org>
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
 Documentation/kernel-parameters.txt |   9 +++
 include/linux/workqueue.h           |   5 ++
 kernel/workqueue.c                  | 125 +++++++++++++++++++++++++-----------
 3 files changed, 102 insertions(+), 37 deletions(-)

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
index 0c36327..b48373a 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -45,6 +45,7 @@
 #include <linux/hashtable.h>
 #include <linux/rculist.h>
 #include <linux/nodemask.h>
+#include <linux/moduleparam.h>
 
 #include "workqueue_internal.h"
 
@@ -302,6 +303,9 @@ EXPORT_SYMBOL_GPL(system_unbound_wq);
 struct workqueue_struct *system_freezable_wq __read_mostly;
 EXPORT_SYMBOL_GPL(system_freezable_wq);
 
+static bool wq_disable_numa;
+module_param_named(disable_numa, wq_disable_numa, bool, 0444);
+
 static int worker_thread(void *__worker);
 static void copy_workqueue_attrs(struct workqueue_attrs *to,
 				 const struct workqueue_attrs *from);
@@ -516,21 +520,6 @@ static int worker_pool_assign_id(struct worker_pool *pool)
 }
 
 /**
- * first_pwq - return the first pool_workqueue of the specified workqueue
- * @wq: the target workqueue
- *
- * This must be called either with pwq_lock held or sched RCU read locked.
- * If the pwq needs to be used beyond the locking in effect, the caller is
- * responsible for guaranteeing that the pwq stays online.
- */
-static struct pool_workqueue *first_pwq(struct workqueue_struct *wq)
-{
-	assert_rcu_or_pwq_lock();
-	return list_first_or_null_rcu(&wq->pwqs, struct pool_workqueue,
-				      pwqs_node);
-}
-
-/**
  * unbound_pwq_by_node - return the unbound pool_workqueue for the given node
  * @wq: the target workqueue
  * @node: the node ID
@@ -3101,16 +3090,21 @@ static struct device_attribute wq_sysfs_attrs[] = {
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
@@ -3199,10 +3193,52 @@ static ssize_t wq_cpumask_store(struct device *dev,
 	return ret ?: count;
 }
 
+static ssize_t wq_numa_show(struct device *dev, struct device_attribute *attr,
+			    char *buf)
+{
+	struct workqueue_struct *wq = dev_to_wq(dev);
+	int written;
+
+	mutex_lock(&wq_mutex);
+	written = scnprintf(buf, PAGE_SIZE, "%d\n",
+			    !wq->unbound_attrs->no_numa &&
+			    wq_numa_possible_cpumask);
+	mutex_unlock(&wq_mutex);
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
+		if (!v || wq_numa_possible_cpumask) {
+			attrs->no_numa = !v;
+			ret = apply_workqueue_attrs(wq, attrs);
+		} else {
+			printk_ratelimited(KERN_WARNING "workqueue: can't enable NUMA affinity for \"%s\", disabled system-wide\n",
+					   wq->name);
+		}
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
 
@@ -3725,6 +3761,7 @@ int apply_workqueue_attrs(struct workqueue_struct *wq,
 {
 	struct pool_workqueue **pwq_tbl = NULL, *dfl_pwq = NULL;
 	struct workqueue_attrs *tmp_attrs = NULL;
+	bool do_numa = !attrs->no_numa && wq_numa_possible_cpumask;
 	int node;
 
 	/* only unbound workqueues can change attributes */
@@ -3740,7 +3777,15 @@ int apply_workqueue_attrs(struct workqueue_struct *wq,
 	if (!pwq_tbl || !tmp_attrs)
 		goto enomem;
 
+	/*
+	 * We'll be creating multiple pwqs with differing cpumasks.  Make a
+	 * copy of @attrs which will be modified and used to obtain pools.
+	 * no_numa attribute is special in that it isn't a part of pool
+	 * attributes but modifies how pools are selected in this function.
+	 * Let's not leak no_numa to pool handling functions.
+	 */
 	copy_workqueue_attrs(tmp_attrs, attrs);
+	tmp_attrs->no_numa = false;
 
 	/*
 	 * We want NUMA affinity.  For each node with intersecting possible
@@ -3755,7 +3800,7 @@ int apply_workqueue_attrs(struct workqueue_struct *wq,
 		 * Just fall through if NUMA affinity isn't enabled.  We'll
 		 * end up using the default pwq which is what we want.
 		 */
-		if (wq_numa_possible_cpumask) {
+		if (do_numa) {
 			cpumask_and(cpumask, wq_numa_possible_cpumask[node],
 				    attrs->cpumask);
 			if (cpumask_empty(cpumask))
@@ -4588,22 +4633,28 @@ static int __init init_workqueues(void)
 	 * available.  Build one from cpu_to_node() which should have been
 	 * fully initialized by now.
 	 */
-	wq_numa_possible_cpumask = kzalloc(wq_numa_tbl_len *
-					   sizeof(wq_numa_possible_cpumask[0]),
-					   GFP_KERNEL);
-	BUG_ON(!wq_numa_possible_cpumask);
+	if (!wq_disable_numa) {
+		static cpumask_var_t *tbl;
 
-	for_each_node(node)
-		BUG_ON(!alloc_cpumask_var_node(&wq_numa_possible_cpumask[node],
-					       GFP_KERNEL, node));
-	for_each_possible_cpu(cpu) {
-		node = cpu_to_node(cpu);
-		if (WARN_ON(node == NUMA_NO_NODE)) {
-			pr_err("workqueue: NUMA node mapping not available for cpu%d, disabling NUMA support\n", cpu);
-			wq_numa_possible_cpumask = NULL;
-			break;
+		tbl = kzalloc(wq_numa_tbl_len * sizeof(tbl[0]), GFP_KERNEL);
+		BUG_ON(!tbl);
+
+		for_each_node(node)
+			BUG_ON(!alloc_cpumask_var_node(&tbl[node], GFP_KERNEL,
+						       node));
+		for_each_possible_cpu(cpu) {
+			node = cpu_to_node(cpu);
+			if (WARN_ON(node == NUMA_NO_NODE)) {
+				pr_warn("workqueue: NUMA node mapping not available for cpu%d, disabling NUMA support\n", cpu);
+				tbl = NULL;
+				break;
+			}
+			cpumask_set_cpu(cpu, tbl[node]);
 		}
-		cpumask_set_cpu(cpu, wq_numa_possible_cpumask[node]);
+
+		wq_numa_possible_cpumask = tbl;
+	} else {
+		pr_info("workqueue: NUMA affinity support disabled\n");
 	}
 
 	/* initialize CPU pools */
-- 
1.8.1.4

