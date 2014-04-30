Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759716AbaD3W7i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 18:59:38 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:63940 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759696AbaD3W7g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 18:59:36 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] ACPI / notify: Clean up handling of hotplug events
Date: Thu, 01 May 2014 01:16:06 +0200
Message-ID: <1731450.Q9aoSFhfhv@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Make the handling of hotplug events in acpi_bus_notify() slightly
cleaner by using an extra local variable to indicate when
acpi_hotplug_schedule() should be called.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/bus.c |   18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

Index: linux-pm/drivers/acpi/bus.c
===================================================================
--- linux-pm.orig/drivers/acpi/bus.c
+++ linux-pm/drivers/acpi/bus.c
@@ -340,16 +340,18 @@ static void acpi_bus_notify(acpi_handle
 {
 	struct acpi_device *adev;
 	struct acpi_driver *driver;
-	acpi_status status;
 	u32 ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE;
+	bool hotplug_event = false;
 
 	switch (type) {
 	case ACPI_NOTIFY_BUS_CHECK:
 		acpi_handle_debug(handle, "ACPI_NOTIFY_BUS_CHECK event\n");
+		hotplug_event = true;
 		break;
 
 	case ACPI_NOTIFY_DEVICE_CHECK:
 		acpi_handle_debug(handle, "ACPI_NOTIFY_DEVICE_CHECK event\n");
+		hotplug_event = true;
 		break;
 
 	case ACPI_NOTIFY_DEVICE_WAKE:
@@ -358,6 +360,7 @@ static void acpi_bus_notify(acpi_handle
 
 	case ACPI_NOTIFY_EJECT_REQUEST:
 		acpi_handle_debug(handle, "ACPI_NOTIFY_EJECT_REQUEST event\n");
+		hotplug_event = true;
 		break;
 
 	case ACPI_NOTIFY_DEVICE_CHECK_LIGHT:
@@ -393,16 +396,9 @@ static void acpi_bus_notify(acpi_handle
 	    (driver->flags & ACPI_DRIVER_ALL_NOTIFY_EVENTS))
 		driver->ops.notify(adev, type);
 
-	switch (type) {
-	case ACPI_NOTIFY_BUS_CHECK:
-	case ACPI_NOTIFY_DEVICE_CHECK:
-	case ACPI_NOTIFY_EJECT_REQUEST:
-		status = acpi_hotplug_schedule(adev, type);
-		if (ACPI_SUCCESS(status))
-			return;
-	default:
-		break;
-	}
+	if (hotplug_event && ACPI_SUCCESS(acpi_hotplug_schedule(adev, type)))
+		return;
+
 	acpi_bus_put_acpi_device(adev);
 	return;
 

