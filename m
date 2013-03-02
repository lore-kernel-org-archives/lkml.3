Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385Ab3CBCFS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 21:05:18 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:49357 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751528Ab3CBCFQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 21:05:16 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2] PM / QoS: Fix concurrency issues and memory leaks in device PM QoS
Date: Sat, 02 Mar 2013 03:09:49 +0100
Message-ID: <2195595.UWMoD0UF1c@vostro.rjw.lan>
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

The current device PM QoS code assumes that certain functions will
never be called in parallel with each other (for example, it is
assumed that dev_pm_qos_expose_flags() won't be called in parallel
with dev_pm_qos_hide_flags() for the same device and analogously
for the latency limit), which may be overly optimistic.  Moreover,
dev_pm_qos_expose_flags() and dev_pm_qos_expose_latency_limit()
leak memory in error code paths (req needs to be freed on errors)
and __dev_pm_qos_drop_user_request() forgets to free the request.

To fix the above issues put more things under the device PM QoS
mutex to make them mutually exclusive and add the missing freeing
of memory.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/base/power/qos.c |  129 +++++++++++++++++++++++++++++++----------------
 1 file changed, 87 insertions(+), 42 deletions(-)

Index: linux-pm/drivers/base/power/qos.c
===================================================================
--- linux-pm.orig/drivers/base/power/qos.c
+++ linux-pm/drivers/base/power/qos.c
@@ -344,6 +344,13 @@ static int __dev_pm_qos_update_request(s
 	s32 curr_value;
 	int ret = 0;
 
+	if (!req) /*guard against callers passing in null */
+		return -EINVAL;
+
+	if (WARN(!dev_pm_qos_request_active(req),
+		 "%s() called for unknown object\n", __func__))
+		return -EINVAL;
+
 	if (!req->dev->power.qos)
 		return -ENODEV;
 
@@ -386,6 +393,17 @@ int dev_pm_qos_update_request(struct dev
 {
 	int ret;
 
+	mutex_lock(&dev_pm_qos_mtx);
+	ret = __dev_pm_qos_update_request(req, new_value);
+	mutex_unlock(&dev_pm_qos_mtx);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(dev_pm_qos_update_request);
+
+static int __dev_pm_qos_remove_request(struct dev_pm_qos_request *req)
+{
+	int ret = 0;
+
 	if (!req) /*guard against callers passing in null */
 		return -EINVAL;
 
@@ -393,13 +411,15 @@ int dev_pm_qos_update_request(struct dev
 		 "%s() called for unknown object\n", __func__))
 		return -EINVAL;
 
-	mutex_lock(&dev_pm_qos_mtx);
-	ret = __dev_pm_qos_update_request(req, new_value);
-	mutex_unlock(&dev_pm_qos_mtx);
-
+	if (req->dev->power.qos) {
+		ret = apply_constraint(req, PM_QOS_REMOVE_REQ,
+				       PM_QOS_DEFAULT_VALUE);
+		memset(req, 0, sizeof(*req));
+	} else {
+		ret = -ENODEV;
+	}
 	return ret;
 }
-EXPORT_SYMBOL_GPL(dev_pm_qos_update_request);
 
 /**
  * dev_pm_qos_remove_request - modifies an existing qos request
@@ -418,26 +438,10 @@ EXPORT_SYMBOL_GPL(dev_pm_qos_update_requ
  */
 int dev_pm_qos_remove_request(struct dev_pm_qos_request *req)
 {
-	int ret = 0;
-
-	if (!req) /*guard against callers passing in null */
-		return -EINVAL;
-
-	if (WARN(!dev_pm_qos_request_active(req),
-		 "%s() called for unknown object\n", __func__))
-		return -EINVAL;
+	int ret;
 
 	mutex_lock(&dev_pm_qos_mtx);
-
-	if (req->dev->power.qos) {
-		ret = apply_constraint(req, PM_QOS_REMOVE_REQ,
-				       PM_QOS_DEFAULT_VALUE);
-		memset(req, 0, sizeof(*req));
-	} else {
-		/* Return if the device has been removed */
-		ret = -ENODEV;
-	}
-
+	ret = __dev_pm_qos_remove_request(req);
 	mutex_unlock(&dev_pm_qos_mtx);
 	return ret;
 }
@@ -563,16 +567,20 @@ EXPORT_SYMBOL_GPL(dev_pm_qos_add_ancesto
 static void __dev_pm_qos_drop_user_request(struct device *dev,
 					   enum dev_pm_qos_req_type type)
 {
+	struct dev_pm_qos_request *req = NULL;
+
 	switch(type) {
 	case DEV_PM_QOS_LATENCY:
-		dev_pm_qos_remove_request(dev->power.qos->latency_req);
+		req = dev->power.qos->latency_req;
 		dev->power.qos->latency_req = NULL;
 		break;
 	case DEV_PM_QOS_FLAGS:
-		dev_pm_qos_remove_request(dev->power.qos->flags_req);
+		req = dev->power.qos->flags_req;
 		dev->power.qos->flags_req = NULL;
 		break;
 	}
+	__dev_pm_qos_remove_request(req);
+	kfree(req);
 }
 
 /**
@@ -588,22 +596,36 @@ int dev_pm_qos_expose_latency_limit(stru
 	if (!device_is_registered(dev) || value < 0)
 		return -EINVAL;
 
-	if (dev->power.qos && dev->power.qos->latency_req)
-		return -EEXIST;
-
 	req = kzalloc(sizeof(*req), GFP_KERNEL);
 	if (!req)
 		return -ENOMEM;
 
 	ret = dev_pm_qos_add_request(dev, req, DEV_PM_QOS_LATENCY, value);
-	if (ret < 0)
+	if (ret < 0) {
+		kfree(req);
 		return ret;
+	}
+
+	mutex_lock(&dev_pm_qos_mtx);
+
+	if (!dev->power.qos)
+		ret = -ENODEV;
+	else if (dev->power.qos->latency_req)
+		ret = -EEXIST;
+
+	if (ret < 0) {
+		__dev_pm_qos_remove_request(req);
+		kfree(req);
+		goto out;
+	}
 
 	dev->power.qos->latency_req = req;
 	ret = pm_qos_sysfs_add_latency(dev);
 	if (ret)
 		__dev_pm_qos_drop_user_request(dev, DEV_PM_QOS_LATENCY);
 
+ out:
+	mutex_unlock(&dev_pm_qos_mtx);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(dev_pm_qos_expose_latency_limit);
@@ -614,10 +636,14 @@ EXPORT_SYMBOL_GPL(dev_pm_qos_expose_late
  */
 void dev_pm_qos_hide_latency_limit(struct device *dev)
 {
+	mutex_lock(&dev_pm_qos_mtx);
+
 	if (dev->power.qos && dev->power.qos->latency_req) {
 		pm_qos_sysfs_remove_latency(dev);
 		__dev_pm_qos_drop_user_request(dev, DEV_PM_QOS_LATENCY);
 	}
+
+	mutex_unlock(&dev_pm_qos_mtx);
 }
 EXPORT_SYMBOL_GPL(dev_pm_qos_hide_latency_limit);
 
@@ -634,24 +660,37 @@ int dev_pm_qos_expose_flags(struct devic
 	if (!device_is_registered(dev))
 		return -EINVAL;
 
-	if (dev->power.qos && dev->power.qos->flags_req)
-		return -EEXIST;
-
 	req = kzalloc(sizeof(*req), GFP_KERNEL);
 	if (!req)
 		return -ENOMEM;
 
-	pm_runtime_get_sync(dev);
 	ret = dev_pm_qos_add_request(dev, req, DEV_PM_QOS_FLAGS, val);
-	if (ret < 0)
-		goto fail;
+	if (ret < 0) {
+		kfree(req);
+		return ret;
+	}
+
+	pm_runtime_get_sync(dev);
+	mutex_lock(&dev_pm_qos_mtx);
+
+	if (!dev->power.qos)
+		ret = -ENODEV;
+	else if (dev->power.qos->flags_req)
+		ret = -EEXIST;
+
+	if (ret < 0) {
+		__dev_pm_qos_remove_request(req);
+		kfree(req);
+		goto out;
+	}
 
 	dev->power.qos->flags_req = req;
 	ret = pm_qos_sysfs_add_flags(dev);
 	if (ret)
 		__dev_pm_qos_drop_user_request(dev, DEV_PM_QOS_FLAGS);
 
-fail:
+ out:
+	mutex_unlock(&dev_pm_qos_mtx);
 	pm_runtime_put(dev);
 	return ret;
 }
@@ -663,12 +702,16 @@ EXPORT_SYMBOL_GPL(dev_pm_qos_expose_flag
  */
 void dev_pm_qos_hide_flags(struct device *dev)
 {
+	pm_runtime_get_sync(dev);
+	mutex_lock(&dev_pm_qos_mtx);
+
 	if (dev->power.qos && dev->power.qos->flags_req) {
 		pm_qos_sysfs_remove_flags(dev);
-		pm_runtime_get_sync(dev);
 		__dev_pm_qos_drop_user_request(dev, DEV_PM_QOS_FLAGS);
-		pm_runtime_put(dev);
 	}
+
+	mutex_unlock(&dev_pm_qos_mtx);
+	pm_runtime_put(dev);
 }
 EXPORT_SYMBOL_GPL(dev_pm_qos_hide_flags);
 
@@ -683,12 +726,14 @@ int dev_pm_qos_update_flags(struct devic
 	s32 value;
 	int ret;
 
-	if (!dev->power.qos || !dev->power.qos->flags_req)
-		return -EINVAL;
-
 	pm_runtime_get_sync(dev);
 	mutex_lock(&dev_pm_qos_mtx);
 
+	if (!dev->power.qos || !dev->power.qos->flags_req) {
+		ret = -EINVAL;
+		goto out;
+	}
+
 	value = dev_pm_qos_requested_flags(dev);
 	if (set)
 		value |= mask;
@@ -697,9 +742,9 @@ int dev_pm_qos_update_flags(struct devic
 
 	ret = __dev_pm_qos_update_request(dev->power.qos->flags_req, value);
 
+ out:
 	mutex_unlock(&dev_pm_qos_mtx);
 	pm_runtime_put(dev);
-
 	return ret;
 }
 #endif /* CONFIG_PM_RUNTIME */

