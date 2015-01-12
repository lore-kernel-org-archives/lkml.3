Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754554AbbALTY3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 14:24:29 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:48055 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932342AbbALTY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 14:24:26 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-ia64@vger.kernel.org
Subject: [PATCH 05/10] PCI, ia64: clip firmware assigned resource under parent bridge's
Date: Mon, 12 Jan 2015 11:23:15 -0800
Message-Id: <1421090600-9750-6-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1421090600-9750-1-git-send-email-yinghai@kernel.org>
References: <1421090600-9750-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some bios put range that is not fully coverred by root bus resources.
Try to clip them and update them in pci bridge bars.

We'd like to fix other arches instead of just x86.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=85491
Reported-by: Marek Kordik <kordikmarek@gmail.com>
Fixes: 5b28541552ef ("PCI: Restrict 64-bit prefetchable bridge windows to 64-bit resources")
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: linux-ia64@vger.kernel.org
---
 arch/ia64/pci/pci.c | 71 +++++++++++++++++++++++++++++++++--------------------
 1 file changed, 44 insertions(+), 27 deletions(-)

diff --git a/arch/ia64/pci/pci.c b/arch/ia64/pci/pci.c
index 291a582..a3f9e27 100644
--- a/arch/ia64/pci/pci.c
+++ b/arch/ia64/pci/pci.c
@@ -487,45 +487,57 @@ int pcibios_root_bridge_prepare(struct pci_host_bridge *bridge)
 	return 0;
 }
 
-static int is_valid_resource(struct pci_dev *dev, int idx)
+void pcibios_fixup_device_resources(struct pci_dev *dev)
 {
-	unsigned int i, type_mask = IORESOURCE_IO | IORESOURCE_MEM;
-	struct resource *devr = &dev->resource[idx], *busr;
+	int idx;
 
 	if (!dev->bus)
-		return 0;
+		return;
 
-	pci_bus_for_each_resource(dev->bus, busr, i) {
-		if (!busr || ((busr->flags ^ devr->flags) & type_mask))
+	for (idx = 0; idx < PCI_BRIDGE_RESOURCES; idx++) {
+		struct resource *r = &dev->resource[idx];
+
+		if (!r->flags || r->parent || !r->start)
 			continue;
-		if ((devr->start) && (devr->start >= busr->start) &&
-				(devr->end <= busr->end))
-			return 1;
+
+		if (pci_claim_resource(dev, idx) >= 0)
+			continue;
+
+		/* try again with clip */
+		if (pci_bus_clip_resource(dev, r)) {
+			pci_update_resource(dev, idx);
+			pci_claim_resource(dev, idx);
+		}
 	}
-	return 0;
 }
+EXPORT_SYMBOL_GPL(pcibios_fixup_device_resources);
 
-static void pcibios_fixup_resources(struct pci_dev *dev, int start, int limit)
+static bool pcibios_fixup_bridge_resources(struct pci_dev *dev)
 {
-	int i;
+	int idx;
+	bool changed = false;
+
+	if (!dev->bus)
+		return changed;
+
+	for (idx = PCI_BRIDGE_RESOURCES; idx < PCI_NUM_RESOURCES; idx++) {
+		struct resource *r = &dev->resource[idx];
 
-	for (i = start; i < limit; i++) {
-		if (!dev->resource[i].flags)
+		if (!r->flags || r->parent || !r->start)
 			continue;
-		if ((is_valid_resource(dev, i)))
-			pci_claim_resource(dev, i);
-	}
-}
 
-void pcibios_fixup_device_resources(struct pci_dev *dev)
-{
-	pcibios_fixup_resources(dev, 0, PCI_BRIDGE_RESOURCES);
-}
-EXPORT_SYMBOL_GPL(pcibios_fixup_device_resources);
+		if (pci_claim_resource(dev, idx) >= 0)
+			continue;
 
-static void pcibios_fixup_bridge_resources(struct pci_dev *dev)
-{
-	pcibios_fixup_resources(dev, PCI_BRIDGE_RESOURCES, PCI_NUM_RESOURCES);
+		/* try again after clip for pci bridge*/
+		if ((dev->class >> 8) == PCI_CLASS_BRIDGE_PCI &&
+		    pci_bus_clip_resource(dev, r)) {
+			changed = true;
+			pci_claim_resource(dev, idx);
+		}
+	}
+
+	return changed;
 }
 
 /*
@@ -536,9 +548,14 @@ void pcibios_fixup_bus(struct pci_bus *b)
 	struct pci_dev *dev;
 
 	if (b->self) {
+		bool changed;
+
 		pci_read_bridge_bases(b);
-		pcibios_fixup_bridge_resources(b->self);
+		changed = pcibios_fixup_bridge_resources(b->self);
+		if (changed)
+			pci_setup_bridge(b);
 	}
+
 	list_for_each_entry(dev, &b->devices, bus_list)
 		pcibios_fixup_device_resources(dev);
 	platform_pci_fixup_bus(b);
-- 
1.8.4.5

