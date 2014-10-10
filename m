Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751665AbaJJHN0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 03:13:26 -0400
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:54721 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbaJJHNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 03:13:23 -0400
From: "Li, Zhen-Hua" <zhen-hual@hp.com>
To: Bjorn Helgaas <bhelgaas@google.com>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Cc: <linda.knippers@hp.com>, <jerry.hoemann@hp.com>, <lisa.mitchell@hp.com>,
        <alexander.duyck@gmail.com>, "Li, Zhen-Hua" <zhen-hual@hp.com>,
        Takao Indoh <indou.takao@jp.fujitsu.com>,
        Randy Wright <rwright@hp.com>
Subject: [PATCH 1/1] pci: fix dmar fault for kdump kernel
Date: Fri, 10 Oct 2014 15:13:11 +0800
Message-Id: <1412925191-27970-1-git-send-email-zhen-hual@hp.com>
X-Mailer: git-send-email 2.0.0-rc0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On a HP system with Intel vt-d supported and many PCI devices on it, 
when kernel crashed and the kdump kernel boots with intel_iommu=on, 
there may be some unexpected DMA requests on this adapter, which will 
cause DMA Remapping faults like:
    dmar: DRHD: handling fault status reg 102
    dmar: DMAR:[DMA Read] Request device [41:00.0] fault addr fff81000
    DMAR:[fault reason 01] Present bit in root entry is clear

This bug may happen on *any* PCI device.
Analysis for this bug:

The present bit is set in this function:

static struct context_entry * device_to_context_entry(
                struct intel_iommu *iommu, u8 bus, u8 devfn)
{
    ......
                set_root_present(root);
    ......
}

Calling tree:
    device driver
        intel_alloc_coherent
            __intel_map_single
                domain_context_mapping
                    domain_context_mapping_one
                        device_to_context_entry

This means, the present bit in root entry will not be set until the device 
driver is loaded.

But in the kdump kernel, hardware devices are not aware that control has 
transferred to the second kernel, and those drivers must initialize again. 
Consequently there may be unexpected DMA requests from devices activity
initiated in the first kernel leading to the DMA Remapping errors in the 
second kernel.

To fix this DMAR fault, we need to reset the bus that this device on. Reset 
the device itself does not work.

A patch for this bug that has been sent before:
https://lkml.org/lkml/2014/9/30/55
As in discussion, this bug may happen on *any* device, so we need to reset all 
pci devices.

There was an original version(Takao Indoh) that resets the pcie devices:
https://lkml.org/lkml/2013/5/14/9

Update of this new version, comparing with Takao Indoh's version:
    Add support for legacy PCI devices.
    Use pci_try_reset_bus instead of do_downstream_device_reset in original version

Randy Wright corrects some misunderstanding in this description.

Signed-off-by: Li, Zhen-Hua <zhen-hual@hp.com>
Signed-off-by: Takao Indoh <indou.takao@jp.fujitsu.com>
Signed-off-by: Randy Wright <rwright@hp.com>
---
 drivers/pci/pci.c | 84 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 84 insertions(+)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 2c9ac70..8cb146c 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -23,6 +23,7 @@
 #include <linux/device.h>
 #include <linux/pm_runtime.h>
 #include <linux/pci_hotplug.h>
+#include <linux/crash_dump.h>
 #include <asm-generic/pci-bridge.h>
 #include <asm/setup.h>
 #include "pci.h"
@@ -4423,6 +4424,89 @@ void __weak pci_fixup_cardbus(struct pci_bus *bus)
 }
 EXPORT_SYMBOL(pci_fixup_cardbus);
 
+/*
+ * Return true if dev is PCI root port or downstream port whose child is PCI
+ * endpoint except VGA device.
+ */
+static int __pci_dev_need_reset(struct pci_dev *dev)
+{
+	struct pci_bus *subordinate;
+	struct pci_dev *child;
+
+	if (dev->hdr_type != PCI_HEADER_TYPE_BRIDGE)
+		return 0;
+
+	if (pci_is_pcie(dev)) {
+		if ((pci_pcie_type(dev) != PCI_EXP_TYPE_ROOT_PORT) &&
+		    (pci_pcie_type(dev) != PCI_EXP_TYPE_DOWNSTREAM))
+			return 0;
+	}
+
+	subordinate = dev->subordinate;
+	list_for_each_entry(child, &subordinate->devices, bus_list) {
+		/* Don't reset switch, bridge, VGA device */
+		if ((child->hdr_type == PCI_HEADER_TYPE_BRIDGE) ||
+		    ((child->class >> 16) == PCI_BASE_CLASS_BRIDGE) ||
+		    ((child->class >> 16) == PCI_BASE_CLASS_DISPLAY))
+			return 0;
+
+		if (pci_is_pcie(child)) {
+			if ((pci_pcie_type(child) == PCI_EXP_TYPE_UPSTREAM) ||
+			    (pci_pcie_type(child) == PCI_EXP_TYPE_PCI_BRIDGE))
+				return 0;
+		}
+	}
+
+	return 1;
+}
+
+struct pci_dev_reset_entry {
+	struct list_head list;
+	struct pci_dev *dev;
+};
+int __init pci_reset_endpoints(void)
+{
+	struct pci_dev *dev = NULL;
+	struct pci_dev_reset_entry *pdev_entry, *tmp;
+	struct pci_bus *subordinate = NULL;
+	int has_it;
+
+	LIST_HEAD(pdev_list);
+
+	if (likely(!is_kdump_kernel()))
+		return 0;
+
+	for_each_pci_dev(dev) {
+		subordinate = dev->subordinate;
+		if (!subordinate || list_empty(&subordinate->devices))
+			continue;
+
+		has_it = 0;
+		list_for_each_entry(pdev_entry, &pdev_list, list) {
+			if (dev == pdev_entry->dev) {
+				has_it = 1;
+				break;
+			}
+		}
+		if (has_it)
+			continue;
+
+		if (__pci_dev_need_reset(dev)) {
+			pdev_entry = kmalloc(sizeof(*pdev_entry), GFP_KERNEL);
+			pdev_entry->dev = dev;
+			list_add(&pdev_entry->list, &pdev_list);
+		}
+	}
+
+	list_for_each_entry_safe(pdev_entry, tmp, &pdev_list, list) {
+		pci_try_reset_bus(pdev_entry->dev->subordinate);
+		kfree(pdev_entry);
+	}
+
+	return 0;
+}
+fs_initcall_sync(pci_reset_endpoints);
+
 static int __init pci_setup(char *str)
 {
 	while (str) {
-- 
2.0.0-rc0

