Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757044AbaISGyX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 02:54:23 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:50826 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753AbaISGyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 02:54:21 -0400
Date: Fri, 19 Sep 2014 16:54:12 +1000
From: Gavin Shan <gwshan@linux.vnet.ibm.com>
To: Michael Neuling <mikey@neuling.org>
Cc: greg@kroah.com, arnd@arndb.de, mpe@ellerman.id.au,
        benh@kernel.crashing.org, cbe-oss-dev@lists.ozlabs.org,
        imunsie@au1.ibm.com, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, jk@ozlabs.org, anton@samba.org
Subject: Re: [PATCH 05/15] powerpc/powernv: Split out set MSI IRQ chip code
Message-ID: <20140919065412.GA27190@shangw>
Reply-To: Gavin Shan <gwshan@linux.vnet.ibm.com>
References: <1411028820-29933-1-git-send-email-mikey@neuling.org>
 <1411028820-29933-6-git-send-email-mikey@neuling.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411028820-29933-6-git-send-email-mikey@neuling.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14091906-7014-0000-0000-000000377F7C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 06:26:50PM +1000, Michael Neuling wrote:
>From: Ian Munsie <imunsie@au1.ibm.com>
>
>Some of the MSI IRQ code in pnv_pci_ioda_msi_setup() is generically useful so
>split it out.
>
>This will be used by some of the cxl PCIe code later.
>
>Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
>Signed-off-by: Michael Neuling <mikey@neuling.org>
>---
> arch/powerpc/platforms/powernv/pci-ioda.c | 43 ++++++++++++++++++-------------
> 1 file changed, 25 insertions(+), 18 deletions(-)
>
>diff --git a/arch/powerpc/platforms/powernv/pci-ioda.c b/arch/powerpc/platforms/powernv/pci-ioda.c
>index df241b1..194f90a 100644
>--- a/arch/powerpc/platforms/powernv/pci-ioda.c
>+++ b/arch/powerpc/platforms/powernv/pci-ioda.c
>@@ -1306,14 +1306,36 @@ static void pnv_ioda2_msi_eoi(struct irq_data *d)
> 	icp_native_eoi(d);
> }
> 
>+
>+static void set_msi_irq_chip(struct pnv_phb *phb, unsigned int virq)
>+{
>+	struct irq_data *idata;
>+	struct irq_chip *ichip;
>+
>+	/*
>+	 * Change the IRQ chip for the MSI interrupts on PHB3.
>+	 * The corresponding IRQ chip should be populated for
>+	 * the first time.
>+	 */
>+	if (phb->type == PNV_PHB_IODA2) {
>+		if (!phb->ioda.irq_chip_init) {
>+			idata = irq_get_irq_data(virq);
>+			ichip = irq_data_get_irq_chip(idata);
>+			phb->ioda.irq_chip_init = 1;
>+			phb->ioda.irq_chip = *ichip;
>+			phb->ioda.irq_chip.irq_eoi = pnv_ioda2_msi_eoi;
>+		}
>+
>+		irq_set_chip(virq, &phb->ioda.irq_chip);
>+	}
>+}
>+

Nitpick: to check PHB type and bail early could avoid nested code :)

	if (phb->type != PNV_PHB_IODA2)
		return;

> static int pnv_pci_ioda_msi_setup(struct pnv_phb *phb, struct pci_dev *dev,
> 				  unsigned int hwirq, unsigned int virq,
> 				  unsigned int is_64, struct msi_msg *msg)
> {
> 	struct pnv_ioda_pe *pe = pnv_ioda_get_pe(dev);
> 	struct pci_dn *pdn = pci_get_pdn(dev);
>-	struct irq_data *idata;
>-	struct irq_chip *ichip;
> 	unsigned int xive_num = hwirq - phb->msi_base;
> 	__be32 data;
> 	int rc;
>@@ -1365,22 +1387,7 @@ static int pnv_pci_ioda_msi_setup(struct pnv_phb *phb, struct pci_dev *dev,
> 	}
> 	msg->data = be32_to_cpu(data);
> 
>-	/*
>-	 * Change the IRQ chip for the MSI interrupts on PHB3.
>-	 * The corresponding IRQ chip should be populated for
>-	 * the first time.
>-	 */
>-	if (phb->type == PNV_PHB_IODA2) {
>-		if (!phb->ioda.irq_chip_init) {
>-			idata = irq_get_irq_data(virq);
>-			ichip = irq_data_get_irq_chip(idata);
>-			phb->ioda.irq_chip_init = 1;
>-			phb->ioda.irq_chip = *ichip;
>-			phb->ioda.irq_chip.irq_eoi = pnv_ioda2_msi_eoi;
>-		}
>-
>-		irq_set_chip(virq, &phb->ioda.irq_chip);
>-	}
>+	set_msi_irq_chip(phb, virq);
> 
> 	pr_devel("%s: %s-bit MSI on hwirq %x (xive #%d),"
> 		 " address=%x_%08x data=%x PE# %d\n",

Thanks,
Gavin

