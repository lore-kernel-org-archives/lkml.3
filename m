Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754621Ab3KQQ2A (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 11:28:00 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:51918 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753969Ab3KQQZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 11:25:50 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        "Moore, Robert" <robert.moore@intel.com>,
        Toshi Kani <toshi.kani@hp.com>, Yinghai Lu <yinghai@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>, Lv Zheng <lv.zheng@intel.com>
Subject: [PATCH 5/10] ACPI / hotplug: Introduce common hotplug function acpi_device_hotplug()
Date: Sun, 17 Nov 2013 17:34:26 +0100
Message-ID: <11541490.l6IsuUiTQs@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1421028.Rsfpmhnym3@vostro.rjw.lan>
References: <1421028.Rsfpmhnym3@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Modify the common ACPI device hotplug code to always queue up the
same function, acpi_device_hotplug(), using acpi_hotplug_execute()
and make the PCI host bridge hotplug code use that function too for
device hot removal.

This allows some code duplication to be reduced and a race condition
where the relevant ACPI handle may become invalid between the
notification handler and the function queued up by it via
acpi_hotplug_execute() to be avoided.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/internal.h |    2 
 drivers/acpi/pci_root.c |    4 +
 drivers/acpi/scan.c     |  141 +++++++++++++++++++++---------------------------
 3 files changed, 68 insertions(+), 79 deletions(-)

Index: linux-pm/drivers/acpi/internal.h
===================================================================
--- linux-pm.orig/drivers/acpi/internal.h
+++ linux-pm/drivers/acpi/internal.h
@@ -89,7 +89,7 @@ void acpi_device_add_finalize(struct acp
 void acpi_free_pnp_ids(struct acpi_device_pnp *pnp);
 int acpi_bind_one(struct device *dev, acpi_handle handle);
 int acpi_unbind_one(struct device *dev);
-void acpi_bus_device_eject(void *data, u32 ost_src);
+void acpi_device_hotplug(void *data, u32 ost_src);
 bool acpi_device_is_present(struct acpi_device *adev);
 
 /* --------------------------------------------------------------------------
Index: linux-pm/drivers/acpi/pci_root.c
===================================================================
--- linux-pm.orig/drivers/acpi/pci_root.c
+++ linux-pm/drivers/acpi/pci_root.c
@@ -680,11 +680,13 @@ static void hotplug_event_root(void *dat
 		if (!root)
 			break;
 
+		acpi_evaluate_hotplug_ost(handle, ACPI_NOTIFY_EJECT_REQUEST,
+					  ACPI_OST_SC_EJECT_IN_PROGRESS, NULL);
 		get_device(&root->device->dev);
 
 		acpi_scan_lock_release();
 
-		acpi_bus_device_eject(root->device, ACPI_NOTIFY_EJECT_REQUEST);
+		acpi_device_hotplug(root->device, ACPI_NOTIFY_EJECT_REQUEST);
 		return;
 	default:
 		acpi_handle_warn(handle,
Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -206,12 +206,8 @@ static int acpi_scan_hot_remove(struct a
 	acpi_status status;
 	unsigned long long sta;
 
-	/* If there is no handle, the device node has been unregistered. */
-	if (!handle) {
-		dev_dbg(&device->dev, "ACPI handle missing\n");
-		put_device(&device->dev);
-		return -EINVAL;
-	}
+	if (device->handler && device->handler->hotplug.mode == AHM_CONTAINER)
+		kobject_uevent(&device->dev.kobj, KOBJ_OFFLINE);
 
 	/*
 	 * Carry out two passes here and ignore errors in the first pass,
@@ -230,7 +226,6 @@ static int acpi_scan_hot_remove(struct a
 		dev_warn(errdev, "Offline disabled.\n");
 		acpi_walk_namespace(ACPI_TYPE_ANY, handle, ACPI_UINT32_MAX,
 				    acpi_bus_online, NULL, NULL, NULL);
-		put_device(&device->dev);
 		return -EPERM;
 	}
 	acpi_bus_offline(handle, 0, (void *)false, (void **)&errdev);
@@ -249,7 +244,6 @@ static int acpi_scan_hot_remove(struct a
 			acpi_walk_namespace(ACPI_TYPE_ANY, handle,
 					    ACPI_UINT32_MAX, acpi_bus_online,
 					    NULL, NULL, NULL);
-			put_device(&device->dev);
 			return -EBUSY;
 		}
 	}
@@ -259,9 +253,6 @@ static int acpi_scan_hot_remove(struct a
 
 	acpi_bus_trim(device);
 
-	put_device(&device->dev);
-	device = NULL;
-
 	acpi_evaluate_lck(handle, 0);
 	/*
 	 * TBD: _EJD support.
@@ -288,77 +279,74 @@ static int acpi_scan_hot_remove(struct a
 	return 0;
 }
 
-void acpi_bus_device_eject(void *data, u32 ost_src)
+static int acpi_scan_device_check(struct acpi_device *adev)
 {
-	struct acpi_device *device = data;
-	acpi_handle handle = device->handle;
-	u32 ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE;
 	int error;
 
-	lock_device_hotplug();
-	mutex_lock(&acpi_scan_lock);
-
-	if (ost_src == ACPI_NOTIFY_EJECT_REQUEST)
-		acpi_evaluate_hotplug_ost(handle, ACPI_NOTIFY_EJECT_REQUEST,
-					  ACPI_OST_SC_EJECT_IN_PROGRESS, NULL);
-
-	if (device->handler && device->handler->hotplug.mode == AHM_CONTAINER)
-		kobject_uevent(&device->dev.kobj, KOBJ_OFFLINE);
-
-	error = acpi_scan_hot_remove(device);
-	if (error == -EPERM) {
-		goto err_support;
-	} else if (error) {
-		goto err_out;
+	/*
+	 * This function is only called for device objects for which matching
+	 * scan handlers exist.  The only situation in which the scan handler is
+	 * not attached to this device object yet is when the device has just
+	 * appeared (either it wasn't present at all before or it was removed
+	 * and then added again).
+	 */
+	if (adev->handler) {
+		dev_warn(&adev->dev, "Already enumerated\n");
+		return -EBUSY;
 	}
-
- out:
-	mutex_unlock(&acpi_scan_lock);
-	unlock_device_hotplug();
-	return;
-
- err_support:
-	ost_code = ACPI_OST_SC_EJECT_NOT_SUPPORTED;
- err_out:
-	acpi_evaluate_hotplug_ost(handle, ost_src, ost_code, NULL);
-	goto out;
+	error = acpi_bus_scan(adev->handle);
+	if (error) {
+		dev_warn(&adev->dev, "Namespace scan failure\n");
+		return error;
+	}
+	if (adev->handler) {
+		if (adev->handler->hotplug.mode == AHM_CONTAINER)
+			kobject_uevent(&adev->dev.kobj, KOBJ_ONLINE);
+	} else {
+		dev_warn(&adev->dev, "Enumeration failure\n");
+		return -ENODEV;
+	}
+	return 0;
 }
 
-static void acpi_scan_bus_device_check(void *data, u32 ost_source)
+void acpi_device_hotplug(void *data, u32 src)
 {
-	acpi_handle handle = data;
-	struct acpi_device *device;
 	u32 ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE;
+	struct acpi_device *adev = data;
 	int error;
 
 	lock_device_hotplug();
 	mutex_lock(&acpi_scan_lock);
 
-	if (ost_source != ACPI_NOTIFY_BUS_CHECK) {
-		device = NULL;
-		acpi_bus_get_device(handle, &device);
-		if (acpi_device_enumerated(device)) {
-			dev_warn(&device->dev, "Attempt to re-insert\n");
-			goto out;
-		}
-	}
-	error = acpi_bus_scan(handle);
-	if (error) {
-		acpi_handle_warn(handle, "Namespace scan failure\n");
-		goto out;
-	}
-	device = NULL;
-	acpi_bus_get_device(handle, &device);
-	if (!acpi_device_enumerated(device)) {
-		acpi_handle_warn(handle, "Device not enumerated\n");
+	/*
+	 * The device object's ACPI handle cannot become invalid as long as we
+	 * are holding acpi_scan_lock, but it may have become invalid before
+	 * that lock was acquired.
+	 */
+	if (adev->handle == INVALID_ACPI_HANDLE)
 		goto out;
+
+	switch (src) {
+	case ACPI_NOTIFY_BUS_CHECK:
+		error = acpi_bus_scan(adev->handle);
+		break;
+	case ACPI_NOTIFY_DEVICE_CHECK:
+		error = acpi_scan_device_check(adev);
+		break;
+	case ACPI_NOTIFY_EJECT_REQUEST:
+	case ACPI_OST_EC_OSPM_EJECT:
+		error = acpi_scan_hot_remove(adev);
+		break;
+	default:
+		error = -EINVAL;
+		break;
 	}
-	ost_code = ACPI_OST_SC_SUCCESS;
-	if (device->handler && device->handler->hotplug.mode == AHM_CONTAINER)
-		kobject_uevent(&device->dev.kobj, KOBJ_ONLINE);
+	if (!error)
+		ost_code = ACPI_OST_SC_SUCCESS;
 
  out:
-	acpi_evaluate_hotplug_ost(handle, ost_source, ost_code, NULL);
+	acpi_evaluate_hotplug_ost(adev->handle, src, ost_code, NULL);
+	put_device(&adev->dev);
 	mutex_unlock(&acpi_scan_lock);
 	unlock_device_hotplug();
 }
@@ -370,6 +358,9 @@ static void acpi_hotplug_notify_cb(acpi_
 	struct acpi_device *adev;
 	acpi_status status;
 
+	if (acpi_bus_get_device(handle, &adev))
+		goto err_out;
+
 	switch (type) {
 	case ACPI_NOTIFY_BUS_CHECK:
 		acpi_handle_debug(handle, "ACPI_NOTIFY_BUS_CHECK event\n");
@@ -384,24 +375,20 @@ static void acpi_hotplug_notify_cb(acpi_
 			ost_code = ACPI_OST_SC_EJECT_NOT_SUPPORTED;
 			goto err_out;
 		}
-		if (acpi_bus_get_device(handle, &adev))
-			goto err_out;
-
-		get_device(&adev->dev);
-		status = acpi_hotplug_execute(acpi_bus_device_eject, adev, type);
-		if (ACPI_SUCCESS(status))
-			return;
-
-		put_device(&adev->dev);
-		goto err_out;
+		acpi_evaluate_hotplug_ost(handle, ACPI_NOTIFY_EJECT_REQUEST,
+					  ACPI_OST_SC_EJECT_IN_PROGRESS, NULL);
+		break;
 	default:
 		/* non-hotplug event; possibly handled by other handler */
 		return;
 	}
-	status = acpi_hotplug_execute(acpi_scan_bus_device_check, handle, type);
+	get_device(&adev->dev);
+	status = acpi_hotplug_execute(acpi_device_hotplug, adev, type);
 	if (ACPI_SUCCESS(status))
 		return;
 
+	put_device(&adev->dev);
+
  err_out:
 	acpi_evaluate_hotplug_ost(handle, type, ost_code, NULL);
 }
@@ -454,7 +441,7 @@ acpi_eject_store(struct device *d, struc
 	acpi_evaluate_hotplug_ost(acpi_device->handle, ACPI_OST_EC_OSPM_EJECT,
 				  ACPI_OST_SC_EJECT_IN_PROGRESS, NULL);
 	get_device(&acpi_device->dev);
-	status = acpi_hotplug_execute(acpi_bus_device_eject, acpi_device,
+	status = acpi_hotplug_execute(acpi_device_hotplug, acpi_device,
 				      ACPI_OST_EC_OSPM_EJECT);
 	if (ACPI_SUCCESS(status))
 		return count;

