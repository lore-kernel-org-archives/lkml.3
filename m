Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756242Ab3KVXJn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 18:09:43 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:64770 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755840Ab3KVXJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 18:09:41 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Toshi Kani <toshi.kani@hp.com>,
        Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH] ACPI / scan: User direct recurrence for device hierarchy walks
Date: Sat, 23 Nov 2013 00:22:23 +0100
Message-ID: <1538742.Kb0j0zok76@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Rework acpi_bus_trim() and acpi_bus_device_attach(), which is
renamed as acpi_bus_attach(), to walk the list of each device
object's children directly and call themselves recursively for
each child instead of using acpi_walk_namespace().  This
simplifies the code quite a bit and avoids the overhead of
callbacks and the ACPICA's internal processing which are not
really necessary for these two routines.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---

Hi,

This is on top of the linux-pm/bleeding-edge branch that contains the series
I posted previously: http://marc.info/?l=linux-pci&m=138470560909690&w=4

Thanks,
Rafael

---
 drivers/acpi/scan.c |  120 +++++++++++++++++++---------------------------------
 1 file changed, 45 insertions(+), 75 deletions(-)

Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -1909,54 +1909,40 @@ static int acpi_scan_attach_handler(stru
 	return ret;
 }
 
-static acpi_status acpi_bus_device_attach(acpi_handle handle, u32 lvl_not_used,
-					  void *not_used, void **ret_not_used)
+static void acpi_bus_attach(struct acpi_device *device)
 {
-	struct acpi_device *device;
-	unsigned long long sta;
+	struct acpi_device *child;
 	int ret;
 
-	/*
-	 * Ignore errors ignored by acpi_bus_check_add() to avoid terminating
-	 * namespace walks prematurely.
-	 */
-	if (acpi_bus_type_and_status(handle, &ret, &sta))
-		return AE_OK;
-
-	if (acpi_bus_get_device(handle, &device))
-		return AE_CTRL_DEPTH;
-
-	acpi_set_device_status(device, sta);
+	acpi_bus_get_status(device);
 	/* Skip devices that are not present. */
-	if (!acpi_device_is_present(device))
-		goto err;
-
+	if (!acpi_device_is_present(device)) {
+		device->flags.visited = false;
+		return;
+	}
 	if (device->handler)
-		return AE_OK;
+		goto ok;
 
 	if (!device->flags.initialized) {
 		acpi_bus_update_power(device, NULL);
 		device->flags.initialized = true;
 	}
+	device->flags.visited = false;
 	ret = acpi_scan_attach_handler(device);
 	if (ret < 0)
-		goto err;
+		return;
 
 	device->flags.match_driver = true;
-	if (ret > 0)
-		goto ok;
-
-	ret = device_attach(&device->dev);
-	if (ret < 0)
-		goto err;
-
- ok:
+	if (!ret) {
+		ret = device_attach(&device->dev);
+		if (ret < 0)
+			return;
+	}
 	device->flags.visited = true;
-	return AE_OK;
 
- err:
-	device->flags.visited = false;
-	return AE_CTRL_DEPTH;
+ ok:
+	list_for_each_entry(child, &device->children, node)
+		acpi_bus_attach(child);
 }
 
 /**
@@ -1976,64 +1962,48 @@ static acpi_status acpi_bus_device_attac
 int acpi_bus_scan(acpi_handle handle)
 {
 	void *device = NULL;
-	int error = 0;
 
 	if (ACPI_SUCCESS(acpi_bus_check_add(handle, 0, NULL, &device)))
 		acpi_walk_namespace(ACPI_TYPE_ANY, handle, ACPI_UINT32_MAX,
 				    acpi_bus_check_add, NULL, NULL, &device);
 
-	if (!device)
-		error = -ENODEV;
-	else if (ACPI_SUCCESS(acpi_bus_device_attach(handle, 0, NULL, NULL)))
-		acpi_walk_namespace(ACPI_TYPE_ANY, handle, ACPI_UINT32_MAX,
-				    acpi_bus_device_attach, NULL, NULL, NULL);
-
-	return error;
-}
-EXPORT_SYMBOL(acpi_bus_scan);
-
-static acpi_status acpi_bus_device_detach(acpi_handle handle, u32 lvl_not_used,
-					  void *not_used, void **ret_not_used)
-{
-	struct acpi_device *device = NULL;
-
-	if (!acpi_bus_get_device(handle, &device)) {
-		struct acpi_scan_handler *dev_handler = device->handler;
-
-		if (dev_handler) {
-			if (dev_handler->detach)
-				dev_handler->detach(device);
-
-			device->handler = NULL;
-		} else {
-			device_release_driver(&device->dev);
-		}
-		/*
-		 * Most likely, the device is going away, so put it into D3cold
-		 * before that.
-		 */
-		acpi_device_set_power(device, ACPI_STATE_D3_COLD);
-		device->flags.initialized = false;
-		device->flags.visited = false;
+	if (device) {
+		acpi_bus_attach(device);
+		return 0;
 	}
-	return AE_OK;
+	return -ENODEV;
 }
+EXPORT_SYMBOL(acpi_bus_scan);
 
 /**
- * acpi_bus_trim - Remove ACPI device node and all of its descendants
- * @start: Root of the ACPI device nodes subtree to remove.
+ * acpi_bus_trim - Detach scan handlers and drivers from ACPI device objects.
+ * @adev: Root of the ACPI namespace scope to walk.
  *
  * Must be called under acpi_scan_lock.
  */
-void acpi_bus_trim(struct acpi_device *start)
+void acpi_bus_trim(struct acpi_device *adev)
 {
+	struct acpi_scan_handler *handler = adev->handler;
+	struct acpi_device *child;
+
+	list_for_each_entry_reverse(child, &adev->children, node)
+		acpi_bus_trim(child);
+
+	if (handler) {
+		if (handler->detach)
+			handler->detach(adev);
+
+		adev->handler = NULL;
+	} else {
+		device_release_driver(&adev->dev);
+	}
 	/*
-	 * Execute acpi_bus_device_detach() as a post-order callback to detach
-	 * all ACPI drivers from the device nodes being removed.
+	 * Most likely, the device is going away, so put it into D3cold before
+	 * that.
 	 */
-	acpi_walk_namespace(ACPI_TYPE_ANY, start->handle, ACPI_UINT32_MAX, NULL,
-			    acpi_bus_device_detach, NULL, NULL);
-	acpi_bus_device_detach(start->handle, 0, NULL, NULL);
+	acpi_device_set_power(adev, ACPI_STATE_D3_COLD);
+	adev->flags.initialized = false;
+	adev->flags.visited = false;
 }
 EXPORT_SYMBOL_GPL(acpi_bus_trim);
 

