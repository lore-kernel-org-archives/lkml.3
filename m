Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121AbaKYFwa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 00:52:30 -0500
Received: from mga11.intel.com ([192.55.52.93]:61317 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750906AbaKYFw2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 00:52:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,453,1413270000"; 
   d="scan'208";a="627797809"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Joerg Roedel <joro@8bytes.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, iommu@lists.linux-foundation.org
Subject: [Patch Part2 v6 09/27] iommu/vt-d: Change prototypes to prepare for enabling hierarchy irqdomain
Date: Tue, 25 Nov 2014 13:53:18 +0800
Message-Id: <1416894816-23245-10-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1416894816-23245-1-git-send-email-jiang.liu@linux.intel.com>
References: <1416894816-23245-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prepare for support hierarchy irqdomain by changing function prototypes,
should be no function changes.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Acked-by: Joerg Roedel <jroedel@suse.de>
---
 drivers/iommu/intel_irq_remapping.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index a55b207b9425..8176b54732e9 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -81,10 +81,10 @@ static int get_irte(int irq, struct irte *entry)
 	return 0;
 }
 
-static int alloc_irte(struct intel_iommu *iommu, int irq, u16 count)
+static int alloc_irte(struct intel_iommu *iommu, int irq,
+		      struct irq_2_iommu *irq_iommu, u16 count)
 {
 	struct ir_table *table = iommu->ir_table;
-	struct irq_2_iommu *irq_iommu = irq_2_iommu(irq);
 	struct irq_cfg *cfg = irq_cfg(irq);
 	unsigned int mask = 0;
 	unsigned long flags;
@@ -172,9 +172,9 @@ static int set_irte_irq(int irq, struct intel_iommu *iommu, u16 index, u16 subha
 	return 0;
 }
 
-static int modify_irte(int irq, struct irte *irte_modified)
+static int modify_irte(struct irq_2_iommu *irq_iommu,
+		       struct irte *irte_modified)
 {
-	struct irq_2_iommu *irq_iommu = irq_2_iommu(irq);
 	struct intel_iommu *iommu;
 	unsigned long flags;
 	struct irte *irte;
@@ -241,7 +241,7 @@ static int clear_entries(struct irq_2_iommu *irq_iommu)
 		return 0;
 
 	iommu = irq_iommu->iommu;
-	index = irq_iommu->irte_index + irq_iommu->sub_handle;
+	index = irq_iommu->irte_index;
 
 	start = iommu->ir_table->base + index;
 	end = start + (1 << irq_iommu->irte_mask);
@@ -979,7 +979,7 @@ static int intel_setup_ioapic_entry(int irq,
 		pr_warn("No mapping iommu for ioapic %d\n", ioapic_id);
 		index = -ENODEV;
 	} else {
-		index = alloc_irte(iommu, irq, 1);
+		index = alloc_irte(iommu, irq, irq_2_iommu(irq), 1);
 		if (index < 0) {
 			pr_warn("Failed to allocate IRTE for ioapic %d\n",
 				ioapic_id);
@@ -995,7 +995,7 @@ static int intel_setup_ioapic_entry(int irq,
 	/* Set source-id of interrupt request */
 	set_ioapic_sid(&irte, ioapic_id);
 
-	modify_irte(irq, &irte);
+	modify_irte(irq_2_iommu(irq), &irte);
 
 	apic_printk(APIC_VERBOSE, KERN_DEBUG "IOAPIC[%d]: "
 		"Set IRTE entry (P:%d FPD:%d Dst_Mode:%d "
@@ -1082,7 +1082,7 @@ intel_ioapic_set_affinity(struct irq_data *data, const struct cpumask *mask,
 	 * Atomically updates the IRTE with the new destination, vector
 	 * and flushes the interrupt entry cache.
 	 */
-	modify_irte(irq, &irte);
+	modify_irte(irq_2_iommu(irq), &irte);
 
 	/*
 	 * After this point, all the interrupts will start arriving
@@ -1118,7 +1118,7 @@ static void intel_compose_msi_msg(struct pci_dev *pdev,
 	else
 		set_hpet_sid(&irte, hpet_id);
 
-	modify_irte(irq, &irte);
+	modify_irte(irq_2_iommu(irq), &irte);
 
 	msg->address_hi = MSI_ADDR_BASE_HI;
 	msg->data = sub_handle;
@@ -1145,7 +1145,7 @@ static int intel_msi_alloc_irq(struct pci_dev *dev, int irq, int nvec)
 		       "Unable to map PCI %s to iommu\n", pci_name(dev));
 		index = -ENOENT;
 	} else {
-		index = alloc_irte(iommu, irq, nvec);
+		index = alloc_irte(iommu, irq, irq_2_iommu(irq), nvec);
 		if (index < 0) {
 			printk(KERN_ERR
 			       "Unable to allocate %d IRTE for PCI %s\n",
@@ -1189,7 +1189,7 @@ static int intel_alloc_hpet_msi(unsigned int irq, unsigned int id)
 	down_read(&dmar_global_lock);
 	iommu = map_hpet_to_ir(id);
 	if (iommu) {
-		index = alloc_irte(iommu, irq, 1);
+		index = alloc_irte(iommu, irq, irq_2_iommu(irq), 1);
 		if (index >= 0)
 			ret = 0;
 	}
-- 
1.7.10.4

