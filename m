Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752133AbaLCHt7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 02:49:59 -0500
Received: from mga11.intel.com ([192.55.52.93]:60624 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751923AbaLCHt5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 02:49:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,506,1413270000"; 
   d="scan'208";a="631852239"
From: Feng Wu <feng.wu@intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        gleb@kernel.org, pbonzini@redhat.com, dwmw2@infradead.org,
        joro@8bytes.org, alex.williamson@redhat.com, jiang.liu@linux.intel.com
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, Feng Wu <feng.wu@intel.com>
Subject: [v2 06/25] iommu, x86: No need to migrating irq for VT-d Posted-Interrupts
Date: Wed,  3 Dec 2014 15:39:35 +0800
Message-Id: <1417592394-24343-7-git-send-email-feng.wu@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1417592394-24343-1-git-send-email-feng.wu@intel.com>
References: <1417592394-24343-1-git-send-email-feng.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need to migrate the irqs for VT-d Posted-Interrupts here.
When 'pst' is set in IRTE, the associated irq will be posted to
guests instead of interrupt remapping. The destination of the
interrupt is set in Posted-Interrupts Descriptor, and the migration
happens during vCPU scheduling.

Signed-off-by: Feng Wu <feng.wu@intel.com>
Reviewed-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/iommu/intel_irq_remapping.c |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index 749cb93..01786a8 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -976,10 +976,20 @@ intel_ir_set_affinity(struct irq_data *data, const struct cpumask *mask,
 {
 	struct intel_ir_data *ir_data = data->chip_data;
 	struct irte *irte = &ir_data->irte_entry;
+	struct irte_pi *irte_pi = (struct irte_pi *)irte;
 	struct irq_cfg *cfg = irqd_cfg(data);
 	struct irq_data *parent = data->parent_data;
 	int ret;
 
+	/*
+	 * If the interrupt is for posting, it is used by guests,
+	 * we cannot set irq affinity here.
+	 */
+	if (irte_pi->pst == 1) {
+		pr_warn("cannot set irq affinity for posted-interrupts\n");
+		return -EBUSY;
+	}
+
 	ret = parent->chip->irq_set_affinity(parent, mask, force);
 	if (ret < 0 || ret == IRQ_SET_MASK_OK_DONE)
 		return ret;
-- 
1.7.1

