Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612Ab3A3QM2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 11:12:28 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:35287 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755318Ab3A3QMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 11:12:23 -0500
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        "Rafael J . Wysocki" <rjw@sisk.pl>
Cc: Jiang Liu <jiang.liu@huawei.com>, Yijing Wang <wangyijing@huawei.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Subject: [PATCH 2/2] acpiphp: remove dead code for PCI host bridge hotplug
Date: Thu, 31 Jan 2013 00:10:10 +0800
Message-Id: <1359562210-26536-2-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359562210-26536-1-git-send-email-jiang.liu@huawei.com>
References: <1359562210-26536-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiang Liu <jiang.liu@huawei.com>

Commit 668192b678201d2fff27c "PCI: acpiphp: Move host bridge hotplug
to pci_root.c" has moved PCI host bridge hotplug logic from acpiphp
to pci_root, but there is still PCI host bridge hotplug related
dead code left in acpiphp. So remove those dead code.

Now companion ACPI devices are always created before corresponding
PCI devices. And the ACPI event handle_hotplug_event_bridge() will be
installed only if it has associated PCI device. So remove dead code to
handle bridge hot-adding in function handle_hotplug_event_bridge().

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
---
 drivers/pci/hotplug/acpiphp.h      |   13 +---
 drivers/pci/hotplug/acpiphp_glue.c |  124 ++++--------------------------------
 2 files changed, 14 insertions(+), 123 deletions(-)

diff --git a/drivers/pci/hotplug/acpiphp.h b/drivers/pci/hotplug/acpiphp.h
index b3ead7a..b70ac00 100644
--- a/drivers/pci/hotplug/acpiphp.h
+++ b/drivers/pci/hotplug/acpiphp.h
@@ -79,7 +79,6 @@ struct acpiphp_bridge {
 	/* Ejectable PCI-to-PCI bridge (PCI bridge and PCI function) */
 	struct acpiphp_func *func;
 
-	int type;
 	int nr_slots;
 
 	u32 flags;
@@ -146,10 +145,6 @@ struct acpiphp_attention_info
 /* PCI bus bridge HID */
 #define ACPI_PCI_HOST_HID		"PNP0A03"
 
-/* PCI BRIDGE type */
-#define BRIDGE_TYPE_HOST		0
-#define BRIDGE_TYPE_P2P			1
-
 /* ACPI _STA method value (ignore bit 4; battery present) */
 #define ACPI_STA_PRESENT		(0x00000001)
 #define ACPI_STA_ENABLED		(0x00000002)
@@ -158,13 +153,7 @@ struct acpiphp_attention_info
 #define ACPI_STA_ALL			(0x0000000f)
 
 /* bridge flags */
-#define BRIDGE_HAS_STA		(0x00000001)
-#define BRIDGE_HAS_EJ0		(0x00000002)
-#define BRIDGE_HAS_HPP		(0x00000004)
-#define BRIDGE_HAS_PS0		(0x00000010)
-#define BRIDGE_HAS_PS1		(0x00000020)
-#define BRIDGE_HAS_PS2		(0x00000040)
-#define BRIDGE_HAS_PS3		(0x00000080)
+#define BRIDGE_HAS_EJ0		(0x00000001)
 
 /* slot flags */
 
diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index acb7af2..4681d2c 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -325,8 +325,8 @@ static void init_bridge_misc(struct acpiphp_bridge *bridge)
 		return;
 	}
 
-	/* install notify handler */
-	if (bridge->type != BRIDGE_TYPE_HOST) {
+	/* install notify handler for P2P bridges */
+	if (!pci_is_root_bus(bridge->pci_bus)) {
 		if ((bridge->flags & BRIDGE_HAS_EJ0) && bridge->func) {
 			status = acpi_remove_notify_handler(bridge->func->handle,
 						ACPI_SYSTEM_NOTIFY,
@@ -369,27 +369,12 @@ static struct acpiphp_func *acpiphp_bridge_handle_to_function(acpi_handle handle
 static inline void config_p2p_bridge_flags(struct acpiphp_bridge *bridge)
 {
 	acpi_handle dummy_handle;
+	struct acpiphp_func *func;
 
 	if (ACPI_SUCCESS(acpi_get_handle(bridge->handle,
-					"_STA", &dummy_handle)))
-		bridge->flags |= BRIDGE_HAS_STA;
-
-	if (ACPI_SUCCESS(acpi_get_handle(bridge->handle,
-					"_EJ0", &dummy_handle)))
+					"_EJ0", &dummy_handle))) {
 		bridge->flags |= BRIDGE_HAS_EJ0;
 
-	if (ACPI_SUCCESS(acpi_get_handle(bridge->handle,
-					"_PS0", &dummy_handle)))
-		bridge->flags |= BRIDGE_HAS_PS0;
-
-	if (ACPI_SUCCESS(acpi_get_handle(bridge->handle,
-					"_PS3", &dummy_handle)))
-		bridge->flags |= BRIDGE_HAS_PS3;
-
-	/* is this ejectable p2p bridge? */
-	if (bridge->flags & BRIDGE_HAS_EJ0) {
-		struct acpiphp_func *func;
-
 		dbg("found ejectable p2p bridge\n");
 
 		/* make link between PCI bridge and PCI function */
@@ -412,7 +397,6 @@ static void add_host_bridge(struct acpi_pci_root *root)
 	if (bridge == NULL)
 		return;
 
-	bridge->type = BRIDGE_TYPE_HOST;
 	bridge->handle = handle;
 
 	bridge->pci_bus = root->bus;
@@ -432,7 +416,6 @@ static void add_p2p_bridge(acpi_handle *handle)
 		return;
 	}
 
-	bridge->type = BRIDGE_TYPE_P2P;
 	bridge->handle = handle;
 	config_p2p_bridge_flags(bridge);
 
@@ -543,7 +526,7 @@ static void cleanup_bridge(struct acpiphp_bridge *bridge)
 	acpi_status status;
 	acpi_handle handle = bridge->handle;
 
-	if (bridge->type != BRIDGE_TYPE_HOST) {
+	if (!pci_is_root_bus(bridge->pci_bus)) {
 		status = acpi_remove_notify_handler(handle,
 					    ACPI_SYSTEM_NOTIFY,
 					    handle_hotplug_event_bridge);
@@ -551,8 +534,7 @@ static void cleanup_bridge(struct acpiphp_bridge *bridge)
 			err("failed to remove notify handler\n");
 	}
 
-	if ((bridge->type != BRIDGE_TYPE_HOST) &&
-	    ((bridge->flags & BRIDGE_HAS_EJ0) && bridge->func)) {
+	if ((bridge->flags & BRIDGE_HAS_EJ0) && bridge->func) {
 		status = acpi_install_notify_handler(bridge->func->handle,
 						ACPI_SYSTEM_NOTIFY,
 						handle_hotplug_event_func,
@@ -1122,64 +1104,11 @@ static void acpiphp_sanitize_bus(struct pci_bus *bus)
 	}
 }
 
-/* Program resources in newly inserted bridge */
-static int acpiphp_configure_p2p_bridge(acpi_handle handle)
-{
-	struct pci_dev *pdev = acpi_get_pci_dev(handle);
-	struct pci_bus *bus = pdev->subordinate;
-
-	pci_dev_put(pdev);
-
-	pci_bus_size_bridges(bus);
-	pci_bus_assign_resources(bus);
-	acpiphp_sanitize_bus(bus);
-	acpiphp_set_hpp_values(bus);
-	pci_enable_bridges(bus);
-	return 0;
-}
-
-static void handle_p2p_bridge_insertion(acpi_handle handle, u32 type)
-{
-	struct acpi_device *device;
-
-	if ((type != ACPI_NOTIFY_BUS_CHECK) &&
-			(type != ACPI_NOTIFY_DEVICE_CHECK)) {
-		err("unexpected notification type %d\n", type);
-		return;
-	}
-
-	if (acpi_bus_scan(handle)) {
-		err("cannot add bridge to acpi list\n");
-		return;
-	}
-	if (acpi_bus_get_device(handle, &device)) {
-		err("ACPI device object missing\n");
-		return;
-	}
-	if (!acpiphp_configure_p2p_bridge(handle))
-		add_p2p_bridge(handle);
-	else
-		err("cannot configure and start bridge\n");
-
-}
-
 /*
  * ACPI event handlers
  */
 
 static acpi_status
-count_sub_bridges(acpi_handle handle, u32 lvl, void *context, void **rv)
-{
-	int *count = (int *)context;
-	struct acpiphp_bridge *bridge;
-
-	bridge = acpiphp_handle_to_bridge(handle);
-	if (bridge)
-		(*count)++;
-	return AE_OK ;
-}
-
-static acpi_status
 check_sub_bridges(acpi_handle handle, u32 lvl, void *context, void **rv)
 {
 	struct acpiphp_bridge *bridge;
@@ -1203,8 +1132,6 @@ static void _handle_hotplug_event_bridge(struct work_struct *work)
 	char objname[64];
 	struct acpi_buffer buffer = { .length = sizeof(objname),
 				      .pointer = objname };
-	struct acpi_device *device;
-	int num_sub_bridges = 0;
 	struct acpi_hp_work *hp_work;
 	acpi_handle handle;
 	u32 type;
@@ -1212,23 +1139,7 @@ static void _handle_hotplug_event_bridge(struct work_struct *work)
 	hp_work = container_of(work, struct acpi_hp_work, work);
 	handle = hp_work->handle;
 	type = hp_work->type;
-
-	if (acpi_bus_get_device(handle, &device)) {
-		/* This bridge must have just been physically inserted */
-		handle_p2p_bridge_insertion(handle, type);
-		goto out;
-	}
-
-	bridge = acpiphp_handle_to_bridge(handle);
-	if (type == ACPI_NOTIFY_BUS_CHECK) {
-		acpi_walk_namespace(ACPI_TYPE_DEVICE, handle, ACPI_UINT32_MAX,
-			count_sub_bridges, NULL, &num_sub_bridges, NULL);
-	}
-
-	if (!bridge && !num_sub_bridges) {
-		err("cannot get bridge info\n");
-		goto out;
-	}
+	bridge = (struct acpiphp_bridge *)hp_work->context;
 
 	acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);
 
@@ -1236,14 +1147,10 @@ static void _handle_hotplug_event_bridge(struct work_struct *work)
 	case ACPI_NOTIFY_BUS_CHECK:
 		/* bus re-enumerate */
 		dbg("%s: Bus check notify on %s\n", __func__, objname);
-		if (bridge) {
-			dbg("%s: re-enumerating slots under %s\n",
-				__func__, objname);
-			acpiphp_check_bridge(bridge);
-		}
-		if (num_sub_bridges)
-			acpi_walk_namespace(ACPI_TYPE_DEVICE, handle,
-				ACPI_UINT32_MAX, check_sub_bridges, NULL, NULL, NULL);
+		dbg("%s: re-enumerating slots under %s\n", __func__, objname);
+		acpiphp_check_bridge(bridge);
+		acpi_walk_namespace(ACPI_TYPE_DEVICE, handle,
+			ACPI_UINT32_MAX, check_sub_bridges, NULL, NULL, NULL);
 		break;
 
 	case ACPI_NOTIFY_DEVICE_CHECK:
@@ -1260,8 +1167,7 @@ static void _handle_hotplug_event_bridge(struct work_struct *work)
 	case ACPI_NOTIFY_EJECT_REQUEST:
 		/* request device eject */
 		dbg("%s: Device eject notify on %s\n", __func__, objname);
-		if ((bridge->type != BRIDGE_TYPE_HOST) &&
-		    (bridge->flags & BRIDGE_HAS_EJ0)) {
+		if ((bridge->flags & BRIDGE_HAS_EJ0) && bridge->func) {
 			struct acpiphp_slot *slot;
 			slot = bridge->func->slot;
 			if (!acpiphp_disable_slot(slot))
@@ -1289,7 +1195,6 @@ static void _handle_hotplug_event_bridge(struct work_struct *work)
 		break;
 	}
 
-out:
 	kfree(hp_work); /* allocated in handle_hotplug_event_bridge */
 }
 
@@ -1324,17 +1229,14 @@ static void _handle_hotplug_event_func(struct work_struct *work)
 	struct acpi_hp_work *hp_work;
 	acpi_handle handle;
 	u32 type;
-	void *context;
 
 	hp_work = container_of(work, struct acpi_hp_work, work);
 	handle = hp_work->handle;
 	type = hp_work->type;
-	context = hp_work->context;
+	func = (struct acpiphp_func *)hp_work->context;
 
 	acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);
 
-	func = (struct acpiphp_func *)context;
-
 	switch (type) {
 	case ACPI_NOTIFY_BUS_CHECK:
 		/* bus re-enumerate */
-- 
1.7.9.5

