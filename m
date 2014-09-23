Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753832AbaIWOqp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 10:46:45 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:34348 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167AbaIWOqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 10:46:43 -0400
From: Antonios Motakis <a.motakis@virtualopensystems.com>
To: alex.williamson@redhat.com, kvmarm@lists.cs.columbia.edu,
        iommu@lists.linux-foundation.org
Cc: tech@virtualopensystems.com, kvm@vger.kernel.org,
        christoffer.dall@linaro.org, will.deacon@arm.com,
        kim.phillips@freescale.com, eric.auger@linaro.org,
        marc.zyngier@arm.com,
        Antonios Motakis <a.motakis@virtualopensystems.com>,
        Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Shuah Khan <shuah.kh@samsung.com>, Thierry Reding <treding@nvidia.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        "Upinder Malhi (umalhi)" <umalhi@cisco.com>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM SMMU DRIVER),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCHv7 01/26] iommu/arm-smmu: change IOMMU_EXEC to IOMMU_NOEXEC
Date: Tue, 23 Sep 2014 16:46:00 +0200
Message-Id: <1411483586-29304-2-git-send-email-a.motakis@virtualopensystems.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1411483586-29304-1-git-send-email-a.motakis@virtualopensystems.com>
References: <1411483586-29304-1-git-send-email-a.motakis@virtualopensystems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Exposing the XN flag of the SMMU driver as IOMMU_NOEXEC instead of
IOMMU_EXEC makes it enforceable, since for IOMMUs that don't support
the XN flag pages will always be executable.

Signed-off-by: Antonios Motakis <a.motakis@virtualopensystems.com>
---
 drivers/iommu/arm-smmu.c | 9 +++++----
 include/linux/iommu.h    | 2 +-
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/arm-smmu.c b/drivers/iommu/arm-smmu.c
index a83cc2a..c7cbdda 100644
--- a/drivers/iommu/arm-smmu.c
+++ b/drivers/iommu/arm-smmu.c
@@ -1252,7 +1252,7 @@ static int arm_smmu_alloc_init_pte(struct arm_smmu_device *smmu, pmd_t *pmd,
 				   unsigned long pfn, int prot, int stage)
 {
 	pte_t *pte, *start;
-	pteval_t pteval = ARM_SMMU_PTE_PAGE | ARM_SMMU_PTE_AF | ARM_SMMU_PTE_XN;
+	pteval_t pteval = ARM_SMMU_PTE_PAGE | ARM_SMMU_PTE_AF;
 
 	if (pmd_none(*pmd)) {
 		/* Allocate a new set of tables */
@@ -1286,10 +1286,11 @@ static int arm_smmu_alloc_init_pte(struct arm_smmu_device *smmu, pmd_t *pmd,
 			pteval |= ARM_SMMU_PTE_MEMATTR_NC;
 	}
 
+	if (prot & IOMMU_NOEXEC)
+		pteval |= ARM_SMMU_PTE_XN;
+
 	/* If no access, create a faulting entry to avoid TLB fills */
-	if (prot & IOMMU_EXEC)
-		pteval &= ~ARM_SMMU_PTE_XN;
-	else if (!(prot & (IOMMU_READ | IOMMU_WRITE)))
+	if (!(prot & (IOMMU_READ | IOMMU_WRITE)))
 		pteval &= ~ARM_SMMU_PTE_PAGE;
 
 	pteval |= ARM_SMMU_PTE_SH_IS;
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 20f9a52..e1a644c 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -27,7 +27,7 @@
 #define IOMMU_READ	(1 << 0)
 #define IOMMU_WRITE	(1 << 1)
 #define IOMMU_CACHE	(1 << 2) /* DMA cache coherency */
-#define IOMMU_EXEC	(1 << 3)
+#define IOMMU_NOEXEC	(1 << 3)
 
 struct iommu_ops;
 struct iommu_group;
-- 
1.8.3.2

