Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756567Ab3AOHjQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 02:39:16 -0500
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:58761 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644Ab3AOHjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 02:39:14 -0500
From: Mike Qiu <qiudayu@linux.vnet.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Cc: benh@kernel.crashing.org, tglx@linutronix.de,
        Mike Qiu <qiudayu@linux.vnet.ibm.com>
Subject: [PATCH 3/3] powerpc/pci: Enable pSeries multiple MSI feature
Date: Tue, 15 Jan 2013 15:38:56 +0800
Message-Id: <1358235536-32741-4-git-send-email-qiudayu@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1358235536-32741-1-git-send-email-qiudayu@linux.vnet.ibm.com>
References: <1358235536-32741-1-git-send-email-qiudayu@linux.vnet.ibm.com>
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011507-6102-0000-0000-000002DAFE93
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PCI devices support MSI, MSIX as well as multiple MSI.
But pSeries does not support multiple MSI yet.

This patch enable multiple MSI feature in pSeries.

Signed-off-by: Mike Qiu <qiudayu@linux.vnet.ibm.com>
---
 arch/powerpc/kernel/msi.c            |    4 --
 arch/powerpc/platforms/pseries/msi.c |   62 ++++++++++++++++++++++++++++++++-
 2 files changed, 60 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/kernel/msi.c b/arch/powerpc/kernel/msi.c
index 8bbc12d..46b1470 100644
--- a/arch/powerpc/kernel/msi.c
+++ b/arch/powerpc/kernel/msi.c
@@ -20,10 +20,6 @@ int arch_msi_check_device(struct pci_dev* dev, int nvec, int type)
 		return -ENOSYS;
 	}
 
-	/* PowerPC doesn't support multiple MSI yet */
-	if (type == PCI_CAP_ID_MSI && nvec > 1)
-		return 1;
-
 	if (ppc_md.msi_check_device) {
 		pr_debug("msi: Using platform check routine.\n");
 		return ppc_md.msi_check_device(dev, nvec, type);
diff --git a/arch/powerpc/platforms/pseries/msi.c b/arch/powerpc/platforms/pseries/msi.c
index e5b0847..6633b18 100644
--- a/arch/powerpc/platforms/pseries/msi.c
+++ b/arch/powerpc/platforms/pseries/msi.c
@@ -132,13 +132,17 @@ static int rtas_query_irq_number(struct pci_dn *pdn, int offset)
 static void rtas_teardown_msi_irqs(struct pci_dev *pdev)
 {
 	struct msi_desc *entry;
+	int nvec, i;
 
 	list_for_each_entry(entry, &pdev->msi_list, list) {
 		if (entry->irq == NO_IRQ)
 			continue;
 
 		irq_set_msi_desc(entry->irq, NULL);
-		irq_dispose_mapping(entry->irq);
+		nvec = entry->msi_attrib.is_msix ? 1 : 1 <<
+					entry->msi_attrib.multiple;
+		for (i = 0; i < nvec; i++)
+			irq_dispose_mapping(entry->irq + i);
 	}
 
 	rtas_disable_msi(pdev);
@@ -392,6 +396,55 @@ static int check_msix_entries(struct pci_dev *pdev)
 	return 0;
 }
 
+static int setup_multiple_msi_irqs(struct pci_dev *pdev, int nvec)
+{
+	struct pci_dn *pdn;
+	int hwirq, virq_base, i, hwirq_base = 0;
+	struct msi_desc *entry;
+	struct msi_msg msg;
+
+	pdn = get_pdn(pdev);
+	entry = list_entry(pdev->msi_list.next, typeof(*entry), list);
+
+	/*
+	 * Get the hardware IRQ base and ensure the retrieved
+	 * hardware IRQs are continuous
+	 */
+	for (i = 0; i < nvec; i++) {
+		hwirq = rtas_query_irq_number(pdn, i);
+		if (i == 0)
+			hwirq_base = hwirq;
+
+		if (hwirq < 0 || hwirq != (hwirq_base + i)) {
+			pr_debug("rtas_msi: Failure to get %d IRQs on"
+				"PCI device %04x:%02x:%02x.%01x\n", nvec,
+				pci_domain_nr(pdev->bus), pdev->bus->number,
+				PCI_SLOT(pdev->devfn), PCI_FUNC(pdev->devfn));
+			return hwirq;
+		}
+	}
+
+	virq_base = irq_create_mapping_many(NULL, hwirq_base, nvec);
+	if (virq_base <= 0) {
+		pr_debug("rtas_msi: Failure to map IRQs (%d, %d) "
+			"for PCI device %04x:%02x:%02x.%01x\n",
+			hwirq_base, nvec, pci_domain_nr(pdev->bus),
+			pdev->bus->number, PCI_SLOT(pdev->devfn),
+			PCI_FUNC(pdev->devfn));
+		return -ENOSPC;
+	}
+
+	entry->msi_attrib.multiple = ilog2(nvec & 0x3f);
+	irq_set_multiple_msi_desc(virq_base, nvec, entry);
+	for (i = 0; i < nvec; i++) {
+		/* Read config space back so we can restore after reset */
+		read_msi_msg(virq_base + i, &msg);
+		entry->msg = msg;
+	}
+
+	return 0;
+}
+
 static int rtas_setup_msi_irqs(struct pci_dev *pdev, int nvec_in, int type)
 {
 	struct pci_dn *pdn;
@@ -444,11 +497,16 @@ again:
 		return rc;
 	}
 
+	if (type == PCI_CAP_ID_MSI && nvec > 1) {
+		rc = setup_multiple_msi_irqs(pdev, nvec);
+		return rc;
+	}
+
 	i = 0;
 	list_for_each_entry(entry, &pdev->msi_list, list) {
 		hwirq = rtas_query_irq_number(pdn, i++);
 		if (hwirq < 0) {
-			pr_debug("rtas_msi: error (%d) getting hwirq\n", rc);
+			pr_debug("rtas_msi: error (%d) getting hwirq\n", nvec);
 			return hwirq;
 		}
 
-- 
1.7.7.6

