Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758839Ab3FMQg2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 12:36:28 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:43352 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756078Ab3FMQgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 12:36:24 -0400
From: Jiang Liu <jiang.liu@huawei.com>
To: "Rafael J . Wysocki" <rjw@sisk.pl>, Bjorn Helgaas <bhelgaas@google.com>,
        Yinghai Lu <yinghai@kernel.org>,
        "Alexander E . Patrakov" <patrakov@gmail.com>
Cc: Jiang Liu <jiang.liu@huawei.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [BUGFIX 9/9] ACPI: use new helper functions to simpilify code
Date: Fri, 14 Jun 2013 00:32:32 +0800
Message-Id: <1371141152-9468-10-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371141152-9468-1-git-send-email-jiang.liu@huawei.com>
References: <1371141152-9468-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use new helper functions to simpilify ACPI dock, acpiphp code.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
---
 drivers/acpi/dock.c                | 78 ++++----------------------------------
 drivers/acpi/scan.c                | 53 ++++++--------------------
 drivers/pci/hotplug/acpiphp_glue.c | 15 ++------
 3 files changed, 21 insertions(+), 125 deletions(-)

diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
index 72cf97e..1811f4f 100644
--- a/drivers/acpi/dock.c
+++ b/drivers/acpi/dock.c
@@ -181,26 +181,14 @@ find_dock_dependent_device(struct dock_station *ds, acpi_handle handle)
  * If an acpi object has a _DCK method, then it is by definition a dock
  * station, so return true.
  */
-static int is_dock(acpi_handle handle)
+static inline int is_dock(acpi_handle handle)
 {
-	acpi_status status;
-	acpi_handle tmp;
-
-	status = acpi_get_handle(handle, "_DCK", &tmp);
-	if (ACPI_FAILURE(status))
-		return 0;
-	return 1;
+	return acpi_has_method(handle, "_DCK");
 }
 
-static int __init is_ejectable(acpi_handle handle)
+static inline int is_ejectable(acpi_handle handle)
 {
-	acpi_status status;
-	acpi_handle tmp;
-
-	status = acpi_get_handle(handle, "_EJ0", &tmp);
-	if (ACPI_FAILURE(status))
-		return 0;
-	return 1;
+	return acpi_has_method(handle, "_EJ0");
 }
 
 static int __init is_ata(acpi_handle handle)
@@ -409,37 +397,6 @@ static void dock_event(struct dock_station *ds, u32 event, int num)
 }
 
 /**
- * eject_dock - respond to a dock eject request
- * @ds: the dock station
- *
- * This is called after _DCK is called, to execute the dock station's
- * _EJ0 method.
- */
-static void eject_dock(struct dock_station *ds)
-{
-	struct acpi_object_list arg_list;
-	union acpi_object arg;
-	acpi_status status;
-	acpi_handle tmp;
-
-	/* all dock devices should have _EJ0, but check anyway */
-	status = acpi_get_handle(ds->handle, "_EJ0", &tmp);
-	if (ACPI_FAILURE(status)) {
-		pr_debug("No _EJ0 support for dock device\n");
-		return;
-	}
-
-	arg_list.count = 1;
-	arg_list.pointer = &arg;
-	arg.type = ACPI_TYPE_INTEGER;
-	arg.integer.value = 1;
-
-	status = acpi_evaluate_object(ds->handle, "_EJ0", &arg_list, NULL);
-	if (ACPI_FAILURE(status))
-		pr_debug("Failed to evaluate _EJ0!\n");
-}
-
-/**
  * handle_dock - handle a dock event
  * @ds: the dock station
  * @dock: to dock, or undock - that is the question
@@ -499,27 +456,6 @@ static inline void complete_undock(struct dock_station *ds)
 	ds->flags &= ~(DOCK_UNDOCKING);
 }
 
-static void dock_lock(struct dock_station *ds, int lock)
-{
-	struct acpi_object_list arg_list;
-	union acpi_object arg;
-	acpi_status status;
-
-	arg_list.count = 1;
-	arg_list.pointer = &arg;
-	arg.type = ACPI_TYPE_INTEGER;
-	arg.integer.value = !!lock;
-	status = acpi_evaluate_object(ds->handle, "_LCK", &arg_list, NULL);
-	if (ACPI_FAILURE(status) && status != AE_NOT_FOUND) {
-		if (lock)
-			acpi_handle_warn(ds->handle,
-				"Locking device failed (0x%x)\n", status);
-		else
-			acpi_handle_warn(ds->handle,
-				"Unlocking device failed (0x%x)\n", status);
-	}
-}
-
 /**
  * dock_in_progress - see if we are in the middle of handling a dock event
  * @ds: the dock station
@@ -653,8 +589,8 @@ static int handle_eject_request(struct dock_station *ds, u32 event)
 
 	hotplug_dock_devices(ds, ACPI_NOTIFY_EJECT_REQUEST);
 	undock(ds);
-	dock_lock(ds, 0);
-	eject_dock(ds);
+	acpi_evaluate_lck(ds->handle, 0);
+	acpi_evaluate_ej0(ds->handle);
 	if (dock_present(ds)) {
 		acpi_handle_err(ds->handle, "Unable to undock!\n");
 		return -EBUSY;
@@ -713,7 +649,7 @@ static void dock_notify(acpi_handle handle, u32 event, void *data)
 			hotplug_dock_devices(ds, event);
 			complete_dock(ds);
 			dock_event(ds, event, DOCK_EVENT);
-			dock_lock(ds, 1);
+			acpi_evaluate_lck(ds->handle, 1);
 			acpi_update_all_gpes();
 			break;
 		}
diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 4148163..3372505 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -123,9 +123,6 @@ static DEVICE_ATTR(modalias, 0444, acpi_device_modalias_show, NULL);
 static int acpi_scan_hot_remove(struct acpi_device *device)
 {
 	acpi_handle handle = device->handle;
-	acpi_handle not_used;
-	struct acpi_object_list arg_list;
-	union acpi_object arg;
 	acpi_status status;
 	unsigned long long sta;
 
@@ -144,31 +141,12 @@ static int acpi_scan_hot_remove(struct acpi_device *device)
 	put_device(&device->dev);
 	device = NULL;
 
-	if (ACPI_SUCCESS(acpi_get_handle(handle, "_LCK", &not_used))) {
-		arg_list.count = 1;
-		arg_list.pointer = &arg;
-		arg.type = ACPI_TYPE_INTEGER;
-		arg.integer.value = 0;
-		acpi_evaluate_object(handle, "_LCK", &arg_list, NULL);
-	}
-
-	arg_list.count = 1;
-	arg_list.pointer = &arg;
-	arg.type = ACPI_TYPE_INTEGER;
-	arg.integer.value = 1;
-
-	/*
-	 * TBD: _EJD support.
-	 */
-	status = acpi_evaluate_object(handle, "_EJ0", &arg_list, NULL);
-	if (ACPI_FAILURE(status)) {
-		if (status == AE_NOT_FOUND) {
-			return -ENODEV;
-		} else {
-			acpi_handle_warn(handle, "Eject failed (0x%x)\n",
-								status);
-			return -EIO;
-		}
+	acpi_evaluate_lck(handle, 0);
+	status = acpi_evaluate_ej0(handle);
+	if (status == AE_NOT_FOUND) {
+		return -ENODEV;
+	} else if (ACPI_FAILURE(status)) {
+		return -EIO;
 	}
 
 	/*
@@ -536,7 +514,6 @@ static int acpi_device_setup_files(struct acpi_device *dev)
 {
 	struct acpi_buffer buffer = {ACPI_ALLOCATE_BUFFER, NULL};
 	acpi_status status;
-	acpi_handle temp;
 	unsigned long long sun;
 	int result = 0;
 
@@ -562,8 +539,7 @@ static int acpi_device_setup_files(struct acpi_device *dev)
 	/*
 	 * If device has _STR, 'description' file is created
 	 */
-	status = acpi_get_handle(dev->handle, "_STR", &temp);
-	if (ACPI_SUCCESS(status)) {
+	if (acpi_has_method(dev->handle, "_STR")) {
 		status = acpi_evaluate_object(dev->handle, "_STR",
 					NULL, &buffer);
 		if (ACPI_FAILURE(status))
@@ -593,8 +569,7 @@ static int acpi_device_setup_files(struct acpi_device *dev)
          * If device has _EJ0, 'eject' file is created that is used to trigger
          * hot-removal function from userland.
          */
-	status = acpi_get_handle(dev->handle, "_EJ0", &temp);
-	if (ACPI_SUCCESS(status)) {
+	if (acpi_has_method(dev->handle, "_EJ0")) {
 		result = device_create_file(&dev->dev, &dev_attr_eject);
 		if (result)
 			return result;
@@ -616,9 +591,6 @@ end:
 
 static void acpi_device_remove_files(struct acpi_device *dev)
 {
-	acpi_status status;
-	acpi_handle temp;
-
 	if (dev->flags.power_manageable) {
 		device_remove_file(&dev->dev, &dev_attr_power_state);
 		if (dev->power.flags.power_resources)
@@ -629,20 +601,17 @@ static void acpi_device_remove_files(struct acpi_device *dev)
 	/*
 	 * If device has _STR, remove 'description' file
 	 */
-	status = acpi_get_handle(dev->handle, "_STR", &temp);
-	if (ACPI_SUCCESS(status)) {
+	if (acpi_has_method(dev->handle, "_STR")) {
 		kfree(dev->pnp.str_obj);
 		device_remove_file(&dev->dev, &dev_attr_description);
 	}
 	/*
 	 * If device has _EJ0, remove 'eject' file.
 	 */
-	status = acpi_get_handle(dev->handle, "_EJ0", &temp);
-	if (ACPI_SUCCESS(status))
+	if (acpi_has_method(dev->handle, "_EJ0"))
 		device_remove_file(&dev->dev, &dev_attr_eject);
 
-	status = acpi_get_handle(dev->handle, "_SUN", &temp);
-	if (ACPI_SUCCESS(status))
+	if (acpi_has_method(dev->handle, "_SUN"))
 		device_remove_file(&dev->dev, &dev_attr_sun);
 
 	if (dev->pnp.unique_id)
diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index 699b8ca..d0699ed 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -828,23 +828,14 @@ int acpiphp_eject_slot(struct acpiphp_slot *slot)
 {
 	acpi_status status;
 	struct acpiphp_func *func;
-	struct acpi_object_list arg_list;
-	union acpi_object arg;
 
 	list_for_each_entry(func, &slot->funcs, sibling) {
 		/* We don't want to call _EJ0 on non-existing functions. */
 		if ((func->flags & FUNC_HAS_EJ0)) {
-			/* _EJ0 method take one argument */
-			arg_list.count = 1;
-			arg_list.pointer = &arg;
-			arg.type = ACPI_TYPE_INTEGER;
-			arg.integer.value = 1;
-
-			status = acpi_evaluate_object(func->handle, "_EJ0", &arg_list, NULL);
-			if (ACPI_FAILURE(status)) {
-				warn("%s: _EJ0 failed\n", __func__);
+			status = acpi_evaluate_ej0(func->handle);
+			if (ACPI_FAILURE(status))
 				return -1;
-			} else
+			else
 				break;
 		}
 	}
-- 
1.8.1.2

