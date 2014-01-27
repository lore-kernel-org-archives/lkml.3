Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704AbaA0Aet (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 19:34:49 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:59958 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753420AbaA0AcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 19:32:23 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Aaron Lu <aaron.lu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 4/11] ACPI / hotplug / PCI: Rework acpiphp_no_hotplug()
Date: Mon, 27 Jan 2014 01:40:32 +0100
Message-ID: <4037947.8Z1PhnlAZj@vostro.rjw.lan>
User-Agent: KMail/4.11.4 (Linux/3.13.0+; KDE/4.11.4; x86_64; ; )
In-Reply-To: <2217793.001RY6hKlo@vostro.rjw.lan>
References: <2217793.001RY6hKlo@vostro.rjw.lan>
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
---
 drivers/pci/hotplug/acpiphp_glue.c |   19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -635,11 +635,8 @@ static void disable_slot(struct acpiphp_
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
 
@@ -647,10 +644,13 @@ static bool slot_no_hotplug(struct acpip
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
 
@@ -707,13 +707,12 @@ static void trim_stale_devices(struct pc
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

