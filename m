Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457AbaIKIXv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 04:23:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:19478 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753419AbaIKIXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 04:23:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,504,1406617200"; 
   d="scan'208";a="571629364"
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
Subject: [RFC Part1 v1 17/18] iommu/vt-d: Use helpers to access irq_cfg data structure associated with IRQ
Date: Thu, 11 Sep 2014 16:25:04 +0800
Message-Id: <1410423905-26239-18-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1410423905-26239-1-git-send-email-jiang.liu@linux.intel.com>
References: <1410423905-26239-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use helpers to access irq_cfg data structure associated with IRQ,
instead of accessing irq_data->chip_data directly. Later we could
rewrite those helpers to support hierarchy irqdomain.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/iommu/intel_irq_remapping.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index 0df41f6264f5..319b39edcf7e 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -55,7 +55,7 @@ static int __init parse_ioapics_under_ir(void);
 
 static struct irq_2_iommu *irq_2_iommu(unsigned int irq)
 {
-	struct irq_cfg *cfg = irq_get_chip_data(irq);
+	struct irq_cfg *cfg = irq_cfg(irq);
 	return cfg ? &cfg->irq_2_iommu : NULL;
 }
 
@@ -86,7 +86,7 @@ static int alloc_irte(struct intel_iommu *iommu, int irq, u16 count)
 {
 	struct ir_table *table = iommu->ir_table;
 	struct irq_2_iommu *irq_iommu = irq_2_iommu(irq);
-	struct irq_cfg *cfg = irq_get_chip_data(irq);
+	struct irq_cfg *cfg = irq_cfg(irq);
 	unsigned int mask = 0;
 	unsigned long flags;
 	int index;
@@ -154,7 +154,7 @@ static int map_irq_to_irte_handle(int irq, u16 *sub_handle)
 static int set_irte_irq(int irq, struct intel_iommu *iommu, u16 index, u16 subhandle)
 {
 	struct irq_2_iommu *irq_iommu = irq_2_iommu(irq);
-	struct irq_cfg *cfg = irq_get_chip_data(irq);
+	struct irq_cfg *cfg = irq_cfg(irq);
 	unsigned long flags;
 
 	if (!irq_iommu)
@@ -1009,7 +1009,7 @@ static int
 intel_ioapic_set_affinity(struct irq_data *data, const struct cpumask *mask,
 			  bool force)
 {
-	struct irq_cfg *cfg = data->chip_data;
+	struct irq_cfg *cfg = irqd_cfg(data);
 	unsigned int dest, irq = data->irq;
 	struct irte irte;
 	int err;
@@ -1064,7 +1064,7 @@ static void intel_compose_msi_msg(struct pci_dev *pdev,
 	u16 sub_handle = 0;
 	int ir_index;
 
-	cfg = irq_get_chip_data(irq);
+	cfg = irq_cfg(irq);
 
 	ir_index = map_irq_to_irte_handle(irq, &sub_handle);
 	BUG_ON(ir_index == -1);
-- 
1.7.10.4

