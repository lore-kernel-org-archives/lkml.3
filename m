Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940AbbAOEch (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 23:32:37 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:20375 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512AbbAOEcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 23:32:35 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>, David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        linux-am33-list@redhat.com
Subject: [PATCH v2 07/10] PCI, mn10300: clip firmware assigned resource under parent bridge's
Date: Wed, 14 Jan 2015 20:31:34 -0800
Message-Id: <1421296297-6371-8-git-send-email-yinghai@kernel.org>
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
Cc: David Howells <dhowells@redhat.com>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Cc: linux-am33-list@redhat.com
---
 arch/mn10300/unit-asb2305/pci-asb2305.c |  2 +-
 arch/mn10300/unit-asb2305/pci.c         | 47 +++++++++++++++------------------
 2 files changed, 22 insertions(+), 27 deletions(-)

diff --git a/arch/mn10300/unit-asb2305/pci-asb2305.c b/arch/mn10300/unit-asb2305/pci-asb2305.c
index febb9cd..b5b036f 100644
--- a/arch/mn10300/unit-asb2305/pci-asb2305.c
+++ b/arch/mn10300/unit-asb2305/pci-asb2305.c
@@ -106,7 +106,7 @@ static void __init pcibios_allocate_bus_resources(struct list_head *bus_list)
 				if (!r->flags)
 					continue;
 				if (!r->start ||
-				    pci_claim_resource(dev, idx) < 0) {
+				    pci_claim_bridge_resource(dev, idx) < 0) {
 					printk(KERN_ERR "PCI:"
 					       " Cannot allocate resource"
 					       " region %d of bridge %s\n",
diff --git a/arch/mn10300/unit-asb2305/pci.c b/arch/mn10300/unit-asb2305/pci.c
index 6b4339f..471ff39 100644
--- a/arch/mn10300/unit-asb2305/pci.c
+++ b/arch/mn10300/unit-asb2305/pci.c
@@ -281,42 +281,37 @@ static int __init pci_check_direct(void)
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
-		}
-	}
+	int idx;
 
-	return 0;
+	if (!dev->bus)
+		return;
+
+	for (idx = 0; idx < PCI_BRIDGE_RESOURCES; idx++) {
+		struct resource *r = &dev->resource[idx];
+
+		if (!r->flags || r->parent || !r->start)
+			continue;
+
+		pci_claim_resource(dev, idx);
+	}
 }
 
-static void pcibios_fixup_device_resources(struct pci_dev *dev)
+static void pcibios_fixup_bridge_resources(struct pci_dev *dev)
 {
-	int limit, i;
+	int idx;
 
-	if (dev->bus->number != 0)
+	if (!dev->bus)
 		return;
 
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
+		pci_claim_bridge_resource(dev, idx);
 	}
 }
 
@@ -330,7 +325,7 @@ void pcibios_fixup_bus(struct pci_bus *bus)
 
 	if (bus->self) {
 		pci_read_bridge_bases(bus);
-		pcibios_fixup_device_resources(bus->self);
+		pcibios_fixup_bridge_resources(bus->self);
 	}
 
 	list_for_each_entry(dev, &bus->devices, bus_list)
-- 
1.8.4.5

