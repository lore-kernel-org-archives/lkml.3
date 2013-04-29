Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752289Ab3D2EcB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 00:32:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40698 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752119Ab3D2Eb7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 00:31:59 -0400
Date: Mon, 29 Apr 2013 06:33:11 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, linux-pci@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Joerg Roedel <joro@8bytes.org>,
        Jan Beulich <JBeulich@suse.com>, Ingo Molnar <mingo@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH -tip/apic 2/2] x86/MSI: Allocate as many multiple-MSIs as
 requested
Message-ID: <eb84d5e5d4af81aa38832c21e49d3276f780a048.1367160713.git.agordeev@redhat.com>
References: <cover.1367160713.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1367160713.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/iommu/irq_remapping.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index d56f8c1..315c563 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -55,19 +55,19 @@ static int do_setup_msi_irqs(struct pci_dev *dev, int nvec)
 	unsigned int irq;
 	struct msi_desc *msidesc;
 
-	nvec = __roundup_pow_of_two(nvec);
-
 	WARN_ON(!list_is_singular(&dev->msi_list));
 	msidesc = list_entry(dev->msi_list.next, struct msi_desc, list);
 	WARN_ON(msidesc->irq);
 	WARN_ON(msidesc->msi_attrib.multiple);
+	WARN_ON(msidesc->nvec);
 
 	node = dev_to_node(&dev->dev);
 	irq = __create_irqs(get_nr_irqs_gsi(), nvec, node);
 	if (irq == 0)
 		return -ENOSPC;
 
-	msidesc->msi_attrib.multiple = ilog2(nvec);
+	msidesc->nvec = nvec;
+	msidesc->msi_attrib.multiple = ilog2(__roundup_pow_of_two(nvec));
 	for (sub_handle = 0; sub_handle < nvec; sub_handle++) {
 		if (!sub_handle) {
 			index = msi_alloc_remapped_irq(dev, irq, nvec);
@@ -95,6 +95,7 @@ error:
 	 * IRQs from tearing down again in default_teardown_msi_irqs()
 	 */
 	msidesc->irq = 0;
+	msidesc->nvec = 0;
 	msidesc->msi_attrib.multiple = 0;
 
 	return ret;
-- 
1.7.7.6


-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
