Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742AbaFFIpq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 04:45:46 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:47751 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884AbaFFIoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 04:44:19 -0400
From: Alexey Kardashevskiy <aik@ozlabs.ru>
To: linuxppc-dev@lists.ozlabs.org
Cc: Alexey Kardashevskiy <aik@ozlabs.ru>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Alistair Popple <alistair@popple.id.au>, linux-kernel@vger.kernel.org
Subject: [PATCH 2/6] powerpc/powernv: use it_page_shift in TCE build
Date: Fri,  6 Jun 2014 18:44:02 +1000
Message-Id: <1402044246-13650-3-git-send-email-aik@ozlabs.ru>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1402044246-13650-1-git-send-email-aik@ozlabs.ru>
References: <1402044246-13650-1-git-send-email-aik@ozlabs.ru>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14060608-3568-0000-0000-000005A3371F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes use of iommu_table::it_page_shift instead of TCE_SHIFT and
TCE_RPN_SHIFT hardcoded values.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
---
 arch/powerpc/platforms/powernv/pci.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/platforms/powernv/pci.c b/arch/powerpc/platforms/powernv/pci.c
index 8518817..9f7c556 100644
--- a/arch/powerpc/platforms/powernv/pci.c
+++ b/arch/powerpc/platforms/powernv/pci.c
@@ -527,10 +527,11 @@ static int pnv_tce_build(struct iommu_table *tbl, long index, long npages,
 		proto_tce |= TCE_PCI_WRITE;
 
 	tces = tcep = ((__be64 *)tbl->it_base) + index - tbl->it_offset;
-	rpn = __pa(uaddr) >> TCE_SHIFT;
+	rpn = __pa(uaddr) >> tbl->it_page_shift;
 
 	while (npages--)
-		*(tcep++) = cpu_to_be64(proto_tce | (rpn++ << TCE_RPN_SHIFT));
+		*(tcep++) = cpu_to_be64(proto_tce |
+				(rpn++ << tbl->it_page_shift));
 
 	/* Some implementations won't cache invalid TCEs and thus may not
 	 * need that flush. We'll probably turn it_type into a bit mask
-- 
2.0.0

