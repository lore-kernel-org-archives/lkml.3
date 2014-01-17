Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbaAQOjY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 09:39:24 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:54848 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752147AbaAQOiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 09:38:00 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linux PM list <linux-pm@vger.kernel.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [RFC/RFT][PATCH 3/5] PM / QoS: Introduce latency tolerance device PM QoS type
Date: Fri, 17 Jan 2014 15:45:38 +0100
Message-ID: <1808417.86iU26no1B@vostro.rjw.lan>
User-Agent: KMail/4.11.3 (Linux/3.13.0-rc8+; KDE/4.11.3; x86_64; ; )
In-Reply-To: <5434847.aCyiWHNRe7@vostro.rjw.lan>
References: <5434847.aCyiWHNRe7@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Add a new latency tolerance device PM QoS type to be use for
specifying active state (RPM_ACTIVE) memory access (DMA) latency
tolerance requirements for devices.  It may be used to prevent
hardware from choosing overly aggressive energy-saving operation
modes (causing too much latency to appear) for the whole platform.

This feature reqiures hardware support, so it only will be
available for devices having a new .set_latency_tolerance()
callback in struct dev_pm_info populated, in which case the
routine pointed to by it should implement whatever is necessary
to transfer the effective requirement value to the hardware.

Whenever the effective latency tolerance changes for the device,
its .set_latency_tolerance() callback will be executed and the
effective value will be passed to it.  If that value is negative,
which means that the list of latency tolerance requirements for
the device is empty, the callback is expected to switch the
underlying hardware latency tolerance control mechanism to an
autonomous mode if available.  If that value is 0, in turn, and
the hardware supports a special "no requirement" setting, the
callback is expected to use it.  That allows software to prevent
the hardware from automatically updating the device's latency
tolerance in response to its power state changes (e.g. during
transitions from D3cold to D0), which generally may be done in
the autonomous latency tolerance control mode.

If .set_latency_tolerance() is present for the device, a new
pm_qos_latency_tolerance_us attribute will be present in the
devivce's power directory in sysfs.  Then, user space can use
that attribute to specify its latency tolerance requirement for
the device, if any.  Writing 0 to it means "no requirement, but
do not let the hardware control latency tolerance" and using a
negative value allows the hardware to be switched to the autonomous
mode if there are no other requirements from the kernel side in the
device's list.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 Documentation/ABI/testing/sysfs-devices-power |   25 ++++++
 Documentation/power/pm_qos_interface.txt      |   61 +++++++++++++---
 drivers/base/power/qos.c                      |   95 +++++++++++++++++++++++++-
 drivers/base/power/sysfs.c                    |   56 +++++++++++++--
 include/linux/pm.h                            |    1 
 include/linux/pm_qos.h                        |   11 +++
 kernel/power/qos.c                            |   13 ++-
 7 files changed, 238 insertions(+), 24 deletions(-)

Index: linux-pm/include/linux/pm_qos.h
===================================================================
--- linux-pm.orig/include/linux/pm_qos.h
+++ linux-pm/include/linux/pm_qos.h
@@ -33,6 +33,8 @@ enum pm_qos_flags_status {
 #define PM_QOS_NETWORK_LAT_DEFAULT_VALUE	(2000 * USEC_PER_SEC)
 #define PM_QOS_NETWORK_THROUGHPUT_DEFAULT_VALUE	0
 #define PM_QOS_RESUME_LATENCY_DEFAULT_VALUE	0
+#define PM_QOS_LATENCY_TOLERANCE_DEFAULT_VALUE	0
+#define PM_QOS_LATENCY_TOLERANCE_NO_CONSTRAINT	(-1)
 
 #define PM_QOS_FLAG_NO_POWER_OFF	(1 << 0)
 #define PM_QOS_FLAG_REMOTE_WAKEUP	(1 << 1)
@@ -50,6 +52,7 @@ struct pm_qos_flags_request {
 
 enum dev_pm_qos_req_type {
 	DEV_PM_QOS_RESUME_LATENCY = 1,
+	DEV_PM_QOS_LATENCY_TOLERANCE,
 	DEV_PM_QOS_FLAGS,
 };
 
@@ -89,8 +92,10 @@ struct pm_qos_flags {
 
 struct dev_pm_qos {
 	struct pm_qos_constraints resume_latency;
+	struct pm_qos_constraints latency_tolerance;
 	struct pm_qos_flags flags;
 	struct dev_pm_qos_request *resume_latency_req;
+	struct dev_pm_qos_request *latency_tolerance_req;
 	struct dev_pm_qos_request *flags_req;
 };
 
@@ -196,6 +201,8 @@ void dev_pm_qos_hide_latency_limit(struc
 int dev_pm_qos_expose_flags(struct device *dev, s32 value);
 void dev_pm_qos_hide_flags(struct device *dev);
 int dev_pm_qos_update_flags(struct device *dev, s32 mask, bool set);
+s32 dev_pm_qos_get_user_latency_tolerance(struct device *dev);
+int dev_pm_qos_update_user_latency_tolerance(struct device *dev, s32 val);
 
 static inline s32 dev_pm_qos_requested_resume_latency(struct device *dev)
 {
@@ -215,6 +222,10 @@ static inline int dev_pm_qos_expose_flag
 static inline void dev_pm_qos_hide_flags(struct device *dev) {}
 static inline int dev_pm_qos_update_flags(struct device *dev, s32 m, bool set)
 			{ return 0; }
+static inline s32 dev_pm_qos_get_user_latency_tolerance(struct device *dev)
+			{ return PM_QOS_LATENCY_TOLERANCE_NO_CONSTRAINT; }
+static inline int dev_pm_qos_update_user_latency_tolerance(struct device *dev, s32 val)
+			{ return 0; }
 
 static inline s32 dev_pm_qos_requested_resume_latency(struct device *dev) { return 0; }
 static inline s32 dev_pm_qos_requested_flags(struct device *dev) { return 0; }
Index: linux-pm/drivers/base/power/qos.c
===================================================================
--- linux-pm.orig/drivers/base/power/qos.c
+++ linux-pm/drivers/base/power/qos.c
@@ -151,6 +151,14 @@ static int apply_constraint(struct dev_p
 						     req);
 		}
 		break;
+	case DEV_PM_QOS_LATENCY_TOLERANCE:
+		ret = pm_qos_update_target(&qos->latency_tolerance,
+					   &req->data.pnode, action, value);
+		if (ret) {
+			value = pm_qos_read_value(&qos->latency_tolerance);
+			req->dev->power.set_latency_tolerance(req->dev, value);
+		}
+		break;
 	case DEV_PM_QOS_FLAGS:
 		ret = pm_qos_update_flags(&qos->flags, &req->data.flr,
 					  action, value);
@@ -194,6 +202,13 @@ static int dev_pm_qos_constraints_alloca
 	c->type = PM_QOS_MIN;
 	c->notifiers = n;
 
+	c = &qos->latency_tolerance;
+	plist_head_init(&c->list);
+	c->target_value = PM_QOS_LATENCY_TOLERANCE_DEFAULT_VALUE;
+	c->default_value = PM_QOS_LATENCY_TOLERANCE_DEFAULT_VALUE;
+	c->no_constraint_value = PM_QOS_LATENCY_TOLERANCE_NO_CONSTRAINT;
+	c->type = PM_QOS_MIN;
+
 	INIT_LIST_HEAD(&qos->flags.list);
 
 	spin_lock_irq(&dev->power.lock);
@@ -247,6 +262,11 @@ void dev_pm_qos_constraints_destroy(stru
 		apply_constraint(req, PM_QOS_REMOVE_REQ, PM_QOS_DEFAULT_VALUE);
 		memset(req, 0, sizeof(*req));
 	}
+	c = &qos->latency_tolerance;
+	plist_for_each_entry_safe(req, tmp, &c->list, data.pnode) {
+		apply_constraint(req, PM_QOS_REMOVE_REQ, PM_QOS_DEFAULT_VALUE);
+		memset(req, 0, sizeof(*req));
+	}
 	f = &qos->flags;
 	list_for_each_entry_safe(req, tmp, &f->list, data.flr.node) {
 		apply_constraint(req, PM_QOS_REMOVE_REQ, PM_QOS_DEFAULT_VALUE);
@@ -266,6 +286,13 @@ void dev_pm_qos_constraints_destroy(stru
 	mutex_unlock(&dev_pm_qos_sysfs_mtx);
 }
 
+static bool dev_pm_qos_invalid_request(struct device *dev,
+				       struct dev_pm_qos_request *req)
+{
+	return !req || (req->type == DEV_PM_QOS_LATENCY_TOLERANCE
+			&& !dev->power.set_latency_tolerance);
+}
+
 /**
  * dev_pm_qos_add_request - inserts new qos request into the list
  * @dev: target device for the constraint
@@ -293,7 +320,7 @@ int dev_pm_qos_add_request(struct device
 {
 	int ret = 0;
 
-	if (!dev || !req) /*guard against callers passing in null */
+	if (!dev || dev_pm_qos_invalid_request(dev, req))
 		return -EINVAL;
 
 	if (WARN(dev_pm_qos_request_active(req),
@@ -343,6 +370,7 @@ static int __dev_pm_qos_update_request(s
 
 	switch(req->type) {
 	case DEV_PM_QOS_RESUME_LATENCY:
+	case DEV_PM_QOS_LATENCY_TOLERANCE:
 		curr_value = req->data.pnode.prio;
 		break;
 	case DEV_PM_QOS_FLAGS:
@@ -563,6 +591,10 @@ static void __dev_pm_qos_drop_user_reque
 		req = dev->power.qos->resume_latency_req;
 		dev->power.qos->resume_latency_req = NULL;
 		break;
+	case DEV_PM_QOS_LATENCY_TOLERANCE:
+		req = dev->power.qos->latency_tolerance_req;
+		dev->power.qos->latency_tolerance_req = NULL;
+		break;
 	case DEV_PM_QOS_FLAGS:
 		req = dev->power.qos->flags_req;
 		dev->power.qos->flags_req = NULL;
@@ -768,6 +800,67 @@ int dev_pm_qos_update_flags(struct devic
 	pm_runtime_put(dev);
 	return ret;
 }
+
+/**
+ * dev_pm_qos_get_user_latency_tolerance - Get user space latency tolerance.
+ * @dev: Device to obtain the user space latency tolerance for.
+ */
+s32 dev_pm_qos_get_user_latency_tolerance(struct device *dev)
+{
+	s32 ret;
+
+	mutex_lock(&dev_pm_qos_mtx);
+	ret = IS_ERR_OR_NULL(dev->power.qos)
+		|| !dev->power.qos->latency_tolerance_req ?
+			PM_QOS_LATENCY_TOLERANCE_NO_CONSTRAINT :
+			dev->power.qos->latency_tolerance_req->data.pnode.prio;
+	mutex_unlock(&dev_pm_qos_mtx);
+	return ret;
+}
+
+/**
+ * dev_pm_qos_update_user_latency_tolerance - Update user space latency tolerance.
+ * @dev: Device to update the user space latency tolerance for.
+ * @val: New user space latency tolerance for @dev (negative values disable).
+ */
+int dev_pm_qos_update_user_latency_tolerance(struct device *dev, s32 val)
+{
+	int ret;
+
+	mutex_lock(&dev_pm_qos_mtx);
+
+	if (IS_ERR_OR_NULL(dev->power.qos)
+	    || !dev->power.qos->latency_tolerance_req) {
+		struct dev_pm_qos_request *req;
+
+		if (val < 0) {
+			ret = -EINVAL;
+			goto out;
+		}
+		req = kzalloc(sizeof(*req), GFP_KERNEL);
+		if (!req) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		ret = dev_pm_qos_add_request(dev, req, DEV_PM_QOS_LATENCY_TOLERANCE, val);
+		if (ret < 0) {
+			kfree(req);
+			goto out;
+		}
+		dev->power.qos->latency_tolerance_req = req;
+	} else {
+		if (val < 0) {
+			__dev_pm_qos_drop_user_request(dev, DEV_PM_QOS_LATENCY_TOLERANCE);
+			ret = 0;
+		} else {
+			ret = __dev_pm_qos_update_request(dev->power.qos->latency_tolerance_req, val);
+		}
+	}
+
+ out:
+	mutex_unlock(&dev_pm_qos_mtx);
+	return ret;
+}
 #else /* !CONFIG_PM_RUNTIME */
 static void __dev_pm_qos_hide_latency_limit(struct device *dev) {}
 static void __dev_pm_qos_hide_flags(struct device *dev) {}
Index: linux-pm/drivers/base/power/sysfs.c
===================================================================
--- linux-pm.orig/drivers/base/power/sysfs.c
+++ linux-pm/drivers/base/power/sysfs.c
@@ -246,6 +246,31 @@ static ssize_t pm_qos_resume_latency_sto
 static DEVICE_ATTR(pm_qos_resume_latency_us, 0644,
 		   pm_qos_resume_latency_show, pm_qos_resume_latency_store);
 
+static ssize_t pm_qos_latency_tolerance_show(struct device *dev,
+					     struct device_attribute *attr,
+					     char *buf)
+{
+	s32 value = dev_pm_qos_get_user_latency_tolerance(dev);
+	return value >= 0 ? sprintf(buf, "%d\n", value) : sprintf(buf, "n/a\n");
+}
+
+static ssize_t pm_qos_latency_tolerance_store(struct device *dev,
+					      struct device_attribute *attr,
+					      const char *buf, size_t n)
+{
+	s32 value;
+	int ret;
+
+	if (kstrtos32(buf, 0, &value))
+		return -EINVAL;
+
+	ret = dev_pm_qos_update_user_latency_tolerance(dev, value);
+	return ret < 0 ? ret : n;
+}
+
+static DEVICE_ATTR(pm_qos_latency_tolerance_us, 0644,
+		   pm_qos_latency_tolerance_show, pm_qos_latency_tolerance_store);
+
 static ssize_t pm_qos_no_power_off_show(struct device *dev,
 					struct device_attribute *attr,
 					char *buf)
@@ -631,6 +656,17 @@ static struct attribute_group pm_qos_res
 	.attrs	= pm_qos_resume_latency_attrs,
 };
 
+static struct attribute *pm_qos_latency_tolerance_attrs[] = {
+#ifdef CONFIG_PM_RUNTIME
+	&dev_attr_pm_qos_latency_tolerance_us.attr,
+#endif /* CONFIG_PM_RUNTIME */
+	NULL,
+};
+static struct attribute_group pm_qos_latency_tolerance_attr_group = {
+	.name	= power_group_name,
+	.attrs	= pm_qos_latency_tolerance_attrs,
+};
+
 static struct attribute *pm_qos_flags_attrs[] = {
 #ifdef CONFIG_PM_RUNTIME
 	&dev_attr_pm_qos_no_power_off.attr,
@@ -656,18 +692,23 @@ int dpm_sysfs_add(struct device *dev)
 		if (rc)
 			goto err_out;
 	}
-
 	if (device_can_wakeup(dev)) {
 		rc = sysfs_merge_group(&dev->kobj, &pm_wakeup_attr_group);
-		if (rc) {
-			if (pm_runtime_callbacks_present(dev))
-				sysfs_unmerge_group(&dev->kobj,
-						    &pm_runtime_attr_group);
-			goto err_out;
-		}
+		if (rc)
+			goto err_runtime;
+	}
+	if (dev->power.set_latency_tolerance) {
+		rc = sysfs_merge_group(&dev->kobj,
+				       &pm_qos_latency_tolerance_attr_group);
+		if (rc)
+			goto err_wakeup;
 	}
 	return 0;
 
+ err_wakeup:
+	sysfs_unmerge_group(&dev->kobj, &pm_wakeup_attr_group);
+ err_runtime:
+	sysfs_unmerge_group(&dev->kobj, &pm_runtime_attr_group);
  err_out:
 	sysfs_remove_group(&dev->kobj, &pm_attr_group);
 	return rc;
@@ -710,6 +751,7 @@ void rpm_sysfs_remove(struct device *dev
 
 void dpm_sysfs_remove(struct device *dev)
 {
+	sysfs_unmerge_group(&dev->kobj, &pm_qos_latency_tolerance_attr_group);
 	dev_pm_qos_constraints_destroy(dev);
 	rpm_sysfs_remove(dev);
 	sysfs_unmerge_group(&dev->kobj, &pm_wakeup_attr_group);
Index: linux-pm/include/linux/pm.h
===================================================================
--- linux-pm.orig/include/linux/pm.h
+++ linux-pm/include/linux/pm.h
@@ -583,6 +583,7 @@ struct dev_pm_info {
 	unsigned long		accounting_timestamp;
 #endif
 	struct pm_subsys_data	*subsys_data;  /* Owned by the subsystem. */
+	void (*set_latency_tolerance)(struct device *, s32);
 	struct dev_pm_qos	*qos;
 };
 
Index: linux-pm/kernel/power/qos.c
===================================================================
--- linux-pm.orig/kernel/power/qos.c
+++ linux-pm/kernel/power/qos.c
@@ -173,6 +173,7 @@ int pm_qos_update_target(struct pm_qos_c
 {
 	unsigned long flags;
 	int prev_value, curr_value, new_value;
+	int ret;
 
 	spin_lock_irqsave(&pm_qos_lock, flags);
 	prev_value = pm_qos_get_value(c);
@@ -208,13 +209,15 @@ int pm_qos_update_target(struct pm_qos_c
 
 	trace_pm_qos_update_target(action, prev_value, curr_value);
 	if (prev_value != curr_value) {
-		blocking_notifier_call_chain(c->notifiers,
-					     (unsigned long)curr_value,
-					     NULL);
-		return 1;
+		ret = 1;
+		if (c->notifiers)
+			blocking_notifier_call_chain(c->notifiers,
+						     (unsigned long)curr_value,
+						     NULL);
 	} else {
-		return 0;
+		ret = 0;
 	}
+	return ret;
 }
 
 /**
Index: linux-pm/Documentation/power/pm_qos_interface.txt
===================================================================
--- linux-pm.orig/Documentation/power/pm_qos_interface.txt
+++ linux-pm/Documentation/power/pm_qos_interface.txt
@@ -88,17 +88,19 @@ node.
 
 2. PM QoS per-device latency and flags framework
 
-For each device, there are two lists of PM QoS requests. One is maintained
-along with the aggregated target of resume latency value and the other is for
-PM QoS flags. Values are updated in response to changes of the request list.
-
-Target resume latency value is simply the minimum of the request values held in
-the parameter list elements.  The PM QoS flags aggregate value is a gather
-(bitwise OR) of all list elements' values.  Two device PM QoS flags are defined
-currently: PM_QOS_FLAG_NO_POWER_OFF and PM_QOS_FLAG_REMOTE_WAKEUP.
+For each device, there are three lists of PM QoS requests. Two of them are
+maintained along with the aggregated targets of resume latency and active
+state latency tolerance (in microseconds) and the third one is for PM QoS flags.
+Values are updated in response to changes of the request list.
+
+The target values of resume latency and active state latency tolerance are
+simply the minimum of the request values held in the parameter list elements.
+The PM QoS flags aggregate value is a gather (bitwise OR) of all list elements'
+values.  Two device PM QoS flags are defined currently: PM_QOS_FLAG_NO_POWER_OFF
+and PM_QOS_FLAG_REMOTE_WAKEUP.
 
-Note: the aggregated target value is implemented in such a way that reading the
-aggregated value does not require any locking mechanism.
+Note: The aggregated target values are implemented in such a way that reading
+the aggregated value does not require any locking mechanism.
 
 
 From kernel mode the use of this interface is the following:
@@ -177,3 +179,42 @@ The callback is called when the aggregat
 int dev_pm_qos_remove_global_notifier(notifier):
 Removes the notification callback function from the global notification tree
 of the framework.
+
+
+Active state latency tolerance
+
+This device PM QoS type is used to support systems in which hardware may switch
+to energy-saving operation modes on the fly.  In those systems, if the operation
+mode chosen by the hardware attempts to save energy in an overly aggressive way,
+it may cause excess latencies to be visible to software, causing it to miss
+certain protocol requirements or target frame or sample rates etc.
+
+If there is a latency tolerance control mechanism for a given device available
+to software, the .set_latency_tolerance callback in that device's dev_pm_info
+structure should be populated.  The routine pointed to by it is should implement
+whatever is necessary to transfer the effective requirement value to the
+hardware.
+
+Whenever the effective latency tolerance changes for the device, its
+.set_latency_tolerance() callback will be executed and the effective value will
+be passed to it.  If that value is negative, which means that the list of
+latency tolerance requirements for the device is empty, the callback is expected
+to switch the underlying hardware latency tolerance control mechanism to an
+autonomous mode if available.  If that value is 0, in turn, and the hardware
+supports a special "no requirement" setting, the callback is expected to use it.
+That allows software to prevent the hardware from automatically updating the
+device's latency tolerance in response to its power state changes (e.g. during
+transitions from D3cold to D0), which generally may be done in the autonomous
+latency tolerance control mode.
+
+If .set_latency_tolerance() is present for the device, sysfs attribute
+pm_qos_latency_tolerance_us will be present in the devivce's power directory.
+Then, user space can use that attribute to specify its latency tolerance
+requirement for the device, if any.  Writing 0 to it means "no requirement, but
+do not let the hardware control latency tolerance" and using a negative value
+allows the hardware to be switched to the autonomous mode if there are no other
+requirements from the kernel side in the device's list.
+
+Kernel code can use the functions described above along with the
+DEV_PM_QOS_LATENCY_TOLERANCE device PM QoS type to add, remove and update
+latency tolerance requirements for devices.
Index: linux-pm/Documentation/ABI/testing/sysfs-devices-power
===================================================================
--- linux-pm.orig/Documentation/ABI/testing/sysfs-devices-power
+++ linux-pm/Documentation/ABI/testing/sysfs-devices-power
@@ -187,7 +187,7 @@ Description:
 		Not all drivers support this attribute.  If it isn't supported,
 		attempts to read or write it will yield I/O errors.
 
-What:		/sys/devices/.../power/pm_qos_latency_us
+What:		/sys/devices/.../power/pm_qos_resume_latency_us
 Date:		March 2012
 Contact:	Rafael J. Wysocki <rjw@rjwysocki.net>
 Description:
@@ -205,6 +205,29 @@ Description:
 		This attribute has no effect on system-wide suspend/resume and
 		hibernation.
 
+What:		/sys/devices/.../power/pm_qos_latency_tolerance_us
+Date:		January 2014
+Contact:	Rafael J. Wysocki <rjw@rjwysocki.net>
+Description:
+		The /sys/devices/.../power/pm_qos_latency_tolerance_us attribute
+		contains the PM QoS active state latency tolerance limit for the
+		given device, which is the maximum memory access latency the
+		device can suffer without any visible adverse effects on user
+		space functionality.  If that value is 0, the latency does not
+		matter to user space at all.
+
+		Reading "n/a" from this file means that the maximum memory
+		access latency for the device may be determined automatically
+		by the hardware as needed.  Writing a negative value to it
+		allows the hardware to be switched to this mode if there are no
+		other latency tolerance requirements from the kernel side.
+
+		This attribute is only present if the feature controlled by it
+		is supported by the hardware.
+
+		This attribute has no effect on runtime suspend and resume of
+		devices and on system-wide suspend/resume and hibernation.
+
 What:		/sys/devices/.../power/pm_qos_no_power_off
 Date:		September 2012
 Contact:	Rafael J. Wysocki <rjw@rjwysocki.net>

