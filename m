Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122Ab3AKWnW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 17:43:22 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:38456 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756061Ab3AKWlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 17:41:21 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Len Brown <lenb@kernel.org>, Taku Izumi <izumi.taku@jp.fujitsu.com>,
        Jiang Liu <jiang.liu@huawei.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v8 15/22] ACPI, PCI: Simplify handle_root_bridge_removal()
Date: Fri, 11 Jan 2013 14:40:42 -0800
Message-Id: <1357944049-29620-16-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1357944049-29620-1-git-send-email-yinghai@kernel.org>
References: <1357944049-29620-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tang Chen found handle_root_bridge_removal is very similiar to
acpi_bus_hot_remove_device().
Only difference is that it call trim two times.

Change to handle_root_bridge_removal to call trim one time and then
use acpi_bus_hot_remove_device.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 drivers/acpi/pci_root.c |   49 ++++++++---------------------------------------
 1 file changed, 8 insertions(+), 41 deletions(-)

diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index 697ec65..8a0e2e2 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -745,56 +745,23 @@ static void handle_root_bridge_insertion(acpi_handle handle)
 		printk(KERN_ERR "cannot add bridge to acpi list\n");
 }
 
-static int acpi_root_evaluate_object(acpi_handle handle, char *cmd, int val)
-{
-	acpi_status status;
-	struct acpi_object_list arg_list;
-	union acpi_object arg;
-
-	arg_list.count = 1;
-	arg_list.pointer = &arg;
-	arg.type = ACPI_TYPE_INTEGER;
-	arg.integer.value = val;
-
-	status = acpi_evaluate_object(handle, cmd, &arg_list, NULL);
-	if (ACPI_FAILURE(status)) {
-		pr_warn("%s: %s to %d failed\n",
-				 __func__, cmd, val);
-		return -1;
-	}
-
-	return 0;
-}
-
 static void handle_root_bridge_removal(struct acpi_device *device)
 {
 	int ret_val;
-	u32 flags = 0;
-	acpi_handle dummy_handle;
-	acpi_handle handle = device->handle;
+	struct acpi_eject_event *ej_event;
+
+	ej_event = kmalloc(sizeof(*ej_event), GFP_KERNEL);
+	if (!ej_event)
+		return;
 
-	if (ACPI_SUCCESS(acpi_get_handle(handle, "_EJ0", &dummy_handle)))
-		flags |= ROOT_BRIDGE_HAS_EJ0;
-	if (ACPI_SUCCESS(acpi_get_handle(handle, "_PS3", &dummy_handle)))
-		flags |= ROOT_BRIDGE_HAS_PS3;
+	ej_event->device = device;
+	ej_event->event = ACPI_NOTIFY_EJECT_REQUEST;
 
 	/* remove pci devices at first */
 	ret_val = acpi_bus_trim(device, 0);
 	printk(KERN_DEBUG "acpi_bus_trim stop return %x\n", ret_val);
 
-	/* remove acpi devices */
-	ret_val = acpi_bus_trim(device, 1);
-	printk(KERN_DEBUG "acpi_bus_trim remove return %x\n", ret_val);
-
-	if (flags & ROOT_BRIDGE_HAS_PS3) {
-		acpi_status status;
-
-		status = acpi_evaluate_object(handle, "_PS3", NULL, NULL);
-		if (ACPI_FAILURE(status))
-			pr_warn("%s: _PS3 failed\n", __func__);
-	}
-	if (flags & ROOT_BRIDGE_HAS_EJ0)
-		acpi_root_evaluate_object(handle, "_EJ0", 1);
+	acpi_bus_hot_remove_device(ej_event);
 }
 
 static void _handle_hotplug_event_root(struct work_struct *work)
-- 
1.7.10.4

