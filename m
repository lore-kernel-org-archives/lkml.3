Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895Ab3EPPwQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 11:52:16 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:49572 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754847Ab3EPPwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 11:52:05 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Len Brown <lenb@kernel.org>, Feng Tang <feng.tang@intel.com>,
        linux-acpi@vger.kernel.org
Subject: [RFC PATCH v2, part3 11/11] PCI, ACPI, pci_root: use PCI bus lock to protect PCI device hotplug
Date: Thu, 16 May 2013 23:50:59 +0800
Message-Id: <1368719459-24800-12-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1368719459-24800-1-git-send-email-jiang.liu@huawei.com>
References: <1368719459-24800-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use PCI bus lock to protect concurrent PCI device hotplug operations.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: Len Brown <lenb@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Feng Tang <feng.tang@intel.com>
Cc: linux-kernel@vger.kernel.org
Cc: linux-acpi@vger.kernel.org
---
 arch/ia64/pci/pci.c     |  2 +-
 arch/x86/pci/acpi.c     |  3 ++-
 drivers/acpi/pci_root.c | 14 ++++++++------
 drivers/pci/Kconfig     |  2 +-
 4 files changed, 12 insertions(+), 9 deletions(-)

diff --git a/arch/ia64/pci/pci.c b/arch/ia64/pci/pci.c
index de1474f..6e91e87 100644
--- a/arch/ia64/pci/pci.c
+++ b/arch/ia64/pci/pci.c
@@ -384,7 +384,7 @@ struct pci_bus *pci_acpi_scan_root(struct acpi_pci_root *root)
 	}
 
 	pci_scan_child_bus(pbus);
-	return pbus;
+	return pci_bus_get(pbus);
 
 out3:
 	kfree(controller->window);
diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index b972f04..6dddc06 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -534,7 +534,7 @@ struct pci_bus *pci_acpi_scan_root(struct acpi_pci_root *root)
 		 */
 		memcpy(bus->sysdata, sd, sizeof(*sd));
 		kfree(info);
-		pci_bus_put(bus);
+		BUG_ON(pci_bus_lock(bus, PCI_BUS_STATE_REMOVED - 1, true) < 0);
 	} else {
 		probe_pci_root_info(info, device, busnum, domain);
 
@@ -561,6 +561,7 @@ struct pci_bus *pci_acpi_scan_root(struct acpi_pci_root *root)
 			pci_set_host_bridge_release(
 				to_pci_host_bridge(bus->bridge),
 				release_pci_root_info, info);
+			pci_bus_get(bus);
 		} else {
 			pci_free_resource_list(&resources);
 			__release_pci_root_info(info);
diff --git a/drivers/acpi/pci_root.c b/drivers/acpi/pci_root.c
index 21dda5a..eb01cc7 100644
--- a/drivers/acpi/pci_root.c
+++ b/drivers/acpi/pci_root.c
@@ -535,6 +535,7 @@ static int acpi_pci_root_add(struct acpi_device *device,
 	}
 
 	pci_bus_add_devices(root->bus);
+	pci_bus_unlock(root->bus, true);
 	return 1;
 
 end:
@@ -546,13 +547,14 @@ static void acpi_pci_root_remove(struct acpi_device *device)
 {
 	struct acpi_pci_root *root = acpi_driver_data(device);
 
-	pci_stop_root_bus(root->bus);
-
-	device_set_run_wake(root->bus->bridge, false);
-	pci_acpi_remove_bus_pm_notifier(device);
-
-	pci_remove_root_bus(root->bus);
+	if (pci_bus_lock(root->bus, PCI_BUS_STATE_REMOVED - 1, true) == 0) {
+		pci_stop_root_bus(root->bus);
+		device_set_run_wake(root->bus->bridge, false);
+		pci_acpi_remove_bus_pm_notifier(device);
+		pci_remove_root_bus(root->bus);
+	}
 
+	pci_bus_put(root->bus);
 	kfree(root);
 }
 
diff --git a/drivers/pci/Kconfig b/drivers/pci/Kconfig
index 92e69bd..5ae3504 100644
--- a/drivers/pci/Kconfig
+++ b/drivers/pci/Kconfig
@@ -121,4 +121,4 @@ config PCI_LABEL
 	select NLS
 
 config PCI_BUS_LOCK
-	def_bool n
+	def_bool y if (X86 || IA64)
-- 
1.8.1.2

