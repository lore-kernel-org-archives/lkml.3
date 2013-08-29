Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151Ab3H2Cwc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 22:52:32 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:20390 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751772Ab3H2Cwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 22:52:30 -0400
Message-ID: <521EB76B.8090903@oracle.com>
Date: Thu, 29 Aug 2013 10:52:27 +0800
From: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Reply-To: zhenzhong.duan@oracle.com
Organization: oracle
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        xen-devel <xen-devel@lists.xen.org>
CC: Bjorn Helgaas <bhelgaas@google.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Feng Jin <joe.jin@oracle.com>,
        Sucheta Chakraborty <sucheta.chakraborty@qlogic.com>
Subject: [PATCH 2/3 v3] Refactor MSI restore call-chain to drop unnecessary
 argument
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Driver init call graph under baremetal:
driver_init->
    msix_capability_init->
        msix_program_entries->
            msix_mask_irq->
                entry->masked = 1
    request_irq->
        __setup_irq->
            irq_startup->
                unmask_msi_irq->
                    msix_mask_irq->
                        entry->masked = 0

So entry->masked is always updated with newest value and its value could be used
to restore to mask register in device.

But in initial domain (aka priviliged guest), it's different.
Driver init call graph under initial domain:
driver_init->
    msix_capability_init->
        msix_program_entries->
            msix_mask_irq->
                entry->masked = 1
    request_irq->
        __setup_irq->
            irq_startup->
                __startup_pirq->
                    EVTCHNOP_bind_pirq hypercall    (trap into Xen)
[Xen:]
pirq_guest_bind->
    startup_msi_irq->
        unmask_msi_irq->
            msi_set_mask_bit->
                entry->msi_attrib.masked = 0

So entry->msi_attrib.masked in xen side always has newest value. entry->masked
in initial domain is untouched and is 1 after msix_capability_init.

Based on above, it's Xen's duty to restore entry->msi_attrib.masked to device,
but with current code, entry->masked is used and MSI-x interrupt is masked.

Before patch, restore call graph under initial domain:
pci_reset_function->
    pci_restore_state->
        __pci_restore_msix_state->
            arch_restore_msi_irqs->
                xen_initdom_restore_msi_irqs->
                    PHYSDEVOP_restore_msi hypercall (first mask restore)
            msix_mask_irq(entry, entry->masked)     (second mask restore)

So msix_mask_irq call in initial domain call graph needs to be removed.

Based on this we can move the restore of the mask in default_restore_msi_irqs
which would avoid restoring the invalid mask under Xen. Furthermore this
simplifies the API by making everything related to restoring an MSI be in the
platform specific APIs instead of just parts of it.

After patch, restore call graph under initial domain:
pci_reset_function->
    pci_restore_state->
        __pci_restore_msix_state->
            arch_restore_msi_irqs->
                xen_initdom_restore_msi_irqs->
                    PHYSDEVOP_restore_msi hypercall (first mask restore)

Logic for baremetal is not changed.
Before patch, restore call graph under baremetal:
pci_reset_function->
    pci_restore_state->
        __pci_restore_msix_state->
            arch_restore_msi_irqs->
                default_restore_msi_irqs->
            msix_mask_irq(entry, entry->masked)     (first mask restore)

After patch, restore call graph under baremetal:
pci_reset_function->
    pci_restore_state->
        __pci_restore_msix_state->
            arch_restore_msi_irqs->
                default_restore_msi_irqs->
                    msix_mask_irq(entry, entry->masked) (first mask restore)

The process for MSI code is similiar.

-v3: Update patch description per Konrad suggestion, thanks.

Tested-by: Sucheta Chakraborty <sucheta.chakraborty@qlogic.com>
Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
---
 drivers/pci/msi.c |   17 ++++++++++++++---
 1 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 87223ae..922fb49 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -216,6 +216,8 @@ void unmask_msi_irq(struct irq_data *data)
 #ifdef HAVE_DEFAULT_MSI_RESTORE_IRQS
 void default_restore_msi_irqs(struct pci_dev *dev, int irq)
 {
+	int pos;
+	u16 control;
 	struct msi_desc *entry;
 
 	entry = NULL;
@@ -228,8 +230,19 @@ void default_restore_msi_irqs(struct pci_dev *dev, int irq)
 		entry = irq_get_msi_desc(irq);
 	}
 
-	if (entry)
+	if (entry) {
 		write_msi_msg(irq, &entry->msg);
+		if (dev->msix_enabled) {
+			msix_mask_irq(entry, entry->masked);
+			readl(entry->mask_base);
+		} else {
+			pos = entry->msi_attrib.pos;
+			pci_read_config_word(dev, pos + PCI_MSI_FLAGS,
+					     &control);
+			msi_mask_irq(entry, msi_capable_mask(control),
+				     entry->masked);
+		}
+	}
 }
 #endif
 
@@ -406,7 +419,6 @@ static void __pci_restore_msi_state(struct pci_dev *dev)
 	arch_restore_msi_irqs(dev, dev->irq);
 
 	pci_read_config_word(dev, dev->msi_cap + PCI_MSI_FLAGS, &control);
-	msi_mask_irq(entry, msi_capable_mask(control), entry->masked);
 	control &= ~PCI_MSI_FLAGS_QSIZE;
 	control |= (entry->msi_attrib.multiple << 4) | PCI_MSI_FLAGS_ENABLE;
 	pci_write_config_word(dev, dev->msi_cap + PCI_MSI_FLAGS, control);
@@ -430,7 +442,6 @@ static void __pci_restore_msix_state(struct pci_dev *dev)
 
 	list_for_each_entry(entry, &dev->msi_list, list) {
 		arch_restore_msi_irqs(dev, entry->irq);
-		msix_mask_irq(entry, entry->masked);
 	}
 
 	control &= ~PCI_MSIX_FLAGS_MASKALL;
-- 
1.7.3

