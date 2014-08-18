Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556AbaHRJBO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 05:01:14 -0400
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:60537 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbaHRJBL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:01:11 -0400
From: "Li, Zhen-Hua" <zhen-hual@hp.com>
To: David Woodhouse <dwmw2@infradead.org>, Joerg Roedel <joro@8bytes.org>,
        <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
Cc: "Li, Zhen-Hua" <zhen-hual@hp.com>
Subject: [PATCH 1/1] iommu/vt-d : clear old root entry for dump kernel
Date: Mon, 18 Aug 2014 16:59:12 +0800
Message-Id: <1408352352-14449-1-git-send-email-zhen-hual@hp.com>
X-Mailer: git-send-email 2.0.0-rc0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If intel_iommu is enabled, when kdump kernel boots, the old root entry
 should be cleared, otherwise it may cause DMAR error.

To make it works for more enviroments, this patch does not use 
is_kdump_kernel() to check it,  but reads the register to check whether 
hardware is using old root entry.

Signed-off-by: Li, Zhen-Hua <zhen-hual@hp.com>
---
 drivers/iommu/dmar.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index 60ab474..7b4fa90 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -66,6 +66,8 @@ static int dmar_dev_scope_status = 1;
 static int alloc_iommu(struct dmar_drhd_unit *drhd);
 static void free_iommu(struct intel_iommu *iommu);
 
+static int iommu_check_root_entry(struct intel_iommu *iommu);
+
 static void __init dmar_register_drhd_unit(struct dmar_drhd_unit *drhd)
 {
 	/*
@@ -987,6 +989,8 @@ static int alloc_iommu(struct dmar_drhd_unit *drhd)
 						       intel_iommu_groups,
 						       iommu->name);
 
+	iommu_check_root_entry(iommu);
+
 	return 0;
 
  err_unmap:
@@ -1666,5 +1670,32 @@ static int __init dmar_free_unused_resources(void)
 	return 0;
 }
 
+static int iommu_check_root_entry(struct intel_iommu *iommu)
+{
+	u64 re_pa;
+
+	re_pa = dmar_readq(iommu->reg + DMAR_RTADDR_REG);
+
+	/* This only works for hardware error and kdump kernel */
+	if (unlikely(re_pa != 0)) {
+		u32 sts;
+		unsigned long flag;
+
+		raw_spin_lock_irqsave(&iommu->register_lock, flag);
+		dmar_writeq(iommu->reg + DMAR_RTADDR_REG, 0);
+
+		writel(iommu->gcmd | DMA_GCMD_SRTP, iommu->reg + DMAR_GCMD_REG);
+
+		/* Make sure hardware complete it */
+		IOMMU_WAIT_OP(iommu, DMAR_GSTS_REG,
+			      readl, (sts & DMA_GSTS_RTPS), sts);
+
+		raw_spin_unlock_irqrestore(&iommu->register_lock, flag);
+
+	}
+
+	return 0;
+}
+
 late_initcall(dmar_free_unused_resources);
 IOMMU_INIT_POST(detect_intel_iommu);
-- 
2.0.0-rc0

