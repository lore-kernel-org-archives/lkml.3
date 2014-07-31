Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752876AbaGaTYp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 15:24:45 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:53139 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470AbaGaTYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 15:24:43 -0400
Date: Thu, 31 Jul 2014 14:24:37 -0500
From: Brian W Hart <hartb@linux.vnet.ibm.com>
To: benh@kernel.crashing.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] powerpc/powernv: update dev->dma_mask in pci_set_dma_mask()
 path
Message-ID: <20140731192437.GA18855@oc3347516403.ibm.com>
Mail-Followup-To: benh@kernel.crashing.org, linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14073119-6688-0000-0000-000003AF7235
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

powerpc defines various machine-specific routines for handling
pci_set_dma_mask().  The routines for machine "PowerNV" may neglect
to set dev->dma_mask.  This could confuse anyone (e.g. drivers) that
consult dev->dma_mask to find the current mask.  Set the dma_mask in
the PowerNV leaf routine.

Signed-off-by: Brian W. Hart <hartb@linux.vnet.ibm.com>
---
I assume the failure to set dma_mask in this path was just an oversight.
With this change everything still seems to work fine on my powernv setup,
and dev->dma_mask now carries the appropriate value after
pci_set_dma_mask(dev, DMA_BIT_MASK(64).

 arch/powerpc/platforms/powernv/pci-ioda.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/powerpc/platforms/powernv/pci-ioda.c b/arch/powerpc/platforms/powernv/pci-ioda.c
index de19ede..3136ae2 100644
--- a/arch/powerpc/platforms/powernv/pci-ioda.c
+++ b/arch/powerpc/platforms/powernv/pci-ioda.c
@@ -491,6 +491,7 @@ static int pnv_pci_ioda_dma_set_mask(struct pnv_phb *phb,
 		set_dma_ops(&pdev->dev, &dma_iommu_ops);
 		set_iommu_table_base(&pdev->dev, &pe->tce32_table);
 	}
+	*pdev->dev.dma_mask = dma_mask;
 	return 0;
 }
 
-- 
1.7.1

