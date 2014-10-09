Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436AbaJIVEX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:04:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58951 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322AbaJIVDa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:03:30 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Olav Haugan <ohaugan@codeaurora.org>, Will Deacon <will.deacon@arm.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 020/163] iommu/arm-smmu: fix programming of SMMU_CBn_TCR for stage 1
Date: Thu,  9 Oct 2014 14:00:45 -0700
Message-Id: <1412888588-26755-21-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olav Haugan <ohaugan@codeaurora.org>

commit 1fc870c7efa364862c3bc792cfbdb38afea26742 upstream.

Stage-1 context banks do not have the SMMU_CBn_TCR[SL0] field since it
is only applicable to stage-2 context banks.

This patch ensures that we don't set the reserved TCR bits for stage-1
translations.

Signed-off-by: Olav Haugan <ohaugan@codeaurora.org>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/iommu/arm-smmu.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/arm-smmu.c b/drivers/iommu/arm-smmu.c
index 0d3e4e6..91739bf 100644
--- a/drivers/iommu/arm-smmu.c
+++ b/drivers/iommu/arm-smmu.c
@@ -793,8 +793,11 @@ static void arm_smmu_init_context_bank(struct arm_smmu_domain *smmu_domain)
 	reg |= TTBCR_EAE |
 	      (TTBCR_SH_IS << TTBCR_SH0_SHIFT) |
 	      (TTBCR_RGN_WBWA << TTBCR_ORGN0_SHIFT) |
-	      (TTBCR_RGN_WBWA << TTBCR_IRGN0_SHIFT) |
-	      (TTBCR_SL0_LVL_1 << TTBCR_SL0_SHIFT);
+	      (TTBCR_RGN_WBWA << TTBCR_IRGN0_SHIFT);
+
+	if (!stage1)
+		reg |= (TTBCR_SL0_LVL_1 << TTBCR_SL0_SHIFT);
+
 	writel_relaxed(reg, cb_base + ARM_SMMU_CB_TTBCR);
 
 	/* MAIR0 (stage-1 only) */
-- 
1.9.1

