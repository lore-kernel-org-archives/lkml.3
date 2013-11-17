Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754503Ab3KQQ0Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 11:26:25 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:60907 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752393Ab3KQQZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 11:25:48 -0500
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
Subject: [PATCH 8/10] ACPI / hotplug: Rework generic code to handle suprise removals
Date: Sun, 17 Nov 2013 17:36:42 +0100
Message-ID: <3525698.21F2z08v1h@vostro.rjw.lan>
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

The generic ACPI hotplug code used for several types of device
doesn't handle surprise removals, mostly because those devices
currently cannot be removed by surprise in the majority of systems.
However, surprise removals should be handled by that code as well
as surprise additions of devices, so make it do that.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/scan.c |   85 ++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 59 insertions(+), 26 deletions(-)

Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -276,18 +276,72 @@ static int acpi_scan_hot_remove(struct a
 	return 0;
 }
 
+static int acpi_scan_device_not_present(struct acpi_device *adev)
+{
+	if (!acpi_device_enumerated(adev)) {
+		dev_warn(&adev->dev, "Still not present\n");
+		return -EALREADY;
+	}
+	acpi_bus_trim(adev);
+	return 0;
+}
+
 static int acpi_scan_device_check(struct acpi_device *adev)
 {
 	int error;
 
+	acpi_bus_get_status(adev);
+	if (adev->status.present || adev->status.functional) {
+		/*
+		 * This function is only called for device objects for which
+		 * matching scan handlers exist.  The only situation in which
+		 * the scan handler is not attached to this device object yet
+		 * is when the device has just appeared (either it wasn't
+		 * present at all before or it was removed and then added
+		 * again).
+		 */
+		if (adev->handler) {
+			dev_warn(&adev->dev, "Already enumerated\n");
+			return -EALREADY;
+		}
+		error = acpi_bus_scan(adev->handle);
+		if (error) {
+			dev_warn(&adev->dev, "Namespace scan failure\n");
+			return error;
+		}
+		if (!adev->handler) {
+			dev_warn(&adev->dev, "Enumeration failure\n");
+			error = -ENODEV;
+		}
+	} else {
+		error = acpi_scan_device_not_present(adev);
+	}
+	return error;
+}
+
+static int acpi_scan_bus_check(struct acpi_device *adev)
+{
+	struct acpi_scan_handler *handler = adev->handler;
+	struct acpi_device *child;
+	int error;
+
+	acpi_bus_get_status(adev);
+	if (!(adev->status.present || adev->status.functional)) {
+		acpi_scan_device_not_present(adev);
+		return 0;
+	}
+	if (handler && handler->hotplug.scan_dependent)
+		return handler->hotplug.scan_dependent(adev);
+
 	error = acpi_bus_scan(adev->handle);
 	if (error) {
 		dev_warn(&adev->dev, "Namespace scan failure\n");
 		return error;
 	}
-	if (!adev->handler) {
-		dev_warn(&adev->dev, "Enumeration failure\n");
-		return -ENODEV;
+	list_for_each_entry(child, &adev->children, node) {
+		error = acpi_scan_bus_check(child);
+		if (error)
+			return error;
 	}
 	return 0;
 }
@@ -296,7 +350,6 @@ static void acpi_device_hotplug(void *da
 {
 	u32 ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE;
 	struct acpi_device *adev = data;
-	struct acpi_scan_handler *handler;
 	int error;
 
 	lock_device_hotplug();
@@ -310,32 +363,12 @@ static void acpi_device_hotplug(void *da
 	if (adev->handle == INVALID_ACPI_HANDLE)
 		goto out;
 
-	handler = adev->handler;
-
 	switch (src) {
 	case ACPI_NOTIFY_BUS_CHECK:
-		if (handler) {
-			error = handler->hotplug.scan_dependent ?
-					handler->hotplug.scan_dependent(adev) :
-					acpi_bus_scan(adev->handle);
-		} else {
-			error = acpi_scan_device_check(adev);
-		}
+		error = acpi_scan_bus_check(adev);
 		break;
 	case ACPI_NOTIFY_DEVICE_CHECK:
-		/*
-		 * This code is only run for device objects for which matching
-		 * scan handlers exist.  The only situation in which the scan
-		 * handler is not attached to this device object yet is when the
-		 * device has just appeared (either it wasn't present at all
-		 * before or it was removed and then added again).
-		 */
-		if (adev->handler) {
-			dev_warn(&adev->dev, "Already enumerated\n");
-			error = -EBUSY;
-		} else {
-			error = acpi_scan_device_check(adev);
-		}
+		error = acpi_scan_device_check(adev);
 		break;
 	case ACPI_NOTIFY_EJECT_REQUEST:
 	case ACPI_OST_EC_OSPM_EJECT:

