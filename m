Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752818Ab3AUVYB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 16:24:01 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:38472 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756720Ab3AUVVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 16:21:31 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Len Brown <lenb@kernel.org>, Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v10 07/11] PCI, acpiphp: Move and enhance hotplug support of pci host bridge
Date: Mon, 21 Jan 2013 13:20:48 -0800
Message-Id: <1358803252-20639-8-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1358803252-20639-1-git-send-email-yinghai@kernel.org>
References: <1358803252-20639-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have partial hot-add support in acpiphp driver, and it is confusing.

Move host bridge hot-add support to pci_root.c, and keep acpiphp simple,
also add hot-remove support in pci_root.c.

How to test it: if sci_emu patch is applied,

Find out root bus number to acpi root name mapping from dmesg or /sys

  echo "\_SB.PCIB 3" > /sys/kernel/debug/acpi/sci_notify
to remove root bus

  echo "\_SB.PCIB 1" > /sys/kernel/debug/acpi/sci_notify
to add back root bus

-v2: put back pci_root_hp change in one patch
-v3: add pcibios_resource_survey_bus() calling
-v4: remove not needed code with remove_bridge
-v5: put back support for acpiphp support for slots just on root bus.
-v6: change some functions to *_p2p_* to make it more clean.
-v7: split hot_added change out.
-v8: Move to pci_root.c instead of adding another file requested by Bjorn.
-v9: Fold three following patches into this one for easy review:
	a: Add missing hot_remove support for root device.
	b: Tang Chen noticed that hotplug through container will not update
	   acpi_root_bridge list. After closely checking, we don't need
	   that for struct for tracking and could use acpi_pci_root directly.
	c: Tang Chen found handle_root_bridge_removal is very similiar to
	   acpi_bus_hot_remove_device().  Change to handle_root_bridge_removal
	   to use acpi_bus_hot_remove_device.
-v10: According to Rafael:
	a. don't use __initcall for acpi_pci_root_hp_init.
	b. bail out on hot add path if acpi device exists.
	c. don't use fixed size buffer with root bridge handle name.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/acpi/internal.h            |    1 +
 drivers/acpi/pci_root.c            |  124 ++++++++++++++++++++++++++++++++++++
 drivers/acpi/scan.c                |    3 +
 drivers/pci/hotplug/acpiphp_glue.c |   59 +++++------------
 4 files changed, 143 insertions(+), 44 deletions(-)

diff --git a/drivers/acpi/internal.h b/drivers/acpi/internal.h
index e050254..0f24148 100644
--- a/drivers/acpi/internal.h
+++ b/drivers/acpi/internal.h
@@ -68,6 +68,7 @@ struct acpi_ec {
 extern struct acpi_ec *first_ec;
 
 int acpi_pci_root_init(void);
+void acpi_pci_root_hp_init(void);
 int acpi_ec_init(void);
 int acpi_ec_ecdt_probe(void);
 int acpi_boot_ec_enable(void);
diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index bf5108a..a2d2c4c 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -655,3 +655,127 @@ int __init acpi_pci_root_init(void)
 
 	return 0;
 }
+/* Support root bridge hotplug */
+
+static void handle_root_bridge_insertion(acpi_handle handle)
+{
+	struct acpi_device *device;
+
+	if (!acpi_bus_get_device(handle, &device)) {
+		printk(KERN_DEBUG "acpi device exists...\n");
+		return;
+	}
+
+	if (acpi_bus_scan(handle))
+		printk(KERN_ERR "cannot add bridge to acpi list\n");
+}
+
+static void handle_root_bridge_removal(struct acpi_device *device)
+{
+	struct acpi_eject_event *ej_event;
+
+	ej_event = kmalloc(sizeof(*ej_event), GFP_KERNEL);
+	if (!ej_event) {
+		/* Inform firmware the hot-remove operation has error */
+		(void) acpi_evaluate_hotplug_ost(device->handle,
+					ACPI_NOTIFY_EJECT_REQUEST,
+					ACPI_OST_SC_NON_SPECIFIC_FAILURE,
+					NULL);
+		return;
+	}
+
+	ej_event->device = device;
+	ej_event->event = ACPI_NOTIFY_EJECT_REQUEST;
+
+	acpi_bus_hot_remove_device(ej_event);
+}
+
+static void _handle_hotplug_event_root(struct work_struct *work)
+{
+	struct acpi_pci_root *root;
+	struct acpi_buffer buffer = { ACPI_ALLOCATE_BUFFER };
+	struct acpi_hp_work *hp_work;
+	acpi_handle handle;
+	u32 type;
+
+	hp_work = container_of(work, struct acpi_hp_work, work);
+	handle = hp_work->handle;
+	type = hp_work->type;
+
+	root = acpi_pci_find_root(handle);
+
+	acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);
+
+	switch (type) {
+	case ACPI_NOTIFY_BUS_CHECK:
+		/* bus enumerate */
+		printk(KERN_DEBUG "%s: Bus check notify on %s\n", __func__,
+				 (char *)buffer.pointer);
+		if (!root)
+			handle_root_bridge_insertion(handle);
+
+		break;
+
+	case ACPI_NOTIFY_DEVICE_CHECK:
+		/* device check */
+		printk(KERN_DEBUG "%s: Device check notify on %s\n", __func__,
+				 (char *)buffer.pointer);
+		if (!root)
+			handle_root_bridge_insertion(handle);
+		break;
+
+	case ACPI_NOTIFY_EJECT_REQUEST:
+		/* request device eject */
+		printk(KERN_DEBUG "%s: Device eject notify on %s\n", __func__,
+				 (char *)buffer.pointer);
+		if (root)
+			handle_root_bridge_removal(root->device);
+		break;
+	default:
+		printk(KERN_WARNING "notify_handler: unknown event type 0x%x for %s\n",
+				 type, (char *)buffer.pointer);
+		break;
+	}
+
+	kfree(hp_work); /* allocated in handle_hotplug_event_bridge */
+	kfree(buffer.pointer);
+}
+
+static void handle_hotplug_event_root(acpi_handle handle, u32 type,
+					void *context)
+{
+	alloc_acpi_hp_work(handle, type, context,
+				_handle_hotplug_event_root);
+}
+
+static acpi_status __init
+find_root_bridges(acpi_handle handle, u32 lvl, void *context, void **rv)
+{
+	char objname[64];
+	struct acpi_buffer buffer = { .length = sizeof(objname),
+				      .pointer = objname };
+	int *count = (int *)context;
+
+	if (!acpi_is_root_bridge(handle))
+		return AE_OK;
+
+	(*count)++;
+
+	acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);
+
+	acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
+				handle_hotplug_event_root, NULL);
+	printk(KERN_DEBUG "acpi root: %s notify handler installed\n", objname);
+
+	return AE_OK;
+}
+
+void __init acpi_pci_root_hp_init(void)
+{
+	int num = 0;
+
+	acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
+		ACPI_UINT32_MAX, find_root_bridges, NULL, &num, NULL);
+
+	printk(KERN_DEBUG "Found %d acpi root devices\n", num);
+}
diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
index 7c43bdc..bc2f337 100644
--- a/drivers/acpi/scan.c
+++ b/drivers/acpi/scan.c
@@ -1706,5 +1706,8 @@ int __init acpi_scan_init(void)
 	}
 
 	acpi_update_all_gpes();
+
+	acpi_pci_root_hp_init();
+
 	return 0;
 }
diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index bf338d2..c4a6301 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -543,10 +543,13 @@ static void cleanup_bridge(struct acpiphp_bridge *bridge)
 	acpi_status status;
 	acpi_handle handle = bridge->handle;
 
-	status = acpi_remove_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
+	if (bridge->type != BRIDGE_TYPE_HOST) {
+		status = acpi_remove_notify_handler(handle,
+					    ACPI_SYSTEM_NOTIFY,
 					    handle_hotplug_event_bridge);
-	if (ACPI_FAILURE(status))
-		err("failed to remove notify handler\n");
+		if (ACPI_FAILURE(status))
+			err("failed to remove notify handler\n");
+	}
 
 	if ((bridge->type != BRIDGE_TYPE_HOST) &&
 	    ((bridge->flags & BRIDGE_HAS_EJ0) && bridge->func)) {
@@ -630,9 +633,6 @@ static void remove_bridge(struct acpi_pci_root *root)
 	bridge = acpiphp_handle_to_bridge(handle);
 	if (bridge)
 		cleanup_bridge(bridge);
-	else
-		acpi_remove_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
-					   handle_hotplug_event_bridge);
 }
 
 static int power_on_slot(struct acpiphp_slot *slot)
@@ -1123,18 +1123,12 @@ static void acpiphp_sanitize_bus(struct pci_bus *bus)
 }
 
 /* Program resources in newly inserted bridge */
-static int acpiphp_configure_bridge (acpi_handle handle)
+static int acpiphp_configure_p2p_bridge(acpi_handle handle)
 {
-	struct pci_bus *bus;
+	struct pci_dev *pdev = acpi_get_pci_dev(handle);
+	struct pci_bus *bus = pdev->subordinate;
 
-	if (acpi_is_root_bridge(handle)) {
-		struct acpi_pci_root *root = acpi_pci_find_root(handle);
-		bus = root->bus;
-	} else {
-		struct pci_dev *pdev = acpi_get_pci_dev(handle);
-		bus = pdev->subordinate;
-		pci_dev_put(pdev);
-	}
+	pci_dev_put(pdev);
 
 	pci_bus_size_bridges(bus);
 	pci_bus_assign_resources(bus);
@@ -1144,7 +1138,7 @@ static int acpiphp_configure_bridge (acpi_handle handle)
 	return 0;
 }
 
-static void handle_bridge_insertion(acpi_handle handle, u32 type)
+static void handle_p2p_bridge_insertion(acpi_handle handle, u32 type)
 {
 	struct acpi_device *device;
 
@@ -1162,8 +1156,8 @@ static void handle_bridge_insertion(acpi_handle handle, u32 type)
 		err("ACPI device object missing\n");
 		return;
 	}
-	if (!acpiphp_configure_bridge(handle))
-		add_bridge(handle);
+	if (!acpiphp_configure_p2p_bridge(handle))
+		add_p2p_bridge(handle);
 	else
 		err("cannot configure and start bridge\n");
 
@@ -1221,7 +1215,7 @@ static void _handle_hotplug_event_bridge(struct work_struct *work)
 
 	if (acpi_bus_get_device(handle, &device)) {
 		/* This bridge must have just been physically inserted */
-		handle_bridge_insertion(handle, type);
+		handle_p2p_bridge_insertion(handle, type);
 		goto out;
 	}
 
@@ -1396,21 +1390,6 @@ static void handle_hotplug_event_func(acpi_handle handle, u32 type,
 	alloc_acpi_hp_work(handle, type, context, _handle_hotplug_event_func);
 }
 
-static acpi_status
-find_root_bridges(acpi_handle handle, u32 lvl, void *context, void **rv)
-{
-	int *count = (int *)context;
-
-	if (!acpi_is_root_bridge(handle))
-		return AE_OK;
-
-	(*count)++;
-	acpi_install_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
-				    handle_hotplug_event_bridge, NULL);
-
-	return AE_OK ;
-}
-
 static struct acpi_pci_driver acpi_pci_hp_driver = {
 	.add =		add_bridge,
 	.remove =	remove_bridge,
@@ -1421,15 +1400,7 @@ static struct acpi_pci_driver acpi_pci_hp_driver = {
  */
 int __init acpiphp_glue_init(void)
 {
-	int num = 0;
-
-	acpi_walk_namespace(ACPI_TYPE_DEVICE, ACPI_ROOT_OBJECT,
-			ACPI_UINT32_MAX, find_root_bridges, NULL, &num, NULL);
-
-	if (num <= 0)
-		return -1;
-	else
-		acpi_pci_register_driver(&acpi_pci_hp_driver);
+	acpi_pci_register_driver(&acpi_pci_hp_driver);
 
 	return 0;
 }
-- 
1.7.10.4

