Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099Ab3AKWlZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 17:41:25 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:38430 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755882Ab3AKWlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 17:41:18 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Len Brown <lenb@kernel.org>, Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v8 13/22] PCI, ACPI: remove acpi_root_bridge in pci_root_hp
Date: Fri, 11 Jan 2013 14:40:40 -0800
Message-Id: <1357944049-29620-14-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357944049-29620-1-git-send-email-yinghai@kernel.org>
References: <1357944049-29620-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tang noticed that hotplug through container will not update acpi_root_bridge
list.

After closely checking, we don't need that for struct for tracking and
could use acpi_pci_root directly.

Reported-by: Tang Chen <tangchen@cn.fujitsu.com>
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/acpi/pci_root.c |  109 +++++++++--------------------------------------
 1 file changed, 20 insertions(+), 89 deletions(-)

diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index 862abcc..697ec65 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -679,73 +679,12 @@ int __init acpi_pci_root_init(void)
  *	only support root bridge
  */
 
-static LIST_HEAD(acpi_root_bridge_list);
-struct acpi_root_bridge {
-	struct list_head list;
-	acpi_handle handle;
-	u32 flags;
-};
-
 /* bridge flags */
 #define ROOT_BRIDGE_HAS_EJ0	(0x00000002)
 #define ROOT_BRIDGE_HAS_PS3	(0x00000080)
 
 #define ACPI_STA_FUNCTIONING	(0x00000008)
 
-static struct acpi_root_bridge *acpi_root_handle_to_bridge(acpi_handle handle)
-{
-	struct acpi_root_bridge *bridge;
-
-	list_for_each_entry(bridge, &acpi_root_bridge_list, list)
-		if (bridge->handle == handle)
-			return bridge;
-
-	return NULL;
-}
-
-/* allocate and initialize host bridge data structure */
-static void add_acpi_root_bridge(acpi_handle handle)
-{
-	struct acpi_root_bridge *bridge;
-	acpi_handle dummy_handle;
-	acpi_status status;
-
-	/* if the bridge doesn't have _STA, we assume it is always there */
-	status = acpi_get_handle(handle, "_STA", &dummy_handle);
-	if (ACPI_SUCCESS(status)) {
-		unsigned long long tmp;
-
-		status = acpi_evaluate_integer(handle, "_STA", NULL, &tmp);
-		if (ACPI_FAILURE(status)) {
-			printk(KERN_DEBUG "%s: _STA evaluation failure\n",
-						 __func__);
-			return;
-		}
-		if ((tmp & ACPI_STA_FUNCTIONING) == 0)
-			/* don't register this object */
-			return;
-	}
-
-	bridge = kzalloc(sizeof(struct acpi_root_bridge), GFP_KERNEL);
-	if (!bridge)
-		return;
-
-	bridge->handle = handle;
-
-	if (ACPI_SUCCESS(acpi_get_handle(handle, "_EJ0", &dummy_handle)))
-		bridge->flags |= ROOT_BRIDGE_HAS_EJ0;
-	if (ACPI_SUCCESS(acpi_get_handle(handle, "_PS3", &dummy_handle)))
-		bridge->flags |= ROOT_BRIDGE_HAS_PS3;
-
-	list_add(&bridge->list, &acpi_root_bridge_list);
-}
-
-static void remove_acpi_root_bridge(struct acpi_root_bridge *bridge)
-{
-	list_del(&bridge->list);
-	kfree(bridge);
-}
-
 struct acpi_root_hp_work {
 	struct work_struct work;
 	acpi_handle handle;
@@ -827,28 +766,25 @@ static int acpi_root_evaluate_object(acpi_handle handle, char *cmd, int val)
 	return 0;
 }
 
-static void handle_root_bridge_removal(acpi_handle handle,
-		 struct acpi_root_bridge *bridge)
+static void handle_root_bridge_removal(struct acpi_device *device)
 {
+	int ret_val;
 	u32 flags = 0;
-	struct acpi_device *device;
+	acpi_handle dummy_handle;
+	acpi_handle handle = device->handle;
 
-	if (bridge) {
-		flags = bridge->flags;
-		remove_acpi_root_bridge(bridge);
-	}
+	if (ACPI_SUCCESS(acpi_get_handle(handle, "_EJ0", &dummy_handle)))
+		flags |= ROOT_BRIDGE_HAS_EJ0;
+	if (ACPI_SUCCESS(acpi_get_handle(handle, "_PS3", &dummy_handle)))
+		flags |= ROOT_BRIDGE_HAS_PS3;
 
-	if (!acpi_bus_get_device(handle, &device)) {
-		int ret_val;
+	/* remove pci devices at first */
+	ret_val = acpi_bus_trim(device, 0);
+	printk(KERN_DEBUG "acpi_bus_trim stop return %x\n", ret_val);
 
-		/* remove pci devices at first */
-		ret_val = acpi_bus_trim(device, 0);
-		printk(KERN_DEBUG "acpi_bus_trim stop return %x\n", ret_val);
-
-		/* remove acpi devices */
-		ret_val = acpi_bus_trim(device, 1);
-		printk(KERN_DEBUG "acpi_bus_trim remove return %x\n", ret_val);
-	}
+	/* remove acpi devices */
+	ret_val = acpi_bus_trim(device, 1);
+	printk(KERN_DEBUG "acpi_bus_trim remove return %x\n", ret_val);
 
 	if (flags & ROOT_BRIDGE_HAS_PS3) {
 		acpi_status status;
@@ -863,7 +799,7 @@ static void handle_root_bridge_removal(acpi_handle handle,
 
 static void _handle_hotplug_event_root(struct work_struct *work)
 {
-	struct acpi_root_bridge *bridge;
+	struct acpi_pci_root *root;
 	char objname[64];
 	struct acpi_buffer buffer = { .length = sizeof(objname),
 				      .pointer = objname };
@@ -875,7 +811,7 @@ static void _handle_hotplug_event_root(struct work_struct *work)
 	handle = hp_work->handle;
 	type = hp_work->type;
 
-	bridge = acpi_root_handle_to_bridge(handle);
+	root = acpi_pci_find_root(handle);
 
 	acpi_get_name(handle, ACPI_FULL_PATHNAME, &buffer);
 
@@ -884,10 +820,8 @@ static void _handle_hotplug_event_root(struct work_struct *work)
 		/* bus enumerate */
 		printk(KERN_DEBUG "%s: Bus check notify on %s\n", __func__,
 				 objname);
-		if (!bridge) {
+		if (!root)
 			handle_root_bridge_insertion(handle);
-			add_acpi_root_bridge(handle);
-		}
 
 		break;
 
@@ -895,17 +829,16 @@ static void _handle_hotplug_event_root(struct work_struct *work)
 		/* device check */
 		printk(KERN_DEBUG "%s: Device check notify on %s\n", __func__,
 				 objname);
-		if (!bridge) {
+		if (!root)
 			handle_root_bridge_insertion(handle);
-			add_acpi_root_bridge(handle);
-		}
 		break;
 
 	case ACPI_NOTIFY_EJECT_REQUEST:
 		/* request device eject */
 		printk(KERN_DEBUG "%s: Device eject notify on %s\n", __func__,
 				 objname);
-		handle_root_bridge_removal(handle, bridge);
+		if (root)
+			handle_root_bridge_removal(root->device);
 		break;
 	default:
 		printk(KERN_WARNING "notify_handler: unknown event type 0x%x for %s\n",
@@ -965,8 +898,6 @@ find_root_bridges(acpi_handle handle, u32 lvl, void *context, void **rv)
 		printk(KERN_DEBUG "acpi root: %s notify handler is installed\n",
 				 objname);
 
-	add_acpi_root_bridge(handle);
-
 	return AE_OK;
 }
 
-- 
1.7.10.4

