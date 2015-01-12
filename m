Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045AbbALHJg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 02:09:36 -0500
Received: from g4t3426.houston.hp.com ([15.201.208.54]:39677 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbbALHJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 02:09:31 -0500
From: "Li, Zhen-Hua" <zhen-hual@hp.com>
To: <dwmw2@infradead.org>, <indou.takao@jp.fujitsu.com>, <bhe@redhat.com>,
        <joro@8bytes.org>, <vgoyal@redhat.com>, <dyoung@redhat.com>
Cc: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <kexec@lists.infradead.org>,
        <alex.williamson@redhat.com>, <ddutile@redhat.com>,
        <ishii.hironobu@jp.fujitsu.com>, <bhelgaas@google.com>,
        <doug.hatch@hp.com>, <jerry.hoemann@hp.com>, <tom.vaden@hp.com>,
        <li.zhang6@hp.com>, <lisa.mitchell@hp.com>,
        <billsumnerlinux@gmail.com>, <zhen-hual@hp.com>, <rwright@hp.com>
Subject: [PATCH v8 10/10] iommu/vt-d: Use old irte in kdump kernel
Date: Mon, 12 Jan 2015 15:06:28 +0800
Message-Id: <1421046388-27925-11-git-send-email-zhen-hual@hp.com>
X-Mailer: git-send-email 2.0.0-rc0
In-Reply-To: <1421046388-27925-1-git-send-email-zhen-hual@hp.com>
References: <1421046388-27925-1-git-send-email-zhen-hual@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the intr-remapping fault.

[1.594890] dmar: DRHD: handling fault status reg 2
[1.594894] dmar: INTR-REMAP: Request device [[41:00.0] fault index 4d
[1.594894] INTR-REMAP:[fault reason 34] Present field in the IRTE entry
is clear

Use old irte in kdump kernel, do not disable and re-enable interrupt
remapping.

Signed-off-by: Li, Zhen-Hua <zhen-hual@hp.com>
---
 drivers/iommu/intel_irq_remapping.c | 42 ++++++++++++++++++++++++++++++++-----
 1 file changed, 37 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index d37fd62..58356cb 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -198,6 +198,11 @@ static int modify_irte(int irq, struct irte *irte_modified)
 
 	set_64bit(&irte->low, irte_modified->low);
 	set_64bit(&irte->high, irte_modified->high);
+
+#ifdef CONFIG_CRASH_DUMP
+	if (is_kdump_kernel())
+		__iommu_update_old_irte(iommu, index);
+#endif
 	__iommu_flush_cache(iommu, irte, sizeof(*irte));
 
 	rc = qi_flush_iec(iommu, index, 0);
@@ -259,6 +264,11 @@ static int clear_entries(struct irq_2_iommu *irq_iommu)
 	bitmap_release_region(iommu->ir_table->bitmap, index,
 			      irq_iommu->irte_mask);
 
+#ifdef CONFIG_CRASH_DUMP
+	if (is_kdump_kernel())
+		__iommu_update_old_irte(iommu, -1);
+#endif
+
 	return qi_flush_iec(iommu, index, irq_iommu->irte_mask);
 }
 
@@ -640,11 +650,20 @@ static int __init intel_enable_irq_remapping(void)
 		 */
 		dmar_fault(-1, iommu);
 
-		/*
-		 * Disable intr remapping and queued invalidation, if already
-		 * enabled prior to OS handover.
-		 */
-		iommu_disable_irq_remapping(iommu);
+#ifdef CONFIG_CRASH_DUMP
+		if (is_kdump_kernel()) {
+			/* Do notdisable irq and then re-enable again. */
+		} else {
+#endif
+			/*
+			 * Disable intr remapping and queued invalidation,
+			 * if already enabled prior to OS handover.
+			 */
+			iommu_disable_irq_remapping(iommu);
+
+#ifdef CONFIG_CRASH_DUMP
+		}
+#endif
 
 		dmar_disable_qi(iommu);
 	}
@@ -687,7 +706,20 @@ static int __init intel_enable_irq_remapping(void)
 		if (intel_setup_irq_remapping(iommu))
 			goto error;
 
+#ifdef CONFIG_CRASH_DUMP
+	if (is_kdump_kernel()) {
+		unsigned long long q;
+
+		q = dmar_readq(iommu->reg + DMAR_IRTA_REG);
+		iommu->ir_table->base_old_phys = q & VTD_PAGE_MASK;
+		iommu->ir_table->base_old_virt = ioremap_cache(
+				iommu->ir_table->base_old_phys,
+				INTR_REMAP_TABLE_ENTRIES*sizeof(struct irte));
+		__iommu_load_old_irte(iommu);
+	} else
+#endif
 		iommu_set_irq_remapping(iommu, eim);
+
 		setup = 1;
 	}
 
-- 
2.0.0-rc0

