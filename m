Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183AbaEGQhS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 12:37:18 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:49809 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbaEGQhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 12:37:11 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Christoph Lameter <cl@linux.com>,
        Kevin Hilman <khilman@linaro.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Mike Galbraith <bitbucket@online.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 2/6] workqueue: Reorder sysfs code
Date: Wed,  7 May 2014 18:36:57 +0200
Message-Id: <1399480621-19555-3-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1399480621-19555-1-git-send-email-fweisbec@gmail.com>
References: <1399480621-19555-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sysfs code usually belongs to the botom of the file since it deals
with high level objects. In the workqueue code it's misplaced and such
that we'll need to work around functions references to allow the sysfs
code to call APIs like apply_workqueue_attrs().

Lets move that block further in the file, right above alloc_workqueue_key()
which reference it.

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
 kernel/workqueue.c | 626 ++++++++++++++++++++++++++---------------------------
 1 file changed, 313 insertions(+), 313 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index c68e84f..e5d7719 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3137,319 +3137,6 @@ int execute_in_process_context(work_func_t fn, struct execute_work *ew)
 }
 EXPORT_SYMBOL_GPL(execute_in_process_context);
 
-#ifdef CONFIG_SYSFS
-/*
- * Workqueues with WQ_SYSFS flag set is visible to userland via
- * /sys/bus/workqueue/devices/WQ_NAME.  All visible workqueues have the
- * following attributes.
- *
- *  per_cpu	RO bool	: whether the workqueue is per-cpu or unbound
- *  max_active	RW int	: maximum number of in-flight work items
- *
- * Unbound workqueues have the following extra attributes.
- *
- *  id		RO int	: the associated pool ID
- *  nice	RW int	: nice value of the workers
- *  cpumask	RW mask	: bitmask of allowed CPUs for the workers
- */
-struct wq_device {
-	struct workqueue_struct		*wq;
-	struct device			dev;
-};
-
-static struct workqueue_struct *dev_to_wq(struct device *dev)
-{
-	struct wq_device *wq_dev = container_of(dev, struct wq_device, dev);
-
-	return wq_dev->wq;
-}
-
-static ssize_t per_cpu_show(struct device *dev, struct device_attribute *attr,
-			    char *buf)
-{
-	struct workqueue_struct *wq = dev_to_wq(dev);
-
-	return scnprintf(buf, PAGE_SIZE, "%d\n", (bool)!(wq->flags & WQ_UNBOUND));
-}
-static DEVICE_ATTR_RO(per_cpu);
-
-static ssize_t max_active_show(struct device *dev,
-			       struct device_attribute *attr, char *buf)
-{
-	struct workqueue_struct *wq = dev_to_wq(dev);
-
-	return scnprintf(buf, PAGE_SIZE, "%d\n", wq->saved_max_active);
-}
-
-static ssize_t max_active_store(struct device *dev,
-				struct device_attribute *attr, const char *buf,
-				size_t count)
-{
-	struct workqueue_struct *wq = dev_to_wq(dev);
-	int val;
-
-	if (sscanf(buf, "%d", &val) != 1 || val <= 0)
-		return -EINVAL;
-
-	workqueue_set_max_active(wq, val);
-	return count;
-}
-static DEVICE_ATTR_RW(max_active);
-
-static struct attribute *wq_sysfs_attrs[] = {
-	&dev_attr_per_cpu.attr,
-	&dev_attr_max_active.attr,
-	NULL,
-};
-ATTRIBUTE_GROUPS(wq_sysfs);
-
-static ssize_t wq_pool_ids_show(struct device *dev,
-				struct device_attribute *attr, char *buf)
-{
-	struct workqueue_struct *wq = dev_to_wq(dev);
-	const char *delim = "";
-	int node, written = 0;
-
-	rcu_read_lock_sched();
-	for_each_node(node) {
-		written += scnprintf(buf + written, PAGE_SIZE - written,
-				     "%s%d:%d", delim, node,
-				     unbound_pwq_by_node(wq, node)->pool->id);
-		delim = " ";
-	}
-	written += scnprintf(buf + written, PAGE_SIZE - written, "\n");
-	rcu_read_unlock_sched();
-
-	return written;
-}
-
-static ssize_t wq_nice_show(struct device *dev, struct device_attribute *attr,
-			    char *buf)
-{
-	struct workqueue_struct *wq = dev_to_wq(dev);
-	int written;
-
-	mutex_lock(&wq->mutex);
-	written = scnprintf(buf, PAGE_SIZE, "%d\n", wq->unbound_attrs->nice);
-	mutex_unlock(&wq->mutex);
-
-	return written;
-}
-
-/* prepare workqueue_attrs for sysfs store operations */
-static struct workqueue_attrs *wq_sysfs_prep_attrs(struct workqueue_struct *wq)
-{
-	struct workqueue_attrs *attrs;
-
-	attrs = alloc_workqueue_attrs(GFP_KERNEL);
-	if (!attrs)
-		return NULL;
-
-	mutex_lock(&wq->mutex);
-	copy_workqueue_attrs(attrs, wq->unbound_attrs);
-	mutex_unlock(&wq->mutex);
-	return attrs;
-}
-
-static ssize_t wq_nice_store(struct device *dev, struct device_attribute *attr,
-			     const char *buf, size_t count)
-{
-	struct workqueue_struct *wq = dev_to_wq(dev);
-	struct workqueue_attrs *attrs;
-	int ret;
-
-	attrs = wq_sysfs_prep_attrs(wq);
-	if (!attrs)
-		return -ENOMEM;
-
-	if (sscanf(buf, "%d", &attrs->nice) == 1 &&
-	    attrs->nice >= MIN_NICE && attrs->nice <= MAX_NICE)
-		ret = apply_workqueue_attrs(wq, attrs);
-	else
-		ret = -EINVAL;
-
-	free_workqueue_attrs(attrs);
-	return ret ?: count;
-}
-
-static ssize_t wq_cpumask_show(struct device *dev,
-			       struct device_attribute *attr, char *buf)
-{
-	struct workqueue_struct *wq = dev_to_wq(dev);
-	int written;
-
-	mutex_lock(&wq->mutex);
-	written = cpumask_scnprintf(buf, PAGE_SIZE, wq->unbound_attrs->cpumask);
-	mutex_unlock(&wq->mutex);
-
-	written += scnprintf(buf + written, PAGE_SIZE - written, "\n");
-	return written;
-}
-
-static ssize_t wq_cpumask_store(struct device *dev,
-				struct device_attribute *attr,
-				const char *buf, size_t count)
-{
-	struct workqueue_struct *wq = dev_to_wq(dev);
-	struct workqueue_attrs *attrs;
-	int ret;
-
-	attrs = wq_sysfs_prep_attrs(wq);
-	if (!attrs)
-		return -ENOMEM;
-
-	ret = cpumask_parse(buf, attrs->cpumask);
-	if (!ret)
-		ret = apply_workqueue_attrs(wq, attrs);
-
-	free_workqueue_attrs(attrs);
-	return ret ?: count;
-}
-
-static ssize_t wq_numa_show(struct device *dev, struct device_attribute *attr,
-			    char *buf)
-{
-	struct workqueue_struct *wq = dev_to_wq(dev);
-	int written;
-
-	mutex_lock(&wq->mutex);
-	written = scnprintf(buf, PAGE_SIZE, "%d\n",
-			    !wq->unbound_attrs->no_numa);
-	mutex_unlock(&wq->mutex);
-
-	return written;
-}
-
-static ssize_t wq_numa_store(struct device *dev, struct device_attribute *attr,
-			     const char *buf, size_t count)
-{
-	struct workqueue_struct *wq = dev_to_wq(dev);
-	struct workqueue_attrs *attrs;
-	int v, ret;
-
-	/* Creating per-node pwqs breaks ordering guarantee. Keep no_numa = 1 */
-	if (WARN_ON(wq->flags & __WQ_ORDERED))
-		return -EINVAL;
-
-	attrs = wq_sysfs_prep_attrs(wq);
-	if (!attrs)
-		return -ENOMEM;
-
-	ret = -EINVAL;
-	if (sscanf(buf, "%d", &v) == 1) {
-		attrs->no_numa = !v;
-		ret = apply_workqueue_attrs(wq, attrs);
-	}
-
-	free_workqueue_attrs(attrs);
-	return ret ?: count;
-}
-
-static struct device_attribute wq_sysfs_unbound_attrs[] = {
-	__ATTR(pool_ids, 0444, wq_pool_ids_show, NULL),
-	__ATTR(nice, 0644, wq_nice_show, wq_nice_store),
-	__ATTR(cpumask, 0644, wq_cpumask_show, wq_cpumask_store),
-	__ATTR(numa, 0644, wq_numa_show, wq_numa_store),
-	__ATTR_NULL,
-};
-
-static struct bus_type wq_subsys = {
-	.name				= "workqueue",
-	.dev_groups			= wq_sysfs_groups,
-};
-
-static int __init wq_sysfs_init(void)
-{
-	return subsys_virtual_register(&wq_subsys, NULL);
-}
-core_initcall(wq_sysfs_init);
-
-static void wq_device_release(struct device *dev)
-{
-	struct wq_device *wq_dev = container_of(dev, struct wq_device, dev);
-
-	kfree(wq_dev);
-}
-
-/**
- * workqueue_sysfs_register - make a workqueue visible in sysfs
- * @wq: the workqueue to register
- *
- * Expose @wq in sysfs under /sys/bus/workqueue/devices.
- * alloc_workqueue*() automatically calls this function if WQ_SYSFS is set
- * which is the preferred method.
- *
- * Workqueue user should use this function directly iff it wants to apply
- * workqueue_attrs before making the workqueue visible in sysfs; otherwise,
- * apply_workqueue_attrs() may race against userland updating the
- * attributes.
- *
- * Return: 0 on success, -errno on failure.
- */
-int workqueue_sysfs_register(struct workqueue_struct *wq)
-{
-	struct wq_device *wq_dev;
-	int ret;
-
-	wq->wq_dev = wq_dev = kzalloc(sizeof(*wq_dev), GFP_KERNEL);
-	if (!wq_dev)
-		return -ENOMEM;
-
-	wq_dev->wq = wq;
-	wq_dev->dev.bus = &wq_subsys;
-	wq_dev->dev.init_name = wq->name;
-	wq_dev->dev.release = wq_device_release;
-
-	/*
-	 * unbound_attrs are created separately.  Suppress uevent until
-	 * everything is ready.
-	 */
-	dev_set_uevent_suppress(&wq_dev->dev, true);
-
-	ret = device_register(&wq_dev->dev);
-	if (ret) {
-		kfree(wq_dev);
-		wq->wq_dev = NULL;
-		return ret;
-	}
-
-	if (wq->flags & WQ_UNBOUND) {
-		struct device_attribute *attr;
-
-		for (attr = wq_sysfs_unbound_attrs; attr->attr.name; attr++) {
-			ret = device_create_file(&wq_dev->dev, attr);
-			if (ret) {
-				device_unregister(&wq_dev->dev);
-				wq->wq_dev = NULL;
-				return ret;
-			}
-		}
-	}
-
-	kobject_uevent(&wq_dev->dev.kobj, KOBJ_ADD);
-	return 0;
-}
-
-/**
- * workqueue_sysfs_unregister - undo workqueue_sysfs_register()
- * @wq: the workqueue to unregister
- *
- * If @wq is registered to sysfs by workqueue_sysfs_register(), unregister.
- */
-static void workqueue_sysfs_unregister(struct workqueue_struct *wq)
-{
-	struct wq_device *wq_dev = wq->wq_dev;
-
-	if (!wq->wq_dev)
-		return;
-
-	wq->wq_dev = NULL;
-	device_unregister(&wq_dev->dev);
-}
-#else	/* CONFIG_SYSFS */
-static void workqueue_sysfs_unregister(struct workqueue_struct *wq)	{ }
-#endif	/* CONFIG_SYSFS */
-
 /**
  * free_workqueue_attrs - free a workqueue_attrs
  * @attrs: workqueue_attrs to free
@@ -4163,6 +3850,319 @@ out_unlock:
 	put_pwq_unlocked(old_pwq);
 }
 
+#ifdef CONFIG_SYSFS
+/*
+ * Workqueues with WQ_SYSFS flag set is visible to userland via
+ * /sys/bus/workqueue/devices/WQ_NAME.  All visible workqueues have the
+ * following attributes.
+ *
+ *  per_cpu	RO bool	: whether the workqueue is per-cpu or unbound
+ *  max_active	RW int	: maximum number of in-flight work items
+ *
+ * Unbound workqueues have the following extra attributes.
+ *
+ *  id		RO int	: the associated pool ID
+ *  nice	RW int	: nice value of the workers
+ *  cpumask	RW mask	: bitmask of allowed CPUs for the workers
+ */
+struct wq_device {
+	struct workqueue_struct		*wq;
+	struct device			dev;
+};
+
+static struct workqueue_struct *dev_to_wq(struct device *dev)
+{
+	struct wq_device *wq_dev = container_of(dev, struct wq_device, dev);
+
+	return wq_dev->wq;
+}
+
+static ssize_t per_cpu_show(struct device *dev, struct device_attribute *attr,
+			    char *buf)
+{
+	struct workqueue_struct *wq = dev_to_wq(dev);
+
+	return scnprintf(buf, PAGE_SIZE, "%d\n", (bool)!(wq->flags & WQ_UNBOUND));
+}
+static DEVICE_ATTR_RO(per_cpu);
+
+static ssize_t max_active_show(struct device *dev,
+			       struct device_attribute *attr, char *buf)
+{
+	struct workqueue_struct *wq = dev_to_wq(dev);
+
+	return scnprintf(buf, PAGE_SIZE, "%d\n", wq->saved_max_active);
+}
+
+static ssize_t max_active_store(struct device *dev,
+				struct device_attribute *attr, const char *buf,
+				size_t count)
+{
+	struct workqueue_struct *wq = dev_to_wq(dev);
+	int val;
+
+	if (sscanf(buf, "%d", &val) != 1 || val <= 0)
+		return -EINVAL;
+
+	workqueue_set_max_active(wq, val);
+	return count;
+}
+static DEVICE_ATTR_RW(max_active);
+
+static struct attribute *wq_sysfs_attrs[] = {
+	&dev_attr_per_cpu.attr,
+	&dev_attr_max_active.attr,
+	NULL,
+};
+ATTRIBUTE_GROUPS(wq_sysfs);
+
+static ssize_t wq_pool_ids_show(struct device *dev,
+				struct device_attribute *attr, char *buf)
+{
+	struct workqueue_struct *wq = dev_to_wq(dev);
+	const char *delim = "";
+	int node, written = 0;
+
+	rcu_read_lock_sched();
+	for_each_node(node) {
+		written += scnprintf(buf + written, PAGE_SIZE - written,
+				     "%s%d:%d", delim, node,
+				     unbound_pwq_by_node(wq, node)->pool->id);
+		delim = " ";
+	}
+	written += scnprintf(buf + written, PAGE_SIZE - written, "\n");
+	rcu_read_unlock_sched();
+
+	return written;
+}
+
+static ssize_t wq_nice_show(struct device *dev, struct device_attribute *attr,
+			    char *buf)
+{
+	struct workqueue_struct *wq = dev_to_wq(dev);
+	int written;
+
+	mutex_lock(&wq->mutex);
+	written = scnprintf(buf, PAGE_SIZE, "%d\n", wq->unbound_attrs->nice);
+	mutex_unlock(&wq->mutex);
+
+	return written;
+}
+
+/* prepare workqueue_attrs for sysfs store operations */
+static struct workqueue_attrs *wq_sysfs_prep_attrs(struct workqueue_struct *wq)
+{
+	struct workqueue_attrs *attrs;
+
+	attrs = alloc_workqueue_attrs(GFP_KERNEL);
+	if (!attrs)
+		return NULL;
+
+	mutex_lock(&wq->mutex);
+	copy_workqueue_attrs(attrs, wq->unbound_attrs);
+	mutex_unlock(&wq->mutex);
+	return attrs;
+}
+
+static ssize_t wq_nice_store(struct device *dev, struct device_attribute *attr,
+			     const char *buf, size_t count)
+{
+	struct workqueue_struct *wq = dev_to_wq(dev);
+	struct workqueue_attrs *attrs;
+	int ret;
+
+	attrs = wq_sysfs_prep_attrs(wq);
+	if (!attrs)
+		return -ENOMEM;
+
+	if (sscanf(buf, "%d", &attrs->nice) == 1 &&
+	    attrs->nice >= MIN_NICE && attrs->nice <= MAX_NICE)
+		ret = apply_workqueue_attrs(wq, attrs);
+	else
+		ret = -EINVAL;
+
+	free_workqueue_attrs(attrs);
+	return ret ?: count;
+}
+
+static ssize_t wq_cpumask_show(struct device *dev,
+			       struct device_attribute *attr, char *buf)
+{
+	struct workqueue_struct *wq = dev_to_wq(dev);
+	int written;
+
+	mutex_lock(&wq->mutex);
+	written = cpumask_scnprintf(buf, PAGE_SIZE, wq->unbound_attrs->cpumask);
+	mutex_unlock(&wq->mutex);
+
+	written += scnprintf(buf + written, PAGE_SIZE - written, "\n");
+	return written;
+}
+
+static ssize_t wq_cpumask_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	struct workqueue_struct *wq = dev_to_wq(dev);
+	struct workqueue_attrs *attrs;
+	int ret;
+
+	attrs = wq_sysfs_prep_attrs(wq);
+	if (!attrs)
+		return -ENOMEM;
+
+	ret = cpumask_parse(buf, attrs->cpumask);
+	if (!ret)
+		ret = apply_workqueue_attrs(wq, attrs);
+
+	free_workqueue_attrs(attrs);
+	return ret ?: count;
+}
+
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
+	/* Creating per-node pwqs breaks ordering guarantee. Keep no_numa = 1 */
+	if (WARN_ON(wq->flags & __WQ_ORDERED))
+		return -EINVAL;
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
+static struct device_attribute wq_sysfs_unbound_attrs[] = {
+	__ATTR(pool_ids, 0444, wq_pool_ids_show, NULL),
+	__ATTR(nice, 0644, wq_nice_show, wq_nice_store),
+	__ATTR(cpumask, 0644, wq_cpumask_show, wq_cpumask_store),
+	__ATTR(numa, 0644, wq_numa_show, wq_numa_store),
+	__ATTR_NULL,
+};
+
+static struct bus_type wq_subsys = {
+	.name				= "workqueue",
+	.dev_groups			= wq_sysfs_groups,
+};
+
+static int __init wq_sysfs_init(void)
+{
+	return subsys_virtual_register(&wq_subsys, NULL);
+}
+core_initcall(wq_sysfs_init);
+
+static void wq_device_release(struct device *dev)
+{
+	struct wq_device *wq_dev = container_of(dev, struct wq_device, dev);
+
+	kfree(wq_dev);
+}
+
+/**
+ * workqueue_sysfs_register - make a workqueue visible in sysfs
+ * @wq: the workqueue to register
+ *
+ * Expose @wq in sysfs under /sys/bus/workqueue/devices.
+ * alloc_workqueue*() automatically calls this function if WQ_SYSFS is set
+ * which is the preferred method.
+ *
+ * Workqueue user should use this function directly iff it wants to apply
+ * workqueue_attrs before making the workqueue visible in sysfs; otherwise,
+ * apply_workqueue_attrs() may race against userland updating the
+ * attributes.
+ *
+ * Return: 0 on success, -errno on failure.
+ */
+int workqueue_sysfs_register(struct workqueue_struct *wq)
+{
+	struct wq_device *wq_dev;
+	int ret;
+
+	wq->wq_dev = wq_dev = kzalloc(sizeof(*wq_dev), GFP_KERNEL);
+	if (!wq_dev)
+		return -ENOMEM;
+
+	wq_dev->wq = wq;
+	wq_dev->dev.bus = &wq_subsys;
+	wq_dev->dev.init_name = wq->name;
+	wq_dev->dev.release = wq_device_release;
+
+	/*
+	 * unbound_attrs are created separately.  Suppress uevent until
+	 * everything is ready.
+	 */
+	dev_set_uevent_suppress(&wq_dev->dev, true);
+
+	ret = device_register(&wq_dev->dev);
+	if (ret) {
+		kfree(wq_dev);
+		wq->wq_dev = NULL;
+		return ret;
+	}
+
+	if (wq->flags & WQ_UNBOUND) {
+		struct device_attribute *attr;
+
+		for (attr = wq_sysfs_unbound_attrs; attr->attr.name; attr++) {
+			ret = device_create_file(&wq_dev->dev, attr);
+			if (ret) {
+				device_unregister(&wq_dev->dev);
+				wq->wq_dev = NULL;
+				return ret;
+			}
+		}
+	}
+
+	kobject_uevent(&wq_dev->dev.kobj, KOBJ_ADD);
+	return 0;
+}
+
+/**
+ * workqueue_sysfs_unregister - undo workqueue_sysfs_register()
+ * @wq: the workqueue to unregister
+ *
+ * If @wq is registered to sysfs by workqueue_sysfs_register(), unregister.
+ */
+static void workqueue_sysfs_unregister(struct workqueue_struct *wq)
+{
+	struct wq_device *wq_dev = wq->wq_dev;
+
+	if (!wq->wq_dev)
+		return;
+
+	wq->wq_dev = NULL;
+	device_unregister(&wq_dev->dev);
+}
+#else	/* CONFIG_SYSFS */
+static void workqueue_sysfs_unregister(struct workqueue_struct *wq)	{ }
+#endif	/* CONFIG_SYSFS */
+
 static int alloc_and_link_pwqs(struct workqueue_struct *wq)
 {
 	bool highpri = wq->flags & WQ_HIGHPRI;
-- 
1.8.3.1

