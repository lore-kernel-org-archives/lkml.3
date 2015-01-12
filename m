Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755752AbbALTYz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 14:24:55 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:48277 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755634AbbALTYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 14:24:52 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Michal Simek <monstr@monstr.eu>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Sebastian Ott <sebott@linux.vnet.ibm.com>
Subject: [PATCH 06/10] PCI, microblaze: clip firmware assigned resource under parent bridge's
Date: Mon, 12 Jan 2015 11:23:16 -0800
Message-Id: <1421090600-9750-7-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1421090600-9750-1-git-send-email-yinghai@kernel.org>
References: <1421090600-9750-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
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
Cc: Michal Simek <monstr@monstr.eu>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Sebastian Ott <sebott@linux.vnet.ibm.com>
---
 arch/microblaze/pci/pci-common.c | 42 +++++++++++++++++++++++++++++++++++++++-
 1 file changed, 41 insertions(+), 1 deletion(-)

diff --git a/arch/microblaze/pci/pci-common.c b/arch/microblaze/pci/pci-common.c
index b30e41c..4ec2dd4 100644
--- a/arch/microblaze/pci/pci-common.c
+++ b/arch/microblaze/pci/pci-common.c
@@ -988,6 +988,7 @@ static void pcibios_allocate_bus_resources(struct pci_bus *bus)
 	struct pci_bus *b;
 	int i;
 	struct resource *res, *pr;
+	bool changed = false;
 
 	pr_debug("PCI: Allocating bus resources for %04x:%02x...\n",
 		 pci_domain_nr(bus), bus->number);
@@ -1026,6 +1027,8 @@ static void pcibios_allocate_bus_resources(struct pci_bus *bus)
 			 pr, (pr && pr->name) ? pr->name : "nil");
 
 		if (pr && !(pr->flags & IORESOURCE_UNSET)) {
+			struct pci_dev *dev = bus->self;
+
 			if (request_resource(pr, res) == 0)
 				continue;
 			/*
@@ -1035,6 +1038,16 @@ static void pcibios_allocate_bus_resources(struct pci_bus *bus)
 			 */
 			if (reparent_resources(pr, res) == 0)
 				continue;
+
+			if (dev && i >= PCI_BRIDGE_RESOURCES &&
+			    i < PCI_NUM_RESOURCES &&
+			    (dev->class >> 8) == PCI_CLASS_BRIDGE_PCI &&
+			    pci_bus_clip_resource(dev, res)) {
+				changed = true;
+				if (pci_claim_resource(dev, i) >= 0)
+					continue;
+			}
+
 		}
 		pr_warn("PCI: Cannot allocate resource region ");
 		pr_cont("%d of PCI bridge %d, will remap\n", i, bus->number);
@@ -1042,6 +1055,9 @@ static void pcibios_allocate_bus_resources(struct pci_bus *bus)
 		res->flags = 0;
 	}
 
+	if (changed)
+		pci_setup_bridge(bus);
+
 	list_for_each_entry(b, &bus->children, node)
 		pcibios_allocate_bus_resources(b);
 }
@@ -1059,6 +1075,12 @@ static inline void alloc_resource(struct pci_dev *dev, int idx)
 	pr = pci_find_parent_resource(dev, r);
 	if (!pr || (pr->flags & IORESOURCE_UNSET) ||
 	    request_resource(pr, r) < 0) {
+		/* try again with clip */
+		if (idx != PCI_ROM_RESOURCE && pci_bus_clip_resource(dev, r)) {
+			pci_update_resource(dev, idx);
+			if (pci_claim_resource(dev, idx) >= 0)
+				return;
+		}
 		pr_warn("PCI: Cannot allocate resource region %d ", idx);
 		pr_cont("of device %s, will remap\n", pci_name(dev));
 		if (pr)
@@ -1213,6 +1235,7 @@ void pcibios_claim_one_bus(struct pci_bus *bus)
 	struct pci_bus *child_bus;
 
 	list_for_each_entry(dev, &bus->devices, bus_list) {
+		bool changed = false;
 		int i;
 
 		for (i = 0; i < PCI_NUM_RESOURCES; i++) {
@@ -1227,8 +1250,25 @@ void pcibios_claim_one_bus(struct pci_bus *bus)
 				 (unsigned long long)r->end,
 				 (unsigned int)r->flags);
 
-			pci_claim_resource(dev, i);
+			if (pci_claim_resource(dev, i) >= 0)
+				continue;
+
+			if (dev->subordinate &&
+			    i >= PCI_BRIDGE_RESOURCES &&
+			    i < PCI_NUM_RESOURCES &&
+			    (dev->class >> 8) != PCI_CLASS_BRIDGE_PCI &&
+			    pci_bus_clip_resource(dev, r)) {
+				changed = true;
+				pci_claim_resource(dev, i);
+			} else if (i < PCI_BRIDGE_RESOURCES &&
+				   i != PCI_ROM_RESOURCE &&
+				   pci_bus_clip_resource(dev, r)) {
+					pci_update_resource(dev, i);
+					pci_claim_resource(dev, i);
+			}
 		}
+		if (changed)
+			pci_setup_bridge(dev->subordinate);
 	}
 
 	list_for_each_entry(child_bus, &bus->children, node)
-- 
1.8.4.5

