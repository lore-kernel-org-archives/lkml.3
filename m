Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804AbaKSQHQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 11:07:16 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:61042 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756756AbaKSQFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 11:05:37 -0500
From: Tomasz Nowicki <tomasz.nowicki@linaro.org>
To: catalin.marinas@arm.com, will.deacon@arm.com, bhelgaas@google.com,
        lorenzo.pieralisi@arm.com, wangyijing@huawei.com, arnd@arndb.de,
        hanjun.guo@linaro.org, Liviu.Dudau@arm.com, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, rjw@rjwysocki.net
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org,
        linaro-acpi@lists.linaro.org,
        Tomasz Nowicki <tomasz.nowicki@linaro.org>
Subject: [PATCH 3/6] x86, acpi, pci: Move PCI config space accessors.
Date: Wed, 19 Nov 2014 17:04:48 +0100
Message-Id: <1416413091-13452-4-git-send-email-tomasz.nowicki@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416413091-13452-1-git-send-email-tomasz.nowicki@linaro.org>
References: <1416413091-13452-1-git-send-email-tomasz.nowicki@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are going to use mmio_config_{} name convention across all architectures.
Currently it belongs to asm/pci_x86.h header which should be included
only for x86 specific files. From now on, those accessors are in asm/pci.h
header which can be included in non-architecture code much easier.

Signed-off-by: Tomasz Nowicki <tomasz.nowicki@linaro.org>
Tested-by: Hanjun Guo <hanjun.guo@linaro.org>
---
 arch/x86/include/asm/pci.h     | 42 +++++++++++++++++++++++++++++++++++++++++
 arch/x86/include/asm/pci_x86.h | 43 ------------------------------------------
 2 files changed, 42 insertions(+), 43 deletions(-)

diff --git a/arch/x86/include/asm/pci.h b/arch/x86/include/asm/pci.h
index 0892ea0..5ba3720 100644
--- a/arch/x86/include/asm/pci.h
+++ b/arch/x86/include/asm/pci.h
@@ -71,6 +71,48 @@ void pcibios_set_master(struct pci_dev *dev);
 struct irq_routing_table *pcibios_get_irq_routing_table(void);
 int pcibios_set_irq_routing(struct pci_dev *dev, int pin, int irq);
 
+/*
+ * AMD Fam10h CPUs are buggy, and cannot access MMIO config space
+ * on their northbrige except through the * %eax register. As such, you MUST
+ * NOT use normal IOMEM accesses, you need to only use the magic mmio-config
+ * accessor functions.
+ * In fact just use pci_config_*, nothing else please.
+ */
+static inline unsigned char mmio_config_readb(void __iomem *pos)
+{
+	u8 val;
+	asm volatile("movb (%1),%%al" : "=a" (val) : "r" (pos));
+	return val;
+}
+
+static inline unsigned short mmio_config_readw(void __iomem *pos)
+{
+	u16 val;
+	asm volatile("movw (%1),%%ax" : "=a" (val) : "r" (pos));
+	return val;
+}
+
+static inline unsigned int mmio_config_readl(void __iomem *pos)
+{
+	u32 val;
+	asm volatile("movl (%1),%%eax" : "=a" (val) : "r" (pos));
+	return val;
+}
+
+static inline void mmio_config_writeb(void __iomem *pos, u8 val)
+{
+	asm volatile("movb %%al,(%1)" : : "a" (val), "r" (pos) : "memory");
+}
+
+static inline void mmio_config_writew(void __iomem *pos, u16 val)
+{
+	asm volatile("movw %%ax,(%1)" : : "a" (val), "r" (pos) : "memory");
+}
+
+static inline void mmio_config_writel(void __iomem *pos, u32 val)
+{
+	asm volatile("movl %%eax,(%1)" : : "a" (val), "r" (pos) : "memory");
+}
 
 #define HAVE_PCI_MMAP
 extern int pci_mmap_page_range(struct pci_dev *dev, struct vm_area_struct *vma,
diff --git a/arch/x86/include/asm/pci_x86.h b/arch/x86/include/asm/pci_x86.h
index caba141..42e7332 100644
--- a/arch/x86/include/asm/pci_x86.h
+++ b/arch/x86/include/asm/pci_x86.h
@@ -121,49 +121,6 @@ extern int __init pcibios_init(void);
 extern int pci_legacy_init(void);
 extern void pcibios_fixup_irqs(void);
 
-/*
- * AMD Fam10h CPUs are buggy, and cannot access MMIO config space
- * on their northbrige except through the * %eax register. As such, you MUST
- * NOT use normal IOMEM accesses, you need to only use the magic mmio-config
- * accessor functions.
- * In fact just use pci_config_*, nothing else please.
- */
-static inline unsigned char mmio_config_readb(void __iomem *pos)
-{
-	u8 val;
-	asm volatile("movb (%1),%%al" : "=a" (val) : "r" (pos));
-	return val;
-}
-
-static inline unsigned short mmio_config_readw(void __iomem *pos)
-{
-	u16 val;
-	asm volatile("movw (%1),%%ax" : "=a" (val) : "r" (pos));
-	return val;
-}
-
-static inline unsigned int mmio_config_readl(void __iomem *pos)
-{
-	u32 val;
-	asm volatile("movl (%1),%%eax" : "=a" (val) : "r" (pos));
-	return val;
-}
-
-static inline void mmio_config_writeb(void __iomem *pos, u8 val)
-{
-	asm volatile("movb %%al,(%1)" : : "a" (val), "r" (pos) : "memory");
-}
-
-static inline void mmio_config_writew(void __iomem *pos, u16 val)
-{
-	asm volatile("movw %%ax,(%1)" : : "a" (val), "r" (pos) : "memory");
-}
-
-static inline void mmio_config_writel(void __iomem *pos, u32 val)
-{
-	asm volatile("movl %%eax,(%1)" : : "a" (val), "r" (pos) : "memory");
-}
-
 #ifdef CONFIG_PCI
 # ifdef CONFIG_ACPI
 #  define x86_default_pci_init		pci_acpi_init
-- 
1.9.1

