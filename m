Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753578Ab3GIANb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 20:13:31 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:35147 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753522Ab3GIANY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 20:13:24 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <liuj97@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [RFC][PATCH 1/8] ACPI / PCI: Make bus registration and unregistration symmetric
Date: Tue, 09 Jul 2013 02:14:38 +0200
Message-ID: <29876102.Oh151SK5OE@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <26431283.HJCKsss0rt@vostro.rjw.lan>
References: <26431283.HJCKsss0rt@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Since acpi_pci_slot_enumerate() and acpiphp_enumerate_slots() can get
the ACPI device handle they need from bus->bridge, it is not
necessary to pass that handle to them as an argument.

Drop the second argument of acpi_pci_slot_enumerate() and
acpiphp_enumerate_slots(), rework them to obtain the ACPI handle
from bus->bridge and make acpi_pci_add_bus() and
acpi_pci_remove_bus() entirely symmetrical.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/pci_slot.c            |   14 +++++++++-----
 drivers/pci/hotplug/acpiphp_glue.c |    7 ++++---
 drivers/pci/pci-acpi.c             |   16 ++++------------
 include/linux/pci-acpi.h           |   10 ++++------
 4 files changed, 21 insertions(+), 26 deletions(-)

Index: linux-pm/drivers/acpi/pci_slot.c
===================================================================
--- linux-pm.orig/drivers/acpi/pci_slot.c
+++ linux-pm/drivers/acpi/pci_slot.c
@@ -159,12 +159,16 @@ register_slot(acpi_handle handle, u32 lv
 	return AE_OK;
 }
 
-void acpi_pci_slot_enumerate(struct pci_bus *bus, acpi_handle handle)
+void acpi_pci_slot_enumerate(struct pci_bus *bus)
 {
-	mutex_lock(&slot_list_lock);
-	acpi_walk_namespace(ACPI_TYPE_DEVICE, handle, 1,
-			    register_slot, NULL, bus, NULL);
-	mutex_unlock(&slot_list_lock);
+	acpi_handle handle = ACPI_HANDLE(bus->bridge);
+
+	if (handle) {
+		mutex_lock(&slot_list_lock);
+		acpi_walk_namespace(ACPI_TYPE_DEVICE, handle, 1,
+				    register_slot, NULL, bus, NULL);
+		mutex_unlock(&slot_list_lock);
+	}
 }
 
 void acpi_pci_slot_remove(struct pci_bus *bus)
Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -1169,15 +1169,16 @@ static void handle_hotplug_event_func(ac
  * Create hotplug slots for the PCI bus.
  * It should always return 0 to avoid skipping following notifiers.
  */
-void acpiphp_enumerate_slots(struct pci_bus *bus, acpi_handle handle)
+void acpiphp_enumerate_slots(struct pci_bus *bus)
 {
-	acpi_handle dummy_handle;
+	acpi_handle handle, dummy_handle;
 	struct acpiphp_bridge *bridge;
 
 	if (acpiphp_disabled)
 		return;
 
-	if (detect_ejectable_slots(handle) <= 0)
+	handle = ACPI_HANDLE(bus->bridge);
+	if (!handle || detect_ejectable_slots(handle) <= 0)
 		return;
 
 	bridge = kzalloc(sizeof(struct acpiphp_bridge), GFP_KERNEL);
Index: linux-pm/drivers/pci/pci-acpi.c
===================================================================
--- linux-pm.orig/drivers/pci/pci-acpi.c
+++ linux-pm/drivers/pci/pci-acpi.c
@@ -290,24 +290,16 @@ static struct pci_platform_pm_ops acpi_p
 
 void acpi_pci_add_bus(struct pci_bus *bus)
 {
-	acpi_handle handle = NULL;
-
-	if (bus->bridge)
-		handle = ACPI_HANDLE(bus->bridge);
-	if (acpi_pci_disabled || handle == NULL)
+	if (acpi_pci_disabled || !bus->bridge)
 		return;
 
-	acpi_pci_slot_enumerate(bus, handle);
-	acpiphp_enumerate_slots(bus, handle);
+	acpi_pci_slot_enumerate(bus);
+	acpiphp_enumerate_slots(bus);
 }
 
 void acpi_pci_remove_bus(struct pci_bus *bus)
 {
-	/*
-	 * bus->bridge->acpi_node.handle has already been reset to NULL
-	 * when acpi_pci_remove_bus() is called, so don't check ACPI handle.
-	 */
-	if (acpi_pci_disabled)
+	if (acpi_pci_disabled || !bus->bridge)
 		return;
 
 	acpiphp_remove_slots(bus);
Index: linux-pm/include/linux/pci-acpi.h
===================================================================
--- linux-pm.orig/include/linux/pci-acpi.h
+++ linux-pm/include/linux/pci-acpi.h
@@ -47,24 +47,22 @@ void acpi_pci_remove_bus(struct pci_bus
 
 #ifdef	CONFIG_ACPI_PCI_SLOT
 void acpi_pci_slot_init(void);
-void acpi_pci_slot_enumerate(struct pci_bus *bus, acpi_handle handle);
+void acpi_pci_slot_enumerate(struct pci_bus *bus);
 void acpi_pci_slot_remove(struct pci_bus *bus);
 #else
 static inline void acpi_pci_slot_init(void) { }
-static inline void acpi_pci_slot_enumerate(struct pci_bus *bus,
-					   acpi_handle handle) { }
+static inline void acpi_pci_slot_enumerate(struct pci_bus *bus) { }
 static inline void acpi_pci_slot_remove(struct pci_bus *bus) { }
 #endif
 
 #ifdef	CONFIG_HOTPLUG_PCI_ACPI
 void acpiphp_init(void);
-void acpiphp_enumerate_slots(struct pci_bus *bus, acpi_handle handle);
+void acpiphp_enumerate_slots(struct pci_bus *bus);
 void acpiphp_remove_slots(struct pci_bus *bus);
 void acpiphp_check_host_bridge(acpi_handle handle);
 #else
 static inline void acpiphp_init(void) { }
-static inline void acpiphp_enumerate_slots(struct pci_bus *bus,
-					   acpi_handle handle) { }
+static inline void acpiphp_enumerate_slots(struct pci_bus *bus) { }
 static inline void acpiphp_remove_slots(struct pci_bus *bus) { }
 static inline void acpiphp_check_host_bridge(acpi_handle handle) { }
 #endif

