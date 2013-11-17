Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590Ab3KQQ1u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 11:27:50 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:65002 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754390Ab3KQQZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 11:25:51 -0500
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
Subject: [PATCH 4/10] ACPI / hotplug: Do not fail bus and device checks for disabled hotplug
Date: Sun, 17 Nov 2013 17:33:47 +0100
Message-ID: <15560767.B2ZaDjMsph@vostro.rjw.lan>
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

If the scan handler for the given device has hotplug.enabled
unset, it doesn't really make sense to fail bus check and device
check notifications.

First, bus check may not have anything to do with the device it is
signaled for, but it may concern another device on the bus below
this one.  For this reason, bus check notifications should not be
failed if hotplug is disabled for the target device.

Second, device check notifications are signaled only after a device
has already appeared (or disappeared), so failing it can only prevent
scan handlers and drivers from attaching to that (already existing)
device, which is not very useful.

Consequently, if device hotplug is disabled through the device's
scan handler, fail eject request notifications only.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/scan.c |   40 +++++++---------------------------------
 1 file changed, 7 insertions(+), 33 deletions(-)

Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -363,43 +363,13 @@ static void acpi_scan_bus_device_check(v
 	unlock_device_hotplug();
 }
 
-static void acpi_hotplug_unsupported(acpi_handle handle, u32 type)
-{
-	u32 ost_status;
-
-	switch (type) {
-	case ACPI_NOTIFY_BUS_CHECK:
-		acpi_handle_debug(handle,
-			"ACPI_NOTIFY_BUS_CHECK event: unsupported\n");
-		ost_status = ACPI_OST_SC_INSERT_NOT_SUPPORTED;
-		break;
-	case ACPI_NOTIFY_DEVICE_CHECK:
-		acpi_handle_debug(handle,
-			"ACPI_NOTIFY_DEVICE_CHECK event: unsupported\n");
-		ost_status = ACPI_OST_SC_INSERT_NOT_SUPPORTED;
-		break;
-	case ACPI_NOTIFY_EJECT_REQUEST:
-		acpi_handle_debug(handle,
-			"ACPI_NOTIFY_EJECT_REQUEST event: unsupported\n");
-		ost_status = ACPI_OST_SC_EJECT_NOT_SUPPORTED;
-		break;
-	default:
-		/* non-hotplug event; possibly handled by other handler */
-		return;
-	}
-
-	acpi_evaluate_hotplug_ost(handle, type, ost_status, NULL);
-}
-
 static void acpi_hotplug_notify_cb(acpi_handle handle, u32 type, void *data)
 {
+	u32 ost_code = ACPI_OST_SC_NON_SPECIFIC_FAILURE;
 	struct acpi_scan_handler *handler = data;
 	struct acpi_device *adev;
 	acpi_status status;
 
-	if (!handler->hotplug.enabled)
-		return acpi_hotplug_unsupported(handle, type);
-
 	switch (type) {
 	case ACPI_NOTIFY_BUS_CHECK:
 		acpi_handle_debug(handle, "ACPI_NOTIFY_BUS_CHECK event\n");
@@ -409,6 +379,11 @@ static void acpi_hotplug_notify_cb(acpi_
 		break;
 	case ACPI_NOTIFY_EJECT_REQUEST:
 		acpi_handle_debug(handle, "ACPI_NOTIFY_EJECT_REQUEST event\n");
+		if (!handler->hotplug.enabled) {
+			acpi_handle_err(handle, "Eject disabled\n");
+			ost_code = ACPI_OST_SC_EJECT_NOT_SUPPORTED;
+			goto err_out;
+		}
 		if (acpi_bus_get_device(handle, &adev))
 			goto err_out;
 
@@ -428,8 +403,7 @@ static void acpi_hotplug_notify_cb(acpi_
 		return;
 
  err_out:
-	acpi_evaluate_hotplug_ost(handle, type,
-				  ACPI_OST_SC_NON_SPECIFIC_FAILURE, NULL);
+	acpi_evaluate_hotplug_ost(handle, type, ost_code, NULL);
 }
 
 static ssize_t real_power_state_show(struct device *dev,

