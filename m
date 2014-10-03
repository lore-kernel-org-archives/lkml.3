Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757849AbaJDAgN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 20:36:13 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45341 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753233AbaJCVmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:42:47 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Olav Haugan <ohaugan@codeaurora.org>,
        Will Deacon <will.deacon@arm.com>
Subject: [PATCH 3.16 154/357] iommu/arm-smmu: fix programming of SMMU_CBn_TCR for stage 1
Date: Fri,  3 Oct 2014 14:29:00 -0700
Message-Id: <20141003212938.095385687@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olav Haugan <ohaugan@codeaurora.org>

commit 1fc870c7efa364862c3bc792cfbdb38afea26742 upstream.

Stage-1 context banks do not have the SMMU_CBn_TCR[SL0] field since it
is only applicable to stage-2 context banks.

This patch ensures that we don't set the reserved TCR bits for stage-1
translations.

Signed-off-by: Olav Haugan <ohaugan@codeaurora.org>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/arm-smmu.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/iommu/arm-smmu.c
+++ b/drivers/iommu/arm-smmu.c
@@ -830,8 +830,11 @@ static void arm_smmu_init_context_bank(s
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


