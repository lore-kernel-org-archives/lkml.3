Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752750Ab3FZQeN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 12:34:13 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:52600 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752222Ab3FZQeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 12:34:09 -0400
From: Jiang Liu <liuj97@gmail.com>
To: "Rafael J . Wysocki" <rjw@sisk.pl>
Cc: liuj97@gmail.com, Jiang Liu <jiang.liu@huawei.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>
Subject: [PATCH v2 8/9] ACPI: simpilify scan.c with new interfaces
Date: Thu, 27 Jun 2013 00:31:00 +0800
Message-Id: <1372264261-17442-9-git-send-email-liuj97@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372264261-17442-1-git-send-email-liuj97@gmail.com>
References: <1372264261-17442-1-git-send-email-liuj97@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Use new interfaces to simpilify scan.c.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Jiang Liu <liuj97@gmail.com>
Cc: Len Brown <lenb@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/acpi/scan.c | 100 ++++++++++++----------------------------------------
 1 file changed, 23 insertions(+), 77 deletions(-)

diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 3ddba74..d228926 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -194,9 +194,6 @@ static acpi_status acpi_bus_online_companions(acpi_handle handle, u32 lvl,
 static int acpi_scan_hot_remove(struct acpi_device *device)
 {
 	acpi_handle handle = device->handle;
-	acpi_handle not_used;
-	struct acpi_object_list arg_list;
-	union acpi_object arg;
 	struct device *errdev;
 	acpi_status status;
 	unsigned long long sta;
@@ -259,32 +256,15 @@ static int acpi_scan_hot_remove(struct acpi_device *device)
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
+	acpi_evaluate_lck(handle, 0);
 	/*
 	 * TBD: _EJD support.
 	 */
-	status = acpi_evaluate_object(handle, "_EJ0", &arg_list, NULL);
-	if (ACPI_FAILURE(status)) {
-		if (status == AE_NOT_FOUND) {
-			return -ENODEV;
-		} else {
-			acpi_handle_warn(handle, "Eject failed (0x%x)\n",
-								status);
-			return -EIO;
-		}
-	}
+	status = acpi_evaluate_ej0(handle);
+	if (status == AE_NOT_FOUND)
+		return -ENODEV;
+	else if (ACPI_FAILURE(status))
+		return -EIO;
 
 	/*
 	 * Verify if eject was indeed successful.  If not, log an error
@@ -653,7 +633,6 @@ static int acpi_device_setup_files(struct acpi_device *dev)
 {
 	struct acpi_buffer buffer = {ACPI_ALLOCATE_BUFFER, NULL};
 	acpi_status status;
-	acpi_handle temp;
 	unsigned long long sun;
 	int result = 0;
 
@@ -679,8 +658,7 @@ static int acpi_device_setup_files(struct acpi_device *dev)
 	/*
 	 * If device has _STR, 'description' file is created
 	 */
-	status = acpi_get_handle(dev->handle, "_STR", &temp);
-	if (ACPI_SUCCESS(status)) {
+	if (acpi_has_method(dev->handle, "_STR")) {
 		status = acpi_evaluate_object(dev->handle, "_STR",
 					NULL, &buffer);
 		if (ACPI_FAILURE(status))
@@ -710,8 +688,7 @@ static int acpi_device_setup_files(struct acpi_device *dev)
          * If device has _EJ0, 'eject' file is created that is used to trigger
          * hot-removal function from userland.
          */
-	status = acpi_get_handle(dev->handle, "_EJ0", &temp);
-	if (ACPI_SUCCESS(status)) {
+	if (acpi_has_method(dev->handle, "_EJ0")) {
 		result = device_create_file(&dev->dev, &dev_attr_eject);
 		if (result)
 			return result;
@@ -733,9 +710,6 @@ end:
 
 static void acpi_device_remove_files(struct acpi_device *dev)
 {
-	acpi_status status;
-	acpi_handle temp;
-
 	if (dev->flags.power_manageable) {
 		device_remove_file(&dev->dev, &dev_attr_power_state);
 		if (dev->power.flags.power_resources)
@@ -746,20 +720,17 @@ static void acpi_device_remove_files(struct acpi_device *dev)
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
@@ -1335,13 +1306,10 @@ static void acpi_bus_set_run_wake_flags(struct acpi_device *device)
 
 static void acpi_bus_get_wakeup_device_flags(struct acpi_device *device)
 {
-	acpi_handle temp;
-	acpi_status status = 0;
 	int err;
 
 	/* Presence of _PRW indicates wake capable */
-	status = acpi_get_handle(device->handle, "_PRW", &temp);
-	if (ACPI_FAILURE(status))
+	if (!acpi_has_method(device->handle, "_PRW"))
 		return;
 
 	err = acpi_bus_extract_wakeup_device_power_package(device->handle,
@@ -1371,7 +1339,6 @@ static void acpi_bus_init_power_state(struct acpi_device *device, int state)
 	struct acpi_device_power_state *ps = &device->power.states[state];
 	char pathname[5] = { '_', 'P', 'R', '0' + state, '\0' };
 	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER, NULL };
-	acpi_handle handle;
 	acpi_status status;
 
 	INIT_LIST_HEAD(&ps->resources);
@@ -1394,8 +1361,7 @@ static void acpi_bus_init_power_state(struct acpi_device *device, int state)
 
 	/* Evaluate "_PSx" to see if we can do explicit sets */
 	pathname[2] = 'S';
-	status = acpi_get_handle(device->handle, pathname, &handle);
-	if (ACPI_SUCCESS(status))
+	if (acpi_has_method(device->handle, pathname))
 		ps->flags.explicit_set = 1;
 
 	/*
@@ -1414,28 +1380,21 @@ static void acpi_bus_init_power_state(struct acpi_device *device, int state)
 
 static void acpi_bus_get_power_flags(struct acpi_device *device)
 {
-	acpi_status status;
-	acpi_handle handle;
 	u32 i;
 
 	/* Presence of _PS0|_PR0 indicates 'power manageable' */
-	status = acpi_get_handle(device->handle, "_PS0", &handle);
-	if (ACPI_FAILURE(status)) {
-		status = acpi_get_handle(device->handle, "_PR0", &handle);
-		if (ACPI_FAILURE(status))
-			return;
-	}
+	if (!acpi_has_method(device->handle, "_PS0") &&
+	    !acpi_has_method(device->handle, "_PR0"))
+		return;
 
 	device->flags.power_manageable = 1;
 
 	/*
 	 * Power Management Flags
 	 */
-	status = acpi_get_handle(device->handle, "_PSC", &handle);
-	if (ACPI_SUCCESS(status))
+	if (acpi_has_method(device->handle, "_PSC"))
 		device->power.flags.explicit_get = 1;
-	status = acpi_get_handle(device->handle, "_IRC", &handle);
-	if (ACPI_SUCCESS(status))
+	if (acpi_has_method(device->handle, "_IRC"))
 		device->power.flags.inrush_current = 1;
 
 	/*
@@ -1469,28 +1428,18 @@ static void acpi_bus_get_power_flags(struct acpi_device *device)
 
 static void acpi_bus_get_flags(struct acpi_device *device)
 {
-	acpi_status status = AE_OK;
-	acpi_handle temp = NULL;
-
 	/* Presence of _STA indicates 'dynamic_status' */
-	status = acpi_get_handle(device->handle, "_STA", &temp);
-	if (ACPI_SUCCESS(status))
+	if (acpi_has_method(device->handle, "_STA"))
 		device->flags.dynamic_status = 1;
 
 	/* Presence of _RMV indicates 'removable' */
-	status = acpi_get_handle(device->handle, "_RMV", &temp);
-	if (ACPI_SUCCESS(status))
+	if (acpi_has_method(device->handle, "_RMV"))
 		device->flags.removable = 1;
 
 	/* Presence of _EJD|_EJ0 indicates 'ejectable' */
-	status = acpi_get_handle(device->handle, "_EJD", &temp);
-	if (ACPI_SUCCESS(status))
+	if (acpi_has_method(device->handle, "_EJD") ||
+	    acpi_has_method(device->handle, "_EJ0"))
 		device->flags.ejectable = 1;
-	else {
-		status = acpi_get_handle(device->handle, "_EJ0", &temp);
-		if (ACPI_SUCCESS(status))
-			device->flags.ejectable = 1;
-	}
 }
 
 static void acpi_device_get_busid(struct acpi_device *device)
@@ -1891,7 +1840,6 @@ static acpi_status acpi_bus_check_add(acpi_handle handle, u32 lvl_not_used,
 	struct acpi_device *device = NULL;
 	int type;
 	unsigned long long sta;
-	acpi_status status;
 	int result;
 
 	acpi_bus_get_device(handle, &device);
@@ -1912,10 +1860,8 @@ static acpi_status acpi_bus_check_add(acpi_handle handle, u32 lvl_not_used,
 	if (!(sta & ACPI_STA_DEVICE_PRESENT) &&
 	    !(sta & ACPI_STA_DEVICE_FUNCTIONING)) {
 		struct acpi_device_wakeup wakeup;
-		acpi_handle temp;
 
-		status = acpi_get_handle(handle, "_PRW", &temp);
-		if (ACPI_SUCCESS(status)) {
+		if (acpi_has_method(handle, "_PRW")) {
 			acpi_bus_extract_wakeup_device_power_package(handle,
 								     &wakeup);
 			acpi_power_resources_list_free(&wakeup.resources);
-- 
1.8.1.2

