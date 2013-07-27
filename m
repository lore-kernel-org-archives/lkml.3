Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751828Ab3G0NON (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 09:14:13 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:43323 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751640Ab3G0NOM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 09:14:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] ACPI: Move acpi_bus_get_device() from bus.c to scan.c
Date: Sat, 27 Jul 2013 15:24:19 +0200
Message-ID: <3314440.iryh4ZRtRb@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Subject: ACPI: Move acpi_bus_get_device() from bus.c to scan.c

Move acpi_bus_get_device() from bus.c to scan.c which allows
acpi_bus_data_handler() to become static and clean up the latter.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/bus.c      |   21 ---------------------
 drivers/acpi/scan.c     |   30 ++++++++++++++++++++++--------
 include/acpi/acpi_bus.h |    1 -
 3 files changed, 22 insertions(+), 30 deletions(-)

Index: linux-pm/drivers/acpi/bus.c
===================================================================
--- linux-pm.orig/drivers/acpi/bus.c
+++ linux-pm/drivers/acpi/bus.c
@@ -89,27 +89,6 @@ static struct dmi_system_id dsdt_dmi_tab
                                 Device Management
    -------------------------------------------------------------------------- */
 
-int acpi_bus_get_device(acpi_handle handle, struct acpi_device **device)
-{
-	acpi_status status;
-
-	if (!device)
-		return -EINVAL;
-
-	/* TBD: Support fixed-feature devices */
-
-	status = acpi_get_data(handle, acpi_bus_data_handler, (void **)device);
-	if (ACPI_FAILURE(status) || !*device) {
-		ACPI_DEBUG_PRINT((ACPI_DB_INFO, "No context for object [%p]\n",
-				  handle));
-		return -ENODEV;
-	}
-
-	return 0;
-}
-
-EXPORT_SYMBOL(acpi_bus_get_device);
-
 acpi_status acpi_bus_get_status_handle(acpi_handle handle,
 				       unsigned long long *sta)
 {
Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -970,6 +970,28 @@ struct bus_type acpi_bus_type = {
 	.uevent		= acpi_device_uevent,
 };
 
+static void acpi_bus_data_handler(acpi_handle handle, void *context)
+{
+	/* Intentionally empty. */
+}
+
+int acpi_bus_get_device(acpi_handle handle, struct acpi_device **device)
+{
+	acpi_status status;
+
+	if (!device)
+		return -EINVAL;
+
+	status = acpi_get_data(handle, acpi_bus_data_handler, (void **)device);
+	if (ACPI_FAILURE(status) || !*device) {
+		ACPI_DEBUG_PRINT((ACPI_DB_INFO, "No context for object [%p]\n",
+				  handle));
+		return -ENODEV;
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(acpi_bus_get_device);
+
 int acpi_device_add(struct acpi_device *device,
 		    void (*release)(struct device *))
 {
@@ -1181,14 +1203,6 @@ acpi_bus_get_ejd(acpi_handle handle, acp
 }
 EXPORT_SYMBOL_GPL(acpi_bus_get_ejd);
 
-void acpi_bus_data_handler(acpi_handle handle, void *context)
-{
-
-	/* TBD */
-
-	return;
-}
-
 static int acpi_bus_extract_wakeup_device_power_package(acpi_handle handle,
 					struct acpi_device_wakeup *wakeup)
 {
Index: linux-pm/include/acpi/acpi_bus.h
===================================================================
--- linux-pm.orig/include/acpi/acpi_bus.h
+++ linux-pm/include/acpi/acpi_bus.h
@@ -371,7 +371,6 @@ extern int unregister_acpi_notifier(stru
  */
 
 int acpi_bus_get_device(acpi_handle handle, struct acpi_device **device);
-void acpi_bus_data_handler(acpi_handle handle, void *context);
 acpi_status acpi_bus_get_status_handle(acpi_handle handle,
 				       unsigned long long *sta);
 int acpi_bus_get_status(struct acpi_device *device);

