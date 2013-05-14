Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537Ab3ENNAN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 09:00:13 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:55556 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757500Ab3ENNAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 09:00:10 -0400
From: Jiang Liu <liuj97@gmail.com>
To: "Rafael J . Wysocki" <rjw@sisk.pl>, Bjorn Helgaas <bhelgaas@google.com>,
        Yinghai Lu <yinghai@kernel.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, Gu Zheng <guz.fnst@cn.fujitsu.com>,
        Toshi Kani <toshi.kani@hp.com>, Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH v1 1/2] ACPI, PCI: remove unused global list acpi_pci_roots in pci_root.c
Date: Tue, 14 May 2013 20:59:55 +0800
Message-Id: <1368536396-19375-1-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now the global list acpi_pci_roots pci_root.c is useless, remove it.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Len Brown <lenb@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/acpi/pci_root.c | 25 +++----------------------
 include/acpi/acpi_bus.h |  1 -
 2 files changed, 3 insertions(+), 23 deletions(-)

diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index b80e06e..91ddfd6 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -65,10 +65,6 @@ static struct acpi_scan_handler pci_root_handler = {
 	.detach = acpi_pci_root_remove,
 };
 
-/* Lock to protect both acpi_pci_roots lists */
-static DEFINE_MUTEX(acpi_pci_root_lock);
-static LIST_HEAD(acpi_pci_roots);
-
 static DEFINE_MUTEX(osc_lock);
 
 /**
@@ -423,7 +419,6 @@ static int acpi_pci_root_add(struct acpi_device *device,
 		}
 	}
 
-	INIT_LIST_HEAD(&root->node);
 	root->device = device;
 	root->segment = segment & 0xFFFF;
 	strcpy(acpi_device_name(device), ACPI_PCI_ROOT_DEVICE_NAME);
@@ -501,10 +496,6 @@ static int acpi_pci_root_add(struct acpi_device *device,
 	 * TBD: Need PCI interface for enumeration/configuration of roots.
 	 */
 
-	mutex_lock(&acpi_pci_root_lock);
-	list_add_tail(&root->node, &acpi_pci_roots);
-	mutex_unlock(&acpi_pci_root_lock);
-
 	/*
 	 * Scan the Root Bridge
 	 * --------------------
@@ -518,7 +509,7 @@ static int acpi_pci_root_add(struct acpi_device *device,
 			    "Bus %04x:%02x not present in PCI namespace\n",
 			    root->segment, (unsigned int)root->secondary.start);
 		result = -ENODEV;
-		goto out_del_root;
+		goto end;
 	}
 
 	/* ASPM setting */
@@ -538,20 +529,13 @@ static int acpi_pci_root_add(struct acpi_device *device,
 	if (system_state != SYSTEM_BOOTING) {
 		pcibios_resource_survey_bus(root->bus);
 		pci_assign_unassigned_bus_resources(root->bus);
-	}
-
-	/* need to after hot-added ioapic is registered */
-	if (system_state != SYSTEM_BOOTING)
+		/* need to after hot-added ioapic is registered */
 		pci_enable_bridges(root->bus);
+	}
 
 	pci_bus_add_devices(root->bus);
 	return 1;
 
-out_del_root:
-	mutex_lock(&acpi_pci_root_lock);
-	list_del(&root->node);
-	mutex_unlock(&acpi_pci_root_lock);
-
 end:
 	kfree(root);
 	return result;
@@ -568,9 +552,6 @@ static void acpi_pci_root_remove(struct acpi_device *device)
 
 	pci_remove_root_bus(root->bus);
 
-	mutex_lock(&acpi_pci_root_lock);
-	list_del(&root->node);
-	mutex_unlock(&acpi_pci_root_lock);
 	kfree(root);
 }
 
diff --git a/include/acpi/acpi_bus.h b/include/acpi/acpi_bus.h
index 22ba56e..4eb9a88 100644
--- a/include/acpi/acpi_bus.h
+++ b/include/acpi/acpi_bus.h
@@ -447,7 +447,6 @@ int register_acpi_bus_type(struct acpi_bus_type *);
 int unregister_acpi_bus_type(struct acpi_bus_type *);
 
 struct acpi_pci_root {
-	struct list_head node;
 	struct acpi_device * device;
 	struct pci_bus *bus;
 	u16 segment;
-- 
1.8.1.2

