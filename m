Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756655Ab3LFDVj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 22:21:39 -0500
Received: from mga03.intel.com ([143.182.124.21]:56623 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753132Ab3LFDVf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 22:21:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,838,1378882800"; 
   d="scan'208";a="325987031"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>, Ashok Raj <ashok.raj@intel.com>,
        Yijing Wang <wangyijing@huawei.com>, Jiri Kosina <trivial@kernel.org>,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, linux-pci@vger.kernel.org,
        dmaengine@vger.kernel.org
Subject: [Patch Part1 V2 19/20] iommu/vt-d, trivial: clean sparse warnings
Date: Fri,  6 Dec 2013 11:21:22 +0800
Message-Id: <1386300083-6882-20-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1386300083-6882-1-git-send-email-jiang.liu@linux.intel.com>
References: <1386300083-6882-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean up most sparse warnings in Intel DMA and interrupt remapping
drivers.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/iommu/dmar.c                |    8 ++++----
 drivers/iommu/intel-iommu.c         |    4 ++--
 drivers/iommu/intel_irq_remapping.c |    4 ++--
 drivers/iommu/irq_remapping.c       |    6 +++---
 4 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index b6b8a7f5..f05e2fc 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -580,7 +580,7 @@ static int __init detect_intel_iommu(void)
 			x86_init.iommu.iommu_init = intel_iommu_init;
 #endif
 	}
-	early_acpi_os_unmap_memory(dmar_tbl, dmar_tbl_size);
+	early_acpi_os_unmap_memory((void __iomem *)dmar_tbl, dmar_tbl_size);
 	dmar_tbl = NULL;
 
 	return ret ? 1 : -ENODEV;
@@ -1072,7 +1072,7 @@ int dmar_enable_qi(struct intel_iommu *iommu)
 	desc_page = alloc_pages_node(iommu->node, GFP_ATOMIC | __GFP_ZERO, 0);
 	if (!desc_page) {
 		kfree(qi);
-		iommu->qi = 0;
+		iommu->qi = NULL;
 		return -ENOMEM;
 	}
 
@@ -1082,7 +1082,7 @@ int dmar_enable_qi(struct intel_iommu *iommu)
 	if (!qi->desc_status) {
 		free_page((unsigned long) qi->desc);
 		kfree(qi);
-		iommu->qi = 0;
+		iommu->qi = NULL;
 		return -ENOMEM;
 	}
 
@@ -1133,7 +1133,7 @@ static const char *irq_remap_fault_reasons[] =
 	"Blocked an interrupt request due to source-id verification failure",
 };
 
-const char *dmar_get_fault_reason(u8 fault_reason, int *fault_type)
+static const char *dmar_get_fault_reason(u8 fault_reason, int *fault_type)
 {
 	if (fault_reason >= 0x20 && (fault_reason - 0x20 <
 					ARRAY_SIZE(irq_remap_fault_reasons))) {
diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index c1831d7..87ea78b 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -382,7 +382,7 @@ struct device_domain_info {
 
 static void flush_unmaps_timeout(unsigned long data);
 
-DEFINE_TIMER(unmap_timer,  flush_unmaps_timeout, 0, 0);
+static DEFINE_TIMER(unmap_timer,  flush_unmaps_timeout, 0, 0);
 
 #define HIGH_WATER_MARK 250
 struct deferred_flush_tables {
@@ -3124,7 +3124,7 @@ static int intel_mapping_error(struct device *dev, dma_addr_t dma_addr)
 	return !dma_addr;
 }
 
-struct dma_map_ops intel_dma_ops = {
+static struct dma_map_ops intel_dma_ops = {
 	.alloc = intel_alloc_coherent,
 	.free = intel_free_coherent,
 	.map_sg = intel_map_sg,
diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index 7b4bdaa..aabdc71 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -48,7 +48,7 @@ static struct irq_2_iommu *irq_2_iommu(unsigned int irq)
 	return cfg ? &cfg->irq_2_iommu : NULL;
 }
 
-int get_irte(int irq, struct irte *entry)
+static int get_irte(int irq, struct irte *entry)
 {
 	struct irq_2_iommu *irq_iommu = irq_2_iommu(irq);
 	unsigned long flags;
@@ -795,7 +795,7 @@ static int __init parse_ioapics_under_ir(void)
 	return 1;
 }
 
-int __init ir_dev_scope_init(void)
+static int __init ir_dev_scope_init(void)
 {
 	if (!irq_remapping_enabled)
 		return 0;
diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index 39f81ae..228632c9 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -150,7 +150,7 @@ static int irq_remapping_setup_msi_irqs(struct pci_dev *dev,
 		return do_setup_msix_irqs(dev, nvec);
 }
 
-void eoi_ioapic_pin_remapped(int apic, int pin, int vector)
+static void eoi_ioapic_pin_remapped(int apic, int pin, int vector)
 {
 	/*
 	 * Intr-remapping uses pin number as the virtual vector
@@ -295,8 +295,8 @@ int setup_ioapic_remapped_entry(int irq,
 					     vector, attr);
 }
 
-int set_remapped_irq_affinity(struct irq_data *data, const struct cpumask *mask,
-			      bool force)
+static int set_remapped_irq_affinity(struct irq_data *data,
+				     const struct cpumask *mask, bool force)
 {
 	if (!config_enabled(CONFIG_SMP) || !remap_ops ||
 	    !remap_ops->set_affinity)
-- 
1.7.10.4

