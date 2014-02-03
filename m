Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754264AbaBCXim (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 18:38:42 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:59396 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752910AbaBCX2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 18:28:20 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Aaron Lu <aaron.lu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>
Subject: [PATCH 21/24][Resend] ACPI / hotplug / PCI: Rework the handling of eject requests
Date: Tue, 04 Feb 2014 00:38:29 +0100
Message-ID: <2266713.TFhenapTbS@vostro.rjw.lan>
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

To avoid the need to install a hotplug notify handler for each ACPI
namespace node representing a device and having a matching scan
handler, move the check whether or not the ejection of the given
device is enabled through its scan handler from acpi_hotplug_notify_cb()
to acpi_generic_hotplug_event().  Also, move the execution of
ACPI_OST_SC_EJECT_IN_PROGRESS _OST to acpi_generic_hotplug_event(),
because in acpi_hotplug_notify_cb() or in acpi_eject_store() we really
don't know whether or not the eject is going to be in progress (for
example, acpi_hotplug_execute() may still fail without queuing up the
work item).

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Tested-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/acpi/scan.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

Index: linux-pm/drivers/acpi/scan.c
===================================================================
--- linux-pm.orig/drivers/acpi/scan.c
+++ linux-pm/drivers/acpi/scan.c
@@ -459,6 +459,12 @@ static int acpi_generic_hotplug_event(st
 		return acpi_scan_device_check(adev);
 	case ACPI_NOTIFY_EJECT_REQUEST:
 	case ACPI_OST_EC_OSPM_EJECT:
+		if (adev->handler && !adev->handler->hotplug.enabled) {
+			dev_info(&adev->dev, "Eject disabled\n");
+			return -EPERM;
+		}
+		acpi_evaluate_hotplug_ost(adev->handle, ACPI_NOTIFY_EJECT_REQUEST,
+					  ACPI_OST_SC_EJECT_IN_PROGRESS, NULL);
 		return acpi_scan_hot_remove(adev);
 	}
 	return -EINVAL;
@@ -483,6 +489,10 @@ static void acpi_device_hotplug(void *da
 
 	if (adev->handler) {
 		error = acpi_generic_hotplug_event(adev, src);
+		if (error == -EPERM) {
+			ost_code = ACPI_OST_SC_EJECT_NOT_SUPPORTED;
+			goto err_out;
+		}
 	} else {
 		int (*event)(struct acpi_device *, u32);
 
@@ -512,7 +522,6 @@ static void acpi_device_hotplug(void *da
 
 static void acpi_hotplug_notify_cb(acpi_handle handle, u32 type, void *data)
 {
-	struct acpi_scan_handler *handler = data;
 	u32 ost_code = ACPI_OST_SC_SUCCESS;
 	struct acpi_device *adev;
 	acpi_status status;
@@ -528,13 +537,6 @@ static void acpi_hotplug_notify_cb(acpi_
 
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
@@ -632,8 +634,6 @@ acpi_eject_store(struct device *d, struc
 	if (ACPI_FAILURE(status) || !acpi_device->flags.ejectable)
 		return -ENODEV;
 
-	acpi_evaluate_hotplug_ost(acpi_device->handle, ACPI_OST_EC_OSPM_EJECT,
-				  ACPI_OST_SC_EJECT_IN_PROGRESS, NULL);
 	get_device(&acpi_device->dev);
 	status = acpi_hotplug_execute(acpi_device_hotplug, acpi_device,
 				      ACPI_OST_EC_OSPM_EJECT);

