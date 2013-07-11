Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757151Ab3GLAFH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 20:05:07 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:39026 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756657Ab3GKX64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 19:58:56 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <liuj97@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [RFC][PATCH 19/30] ACPI / hotplug / PCI: Rework namespace scanning and trimming routines
Date: Fri, 12 Jul 2013 01:57:58 +0200
Message-ID: <7159825.56C6kpKbiy@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <3718119.FLASu5DBx8@vostro.rjw.lan>
References: <26431283.HJCKsss0rt@vostro.rjw.lan> <3718119.FLASu5DBx8@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

The acpiphp_bus_trim() and acpiphp_bus_add() functions need not
return error codes that are never checked, so redefine them and
simplify them a bit.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/pci/hotplug/acpiphp_glue.c |   52 +++++++++----------------------------
 1 file changed, 13 insertions(+), 39 deletions(-)

Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -552,53 +552,27 @@ static unsigned char acpiphp_max_busnr(s
 	return max;
 }
 
-
 /**
- * acpiphp_bus_add - add a new bus to acpi subsystem
- * @func: acpiphp_func of the bridge
+ * acpiphp_bus_trim - Trim device objects in an ACPI namespace subtree.
+ * @handle: ACPI device object handle to start from.
  */
-static int acpiphp_bus_add(struct acpiphp_func *func)
+static void acpiphp_bus_trim(acpi_handle handle)
 {
-	acpi_handle handle = func_to_handle(func);
-	struct acpi_device *device;
-	int ret_val;
-
-	if (!acpi_bus_get_device(handle, &device)) {
-		dbg("bus exists... trim\n");
-		/* this shouldn't be in here, so remove
-		 * the bus then re-add it...
-		 */
-		acpi_bus_trim(device);
-	}
-
-	ret_val = acpi_bus_scan(handle);
-	if (!ret_val)
-		ret_val = acpi_bus_get_device(handle, &device);
-
-	if (ret_val)
-		dbg("error adding bus, %x\n", -ret_val);
+	struct acpi_device *adev = NULL;
 
-	return ret_val;
+	acpi_bus_get_device(handle, &adev);
+	if (adev)
+		acpi_bus_trim(adev);
 }
 
-
 /**
- * acpiphp_bus_trim - trim a bus from acpi subsystem
- * @handle: handle to acpi namespace
+ * acpiphp_bus_add - Scan ACPI namespace subtree.
+ * @handle: ACPI object handle to start the scan from.
  */
-static int acpiphp_bus_trim(acpi_handle handle)
+static void acpiphp_bus_add(acpi_handle handle)
 {
-	struct acpi_device *device;
-	int retval;
-
-	retval = acpi_bus_get_device(handle, &device);
-	if (retval) {
-		dbg("acpi_device not found\n");
-		return retval;
-	}
-
-	acpi_bus_trim(device);
-	return 0;
+	acpiphp_bus_trim(handle);
+	acpi_bus_scan(handle);
 }
 
 static void acpiphp_set_acpi_region(struct acpiphp_slot *slot)
@@ -661,7 +635,7 @@ static int __ref enable_device(struct ac
 		goto err_exit;
 
 	list_for_each_entry(func, &slot->funcs, sibling)
-		acpiphp_bus_add(func);
+		acpiphp_bus_add(func_to_handle(func));
 
 	num = pci_scan_slot(bus, PCI_DEVFN(slot->device, 0));
 	if (num == 0) {

