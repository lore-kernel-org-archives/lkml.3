Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753736Ab3LFDUh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 22:20:37 -0500
Received: from mga03.intel.com ([143.182.124.21]:56623 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752302Ab3LFDUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 22:20:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,838,1378882800"; 
   d="scan'208";a="325986877"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw2@infradead.org>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>, Ashok Raj <ashok.raj@intel.com>,
        Yijing Wang <wangyijing@huawei.com>, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, linux-pci@vger.kernel.org,
        dmaengine@vger.kernel.org
Subject: [Patch Part1 V2 01/20] iommu/vt-d: use dedicated bitmap to track remapping entry allocation status
Date: Fri,  6 Dec 2013 11:21:04 +0800
Message-Id: <1386300083-6882-2-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1386300083-6882-1-git-send-email-jiang.liu@linux.intel.com>
References: <1386300083-6882-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently Intel interrupt remapping drivers uses the "present" flag bit
in remapping entry to track whether an entry is allocated or not.
It works as follow:
1) allocate a remapping entry and set its "present" flag bit to 1
2) compose other fields for the entry
3) update the remapping entry with the composed value

The remapping hardware may access the entry between step 1 and step 3,
which then obervers an entry with the "present" flag set but random
values in all other fields.

This patch introduces a dedicated bitmap to track remapping entry
allocation status instead of sharing the "present" flag with hardware,
thus eliminate the race window. It also simplifies the implementation.

Tested-and-reviewed-by: Yijing Wang <wangyijing@huawei.com>
Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/iommu/intel_irq_remapping.c |   51 +++++++++++++++++------------------
 include/linux/intel-iommu.h         |    1 +
 2 files changed, 25 insertions(+), 27 deletions(-)

diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index bab10b1..282d392 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -72,7 +72,6 @@ static int alloc_irte(struct intel_iommu *iommu, int irq, u16 count)
 	u16 index, start_index;
 	unsigned int mask = 0;
 	unsigned long flags;
-	int i;
 
 	if (!count || !irq_iommu)
 		return -1;
@@ -96,32 +95,17 @@ static int alloc_irte(struct intel_iommu *iommu, int irq, u16 count)
 	}
 
 	raw_spin_lock_irqsave(&irq_2_ir_lock, flags);
-	do {
-		for (i = index; i < index + count; i++)
-			if  (table->base[i].present)
-				break;
-		/* empty index found */
-		if (i == index + count)
-			break;
-
-		index = (index + count) % INTR_REMAP_TABLE_ENTRIES;
-
-		if (index == start_index) {
-			raw_spin_unlock_irqrestore(&irq_2_ir_lock, flags);
-			printk(KERN_ERR "can't allocate an IRTE\n");
-			return -1;
-		}
-	} while (1);
-
-	for (i = index; i < index + count; i++)
-		table->base[i].present = 1;
-
-	cfg->remapped = 1;
-	irq_iommu->iommu = iommu;
-	irq_iommu->irte_index =  index;
-	irq_iommu->sub_handle = 0;
-	irq_iommu->irte_mask = mask;
-
+	index = bitmap_find_free_region(table->bitmap,
+					INTR_REMAP_TABLE_ENTRIES, mask);
+	if (index < 0) {
+		printk(KERN_ERR "can't allocate an IRTE\n");
+	} else {
+		cfg->remapped = 1;
+		irq_iommu->iommu = iommu;
+		irq_iommu->irte_index =  index;
+		irq_iommu->sub_handle = 0;
+		irq_iommu->irte_mask = mask;
+	}
 	raw_spin_unlock_irqrestore(&irq_2_ir_lock, flags);
 
 	return index;
@@ -254,6 +238,8 @@ static int clear_entries(struct irq_2_iommu *irq_iommu)
 		set_64bit(&entry->low, 0);
 		set_64bit(&entry->high, 0);
 	}
+	bitmap_release_region(iommu->ir_table->bitmap, index,
+			      irq_iommu->irte_mask);
 
 	return qi_flush_iec(iommu, index, irq_iommu->irte_mask);
 }
@@ -453,6 +439,7 @@ static int intel_setup_irq_remapping(struct intel_iommu *iommu, int mode)
 {
 	struct ir_table *ir_table;
 	struct page *pages;
+	unsigned long *bitmap;
 
 	ir_table = iommu->ir_table = kzalloc(sizeof(struct ir_table),
 					     GFP_ATOMIC);
@@ -470,7 +457,17 @@ static int intel_setup_irq_remapping(struct intel_iommu *iommu, int mode)
 		return -ENOMEM;
 	}
 
+	bitmap = kcalloc(BITS_TO_LONGS(INTR_REMAP_TABLE_ENTRIES),
+			 sizeof(long), GFP_ATOMIC);
+	if (bitmap == NULL) {
+		printk(KERN_ERR "failed to allocate bitmap\n");
+		__free_pages(pages, INTR_REMAP_PAGE_ORDER);
+		kfree(ir_table);
+		return -ENOMEM;
+	}
+
 	ir_table->base = page_address(pages);
+	ir_table->bitmap = bitmap;
 
 	iommu_set_irq_remapping(iommu, mode);
 	return 0;
diff --git a/include/linux/intel-iommu.h b/include/linux/intel-iommu.h
index d380c5e..de1e5e9 100644
--- a/include/linux/intel-iommu.h
+++ b/include/linux/intel-iommu.h
@@ -288,6 +288,7 @@ struct q_inval {
 
 struct ir_table {
 	struct irte *base;
+	unsigned long *bitmap;
 };
 #endif
 
-- 
1.7.10.4

