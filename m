Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757462Ab3DLPrw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 11:47:52 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:55609 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754123Ab3DLPrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 11:47:49 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, "Rafael J . Wysocki" <rjw@sisk.pl>
Cc: Yijing Wang <wangyijing@huawei.com>, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <liuj97@gmail.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Myron Stowe <myron.stowe@redhat.com>,
        Jiang Liu <jiang.liu@huawei.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH v9 13/16] PCI/acpiphp: use normal list to simplify implementation
Date: Fri, 12 Apr 2013 23:44:27 +0800
Message-Id: <1365781470-32379-14-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1365781470-32379-1-git-send-email-jiang.liu@huawei.com>
References: <1365781470-32379-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yijing Wang <wangyijing@huawei.com>

Use normal list for struct acpiphp_slot to simplify implementation.

Signed-off-by: Yijing Wang <wangyijing@huawei.com>
Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Toshi Kani <toshi.kani@hp.com>
Cc: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/pci/hotplug/acpiphp.h      |    4 ++--
 drivers/pci/hotplug/acpiphp_glue.c |   23 ++++++++++-------------
 2 files changed, 12 insertions(+), 15 deletions(-)

diff --git a/drivers/pci/hotplug/acpiphp.h b/drivers/pci/hotplug/acpiphp.h
index 69b4aac..0b30045 100644
--- a/drivers/pci/hotplug/acpiphp.h
+++ b/drivers/pci/hotplug/acpiphp.h
@@ -73,8 +73,8 @@ static inline const char *slot_name(struct slot *slot)
  */
 struct acpiphp_bridge {
 	struct list_head list;
+	struct list_head slots;
 	acpi_handle handle;
-	struct acpiphp_slot *slots;
 
 	/* Ejectable PCI-to-PCI bridge (PCI bridge and PCI function) */
 	struct acpiphp_func *func;
@@ -97,7 +97,7 @@ struct acpiphp_bridge {
  * PCI slot information for each *physical* PCI slot
  */
 struct acpiphp_slot {
-	struct acpiphp_slot *next;
+	struct list_head node;
 	struct acpiphp_bridge *bridge;	/* parent */
 	struct list_head funcs;		/* one slot may have different
 					   objects (i.e. for each function) */
diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index 372c030..6bfd5a0 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -154,7 +154,7 @@ register_slot(acpi_handle handle, u32 lvl, void *context, void **rv)
 	acpi_handle tmp;
 	acpi_status status = AE_OK;
 	unsigned long long adr, sun;
-	int device, function, retval;
+	int device, function, retval, found = 0;
 	struct pci_bus *pbus = bridge->pci_bus;
 	struct pci_dev *pdev;
 	u32 val;
@@ -208,14 +208,15 @@ register_slot(acpi_handle handle, u32 lvl, void *context, void **rv)
 	}
 
 	/* search for objects that share the same slot */
-	for (slot = bridge->slots; slot; slot = slot->next)
+	list_for_each_entry(slot, &bridge->slots, node)
 		if (slot->device == device) {
 			if (slot->sun != sun)
 				warn("sibling found, but _SUN doesn't match!\n");
+			found = 1;
 			break;
 		}
 
-	if (!slot) {
+	if (!found) {
 		slot = kzalloc(sizeof(struct acpiphp_slot), GFP_KERNEL);
 		if (!slot) {
 			kfree(newfunc);
@@ -228,9 +229,7 @@ register_slot(acpi_handle handle, u32 lvl, void *context, void **rv)
 		INIT_LIST_HEAD(&slot->funcs);
 		mutex_init(&slot->crit_sect);
 
-		slot->next = bridge->slots;
-		bridge->slots = slot;
-
+		list_add_tail(&slot->node, &bridge->slots);
 		bridge->nr_slots++;
 
 		dbg("found ACPI PCI Hotplug slot %llu at PCI %04x:%02x:%02x\n",
@@ -289,7 +288,7 @@ register_slot(acpi_handle handle, u32 lvl, void *context, void **rv)
 
  err_exit:
 	bridge->nr_slots--;
-	bridge->slots = slot->next;
+	list_del(&slot->node);
 	kfree(slot);
 	kfree(newfunc);
 
@@ -353,7 +352,7 @@ static struct acpiphp_func *acpiphp_bridge_handle_to_function(acpi_handle handle
 	struct acpiphp_func *func;
 
 	list_for_each_entry(bridge, &bridge_list, list) {
-		for (slot = bridge->slots; slot; slot = slot->next) {
+		list_for_each_entry(slot, &bridge->slots, node) {
 			list_for_each_entry(func, &slot->funcs, sibling) {
 				if (func->handle == handle)
 					return func;
@@ -400,9 +399,7 @@ static void cleanup_bridge(struct acpiphp_bridge *bridge)
 			err("failed to install interrupt notify handler\n");
 	}
 
-	slot = bridge->slots;
-	while (slot) {
-		next = slot->next;
+	list_for_each_entry_safe(slot, next, &bridge->slots, node) {
 		list_for_each_entry_safe(func, tmp, &slot->funcs, sibling) {
 			if (is_dock_device(func->handle)) {
 				unregister_hotplug_dock_device(func->handle);
@@ -421,7 +418,6 @@ static void cleanup_bridge(struct acpiphp_bridge *bridge)
 		acpiphp_unregister_hotplug_slot(slot);
 		list_del(&slot->funcs);
 		kfree(slot);
-		slot = next;
 	}
 
 	put_device(&bridge->pci_bus->dev);
@@ -820,7 +816,7 @@ static int acpiphp_check_bridge(struct acpiphp_bridge *bridge)
 
 	enabled = disabled = 0;
 
-	for (slot = bridge->slots; slot; slot = slot->next) {
+	list_for_each_entry(slot, &bridge->slots, node) {
 		unsigned int status = get_slot_status(slot);
 		if (slot->flags & SLOT_ENABLED) {
 			if (status == ACPI_STA_ALL)
@@ -1095,6 +1091,7 @@ void acpiphp_enumerate_slots(struct pci_bus *bus, acpi_handle handle)
 		return;
 	}
 
+	INIT_LIST_HEAD(&bridge->slots);
 	bridge->handle = handle;
 	bridge->pci_dev = pci_dev_get(bus->self);
 	bridge->pci_bus = bus;
-- 
1.7.9.5

