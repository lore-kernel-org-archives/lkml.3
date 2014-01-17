Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595AbaAQOit (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 09:38:49 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:58951 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752502AbaAQOiC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 09:38:02 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linux PM list <linux-pm@vger.kernel.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [RFC/RFT][PATCH 1/5] PM / QoS: Rename device resume latency QoS items
Date: Fri, 17 Jan 2014 15:43:17 +0100
Message-ID: <1930473.iPyISJEKtS@vostro.rjw.lan>
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

Rename symbols, variables, functions and structure fields related do
the resume latency device PM QoS type so that it is clear where they
belong (in particular, to avoid confusion with the latency tolerance
device PM QoS type introduced by a subsequent changeset).

Update the PM QoS documentation to better reflect its current state.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 Documentation/power/pm_qos_interface.txt |   37 +++++++++-----------
 Documentation/trace/events-power.txt     |    2 -
 drivers/base/power/power.h               |    4 +-
 drivers/base/power/qos.c                 |   55 +++++++++++++++----------------
 drivers/base/power/sysfs.c               |   32 +++++++++---------
 drivers/mtd/nand/sh_flctl.c              |    2 -
 include/linux/pm_qos.h                   |   14 +++----
 include/trace/events/power.h             |    4 +-
 8 files changed, 73 insertions(+), 77 deletions(-)

Index: linux-pm/Documentation/trace/events-power.txt
===================================================================
--- linux-pm.orig/Documentation/trace/events-power.txt
+++ linux-pm/Documentation/trace/events-power.txt
@@ -92,5 +92,5 @@ dev_pm_qos_remove_request          "devi
 
 The first parameter gives the device name which tries to add/update/remove
 QoS requests.
-The second parameter gives the request type (e.g. "DEV_PM_QOS_LATENCY").
+The second parameter gives the request type (e.g. "DEV_PM_QOS_RESUME_LATENCY").
 The third parameter is value to be added/updated/removed.
Index: linux-pm/drivers/base/power/qos.c
===================================================================
--- linux-pm.orig/drivers/base/power/qos.c
+++ linux-pm/drivers/base/power/qos.c
@@ -105,7 +105,7 @@ EXPORT_SYMBOL_GPL(dev_pm_qos_flags);
 s32 __dev_pm_qos_read_value(struct device *dev)
 {
 	return IS_ERR_OR_NULL(dev->power.qos) ?
-		0 : pm_qos_read_value(&dev->power.qos->latency);
+		0 : pm_qos_read_value(&dev->power.qos->resume_latency);
 }
 
 /**
@@ -141,11 +141,11 @@ static int apply_constraint(struct dev_p
 	int ret;
 
 	switch(req->type) {
-	case DEV_PM_QOS_LATENCY:
-		ret = pm_qos_update_target(&qos->latency, &req->data.pnode,
-					   action, value);
+	case DEV_PM_QOS_RESUME_LATENCY:
+		ret = pm_qos_update_target(&qos->resume_latency,
+					   &req->data.pnode, action, value);
 		if (ret) {
-			value = pm_qos_read_value(&qos->latency);
+			value = pm_qos_read_value(&qos->resume_latency);
 			blocking_notifier_call_chain(&dev_pm_notifiers,
 						     (unsigned long)value,
 						     req);
@@ -186,10 +186,10 @@ static int dev_pm_qos_constraints_alloca
 	}
 	BLOCKING_INIT_NOTIFIER_HEAD(n);
 
-	c = &qos->latency;
+	c = &qos->resume_latency;
 	plist_head_init(&c->list);
-	c->target_value = PM_QOS_DEV_LAT_DEFAULT_VALUE;
-	c->default_value = PM_QOS_DEV_LAT_DEFAULT_VALUE;
+	c->target_value = PM_QOS_RESUME_LATENCY_DEFAULT_VALUE;
+	c->default_value = PM_QOS_RESUME_LATENCY_DEFAULT_VALUE;
 	c->type = PM_QOS_MIN;
 	c->notifiers = n;
 
@@ -224,7 +224,7 @@ void dev_pm_qos_constraints_destroy(stru
 	 * If the device's PM QoS resume latency limit or PM QoS flags have been
 	 * exposed to user space, they have to be hidden at this point.
 	 */
-	pm_qos_sysfs_remove_latency(dev);
+	pm_qos_sysfs_remove_resume_latency(dev);
 	pm_qos_sysfs_remove_flags(dev);
 
 	mutex_lock(&dev_pm_qos_mtx);
@@ -237,7 +237,7 @@ void dev_pm_qos_constraints_destroy(stru
 		goto out;
 
 	/* Flush the constraints lists for the device. */
-	c = &qos->latency;
+	c = &qos->resume_latency;
 	plist_for_each_entry_safe(req, tmp, &c->list, data.pnode) {
 		/*
 		 * Update constraints list and call the notification
@@ -341,7 +341,7 @@ static int __dev_pm_qos_update_request(s
 		return -ENODEV;
 
 	switch(req->type) {
-	case DEV_PM_QOS_LATENCY:
+	case DEV_PM_QOS_RESUME_LATENCY:
 		curr_value = req->data.pnode.prio;
 		break;
 	case DEV_PM_QOS_FLAGS:
@@ -460,8 +460,8 @@ int dev_pm_qos_add_notifier(struct devic
 		ret = dev_pm_qos_constraints_allocate(dev);
 
 	if (!ret)
-		ret = blocking_notifier_chain_register(
-				dev->power.qos->latency.notifiers, notifier);
+		ret = blocking_notifier_chain_register(dev->power.qos->resume_latency.notifiers,
+						       notifier);
 
 	mutex_unlock(&dev_pm_qos_mtx);
 	return ret;
@@ -487,9 +487,8 @@ int dev_pm_qos_remove_notifier(struct de
 
 	/* Silently return if the constraints object is not present. */
 	if (!IS_ERR_OR_NULL(dev->power.qos))
-		retval = blocking_notifier_chain_unregister(
-				dev->power.qos->latency.notifiers,
-				notifier);
+		retval = blocking_notifier_chain_unregister(dev->power.qos->resume_latency.notifiers,
+							    notifier);
 
 	mutex_unlock(&dev_pm_qos_mtx);
 	return retval;
@@ -543,7 +542,7 @@ int dev_pm_qos_add_ancestor_request(stru
 
 	if (ancestor)
 		ret = dev_pm_qos_add_request(ancestor, req,
-					     DEV_PM_QOS_LATENCY, value);
+					     DEV_PM_QOS_RESUME_LATENCY, value);
 
 	if (ret < 0)
 		req->dev = NULL;
@@ -559,9 +558,9 @@ static void __dev_pm_qos_drop_user_reque
 	struct dev_pm_qos_request *req = NULL;
 
 	switch(type) {
-	case DEV_PM_QOS_LATENCY:
-		req = dev->power.qos->latency_req;
-		dev->power.qos->latency_req = NULL;
+	case DEV_PM_QOS_RESUME_LATENCY:
+		req = dev->power.qos->resume_latency_req;
+		dev->power.qos->resume_latency_req = NULL;
 		break;
 	case DEV_PM_QOS_FLAGS:
 		req = dev->power.qos->flags_req;
@@ -597,7 +596,7 @@ int dev_pm_qos_expose_latency_limit(stru
 	if (!req)
 		return -ENOMEM;
 
-	ret = dev_pm_qos_add_request(dev, req, DEV_PM_QOS_LATENCY, value);
+	ret = dev_pm_qos_add_request(dev, req, DEV_PM_QOS_RESUME_LATENCY, value);
 	if (ret < 0) {
 		kfree(req);
 		return ret;
@@ -609,7 +608,7 @@ int dev_pm_qos_expose_latency_limit(stru
 
 	if (IS_ERR_OR_NULL(dev->power.qos))
 		ret = -ENODEV;
-	else if (dev->power.qos->latency_req)
+	else if (dev->power.qos->resume_latency_req)
 		ret = -EEXIST;
 
 	if (ret < 0) {
@@ -618,13 +617,13 @@ int dev_pm_qos_expose_latency_limit(stru
 		mutex_unlock(&dev_pm_qos_mtx);
 		goto out;
 	}
-	dev->power.qos->latency_req = req;
+	dev->power.qos->resume_latency_req = req;
 
 	mutex_unlock(&dev_pm_qos_mtx);
 
-	ret = pm_qos_sysfs_add_latency(dev);
+	ret = pm_qos_sysfs_add_resume_latency(dev);
 	if (ret)
-		dev_pm_qos_drop_user_request(dev, DEV_PM_QOS_LATENCY);
+		dev_pm_qos_drop_user_request(dev, DEV_PM_QOS_RESUME_LATENCY);
 
  out:
 	mutex_unlock(&dev_pm_qos_sysfs_mtx);
@@ -634,8 +633,8 @@ EXPORT_SYMBOL_GPL(dev_pm_qos_expose_late
 
 static void __dev_pm_qos_hide_latency_limit(struct device *dev)
 {
-	if (!IS_ERR_OR_NULL(dev->power.qos) && dev->power.qos->latency_req)
-		__dev_pm_qos_drop_user_request(dev, DEV_PM_QOS_LATENCY);
+	if (!IS_ERR_OR_NULL(dev->power.qos) && dev->power.qos->resume_latency_req)
+		__dev_pm_qos_drop_user_request(dev, DEV_PM_QOS_RESUME_LATENCY);
 }
 
 /**
@@ -646,7 +645,7 @@ void dev_pm_qos_hide_latency_limit(struc
 {
 	mutex_lock(&dev_pm_qos_sysfs_mtx);
 
-	pm_qos_sysfs_remove_latency(dev);
+	pm_qos_sysfs_remove_resume_latency(dev);
 
 	mutex_lock(&dev_pm_qos_mtx);
 	__dev_pm_qos_hide_latency_limit(dev);
Index: linux-pm/drivers/mtd/nand/sh_flctl.c
===================================================================
--- linux-pm.orig/drivers/mtd/nand/sh_flctl.c
+++ linux-pm/drivers/mtd/nand/sh_flctl.c
@@ -897,7 +897,7 @@ static void flctl_select_chip(struct mtd
 		if (!flctl->qos_request) {
 			ret = dev_pm_qos_add_request(&flctl->pdev->dev,
 							&flctl->pm_qos,
-							DEV_PM_QOS_LATENCY,
+							DEV_PM_QOS_RESUME_LATENCY,
 							100);
 			if (ret < 0)
 				dev_err(&flctl->pdev->dev,
Index: linux-pm/include/linux/pm_qos.h
===================================================================
--- linux-pm.orig/include/linux/pm_qos.h
+++ linux-pm/include/linux/pm_qos.h
@@ -32,7 +32,7 @@ enum pm_qos_flags_status {
 #define PM_QOS_CPU_DMA_LAT_DEFAULT_VALUE	(2000 * USEC_PER_SEC)
 #define PM_QOS_NETWORK_LAT_DEFAULT_VALUE	(2000 * USEC_PER_SEC)
 #define PM_QOS_NETWORK_THROUGHPUT_DEFAULT_VALUE	0
-#define PM_QOS_DEV_LAT_DEFAULT_VALUE		0
+#define PM_QOS_RESUME_LATENCY_DEFAULT_VALUE	0
 
 #define PM_QOS_FLAG_NO_POWER_OFF	(1 << 0)
 #define PM_QOS_FLAG_REMOTE_WAKEUP	(1 << 1)
@@ -49,7 +49,7 @@ struct pm_qos_flags_request {
 };
 
 enum dev_pm_qos_req_type {
-	DEV_PM_QOS_LATENCY = 1,
+	DEV_PM_QOS_RESUME_LATENCY = 1,
 	DEV_PM_QOS_FLAGS,
 };
 
@@ -87,9 +87,9 @@ struct pm_qos_flags {
 };
 
 struct dev_pm_qos {
-	struct pm_qos_constraints latency;
+	struct pm_qos_constraints resume_latency;
 	struct pm_qos_flags flags;
-	struct dev_pm_qos_request *latency_req;
+	struct dev_pm_qos_request *resume_latency_req;
 	struct dev_pm_qos_request *flags_req;
 };
 
@@ -196,9 +196,9 @@ int dev_pm_qos_expose_flags(struct devic
 void dev_pm_qos_hide_flags(struct device *dev);
 int dev_pm_qos_update_flags(struct device *dev, s32 mask, bool set);
 
-static inline s32 dev_pm_qos_requested_latency(struct device *dev)
+static inline s32 dev_pm_qos_requested_resume_latency(struct device *dev)
 {
-	return dev->power.qos->latency_req->data.pnode.prio;
+	return dev->power.qos->resume_latency_req->data.pnode.prio;
 }
 
 static inline s32 dev_pm_qos_requested_flags(struct device *dev)
@@ -215,7 +215,7 @@ static inline void dev_pm_qos_hide_flags
 static inline int dev_pm_qos_update_flags(struct device *dev, s32 m, bool set)
 			{ return 0; }
 
-static inline s32 dev_pm_qos_requested_latency(struct device *dev) { return 0; }
+static inline s32 dev_pm_qos_requested_resume_latency(struct device *dev) { return 0; }
 static inline s32 dev_pm_qos_requested_flags(struct device *dev) { return 0; }
 #endif
 
Index: linux-pm/include/trace/events/power.h
===================================================================
--- linux-pm.orig/include/trace/events/power.h
+++ linux-pm/include/trace/events/power.h
@@ -359,8 +359,8 @@ DECLARE_EVENT_CLASS(dev_pm_qos_request,
 	TP_printk("device=%s type=%s new_value=%d",
 		  __get_str(name),
 		  __print_symbolic(__entry->type,
-			{ DEV_PM_QOS_LATENCY,	"DEV_PM_QOS_LATENCY" },
-			{ DEV_PM_QOS_FLAGS,	"DEV_PM_QOS_FLAGS" }),
+			{ DEV_PM_QOS_RESUME_LATENCY, "DEV_PM_QOS_RESUME_LATENCY" },
+			{ DEV_PM_QOS_FLAGS, "DEV_PM_QOS_FLAGS" }),
 		  __entry->new_value)
 );
 
Index: linux-pm/drivers/base/power/power.h
===================================================================
--- linux-pm.orig/drivers/base/power/power.h
+++ linux-pm/drivers/base/power/power.h
@@ -89,8 +89,8 @@ extern void dpm_sysfs_remove(struct devi
 extern void rpm_sysfs_remove(struct device *dev);
 extern int wakeup_sysfs_add(struct device *dev);
 extern void wakeup_sysfs_remove(struct device *dev);
-extern int pm_qos_sysfs_add_latency(struct device *dev);
-extern void pm_qos_sysfs_remove_latency(struct device *dev);
+extern int pm_qos_sysfs_add_resume_latency(struct device *dev);
+extern void pm_qos_sysfs_remove_resume_latency(struct device *dev);
 extern int pm_qos_sysfs_add_flags(struct device *dev);
 extern void pm_qos_sysfs_remove_flags(struct device *dev);
 
Index: linux-pm/drivers/base/power/sysfs.c
===================================================================
--- linux-pm.orig/drivers/base/power/sysfs.c
+++ linux-pm/drivers/base/power/sysfs.c
@@ -218,15 +218,16 @@ static ssize_t autosuspend_delay_ms_stor
 static DEVICE_ATTR(autosuspend_delay_ms, 0644, autosuspend_delay_ms_show,
 		autosuspend_delay_ms_store);
 
-static ssize_t pm_qos_latency_show(struct device *dev,
-				   struct device_attribute *attr, char *buf)
+static ssize_t pm_qos_resume_latency_show(struct device *dev,
+					  struct device_attribute *attr,
+					  char *buf)
 {
-	return sprintf(buf, "%d\n", dev_pm_qos_requested_latency(dev));
+	return sprintf(buf, "%d\n", dev_pm_qos_requested_resume_latency(dev));
 }
 
-static ssize_t pm_qos_latency_store(struct device *dev,
-				    struct device_attribute *attr,
-				    const char *buf, size_t n)
+static ssize_t pm_qos_resume_latency_store(struct device *dev,
+					   struct device_attribute *attr,
+					   const char *buf, size_t n)
 {
 	s32 value;
 	int ret;
@@ -237,12 +238,13 @@ static ssize_t pm_qos_latency_store(stru
 	if (value < 0)
 		return -EINVAL;
 
-	ret = dev_pm_qos_update_request(dev->power.qos->latency_req, value);
+	ret = dev_pm_qos_update_request(dev->power.qos->resume_latency_req,
+					value);
 	return ret < 0 ? ret : n;
 }
 
 static DEVICE_ATTR(pm_qos_resume_latency_us, 0644,
-		   pm_qos_latency_show, pm_qos_latency_store);
+		   pm_qos_resume_latency_show, pm_qos_resume_latency_store);
 
 static ssize_t pm_qos_no_power_off_show(struct device *dev,
 					struct device_attribute *attr,
@@ -618,15 +620,15 @@ static struct attribute_group pm_runtime
 	.attrs	= runtime_attrs,
 };
 
-static struct attribute *pm_qos_latency_attrs[] = {
+static struct attribute *pm_qos_resume_latency_attrs[] = {
 #ifdef CONFIG_PM_RUNTIME
 	&dev_attr_pm_qos_resume_latency_us.attr,
 #endif /* CONFIG_PM_RUNTIME */
 	NULL,
 };
-static struct attribute_group pm_qos_latency_attr_group = {
+static struct attribute_group pm_qos_resume_latency_attr_group = {
 	.name	= power_group_name,
-	.attrs	= pm_qos_latency_attrs,
+	.attrs	= pm_qos_resume_latency_attrs,
 };
 
 static struct attribute *pm_qos_flags_attrs[] = {
@@ -681,14 +683,14 @@ void wakeup_sysfs_remove(struct device *
 	sysfs_unmerge_group(&dev->kobj, &pm_wakeup_attr_group);
 }
 
-int pm_qos_sysfs_add_latency(struct device *dev)
+int pm_qos_sysfs_add_resume_latency(struct device *dev)
 {
-	return sysfs_merge_group(&dev->kobj, &pm_qos_latency_attr_group);
+	return sysfs_merge_group(&dev->kobj, &pm_qos_resume_latency_attr_group);
 }
 
-void pm_qos_sysfs_remove_latency(struct device *dev)
+void pm_qos_sysfs_remove_resume_latency(struct device *dev)
 {
-	sysfs_unmerge_group(&dev->kobj, &pm_qos_latency_attr_group);
+	sysfs_unmerge_group(&dev->kobj, &pm_qos_resume_latency_attr_group);
 }
 
 int pm_qos_sysfs_add_flags(struct device *dev)
Index: linux-pm/Documentation/power/pm_qos_interface.txt
===================================================================
--- linux-pm.orig/Documentation/power/pm_qos_interface.txt
+++ linux-pm/Documentation/power/pm_qos_interface.txt
@@ -89,16 +89,16 @@ node.
 2. PM QoS per-device latency and flags framework
 
 For each device, there are two lists of PM QoS requests. One is maintained
-along with the aggregated target of latency value and the other is for PM QoS
-flags. Values are updated in response to changes of the request list.
+along with the aggregated target of resume latency value and the other is for
+PM QoS flags. Values are updated in response to changes of the request list.
 
-Target latency value is simply the minimum of the request values held in the
-parameter list elements.  The PM QoS flags aggregate value is a gather (bitwise
-OR) of all list elements' values. Two device PM QoS flags are defined currently:
-PM_QOS_FLAG_NO_POWER_OFF and PM_QOS_FLAG_REMOTE_WAKEUP.
+Target resume latency value is simply the minimum of the request values held in
+the parameter list elements.  The PM QoS flags aggregate value is a gather
+(bitwise OR) of all list elements' values.  Two device PM QoS flags are defined
+currently: PM_QOS_FLAG_NO_POWER_OFF and PM_QOS_FLAG_REMOTE_WAKEUP.
 
-Note: the aggregated target value is implemented as an atomic variable so that
-reading the aggregated value does not require any locking mechanism.
+Note: the aggregated target value is implemented in such a way that reading the
+aggregated value does not require any locking mechanism.
 
 
 From kernel mode the use of this interface is the following:
@@ -137,14 +137,14 @@ Add a PM QoS request for the first direc
 power.ignore_children flag is unset.
 
 int dev_pm_qos_expose_latency_limit(device, value)
-Add a request to the device's PM QoS list of latency constraints and create
-a sysfs attribute pm_qos_resume_latency_us under the device's power directory
-allowing user space to manipulate that request.
+Add a request to the device's PM QoS list of resume latency constraints and
+create a sysfs attribute pm_qos_resume_latency_us under the device's power
+directory allowing user space to manipulate that request.
 
 void dev_pm_qos_hide_latency_limit(device)
 Drop the request added by dev_pm_qos_expose_latency_limit() from the device's
-PM QoS list of latency constraints and remove sysfs attribute pm_qos_resume_latency_us
-from the device's power directory.
+PM QoS list of resume latency constraints and remove sysfs attribute
+pm_qos_resume_latency_us from the device's power directory.
 
 int dev_pm_qos_expose_flags(device, value)
 Add a request to the device's PM QoS list of flags and create sysfs attributes
@@ -163,7 +163,7 @@ a per-device notification tree and a glo
 int dev_pm_qos_add_notifier(device, notifier):
 Adds a notification callback function for the device.
 The callback is called when the aggregated value of the device constraints list
-is changed.
+is changed (for resume latency device PM QoS only).
 
 int dev_pm_qos_remove_notifier(device, notifier):
 Removes the notification callback function for the device.
@@ -171,14 +171,9 @@ Removes the notification callback functi
 int dev_pm_qos_add_global_notifier(notifier):
 Adds a notification callback function in the global notification tree of the
 framework.
-The callback is called when the aggregated value for any device is changed.
+The callback is called when the aggregated value for any device is changed
+(for resume latency device PM QoS only).
 
 int dev_pm_qos_remove_global_notifier(notifier):
 Removes the notification callback function from the global notification tree
 of the framework.
-
-
-From user mode:
-No API for user space access to the per-device latency constraints is provided
-yet - still under discussion.
-

