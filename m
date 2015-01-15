Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531AbbAOEeK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 23:34:10 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:21528 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517AbbAOEcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 23:32:21 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-ia64@vger.kernel.org
Subject: [PATCH v2 05/10] PCI, ia64: clip firmware assigned resource under parent bridge's
Date: Wed, 14 Jan 2015 20:31:32 -0800
Message-Id: <1421296297-6371-6-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1421296297-6371-1-git-send-email-yinghai@kernel.org>
References: <1421296297-6371-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
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
 arch/ia64/pci/pci.c | 48 +++++++++++++++++++++---------------------------
 1 file changed, 21 insertions(+), 27 deletions(-)

diff --git a/arch/ia64/pci/pci.c b/arch/ia64/pci/pci.c
index 291a582..900cc93 100644
--- a/arch/ia64/pci/pci.c
+++ b/arch/ia64/pci/pci.c
@@ -487,45 +487,39 @@ int pcibios_root_bridge_prepare(struct pci_host_bridge *bridge)
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
-
-	pci_bus_for_each_resource(dev->bus, busr, i) {
-		if (!busr || ((busr->flags ^ devr->flags) & type_mask))
-			continue;
-		if ((devr->start) && (devr->start >= busr->start) &&
-				(devr->end <= busr->end))
-			return 1;
-	}
-	return 0;
-}
+		return;
 
-static void pcibios_fixup_resources(struct pci_dev *dev, int start, int limit)
-{
-	int i;
+	for (idx = 0; idx < PCI_BRIDGE_RESOURCES; idx++) {
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
+		pci_claim_resource(dev, idx);
+	}
 }
 EXPORT_SYMBOL_GPL(pcibios_fixup_device_resources);
 
 static void pcibios_fixup_bridge_resources(struct pci_dev *dev)
 {
-	pcibios_fixup_resources(dev, PCI_BRIDGE_RESOURCES, PCI_NUM_RESOURCES);
+	int idx;
+
+	if (!dev->bus)
+		return;
+
+	for (idx = PCI_BRIDGE_RESOURCES; idx < PCI_NUM_RESOURCES; idx++) {
+		struct resource *r = &dev->resource[idx];
+
+		if (!r->flags || r->parent || !r->start)
+			continue;
+
+		pci_claim_bridge_resource(dev, idx);
+	}
 }
 
 /*
-- 
1.8.4.5

