Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597Ab3FNMYT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 08:24:19 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:37233 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752471Ab3FNMYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 08:24:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>, Lan Tianyu <tianyu.lan@intel.com>
Subject: [PATCH 4/4] ACPI / PM: Drop two functions that are not used any more
Date: Fri, 14 Jun 2013 14:33:24 +0200
Message-ID: <2934743.cl2LaccKZx@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <6895318.cKDBc4OdI0@vostro.rjw.lan>
References: <6895318.cKDBc4OdI0@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Two functions defined in device_pm.c, acpi_dev_pm_add_dependent()
and acpi_dev_pm_remove_dependent(), have no callers and may be
dropped, so drop them.

Moreover, they are the only functions adding entries to and removing
entries from the power_dependent list in struct acpi_device, so drop
that list and the loop walking it in acpi_power_resume_dependent()
too.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/device_pm.c |   56 -----------------------------------------------
 drivers/acpi/power.c     |    3 --
 drivers/acpi/scan.c      |    1 
 include/acpi/acpi_bus.h  |    7 -----
 4 files changed, 67 deletions(-)

Index: linux-pm/include/acpi/acpi_bus.h
===================================================================
--- linux-pm.orig/include/acpi/acpi_bus.h
+++ linux-pm/include/acpi/acpi_bus.h
@@ -308,7 +308,6 @@ struct acpi_device {
 	struct list_head physical_node_list;
 	struct mutex physical_node_lock;
 	DECLARE_BITMAP(physical_node_id_bitmap, ACPI_MAX_PHYSICAL_NODE);
-	struct list_head power_dependent;
 	void (*remove)(struct acpi_device *);
 };
 
@@ -461,8 +460,6 @@ acpi_status acpi_add_pm_notifier(struct
 acpi_status acpi_remove_pm_notifier(struct acpi_device *adev,
 				    acpi_notify_handler handler);
 int acpi_pm_device_sleep_state(struct device *, int *, int);
-void acpi_dev_pm_add_dependent(acpi_handle handle, struct device *depdev);
-void acpi_dev_pm_remove_dependent(acpi_handle handle, struct device *depdev);
 #else
 static inline acpi_status acpi_add_pm_notifier(struct acpi_device *adev,
 					       acpi_notify_handler handler,
@@ -482,10 +479,6 @@ static inline int acpi_pm_device_sleep_s
 
 	return (m >= ACPI_STATE_D0 && m <= ACPI_STATE_D3) ? m : ACPI_STATE_D0;
 }
-static inline void acpi_dev_pm_add_dependent(acpi_handle handle,
-					     struct device *depdev) {}
-static inline void acpi_dev_pm_remove_dependent(acpi_handle handle,
-						struct device *depdev) {}
 #endif
 
 #ifdef CONFIG_PM_RUNTIME
Index: linux-pm/drivers/acpi/device_pm.c
===================================================================
--- linux-pm.orig/drivers/acpi/device_pm.c
+++ linux-pm/drivers/acpi/device_pm.c
@@ -994,60 +994,4 @@ void acpi_dev_pm_detach(struct device *d
 	}
 }
 EXPORT_SYMBOL_GPL(acpi_dev_pm_detach);
-
-/**
- * acpi_dev_pm_add_dependent - Add physical device depending for PM.
- * @handle: Handle of ACPI device node.
- * @depdev: Device depending on that node for PM.
- */
-void acpi_dev_pm_add_dependent(acpi_handle handle, struct device *depdev)
-{
-	struct acpi_device_physical_node *dep;
-	struct acpi_device *adev;
-
-	if (!depdev || acpi_bus_get_device(handle, &adev))
-		return;
-
-	mutex_lock(&adev->physical_node_lock);
-
-	list_for_each_entry(dep, &adev->power_dependent, node)
-		if (dep->dev == depdev)
-			goto out;
-
-	dep = kzalloc(sizeof(*dep), GFP_KERNEL);
-	if (dep) {
-		dep->dev = depdev;
-		list_add_tail(&dep->node, &adev->power_dependent);
-	}
-
- out:
-	mutex_unlock(&adev->physical_node_lock);
-}
-EXPORT_SYMBOL_GPL(acpi_dev_pm_add_dependent);
-
-/**
- * acpi_dev_pm_remove_dependent - Remove physical device depending for PM.
- * @handle: Handle of ACPI device node.
- * @depdev: Device depending on that node for PM.
- */
-void acpi_dev_pm_remove_dependent(acpi_handle handle, struct device *depdev)
-{
-	struct acpi_device_physical_node *dep;
-	struct acpi_device *adev;
-
-	if (!depdev || acpi_bus_get_device(handle, &adev))
-		return;
-
-	mutex_lock(&adev->physical_node_lock);
-
-	list_for_each_entry(dep, &adev->power_dependent, node)
-		if (dep->dev == depdev) {
-			list_del(&dep->node);
-			kfree(dep);
-			break;
-		}
-
-	mutex_unlock(&adev->physical_node_lock);
-}
-EXPORT_SYMBOL_GPL(acpi_dev_pm_remove_dependent);
 #endif /* CONFIG_PM */
Index: linux-pm/drivers/acpi/power.c
===================================================================
--- linux-pm.orig/drivers/acpi/power.c
+++ linux-pm/drivers/acpi/power.c
@@ -253,9 +253,6 @@ static void acpi_power_resume_dependent(
 	list_for_each_entry(pn, &adev->physical_node_list, node)
 		pm_request_resume(pn->dev);
 
-	list_for_each_entry(pn, &adev->power_dependent, node)
-		pm_request_resume(pn->dev);
-
 	mutex_unlock(&adev->physical_node_lock);
 }
 
Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -1018,7 +1018,6 @@ int acpi_device_add(struct acpi_device *
 	INIT_LIST_HEAD(&device->wakeup_list);
 	INIT_LIST_HEAD(&device->physical_node_list);
 	mutex_init(&device->physical_node_lock);
-	INIT_LIST_HEAD(&device->power_dependent);
 
 	new_bus_id = kzalloc(sizeof(struct acpi_device_bus_id), GFP_KERNEL);
 	if (!new_bus_id) {

