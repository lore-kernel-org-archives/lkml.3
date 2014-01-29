Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753296AbaA2SS5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 13:18:57 -0500
Received: from mail-ie0-f170.google.com ([209.85.223.170]:32846 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271AbaA2SSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 13:18:50 -0500
Subject: [PATCH 11/17] x86/PCI: Remove acpi_get_pxm() usage
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-acpi@vger.kernel.org, x86@kernel.org, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 29 Jan 2014 11:18:48 -0700
Message-ID: <20140129181848.15476.265.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20140129174106.15476.7075.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20140129174106.15476.7075.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The PCI host bridge code doesn't care about _PXM values directly; it only
needs to know what NUMA node the hardware is on.

This uses acpi_get_node() directly and removes the _PXM stuff.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 arch/x86/pci/acpi.c |   19 ++-----------------
 1 file changed, 2 insertions(+), 17 deletions(-)

diff --git a/arch/x86/pci/acpi.c b/arch/x86/pci/acpi.c
index 6304ea0f426d..f44a64c74e37 100644
--- a/arch/x86/pci/acpi.c
+++ b/arch/x86/pci/acpi.c
@@ -480,9 +480,6 @@ struct pci_bus *pci_acpi_scan_root(struct acpi_pci_root *root)
 	struct pci_bus *bus = NULL;
 	struct pci_sysdata *sd;
 	int node;
-#ifdef CONFIG_ACPI_NUMA
-	int pxm;
-#endif
 
 	if (pci_ignore_seg)
 		domain = 0;
@@ -494,12 +491,7 @@ struct pci_bus *pci_acpi_scan_root(struct acpi_pci_root *root)
 		return NULL;
 	}
 
-	node = NUMA_NO_NODE;
-#ifdef CONFIG_ACPI_NUMA
-	pxm = acpi_get_pxm(device->handle);
-	if (pxm >= 0)
-		node = pxm_to_node(pxm);
-#endif
+	node = acpi_get_node(device->handle);
 	if (node == NUMA_NO_NODE)
 		node = x86_pci_root_bus_node(busnum);
 
@@ -570,15 +562,8 @@ struct pci_bus *pci_acpi_scan_root(struct acpi_pci_root *root)
 			pcie_bus_configure_settings(child);
 	}
 
-	if (bus && node != NUMA_NO_NODE) {
-#ifdef CONFIG_ACPI_NUMA
-		if (pxm >= 0)
-			dev_printk(KERN_DEBUG, &bus->dev,
-				   "on NUMA node %d (pxm %d)\n", node, pxm);
-#else
+	if (bus && node != NUMA_NO_NODE)
 		dev_printk(KERN_DEBUG, &bus->dev, "on NUMA node %d\n", node);
-#endif
-	}
 
 	return bus;
 }

