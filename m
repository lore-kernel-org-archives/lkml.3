Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075AbaA2SR7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 13:17:59 -0500
Received: from mail-ie0-f179.google.com ([209.85.223.179]:43157 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753031AbaA2SRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 13:17:52 -0500
Subject: [PATCH 03/17] x86/PCI: Use pcibios_scan_root() instead of
 pci_scan_bus_on_node()
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-acpi@vger.kernel.org, x86@kernel.org, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 29 Jan 2014 11:17:49 -0700
Message-ID: <20140129181749.15476.64115.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20140129174106.15476.7075.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20140129174106.15476.7075.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pcibios_scan_root() looks up the bus's NUMA node, then calls
pci_scan_bus_on_node().  This uses pcibios_scan_root() directly and drops
the node lookup in the callers.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 arch/x86/pci/irq.c    |    4 +---
 arch/x86/pci/legacy.c |    4 +---
 2 files changed, 2 insertions(+), 6 deletions(-)

diff --git a/arch/x86/pci/irq.c b/arch/x86/pci/irq.c
index 372e9b8989b3..8658874165c2 100644
--- a/arch/x86/pci/irq.c
+++ b/arch/x86/pci/irq.c
@@ -136,11 +136,9 @@ static void __init pirq_peer_trick(void)
 		busmap[e->bus] = 1;
 	}
 	for (i = 1; i < 256; i++) {
-		int node;
 		if (!busmap[i] || pci_find_bus(0, i))
 			continue;
-		node = get_mp_bus_to_node(i);
-		if (pci_scan_bus_on_node(i, &pci_root_ops, node))
+		if (pcibios_scan_root(i))
 			printk(KERN_INFO "PCI: Discovered primary peer "
 			       "bus %02x [IRQ]\n", i);
 	}
diff --git a/arch/x86/pci/legacy.c b/arch/x86/pci/legacy.c
index 4db96fb1c232..5b662c0faf8c 100644
--- a/arch/x86/pci/legacy.c
+++ b/arch/x86/pci/legacy.c
@@ -37,19 +37,17 @@ int __init pci_legacy_init(void)
 void pcibios_scan_specific_bus(int busn)
 {
 	int devfn;
-	long node;
 	u32 l;
 
 	if (pci_find_bus(0, busn))
 		return;
 
-	node = get_mp_bus_to_node(busn);
 	for (devfn = 0; devfn < 256; devfn += 8) {
 		if (!raw_pci_read(0, busn, devfn, PCI_VENDOR_ID, 2, &l) &&
 		    l != 0x0000 && l != 0xffff) {
 			DBG("Found device at %02x:%02x [%04x]\n", busn, devfn, l);
 			printk(KERN_INFO "PCI: Discovered peer bus %02x\n", busn);
-			pci_scan_bus_on_node(busn, &pci_root_ops, node);
+			pcibios_scan_root(busn);
 			return;
 		}
 	}

