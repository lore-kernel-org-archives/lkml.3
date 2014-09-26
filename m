Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755946AbaIZOFh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 10:05:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:63344 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755705AbaIZODK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 10:03:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,604,1406617200"; 
   d="scan'208";a="609110458"
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
Subject: [RFT v2 21/24] iommu/vt-d: Refine the interfaces to create IRQ for DMAR unit
Date: Fri, 26 Sep 2014 22:02:22 +0800
Message-Id: <1411740145-30626-22-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1411740145-30626-1-git-send-email-jiang.liu@linux.intel.com>
References: <1411740145-30626-1-git-send-email-jiang.liu@linux.intel.com>
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
index c430f9198d1b..f7264db62804 100644
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
index 514bb9b73013..de1a5d3277e2 100644
--- a/arch/x86/include/asm/irq_remapping.h
+++ b/arch/x86/include/asm/irq_remapping.h
@@ -158,8 +158,4 @@ static inline bool irq_remapping_domain_is_remapped(struct irq_domain *domain)
 
 #define	irq_remapping_print_chip	NULL
 #endif /* CONFIG_IRQ_REMAP */
-
-extern int dmar_alloc_hwirq(void);
-extern void dmar_free_hwirq(int irq);
-
 #endif /* __X86_IRQ_REMAPPING_H */
diff --git a/arch/x86/kernel/apic/msi.c b/arch/x86/kernel/apic/msi.c
index 35f090c2f698..08b6d1987ea6 100644
--- a/arch/x86/kernel/apic/msi.c
+++ b/arch/x86/kernel/apic/msi.c
@@ -329,25 +329,27 @@ static struct irq_chip dmar_msi_type = {
 	.irq_retrigger		= apic_retrigger_irq,
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
index 06d268abe951..6644f504b741 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -1001,8 +1001,8 @@ static void free_iommu(struct intel_iommu *iommu)
 
 	if (iommu->irq) {
 		free_irq(iommu->irq, iommu);
-		irq_set_handler_data(iommu->irq, NULL);
 		dmar_free_hwirq(iommu->irq);
+		iommu->irq = 0;
 	}
 
 	if (iommu->qi) {
@@ -1555,23 +1555,14 @@ int dmar_set_interrupt(struct intel_iommu *iommu)
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
index 1deece46a0ca..9eff3a81a636 100644
--- a/include/linux/dmar.h
+++ b/include/linux/dmar.h
@@ -183,6 +183,7 @@ extern void dmar_msi_read(int irq, struct msi_msg *msg);
 extern void dmar_msi_write(int irq, struct msi_msg *msg);
 extern int dmar_set_interrupt(struct intel_iommu *iommu);
 extern irqreturn_t dmar_fault(int irq, void *dev_id);
-extern int arch_setup_dmar_msi(unsigned int irq);
+extern int dmar_alloc_hwirq(int id, int node, void *arg);
+extern void dmar_free_hwirq(int irq);
 
 #endif /* __DMAR_H__ */
-- 
1.7.10.4

