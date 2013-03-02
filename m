Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752218Ab3CBCFR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 21:05:17 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:49355 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751298Ab3CBCFQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 21:05:16 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] PM / QoS: Remove device PM QoS sysfs attributes at the right place
Date: Sat, 02 Mar 2013 03:11:54 +0100
Message-ID: <1544982.lMMvPjF71N@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0; KDE/4.9.5; x86_64; ; )
In-Reply-To: <2252670.qpofTRSm2a@vostro.rjw.lan>
References: <2252670.qpofTRSm2a@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Device PM QoS sysfs attributes, if present during device removal,
are removed from within device_pm_remove(), which is too late,
since dpm_sysfs_remove() has already removed the whole attribute
group they belonged to.  However, moving the removal of those
attributes to dpm_sysfs_remove() alone is not sufficient, because
in theory they still can be re-added right after being removed by it
(the device's driver is still bound to it at that point).

For this reason, move the entire desctruction of device PM QoS
constraints to dpm_sysfs_remove() and make it prevent any new
constraints from being added after it has run.  Analogously, move
the initialization of device PM QoS constraints to dpm_sysfs_add().

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/base/power/main.c  |    2 
 drivers/base/power/power.h |    6 --
 drivers/base/power/qos.c   |  104 +++++++++++++++++++++------------------------
 drivers/base/power/sysfs.c |    3 +
 4 files changed, 53 insertions(+), 62 deletions(-)

Index: linux-pm/drivers/base/power/main.c
===================================================================
--- linux-pm.orig/drivers/base/power/main.c
+++ linux-pm/drivers/base/power/main.c
@@ -99,7 +99,6 @@ void device_pm_add(struct device *dev)
 		dev_warn(dev, "parent %s should not be sleeping\n",
 			dev_name(dev->parent));
 	list_add_tail(&dev->power.entry, &dpm_list);
-	dev_pm_qos_constraints_init(dev);
 	mutex_unlock(&dpm_list_mtx);
 }
 
@@ -113,7 +112,6 @@ void device_pm_remove(struct device *dev
 		 dev->bus ? dev->bus->name : "No Bus", dev_name(dev));
 	complete_all(&dev->power.completion);
 	mutex_lock(&dpm_list_mtx);
-	dev_pm_qos_constraints_destroy(dev);
 	list_del_init(&dev->power.entry);
 	mutex_unlock(&dpm_list_mtx);
 	device_wakeup_disable(dev);
Index: linux-pm/drivers/base/power/qos.c
===================================================================
--- linux-pm.orig/drivers/base/power/qos.c
+++ linux-pm/drivers/base/power/qos.c
@@ -61,7 +61,7 @@ enum pm_qos_flags_status __dev_pm_qos_fl
 	struct pm_qos_flags *pqf;
 	s32 val;
 
-	if (!qos)
+	if (IS_ERR_OR_NULL(qos))
 		return PM_QOS_FLAGS_UNDEFINED;
 
 	pqf = &qos->flags;
@@ -101,7 +101,8 @@ EXPORT_SYMBOL_GPL(dev_pm_qos_flags);
  */
 s32 __dev_pm_qos_read_value(struct device *dev)
 {
-	return dev->power.qos ? pm_qos_read_value(&dev->power.qos->latency) : 0;
+	return IS_ERR_OR_NULL(dev->power.qos) ?
+		0 : pm_qos_read_value(&dev->power.qos->latency);
 }
 
 /**
@@ -209,10 +210,12 @@ void dev_pm_qos_constraints_init(struct
 {
 	mutex_lock(&dev_pm_qos_mtx);
 	dev->power.qos = NULL;
-	dev->power.power_state = PMSG_ON;
 	mutex_unlock(&dev_pm_qos_mtx);
 }
 
+static void __dev_pm_qos_hide_latency_limit(struct device *dev);
+static void __dev_pm_qos_hide_flags(struct device *dev);
+
 /**
  * dev_pm_qos_constraints_destroy
  * @dev: target device
@@ -226,16 +229,15 @@ void dev_pm_qos_constraints_destroy(stru
 	struct pm_qos_constraints *c;
 	struct pm_qos_flags *f;
 
+	mutex_lock(&dev_pm_qos_mtx);
+
 	/*
 	 * If the device's PM QoS resume latency limit or PM QoS flags have been
 	 * exposed to user space, they have to be hidden at this point.
 	 */
-	dev_pm_qos_hide_latency_limit(dev);
-	dev_pm_qos_hide_flags(dev);
-
-	mutex_lock(&dev_pm_qos_mtx);
+	__dev_pm_qos_hide_latency_limit(dev);
+	__dev_pm_qos_hide_flags(dev);
 
-	dev->power.power_state = PMSG_INVALID;
 	qos = dev->power.qos;
 	if (!qos)
 		goto out;
@@ -257,7 +259,7 @@ void dev_pm_qos_constraints_destroy(stru
 	}
 
 	spin_lock_irq(&dev->power.lock);
-	dev->power.qos = NULL;
+	dev->power.qos = ERR_PTR(-ENODEV);
 	spin_unlock_irq(&dev->power.lock);
 
 	kfree(c->notifiers);
@@ -301,32 +303,19 @@ int dev_pm_qos_add_request(struct device
 		 "%s() called for already added request\n", __func__))
 		return -EINVAL;
 
-	req->dev = dev;
-
 	mutex_lock(&dev_pm_qos_mtx);
 
-	if (!dev->power.qos) {
-		if (dev->power.power_state.event == PM_EVENT_INVALID) {
-			/* The device has been removed from the system. */
-			req->dev = NULL;
-			ret = -ENODEV;
-			goto out;
-		} else {
-			/*
-			 * Allocate the constraints data on the first call to
-			 * add_request, i.e. only if the data is not already
-			 * allocated and if the device has not been removed.
-			 */
-			ret = dev_pm_qos_constraints_allocate(dev);
-		}
-	}
+	if (IS_ERR(dev->power.qos))
+		ret = -ENODEV;
+	else if (!dev->power.qos)
+		ret = dev_pm_qos_constraints_allocate(dev);
 
 	if (!ret) {
+		req->dev = dev;
 		req->type = type;
 		ret = apply_constraint(req, PM_QOS_ADD_REQ, value);
 	}
 
- out:
 	mutex_unlock(&dev_pm_qos_mtx);
 
 	return ret;
@@ -351,7 +340,7 @@ static int __dev_pm_qos_update_request(s
 		 "%s() called for unknown object\n", __func__))
 		return -EINVAL;
 
-	if (!req->dev->power.qos)
+	if (IS_ERR_OR_NULL(req->dev->power.qos))
 		return -ENODEV;
 
 	switch(req->type) {
@@ -402,7 +391,7 @@ EXPORT_SYMBOL_GPL(dev_pm_qos_update_requ
 
 static int __dev_pm_qos_remove_request(struct dev_pm_qos_request *req)
 {
-	int ret = 0;
+	int ret;
 
 	if (!req) /*guard against callers passing in null */
 		return -EINVAL;
@@ -411,13 +400,11 @@ static int __dev_pm_qos_remove_request(s
 		 "%s() called for unknown object\n", __func__))
 		return -EINVAL;
 
-	if (req->dev->power.qos) {
-		ret = apply_constraint(req, PM_QOS_REMOVE_REQ,
-				       PM_QOS_DEFAULT_VALUE);
-		memset(req, 0, sizeof(*req));
-	} else {
-		ret = -ENODEV;
-	}
+	if (IS_ERR_OR_NULL(req->dev->power.qos))
+		return -ENODEV;
+
+	ret = apply_constraint(req, PM_QOS_REMOVE_REQ, PM_QOS_DEFAULT_VALUE);
+	memset(req, 0, sizeof(*req));
 	return ret;
 }
 
@@ -466,9 +453,10 @@ int dev_pm_qos_add_notifier(struct devic
 
 	mutex_lock(&dev_pm_qos_mtx);
 
-	if (!dev->power.qos)
-		ret = dev->power.power_state.event != PM_EVENT_INVALID ?
-			dev_pm_qos_constraints_allocate(dev) : -ENODEV;
+	if (IS_ERR(dev->power.qos))
+		ret = -ENODEV;
+	else if (!dev->power.qos)
+		ret = dev_pm_qos_constraints_allocate(dev);
 
 	if (!ret)
 		ret = blocking_notifier_chain_register(
@@ -497,7 +485,7 @@ int dev_pm_qos_remove_notifier(struct de
 	mutex_lock(&dev_pm_qos_mtx);
 
 	/* Silently return if the constraints object is not present. */
-	if (dev->power.qos)
+	if (!IS_ERR_OR_NULL(dev->power.qos))
 		retval = blocking_notifier_chain_unregister(
 				dev->power.qos->latency.notifiers,
 				notifier);
@@ -608,7 +596,7 @@ int dev_pm_qos_expose_latency_limit(stru
 
 	mutex_lock(&dev_pm_qos_mtx);
 
-	if (!dev->power.qos)
+	if (IS_ERR_OR_NULL(dev->power.qos))
 		ret = -ENODEV;
 	else if (dev->power.qos->latency_req)
 		ret = -EEXIST;
@@ -630,6 +618,14 @@ int dev_pm_qos_expose_latency_limit(stru
 }
 EXPORT_SYMBOL_GPL(dev_pm_qos_expose_latency_limit);
 
+static void __dev_pm_qos_hide_latency_limit(struct device *dev)
+{
+	if (!IS_ERR_OR_NULL(dev->power.qos) && dev->power.qos->latency_req) {
+		pm_qos_sysfs_remove_latency(dev);
+		__dev_pm_qos_drop_user_request(dev, DEV_PM_QOS_LATENCY);
+	}
+}
+
 /**
  * dev_pm_qos_hide_latency_limit - Hide PM QoS latency limit from user space.
  * @dev: Device whose PM QoS latency limit is to be hidden from user space.
@@ -637,12 +633,7 @@ EXPORT_SYMBOL_GPL(dev_pm_qos_expose_late
 void dev_pm_qos_hide_latency_limit(struct device *dev)
 {
 	mutex_lock(&dev_pm_qos_mtx);
-
-	if (dev->power.qos && dev->power.qos->latency_req) {
-		pm_qos_sysfs_remove_latency(dev);
-		__dev_pm_qos_drop_user_request(dev, DEV_PM_QOS_LATENCY);
-	}
-
+	__dev_pm_qos_hide_latency_limit(dev);
 	mutex_unlock(&dev_pm_qos_mtx);
 }
 EXPORT_SYMBOL_GPL(dev_pm_qos_hide_latency_limit);
@@ -673,7 +664,7 @@ int dev_pm_qos_expose_flags(struct devic
 	pm_runtime_get_sync(dev);
 	mutex_lock(&dev_pm_qos_mtx);
 
-	if (!dev->power.qos)
+	if (IS_ERR_OR_NULL(dev->power.qos))
 		ret = -ENODEV;
 	else if (dev->power.qos->flags_req)
 		ret = -EEXIST;
@@ -696,6 +687,14 @@ int dev_pm_qos_expose_flags(struct devic
 }
 EXPORT_SYMBOL_GPL(dev_pm_qos_expose_flags);
 
+static void __dev_pm_qos_hide_flags(struct device *dev)
+{
+	if (!IS_ERR_OR_NULL(dev->power.qos) && dev->power.qos->flags_req) {
+		pm_qos_sysfs_remove_flags(dev);
+		__dev_pm_qos_drop_user_request(dev, DEV_PM_QOS_FLAGS);
+	}
+}
+
 /**
  * dev_pm_qos_hide_flags - Hide PM QoS flags of a device from user space.
  * @dev: Device whose PM QoS flags are to be hidden from user space.
@@ -704,12 +703,7 @@ void dev_pm_qos_hide_flags(struct device
 {
 	pm_runtime_get_sync(dev);
 	mutex_lock(&dev_pm_qos_mtx);
-
-	if (dev->power.qos && dev->power.qos->flags_req) {
-		pm_qos_sysfs_remove_flags(dev);
-		__dev_pm_qos_drop_user_request(dev, DEV_PM_QOS_FLAGS);
-	}
-
+	__dev_pm_qos_hide_flags(dev);
 	mutex_unlock(&dev_pm_qos_mtx);
 	pm_runtime_put(dev);
 }
@@ -729,7 +723,7 @@ int dev_pm_qos_update_flags(struct devic
 	pm_runtime_get_sync(dev);
 	mutex_lock(&dev_pm_qos_mtx);
 
-	if (!dev->power.qos || !dev->power.qos->flags_req) {
+	if (IS_ERR_OR_NULL(dev->power.qos) || !dev->power.qos->flags_req) {
 		ret = -EINVAL;
 		goto out;
 	}
Index: linux-pm/drivers/base/power/power.h
===================================================================
--- linux-pm.orig/drivers/base/power/power.h
+++ linux-pm/drivers/base/power/power.h
@@ -56,14 +56,10 @@ extern void device_pm_move_last(struct d
 
 static inline void device_pm_sleep_init(struct device *dev) {}
 
-static inline void device_pm_add(struct device *dev)
-{
-	dev_pm_qos_constraints_init(dev);
-}
+static inline void device_pm_add(struct device *dev) {}
 
 static inline void device_pm_remove(struct device *dev)
 {
-	dev_pm_qos_constraints_destroy(dev);
 	pm_runtime_remove(dev);
 }
 
Index: linux-pm/drivers/base/power/sysfs.c
===================================================================
--- linux-pm.orig/drivers/base/power/sysfs.c
+++ linux-pm/drivers/base/power/sysfs.c
@@ -664,6 +664,8 @@ int dpm_sysfs_add(struct device *dev)
 			goto err_out;
 		}
 	}
+
+	dev_pm_qos_constraints_init(dev);
 	return 0;
 
  err_out:
@@ -708,6 +710,7 @@ void rpm_sysfs_remove(struct device *dev
 
 void dpm_sysfs_remove(struct device *dev)
 {
+	dev_pm_qos_constraints_destroy(dev);
 	rpm_sysfs_remove(dev);
 	sysfs_unmerge_group(&dev->kobj, &pm_wakeup_attr_group);
 	sysfs_remove_group(&dev->kobj, &pm_attr_group);

