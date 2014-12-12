Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934985AbaLLPZO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 10:25:14 -0500
Received: from mga02.intel.com ([134.134.136.20]:21486 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759540AbaLLPZI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 10:25:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,564,1413270000"; 
   d="scan'208";a="622807147"
From: Feng Wu <feng.wu@intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        gleb@kernel.org, pbonzini@redhat.com, dwmw2@infradead.org,
        joro@8bytes.org, alex.williamson@redhat.com, jiang.liu@linux.intel.com
Cc: eric.auger@linaro.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        Feng Wu <feng.wu@intel.com>
Subject: [v3 04/26] iommu, x86: Implement irq_set_vcpu_affinity for intel_ir_chip
Date: Fri, 12 Dec 2014 23:14:38 +0800
Message-Id: <1418397300-10870-5-git-send-email-feng.wu@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1418397300-10870-1-git-send-email-feng.wu@intel.com>
References: <1418397300-10870-1-git-send-email-feng.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement irq_set_vcpu_affinity for intel_ir_chip.

Signed-off-by: Feng Wu <feng.wu@intel.com>
Reviewed-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/include/asm/irq_remapping.h |  5 +++++
 drivers/iommu/intel_irq_remapping.c  | 35 +++++++++++++++++++++++++++++++++++
 2 files changed, 40 insertions(+)

diff --git a/arch/x86/include/asm/irq_remapping.h b/arch/x86/include/asm/irq_remapping.h
index f67ae08..f87ac70 100644
--- a/arch/x86/include/asm/irq_remapping.h
+++ b/arch/x86/include/asm/irq_remapping.h
@@ -60,6 +60,11 @@ static inline struct irq_domain *arch_get_ir_parent_domain(void)
 	return x86_vector_domain;
 }
 
+struct vcpu_data {
+	u64 pi_desc_addr;	/* Physical address of PI Descriptor */
+	u32 vector;		/* Guest vector of the interrupt */
+};
+
 #else  /* CONFIG_IRQ_REMAP */
 
 static inline void setup_irq_remapping_ops(void) { }
diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index f6da3b2..48c2051 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -42,6 +42,7 @@ struct irq_2_iommu {
 struct intel_ir_data {
 	struct irq_2_iommu			irq_2_iommu;
 	struct irte				irte_entry;
+	struct irte_pi                          irte_pi_entry;
 	union {
 		struct msi_msg			msi_entry;
 	};
@@ -1010,10 +1011,44 @@ static void intel_ir_compose_msi_msg(struct irq_data *irq_data,
 	*msg = ir_data->msi_entry;
 }
 
+static int intel_ir_set_vcpu_affinity(struct irq_data *data, void *vcpu_info)
+{
+	struct intel_ir_data *ir_data = data->chip_data;
+	struct irte_pi *irte_pi = &ir_data->irte_pi_entry;
+	struct vcpu_data *vcpu_pi_info;
+
+	/* stop posting interrupts, back to remapping mode */
+	if (!vcpu_info)
+		modify_irte(&ir_data->irq_2_iommu, &ir_data->irte_entry);
+	else {
+		vcpu_pi_info = (struct vcpu_data *)vcpu_info;
+		memcpy(irte_pi, &ir_data->irte_entry, sizeof(struct irte));
+
+		irte_pi->urg = 0;
+		irte_pi->vector = vcpu_pi_info->vector;
+		irte_pi->pda_l = (vcpu_pi_info->pi_desc_addr >>
+				 (32 - PDA_LOW_BIT)) & ~(-1UL << PDA_LOW_BIT);
+		irte_pi->pda_h = (vcpu_pi_info->pi_desc_addr >> 32) &
+				 ~(-1UL << PDA_HIGH_BIT);
+
+		irte_pi->__reserved_1 = 0;
+		irte_pi->__reserved_2 = 0;
+		irte_pi->__reserved_3 = 0;
+		irte_pi->__reserved_4 = 0;
+
+		irte_pi->pst = 1;
+
+		modify_irte(&ir_data->irq_2_iommu, (struct irte *)irte_pi);
+	}
+
+	return 0;
+}
+
 static struct irq_chip intel_ir_chip = {
 	.irq_ack = ir_ack_apic_edge,
 	.irq_set_affinity = intel_ir_set_affinity,
 	.irq_compose_msi_msg = intel_ir_compose_msi_msg,
+	.irq_set_vcpu_affinity = intel_ir_set_vcpu_affinity,
 };
 
 static void intel_irq_remapping_prepare_irte(struct intel_ir_data *data,
-- 
1.9.1

