Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754508Ab3IZSyg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 14:54:36 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:47609 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754162Ab3IZSvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 14:51:31 -0400
From: Rob Herring <robherring2@gmail.com>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Michal Simek <monstr@monstr.eu>,
        Ralf Baechle <ralf@linux-mips.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: [PATCH 13/21] of: implement pci_address_to_pio as weak function
Date: Thu, 26 Sep 2013 13:50:48 -0500
Message-Id: <1380221456-11192-14-git-send-email-robherring2@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1380221456-11192-1-git-send-email-robherring2@gmail.com>
References: <1380221456-11192-1-git-send-email-robherring2@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Herring <rob.herring@calxeda.com>

Implement pci_address_to_pio as weak function to remove the dependency on
asm/prom.h. This is in preparation to make prom.h optional.

Signed-off-by: Rob Herring <rob.herring@calxeda.com>
Cc: Michal Simek <monstr@monstr.eu>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: Grant Likely <grant.likely@linaro.org>
---
 arch/microblaze/include/asm/prom.h |  9 ---------
 arch/mips/include/asm/prom.h       | 11 -----------
 arch/powerpc/include/asm/prom.h    |  5 -----
 arch/x86/include/asm/prom.h        |  3 ---
 arch/x86/kernel/devicetree.c       | 10 ----------
 drivers/of/address.c               |  8 ++++++++
 drivers/of/of_pci.c                |  1 -
 include/linux/of_address.h         |  5 +----
 8 files changed, 9 insertions(+), 43 deletions(-)

diff --git a/arch/microblaze/include/asm/prom.h b/arch/microblaze/include/asm/prom.h
index f05bedc..0ebd924 100644
--- a/arch/microblaze/include/asm/prom.h
+++ b/arch/microblaze/include/asm/prom.h
@@ -26,13 +26,4 @@ enum early_consoles {
 
 extern int of_early_console(void *version);
 
-/*
- * OF address retreival & translation
- */
-
-#ifdef CONFIG_PCI
-extern unsigned long pci_address_to_pio(phys_addr_t address);
-#define pci_address_to_pio pci_address_to_pio
-#endif	/* CONFIG_PCI */
-
 #endif /* _ASM_MICROBLAZE_PROM_H */
diff --git a/arch/mips/include/asm/prom.h b/arch/mips/include/asm/prom.h
index 1e7e096..a7b28f5 100644
--- a/arch/mips/include/asm/prom.h
+++ b/arch/mips/include/asm/prom.h
@@ -22,17 +22,6 @@ extern int early_init_dt_scan_memory_arch(unsigned long node,
 
 extern void device_tree_init(void);
 
-static inline unsigned long pci_address_to_pio(phys_addr_t address)
-{
-	/*
-	 * The ioport address can be directly used by inX() / outX()
-	 */
-	BUG_ON(address > IO_SPACE_LIMIT);
-
-	return (unsigned long) address;
-}
-#define pci_address_to_pio pci_address_to_pio
-
 struct boot_param_header;
 
 extern void __dt_setup_arch(struct boot_param_header *bph);
diff --git a/arch/powerpc/include/asm/prom.h b/arch/powerpc/include/asm/prom.h
index 7d0c7f3..bd215f7 100644
--- a/arch/powerpc/include/asm/prom.h
+++ b/arch/powerpc/include/asm/prom.h
@@ -30,11 +30,6 @@
 extern u64 of_translate_dma_address(struct device_node *dev,
 				    const __be32 *in_addr);
 
-#ifdef CONFIG_PCI
-extern unsigned long pci_address_to_pio(phys_addr_t address);
-#define pci_address_to_pio pci_address_to_pio
-#endif	/* CONFIG_PCI */
-
 /* Parse the ibm,dma-window property of an OF node into the busno, phys and
  * size parameters.
  */
diff --git a/arch/x86/include/asm/prom.h b/arch/x86/include/asm/prom.h
index bade6ac..8ef2ec7 100644
--- a/arch/x86/include/asm/prom.h
+++ b/arch/x86/include/asm/prom.h
@@ -39,9 +39,6 @@ static inline void x86_dtb_init(void) { }
 
 extern char cmd_line[COMMAND_LINE_SIZE];
 
-#define pci_address_to_pio pci_address_to_pio
-unsigned long pci_address_to_pio(phys_addr_t addr);
-
 #define HAVE_ARCH_DEVTREE_FIXUPS
 
 #endif /* __ASSEMBLY__ */
diff --git a/arch/x86/kernel/devicetree.c b/arch/x86/kernel/devicetree.c
index c321a78..e119918 100644
--- a/arch/x86/kernel/devicetree.c
+++ b/arch/x86/kernel/devicetree.c
@@ -27,16 +27,6 @@ char __initdata cmd_line[COMMAND_LINE_SIZE];
 
 int __initdata of_ioapic;
 
-unsigned long pci_address_to_pio(phys_addr_t address)
-{
-	/*
-	 * The ioport address can be directly used by inX / outX
-	 */
-	BUG_ON(address >= (1 << 16));
-	return (unsigned long)address;
-}
-EXPORT_SYMBOL_GPL(pci_address_to_pio);
-
 void __init early_init_dt_scan_chosen_arch(unsigned long node)
 {
 	BUG();
diff --git a/drivers/of/address.c b/drivers/of/address.c
index b55c218..556a7fb 100644
--- a/drivers/of/address.c
+++ b/drivers/of/address.c
@@ -626,6 +626,14 @@ const __be32 *of_get_address(struct device_node *dev, int index, u64 *size,
 }
 EXPORT_SYMBOL(of_get_address);
 
+unsigned long __weak pci_address_to_pio(phys_addr_t address)
+{
+	if (address > IO_SPACE_LIMIT)
+		return (unsigned long)-1;
+
+	return (unsigned long) address;
+}
+
 static int __of_address_to_resource(struct device_node *dev,
 		const __be32 *addrp, u64 size, unsigned int flags,
 		const char *name, struct resource *r)
diff --git a/drivers/of/of_pci.c b/drivers/of/of_pci.c
index e5ca008..8481996 100644
--- a/drivers/of/of_pci.c
+++ b/drivers/of/of_pci.c
@@ -2,7 +2,6 @@
 #include <linux/export.h>
 #include <linux/of.h>
 #include <linux/of_pci.h>
-#include <asm/prom.h>
 
 static inline int __of_pci_pci_compare(struct device_node *node,
 				       unsigned int data)
diff --git a/include/linux/of_address.h b/include/linux/of_address.h
index 4c2e6f2..f6fc689 100644
--- a/include/linux/of_address.h
+++ b/include/linux/of_address.h
@@ -52,10 +52,7 @@ extern void __iomem *of_iomap(struct device_node *device, int index);
 extern const __be32 *of_get_address(struct device_node *dev, int index,
 			   u64 *size, unsigned int *flags);
 
-#ifndef pci_address_to_pio
-static inline unsigned long pci_address_to_pio(phys_addr_t addr) { return -1; }
-#define pci_address_to_pio pci_address_to_pio
-#endif
+extern unsigned long pci_address_to_pio(phys_addr_t addr);
 
 extern int of_pci_range_parser_init(struct of_pci_range_parser *parser,
 			struct device_node *node);
-- 
1.8.1.2

