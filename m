Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778AbaIIVMA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 17:12:00 -0400
Received: from relay2.sgi.com ([192.48.180.65]:49477 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752006AbaIIVL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 17:11:59 -0400
From: Nathan Zimmer <nzimmer@sgi.com>
To: jroedel@suse.de, jan.kiszka@siemens.com
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Nathan Zimmer <nzimmer@sgi.com>, Gary Kroening <gfk@sgi.com>
Subject: [RFC] iommu/vt-d: Use the SIRTP when enabling remapping
Date: Tue,  9 Sep 2014 16:11:36 -0500
Message-Id: <1410297096-54096-1-git-send-email-nzimmer@sgi.com>
X-Mailer: git-send-email 1.8.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The previous change (iommu/vt-d: Don't store SIRTP request) to this area
caused a crash in our simulator. In particular is seems that by the time a
UART interrupt is sent through the system, we don't see interrupt remapping
to be enabled.  So the interrupt does not get translated to a logical
interrupt and crashes.

OR'ing the SIRTP request to make sure it is seen but hopefully not sticky.
This seems like a clean fix, at least on our simulator; if you don't agree,
our simulator guy will take a closer look at our iommu model.

Found testing on our simulator, not real hardware.

Signed-off-by: Nathan Zimmer <nzimmer@sgi.com>
Signed-off-by: Gary Kroening <gfk@sgi.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Joerg Roedel <jroedel@suse.de>

---
 drivers/iommu/intel_irq_remapping.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index a872874..f586e41 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -455,7 +455,7 @@ static void iommu_set_irq_remapping(struct intel_iommu *iommu, int mode)
 	/* Enable interrupt-remapping */
 	iommu->gcmd |= DMA_GCMD_IRE;
 	iommu->gcmd &= ~DMA_GCMD_CFI;  /* Block compatibility-format MSIs */
-	writel(iommu->gcmd, iommu->reg + DMAR_GCMD_REG);
+	writel(iommu->gcmd | DMA_GCMD_SIRTP, iommu->reg + DMAR_GCMD_REG);
 
 	IOMMU_WAIT_OP(iommu, DMAR_GSTS_REG,
 		      readl, (sts & DMA_GSTS_IRES), sts);
-- 
1.8.2.1


