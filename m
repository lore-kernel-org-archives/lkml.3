Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007AbaBCXhx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 18:37:53 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:63395 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753004AbaBCX2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 18:28:22 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Aaron Lu <aaron.lu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>
Subject: [PATCH 18/24][Update] ACPI / hotplug: Fix potential race in acpi_bus_notify()
Date: Tue, 04 Feb 2014 00:36:10 +0100
Message-ID: <1957606.iEkqlTBjjf@vostro.rjw.lan>
User-Agent: KMail/4.11.4 (Linux/3.13.0+; KDE/4.11.4; x86_64; ; )
In-Reply-To: <7532948.aJNUotNMpR@vostro.rjw.lan>
References: <2217793.001RY6hKlo@vostro.rjw.lan> <20140203104408.GQ18029@intel.com> <7532948.aJNUotNMpR@vostro.rjw.lan>
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
 drivers/acpi/bus.c      |    6 ++++--
 drivers/acpi/scan.c     |   42 ++++++++++++++++++++++++++++++++++--------
 include/acpi/acpi_bus.h |    2 ++
 3 files changed, 40 insertions(+), 10 deletions(-)

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
@@ -512,12 +509,15 @@ static void acpi_hotplug_notify_cb(acpi_
 		/* non-hotplug event; possibly handled by other handler */
 		return;
 	}
-	get_device(&adev->dev);
+	adev = acpi_bus_get_acpi_device(handle);
+	if (!adev)
+		goto err_out;
+
 	status = acpi_hotplug_execute(acpi_device_hotplug, adev, type);
 	if (ACPI_SUCCESS(status))
 		return;
 
-	put_device(&adev->dev);
+	acpi_bus_put_acpi_device(adev);
 
  err_out:
 	acpi_evaluate_hotplug_ost(handle, type, ost_code, NULL);
@@ -1112,14 +1112,16 @@ static void acpi_scan_drop_device(acpi_h
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
@@ -1127,8 +1129,32 @@ int acpi_bus_get_device(acpi_handle hand
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
+struct acpi_device *acpi_bus_get_acpi_device(acpi_handle handle)
+{
+	struct acpi_device *adev = NULL;
+
+	acpi_get_device_data(handle, &adev, get_acpi_device);
+	return adev;
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
Index: linux-pm/drivers/acpi/bus.c
===================================================================
--- linux-pm.orig/drivers/acpi/bus.c
+++ linux-pm/drivers/acpi/bus.c
@@ -340,7 +340,7 @@ static void acpi_bus_osc_support(void)
  */
 static void acpi_bus_notify(acpi_handle handle, u32 type, void *data)
 {
-	struct acpi_device *device = NULL;
+	struct acpi_device *device;
 	struct acpi_driver *driver;
 
 	ACPI_DEBUG_PRINT((ACPI_DB_INFO, "Notification %#02x to handle %p\n",
@@ -387,12 +387,14 @@ static void acpi_bus_notify(acpi_handle
 		break;
 	}
 
-	acpi_bus_get_device(handle, &device);
+	device = acpi_bus_get_acpi_device(handle);
 	if (device) {
 		driver = device->driver;
 		if (driver && driver->ops.notify &&
 		    (driver->flags & ACPI_DRIVER_ALL_NOTIFY_EVENTS))
 			driver->ops.notify(device, type);
+
+		acpi_bus_put_acpi_device(device);
 	}
 }
 
Index: linux-pm/include/acpi/acpi_bus.h
===================================================================
--- linux-pm.orig/include/acpi/acpi_bus.h
+++ linux-pm/include/acpi/acpi_bus.h
@@ -381,6 +381,8 @@ extern int unregister_acpi_notifier(stru
  */
 
 int acpi_bus_get_device(acpi_handle handle, struct acpi_device **device);
+struct acpi_device *acpi_bus_get_acpi_device(acpi_handle handle);
+void acpi_bus_put_acpi_device(struct acpi_device *adev);
 acpi_status acpi_bus_get_status_handle(acpi_handle handle,
 				       unsigned long long *sta);
 int acpi_bus_get_status(struct acpi_device *device);
