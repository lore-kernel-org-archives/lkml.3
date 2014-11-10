Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751809AbaKJGgd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 01:36:33 -0500
Received: from mga11.intel.com ([192.55.52.93]:54478 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750850AbaKJGgb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 01:36:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,351,1413270000"; 
   d="scan'208";a="629364112"
From: Feng Wu <feng.wu@intel.com>
To: gleb@kernel.org, pbonzini@redhat.com, dwmw2@infradead.org, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org
Cc: kvm@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Feng Wu <feng.wu@intel.com>
Subject: [PATCH 01/13] iommu/vt-d: VT-d Posted-Interrupts feature detection
Date: Mon, 10 Nov 2014 14:26:40 +0800
Message-Id: <1415600812-27773-2-git-send-email-feng.wu@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1415600812-27773-1-git-send-email-feng.wu@intel.com>
References: <1415600812-27773-1-git-send-email-feng.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

VT-d Posted-Interrupts is an enhancement to CPU side Posted-Interrupt.
With VT-d Posted-Interrupts enabled, external interrupts from
direct-assigned devices can be delivered to guests without VMM
intervention when guest is running in non-root mode.

This patch adds feature detection logic for VT-d posted-interrupt.

Signed-off-by: Feng Wu <feng.wu@intel.com>
---
 drivers/iommu/intel_irq_remapping.c |   13 +++++++++++++
 drivers/iommu/irq_remapping.c       |    4 ++++
 drivers/iommu/irq_remapping.h       |    5 +++++
 include/linux/intel-iommu.h         |    1 +
 4 files changed, 23 insertions(+), 0 deletions(-)

diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index 7c80661..f99f0f1 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -580,6 +580,19 @@ static int __init intel_irq_remapping_supported(void)
 		if (!ecap_ir_support(iommu->ecap))
 			return 0;
 
+	/* VT-d posted-interrupt feature detection*/
+	if (disable_irq_post == 0)
+		for_each_drhd_unit(drhd) {
+			struct intel_iommu *iommu = drhd->iommu;
+
+			if (!cap_pi_support(iommu->cap)) {
+				irq_post_enabled = 0;
+				disable_irq_post = 1;
+				break;
+			}
+			irq_post_enabled = 1;
+		}
+
 	return 1;
 }
 
diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index 74a1767..2f8ee00 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -23,6 +23,10 @@ int irq_remap_broken;
 int disable_sourceid_checking;
 int no_x2apic_optout;
 
+int disable_irq_post = 1;
+int irq_post_enabled = 0;
+EXPORT_SYMBOL_GPL(irq_post_enabled);
+
 static struct irq_remap_ops *remap_ops;
 
 static int msi_alloc_remapped_irq(struct pci_dev *pdev, int irq, int nvec);
diff --git a/drivers/iommu/irq_remapping.h b/drivers/iommu/irq_remapping.h
index fde250f..7bb5913 100644
--- a/drivers/iommu/irq_remapping.h
+++ b/drivers/iommu/irq_remapping.h
@@ -37,6 +37,9 @@ extern int disable_sourceid_checking;
 extern int no_x2apic_optout;
 extern int irq_remapping_enabled;
 
+extern int disable_irq_post;
+extern int irq_post_enabled;
+
 struct irq_remap_ops {
 	/* Check whether Interrupt Remapping is supported */
 	int (*supported)(void);
@@ -91,6 +94,8 @@ extern struct irq_remap_ops amd_iommu_irq_ops;
 #define irq_remapping_enabled 0
 #define disable_irq_remap     1
 #define irq_remap_broken      0
+#define disable_irq_post      1
+#define irq_post_enabled      0
 
 #endif /* CONFIG_IRQ_REMAP */
 
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index a65208a..5b1a124 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -87,6 +87,7 @@ static inline void dmar_writeq(void __iomem *addr, u64 val)
 /*
  * Decoding Capability Register
  */
+#define cap_pi_support(c)	(((c) >> 59) & 1)
 #define cap_read_drain(c)	(((c) >> 55) & 1)
 #define cap_write_drain(c)	(((c) >> 54) & 1)
 #define cap_max_amask_val(c)	(((c) >> 48) & 0x3f)
-- 
1.7.1

