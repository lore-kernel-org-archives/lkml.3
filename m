Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932171Ab3CDSaf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 13:30:35 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:41055 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932095Ab3CDSaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 13:30:30 -0500
Date: Mon, 4 Mar 2013 10:30:25 -0800
From: Tejun Heo <tj@kernel.org>
To: linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com
Cc: axboe@kernel.dk, jmoyer@redhat.com, zab@redhat.com
Subject: [PATCH v2 31/31] workqueue: implement sysfs interface for workqueues
Message-ID: <20130304183025.GH30413@htj.dyndns.org>
References: <1362194662-2344-1-git-send-email-tj@kernel.org>
 <1362194662-2344-32-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1362194662-2344-32-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are cases where workqueue users want to expose control knobs to
userland.  e.g. Unbound workqueues with custom attributes are
scheduled to be used for writeback workers and depending on
configuration it can be useful to allow admins to tinker with the
priority or allowed CPUs.

This patch implements workqueue_sysfs_register(), which makes the
workqueue visible under /sys/bus/workqueue/devices/WQ_NAME.  There
currently are two attributes common to both per-cpu and unbound pools
and extra attributes for unbound pools including nice level and
cpumask.

If alloc_workqueue*() is called with WQ_SYSFS,
workqueue_sysfs_register() is called automatically as part of
workqueue creation.  This is the preferred method unless the workqueue
user wants to apply workqueue_attrs before making the workqueue
visible to userland.

v2: Disallow exposing ordered workqueues as ordered workqueues can't
    be tuned in any way.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/workqueue.h |    8 +
 kernel/workqueue.c        |  288 ++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 296 insertions(+)

--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -292,6 +292,7 @@ enum {
 	WQ_MEM_RECLAIM		= 1 << 3, /* may be used for memory reclaim */
 	WQ_HIGHPRI		= 1 << 4, /* high priority */
 	WQ_CPU_INTENSIVE	= 1 << 5, /* cpu instensive workqueue */
+	WQ_SYSFS		= 1 << 6, /* visible in sysfs, see wq_sysfs_register() */
 
 	__WQ_DRAINING		= 1 << 16, /* internal: workqueue is draining */
 	__WQ_ORDERED		= 1 << 17, /* internal: workqueue is ordered */
@@ -494,4 +495,11 @@ extern bool freeze_workqueues_busy(void)
 extern void thaw_workqueues(void);
 #endif /* CONFIG_FREEZER */
 
+#ifdef CONFIG_SYSFS
+int workqueue_sysfs_register(struct workqueue_struct *wq);
+#else	/* CONFIG_SYSFS */
+static inline int workqueue_sysfs_register(struct workqueue_struct *wq)
+{ return 0; }
+#endif	/* CONFIG_SYSFS */
+
 #endif
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -210,6 +210,8 @@ struct wq_flusher {
 	struct completion	done;		/* flush completion */
 };
 
+struct wq_device;
+
 /*
  * The externally visible workqueue abstraction is an array of
  * per-CPU workqueues:
@@ -233,6 +235,10 @@ struct workqueue_struct {
 
 	int			nr_drainers;	/* W: drain in progress */
 	int			saved_max_active; /* W: saved pwq max_active */
+
+#ifdef CONFIG_SYSFS
+	struct wq_device	*wq_dev;	/* I: for sysfs interface */
+#endif
 #ifdef CONFIG_LOCKDEP
 	struct lockdep_map	lockdep_map;
 #endif
@@ -438,6 +444,8 @@ static DEFINE_PER_CPU_SHARED_ALIGNED(str
 static DEFINE_IDR(worker_pool_idr);
 
 static int worker_thread(void *__worker);
+static void copy_workqueue_attrs(struct workqueue_attrs *to,
+				 const struct workqueue_attrs *from);
 
 /* allocate ID and assign it to @pool */
 static int worker_pool_assign_id(struct worker_pool *pool)
@@ -3151,6 +3159,281 @@ int keventd_up(void)
 	return system_wq != NULL;
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
+static ssize_t wq_per_cpu_show(struct device *dev,
+			       struct device_attribute *attr, char *buf)
+{
+	struct workqueue_struct *wq = dev_to_wq(dev);
+
+	return scnprintf(buf, PAGE_SIZE, "%d\n", (bool)!(wq->flags & WQ_UNBOUND));
+}
+
+static ssize_t wq_max_active_show(struct device *dev,
+				  struct device_attribute *attr, char *buf)
+{
+	struct workqueue_struct *wq = dev_to_wq(dev);
+
+	return scnprintf(buf, PAGE_SIZE, "%d\n", wq->saved_max_active);
+}
+
+static ssize_t wq_max_active_store(struct device *dev,
+				   struct device_attribute *attr,
+				   const char *buf, size_t count)
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
+
+static struct device_attribute wq_sysfs_attrs[] = {
+	__ATTR(per_cpu, 0444, wq_per_cpu_show, NULL),
+	__ATTR(max_active, 0644, wq_max_active_show, wq_max_active_store),
+	__ATTR_NULL,
+};
+
+static ssize_t wq_pool_id_show(struct device *dev,
+			       struct device_attribute *attr, char *buf)
+{
+	struct workqueue_struct *wq = dev_to_wq(dev);
+	struct worker_pool *pool;
+	int written;
+
+	rcu_read_lock_sched();
+	pool = first_pwq(wq)->pool;
+	written = scnprintf(buf, PAGE_SIZE, "%d\n", pool->id);
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
+	rcu_read_lock_sched();
+	written = scnprintf(buf, PAGE_SIZE, "%d\n",
+			    first_pwq(wq)->pool->attrs->nice);
+	rcu_read_unlock_sched();
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
+	rcu_read_lock_sched();
+	copy_workqueue_attrs(attrs, first_pwq(wq)->pool->attrs);
+	rcu_read_unlock_sched();
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
+	    attrs->nice >= -20 && attrs->nice <= 19)
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
+	rcu_read_lock_sched();
+	written = cpumask_scnprintf(buf, PAGE_SIZE,
+				    first_pwq(wq)->pool->attrs->cpumask);
+	rcu_read_unlock_sched();
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
+static struct device_attribute wq_sysfs_unbound_attrs[] = {
+	__ATTR(pool_id, 0444, wq_pool_id_show, NULL),
+	__ATTR(nice, 0644, wq_nice_show, wq_nice_store),
+	__ATTR(cpumask, 0644, wq_cpumask_show, wq_cpumask_store),
+	__ATTR_NULL,
+};
+
+static struct bus_type wq_subsys = {
+	.name				= "workqueue",
+	.dev_attrs			= wq_sysfs_attrs,
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
+ * Returns 0 on success, -errno on failure.
+ */
+int workqueue_sysfs_register(struct workqueue_struct *wq)
+{
+	struct wq_device *wq_dev;
+	int ret;
+
+	/*
+	 * Adjusting max_active or creating new pwqs by applyting
+	 * attributes breaks ordering guarantee.  Disallow exposing ordered
+	 * workqueues.
+	 */
+	if (WARN_ON(wq->flags & __WQ_ORDERED))
+		return -EINVAL;
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
 /**
  * free_workqueue_attrs - free a workqueue_attrs
  * @attrs: workqueue_attrs to free
@@ -3618,6 +3901,9 @@ struct workqueue_struct *__alloc_workque
 		wake_up_process(rescuer->task);
 	}
 
+	if ((wq->flags & WQ_SYSFS) && workqueue_sysfs_register(wq))
+		goto err_destroy;
+
 	/*
 	 * workqueue_lock protects global freeze state and workqueues
 	 * list.  Grab it, set max_active accordingly and add the new
@@ -3686,6 +3972,8 @@ void destroy_workqueue(struct workqueue_
 
 	spin_unlock_irq(&workqueue_lock);
 
+	workqueue_sysfs_unregister(wq);
+
 	if (wq->rescuer) {
 		kthread_stop(wq->rescuer->task);
 		kfree(wq->rescuer);
