Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758011Ab3DLPsO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 11:48:14 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:44901 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757738Ab3DLPsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 11:48:11 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, "Rafael J . Wysocki" <rjw@sisk.pl>
Cc: Myron Stowe <myron.stowe@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Jiang Liu <jiang.liu@huawei.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH v9 16/16] PCI, ACPI: remove support of ACPI PCI subdrivers
Date: Fri, 12 Apr 2013 23:44:30 +0800
Message-Id: <1365781470-32379-17-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1365781470-32379-1-git-send-email-jiang.liu@huawei.com>
References: <1365781470-32379-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Myron Stowe <myron.stowe@redhat.com>

Both sub-drivers of the "PCI Root Bridge ("pci_bridge")" driver, "acpiphp"
and "pci_slot", have been converted to hook directly into the PCI core.

With the conversions there are no remaining usages of the 'struct
acpi_pci_driver' list based infrastructure.  This patch removes it.

Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Toshi Kani <toshi.kani@hp.com>
Cc: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/acpi/pci_root.c |   48 +----------------------------------------------
 include/linux/acpi.h    |    9 ---------
 2 files changed, 1 insertion(+), 56 deletions(-)

diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index 0ac546d..b80e06e 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -65,44 +65,12 @@ static struct acpi_scan_handler pci_root_handler = {
 	.detach = acpi_pci_root_remove,
 };
 
-/* Lock to protect both acpi_pci_roots and acpi_pci_drivers lists */
+/* Lock to protect both acpi_pci_roots lists */
 static DEFINE_MUTEX(acpi_pci_root_lock);
 static LIST_HEAD(acpi_pci_roots);
-static LIST_HEAD(acpi_pci_drivers);
 
 static DEFINE_MUTEX(osc_lock);
 
-int acpi_pci_register_driver(struct acpi_pci_driver *driver)
-{
-	int n = 0;
-	struct acpi_pci_root *root;
-
-	mutex_lock(&acpi_pci_root_lock);
-	list_add_tail(&driver->node, &acpi_pci_drivers);
-	if (driver->add)
-		list_for_each_entry(root, &acpi_pci_roots, node) {
-			driver->add(root);
-			n++;
-		}
-	mutex_unlock(&acpi_pci_root_lock);
-
-	return n;
-}
-EXPORT_SYMBOL(acpi_pci_register_driver);
-
-void acpi_pci_unregister_driver(struct acpi_pci_driver *driver)
-{
-	struct acpi_pci_root *root;
-
-	mutex_lock(&acpi_pci_root_lock);
-	list_del(&driver->node);
-	if (driver->remove)
-		list_for_each_entry(root, &acpi_pci_roots, node)
-			driver->remove(root);
-	mutex_unlock(&acpi_pci_root_lock);
-}
-EXPORT_SYMBOL(acpi_pci_unregister_driver);
-
 /**
  * acpi_is_root_bridge - determine whether an ACPI CA node is a PCI root bridge
  * @handle - the ACPI CA node in question.
@@ -413,7 +381,6 @@ static int acpi_pci_root_add(struct acpi_device *device,
 	acpi_status status;
 	int result;
 	struct acpi_pci_root *root;
-	struct acpi_pci_driver *driver;
 	u32 flags, base_flags;
 	bool is_osc_granted = false;
 
@@ -573,12 +540,6 @@ static int acpi_pci_root_add(struct acpi_device *device,
 		pci_assign_unassigned_bus_resources(root->bus);
 	}
 
-	mutex_lock(&acpi_pci_root_lock);
-	list_for_each_entry(driver, &acpi_pci_drivers, node)
-		if (driver->add)
-			driver->add(root);
-	mutex_unlock(&acpi_pci_root_lock);
-
 	/* need to after hot-added ioapic is registered */
 	if (system_state != SYSTEM_BOOTING)
 		pci_enable_bridges(root->bus);
@@ -599,16 +560,9 @@ end:
 static void acpi_pci_root_remove(struct acpi_device *device)
 {
 	struct acpi_pci_root *root = acpi_driver_data(device);
-	struct acpi_pci_driver *driver;
 
 	pci_stop_root_bus(root->bus);
 
-	mutex_lock(&acpi_pci_root_lock);
-	list_for_each_entry_reverse(driver, &acpi_pci_drivers, node)
-		if (driver->remove)
-			driver->remove(root);
-	mutex_unlock(&acpi_pci_root_lock);
-
 	device_set_run_wake(root->bus->bridge, false);
 	pci_acpi_remove_bus_pm_notifier(device);
 
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index bcbdd74..03053ac 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -152,15 +152,6 @@ void acpi_penalize_isa_irq(int irq, int active);
 
 void acpi_pci_irq_disable (struct pci_dev *dev);
 
-struct acpi_pci_driver {
-	struct list_head node;
-	int (*add)(struct acpi_pci_root *root);
-	void (*remove)(struct acpi_pci_root *root);
-};
-
-int acpi_pci_register_driver(struct acpi_pci_driver *driver);
-void acpi_pci_unregister_driver(struct acpi_pci_driver *driver);
-
 extern int ec_read(u8 addr, u8 *val);
 extern int ec_write(u8 addr, u8 val);
 extern int ec_transaction(u8 command,
-- 
1.7.9.5

