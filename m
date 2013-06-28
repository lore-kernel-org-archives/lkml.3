Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916Ab3F1Q2N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 12:28:13 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:37726 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755736Ab3F1Q2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 12:28:10 -0400
From: Jiang Liu <liuj97@gmail.com>
To: "Rafael J . Wysocki" <rjw@sisk.pl>
Cc: liuj97@gmail.com, Jiang Liu <jiang.liu@huawei.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>
Subject: [PATCH v3 09/10] ACPI: simplify dock driver with new helper functions
Date: Sat, 29 Jun 2013 00:24:42 +0800
Message-Id: <1372436683-31711-10-git-send-email-liuj97@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372436683-31711-1-git-send-email-liuj97@gmail.com>
References: <1372436683-31711-1-git-send-email-liuj97@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Use new helper functions to simplify ACPI dock driver.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Jiang Liu <liuj97@gmail.com>
Cc: Len Brown <lenb@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/acpi/dock.c | 122 ++++++----------------------------------------------
 1 file changed, 12 insertions(+), 110 deletions(-)

diff --git a/drivers/acpi/dock.c b/drivers/acpi/dock.c
index 22183c4..31ab001 100644
--- a/drivers/acpi/dock.c
+++ b/drivers/acpi/dock.c
@@ -226,48 +226,6 @@ find_dock_dependent_device(struct dock_station *ds, acpi_handle handle)
 /*****************************************************************************
  *                         Dock functions                                    *
  *****************************************************************************/
-/**
- * is_dock - see if a device is a dock station
- * @handle: acpi handle of the device
- *
- * If an acpi object has a _DCK method, then it is by definition a dock
- * station, so return true.
- */
-static int is_dock(acpi_handle handle)
-{
-	acpi_status status;
-	acpi_handle tmp;
-
-	status = acpi_get_handle(handle, "_DCK", &tmp);
-	if (ACPI_FAILURE(status))
-		return 0;
-	return 1;
-}
-
-static int __init is_ejectable(acpi_handle handle)
-{
-	acpi_status status;
-	acpi_handle tmp;
-
-	status = acpi_get_handle(handle, "_EJ0", &tmp);
-	if (ACPI_FAILURE(status))
-		return 0;
-	return 1;
-}
-
-static int __init is_ata(acpi_handle handle)
-{
-	acpi_handle tmp;
-
-	if ((ACPI_SUCCESS(acpi_get_handle(handle, "_GTF", &tmp))) ||
-	   (ACPI_SUCCESS(acpi_get_handle(handle, "_GTM", &tmp))) ||
-	   (ACPI_SUCCESS(acpi_get_handle(handle, "_STM", &tmp))) ||
-	   (ACPI_SUCCESS(acpi_get_handle(handle, "_SDD", &tmp))))
-		return 1;
-
-	return 0;
-}
-
 static int __init is_battery(acpi_handle handle)
 {
 	struct acpi_device_info *info;
@@ -284,17 +242,13 @@ static int __init is_battery(acpi_handle handle)
 	return ret;
 }
 
-static int __init is_ejectable_bay(acpi_handle handle)
+/* Check whether ACPI object is an ejectable battery or disk bay */
+static bool __init is_ejectable_bay(acpi_handle handle)
 {
-	acpi_handle phandle;
+	if (acpi_has_method(handle, "_EJ0") && is_battery(handle))
+		return true;
 
-	if (!is_ejectable(handle))
-		return 0;
-	if (is_battery(handle) || is_ata(handle))
-		return 1;
-	if (!acpi_get_parent(handle, &phandle) && is_ata(phandle))
-		return 1;
-	return 0;
+	return acpi_bay_match(handle);
 }
 
 /**
@@ -312,7 +266,7 @@ int is_dock_device(acpi_handle handle)
 	if (!dock_station_count)
 		return 0;
 
-	if (is_dock(handle))
+	if (acpi_dock_match(handle))
 		return 1;
 
 	list_for_each_entry(dock_station, &dock_stations, sibling)
@@ -447,37 +401,6 @@ static void dock_event(struct dock_station *ds, u32 event, int num)
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
@@ -537,27 +460,6 @@ static inline void complete_undock(struct dock_station *ds)
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
@@ -692,8 +594,8 @@ static int handle_eject_request(struct dock_station *ds, u32 event)
 
 	hotplug_dock_devices(ds, ACPI_NOTIFY_EJECT_REQUEST);
 	undock(ds);
-	dock_lock(ds, 0);
-	eject_dock(ds);
+	acpi_evaluate_lck(ds->handle, 0);
+	acpi_evaluate_ej0(ds->handle);
 	if (dock_present(ds)) {
 		acpi_handle_err(ds->handle, "Unable to undock!\n");
 		return -EBUSY;
@@ -752,7 +654,7 @@ static void dock_notify(acpi_handle handle, u32 event, void *data)
 			hotplug_dock_devices(ds, event);
 			complete_dock(ds);
 			dock_event(ds, event, DOCK_EVENT);
-			dock_lock(ds, 1);
+			acpi_evaluate_lck(ds->handle, 1);
 			acpi_update_all_gpes();
 			break;
 		}
@@ -998,9 +900,9 @@ static int __init dock_add(acpi_handle handle)
 	/* we want the dock device to send uevents */
 	dev_set_uevent_suppress(&dd->dev, 0);
 
-	if (is_dock(handle))
+	if (acpi_dock_match(handle))
 		dock_station->flags |= DOCK_IS_DOCK;
-	if (is_ata(handle))
+	if (acpi_ata_match(handle))
 		dock_station->flags |= DOCK_IS_ATA;
 	if (is_battery(handle))
 		dock_station->flags |= DOCK_IS_BAT;
@@ -1043,7 +945,7 @@ err_unregister:
 static __init acpi_status
 find_dock_and_bay(acpi_handle handle, u32 lvl, void *context, void **rv)
 {
-	if (is_dock(handle) || is_ejectable_bay(handle))
+	if (acpi_dock_match(handle) || is_ejectable_bay(handle))
 		dock_add(handle);
 
 	return AE_OK;
-- 
1.8.1.2

