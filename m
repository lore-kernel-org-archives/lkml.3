Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528AbaAQOiE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 09:38:04 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:52790 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751548AbaAQOh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 09:37:59 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linux PM list <linux-pm@vger.kernel.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [RFC/RFT][PATCH 5/5] PM / QoS: Add type to dev_pm_qos_add_ancestor_request() arguments
Date: Fri, 17 Jan 2014 15:49:03 +0100
Message-ID: <13391502.k2E2vCKgDd@vostro.rjw.lan>
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

Rework dev_pm_qos_add_ancestor_request() so that device PM QoS type
is passed to it as the third argument and make it support the
DEV_PM_QOS_LATENCY_TOLERANCE device PM QoS type (in addition to
DEV_PM_QOS_RESUME_LATENCY).

That will allow the drivers of devices without latency tolerance
hardware support to use their ancestors having it as proxies for
their latency tolerance requirements.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 Documentation/power/pm_qos_interface.txt |    6 ++++--
 drivers/base/power/qos.c                 |   22 +++++++++++++++++-----
 drivers/input/touchscreen/st1232.c       |    3 ++-
 include/linux/pm_qos.h                   |    7 +++++--
 4 files changed, 28 insertions(+), 10 deletions(-)

Index: linux-pm/include/linux/pm_qos.h
===================================================================
--- linux-pm.orig/include/linux/pm_qos.h
+++ linux-pm/include/linux/pm_qos.h
@@ -148,7 +148,8 @@ int dev_pm_qos_remove_global_notifier(st
 void dev_pm_qos_constraints_init(struct device *dev);
 void dev_pm_qos_constraints_destroy(struct device *dev);
 int dev_pm_qos_add_ancestor_request(struct device *dev,
-				    struct dev_pm_qos_request *req, s32 value);
+				    struct dev_pm_qos_request *req,
+				    enum dev_pm_qos_req_type type, s32 value);
 #else
 static inline enum pm_qos_flags_status __dev_pm_qos_flags(struct device *dev,
 							  s32 mask)
@@ -191,7 +192,9 @@ static inline void dev_pm_qos_constraint
 	dev->power.power_state = PMSG_INVALID;
 }
 static inline int dev_pm_qos_add_ancestor_request(struct device *dev,
-				    struct dev_pm_qos_request *req, s32 value)
+						  struct dev_pm_qos_request *req,
+						  enum dev_pm_qos_req_type type,
+						  s32 value)
 			{ return 0; }
 #endif
 
Index: linux-pm/drivers/base/power/qos.c
===================================================================
--- linux-pm.orig/drivers/base/power/qos.c
+++ linux-pm/drivers/base/power/qos.c
@@ -558,20 +558,32 @@ EXPORT_SYMBOL_GPL(dev_pm_qos_remove_glob
  * dev_pm_qos_add_ancestor_request - Add PM QoS request for device's ancestor.
  * @dev: Device whose ancestor to add the request for.
  * @req: Pointer to the preallocated handle.
+ * @type: Type of the request.
  * @value: Constraint latency value.
  */
 int dev_pm_qos_add_ancestor_request(struct device *dev,
-				    struct dev_pm_qos_request *req, s32 value)
+				    struct dev_pm_qos_request *req,
+				    enum dev_pm_qos_req_type type, s32 value)
 {
 	struct device *ancestor = dev->parent;
 	int ret = -ENODEV;
 
-	while (ancestor && !ancestor->power.ignore_children)
-		ancestor = ancestor->parent;
+	switch (type) {
+	case DEV_PM_QOS_RESUME_LATENCY:
+		while (ancestor && !ancestor->power.ignore_children)
+			ancestor = ancestor->parent;
 
+		break;
+	case DEV_PM_QOS_LATENCY_TOLERANCE:
+		while (ancestor && !ancestor->power.set_latency_tolerance)
+			ancestor = ancestor->parent;
+
+		break;
+	default:
+		ancestor = NULL;
+	}
 	if (ancestor)
-		ret = dev_pm_qos_add_request(ancestor, req,
-					     DEV_PM_QOS_RESUME_LATENCY, value);
+		ret = dev_pm_qos_add_request(ancestor, req, type, value);
 
 	if (ret < 0)
 		req->dev = NULL;
Index: linux-pm/Documentation/power/pm_qos_interface.txt
===================================================================
--- linux-pm.orig/Documentation/power/pm_qos_interface.txt
+++ linux-pm/Documentation/power/pm_qos_interface.txt
@@ -134,9 +134,11 @@ The meaning of the return values is as f
 	PM_QOS_FLAGS_UNDEFINED: The device's PM QoS structure has not been
 			initialized or the list of requests is empty.
 
-int dev_pm_qos_add_ancestor_request(dev, handle, value)
+int dev_pm_qos_add_ancestor_request(dev, handle, type, value)
 Add a PM QoS request for the first direct ancestor of the given device whose
-power.ignore_children flag is unset.
+power.ignore_children flag is unset (for DEV_PM_QOS_RESUME_LATENCY requests)
+or whose power.set_latency_tolerance callback pointer is not NULL (for
+DEV_PM_QOS_LATENCY_TOLERANCE requests).
 
 int dev_pm_qos_expose_latency_limit(device, value)
 Add a request to the device's PM QoS list of resume latency constraints and
Index: linux-pm/drivers/input/touchscreen/st1232.c
===================================================================
--- linux-pm.orig/drivers/input/touchscreen/st1232.c
+++ linux-pm/drivers/input/touchscreen/st1232.c
@@ -134,7 +134,8 @@ static irqreturn_t st1232_ts_irq_handler
 	} else if (!ts->low_latency_req.dev) {
 		/* First contact, request 100 us latency. */
 		dev_pm_qos_add_ancestor_request(&ts->client->dev,
-						&ts->low_latency_req, 100);
+						&ts->low_latency_req,
+						DEV_PM_QOS_RESUME_LATENCY, 100);
 	}
 
 	/* SYN_REPORT */

