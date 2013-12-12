Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752224Ab3LLH6q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 02:58:46 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:1559 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402Ab3LLH6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 02:58:41 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 12 Dec 2013 00:01:20 -0800
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>, <swarren@nvidia.com>,
        <will.deacon@arm.com>, <grant.likely@linaro.org>,
        <thierry.reding@gmail.com>, <robherring2@gmail.com>, <joro@8bytes.org>
CC: Hiroshi Doyu <hdoyu@nvidia.com>, <mark.rutland@arm.com>,
        <devicetree@vger.kernel.org>, <lorenzo.pieralisi@arm.com>,
        <linux-kernel@vger.kernel.org>, <iommu@lists.linux-foundation.org>,
        <galak@codeaurora.org>, <linux-tegra@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Subject: [PATCHv7 10/12] iommu/tegra: smmu: allow duplicate ASID wirte
Date: Thu, 12 Dec 2013 09:57:11 +0200
Message-ID: <1386835033-4701-11-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1386835033-4701-1-git-send-email-hdoyu@nvidia.com>
References: <1386835033-4701-1-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The device, which belongs to the same ASID, can try to enable the same
ASID as the other swgroup devices. This should be allowed but just
skip the actual register write. If the write value is different, it
will return -EINVAL.

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
---
v4:
This was the part of v3, which isn't used any more.
  [PATCHv3 10/19] iommu/tegra: smmu: Get "nvidia,swgroups" from DT

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
---
 drivers/iommu/tegra-smmu.c | 20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c
index fd4479a..2b8a302 100644
--- a/drivers/iommu/tegra-smmu.c
+++ b/drivers/iommu/tegra-smmu.c
@@ -418,9 +418,13 @@ static int __smmu_client_set_hwgrp(struct smmu_client *c,
 		offs = HWGRP_ASID_REG(i);
 		val = smmu_read(smmu, offs);
 		if (on) {
-			if (WARN_ON(val & mask))
-				goto err_hw_busy;
-			val |= mask;
+			if (val) {
+				if (WARN_ON(val != mask))
+					return -EINVAL;
+				goto skip;
+			}
+
+			val = mask;
 			memcpy(c->hwgrp, map, sizeof(u64));
 		} else {
 			WARN_ON((val & mask) == mask);
@@ -430,16 +434,8 @@ static int __smmu_client_set_hwgrp(struct smmu_client *c,
 	}
 
 	FLUSH_SMMU_REGS(smmu);
+skip:
 	return 0;
-
-err_hw_busy:
-	for_each_set_bit(i, map, TEGRA_SWGROUP_MAX) {
-		offs = HWGRP_ASID_REG(i);
-		val = smmu_read(smmu, offs);
-		val &= ~mask;
-		smmu_write(smmu, val, offs);
-	}
-	return -EBUSY;
 }
 
 static int smmu_client_set_hwgrp(struct smmu_client *c,
-- 
1.8.1.5

