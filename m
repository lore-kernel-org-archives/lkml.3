Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933614AbaEGPqz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 11:46:55 -0400
Received: from www.linutronix.de ([62.245.132.108]:48653 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756903AbaEGPoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 11:44:04 -0400
Message-Id: <20140507154339.409085048@linutronix.de>
User-Agent: quilt/0.60-1
Date: Wed, 07 May 2014 15:44:19 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Anvin <hpa@zytor.com>,
        Tony Luck <tony.luck@intel.com>, Peter Zijlstra <peterz@infradead.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [patch 25/32] s390: pci: Check return value of alloc_irq_desc() proper
References: <20140507153622.703412101@linutronix.de>
Content-Disposition: inline; filename=s390-pci-check-alloc-irq-proper.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

alloc_irq_desc() returns an integer and as documented either a valid
irq number or a negative error code. Checking for NO_IRQ is definitely
not the proper error handling.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux390@de.ibm.com
---
 arch/s390/pci/pci.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: tip/arch/s390/pci/pci.c
===================================================================
--- tip.orig/arch/s390/pci/pci.c
+++ tip/arch/s390/pci/pci.c
@@ -401,11 +401,11 @@ static void zpci_irq_handler(struct airq
 int arch_setup_msi_irqs(struct pci_dev *pdev, int nvec, int type)
 {
 	struct zpci_dev *zdev = get_zdev(pdev);
-	unsigned int hwirq, irq, msi_vecs;
+	unsigned int hwirq, msi_vecs;
 	unsigned long aisb;
 	struct msi_desc *msi;
 	struct msi_msg msg;
-	int rc;
+	int rc, irq;
 
 	if (type == PCI_CAP_ID_MSI && nvec > 1)
 		return 1;
@@ -433,7 +433,7 @@ int arch_setup_msi_irqs(struct pci_dev *
 	list_for_each_entry(msi, &pdev->msi_list, list) {
 		rc = -EIO;
 		irq = irq_alloc_desc(0);	/* Alloc irq on node 0 */
-		if (irq == NO_IRQ)
+		if (irq < 0)
 			goto out_msi;
 		rc = irq_set_msi_desc(irq, msi);
 		if (rc)


