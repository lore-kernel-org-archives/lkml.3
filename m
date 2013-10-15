Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934011Ab3JOUku (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 16:40:50 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:41959 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933952Ab3JOUjk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 16:39:40 -0400
From: Grant Likely <grant.likely@linaro.org>
To: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>, Michal Simek <monstr@monstr.eu>
Subject: [RFC 8/9] microblaze/pci: Drop PowerPC-ism from irq parsing
Date: Tue, 15 Oct 2013 21:39:22 +0100
Message-Id: <1381869563-16083-9-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1381869563-16083-1-git-send-email-grant.likely@linaro.org>
References: <1381869563-16083-1-git-send-email-grant.likely@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Microblaze PCI code copied the PowerPC irq handling, but powerpc
needs to handle broken device trees that are not present on Microblaze.
This patch removes the powerpc special case and replaces it with a
direct of_irq_parse_and_map_pci() call.

Signed-off-by: Grant Likely <grant.likely@linaro.org>
Cc: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/include/asm/pci.h |  2 --
 arch/microblaze/pci/pci-common.c  | 71 +--------------------------------------
 2 files changed, 1 insertion(+), 72 deletions(-)

diff --git a/arch/microblaze/include/asm/pci.h b/arch/microblaze/include/asm/pci.h
index d52abb6..935f9be 100644
--- a/arch/microblaze/include/asm/pci.h
+++ b/arch/microblaze/include/asm/pci.h
@@ -127,8 +127,6 @@ extern void of_scan_pci_bridge(struct device_node *node,
 extern void of_scan_bus(struct device_node *node, struct pci_bus *bus);
 extern void of_rescan_bus(struct device_node *node, struct pci_bus *bus);
 
-extern int pci_read_irq_line(struct pci_dev *dev);
-
 extern int pci_bus_find_capability(struct pci_bus *bus,
 						unsigned int devfn, int cap);
 
diff --git a/arch/microblaze/pci/pci-common.c b/arch/microblaze/pci/pci-common.c
index 60b386c..5060fc5 100644
--- a/arch/microblaze/pci/pci-common.c
+++ b/arch/microblaze/pci/pci-common.c
@@ -193,75 +193,6 @@ void pcibios_set_master(struct pci_dev *dev)
 }
 
 /*
- * Reads the interrupt pin to determine if interrupt is use by card.
- * If the interrupt is used, then gets the interrupt line from the
- * openfirmware and sets it in the pci_dev and pci_config line.
- */
-int pci_read_irq_line(struct pci_dev *pci_dev)
-{
-	struct of_phandle_args oirq;
-	unsigned int virq;
-
-	/* The current device-tree that iSeries generates from the HV
-	 * PCI informations doesn't contain proper interrupt routing,
-	 * and all the fallback would do is print out crap, so we
-	 * don't attempt to resolve the interrupts here at all, some
-	 * iSeries specific fixup does it.
-	 *
-	 * In the long run, we will hopefully fix the generated device-tree
-	 * instead.
-	 */
-	pr_debug("PCI: Try to map irq for %s...\n", pci_name(pci_dev));
-
-#ifdef DEBUG
-	memset(&oirq, 0xff, sizeof(oirq));
-#endif
-	/* Try to get a mapping from the device-tree */
-	if (of_irq_parse_pci(pci_dev, &oirq)) {
-		u8 line, pin;
-
-		/* If that fails, lets fallback to what is in the config
-		 * space and map that through the default controller. We
-		 * also set the type to level low since that's what PCI
-		 * interrupts are. If your platform does differently, then
-		 * either provide a proper interrupt tree or don't use this
-		 * function.
-		 */
-		if (pci_read_config_byte(pci_dev, PCI_INTERRUPT_PIN, &pin))
-			return -1;
-		if (pin == 0)
-			return -1;
-		if (pci_read_config_byte(pci_dev, PCI_INTERRUPT_LINE, &line) ||
-		    line == 0xff || line == 0) {
-			return -1;
-		}
-		pr_debug(" No map ! Using line %d (pin %d) from PCI config\n",
-			 line, pin);
-
-		virq = irq_create_mapping(NULL, line);
-		if (virq)
-			irq_set_irq_type(virq, IRQ_TYPE_LEVEL_LOW);
-	} else {
-		pr_debug(" Got one, spec %d cells (0x%08x 0x%08x...) on %s\n",
-			 oirq.args_count, oirq.args[0], oirq.args[1],
-			 of_node_full_name(oirq.np));
-
-		virq = irq_create_of_mapping(&oirq);
-	}
-	if (!virq) {
-		pr_debug(" Failed to map !\n");
-		return -1;
-	}
-
-	pr_debug(" Mapped to linux irq %d\n", virq);
-
-	pci_dev->irq = virq;
-
-	return 0;
-}
-EXPORT_SYMBOL(pci_read_irq_line);
-
-/*
  * Platform support for /proc/bus/pci/X/Y mmap()s,
  * modelled on the sparc64 implementation by Dave Miller.
  *  -- paulus.
@@ -959,7 +890,7 @@ void pcibios_setup_bus_devices(struct pci_bus *bus)
 		dev->dev.archdata.dma_data = (void *)PCI_DRAM_OFFSET;
 
 		/* Read default IRQs and fixup if necessary */
-		pci_read_irq_line(dev);
+		dev->irq = of_irq_parse_and_map_pci(dev, 0, 0);
 	}
 }
 
-- 
1.8.1.2

