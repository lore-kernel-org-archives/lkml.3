Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241AbaBCXcj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 18:32:39 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:58700 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753667AbaBCX21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 18:28:27 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Aaron Lu <aaron.lu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>
Subject: [PATCH 10/24][Resend] ACPI / hotplug / PCI: Rework acpiphp_no_hotplug()
Date: Tue, 04 Feb 2014 00:24:21 +0100
Message-ID: <2910389.HdF4mpSM6b@vostro.rjw.lan>
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

If a struct acpi_device pointer is passed to acpiphp_no_hotplug()
instead of an ACPI handle, the function won't need to call
acpi_bus_get_device(), which may be costly, any more.  Then,
trim_stale_devices() can call acpiphp_no_hotplug() passing
the struct acpi_device object it already has directly to that
function.

Make those changes and update slot_no_hotplug() accordingly.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Tested-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/pci/hotplug/acpiphp_glue.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -638,11 +638,8 @@ static void disable_slot(struct acpiphp_
 	slot->flags &= (~SLOT_ENABLED);
 }
 
-static bool acpiphp_no_hotplug(acpi_handle handle)
+static bool acpiphp_no_hotplug(struct acpi_device *adev)
 {
-	struct acpi_device *adev = NULL;
-
-	acpi_bus_get_device(handle, &adev);
 	return adev && adev->flags.no_hotplug;
 }
 
@@ -650,10 +647,13 @@ static bool slot_no_hotplug(struct acpip
 {
 	struct acpiphp_func *func;
 
-	list_for_each_entry(func, &slot->funcs, sibling)
-		if (acpiphp_no_hotplug(func_to_handle(func)))
-			return true;
+	list_for_each_entry(func, &slot->funcs, sibling) {
+		struct acpi_device *adev = NULL;
 
+		acpi_bus_get_device(func_to_handle(func), &adev);
+		if (acpiphp_no_hotplug(adev))
+			return true;
+	}
 	return false;
 }
 
@@ -710,13 +710,12 @@ static void trim_stale_devices(struct pc
 	bool alive = false;
 
 	if (adev) {
-		acpi_handle handle = adev->handle;
 		acpi_status status;
 		unsigned long long sta;
 
-		status = acpi_evaluate_integer(handle, "_STA", NULL, &sta);
+		status = acpi_evaluate_integer(adev->handle, "_STA", NULL, &sta);
 		alive = (ACPI_SUCCESS(status) && sta == ACPI_STA_ALL)
-			|| acpiphp_no_hotplug(handle);
+			|| acpiphp_no_hotplug(adev);
 	}
 	if (!alive) {
 		u32 v;

