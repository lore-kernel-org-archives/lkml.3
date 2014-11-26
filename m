Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088AbaKZXLd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 18:11:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58390 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753370AbaKZXLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 18:11:31 -0500
Date: Wed, 26 Nov 2014 15:10:35 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-82ebe4e0c0d6ce8ef20cac67ef4ce4b46b9e219b@git.kernel.org>
Cc: tony.luck@intel.com, fenghua.yu@intel.com, mingo@kernel.org,
        gregkh@linuxfoundation.org, rjw@rjwysocki.net, joro@8bytes.org,
        konrad.wilk@oracle.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        benh@kernel.crashing.org, bp@alien8.de, bhelgaas@google.com,
        yinghai@kernel.org, jiang.liu@linux.intel.com, rdunlap@infradead.org,
        vinod.koul@intel.com, tglx@linutronix.de
Reply-To: rdunlap@infradead.org, jiang.liu@linux.intel.com, yinghai@kernel.org,
        bhelgaas@google.com, tglx@linutronix.de, vinod.koul@intel.com,
        rjw@rjwysocki.net, mingo@kernel.org, gregkh@linuxfoundation.org,
        fenghua.yu@intel.com, tony.luck@intel.com, benh@kernel.crashing.org,
        bp@alien8.de, linux-kernel@vger.kernel.org, hpa@zytor.com,
        konrad.wilk@oracle.com, joro@8bytes.org
In-Reply-To: <1416894816-23245-20-git-send-email-jiang.liu@linux.intel.com>
References: <1416894816-23245-20-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] iommu/vt-d:
  Refine the interfaces to create IRQ for DMAR unit
Git-Commit-ID: 82ebe4e0c0d6ce8ef20cac67ef4ce4b46b9e219b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  82ebe4e0c0d6ce8ef20cac67ef4ce4b46b9e219b
Gitweb:     http://git.kernel.org/tip/82ebe4e0c0d6ce8ef20cac67ef4ce4b46b9e219b
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Tue, 25 Nov 2014 13:53:28 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 26 Nov 2014 18:59:25 +0100

iommu/vt-d: Refine the interfaces to create IRQ for DMAR unit

Refine the interfaces to create IRQ for DMAR unit. It's a preparation
for converting DMAR IRQ to hierarchy irqdomain on x86.

It also moves dmar_alloc_hwirq()/dmar_free_hwirq() from irq_remapping.h
to dmar.h. They are not irq_remapping specific.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: iommu@lists.linux-foundation.org
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Vinod Koul <vinod.koul@intel.com>
Link: http://lkml.kernel.org/r/1416894816-23245-20-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/ia64/include/asm/irq_remapping.h |  2 --
 arch/ia64/kernel/msi_ia64.c           | 30 +++++++++++++++++++-----------
 arch/x86/include/asm/irq_remapping.h  |  4 ----
 arch/x86/kernel/apic/msi.c            | 24 +++++++++++++-----------
 drivers/iommu/dmar.c                  | 19 +++++--------------
 include/linux/dmar.h                  |  3 ++-
 6 files changed, 39 insertions(+), 43 deletions(-)

diff --git a/arch/ia64/include/asm/irq_remapping.h b/arch/ia64/include/asm/irq_remapping.h
index e3b3556..a8687b1 100644
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
index 8ae36ea..3f6b761 100644
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
index 9c39650..82507c5 100644
--- a/arch/x86/include/asm/irq_remapping.h
+++ b/arch/x86/include/asm/irq_remapping.h
@@ -121,8 +121,4 @@ irq_remapping_get_irq_domain(struct irq_alloc_info *info)
 
 #define	irq_remapping_print_chip	NULL
 #endif /* CONFIG_IRQ_REMAP */
-
-extern int dmar_alloc_hwirq(void);
-extern void dmar_free_hwirq(int irq);
-
 #endif /* __X86_IRQ_REMAPPING_H */
diff --git a/arch/x86/kernel/apic/msi.c b/arch/x86/kernel/apic/msi.c
index afaaa11..695c82b 100644
--- a/arch/x86/kernel/apic/msi.c
+++ b/arch/x86/kernel/apic/msi.c
@@ -228,25 +228,27 @@ static struct irq_chip dmar_msi_type = {
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
index 9847613..536f2d8 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -1087,8 +1087,8 @@ static void free_iommu(struct intel_iommu *iommu)
 
 	if (iommu->irq) {
 		free_irq(iommu->irq, iommu);
-		irq_set_handler_data(iommu->irq, NULL);
 		dmar_free_hwirq(iommu->irq);
+		iommu->irq = 0;
 	}
 
 	if (iommu->qi) {
@@ -1642,23 +1642,14 @@ int dmar_set_interrupt(struct intel_iommu *iommu)
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
index 3062495..8473756 100644
--- a/include/linux/dmar.h
+++ b/include/linux/dmar.h
@@ -227,6 +227,7 @@ extern void dmar_msi_read(int irq, struct msi_msg *msg);
 extern void dmar_msi_write(int irq, struct msi_msg *msg);
 extern int dmar_set_interrupt(struct intel_iommu *iommu);
 extern irqreturn_t dmar_fault(int irq, void *dev_id);
-extern int arch_setup_dmar_msi(unsigned int irq);
+extern int dmar_alloc_hwirq(int id, int node, void *arg);
+extern void dmar_free_hwirq(int irq);
 
 #endif /* __DMAR_H__ */
