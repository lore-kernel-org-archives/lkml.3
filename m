Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754990AbaIZO4o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 10:56:44 -0400
Received: from mga11.intel.com ([192.55.52.93]:27175 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754881AbaIZO4l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 10:56:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,604,1406617200"; 
   d="scan'208";a="597292401"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [RFC v1 17/28] x86, irq: Kill irq_cfg.irq_remapped
Date: Fri, 26 Sep 2014 22:57:47 +0800
Message-Id: <1411743478-31435-18-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1411743478-31435-1-git-send-email-jiang.liu@linux.intel.com>
References: <1411743478-31435-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now there is no user of irq_cfg.irq_remapped, so kill it.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/include/asm/hw_irq.h       |    1 -
 drivers/iommu/amd_iommu.c           |    1 -
 drivers/iommu/intel_irq_remapping.c |    2 --
 3 files changed, 4 deletions(-)

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index ceb0244c3454..990e255ea5d5 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -185,7 +185,6 @@ struct irq_cfg {
 	u8			vector;
 	u8			move_in_progress : 1;
 #ifdef CONFIG_IRQ_REMAP
-	u8			remapped : 1;
 	union {
 		struct irq_2_iommu irq_2_iommu;
 		struct irq_2_irte  irq_2_irte;
diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 21f8edcc0635..28d1cd404ff1 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -4132,7 +4132,6 @@ static void irq_remapping_prepare_irte(struct amd_ir_data *data,
 	struct IR_IO_APIC_route_entry *entry = &data->ioapic_entry;
 	struct msi_msg *msg = &data->msi_entry;
 
-	irq_cfg->remapped = 1;
 	data->irq_2_irte.devid = devid;
 	data->irq_2_irte.index = index + sub_handle;
 
diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index 41ece6b0564e..5c77d6f04136 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -68,7 +68,6 @@ static int alloc_irte(struct intel_iommu *iommu, int irq,
 		      struct irq_2_iommu *irq_iommu, u16 count)
 {
 	struct ir_table *table = iommu->ir_table;
-	struct irq_cfg *cfg = irq_cfg(irq);
 	unsigned int mask = 0;
 	unsigned long flags;
 	int index;
@@ -95,7 +94,6 @@ static int alloc_irte(struct intel_iommu *iommu, int irq,
 	if (index < 0) {
 		pr_warn("IR%d: can't allocate an IRTE\n", iommu->seq_id);
 	} else {
-		cfg->remapped = 1;
 		irq_iommu->iommu = iommu;
 		irq_iommu->irte_index =  index;
 		irq_iommu->sub_handle = 0;
-- 
1.7.10.4

