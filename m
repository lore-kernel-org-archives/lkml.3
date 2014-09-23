Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621AbaIWDCQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 23:02:16 -0400
Received: from e23smtp05.au.ibm.com ([202.81.31.147]:59866 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755594AbaIWDCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 23:02:13 -0400
From: Alexey Kardashevskiy <aik@ozlabs.ru>
To: linuxppc-dev@lists.ozlabs.org
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        Gavin Shan <gwshan@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: [PATCH v2 07/13] powerpc/powernv: Do not set "read" flag if direction==DMA_NONE
Date: Tue, 23 Sep 2014 13:00:56 +1000
Message-Id: <1411441262-11025-8-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1411441262-11025-1-git-send-email-aik@ozlabs.ru>
References: <1411441262-11025-1-git-send-email-aik@ozlabs.ru>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14092303-0017-0000-0000-0000003DE5BB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Normally a bitmap from the iommu_table is used to track what TCE entry
is in use. Since we are going to use iommu_table without its locks and
do xchg() instead, it becomes essential not to put bits which are not
implied in the direction flag.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 arch/powerpc/platforms/powernv/pci.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/platforms/powernv/pci.c b/arch/powerpc/platforms/powernv/pci.c
index deddcad..ab79e2d 100644
--- a/arch/powerpc/platforms/powernv/pci.c
+++ b/arch/powerpc/platforms/powernv/pci.c
@@ -628,10 +628,18 @@ static int pnv_tce_build(struct iommu_table *tbl, long index, long npages,
 	__be64 *tcep, *tces;
 	u64 rpn;
 
-	proto_tce = TCE_PCI_READ; // Read allowed
-
-	if (direction != DMA_TO_DEVICE)
-		proto_tce |= TCE_PCI_WRITE;
+	switch (direction) {
+	case DMA_BIDIRECTIONAL:
+	case DMA_FROM_DEVICE:
+		proto_tce = TCE_PCI_READ | TCE_PCI_WRITE;
+		break;
+	case DMA_TO_DEVICE:
+		proto_tce = TCE_PCI_READ;
+		break;
+	default:
+		proto_tce = 0;
+		break;
+	}
 
 	tces = tcep = ((__be64 *)tbl->it_base) + index - tbl->it_offset;
 	rpn = __pa(uaddr) >> tbl->it_page_shift;
-- 
2.0.0

