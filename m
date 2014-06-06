Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752647AbaFFIoX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 04:44:23 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:47749 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751809AbaFFIoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 04:44:19 -0400
From: Alexey Kardashevskiy <aik@ozlabs.ru>
To: linuxppc-dev@lists.ozlabs.org
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Alistair Popple <alistair@popple.id.au>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] powerpc/powernv: use it_page_shift for TCE invalidation
Date: Fri,  6 Jun 2014 18:44:01 +1000
Message-Id: <1402044246-13650-2-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1402044246-13650-1-git-send-email-aik@ozlabs.ru>
References: <1402044246-13650-1-git-send-email-aik@ozlabs.ru>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060608-3568-0000-0000-000005A33721
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes IODA1/2 to use it_page_shift as it may be bigger than 4K.

This changes involved constant values to use "ull" modifier.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 arch/powerpc/platforms/powernv/pci-ioda.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/platforms/powernv/pci-ioda.c b/arch/powerpc/platforms/powernv/pci-ioda.c
index 98824aa..8307fe5 100644
--- a/arch/powerpc/platforms/powernv/pci-ioda.c
+++ b/arch/powerpc/platforms/powernv/pci-ioda.c
@@ -512,15 +512,16 @@ static void pnv_pci_ioda1_tce_invalidate(struct pnv_ioda_pe *pe,
 		(__be64 __iomem *)pe->tce_inval_reg_phys :
 		(__be64 __iomem *)tbl->it_index;
 	unsigned long start, end, inc;
+	const unsigned shift = tbl->it_page_shift;
 
 	start = __pa(startp);
 	end = __pa(endp);
 
 	/* BML uses this case for p6/p7/galaxy2: Shift addr and put in node */
 	if (tbl->it_busno) {
-		start <<= 12;
-		end <<= 12;
-		inc = 128 << 12;
+		start <<= shift;
+		end <<= shift;
+		inc = 128ull << shift;
 		start |= tbl->it_busno;
 		end |= tbl->it_busno;
 	} else if (tbl->it_type & TCE_PCI_SWINV_PAIR) {
@@ -558,18 +559,19 @@ static void pnv_pci_ioda2_tce_invalidate(struct pnv_ioda_pe *pe,
 	__be64 __iomem *invalidate = rm ?
 		(__be64 __iomem *)pe->tce_inval_reg_phys :
 		(__be64 __iomem *)tbl->it_index;
+	const unsigned shift = tbl->it_page_shift;
 
 	/* We'll invalidate DMA address in PE scope */
-	start = 0x2ul << 60;
+	start = 0x2ull << 60;
 	start |= (pe->pe_number & 0xFF);
 	end = start;
 
 	/* Figure out the start, end and step */
 	inc = tbl->it_offset + (((u64)startp - tbl->it_base) / sizeof(u64));
-	start |= (inc << 12);
+	start |= (inc << shift);
 	inc = tbl->it_offset + (((u64)endp - tbl->it_base) / sizeof(u64));
-	end |= (inc << 12);
-	inc = (0x1ul << 12);
+	end |= (inc << shift);
+	inc = (0x1ull << shift);
 	mb();
 
 	while (start <= end) {
-- 
2.0.0

