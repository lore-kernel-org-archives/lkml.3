Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468Ab3CUBdu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 21:33:50 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:39092 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753772Ab3CUBdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 21:33:49 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
From: Takao Indoh <indou.takao@jp.fujitsu.com>
To: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        dwmw2@infradead.org, joro@8bytes.org
Cc: kexec@lists.infradead.org
Subject: [PATCH] intel-iommu: Synchronize gcmd value with global command register
Date: Thu, 21 Mar 2013 10:32:36 +0900
Message-Id: <1363829556-2128-1-git-send-email-indou.takao@jp.fujitsu.com>
X-Mailer: git-send-email 1.7.9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch synchronize iommu->gcmd value with global command register so
that bits in the register could be handled correctly.

iommu_disable_irq_remapping() should disable only IR(Interrupt
Remapping), but in the case of kdump, it also disables QI(Queued
Invalidation) and DMAR(DMA remapping) at the same time.

At boot time, iommu_disable_irq_remapping() is called via
intel_enable_irq_remapping().

static void iommu_disable_irq_remapping(struct intel_iommu *iommu)
{
(snip)
	iommu->gcmd &= ~DMA_GCMD_IRE;
	writel(iommu->gcmd, iommu->reg + DMAR_GCMD_REG);

In this function, clearing IRE bit in iommu->gcmd and writing it to
global command register. But initial value of iommu->gcmd is zero, so
this writel means clearing all bits in global command register.

In the case of second kernel(kdump kernel) boot, IR/QI/DMAR are already
enabled because it was used in first kernel, so they are disabled at the
same time in this function.

In this patch iommu->gcmd is initialized so that its value could be
synchronized with global command register. By this,
iommu_disable_irq_remapping() disables only IR, and QI is disabled in
dmar_disable_qi(). This patch also changes init_dmars() to disable DMAR
before initializing it if already enabled.

Signed-off-by: Takao Indoh <indou.takao@jp.fujitsu.com>
---
 drivers/iommu/dmar.c        |   11 ++++++++++-
 drivers/iommu/intel-iommu.c |   12 ++++++++++++
 2 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/drivers/iommu/dmar.c b/drivers/iommu/dmar.c
index e5cdaf8..9f69352 100644
--- a/drivers/iommu/dmar.c
+++ b/drivers/iommu/dmar.c
@@ -645,7 +645,7 @@ out:
 int alloc_iommu(struct dmar_drhd_unit *drhd)
 {
 	struct intel_iommu *iommu;
-	u32 ver;
+	u32 ver, sts;
 	static int iommu_allocated = 0;
 	int agaw = 0;
 	int msagaw = 0;
@@ -695,6 +695,15 @@ int alloc_iommu(struct dmar_drhd_unit *drhd)
 		(unsigned long long)iommu->cap,
 		(unsigned long long)iommu->ecap);
 
+	/* Reflect status in gcmd */
+	sts = readl(iommu->reg + DMAR_GSTS_REG);
+	if (sts & DMA_GSTS_IRES)
+		iommu->gcmd |= DMA_GCMD_IRE;
+	if (sts & DMA_GSTS_TES)
+		iommu->gcmd |= DMA_GCMD_TE;
+	if (sts & DMA_GSTS_QIES)
+		iommu->gcmd |= DMA_GCMD_QIE;
+
 	raw_spin_lock_init(&iommu->register_lock);
 
 	drhd->iommu = iommu;
diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 0099667..3437046 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -2515,6 +2515,18 @@ static int __init init_dmars(void)
 	}
 
 	/*
+	 * Disable translation if already enabled prior to OS handover.
+	 */
+	for_each_drhd_unit(drhd) {
+		if (drhd->ignored)
+			continue;
+
+		iommu = drhd->iommu;
+		if (iommu->gcmd & DMA_GCMD_TE)
+			iommu_disable_translation(iommu);
+	}
+
+	/*
 	 * Start from the sane iommu hardware state.
 	 */
 	for_each_drhd_unit(drhd) {
-- 
1.7.1


