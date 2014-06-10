Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964931AbaFJHcr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 03:32:47 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:45690 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964907AbaFJHcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 03:32:45 -0400
From: Zhouyi Zhou <zhouzhouyi@gmail.com>
To: <benh@kernel.crashing.org>, <paulus@samba.org>, <aik@ozlabs.ru>,
        <anton@samba.org>, <nacc@linux.vnet.ibm.com>, <alistair@popple.id.au>,
        <deepthi@linux.vnet.ibm.com>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Cc: Zhouyi Zhou <zhouzhouyi@gmail.com>, Zhouyi Zhou <yizhouzhou@ict.ac.cn>
Subject: [PATCH 1/1] powerpc/iommu: Handling null return of kzalloc_node
Date: Tue, 10 Jun 2014 15:32:10 +0800
Message-Id: <1402385530-23091-1-git-send-email-zhouzhouyi@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NULL return of kzalloc_node should be handled 

Signed-off-by: Zhouyi Zhou <yizhouzhou@ict.ac.cn>
---
 arch/powerpc/platforms/pseries/iommu.c |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/iommu.c b/arch/powerpc/platforms/pseries/iommu.c
index 33b552f..593cd3d 100644
--- a/arch/powerpc/platforms/pseries/iommu.c
+++ b/arch/powerpc/platforms/pseries/iommu.c
@@ -613,7 +613,11 @@ static void pci_dma_bus_setup_pSeries(struct pci_bus *bus)
 
 	tbl = kzalloc_node(sizeof(struct iommu_table), GFP_KERNEL,
 			   pci->phb->node);
-
+	if (!tbl) {
+		pr_debug(" out of memory, can't create iommu_table !\n");
+		return;
+	}
+
 	iommu_table_setparms(pci->phb, dn, tbl);
 	pci->iommu_table = iommu_init_table(tbl, pci->phb->node);
 	iommu_register_group(tbl, pci_domain_nr(bus), 0);
@@ -659,6 +663,10 @@ static void pci_dma_bus_setup_pSeriesLP(struct pci_bus *bus)
 	if (!ppci->iommu_table) {
 		tbl = kzalloc_node(sizeof(struct iommu_table), GFP_KERNEL,
 				   ppci->phb->node);
+		if (!tbl) {
+			pr_debug(" out of memory, can't create iommu_table !\n");
+			return;
+		}
 		iommu_table_setparms_lpar(ppci->phb, pdn, tbl, dma_window);
 		ppci->iommu_table = iommu_init_table(tbl, ppci->phb->node);
 		iommu_register_group(tbl, pci_domain_nr(bus), 0);
@@ -686,6 +694,11 @@ static void pci_dma_dev_setup_pSeries(struct pci_dev *dev)
 		pr_debug(" --> first child, no bridge. Allocating iommu table.\n");
 		tbl = kzalloc_node(sizeof(struct iommu_table), GFP_KERNEL,
 				   phb->node);
+		if (!tbl) {
+			pr_debug(" out of memory, can't create iommu_table !\n");
+			return;
+		}
+
 		iommu_table_setparms(phb, dn, tbl);
 		PCI_DN(dn)->iommu_table = iommu_init_table(tbl, phb->node);
 		iommu_register_group(tbl, pci_domain_nr(phb->bus), 0);
@@ -1102,6 +1116,10 @@ static void pci_dma_dev_setup_pSeriesLP(struct pci_dev *dev)
 	if (!pci->iommu_table) {
 		tbl = kzalloc_node(sizeof(struct iommu_table), GFP_KERNEL,
 				   pci->phb->node);
+		if (!tbl) {
+			pr_debug(" out of memory, can't create iommu_table !\n");
+			return;
+		}
 		iommu_table_setparms_lpar(pci->phb, pdn, tbl, dma_window);
 		pci->iommu_table = iommu_init_table(tbl, pci->phb->node);
 		iommu_register_group(tbl, pci_domain_nr(pci->phb->bus), 0);
-- 
1.7.10.4

