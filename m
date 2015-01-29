Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761314AbbA2JW0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:22:26 -0500
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:37566 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759676AbbA2JWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:22:21 -0500
From: Alexey Kardashevskiy <aik@ozlabs.ru>
To: linuxppc-dev@lists.ozlabs.org
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Gavin Shan <gwshan@linux.vnet.ibm.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Alexander Graf <agraf@suse.de>,
        Alexander Gordeev <agordeev@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH v3 03/24] powerpc/powernv: Do not set "read" flag if direction==DMA_NONE
Date: Thu, 29 Jan 2015 20:21:44 +1100
Message-Id: <1422523325-1389-4-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1422523325-1389-1-git-send-email-aik@ozlabs.ru>
References: <1422523325-1389-1-git-send-email-aik@ozlabs.ru>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012909-0013-0000-0000-000000BF16B3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Normally a bitmap from the iommu_table is used to track what TCE entry
is in use. Since we are going to use iommu_table without its locks and
do xchg() instead, it becomes essential not to put bits which are not
implied in the direction flag.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Reviewed-by: David Gibson <david@gibson.dropbear.id.au>
---
 arch/powerpc/platforms/powernv/pci.c | 20 ++++++++++++++------
 1 file changed, 14 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/platforms/powernv/pci.c b/arch/powerpc/platforms/powernv/pci.c
index 4945e87..9ec7d68 100644
--- a/arch/powerpc/platforms/powernv/pci.c
+++ b/arch/powerpc/platforms/powernv/pci.c
@@ -589,19 +589,27 @@ struct pci_ops pnv_pci_ops = {
 	.write = pnv_pci_write_config,
 };
 
+static unsigned long pnv_dmadir_to_flags(enum dma_data_direction direction)
+{
+	switch (direction) {
+	case DMA_BIDIRECTIONAL:
+	case DMA_FROM_DEVICE:
+		return TCE_PCI_READ | TCE_PCI_WRITE;
+	case DMA_TO_DEVICE:
+		return TCE_PCI_READ;
+	default:
+		return 0;
+	}
+}
+
 static int pnv_tce_build(struct iommu_table *tbl, long index, long npages,
 			 unsigned long uaddr, enum dma_data_direction direction,
 			 struct dma_attrs *attrs, bool rm)
 {
-	u64 proto_tce;
+	u64 proto_tce = pnv_dmadir_to_flags(direction);
 	__be64 *tcep, *tces;
 	u64 rpn;
 
-	proto_tce = TCE_PCI_READ; // Read allowed
-
-	if (direction != DMA_TO_DEVICE)
-		proto_tce |= TCE_PCI_WRITE;
-
 	tces = tcep = ((__be64 *)tbl->it_base) + index - tbl->it_offset;
 	rpn = __pa(uaddr) >> tbl->it_page_shift;
 
-- 
2.0.0

