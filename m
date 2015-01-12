Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932323AbbALTYR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 14:24:17 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:46028 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754614AbbALTYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 14:24:14 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org
Subject: [PATCH 02/10] PCI, x86: clip firmware assigned resource under parent bridge's
Date: Mon, 12 Jan 2015 11:23:12 -0800
Message-Id: <1421090600-9750-3-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1421090600-9750-1-git-send-email-yinghai@kernel.org>
References: <1421090600-9750-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some bios put range that is not fully coverred by root bus resources.
Try to clip them and update them in pci bridge bars.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=85491
Reported-by: Marek Kordik <kordikmarek@gmail.com>
Tested-by: Marek Kordik <kordikmarek@gmail.com>
Fixes: 5b28541552ef ("PCI: Restrict 64-bit prefetchable bridge windows to 64-bit resources")
Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
---
 arch/x86/pci/i386.c | 74 +++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 52 insertions(+), 22 deletions(-)

diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
index 9b18ef3..d43e1af 100644
--- a/arch/x86/pci/i386.c
+++ b/arch/x86/pci/i386.c
@@ -205,10 +205,11 @@ EXPORT_SYMBOL(pcibios_align_resource);
  *	    as well.
  */
 
-static void pcibios_allocate_bridge_resources(struct pci_dev *dev)
+static bool pcibios_allocate_bridge_resources(struct pci_dev *dev)
 {
 	int idx;
 	struct resource *r;
+	bool changed = false;
 
 	for (idx = PCI_BRIDGE_RESOURCES; idx < PCI_NUM_RESOURCES; idx++) {
 		r = &dev->resource[idx];
@@ -216,17 +217,33 @@ static void pcibios_allocate_bridge_resources(struct pci_dev *dev)
 			continue;
 		if (r->parent)	/* Already allocated */
 			continue;
-		if (!r->start || pci_claim_resource(dev, idx) < 0) {
-			/*
-			 * Something is wrong with the region.
-			 * Invalidate the resource to prevent
-			 * child resource allocations in this
-			 * range.
-			 */
-			r->start = r->end = 0;
-			r->flags = 0;
+
+		if (!r->start)
+			goto clear;
+
+		if (pci_claim_resource(dev, idx) >= 0)
+			continue;
+
+		/* try again after clip for pci bridge*/
+		if ((dev->class >> 8) == PCI_CLASS_BRIDGE_PCI &&
+		    pci_bus_clip_resource(dev, r)) {
+			changed = true;
+			if (pci_claim_resource(dev, idx) >= 0)
+				continue;
 		}
+
+clear:
+		/*
+		 * Something is wrong with the region.
+		 * Invalidate the resource to prevent
+		 * child resource allocations in this
+		 * range.
+		 */
+		r->start = r->end = 0;
+		r->flags = 0;
 	}
+
+	return changed;
 }
 
 static void pcibios_allocate_bus_resources(struct pci_bus *bus)
@@ -234,8 +251,12 @@ static void pcibios_allocate_bus_resources(struct pci_bus *bus)
 	struct pci_bus *child;
 
 	/* Depth-First Search on bus tree */
-	if (bus->self)
-		pcibios_allocate_bridge_resources(bus->self);
+	if (bus->self) {
+		bool changed = pcibios_allocate_bridge_resources(bus->self);
+
+		if (changed)
+			pci_setup_bridge(bus);
+	}
 	list_for_each_entry(child, &bus->children, node)
 		pcibios_allocate_bus_resources(child);
 }
@@ -274,18 +295,27 @@ static void pcibios_allocate_dev_resources(struct pci_dev *dev, int pass)
 				dev_dbg(&dev->dev,
 					"BAR %d: reserving %pr (d=%d, p=%d)\n",
 					idx, r, disabled, pass);
-				if (pci_claim_resource(dev, idx) < 0) {
-					if (r->flags & IORESOURCE_PCI_FIXED) {
-						dev_info(&dev->dev, "BAR %d %pR is immovable\n",
+
+				if (pci_claim_resource(dev, idx) >= 0)
+					continue;
+
+				if (r->flags & IORESOURCE_PCI_FIXED) {
+					dev_info(&dev->dev, "BAR %d %pR is immovable\n",
 							 idx, r);
-					} else {
-						/* We'll assign a new address later */
-						pcibios_save_fw_addr(dev,
-								idx, r->start);
-						r->end -= r->start;
-						r->start = 0;
-					}
+					continue;
+				}
+
+				/* try again with clip */
+				if (pci_bus_clip_resource(dev, r)) {
+					pci_update_resource(dev, idx);
+					if (pci_claim_resource(dev, idx) >= 0)
+						continue;
 				}
+
+				/* We'll assign a new address later */
+				pcibios_save_fw_addr(dev, idx, r->start);
+				r->end -= r->start;
+				r->start = 0;
 			}
 		}
 	if (!pass) {
-- 
1.8.4.5

