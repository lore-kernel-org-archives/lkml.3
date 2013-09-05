Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965259Ab3IEMv3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 08:51:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57022 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763374Ab3IEMv1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 08:51:27 -0400
Date: Thu, 5 Sep 2013 14:53:19 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, linux-pci@vger.kernel.org, linux-ide@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Joerg Roedel <joro@8bytes.org>, Jan Beulich <JBeulich@suse.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH v2 3/6] MSI/x86: Support pci_enable_msi_block_part() interface
Message-ID: <1519938bbcfd083c0e091e5ac69b573c39664e40.1378383792.git.agordeev@redhat.com>
References: <cover.1378383792.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1378383792.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change is a prerequisite for the forthcoming update
of the AHCI device driver to conserve 10/16 MSIs on Intel
chipsets. The update makes use of 'nvec_mme' parameter
for pci_enable_msi_block_part() interface.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/iommu/irq_remapping.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index 1a220a0..7671da3 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -49,9 +49,9 @@ static void irq_remapping_disable_io_apic(void)
 		disconnect_bsp_APIC(0);
 }
 
-static int do_setup_msi_irqs(struct pci_dev *dev, int nvec)
+static int do_setup_msi_irqs(struct pci_dev *dev, int nvec, int nvec_mme)
 {
-	int node, ret, sub_handle, nvec_pow2, index = 0;
+	int node, ret, sub_handle, index = 0;
 	unsigned int irq;
 	struct msi_desc *msidesc;
 
@@ -60,18 +60,18 @@ static int do_setup_msi_irqs(struct pci_dev *dev, int nvec)
 	WARN_ON(msidesc->irq);
 	WARN_ON(msidesc->msi_attrib.multiple);
 	WARN_ON(msidesc->nvec_used);
+	BUG_ON(!is_power_of_2(nvec_mme));
 
 	node = dev_to_node(&dev->dev);
 	irq = __create_irqs(get_nr_irqs_gsi(), nvec, node);
 	if (irq == 0)
 		return -ENOSPC;
 
-	nvec_pow2 = __roundup_pow_of_two(nvec);
 	msidesc->nvec_used = nvec;
-	msidesc->msi_attrib.multiple = ilog2(nvec_pow2);
+	msidesc->msi_attrib.multiple = ilog2(nvec_mme);
 	for (sub_handle = 0; sub_handle < nvec; sub_handle++) {
 		if (!sub_handle) {
-			index = msi_alloc_remapped_irq(dev, irq, nvec_pow2);
+			index = msi_alloc_remapped_irq(dev, irq, nvec_mme);
 			if (index < 0) {
 				ret = index;
 				goto error;
@@ -145,7 +145,7 @@ static int irq_remapping_setup_msi_irqs(struct pci_dev *dev,
 					int nvec, int nvec_mme, int type)
 {
 	if (type == PCI_CAP_ID_MSI)
-		return do_setup_msi_irqs(dev, nvec);
+		return do_setup_msi_irqs(dev, nvec, nvec_mme);
 	else
 		return do_setup_msix_irqs(dev, nvec);
 }
-- 
1.7.7.6


-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
