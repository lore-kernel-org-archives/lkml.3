Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253AbaBJX6J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 18:58:09 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:56442 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752659AbaBJX5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 18:57:20 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 2/3] ACPI / dock: Pass ACPI device pointer to acpi_device_is_battery()
Date: Tue, 11 Feb 2014 01:10:51 +0100
Message-ID: <3670100.egnJn4ezsJ@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <3728252.WpMGKRKmqq@vostro.rjw.lan>
References: <3728252.WpMGKRKmqq@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Since we already know what the device's PNP IDs are when
acpi_device_is_battery() is called, it is not necessary to run
acpi_get_object_info() for the device in that function.  Instead, if
acpi_device_is_battery() is passed a pointer to a struct acpi_device
object, it can use the list of PNP IDs from that object, so make that
happen and modify the function's header accordingly

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/dock.c     |    2 +-
 drivers/acpi/internal.h |    2 +-
 drivers/acpi/scan.c     |   24 +++++++++++-------------
 3 files changed, 13 insertions(+), 15 deletions(-)

Index: linux-pm/drivers/acpi/internal.h
===================================================================
--- linux-pm.orig/drivers/acpi/internal.h
+++ linux-pm/drivers/acpi/internal.h
@@ -97,7 +97,7 @@ void acpi_free_pnp_ids(struct acpi_devic
 int acpi_bind_one(struct device *dev, struct acpi_device *adev);
 int acpi_unbind_one(struct device *dev);
 bool acpi_device_is_present(struct acpi_device *adev);
-bool acpi_device_is_battery(acpi_handle handle);
+bool acpi_device_is_battery(struct acpi_device *adev);
 
 /* --------------------------------------------------------------------------
                                   Power Resource
Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -1662,24 +1662,22 @@ bool acpi_bay_match(acpi_handle handle)
 	return acpi_ata_match(phandle);
 }
 
-bool acpi_device_is_battery(acpi_handle handle)
+bool acpi_device_is_battery(struct acpi_device *adev)
 {
-	struct acpi_device_info *info;
-	bool ret = false;
-
-	if (!ACPI_SUCCESS(acpi_get_object_info(handle, &info)))
-		return false;
+	struct acpi_hardware_id *hwid;
 
-	if (info->valid & ACPI_VALID_HID)
-		ret = !strcmp("PNP0C0A", info->hardware_id.string);
+	list_for_each_entry(hwid, &adev->pnp.ids, list)
+		if (!strcmp("PNP0C0A", hwid->id))
+			return true;
 
-	kfree(info);
-	return ret;
+	return false;
 }
 
-static bool is_ejectable_bay(acpi_handle handle)
+static bool is_ejectable_bay(struct acpi_device *adev)
 {
-	if (acpi_has_method(handle, "_EJ0") && acpi_device_is_battery(handle))
+	acpi_handle handle = adev->handle;
+
+	if (acpi_has_method(handle, "_EJ0") && acpi_device_is_battery(adev))
 		return true;
 
 	return acpi_bay_match(handle);
@@ -1989,7 +1987,7 @@ static void acpi_scan_init_hotplug(struc
 {
 	struct acpi_hardware_id *hwid;
 
-	if (acpi_dock_match(adev->handle) || is_ejectable_bay(adev->handle)) {
+	if (acpi_dock_match(adev->handle) || is_ejectable_bay(adev)) {
 		acpi_dock_add(adev);
 		return;
 	}
Index: linux-pm/drivers/acpi/dock.c
===================================================================
--- linux-pm.orig/drivers/acpi/dock.c
+++ linux-pm/drivers/acpi/dock.c
@@ -796,7 +796,7 @@ void acpi_dock_add(struct acpi_device *a
 		dock_station->flags |= DOCK_IS_DOCK;
 	if (acpi_ata_match(handle))
 		dock_station->flags |= DOCK_IS_ATA;
-	if (acpi_device_is_battery(handle))
+	if (acpi_device_is_battery(adev))
 		dock_station->flags |= DOCK_IS_BAT;
 
 	ret = sysfs_create_group(&dd->dev.kobj, &dock_attribute_group);

