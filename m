Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756618AbaCEOYq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 09:24:46 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40745 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756197AbaCEOYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 09:24:39 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Yifan Zhang <zhangyf@marvell.com>, Will Deacon <will.deacon@arm.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 012/131] iommu/arm-smmu: fix pud/pmd entry fill sequence
Date: Wed,  5 Mar 2014 14:22:16 +0000
Message-Id: <1394029455-23128-13-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
References: <1394029455-23128-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yifan Zhang <zhangyf@marvell.com>

commit 97a644208d1a08b7104d1fe2ace8cef011222711 upstream.

The ARM SMMU driver's population of puds and pmds is broken, since we
iterate over the next level of table repeatedly setting the current
level descriptor to point at the pmd being initialised. This is clearly
wrong when dealing with multiple pmds/puds.

This patch fixes the problem by moving the pud/pmd population out of the
loop and instead performing it when we allocate the next level (like we
correctly do for ptes already). The starting address for the next level
is then calculated prior to entering the loop.

Signed-off-by: Yifan Zhang <zhangyf@marvell.com>
Signed-off-by: Will Deacon <will.deacon@arm.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/iommu/arm-smmu.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/arm-smmu.c b/drivers/iommu/arm-smmu.c
index 320894b..896a229 100644
--- a/drivers/iommu/arm-smmu.c
+++ b/drivers/iommu/arm-smmu.c
@@ -1293,6 +1293,11 @@ static int arm_smmu_alloc_init_pmd(struct arm_smmu_device *smmu, pud_t *pud,
 		pmd = pmd_alloc_one(NULL, addr);
 		if (!pmd)
 			return -ENOMEM;
+
+		pud_populate(NULL, pud, pmd);
+		arm_smmu_flush_pgtable(smmu, pud, sizeof(*pud));
+
+		pmd += pmd_index(addr);
 	} else
 #endif
 		pmd = pmd_offset(pud, addr);
@@ -1301,8 +1306,6 @@ static int arm_smmu_alloc_init_pmd(struct arm_smmu_device *smmu, pud_t *pud,
 		next = pmd_addr_end(addr, end);
 		ret = arm_smmu_alloc_init_pte(smmu, pmd, addr, end, pfn,
 					      flags, stage);
-		pud_populate(NULL, pud, pmd);
-		arm_smmu_flush_pgtable(smmu, pud, sizeof(*pud));
 		phys += next - addr;
 	} while (pmd++, addr = next, addr < end);
 
@@ -1322,6 +1325,11 @@ static int arm_smmu_alloc_init_pud(struct arm_smmu_device *smmu, pgd_t *pgd,
 		pud = pud_alloc_one(NULL, addr);
 		if (!pud)
 			return -ENOMEM;
+
+		pgd_populate(NULL, pgd, pud);
+		arm_smmu_flush_pgtable(smmu, pgd, sizeof(*pgd));
+
+		pud += pud_index(addr);
 	} else
 #endif
 		pud = pud_offset(pgd, addr);
@@ -1330,8 +1338,6 @@ static int arm_smmu_alloc_init_pud(struct arm_smmu_device *smmu, pgd_t *pgd,
 		next = pud_addr_end(addr, end);
 		ret = arm_smmu_alloc_init_pmd(smmu, pud, addr, next, phys,
 					      flags, stage);
-		pgd_populate(NULL, pud, pgd);
-		arm_smmu_flush_pgtable(smmu, pgd, sizeof(*pgd));
 		phys += next - addr;
 	} while (pud++, addr = next, addr < end);
 
-- 
1.9.0

