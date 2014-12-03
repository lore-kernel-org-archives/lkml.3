Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752102AbaLCHty (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 02:49:54 -0500
Received: from mga11.intel.com ([192.55.52.93]:60624 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923AbaLCHtv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 02:49:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,506,1413270000"; 
   d="scan'208";a="631852226"
From: Feng Wu <feng.wu@intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        gleb@kernel.org, pbonzini@redhat.com, dwmw2@infradead.org,
        joro@8bytes.org, alex.williamson@redhat.com, jiang.liu@linux.intel.com
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, Feng Wu <feng.wu@intel.com>
Subject: [v2 04/25] iommu, x86: Implement irq_set_vcpu_affinity for intel_ir_chip
Date: Wed,  3 Dec 2014 15:39:33 +0800
Message-Id: <1417592394-24343-5-git-send-email-feng.wu@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1417592394-24343-1-git-send-email-feng.wu@intel.com>
References: <1417592394-24343-1-git-send-email-feng.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement irq_set_vcpu_affinity for intel_ir_chip.

Signed-off-by: Feng Wu <feng.wu@intel.com>
Reviewed-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/include/asm/irq_remapping.h |    5 +++++
 drivers/iommu/intel_irq_remapping.c  |   27 +++++++++++++++++++++++++++
 2 files changed, 32 insertions(+), 0 deletions(-)

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
index f6da3b2..749cb93 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -1010,10 +1010,37 @@ static void intel_ir_compose_msi_msg(struct irq_data *irq_data,
 	*msg = ir_data->msi_entry;
 }
 
+static int intel_ir_set_vcpu_affinity(struct irq_data *data, void *vcpu_info)
+{
+	struct intel_ir_data *ir_data = data->chip_data;
+	struct irte *irte = &ir_data->irte_entry;
+	struct irte_pi *irte_pi = (struct irte_pi *)irte;
+	struct vcpu_data *vcpu_pi_info = (struct vcpu_data *)vcpu_info;
+
+	irte_pi->urg = 0;
+	irte_pi->vector = vcpu_pi_info->vector;
+	irte_pi->pda_l = (vcpu_pi_info->pi_desc_addr >> (32 - PDA_LOW_BIT)) &
+			 ~(-1UL << PDA_LOW_BIT);
+	irte_pi->pda_h = (vcpu_pi_info->pi_desc_addr >> 32) &
+			 ~(-1UL << PDA_HIGH_BIT);
+
+	irte_pi->__reserved_1 = 0;
+	irte_pi->__reserved_2 = 0;
+	irte_pi->__reserved_3 = 0;
+	irte_pi->__reserved_4 = 0;
+
+	irte_pi->pst = 1;
+
+	modify_irte(&ir_data->irq_2_iommu, irte);
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
1.7.1

