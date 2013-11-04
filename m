Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753409Ab3KDN0D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 08:26:03 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:50124 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751632Ab3KDN0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 08:26:00 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Linux PCI <linux-pci@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>, Toshi Kani <toshi.kani@hp.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: [Update][PATCH 6/6] ACPI / hotplug: Merge device hot-removal routines
Date: Mon, 04 Nov 2013 14:36:58 +0100
Message-ID: <7014358.W2jKmobrlg@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <2970389.SeMGM45Qln@vostro.rjw.lan>
References: <5839747.7HXXGHmMBd@vostro.rjw.lan> <2970389.SeMGM45Qln@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

There is no real reasn why acpi_bus_device_eject() and
acpi_bus_hot_remove_device() should work differently, so rework
acpi_bus_device_eject() so that it can be called internally by
both acpi_bus_hot_remove_device() and acpi_eject_store_work().
Accordingly, rework acpi_hotplug_notify_cb() to queue up the
execution of acpi_bus_hot_remove_device() through
acpi_os_hotplug_execute() on eject request notifications.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/scan.c |   84 +++++++++++++++++++++++-----------------------------
 1 file changed, 38 insertions(+), 46 deletions(-)

Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -285,10 +285,9 @@ static int acpi_scan_hot_remove(struct a
 	return 0;
 }
 
-static void acpi_bus_device_eject(void *context)
+static void acpi_bus_device_eject(struct acpi_device *device, u32 ost_src)
 {
-	acpi_handle handle = context;
-	struct acpi_device *device = NULL;
+	acpi_handle handle = device->handle;
 	struct acpi_scan_handler *handler;
 	u32 ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE;
 	int error;
@@ -296,20 +295,19 @@ static void acpi_bus_device_eject(void *
 	lock_device_hotplug();
 	mutex_lock(&acpi_scan_lock);
 
-	acpi_bus_get_device(handle, &device);
-	if (!device)
-		goto err_out;
-
 	handler = device->handler;
-	if (!handler || !handler->hotplug.enabled)
+	if (!handler || !handler->hotplug.enabled) {
+		put_device(&device->dev);
 		goto err_support;
+	}
+
+	if (ost_src == ACPI_NOTIFY_EJECT_REQUEST)
+		acpi_evaluate_hotplug_ost(handle, ACPI_NOTIFY_EJECT_REQUEST,
+					  ACPI_OST_SC_EJECT_IN_PROGRESS, NULL);
 
-	acpi_evaluate_hotplug_ost(handle, ACPI_NOTIFY_EJECT_REQUEST,
-				  ACPI_OST_SC_EJECT_IN_PROGRESS, NULL);
 	if (handler->hotplug.mode == AHM_CONTAINER)
 		kobject_uevent(&device->dev.kobj, KOBJ_OFFLINE);
 
-	get_device(&device->dev);
 	error = acpi_scan_hot_remove(device);
 	if (error == -EPERM) {
 		goto err_support;
@@ -325,8 +323,7 @@ static void acpi_bus_device_eject(void *
  err_support:
 	ost_code = ACPI_OST_SC_EJECT_NOT_SUPPORTED;
  err_out:
-	acpi_evaluate_hotplug_ost(handle, ACPI_NOTIFY_EJECT_REQUEST, ost_code,
-				  NULL);
+	acpi_evaluate_hotplug_ost(handle, ost_src, ost_code, NULL);
 	goto out;
 }
 
@@ -408,10 +405,20 @@ static void acpi_hotplug_unsupported(acp
 	acpi_evaluate_hotplug_ost(handle, type, ost_status, NULL);
 }
 
+/**
+ * acpi_bus_hot_remove_device: Hot-remove a device and its children.
+ * @context: Address of the ACPI device object to hot-remove.
+ */
+void acpi_bus_hot_remove_device(void *context)
+{
+	acpi_bus_device_eject(context, ACPI_NOTIFY_EJECT_REQUEST);
+}
+
 static void acpi_hotplug_notify_cb(acpi_handle handle, u32 type, void *data)
 {
 	acpi_osd_exec_callback callback;
 	struct acpi_scan_handler *handler = data;
+	struct acpi_device *adev;
 	acpi_status status;
 
 	if (!handler->hotplug.enabled)
@@ -428,44 +435,29 @@ static void acpi_hotplug_notify_cb(acpi_
 		break;
 	case ACPI_NOTIFY_EJECT_REQUEST:
 		acpi_handle_debug(handle, "ACPI_NOTIFY_EJECT_REQUEST event\n");
-		callback = acpi_bus_device_eject;
-		break;
+		status = acpi_bus_get_device(handle, &adev);
+		if (ACPI_FAILURE(status))
+			goto err_out;
+
+		get_device(&adev->dev);
+		callback = acpi_bus_hot_remove_device;
+		status = acpi_os_hotplug_execute(callback, adev);
+		if (ACPI_SUCCESS(status))
+			return;
+
+		put_device(&adev->dev);
+		goto err_out;
 	default:
 		/* non-hotplug event; possibly handled by other handler */
 		return;
 	}
 	status = acpi_os_hotplug_execute(callback, handle);
-	if (ACPI_FAILURE(status))
-		acpi_evaluate_hotplug_ost(handle, type,
-					  ACPI_OST_SC_NON_SPECIFIC_FAILURE,
-					  NULL);
-}
-
-void __acpi_bus_hot_remove_device(struct acpi_device *device, u32 ost_src)
-{
-	acpi_handle handle = device->handle;
-	int error;
-
-	lock_device_hotplug();
-	mutex_lock(&acpi_scan_lock);
-
-	error = acpi_scan_hot_remove(device);
-	if (error && handle)
-		acpi_evaluate_hotplug_ost(handle, ost_src,
-					  ACPI_OST_SC_NON_SPECIFIC_FAILURE,
-					  NULL);
-
-	mutex_unlock(&acpi_scan_lock);
-	unlock_device_hotplug();
-}
+	if (ACPI_SUCCESS(status))
+		return;
 
-/**
- * acpi_bus_hot_remove_device: Hot-remove a device and its children.
- * @context: Address of the ACPI device object to hot-remove.
- */
-void acpi_bus_hot_remove_device(void *context)
-{
-	__acpi_bus_hot_remove_device(context, ACPI_NOTIFY_EJECT_REQUEST);
+ err_out:
+	acpi_evaluate_hotplug_ost(handle, type,
+				  ACPI_OST_SC_NON_SPECIFIC_FAILURE, NULL);
 }
 
 static ssize_t real_power_state_show(struct device *dev,
@@ -496,7 +488,7 @@ static DEVICE_ATTR(power_state, 0444, po
 
 static void acpi_eject_store_work(void *context)
 {
-	__acpi_bus_hot_remove_device(context, ACPI_OST_EC_OSPM_EJECT);
+	acpi_bus_device_eject(context, ACPI_OST_EC_OSPM_EJECT);
 }
 
 static ssize_t
