Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017AbaI3KjN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 06:39:13 -0400
Received: from ozlabs.org ([103.22.144.67]:49609 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751696AbaI3Kfk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 06:35:40 -0400
From: Michael Neuling <mikey@neuling.org>
To: greg@kroah.com, arnd@arndb.de, mpe@ellerman.id.au,
        benh@kernel.crashing.org
Cc: mikey@neuling.org, anton@samba.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, jk@ozlabs.org, imunsie@au.ibm.com,
        cbe-oss-dev@lists.ozlabs.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH v2 06/17] powerpc/powernv: Split out set MSI IRQ chip code
Date: Tue, 30 Sep 2014 20:34:55 +1000
Message-Id: <1412073306-13812-7-git-send-email-mikey@neuling.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412073306-13812-1-git-send-email-mikey@neuling.org>
References: <1412073306-13812-1-git-send-email-mikey@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

Some of the MSI IRQ code in pnv_pci_ioda_msi_setup() is generically useful so
split it out.

This will be used by some of the cxl PCIe code later.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
Signed-off-by: Michael Neuling <mikey@neuling.org>
---
 arch/powerpc/platforms/powernv/pci-ioda.c | 43 ++++++++++++++++++-------------
 1 file changed, 25 insertions(+), 18 deletions(-)

diff --git a/arch/powerpc/platforms/powernv/pci-ioda.c b/arch/powerpc/platforms/powernv/pci-ioda.c
index df241b1..329164f 100644
--- a/arch/powerpc/platforms/powernv/pci-ioda.c
+++ b/arch/powerpc/platforms/powernv/pci-ioda.c
@@ -1306,14 +1306,36 @@ static void pnv_ioda2_msi_eoi(struct irq_data *d)
 	icp_native_eoi(d);
 }
 
+
+static void set_msi_irq_chip(struct pnv_phb *phb, unsigned int virq)
+{
+	struct irq_data *idata;
+	struct irq_chip *ichip;
+
+	if (phb->type != PNV_PHB_IODA2)
+		return;
+
+	/*
+	 * Change the IRQ chip for the MSI interrupts on PHB3.
+	 * The corresponding IRQ chip should be populated for
+	 * the first time.
+	 */
+	if (!phb->ioda.irq_chip_init) {
+		idata = irq_get_irq_data(virq);
+		ichip = irq_data_get_irq_chip(idata);
+		phb->ioda.irq_chip_init = 1;
+		phb->ioda.irq_chip = *ichip;
+		phb->ioda.irq_chip.irq_eoi = pnv_ioda2_msi_eoi;
+	}
+	irq_set_chip(virq, &phb->ioda.irq_chip);
+}
+
 static int pnv_pci_ioda_msi_setup(struct pnv_phb *phb, struct pci_dev *dev,
 				  unsigned int hwirq, unsigned int virq,
 				  unsigned int is_64, struct msi_msg *msg)
 {
 	struct pnv_ioda_pe *pe = pnv_ioda_get_pe(dev);
 	struct pci_dn *pdn = pci_get_pdn(dev);
-	struct irq_data *idata;
-	struct irq_chip *ichip;
 	unsigned int xive_num = hwirq - phb->msi_base;
 	__be32 data;
 	int rc;
@@ -1365,22 +1387,7 @@ static int pnv_pci_ioda_msi_setup(struct pnv_phb *phb, struct pci_dev *dev,
 	}
 	msg->data = be32_to_cpu(data);
 
-	/*
-	 * Change the IRQ chip for the MSI interrupts on PHB3.
-	 * The corresponding IRQ chip should be populated for
-	 * the first time.
-	 */
-	if (phb->type == PNV_PHB_IODA2) {
-		if (!phb->ioda.irq_chip_init) {
-			idata = irq_get_irq_data(virq);
-			ichip = irq_data_get_irq_chip(idata);
-			phb->ioda.irq_chip_init = 1;
-			phb->ioda.irq_chip = *ichip;
-			phb->ioda.irq_chip.irq_eoi = pnv_ioda2_msi_eoi;
-		}
-
-		irq_set_chip(virq, &phb->ioda.irq_chip);
-	}
+	set_msi_irq_chip(phb, virq);
 
 	pr_devel("%s: %s-bit MSI on hwirq %x (xive #%d),"
 		 " address=%x_%08x data=%x PE# %d\n",
-- 
1.9.1

