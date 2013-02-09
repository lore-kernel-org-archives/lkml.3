Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760738Ab3BIOZK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 09:25:10 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:36262 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758109Ab3BIOYv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 09:24:51 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Jiang Liu <liuj97@gmail.com>,
        Toshi Kani <toshi.kani@hp.com>, LKML <linux-kernel@vger.kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Subject: [PATCH 1/2] ACPI / scan: Make acpi_bus_hot_remove_device() acquire the scan lock
Date: Sat, 09 Feb 2013 15:29:25 +0100
Message-ID: <3006340.mglZY9ZPKY@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc6; KDE/4.9.5; x86_64; ; )
In-Reply-To: <2074190.mMzUc3TOxk@vostro.rjw.lan>
References: <1873429.MS5RQDxTye@vostro.rjw.lan> <1468930.acVuhKfKYv@vostro.rjw.lan> <2074190.mMzUc3TOxk@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

The ACPI scan lock has been introduced to prevent acpi_bus_scan()
and acpi_bus_trim() from running in parallel with each other for
overlapping ACPI namespace scopes.  However, it is not sufficient
to do that, because if acpi_bus_scan() is run (for an overlapping
namespace scope) right after the acpi_bus_trim() in
acpi_bus_hot_remove_device(), the subsequent eject will remove
devices without removing the corresponding struct acpi_device
objects (and possibly companion "physical" device objects).
Therefore acpi_bus_hot_remove_device() has to acquire the scan
lock before carrying out the bus trimming and hold it through
the evaluation of _EJ0, so make that happen.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/scan.c |   31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

Index: test/drivers/acpi/scan.c
===================================================================
--- test.orig/drivers/acpi/scan.c
+++ test/drivers/acpi/scan.c
@@ -95,6 +95,8 @@ acpi_device_modalias_show(struct device
 }
 static DEVICE_ATTR(modalias, 0444, acpi_device_modalias_show, NULL);
 
+static void __acpi_bus_trim(struct acpi_device *start);
+
 /**
  * acpi_bus_hot_remove_device: hot-remove a device and its children
  * @context: struct acpi_eject_event pointer (freed in this func)
@@ -114,10 +116,12 @@ void acpi_bus_hot_remove_device(void *co
 	acpi_status status = AE_OK;
 	u32 ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE; /* default */
 
+	mutex_lock(&acpi_scan_lock);
+
 	ACPI_DEBUG_PRINT((ACPI_DB_INFO,
 		"Hot-removing device %s...\n", dev_name(&device->dev)));
 
-	acpi_bus_trim(device);
+	__acpi_bus_trim(device);
 	/* Device node has been released. */
 	device = NULL;
 
@@ -146,18 +150,14 @@ void acpi_bus_hot_remove_device(void *co
 	status = acpi_evaluate_object(handle, "_EJ0", &arg_list, NULL);
 	if (ACPI_FAILURE(status)) {
 		if (status != AE_NOT_FOUND)
-			printk(KERN_WARNING PREFIX
-					"Eject device failed\n");
-		goto err_out;
-	}
+			acpi_handle_warn(handle, "Eject failed\n");
 
-	kfree(context);
-	return;
+		/* Tell the firmware the hot-remove operation has failed. */
+		acpi_evaluate_hotplug_ost(handle, ej_event->event,
+					  ost_code, NULL);
+	}
 
-err_out:
-	/* Inform firmware the hot-remove operation has completed w/ error */
-	(void) acpi_evaluate_hotplug_ost(handle,
-				ej_event->event, ost_code, NULL);
+	mutex_unlock(&acpi_scan_lock);
 	kfree(context);
 	return;
 }
@@ -1686,10 +1686,8 @@ static acpi_status acpi_bus_remove(acpi_
 	return AE_OK;
 }
 
-void acpi_bus_trim(struct acpi_device *start)
+static void __acpi_bus_trim(struct acpi_device *start)
 {
-	mutex_lock(&acpi_scan_lock);
-
 	/*
 	 * Execute acpi_bus_device_detach() as a post-order callback to detach
 	 * all ACPI drivers from the device nodes being removed.
@@ -1704,7 +1702,12 @@ void acpi_bus_trim(struct acpi_device *s
 	acpi_walk_namespace(ACPI_TYPE_ANY, start->handle, ACPI_UINT32_MAX, NULL,
 			    acpi_bus_remove, NULL, NULL);
 	acpi_bus_remove(start->handle, 0, NULL, NULL);
+}
 
+void acpi_bus_trim(struct acpi_device *start)
+{
+	mutex_lock(&acpi_scan_lock);
+	__acpi_bus_trim(start);
 	mutex_unlock(&acpi_scan_lock);
 }
 EXPORT_SYMBOL_GPL(acpi_bus_trim);

