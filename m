Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108AbaA2SSM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jan 2014 13:18:12 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:63740 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086AbaA2SSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jan 2014 13:18:06 -0500
Subject: [PATCH 05/17] x86/PCI: Drop return value of pcibios_scan_root()
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-acpi@vger.kernel.org, x86@kernel.org, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 29 Jan 2014 11:18:03 -0700
Message-ID: <20140129181803.15476.65726.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20140129174106.15476.7075.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20140129174106.15476.7075.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nobody really uses the return value of pcibios_scan_root() (one place uses
it to control a printk, but the printk is not very useful).  This converts
pcibios_scan_root() to a void function.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 arch/x86/include/asm/pci.h |    2 +-
 arch/x86/pci/common.c      |    6 ++----
 arch/x86/pci/irq.c         |    4 +---
 3 files changed, 4 insertions(+), 8 deletions(-)

diff --git a/arch/x86/include/asm/pci.h b/arch/x86/include/asm/pci.h
index b52f9c0ec5fb..96ae4f4040bb 100644
--- a/arch/x86/include/asm/pci.h
+++ b/arch/x86/include/asm/pci.h
@@ -65,7 +65,7 @@ extern unsigned long pci_mem_start;
 
 extern int pcibios_enabled;
 void pcibios_config_init(void);
-struct pci_bus *pcibios_scan_root(int bus);
+void pcibios_scan_root(int bus);
 
 void pcibios_set_master(struct pci_dev *dev);
 void pcibios_penalize_isa_irq(int irq, int active);
diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c
index 52ad00c2e198..600e5925f1a4 100644
--- a/arch/x86/pci/common.c
+++ b/arch/x86/pci/common.c
@@ -456,7 +456,7 @@ void __init dmi_check_pciprobe(void)
 	dmi_check_system(pciprobe_dmi_table);
 }
 
-struct pci_bus *pcibios_scan_root(int busnum)
+void pcibios_scan_root(int busnum)
 {
 	struct pci_bus *bus;
 	struct pci_sysdata *sd;
@@ -465,7 +465,7 @@ struct pci_bus *pcibios_scan_root(int busnum)
 	sd = kzalloc(sizeof(*sd), GFP_KERNEL);
 	if (!sd) {
 		printk(KERN_ERR "PCI: OOM, skipping PCI bus %02x\n", busnum);
-		return NULL;
+		return;
 	}
 	sd->node = get_mp_bus_to_node(busnum);
 	x86_pci_root_bus_resources(busnum, &resources);
@@ -475,8 +475,6 @@ struct pci_bus *pcibios_scan_root(int busnum)
 		pci_free_resource_list(&resources);
 		kfree(sd);
 	}
-
-	return bus;
 }
 
 void __init pcibios_set_cache_line_size(void)
diff --git a/arch/x86/pci/irq.c b/arch/x86/pci/irq.c
index 8658874165c2..84112f55dd7a 100644
--- a/arch/x86/pci/irq.c
+++ b/arch/x86/pci/irq.c
@@ -138,9 +138,7 @@ static void __init pirq_peer_trick(void)
 	for (i = 1; i < 256; i++) {
 		if (!busmap[i] || pci_find_bus(0, i))
 			continue;
-		if (pcibios_scan_root(i))
-			printk(KERN_INFO "PCI: Discovered primary peer "
-			       "bus %02x [IRQ]\n", i);
+		pcibios_scan_root(i);
 	}
 	pcibios_last_bus = -1;
 }

