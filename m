Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753158AbaJVN6v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 09:58:51 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:58664 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752943AbaJVN6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 09:58:16 -0400
From: Daniel Lezcano <daniel.lezcano@linaro.org>
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: axboe@kernel.dk, rafael.j.wysocki@intel.com, mingo@kernel.org,
        peterz@infradead.org, preeti@linux.vnet.ibm.com,
        Morten.Rasmussen@arm.com, mturquette@linaro.org,
        tuukka.tikkanen@linaro.org, nicolas.pitre@linaro.org,
        patches@linaro.org
Subject: [RFD PATCH 09/10] cpuidle: sysfs: Add per cpu idle state prediction statistics
Date: Wed, 22 Oct 2014 15:57:52 +0200
Message-Id: <1413986273-28522-10-git-send-email-daniel.lezcano@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413986273-28522-1-git-send-email-daniel.lezcano@linaro.org>
References: <1413986273-28522-1-git-send-email-daniel.lezcano@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
---
 drivers/cpuidle/cpuidle.c |   8 +++
 drivers/cpuidle/sysfs.c   | 156 ++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/cpuidle.h   |   7 ++-
 3 files changed, 170 insertions(+), 1 deletion(-)

diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
index bf42e17..66231a40 100644
--- a/drivers/cpuidle/cpuidle.c
+++ b/drivers/cpuidle/cpuidle.c
@@ -139,6 +139,14 @@ int cpuidle_enter_state(struct cpuidle_device *dev, struct cpuidle_driver *drv,
 		 */
 		dev->states_usage[entered_state].time += dev->last_residency;
 		dev->states_usage[entered_state].usage++;
+		if (diff < dev->last_residency)
+			atomic_inc(&dev->over_estimate);
+		else if (entered_state < (drv->state_count - 1) &&
+			 dev->last_residency <
+			 drv->states[entered_state + 1].target_residency)
+			atomic_inc(&dev->under_estimate);
+		else
+			atomic_inc(&dev->right_estimate);
 	} else {
 		dev->last_residency = 0;
 	}
diff --git a/drivers/cpuidle/sysfs.c b/drivers/cpuidle/sysfs.c
index 97c5903..f446bd0 100644
--- a/drivers/cpuidle/sysfs.c
+++ b/drivers/cpuidle/sysfs.c
@@ -439,6 +439,154 @@ static void cpuidle_remove_state_sysfs(struct cpuidle_device *device)
 		cpuidle_free_state_kobj(device, i);
 }
 
+#define kobj_to_stats_kobj(k) container_of(k, struct cpuidle_stats_kobj, kobj)
+#define attr_to_stats_attr(a) container_of(a, struct cpuidle_stats_attr, attr)
+
+#define define_show_stats_function(_name)				\
+	static ssize_t show_stats_##_name(struct cpuidle_device *dev,	\
+					  char *buf)			\
+	{								\
+		return sprintf(buf, "%d\n", atomic_read(&dev->_name));	\
+	}
+
+#define define_store_stats_function(_name)				\
+	static ssize_t store_stats_##_name(struct cpuidle_device *dev,	\
+					   const char *buf, size_t size) \
+	{								\
+		unsigned long long value;				\
+		int err;						\
+		if (!capable(CAP_SYS_ADMIN))				\
+			return -EPERM;					\
+		err = kstrtoull(buf, 0, &value);			\
+		if (err)						\
+			return err;					\
+									\
+		atomic_set(&dev->_name, value);				\
+		return size;						\
+	}
+
+#define define_one_stats_rw(_name, show, store)		       \
+	static struct cpuidle_stats_attr attr_stats_##_name = \
+		__ATTR(_name, 0644, show, store)
+
+struct cpuidle_stats_kobj {
+	struct cpuidle_device *dev;
+	struct completion kobj_unregister;
+	struct kobject kobj;
+};
+
+struct cpuidle_stats_attr {
+	struct attribute attr;
+	ssize_t (*show)(struct cpuidle_device *, char *);
+	ssize_t (*store)(struct cpuidle_device *, const char *, size_t);
+};
+
+static void cpuidle_stats_sysfs_release(struct kobject *kobj)
+{
+	struct cpuidle_stats_kobj *stats_kobj = kobj_to_stats_kobj(kobj);
+	complete(&stats_kobj->kobj_unregister);
+}
+
+static ssize_t cpuidle_stats_show(struct kobject *kobj, struct attribute *attr,
+				  char *buf)
+{
+	int ret = -EIO;
+	struct cpuidle_stats_kobj *stats_kobj = kobj_to_stats_kobj(kobj);
+	struct cpuidle_stats_attr *dattr = attr_to_stats_attr(attr);
+
+	if (dattr->show)
+		ret = dattr->show(stats_kobj->dev, buf);
+
+	return ret;
+}
+
+static ssize_t cpuidle_stats_store(struct kobject *kobj,
+				   struct attribute *attr,
+				   const char *buf, size_t size)
+{
+	int ret = -EIO;
+	struct cpuidle_stats_kobj *stats_kobj = kobj_to_stats_kobj(kobj);
+	struct cpuidle_stats_attr *dattr = attr_to_stats_attr(attr);
+
+	if (dattr->store)
+		ret = dattr->store(stats_kobj->dev, buf, size);
+
+	return ret;
+}
+
+define_show_stats_function(right_estimate);
+define_store_stats_function(right_estimate);
+
+define_show_stats_function(under_estimate);
+define_store_stats_function(under_estimate);
+
+define_show_stats_function(over_estimate);
+define_store_stats_function(over_estimate);
+
+define_one_stats_rw(right_estimate,
+		    show_stats_right_estimate,
+		    store_stats_right_estimate);
+
+define_one_stats_rw(under_estimate,
+		    show_stats_under_estimate,
+		    store_stats_under_estimate);
+
+define_one_stats_rw(over_estimate,
+		    show_stats_over_estimate,
+		    store_stats_over_estimate);
+
+static const struct sysfs_ops cpuidle_stats_sysfs_ops = {
+	.show = cpuidle_stats_show,
+	.store = cpuidle_stats_store,
+};
+
+static struct attribute *cpuidle_stats_default_attrs[] = {
+	&attr_stats_right_estimate.attr,
+	&attr_stats_under_estimate.attr,
+	&attr_stats_over_estimate.attr,
+	NULL
+};
+
+static struct kobj_type ktype_stats_cpuidle = {
+	.sysfs_ops = &cpuidle_stats_sysfs_ops,
+	.default_attrs = cpuidle_stats_default_attrs,
+	.release = cpuidle_stats_sysfs_release,
+};
+
+static int cpuidle_add_stats_sysfs(struct cpuidle_device *dev)
+{
+	struct cpuidle_stats_kobj *kstats;
+	struct cpuidle_device_kobj *kdev = dev->kobj_dev;
+	int ret;
+
+	kstats = kzalloc(sizeof(*kstats), GFP_KERNEL);
+	if (!kstats)
+		return -ENOMEM;
+
+	kstats->dev = dev;
+	init_completion(&kstats->kobj_unregister);
+
+	ret = kobject_init_and_add(&kstats->kobj, &ktype_stats_cpuidle,
+				   &kdev->kobj, "stats");
+	if (ret) {
+		kfree(kstats);
+		return ret;
+	}
+
+	kobject_uevent(&kstats->kobj, KOBJ_ADD);
+	dev->kobj_stats = kstats;
+
+	return ret;
+}
+
+static void cpuidle_remove_stats_sysfs(struct cpuidle_device *dev)
+{
+	struct cpuidle_stats_kobj *kstats = dev->kobj_stats;
+	kobject_put(&kstats->kobj);
+	wait_for_completion(&kstats->kobj_unregister);
+	kfree(kstats);
+}
+
 #ifdef CONFIG_CPU_IDLE_MULTIPLE_DRIVERS
 #define kobj_to_driver_kobj(k) container_of(k, struct cpuidle_driver_kobj, kobj)
 #define attr_to_driver_attr(a) container_of(a, struct cpuidle_driver_attr, attr)
@@ -589,6 +737,13 @@ int cpuidle_add_device_sysfs(struct cpuidle_device *device)
 	ret = cpuidle_add_driver_sysfs(device);
 	if (ret)
 		cpuidle_remove_state_sysfs(device);
+
+	ret = cpuidle_add_stats_sysfs(device);
+	if (ret) {
+		cpuidle_remove_driver_sysfs(device);
+		cpuidle_remove_state_sysfs(device);
+	}
+
 	return ret;
 }
 
@@ -598,6 +753,7 @@ int cpuidle_add_device_sysfs(struct cpuidle_device *device)
  */
 void cpuidle_remove_device_sysfs(struct cpuidle_device *device)
 {
+	cpuidle_remove_stats_sysfs(device);
 	cpuidle_remove_driver_sysfs(device);
 	cpuidle_remove_state_sysfs(device);
 }
diff --git a/include/linux/cpuidle.h b/include/linux/cpuidle.h
index e99823f..c3b9bdd 100644
--- a/include/linux/cpuidle.h
+++ b/include/linux/cpuidle.h
@@ -44,7 +44,6 @@ struct cpuidle_state {
 	int		power_usage; /* in mW */
 	unsigned int	target_residency; /* in US */
 	bool		disabled; /* disabled on all CPUs */
-
 	int (*enter)	(struct cpuidle_device *dev,
 			struct cpuidle_driver *drv,
 			int index);
@@ -62,6 +61,7 @@ struct cpuidle_state {
 struct cpuidle_device_kobj;
 struct cpuidle_state_kobj;
 struct cpuidle_driver_kobj;
+struct cpuidle_stats_kobj;
 
 struct cpuidle_device {
 	unsigned int		registered:1;
@@ -74,8 +74,13 @@ struct cpuidle_device {
 	struct cpuidle_state_kobj *kobjs[CPUIDLE_STATE_MAX];
 	struct cpuidle_driver_kobj *kobj_driver;
 	struct cpuidle_device_kobj *kobj_dev;
+	struct cpuidle_stats_kobj  *kobj_stats;
 	struct list_head 	device_list;
 
+	atomic_t right_estimate;
+	atomic_t under_estimate;
+	atomic_t over_estimate;
+
 #ifdef CONFIG_ARCH_NEEDS_CPU_IDLE_COUPLED
 	int			safe_state_index;
 	cpumask_t		coupled_cpus;
-- 
1.9.1

