Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756081AbaA1Xvr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 18:51:47 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:61298 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755938AbaA1Xu1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 18:50:27 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Aaron Lu <aaron.lu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [Update][PATCH 4/5][RFT] ACPI / hotplug / PCI: Simplify acpi_install_hotplug_notify_handler()
Date: Wed, 29 Jan 2014 01:00:57 +0100
Message-ID: <18315277.jcVt0SJ67s@vostro.rjw.lan>
User-Agent: KMail/4.11.4 (Linux/3.13.0+; KDE/4.11.4; x86_64; ; )
In-Reply-To: <1693151.2qrLZHyp0o@vostro.rjw.lan>
References: <2217793.001RY6hKlo@vostro.rjw.lan> <1508034.JFmpIOzjVZ@vostro.rjw.lan> <1693151.2qrLZHyp0o@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Use the observation that the ACPI scan handler of the device object
in acpi_hotplug_notify_cb() can be obtained from that device object's
handler pointer and do not pass it as data to
acpi_install_hotplug_notify_handler() in acpi_scan_init_hotplug().

That allows the second argument of acpi_install_hotplug_notify_handler()
to be dropped, so do it and update its callers accordingly.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/scan.c                |   31 ++++++++++++++++++-------------
 drivers/pci/hotplug/acpiphp_glue.c |    2 +-
 include/acpi/acpi_bus.h            |    2 +-
 3 files changed, 20 insertions(+), 15 deletions(-)

Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -487,7 +487,6 @@ static void acpi_device_hotplug(void *da
 
 static void acpi_hotplug_notify_cb(acpi_handle handle, u32 type, void *data)
 {
-	struct acpi_scan_handler *handler = data;
 	u32 ost_code = ACPI_OST_SC_SUCCESS;
 	struct acpi_device *adev;
 	acpi_status status;
@@ -503,13 +502,6 @@ static void acpi_hotplug_notify_cb(acpi_
 
 	case ACPI_NOTIFY_EJECT_REQUEST:
 		acpi_handle_debug(handle, "ACPI_NOTIFY_EJECT_REQUEST event\n");
-		if (handler && !handler->hotplug.enabled) {
-			acpi_handle_err(handle, "Eject disabled\n");
-			ost_code = ACPI_OST_SC_EJECT_NOT_SUPPORTED;
-			goto out;
-		}
-		acpi_evaluate_hotplug_ost(handle, ACPI_NOTIFY_EJECT_REQUEST,
-					  ACPI_OST_SC_EJECT_IN_PROGRESS, NULL);
 		break;
 
 	case ACPI_NOTIFY_DEVICE_WAKE:
@@ -535,11 +527,24 @@ static void acpi_hotplug_notify_cb(acpi_
 		goto out;
 	}
 
+	mutex_lock(&acpi_scan_lock);
 	ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE;
-	if (acpi_bus_get_device(handle, &adev))
+	if (acpi_bus_get_device(handle, &adev)) {
+		mutex_unlock(&acpi_scan_lock);
 		goto out;
-
+	}
+	if (type == ACPI_NOTIFY_EJECT_REQUEST) {
+		if (adev->handler && !adev->handler->hotplug.enabled) {
+			acpi_handle_err(handle, "Eject disabled\n");
+			ost_code = ACPI_OST_SC_EJECT_NOT_SUPPORTED;
+			mutex_unlock(&acpi_scan_lock);
+			goto out;
+		}
+		acpi_evaluate_hotplug_ost(handle, ACPI_NOTIFY_EJECT_REQUEST,
+					  ACPI_OST_SC_EJECT_IN_PROGRESS, NULL);
+	}
 	get_device(&adev->dev);
+	mutex_unlock(&acpi_scan_lock);
 	status = acpi_hotplug_execute(acpi_device_hotplug, adev, type);
 	if (ACPI_SUCCESS(status))
 		return;
@@ -550,10 +555,10 @@ static void acpi_hotplug_notify_cb(acpi_
 	acpi_evaluate_hotplug_ost(handle, type, ost_code, NULL);
 }
 
-void acpi_install_hotplug_notify_handler(acpi_handle handle, void *data)
+void acpi_install_hotplug_notify_handler(acpi_handle handle)
 {
 	acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
-				    acpi_hotplug_notify_cb, data);
+				    acpi_hotplug_notify_cb, NULL);
 }
 
 void acpi_remove_hotplug_notify_handler(acpi_handle handle)
@@ -2000,7 +2005,7 @@ static void acpi_scan_init_hotplug(acpi_
 	list_for_each_entry(hwid, &pnp.ids, list) {
 		handler = acpi_scan_match_handler(hwid->id, NULL);
 		if (handler) {
-			acpi_install_hotplug_notify_handler(handle, handler);
+			acpi_install_hotplug_notify_handler(handle);
 			break;
 		}
 	}
Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -371,7 +371,7 @@ static acpi_status register_slot(acpi_ha
 
 	/* install notify handler */
 	if (!(newfunc->flags & FUNC_HAS_DCK))
-		acpi_install_hotplug_notify_handler(handle, NULL);
+		acpi_install_hotplug_notify_handler(handle);
 
 	return AE_OK;
 }
Index: linux-pm/include/acpi/acpi_bus.h
===================================================================
--- linux-pm.orig/include/acpi/acpi_bus.h
+++ linux-pm/include/acpi/acpi_bus.h
@@ -435,7 +435,7 @@ static inline bool acpi_device_enumerate
 typedef void (*acpi_hp_callback)(void *data, u32 src);
 
 acpi_status acpi_hotplug_execute(acpi_hp_callback func, void *data, u32 src);
-void acpi_install_hotplug_notify_handler(acpi_handle handle, void *data);
+void acpi_install_hotplug_notify_handler(acpi_handle handle);
 void acpi_remove_hotplug_notify_handler(acpi_handle handle);
 
 /**

