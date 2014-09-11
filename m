Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754864AbaIKOC7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 10:02:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:39913 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753915AbaIKOCx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 10:02:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="384738933"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [RFC Part2 v1 09/21] x86, dmar: Use new irqdomain interfaces to allocate/free IRQ
Date: Thu, 11 Sep 2014 22:03:36 +0800
Message-Id: <1410444228-3134-10-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1410444228-3134-1-git-send-email-jiang.liu@linux.intel.com>
References: <1410444228-3134-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use new irqdomain interfaces to allocate/free IRQ for DMAR and interrupt
remapping, so we could kill GENERIC_IRQ_LEGACY_ALLOC_HWIRQ later.

The private definition of irq_alloc_hwirqs()/irq_free_hwirqs() are
temporary solution, it will be removed once we have converted interrupt
remapping driver to use irqdomain framework.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/include/asm/irq_remapping.h |    4 ++--
 arch/x86/kernel/apic/msi.c           |   10 ++++++++++
 drivers/iommu/irq_remapping.c        |   17 +++++++++++++++--
 3 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/irq_remapping.h b/arch/x86/include/asm/irq_remapping.h
index b7747c4c2cf2..230dde9b695e 100644
--- a/arch/x86/include/asm/irq_remapping.h
+++ b/arch/x86/include/asm/irq_remapping.h
@@ -103,7 +103,7 @@ static inline bool setup_remapped_irq(int irq,
 }
 #endif /* CONFIG_IRQ_REMAP */
 
-#define dmar_alloc_hwirq()	irq_alloc_hwirq(-1)
-#define dmar_free_hwirq		irq_free_hwirq
+extern int dmar_alloc_hwirq(void);
+extern void dmar_free_hwirq(int irq);
 
 #endif /* __X86_IRQ_REMAPPING_H */
diff --git a/arch/x86/kernel/apic/msi.c b/arch/x86/kernel/apic/msi.c
index 2439d383c10c..ad2d624a0800 100644
--- a/arch/x86/kernel/apic/msi.c
+++ b/arch/x86/kernel/apic/msi.c
@@ -221,6 +221,16 @@ int arch_setup_dmar_msi(unsigned int irq)
 				      "edge");
 	return 0;
 }
+
+int dmar_alloc_hwirq(void)
+{
+	return irq_domain_alloc_irqs(NULL, -1, 1, NUMA_NO_NODE, NULL);
+}
+
+void dmar_free_hwirq(int irq)
+{
+	irq_domain_free_irqs(irq, 1);
+}
 #endif
 
 /*
diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index 34d01de91bd7..7dd893ee70be 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -6,6 +6,7 @@
 #include <linux/msi.h>
 #include <linux/irq.h>
 #include <linux/pci.h>
+#include <linux/irqdomain.h>
 
 #include <asm/hw_irq.h>
 #include <asm/irq_remapping.h>
@@ -49,6 +50,18 @@ static void irq_remapping_disable_io_apic(void)
 		disconnect_bsp_APIC(0);
 }
 
+#ifndef CONFIG_GENERIC_IRQ_LEGACY_ALLOC_HWIRQ
+static unsigned int irq_alloc_hwirqs(int cnt, int node)
+{
+	return irq_domain_alloc_irqs(NULL, -1, cnt, node, NULL);
+}
+
+static void irq_free_hwirqs(unsigned int from, int cnt)
+{
+	irq_domain_free_irqs(from, cnt);
+}
+#endif
+
 static int do_setup_msi_irqs(struct pci_dev *dev, int nvec)
 {
 	int ret, sub_handle, nvec_pow2, index = 0;
@@ -112,7 +125,7 @@ static int do_setup_msix_irqs(struct pci_dev *dev, int nvec)
 
 	list_for_each_entry(msidesc, &dev->msi_list, list) {
 
-		irq = irq_alloc_hwirq(node);
+		irq = irq_alloc_hwirqs(1, node);
 		if (irq == 0)
 			return -1;
 
@@ -135,7 +148,7 @@ static int do_setup_msix_irqs(struct pci_dev *dev, int nvec)
 	return 0;
 
 error:
-	irq_free_hwirq(irq);
+	irq_free_hwirqs(irq, 1);
 	return ret;
 }
 
-- 
1.7.10.4

