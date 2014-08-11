Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552AbaHKLNk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 07:13:40 -0400
Received: from david.siemens.de ([192.35.17.14]:42002 "EHLO david.siemens.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132AbaHKLNi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 07:13:38 -0400
Message-ID: <53E8A555.5010905@siemens.com>
Date: Mon, 11 Aug 2014 13:13:25 +0200
From: Jan Kiszka <jan.kiszka@siemens.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>, iommu <iommu@lists.linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Jiang Liu <jiang.liu@linux.intel.com>
Subject: [PATCH] iommu/vt-d: Don't store SIRTP request
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't store the SIRTP request bit in the register state. It will
otherwise become sticky and could request an Interrupt Remap Table
Pointer update on each command register write.

Found while starting to emulate IR in QEMU, not by observing problems on
real hardware.

Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 drivers/iommu/intel_irq_remapping.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index 0df41f6..a872874 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -438,8 +438,7 @@ static void iommu_set_irq_remapping(struct intel_iommu *iommu, int mode)
 		    (addr) | IR_X2APIC_MODE(mode) | INTR_REMAP_TABLE_REG_SIZE);
 
 	/* Set interrupt-remapping table pointer */
-	iommu->gcmd |= DMA_GCMD_SIRTP;
-	writel(iommu->gcmd, iommu->reg + DMAR_GCMD_REG);
+	writel(iommu->gcmd | DMA_GCMD_SIRTP, iommu->reg + DMAR_GCMD_REG);
 
 	IOMMU_WAIT_OP(iommu, DMAR_GSTS_REG,
 		      readl, (sts & DMA_GSTS_IRTPS), sts);
-- 
1.8.1.1.298.ge7eed54
