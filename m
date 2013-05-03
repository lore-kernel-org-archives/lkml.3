Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762547Ab3ECHLr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 03:11:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21113 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752404Ab3ECHLq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 03:11:46 -0400
Date: Fri, 3 May 2013 09:12:59 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Joerg Roedel <joro@8bytes.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, linux-pci@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>, Jan Beulich <JBeulich@suse.com>,
        Ingo Molnar <mingo@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH v3 -tip/apic 2/2] x86/MSI: Conserve interrupt resources when
 using multiple-MSIs
Message-ID: <20130503071259.GA12749@dhcp-26-207.brq.redhat.com>
References: <cover.1367319112.git.agordeev@redhat.com>
 <096b258a86c1cb46e4f3084f1fbcf37c7859bb15.1367319112.git.agordeev@redhat.com>
 <20130502123631.GB24440@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130502123631.GB24440@8bytes.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current multiple-MSI implementation does not take into account
actual number of requested MSIs and always rounds that number
to a closest power-of-two value. Yet, a number of MSIs a PCI
device could send (and therefore a number of messages a device
driver could request) may be a lesser power-of-two. As result,
resources allocated for extra MSIs just wasted.

This update takes advantage of 'msi_desc::nvec' field introduced
with generic MSI code to track number of requested and used MSIs.
As result, resources associated with interrupts are conserved.
Of those resources most noticeable are x86 interrupt vectors.

The initial version of this fix also consumed on IRTEs, but Jan
noticed that a malfunctioning PCI device might send a message
number it did not claim and thus refer an IRTE it does not own.
To avoid this security hole the old-way approach preserved and
as many IRTEs are reserved as the device could possibly send.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 drivers/iommu/irq_remapping.c |   12 +++++++-----
 1 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index d56f8c1..9eeb6cf 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -51,26 +51,27 @@ static void irq_remapping_disable_io_apic(void)
 
 static int do_setup_msi_irqs(struct pci_dev *dev, int nvec)
 {
-	int node, ret, sub_handle, index = 0;
+	int node, ret, sub_handle, nvec_pow2, index = 0;
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
+	nvec_pow2 = __roundup_pow_of_two(nvec);
+	msidesc->nvec = nvec;
+	msidesc->msi_attrib.multiple = ilog2(nvec_pow2);
 	for (sub_handle = 0; sub_handle < nvec; sub_handle++) {
 		if (!sub_handle) {
-			index = msi_alloc_remapped_irq(dev, irq, nvec);
+			index = msi_alloc_remapped_irq(dev, irq, nvec_pow2);
 			if (index < 0) {
 				ret = index;
 				goto error;
@@ -95,6 +96,7 @@ error:
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
