Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757136Ab3GLAEi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 20:04:38 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:39028 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756671Ab3GKX65 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 19:58:57 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <liuj97@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [RFC][PATCH 18/30] ACPI / hotplug / PCI: Store parent in functions and bus in slots
Date: Fri, 12 Jul 2013 01:56:59 +0200
Message-ID: <3768978.kzUGSDTsXK@vostro.rjw.lan>
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

To avoid chasing more pointers than necessary in some situations,
move the bridge pointer from struct acpiphp_slot to struct
acpiphp_func (and call it 'parent') and add a bus pointer to
struct acpiphp_slot.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/pci/hotplug/acpiphp.h      |    5 +++--
 drivers/pci/hotplug/acpiphp_core.c |    6 ++----
 drivers/pci/hotplug/acpiphp_glue.c |   25 +++++++++++++------------
 3 files changed, 18 insertions(+), 18 deletions(-)

Index: linux-pm/drivers/pci/hotplug/acpiphp.h
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp.h
+++ linux-pm/drivers/pci/hotplug/acpiphp.h
@@ -94,7 +94,7 @@ struct acpiphp_bridge {
  */
 struct acpiphp_slot {
 	struct list_head node;
-	struct acpiphp_bridge *bridge;	/* parent */
+	struct pci_bus *bus;
 	struct list_head funcs;		/* one slot may have different
 					   objects (i.e. for each function) */
 	struct slot *slot;
@@ -112,7 +112,8 @@ struct acpiphp_slot {
  * typically 8 objects per slot (i.e. for each PCI function)
  */
 struct acpiphp_func {
-	struct acpiphp_slot *slot;	/* parent */
+	struct acpiphp_bridge *parent;
+	struct acpiphp_slot *slot;
 
 	struct list_head sibling;
 	struct notifier_block nb;
Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -165,7 +165,7 @@ static void free_bridge(struct kref *kre
 	/* Root bridges will not have hotplug context. */
 	if (context) {
 		/* Release the reference taken by acpiphp_enumerate_slots(). */
-		put_bridge(context->func.slot->bridge);
+		put_bridge(context->func.parent);
 		context->bridge = NULL;
 		acpiphp_put_context(context);
 	}
@@ -188,7 +188,7 @@ static int post_dock_fixups(struct notif
 	void *v)
 {
 	struct acpiphp_func *func = container_of(nb, struct acpiphp_func, nb);
-	struct pci_bus *bus = func->slot->bridge->pci_bus;
+	struct pci_bus *bus = func->slot->bus;
 	u32 buses;
 
 	if (!bus->self)
@@ -249,14 +249,14 @@ static void acpiphp_dock_init(void *data
 {
 	struct acpiphp_context *context = data;
 
-	get_bridge(context->func.slot->bridge);
+	get_bridge(context->func.parent);
 }
 
 static void acpiphp_dock_release(void *data)
 {
 	struct acpiphp_context *context = data;
 
-	put_bridge(context->func.slot->bridge);
+	put_bridge(context->func.parent);
 }
 
 /* callback routine to register each ACPI PCI slot object */
@@ -296,6 +296,7 @@ static acpi_status register_slot(acpi_ha
 	}
 	newfunc = &context->func;
 	newfunc->function = function;
+	newfunc->parent = bridge;
 	mutex_unlock(&acpiphp_context_lock);
 
 	if (ACPI_SUCCESS(acpi_get_handle(handle, "_EJ0", &tmp)))
@@ -324,7 +325,7 @@ static acpi_status register_slot(acpi_ha
 		goto err;
 	}
 
-	slot->bridge = bridge;
+	slot->bus = bridge->pci_bus;
 	slot->device = device;
 	INIT_LIST_HEAD(&slot->funcs);
 	mutex_init(&slot->crit_sect);
@@ -651,7 +652,7 @@ static void check_hotplug_bridge(struct
 static int __ref enable_device(struct acpiphp_slot *slot)
 {
 	struct pci_dev *dev;
-	struct pci_bus *bus = slot->bridge->pci_bus;
+	struct pci_bus *bus = slot->bus;
 	struct acpiphp_func *func;
 	int num, max, pass;
 	LIST_HEAD(add_list);
@@ -721,7 +722,7 @@ static int __ref enable_device(struct ac
 /* return first device in slot, acquiring a reference on it */
 static struct pci_dev *dev_in_slot(struct acpiphp_slot *slot)
 {
-	struct pci_bus *bus = slot->bridge->pci_bus;
+	struct pci_bus *bus = slot->bus;
 	struct pci_dev *dev;
 	struct pci_dev *ret = NULL;
 
@@ -793,7 +794,7 @@ static unsigned int get_slot_status(stru
 		} else {
 			u32 dvid;
 
-			pci_bus_read_config_dword(slot->bridge->pci_bus,
+			pci_bus_read_config_dword(slot->bus,
 						  PCI_DEVFN(slot->device,
 							    func->function),
 						  PCI_VENDOR_ID, &dvid);
@@ -993,7 +994,7 @@ static void hotplug_event(acpi_handle ha
 		if (bridge)
 			acpiphp_check_bridge(bridge);
 		else
-			acpiphp_check_bridge(func->slot->bridge);
+			acpiphp_check_bridge(func->parent);
 
 		break;
 
@@ -1048,7 +1049,7 @@ static void hotplug_event_work(struct wo
 
 	acpi_scan_lock_release();
 	kfree(hp_work); /* allocated in handle_hotplug_event() */
-	put_bridge(context->func.slot->bridge);
+	put_bridge(context->func.parent);
 }
 
 /**
@@ -1066,7 +1067,7 @@ static void handle_hotplug_event(acpi_ha
 	mutex_lock(&acpiphp_context_lock);
 	context = acpiphp_get_context(handle);
 	if (context) {
-		get_bridge(context->func.slot->bridge);
+		get_bridge(context->func.parent);
 		acpiphp_put_context(context);
 	}
 	mutex_unlock(&acpiphp_context_lock);
@@ -1136,7 +1137,7 @@ void acpiphp_enumerate_slots(struct pci_
 		bridge->context = context;
 		context->bridge = bridge;
 		/* Get a reference to the parent bridge. */
-		get_bridge(context->func.slot->bridge);
+		get_bridge(context->func.parent);
 		mutex_unlock(&acpiphp_context_lock);
 	}
 
Index: linux-pm/drivers/pci/hotplug/acpiphp_core.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_core.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_core.c
@@ -320,10 +320,8 @@ int acpiphp_register_hotplug_slot(struct
 	acpiphp_slot->slot = slot;
 	snprintf(name, SLOT_NAME_SIZE, "%u", sun);
 
-	retval = pci_hp_register(slot->hotplug_slot,
-					acpiphp_slot->bridge->pci_bus,
-					acpiphp_slot->device,
-					name);
+	retval = pci_hp_register(slot->hotplug_slot, acpiphp_slot->bus,
+				 acpiphp_slot->device, name);
 	if (retval == -EBUSY)
 		goto error_hpslot;
 	if (retval) {

