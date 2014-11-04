Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754248AbaKDMF4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 07:05:56 -0500
Received: from mga01.intel.com ([192.55.52.88]:26523 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751562AbaKDMFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 07:05:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,313,1413270000"; 
   d="scan'208";a="616768480"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        x86@kernel.org, Joerg Roedel <joro@8bytes.org>,
        Vinod Koul <vinod.koul@intel.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-ia64@vger.kernel.org, iommu@lists.linux-foundation.org,
        dmaengine@vger.kernel.org
Subject: [Patch Part2 v4 28/31] iommu/vt-d: Refine the interfaces to create IRQ for DMAR unit
Date: Tue,  4 Nov 2014 20:02:02 +0800
Message-Id: <1415102525-9898-29-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1415102525-9898-1-git-send-email-jiang.liu@linux.intel.com>
References: <1415102525-9898-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Refine the interfaces to create IRQ for DMAR unit. It's a preparation
for converting DMAR IRQ to irqdomain on x86.

It also moves dmar_alloc_hwirq()/dmar_free_hwirq() from irq_remapping.h
to dmar.h. They are not irq_remapping specific.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/ia64/include/asm/irq_remapping.h |    2 --
 arch/ia64/kernel/msi_ia64.c           |   30 +++++++++++++++++++-----------
 arch/x86/include/asm/irq_remapping.h  |    4 ----
 arch/x86/kernel/apic/msi.c            |   24 +++++++++++++-----------
 drivers/iommu/dmar.c                  |   19 +++++--------------
 include/linux/dmar.h                  |    3 ++-
 6 files changed, 39 insertions(+), 43 deletions(-)

diff --git a/arch/ia64/include/asm/irq_remapping.h b/arch/ia64/include/asm/irq_remapping.h
index e3b3556e2e1b..a8687b1d8906 100644
--- a/arch/ia64/include/asm/irq_remapping.h
+++ b/arch/ia64/include/asm/irq_remapping.h
@@ -1,6 +1,4 @@
 #ifndef __IA64_INTR_REMAPPING_H
 #define __IA64_INTR_REMAPPING_H
 #define irq_remapping_enabled 0
-#define dmar_alloc_hwirq	create_irq
-#define dmar_free_hwirq		destroy_irq
 #endif
diff --git a/arch/ia64/kernel/msi_ia64.c b/arch/ia64/kernel/msi_ia64.c
index 8c3730c3c63d..15032330573b 100644
--- a/arch/ia64/kernel/msi_ia64.c
+++ b/arch/ia64/kernel/msi_ia64.c
@@ -166,7 +166,7 @@ static struct irq_chip dmar_msi_type = {
 	.irq_retrigger = ia64_msi_retrigger_irq,
 };
 
-static int
+static void
 msi_compose_msg(struct pci_dev *pdev, unsigned int irq, struct msi_msg *msg)
 {
 	struct irq_cfg *cfg = irq_cfg + irq;
@@ -188,21 +188,29 @@ msi_compose_msg(struct pci_dev *pdev, unsigned int irq, struct msi_msg *msg)
 		MSI_DATA_LEVEL_ASSERT |
 		MSI_DATA_DELIVERY_FIXED |
 		MSI_DATA_VECTOR(cfg->vector);
-	return 0;
 }
 
-int arch_setup_dmar_msi(unsigned int irq)
+int dmar_alloc_hwirq(int id, int node, void *arg)
 {
-	int ret;
+	int irq;
 	struct msi_msg msg;
 
-	ret = msi_compose_msg(NULL, irq, &msg);
-	if (ret < 0)
-		return ret;
-	dmar_msi_write(irq, &msg);
-	irq_set_chip_and_handler_name(irq, &dmar_msi_type, handle_edge_irq,
-				      "edge");
-	return 0;
+	irq = create_irq();
+	if (irq > 0) {
+		irq_set_handler_data(irq, arg);
+		irq_set_chip_and_handler_name(irq, &dmar_msi_type,
+					      handle_edge_irq, "edge");
+		msi_compose_msg(NULL, irq, &msg);
+		dmar_msi_write(irq, &msg);
+	}
+
+	return irq;
+}
+
+void dmar_free_hwirq(int irq)
+{
+	irq_set_handler_data(irq, NULL);
+	destroy_irq(irq);
 }
 #endif /* CONFIG_INTEL_IOMMU */
 
diff --git a/arch/x86/include/asm/irq_remapping.h b/arch/x86/include/asm/irq_remapping.h
index 61c50e6e28c8..61ec9234c88e 100644
--- a/arch/x86/include/asm/irq_remapping.h
+++ b/arch/x86/include/asm/irq_remapping.h
@@ -124,8 +124,4 @@ irq_remapping_get_irq_domain(struct irq_alloc_info *info)
 
 #define	irq_remapping_print_chip	NULL
 #endif /* CONFIG_IRQ_REMAP */
-
-extern int dmar_alloc_hwirq(void);
-extern void dmar_free_hwirq(int irq);
-
 #endif /* __X86_IRQ_REMAPPING_H */
diff --git a/arch/x86/kernel/apic/msi.c b/arch/x86/kernel/apic/msi.c
index 6bfe85e96c74..79fc6bb0d104 100644
--- a/arch/x86/kernel/apic/msi.c
+++ b/arch/x86/kernel/apic/msi.c
@@ -219,25 +219,27 @@ static struct irq_chip dmar_msi_type = {
  	.flags			= IRQCHIP_SKIP_SET_WAKE,
 };
 
-int arch_setup_dmar_msi(unsigned int irq)
+int dmar_alloc_hwirq(int id, int node, void *arg)
 {
+	int irq;
 	struct msi_msg msg;
-	struct irq_cfg *cfg = irq_cfg(irq);
 
-	native_compose_msi_msg(cfg, &msg);
-	dmar_msi_write(irq, &msg);
-	irq_set_chip_and_handler_name(irq, &dmar_msi_type, handle_edge_irq,
-				      "edge");
-	return 0;
-}
+	irq = irq_domain_alloc_irqs(NULL, 1, node, NULL);
+	if (irq > 0) {
+		irq_set_handler_data(irq, arg);
+		irq_set_chip_and_handler_name(irq, &dmar_msi_type,
+					      handle_edge_irq, "edge");
+		native_compose_msi_msg(irq_cfg(irq), &msg);
+		dmar_msi_write(irq, &msg);
+	}
 
-int dmar_alloc_hwirq(void)
-{
-	return irq_domain_alloc_irqs(NULL, 1, NUMA_NO_NODE, NULL);
+	return irq;
 }
 
 void dmar_free_hwirq(int irq)
 {
+	irq_set_handler_data(irq, NULL);
+	irq_set_handler(irq, NULL);
 	irq_domain_free_irqs(irq, 1);
 }
 #endif
diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index c5c61cabd6e3..25f47937f1d5 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -1018,8 +1018,8 @@ static void free_iommu(struct intel_iommu *iommu)
 
 	if (iommu->irq) {
 		free_irq(iommu->irq, iommu);
-		irq_set_handler_data(iommu->irq, NULL);
 		dmar_free_hwirq(iommu->irq);
+		iommu->irq = 0;
 	}
 
 	if (iommu->qi) {
@@ -1572,23 +1572,14 @@ int dmar_set_interrupt(struct intel_iommu *iommu)
 	if (iommu->irq)
 		return 0;
 
-	irq = dmar_alloc_hwirq();
-	if (irq <= 0) {
+	irq = dmar_alloc_hwirq(iommu->seq_id, iommu->node, iommu);
+	if (irq > 0) {
+		iommu->irq = irq;
+	} else {
 		pr_err("IOMMU: no free vectors\n");
 		return -EINVAL;
 	}
 
-	irq_set_handler_data(irq, iommu);
-	iommu->irq = irq;
-
-	ret = arch_setup_dmar_msi(irq);
-	if (ret) {
-		irq_set_handler_data(irq, NULL);
-		iommu->irq = 0;
-		dmar_free_hwirq(irq);
-		return ret;
-	}
-
 	ret = request_irq(irq, dmar_fault, IRQF_NO_THREAD, iommu->name, iommu);
 	if (ret)
 		pr_err("IOMMU: can't request irq\n");
diff --git a/include/linux/dmar.h b/include/linux/dmar.h
index 593fff99e6bf..df3918482073 100644
--- a/include/linux/dmar.h
+++ b/include/linux/dmar.h
@@ -189,6 +189,7 @@ extern void dmar_msi_read(int irq, struct msi_msg *msg);
 extern void dmar_msi_write(int irq, struct msi_msg *msg);
 extern int dmar_set_interrupt(struct intel_iommu *iommu);
 extern irqreturn_t dmar_fault(int irq, void *dev_id);
-extern int arch_setup_dmar_msi(unsigned int irq);
+extern int dmar_alloc_hwirq(int id, int node, void *arg);
+extern void dmar_free_hwirq(int irq);
 
 #endif /* __DMAR_H__ */
-- 
1.7.10.4

