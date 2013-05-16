Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab3EPPv7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 11:51:59 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:34568 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754806Ab3EPPvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 11:51:55 -0400
From: Jiang Liu <liuj97@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>
Cc: Jiang Liu <jiang.liu@huawei.com>, "Rafael J . Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, Jiang Liu <liuj97@gmail.com>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [RFC PATCH v2, part3 09/11] PCI, acpiphp: use PCI bus lock to protect PCI device hotplug
Date: Thu, 16 May 2013 23:50:57 +0800
Message-Id: <1368719459-24800-10-git-send-email-jiang.liu@huawei.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1368719459-24800-1-git-send-email-jiang.liu@huawei.com>
References: <1368719459-24800-1-git-send-email-jiang.liu@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use PCI bus lock to protect concurrent PCI device hotplug operations.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: Yijing Wang <wangyijing@huawei.com>
Cc: linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 drivers/pci/hotplug/acpiphp_glue.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
index e330331..d105dcd 100644
--- a/drivers/pci/hotplug/acpiphp_glue.c
+++ b/drivers/pci/hotplug/acpiphp_glue.c
@@ -674,6 +674,9 @@ static int __ref enable_device(struct acpiphp_slot *slot)
 	if (slot->flags & SLOT_ENABLED)
 		goto err_exit;
 
+	if (pci_bus_lock(bus, PCI_BUS_STATE_STOPPING - 1, true) < 0)
+		goto err_exit;
+
 	list_for_each_entry(func, &slot->funcs, sibling)
 		acpiphp_bus_add(func);
 
@@ -681,7 +684,7 @@ static int __ref enable_device(struct acpiphp_slot *slot)
 	if (num == 0) {
 		/* Maybe only part of funcs are added. */
 		dbg("No new device found\n");
-		goto err_exit;
+		goto out_unlock;
 	}
 
 	max = acpiphp_max_busnr(bus);
@@ -726,8 +729,9 @@ static int __ref enable_device(struct acpiphp_slot *slot)
 		}
 	}
 
-
- err_exit:
+out_unlock:
+	pci_bus_unlock(bus, true);
+err_exit:
 	return 0;
 }
 
@@ -757,7 +761,10 @@ static int disable_device(struct acpiphp_slot *slot)
 {
 	struct acpiphp_func *func;
 	struct pci_dev *pdev;
+	struct pci_bus *bus = slot->bridge->pci_bus;
 
+	if (pci_bus_lock(bus, PCI_BUS_STATE_STOPPING - 1, true) < 0)
+		return -EBUSY;
 	/*
 	 * enable_device() enumerates all functions in this device via
 	 * pci_scan_slot(), whether they have associated ACPI hotplug
@@ -768,6 +775,7 @@ static int disable_device(struct acpiphp_slot *slot)
 		pci_stop_and_remove_bus_device(pdev);
 		pci_dev_put(pdev);
 	}
+	pci_bus_unlock(bus, true);
 
 	list_for_each_entry(func, &slot->funcs, sibling) {
 		acpiphp_bus_trim(func->handle);
-- 
1.8.1.2

