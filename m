Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755700AbbALTYv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 14:24:51 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:48231 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755619AbbALTYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 14:24:47 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        linux-am33-list@redhat.com
Subject: [PATCH 07/10] PCI, mn10300: clip firmware assigned resource under parent bridge's
Date: Mon, 12 Jan 2015 11:23:17 -0800
Message-Id: <1421090600-9750-8-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1421090600-9750-1-git-send-email-yinghai@kernel.org>
References: <1421090600-9750-1-git-send-email-yinghai@kernel.org>
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
Cc: David Howells <dhowells@redhat.com>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Cc: linux-am33-list@redhat.com
---
 arch/mn10300/unit-asb2305/pci-asb2305.c | 61 +++++++++++++++++++----------
 arch/mn10300/unit-asb2305/pci.c         | 69 ++++++++++++++++++++-------------
 2 files changed, 84 insertions(+), 46 deletions(-)

diff --git a/arch/mn10300/unit-asb2305/pci-asb2305.c b/arch/mn10300/unit-asb2305/pci-asb2305.c
index febb9cd..32ea240 100644
--- a/arch/mn10300/unit-asb2305/pci-asb2305.c
+++ b/arch/mn10300/unit-asb2305/pci-asb2305.c
@@ -99,26 +99,40 @@ static void __init pcibios_allocate_bus_resources(struct list_head *bus_list)
 	list_for_each_entry(bus, bus_list, node) {
 		dev = bus->self;
 		if (dev) {
+			bool changed = false;
+
 			for (idx = PCI_BRIDGE_RESOURCES;
 			     idx < PCI_NUM_RESOURCES;
 			     idx++) {
 				r = &dev->resource[idx];
 				if (!r->flags)
 					continue;
-				if (!r->start ||
-				    pci_claim_resource(dev, idx) < 0) {
-					printk(KERN_ERR "PCI:"
-					       " Cannot allocate resource"
-					       " region %d of bridge %s\n",
-					       idx, pci_name(dev));
-					/* Something is wrong with the region.
-					 * Invalidate the resource to prevent
-					 * child resource allocations in this
-					 * range. */
-					r->start = r->end = 0;
-					r->flags = 0;
+				if (!r->start)
+					goto clear;
+
+				if (pci_claim_resource(dev, idx) >= 0)
+					continue;
+
+				/* try again after clip for pci bridge*/
+				if ((dev->class >> 8) == PCI_CLASS_BRIDGE_PCI &&
+				    pci_bus_clip_resource(dev, r)) {
+					changed = true;
+					if (pci_claim_resource(dev, idx) >= 0)
+						continue;
 				}
+
+clear:
+				pr_err("PCI: Cannot allocate resource region %d of bridge %s\n",
+				       idx, pci_name(dev));
+				/* Something is wrong with the region.
+				 * Invalidate the resource to prevent
+				 * child resource allocations in this
+				 * range. */
+				r->start = r->end = 0;
+				r->flags = 0;
 			}
+			if (changed)
+				pci_setup_bridge(bus);
 		}
 		pcibios_allocate_bus_resources(&bus->children);
 	}
@@ -148,15 +162,22 @@ static void __init pcibios_allocate_resources(int pass)
 				    " (f=%lx, d=%d, p=%d)\n",
 				    pci_name(dev), r->start, r->end, r->flags,
 				    disabled, pass);
-				if (pci_claim_resource(dev, idx) < 0) {
-					printk(KERN_ERR "PCI:"
-					       " Cannot allocate resource"
-					       " region %d of device %s\n",
-					       idx, pci_name(dev));
-					/* We'll assign a new address later */
-					r->end -= r->start;
-					r->start = 0;
+
+				if (pci_claim_resource(dev, idx) >= 0)
+					continue;
+
+				/* try again with clip */
+				if (pci_bus_clip_resource(dev, r)) {
+					pci_update_resource(dev, idx);
+					if (pci_claim_resource(dev, idx) >= 0)
+						continue;
 				}
+
+				pr_err("PCI:  Cannot allocate resource region %d of device %s\n",
+					       idx, pci_name(dev));
+				/* We'll assign a new address later */
+				r->end -= r->start;
+				r->start = 0;
 			}
 		}
 		if (!pass) {
diff --git a/arch/mn10300/unit-asb2305/pci.c b/arch/mn10300/unit-asb2305/pci.c
index 6b4339f..83caf70 100644
--- a/arch/mn10300/unit-asb2305/pci.c
+++ b/arch/mn10300/unit-asb2305/pci.c
@@ -281,43 +281,56 @@ static int __init pci_check_direct(void)
 	return -ENODEV;
 }
 
-static int is_valid_resource(struct pci_dev *dev, int idx)
+static void pcibios_fixup_device_resources(struct pci_dev *dev)
 {
-	unsigned int i, type_mask = IORESOURCE_IO | IORESOURCE_MEM;
-	struct resource *devr = &dev->resource[idx], *busr;
-
-	if (dev->bus) {
-		pci_bus_for_each_resource(dev->bus, busr, i) {
-			if (!busr || (busr->flags ^ devr->flags) & type_mask)
-				continue;
-
-			if (devr->start &&
-			    devr->start >= busr->start &&
-			    devr->end <= busr->end)
-				return 1;
+	int idx;
+
+	if (!dev->bus)
+		return;
+
+	for (idx = 0; idx < PCI_BRIDGE_RESOURCES; idx++) {
+		struct resource *r = &dev->resource[idx];
+
+		if (!r->flags || r->parent || !r->start)
+			continue;
+
+		if (pci_claim_resource(dev, idx) >= 0)
+			continue;
+
+		/* try again with clip */
+		if (pci_bus_clip_resource(dev, r)) {
+			pci_update_resource(dev, idx);
+			pci_claim_resource(dev, idx);
 		}
 	}
-
-	return 0;
 }
 
-static void pcibios_fixup_device_resources(struct pci_dev *dev)
+static bool pcibios_fixup_bridge_resources(struct pci_dev *dev)
 {
-	int limit, i;
+	int idx;
+	bool changed = false;
 
-	if (dev->bus->number != 0)
-		return;
+	if (!dev->bus)
+		return changed;
 
-	limit = (dev->hdr_type == PCI_HEADER_TYPE_NORMAL) ?
-		PCI_BRIDGE_RESOURCES : PCI_NUM_RESOURCES;
+	for (idx = PCI_BRIDGE_RESOURCES; idx < PCI_NUM_RESOURCES; idx++) {
+		struct resource *r = &dev->resource[idx];
 
-	for (i = 0; i < limit; i++) {
-		if (!dev->resource[i].flags)
+		if (!r->flags || r->parent || !r->start)
 			continue;
 
-		if (is_valid_resource(dev, i))
-			pci_claim_resource(dev, i);
+		if (pci_claim_resource(dev, idx) >= 0)
+			continue;
+
+		/* try again after clip for pci bridge*/
+		if ((dev->class >> 8) == PCI_CLASS_BRIDGE_PCI &&
+		    pci_bus_clip_resource(dev, r)) {
+			changed = true;
+			pci_claim_resource(dev, idx);
+		}
 	}
+
+	return changed;
 }
 
 /*
@@ -329,8 +342,12 @@ void pcibios_fixup_bus(struct pci_bus *bus)
 	struct pci_dev *dev;
 
 	if (bus->self) {
+		bool changed;
+
 		pci_read_bridge_bases(bus);
-		pcibios_fixup_device_resources(bus->self);
+		changed = pcibios_fixup_bridge_resources(bus->self);
+		if (changed)
+			pci_setup_bridge(bus);
 	}
 
 	list_for_each_entry(dev, &bus->devices, bus_list)
-- 
1.8.4.5

