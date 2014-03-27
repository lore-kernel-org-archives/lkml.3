Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757011AbaC0RVR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 13:21:17 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:63634 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756987AbaC0RVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 13:21:13 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Christoph Lameter <cl@linux.com>,
        Kevin Hilman <khilman@linaro.org>,
        Mike Galbraith <bitbucket@online.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 3/4] workqueue: Add anon workqueue sysfs hierarchy
Date: Thu, 27 Mar 2014 18:21:01 +0100
Message-Id: <1395940862-31428-4-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1395940862-31428-1-git-send-email-fweisbec@gmail.com>
References: <1395940862-31428-1-git-send-email-fweisbec@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We call "anon workqueues" the set of unbound workqueues that don't
carry the WQ_SYSFS flag.

They are a problem nowadays because people who work on CPU isolation
(HPC, Real time, etc...) want to be able to migrate all the unbound
workqueues away to a single housekeeping CPU. This control is possible
through sysfs but only with WQ_SYSFS workqueues.

Now we need to deal with the other unbound workqueues. There is two
possible solutions:

1) Implement a sysfs directory for each unbound !WQ_SYSFS. This could
be done with a specific Kconfig to make sure that these workqueue
won't be considered as a stable ABI. But we all know that all distros
will enable this Kconfig symbol and that a warning in the Kconfig help
text won't protect against anything.

2) Implement a single sysfs directory containing only the cpumask file
to the control the affinity of all the !WQ_SYSFS workqueues.

This patch implements the second solution but only for non-ordered
unbound workqueues. Ordered workqueues need a special treatment and
will be handled in a subsequent patch.

Cc: Christoph Lameter <cl@linux.com>
Cc: Kevin Hilman <khilman@linaro.org>
Cc: Mike Galbraith <bitbucket@online.de>
Cc: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
---
 kernel/workqueue.c | 119 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 117 insertions(+), 2 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 8749bef..2863c39 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -291,7 +291,8 @@ static bool wq_numa_enabled;		/* unbound NUMA affinity enabled */
 static struct workqueue_attrs *wq_update_unbound_numa_attrs_buf;
 
 static DEFINE_MUTEX(wq_pool_mutex);	/* protects pools and workqueues list */
-static DEFINE_MUTEX(wq_unbound_mutex);	/* protects list of unbound workqueues */
+/* protects list of unbound workqueues and wq_anon_cpumask*/
+static DEFINE_MUTEX(wq_unbound_mutex);
 static DEFINE_SPINLOCK(wq_mayday_lock);	/* protects wq->maydays list */
 
 static LIST_HEAD(workqueues);		/* PL: list of all workqueues */
@@ -3313,13 +3314,127 @@ static struct device_attribute wq_sysfs_unbound_attrs[] = {
 	__ATTR_NULL,
 };
 
+/* Protected by wq_anon_cpumask */
+static cpumask_t wq_anon_cpumask;
+static ssize_t wq_anon_cpumask_show(struct device *dev,
+				    struct device_attribute *attr, char *buf)
+{
+	int written;
+
+	mutex_lock(&wq_unbound_mutex);
+	written = cpumask_scnprintf(buf, PAGE_SIZE, &wq_anon_cpumask);
+	mutex_unlock(&wq_unbound_mutex);
+
+	written += scnprintf(buf + written, PAGE_SIZE - written, "\n");
+
+	return written;
+}
+
+/* Must be called with wq_unbound_mutex held */
+static int wq_anon_cpumask_set(cpumask_var_t cpumask)
+{
+	struct workqueue_attrs *attrs;
+	struct workqueue_struct *wq;
+	int ret;
+
+	list_for_each_entry(wq, &workqueues_unbound, unbound_list) {
+		/* WQ_SYSFS have their own directories */
+		if (wq->flags & WQ_SYSFS)
+			continue;
+		/* Ordered workqueues need specific treatment */
+		if (wq->flags & __WQ_ORDERED)
+			continue;
+
+		attrs = wq_sysfs_prep_attrs(wq);
+		if (!attrs)
+			return -ENOMEM;
+
+		cpumask_copy(attrs->cpumask, cpumask);
+		ret = apply_workqueue_attrs(wq, attrs);
+		free_workqueue_attrs(attrs);
+		if (ret)
+			break;
+	}
+
+	return ret;
+}
+
+static ssize_t wq_anon_cpumask_store(struct device *dev,
+				     struct device_attribute *attr,
+				     const char *buf, size_t count)
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
+		mutex_lock(&wq_unbound_mutex);
+		ret = wq_anon_cpumask_set(cpumask);
+		if (!ret)
+			cpumask_copy(&wq_anon_cpumask, cpumask);
+		mutex_unlock(&wq_unbound_mutex);
+	}
+	put_online_cpus();
+out:
+	free_cpumask_var(cpumask);
+	return ret ? ret : count;
+}
+
+static void device_release(struct device *dev)
+{
+	kfree(dev);
+}
+
+static struct device_attribute wq_sysfs_anon_attr =
+	__ATTR(cpumask, 0644, wq_anon_cpumask_show, wq_anon_cpumask_store);
+
 static struct bus_type wq_subsys = {
 	.name				= "workqueue",
 };
 
 static int __init wq_sysfs_init(void)
 {
-	return subsys_virtual_register(&wq_subsys, NULL);
+	struct device *anon_dev;
+	int ret;
+
+	ret = subsys_virtual_register(&wq_subsys, NULL);
+	if (ret < 0)
+		return ret;
+
+	mutex_lock(&wq_unbound_mutex);
+	cpumask_copy(&wq_anon_cpumask, cpu_possible_mask);
+	mutex_unlock(&wq_unbound_mutex);
+
+	anon_dev = kzalloc(sizeof(*anon_dev), GFP_KERNEL);
+	if (!anon_dev)
+		return -ENOMEM;
+
+	anon_dev->bus = &wq_subsys;
+	anon_dev->init_name = "anon_wqs";
+	anon_dev->release = device_release;
+
+	ret = device_register(anon_dev);
+	if (ret) {
+		kfree(anon_dev);
+		return ret;
+	}
+
+	ret = device_create_file(anon_dev, &wq_sysfs_anon_attr);
+	if (ret) {
+		device_unregister(anon_dev);
+		return ret;
+	}
+
+	kobject_uevent(&anon_dev->kobj, KOBJ_ADD);
+
+	return 0;
 }
 core_initcall(wq_sysfs_init);
 
-- 
1.8.3.1

