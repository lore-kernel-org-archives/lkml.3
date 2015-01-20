Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766AbbATDHq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 22:07:46 -0500
Received: from mga11.intel.com ([192.55.52.93]:62057 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752736AbbATDHn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 22:07:43 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="442528524"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Dimitri Sivanich <sivanich@sgi.com>,
        x86@kernel.org, Joerg Roedel <joro@8bytes.org>,
        Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Sander Eikelenboom <linux@eikelenboom.it>,
        David Vrabel <david.vrabel@citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, iommu@lists.linux-foundation.org,
        Joerg Roedel <jroedel@suse.de>
Subject: [Patch Part1 v7 07/38] x86/dmar: Use new irqdomain interfaces to allocate/free IRQ
Date: Tue, 20 Jan 2015 11:08:10 +0800
Message-Id: <1421723321-8386-8-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1421723321-8386-1-git-send-email-jiang.liu@linux.intel.com>
References: <1421723321-8386-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use new irqdomain interfaces to allocate/free IRQ for DMAR and interrupt
remapping, so we could kill GENERIC_IRQ_LEGACY_ALLOC_HWIRQ later.

The private definition of irq_alloc_hwirqs()/irq_free_hwirqs() are
temporary solution, it will be removed once we have converted interrupt
remapping driver to use irqdomain framework.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: iommu@lists.linux-foundation.org
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Joerg Roedel <joro@8bytes.org>
Link: http://lkml.kernel.org/r/1416894816-23245-8-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/include/asm/irq_remapping.h |    4 ++--
 arch/x86/kernel/apic/msi.c           |   10 ++++++++++
 drivers/iommu/irq_remapping.c        |   17 +++++++++++++++--
 3 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/irq_remapping.h b/arch/x86/include/asm/irq_remapping.h
index 6224d316c405..86d897bc15dd 100644
--- a/arch/x86/include/asm/irq_remapping.h
+++ b/arch/x86/include/asm/irq_remapping.h
@@ -99,7 +99,7 @@ static inline bool setup_remapped_irq(int irq,
 }
 #endif /* CONFIG_IRQ_REMAP */
 
-#define dmar_alloc_hwirq()	irq_alloc_hwirq(-1)
-#define dmar_free_hwirq		irq_free_hwirq
+extern int dmar_alloc_hwirq(void);
+extern void dmar_free_hwirq(int irq);
 
 #endif /* __X86_IRQ_REMAPPING_H */
diff --git a/arch/x86/kernel/apic/msi.c b/arch/x86/kernel/apic/msi.c
index 76cc2c902176..9be7d6d8a579 100644
--- a/arch/x86/kernel/apic/msi.c
+++ b/arch/x86/kernel/apic/msi.c
@@ -223,6 +223,16 @@ int arch_setup_dmar_msi(unsigned int irq)
 				      "edge");
 	return 0;
 }
+
+int dmar_alloc_hwirq(void)
+{
+	return irq_domain_alloc_irqs(NULL, 1, NUMA_NO_NODE, NULL);
+}
+
+void dmar_free_hwirq(int irq)
+{
+	irq_domain_free_irqs(irq, 1);
+}
 #endif
 
 /*
diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index 390079ee1350..5617150fd8fb 100644
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
@@ -104,7 +117,7 @@ static int do_setup_msix_irqs(struct pci_dev *dev, int nvec)
 
 	list_for_each_entry(msidesc, &dev->msi_list, list) {
 
-		irq = irq_alloc_hwirq(node);
+		irq = irq_alloc_hwirqs(1, node);
 		if (irq == 0)
 			return -1;
 
@@ -127,7 +140,7 @@ static int do_setup_msix_irqs(struct pci_dev *dev, int nvec)
 	return 0;
 
 error:
-	irq_free_hwirq(irq);
+	irq_free_hwirqs(irq, 1);
 	return ret;
 }
 
-- 
1.7.10.4

