Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935004AbaLLPZS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 10:25:18 -0500
Received: from mga02.intel.com ([134.134.136.20]:36405 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933783AbaLLPZP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 10:25:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,564,1413270000"; 
   d="scan'208";a="622807159"
From: Feng Wu <feng.wu@intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        gleb@kernel.org, pbonzini@redhat.com, dwmw2@infradead.org,
        joro@8bytes.org, alex.williamson@redhat.com, jiang.liu@linux.intel.com
Cc: eric.auger@linaro.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, kvm@vger.kernel.org,
        Feng Wu <feng.wu@intel.com>
Subject: [v3 06/26] iommu, x86: No need to migrating irq for VT-d Posted-Interrupts
Date: Fri, 12 Dec 2014 23:14:40 +0800
Message-Id: <1418397300-10870-7-git-send-email-feng.wu@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1418397300-10870-1-git-send-email-feng.wu@intel.com>
References: <1418397300-10870-1-git-send-email-feng.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need to migrate the irqs for VT-d Posted-Interrupts here.
When 'pst' is set in IRTE, the associated irq will be posted to
guests instead of interrupt remapping. The destination of the
interrupt is set in Posted-Interrupts Descriptor, and the migration
happens during vCPU scheduling.

However, we still update the cached irte here, which can be used
when changing back to remapping mode.

Signed-off-by: Feng Wu <feng.wu@intel.com>
Reviewed-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/iommu/intel_irq_remapping.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index 48c2051..ab9057a 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -977,6 +977,7 @@ intel_ir_set_affinity(struct irq_data *data, const struct cpumask *mask,
 {
 	struct intel_ir_data *ir_data = data->chip_data;
 	struct irte *irte = &ir_data->irte_entry;
+	struct irte_pi *irte_pi = (struct irte_pi *)irte;
 	struct irq_cfg *cfg = irqd_cfg(data);
 	struct irq_data *parent = data->parent_data;
 	int ret;
@@ -991,7 +992,10 @@ intel_ir_set_affinity(struct irq_data *data, const struct cpumask *mask,
 	 */
 	irte->vector = cfg->vector;
 	irte->dest_id = IRTE_DEST(cfg->dest_apicid);
-	modify_irte(&ir_data->irq_2_iommu, irte);
+
+	/* We don't need to modify irte if the interrupt is for posting. */
+	if (irte_pi->pst != 1)
+		modify_irte(&ir_data->irq_2_iommu, irte);
 
 	/*
 	 * After this point, all the interrupts will start arriving
-- 
1.9.1

