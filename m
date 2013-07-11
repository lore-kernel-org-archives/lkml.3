Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756893Ab3GKX7N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 19:59:13 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:39091 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756655Ab3GKX7K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 19:59:10 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <liuj97@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [RFC][PATCH 2/30] ACPI / hotplug / PCI: Consolidate acpiphp_enumerate_slots()
Date: Fri, 12 Jul 2013 01:37:29 +0200
Message-ID: <1864434.MIBpTeSunD@vostro.rjw.lan>
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

The acpiphp_enumerate_slots() function is now split into two parts,
acpiphp_enumerate_slots() proper and init_bridge_misc() which is
only called by the former.  If these functions are combined,
it is possible to make the code easier to follow and to clean up
the error handling (to prevent memory leaks on error from
happening in particular), so do that.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/pci/hotplug/acpiphp_glue.c |   94 ++++++++++++++++++-------------------
 1 file changed, 46 insertions(+), 48 deletions(-)

Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -363,46 +363,6 @@ static int detect_ejectable_slots(acpi_h
 	return found;
 }
 
-/* initialize miscellaneous stuff for both root and PCI-to-PCI bridge */
-static void init_bridge_misc(struct acpiphp_bridge *bridge)
-{
-	acpi_status status;
-
-	/* must be added to the list prior to calling register_slot */
-	mutex_lock(&bridge_mutex);
-	list_add(&bridge->list, &bridge_list);
-	mutex_unlock(&bridge_mutex);
-
-	/* register all slot objects under this bridge */
-	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, bridge->handle, (u32)1,
-				     register_slot, NULL, bridge, NULL);
-	if (ACPI_FAILURE(status)) {
-		mutex_lock(&bridge_mutex);
-		list_del(&bridge->list);
-		mutex_unlock(&bridge_mutex);
-		return;
-	}
-
-	/* install notify handler for P2P bridges */
-	if (!pci_is_root_bus(bridge->pci_bus)) {
-		if ((bridge->flags & BRIDGE_HAS_EJ0) && bridge->func) {
-			status = acpi_remove_notify_handler(bridge->func->handle,
-						ACPI_SYSTEM_NOTIFY,
-						handle_hotplug_event_func);
-			if (ACPI_FAILURE(status))
-				err("failed to remove notify handler\n");
-		}
-		status = acpi_install_notify_handler(bridge->handle,
-					     ACPI_SYSTEM_NOTIFY,
-					     handle_hotplug_event_bridge,
-					     bridge);
-
-		if (ACPI_FAILURE(status)) {
-			err("failed to register interrupt notify handler\n");
-		}
-	}
-}
-
 
 /* find acpiphp_func from acpiphp_bridge */
 static struct acpiphp_func *acpiphp_bridge_handle_to_function(acpi_handle handle)
@@ -1171,8 +1131,9 @@ static void handle_hotplug_event_func(ac
  */
 void acpiphp_enumerate_slots(struct pci_bus *bus)
 {
-	acpi_handle handle, dummy_handle;
 	struct acpiphp_bridge *bridge;
+	acpi_handle handle;
+	acpi_status status;
 
 	if (acpiphp_disabled)
 		return;
@@ -1200,15 +1161,52 @@ void acpiphp_enumerate_slots(struct pci_
 	 */
 	get_device(&bus->dev);
 
-	if (!pci_is_root_bus(bridge->pci_bus) &&
-	    ACPI_SUCCESS(acpi_get_handle(bridge->handle,
-					"_EJ0", &dummy_handle))) {
-		dbg("found ejectable p2p bridge\n");
-		bridge->flags |= BRIDGE_HAS_EJ0;
-		bridge->func = acpiphp_bridge_handle_to_function(handle);
+	/* must be added to the list prior to calling register_slot */
+	mutex_lock(&bridge_mutex);
+	list_add(&bridge->list, &bridge_list);
+	mutex_unlock(&bridge_mutex);
+
+	/* register all slot objects under this bridge */
+	status = acpi_walk_namespace(ACPI_TYPE_DEVICE, bridge->handle, 1,
+				     register_slot, NULL, bridge, NULL);
+	if (ACPI_FAILURE(status)) {
+		acpi_handle_err(bridge->handle, "failed to register slots\n");
+		goto err;
 	}
 
-	init_bridge_misc(bridge);
+	if (pci_is_root_bus(bridge->pci_bus))
+		return;
+
+	/* install notify handler for P2P bridges */
+	status = acpi_install_notify_handler(bridge->handle, ACPI_SYSTEM_NOTIFY,
+					     handle_hotplug_event_bridge,
+					     bridge);
+	if (ACPI_FAILURE(status)) {
+		acpi_handle_err(bridge->handle,
+				"failed to register notify handler\n");
+		goto err;
+	}
+
+	status = acpi_get_handle(bridge->handle, "_EJ0", &handle);
+	if (ACPI_FAILURE(status))
+		return;
+
+	dbg("found ejectable p2p bridge\n");
+	bridge->flags |= BRIDGE_HAS_EJ0;
+	bridge->func = acpiphp_bridge_handle_to_function(bridge->handle);
+	if (bridge->func) {
+		status = acpi_remove_notify_handler(bridge->func->handle,
+						    ACPI_SYSTEM_NOTIFY,
+						    handle_hotplug_event_func);
+		if (ACPI_FAILURE(status))
+			acpi_handle_err(bridge->func->handle,
+					"failed to remove notify handler\n");
+	}
+	return;
+
+ err:
+	cleanup_bridge(bridge);
+	put_bridge(bridge);
 }
 
 /* Destroy hotplug slots associated with the PCI bus */

