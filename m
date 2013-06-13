Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757409Ab3FMHxs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 03:53:48 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:55888 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755478Ab3FMHxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 03:53:47 -0400
From: Rojhalat Ibrahim <imr@rtschenk.de>
To: Scott Wood <scottwood@freescale.com>
Cc: Michael Guntsche <michael.guntsche@it-loops.com>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH] powerpc/pci: Fix setup of Freescale PCI / PCIe controllers
Date: Thu, 13 Jun 2013 09:53:43 +0200
Message-ID: <27985603.vMaTQLaIcr@pcimr>
User-Agent: KMail/4.10.3 (Linux/3.4.26; KDE/4.10.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 50d8f87d2b3 (powerpc/fsl-pci Make PCIe hotplug work with Freescale
PCIe controllers) does not handle non-PCIe controllers properly, which causes
a panic during boot for certain configurations.
This patch fixes the issue for 83xx devices by calling the proper setup function.
For booke/86xx devices a check is added to differentiate between PCI and PCIe
controllers.

Reported-by: Michael Guntsche <mike@it-loops.com>
Cc: Scott Wood <scottwood@freescale.com>
Signed-off-by: Rojhalat Ibrahim <imr@rtschenk.de>
---
 arch/powerpc/sysdev/fsl_pci.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/sysdev/fsl_pci.c b/arch/powerpc/sysdev/fsl_pci.c
index 028ac1f..45670df 100644
--- a/arch/powerpc/sysdev/fsl_pci.c
+++ b/arch/powerpc/sysdev/fsl_pci.c
@@ -97,22 +97,23 @@ static int fsl_indirect_read_config(struct pci_bus *bus, unsigned int devfn,
 	return indirect_read_config(bus, devfn, offset, len, val);
 }
 
-static struct pci_ops fsl_indirect_pci_ops =
+static struct pci_ops fsl_indirect_pcie_ops =
 {
 	.read = fsl_indirect_read_config,
 	.write = indirect_write_config,
 };
 
+#if defined(CONFIG_FSL_SOC_BOOKE) || defined(CONFIG_PPC_86xx)
+
 static void __init fsl_setup_indirect_pci(struct pci_controller* hose,
 					  resource_size_t cfg_addr,
 					  resource_size_t cfg_data, u32 flags)
 {
 	setup_indirect_pci(hose, cfg_addr, cfg_data, flags);
-	hose->ops = &fsl_indirect_pci_ops;
+	if (early_find_capability(hose, 0, 0, PCI_CAP_ID_EXP))  /* PCIe */
+		hose->ops = &fsl_indirect_pcie_ops;
 }
 
-#if defined(CONFIG_FSL_SOC_BOOKE) || defined(CONFIG_PPC_86xx)
-
 #define MAX_PHYS_ADDR_BITS	40
 static u64 pci64_dma_offset = 1ull << MAX_PHYS_ADDR_BITS;
 
@@ -814,8 +815,8 @@ int __init mpc83xx_add_bridge(struct device_node *dev)
 		if (ret)
 			goto err0;
 	} else {
-		fsl_setup_indirect_pci(hose, rsrc_cfg.start,
-				       rsrc_cfg.start + 4, 0);
+		setup_indirect_pci(hose, rsrc_cfg.start,
+				   rsrc_cfg.start + 4, 0);
 	}
 
 	printk(KERN_INFO "Found FSL PCI host bridge at 0x%016llx. "

--
1.8.1.5

