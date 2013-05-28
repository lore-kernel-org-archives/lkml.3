Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758884Ab3E1HTA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 03:19:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11823 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755043Ab3E1HS7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 03:18:59 -0400
Date: Tue, 28 May 2013 09:20:22 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-kernel@vger.kernel.org, Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH] powerpc/pseries: Force 32 bit MSIs when tearing down
Message-ID: <20130528072021.GA10576@dhcp-26-207.brq.redhat.com>
References: <20130527162027.GA18182@dhcp-26-207.brq.redhat.com>
 <1369691531.3557.36.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369691531.3557.36.camel@pasglop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 28, 2013 at 07:52:11AM +1000, Benjamin Herrenschmidt wrote:
> On Mon, 2013-05-27 at 18:20 +0200, Alexander Gordeev wrote:
> > This fix just adds a missed call to a new PAPR function
> > which should have been done with commit e61133d ("powerpc/
> > pseries: Force 32 bit MSIs for devices that require it")
> 
> Arguably, PAPR should allow to disable MSIs using either interface,
> we shouldn't have to know whether the MSI was a forced-32-bit one to be
> able to disable it.

BTW, it is not clear why MSIs do not get disabled on powernv on teardown.
Would this (pseudo-code) make sense?


diff --git a/arch/powerpc/platforms/powernv/pci.c b/arch/powerpc/platforms/powernv/pci.c
index 163bd74..1502c49 100644
--- a/arch/powerpc/platforms/powernv/pci.c
+++ b/arch/powerpc/platforms/powernv/pci.c
@@ -102,6 +102,7 @@ static void pnv_teardown_msi_irqs(struct pci_dev *pdev)
 	struct pci_controller *hose = pci_bus_to_host(pdev->bus);
 	struct pnv_phb *phb = hose->private_data;
 	struct msi_desc *entry;
+	unsigned int hwirq;
 
 	if (WARN_ON(!phb))
 		return;
@@ -109,10 +110,15 @@ static void pnv_teardown_msi_irqs(struct pci_dev *pdev)
 	list_for_each_entry(entry, &pdev->msi_list, list) {
 		if (entry->irq == NO_IRQ)
 			continue;
+
 		irq_set_msi_desc(entry->irq, NULL);
+		hwirq = virq_to_hw(entry->irq);
 		msi_bitmap_free_hwirqs(&phb->msi_bmp,
-			virq_to_hw(entry->irq) - phb->msi_base, 1);
+			hwirq - phb->msi_base, 1);
 		irq_dispose_mapping(entry->irq);
+		if (phb->msi_disable)
+			phb->msi_disable(phb, pdev, hwirq,
+					 entry->msi_attrib.is_64);
 	}
 }
 #endif /* CONFIG_PCI_MSI */
diff --git a/arch/powerpc/platforms/powernv/pci.h b/arch/powerpc/platforms/powernv/pci.h
index 25d76c4..049cbd3 100644
--- a/arch/powerpc/platforms/powernv/pci.h
+++ b/arch/powerpc/platforms/powernv/pci.h
@@ -79,10 +79,13 @@ struct pnv_phb {
 	unsigned int		msi_base;
 	unsigned int		msi32_support;
 	struct msi_bitmap	msi_bmp;
-#endif
+
 	int (*msi_setup)(struct pnv_phb *phb, struct pci_dev *dev,
 			 unsigned int hwirq, unsigned int virq,
 			 unsigned int is_64, struct msi_msg *msg);
+	int (*msi_disable)(struct pnv_phb *phb, struct pci_dev *dev,
+			   unsigned int hwirq, unsigned int is_64);
+#endif
 	void (*dma_dev_setup)(struct pnv_phb *phb, struct pci_dev *pdev);
 	void (*fixup_phb)(struct pci_controller *hose);
 	u32 (*bdfn_to_pe)(struct pnv_phb *phb, struct pci_bus *bus, u32 devfn);

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
