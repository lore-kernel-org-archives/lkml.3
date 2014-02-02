Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752317AbaBBRHR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 12:07:17 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:51382 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752056AbaBBRGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 12:06:25 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Aaron Lu <aaron.lu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Robert Moore <robert.moore@intel.com>
Subject: [PATCH v3 2/7] ACPI / hotplug: Fix potential races in notify handlers
Date: Sun, 02 Feb 2014 18:15:02 +0100
Message-ID: <1499994.Za93jVWRjt@vostro.rjw.lan>
User-Agent: KMail/4.11.4 (Linux/3.13.0+; KDE/4.11.4; x86_64; ; )
In-Reply-To: <5157096.hCmU2aoKCT@vostro.rjw.lan>
References: <2217793.001RY6hKlo@vostro.rjw.lan> <1519631.YS65c9Af2C@vostro.rjw.lan> <5157096.hCmU2aoKCT@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

There is a slight possibility for the ACPI device object pointed to
by adev in acpi_hotplug_notify_cb() to become invalid between the
acpi_bus_get_device() that it comes from and the subsequent dereference
of that pointer under get_device().  Namely, if acpi_scan_drop_device()
runs in parallel with acpi_hotplug_notify_cb(), acpi_device_del_work_fn()
queued up by it may delete the device object in question right after
a successful execution of acpi_bus_get_device() in acpi_bus_notify().

An analogous problem is present in acpi_bus_notify() where the device
pointer coming from acpi_bus_get_device() may become invalid before
it subsequent dereference in the "if" block.

To prevent that from happening, introduce a new function,
acpi_bus_get_acpi_device(), working analogously to acpi_bus_get_device()
except that it will grab a reference to the ACPI device object returned
by it and it will do that under the ACPICA's namespace mutex.  Then,
make both acpi_hotplug_notify_cb() and acpi_bus_notify() use
acpi_bus_get_acpi_device() instead of acpi_bus_get_device() so as to
ensure that the pointers used by them will not become stale at one
point.

In addition to that, introduce acpi_bus_put_acpi_device() as a wrapper
around put_device() to be used along with acpi_bus_get_acpi_device()
and make the (new) users of the latter use acpi_bus_put_acpi_device()
too.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/bus.c      |    4 +++-
 drivers/acpi/internal.h |    2 ++
 drivers/acpi/scan.c     |   38 ++++++++++++++++++++++++++++++--------
 3 files changed, 35 insertions(+), 9 deletions(-)

Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -476,7 +476,7 @@ static void acpi_device_hotplug(void *da
 
  out:
 	acpi_evaluate_hotplug_ost(adev->handle, src, ost_code, NULL);
-	put_device(&adev->dev);
+	acpi_bus_put_acpi_device(adev);
 	mutex_unlock(&acpi_scan_lock);
 	unlock_device_hotplug();
 }
@@ -488,9 +488,6 @@ static void acpi_hotplug_notify_cb(acpi_
 	struct acpi_device *adev;
 	acpi_status status;
 
-	if (acpi_bus_get_device(handle, &adev))
-		goto err_out;
-
 	switch (type) {
 	case ACPI_NOTIFY_BUS_CHECK:
 		acpi_handle_debug(handle, "ACPI_NOTIFY_BUS_CHECK event\n");
@@ -512,12 +509,14 @@ static void acpi_hotplug_notify_cb(acpi_
 		/* non-hotplug event; possibly handled by other handler */
 		return;
 	}
-	get_device(&adev->dev);
+	if (acpi_bus_get_acpi_device(handle, &adev))
+		goto err_out;
+
 	status = acpi_hotplug_execute(acpi_device_hotplug, adev, type);
 	if (ACPI_SUCCESS(status))
 		return;
 
-	put_device(&adev->dev);
+	acpi_bus_put_acpi_device(adev);
 
  err_out:
 	acpi_evaluate_hotplug_ost(handle, type, ost_code, NULL);
@@ -1112,14 +1111,16 @@ static void acpi_scan_drop_device(acpi_h
 	mutex_unlock(&acpi_device_del_lock);
 }
 
-int acpi_bus_get_device(acpi_handle handle, struct acpi_device **device)
+static int acpi_get_device_data(acpi_handle handle, struct acpi_device **device,
+				void (*callback)(void *))
 {
 	acpi_status status;
 
 	if (!device)
 		return -EINVAL;
 
-	status = acpi_get_data(handle, acpi_scan_drop_device, (void **)device);
+	status = acpi_get_data_full(handle, acpi_scan_drop_device,
+				    (void **)device, callback);
 	if (ACPI_FAILURE(status) || !*device) {
 		ACPI_DEBUG_PRINT((ACPI_DB_INFO, "No context for object [%p]\n",
 				  handle));
@@ -1127,8 +1128,29 @@ int acpi_bus_get_device(acpi_handle hand
 	}
 	return 0;
 }
+
+int acpi_bus_get_device(acpi_handle handle, struct acpi_device **device)
+{
+	return acpi_get_device_data(handle, device, NULL);
+}
 EXPORT_SYMBOL(acpi_bus_get_device);
 
+static void get_acpi_device(void *dev)
+{
+	if (dev)
+		get_device(&((struct acpi_device *)dev)->dev);
+}
+
+int acpi_bus_get_acpi_device(acpi_handle handle, struct acpi_device **adev_p)
+{
+	return acpi_get_device_data(handle, adev_p, get_acpi_device);
+}
+
+void acpi_bus_put_acpi_device(struct acpi_device *adev)
+{
+	put_device(&adev->dev);
+}
+
 int acpi_device_add(struct acpi_device *device,
 		    void (*release)(struct device *))
 {
Index: linux-pm/drivers/acpi/internal.h
===================================================================
--- linux-pm.orig/drivers/acpi/internal.h
+++ linux-pm/drivers/acpi/internal.h
@@ -81,6 +81,8 @@ bool acpi_scan_is_offline(struct acpi_de
 #define ACPI_STA_DEFAULT (ACPI_STA_DEVICE_PRESENT | ACPI_STA_DEVICE_ENABLED | \
 			  ACPI_STA_DEVICE_UI | ACPI_STA_DEVICE_FUNCTIONING)
 
+int acpi_bus_get_acpi_device(acpi_handle handle, struct acpi_device **adev_p);
+void acpi_bus_put_acpi_device(struct acpi_device *adev);
 int acpi_device_add(struct acpi_device *device,
 		    void (*release)(struct device *));
 void acpi_init_device_object(struct acpi_device *device, acpi_handle handle,
Index: linux-pm/drivers/acpi/bus.c
===================================================================
--- linux-pm.orig/drivers/acpi/bus.c
+++ linux-pm/drivers/acpi/bus.c
@@ -387,12 +387,14 @@ static void acpi_bus_notify(acpi_handle
 		break;
 	}
 
-	acpi_bus_get_device(handle, &device);
+	acpi_bus_get_acpi_device(handle, &device);
 	if (device) {
 		driver = device->driver;
 		if (driver && driver->ops.notify &&
 		    (driver->flags & ACPI_DRIVER_ALL_NOTIFY_EVENTS))
 			driver->ops.notify(device, type);
+
+		acpi_bus_put_acpi_device(device);
 	}
 }
 

