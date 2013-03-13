Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934077Ab3CMSyI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 14:54:08 -0400
Received: from [213.199.154.184] ([213.199.154.184]:43322 "EHLO
	db8outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S933116Ab3CMSyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 14:54:06 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 8
X-BigFish: VS8(zza1fflb922lzz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh2a8h668h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
From: Varun Sethi <Varun.Sethi@freescale.com>
To: <joro@8bytes.org>, <iommu@lists.linux-foundation.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <galak@kernel.crashing.org>, <benh@kernel.crashing.org>,
        <scottwood@freescale.com>, <stuart.yoder@freescale.com>
CC: Varun Sethi <Varun.Sethi@freescale.com>
Subject: [PATCH 1/5 v9] iommu/fsl: Make iova u64 in the iommu_iova_to_phys API.
Date: Thu, 14 Mar 2013 00:15:06 +0530
Message-ID: <1363200310-11513-2-git-send-email-Varun.Sethi@freescale.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1363200310-11513-1-git-send-email-Varun.Sethi@freescale.com>
References: <1363200310-11513-1-git-send-email-Varun.Sethi@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is required in case of PAMU, as it can support a window size of up
to 64G (even on 32bit).

Signed-off-by: Varun Sethi <Varun.Sethi@freescale.com>
---
 drivers/iommu/amd_iommu.c      |    2 +-
 drivers/iommu/exynos-iommu.c   |    2 +-
 drivers/iommu/intel-iommu.c    |    2 +-
 drivers/iommu/iommu.c          |    3 +--
 drivers/iommu/msm_iommu.c      |    2 +-
 drivers/iommu/omap-iommu.c     |    2 +-
 drivers/iommu/shmobile-iommu.c |    2 +-
 drivers/iommu/tegra-gart.c     |    2 +-
 drivers/iommu/tegra-smmu.c     |    2 +-
 include/linux/iommu.h          |    9 +++------
 10 files changed, 12 insertions(+), 16 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 98f555d..42f6a71 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -3412,7 +3412,7 @@ static size_t amd_iommu_unmap(struct iommu_domain *dom, unsigned long iova,
 }
 
 static phys_addr_t amd_iommu_iova_to_phys(struct iommu_domain *dom,
-					  unsigned long iova)
+					  u64 iova)
 {
 	struct protection_domain *domain = dom->priv;
 	unsigned long offset_mask;
diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 238a3ca..541e81b 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -1027,7 +1027,7 @@ done:
 }
 
 static phys_addr_t exynos_iommu_iova_to_phys(struct iommu_domain *domain,
-					  unsigned long iova)
+					  u64 iova)
 {
 	struct exynos_iommu_domain *priv = domain->priv;
 	unsigned long *entry;
diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 0099667..c9663ac 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -4111,7 +4111,7 @@ static size_t intel_iommu_unmap(struct iommu_domain *domain,
 }
 
 static phys_addr_t intel_iommu_iova_to_phys(struct iommu_domain *domain,
-					    unsigned long iova)
+					    u64 iova)
 {
 	struct dmar_domain *dmar_domain = domain->priv;
 	struct dma_pte *pte;
diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index b972d43..39106ec 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -706,8 +706,7 @@ void iommu_detach_group(struct iommu_domain *domain, struct iommu_group *group)
 }
 EXPORT_SYMBOL_GPL(iommu_detach_group);
 
-phys_addr_t iommu_iova_to_phys(struct iommu_domain *domain,
-			       unsigned long iova)
+phys_addr_t iommu_iova_to_phys(struct iommu_domain *domain, u64 iova)
 {
 	if (unlikely(domain->ops->iova_to_phys == NULL))
 		return 0;
diff --git a/drivers/iommu/msm_iommu.c b/drivers/iommu/msm_iommu.c
index 6a8870a..fcd14a3 100644
--- a/drivers/iommu/msm_iommu.c
+++ b/drivers/iommu/msm_iommu.c
@@ -554,7 +554,7 @@ fail:
 }
 
 static phys_addr_t msm_iommu_iova_to_phys(struct iommu_domain *domain,
-					  unsigned long va)
+					  u64 va)
 {
 	struct msm_priv *priv;
 	struct msm_iommu_drvdata *iommu_drvdata;
diff --git a/drivers/iommu/omap-iommu.c b/drivers/iommu/omap-iommu.c
index 6ac02fa..102ae56 100644
--- a/drivers/iommu/omap-iommu.c
+++ b/drivers/iommu/omap-iommu.c
@@ -1219,7 +1219,7 @@ static void omap_iommu_domain_destroy(struct iommu_domain *domain)
 }
 
 static phys_addr_t omap_iommu_iova_to_phys(struct iommu_domain *domain,
-					  unsigned long da)
+					  u64 da)
 {
 	struct omap_iommu_domain *omap_domain = domain->priv;
 	struct omap_iommu *oiommu = omap_domain->iommu_dev;
diff --git a/drivers/iommu/shmobile-iommu.c b/drivers/iommu/shmobile-iommu.c
index b6e8b57..9216802 100644
--- a/drivers/iommu/shmobile-iommu.c
+++ b/drivers/iommu/shmobile-iommu.c
@@ -296,7 +296,7 @@ done:
 }
 
 static phys_addr_t shmobile_iommu_iova_to_phys(struct iommu_domain *domain,
-					       unsigned long iova)
+					       u64 iova)
 {
 	struct shmobile_iommu_domain *sh_domain = domain->priv;
 	uint32_t l1entry = 0, l2entry = 0;
diff --git a/drivers/iommu/tegra-gart.c b/drivers/iommu/tegra-gart.c
index 8643757..17179c0 100644
--- a/drivers/iommu/tegra-gart.c
+++ b/drivers/iommu/tegra-gart.c
@@ -279,7 +279,7 @@ static size_t gart_iommu_unmap(struct iommu_domain *domain, unsigned long iova,
 }
 
 static phys_addr_t gart_iommu_iova_to_phys(struct iommu_domain *domain,
-					   unsigned long iova)
+					   u64 iova)
 {
 	struct gart_device *gart = domain->priv;
 	unsigned long pte;
diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c
index b34e5fd..eef9460 100644
--- a/drivers/iommu/tegra-smmu.c
+++ b/drivers/iommu/tegra-smmu.c
@@ -757,7 +757,7 @@ static size_t smmu_iommu_unmap(struct iommu_domain *domain, unsigned long iova,
 }
 
 static phys_addr_t smmu_iommu_iova_to_phys(struct iommu_domain *domain,
-					   unsigned long iova)
+					   u64 iova)
 {
 	struct smmu_as *as = domain->priv;
 	unsigned long *pte;
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index ba3b8a9..576cc19 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -91,8 +91,7 @@ struct iommu_ops {
 		   phys_addr_t paddr, size_t size, int prot);
 	size_t (*unmap)(struct iommu_domain *domain, unsigned long iova,
 		     size_t size);
-	phys_addr_t (*iova_to_phys)(struct iommu_domain *domain,
-				    unsigned long iova);
+	phys_addr_t (*iova_to_phys)(struct iommu_domain *domain, u64 iova);
 	int (*domain_has_cap)(struct iommu_domain *domain,
 			      unsigned long cap);
 	int (*add_device)(struct device *dev);
@@ -134,8 +133,7 @@ extern int iommu_map(struct iommu_domain *domain, unsigned long iova,
 		     phys_addr_t paddr, size_t size, int prot);
 extern size_t iommu_unmap(struct iommu_domain *domain, unsigned long iova,
 		       size_t size);
-extern phys_addr_t iommu_iova_to_phys(struct iommu_domain *domain,
-				      unsigned long iova);
+extern phys_addr_t iommu_iova_to_phys(struct iommu_domain *domain, u64 iova);
 extern int iommu_domain_has_cap(struct iommu_domain *domain,
 				unsigned long cap);
 extern void iommu_set_fault_handler(struct iommu_domain *domain,
@@ -267,8 +265,7 @@ static inline void iommu_domain_window_disable(struct iommu_domain *domain,
 {
 }
 
-static inline phys_addr_t iommu_iova_to_phys(struct iommu_domain *domain,
-					     unsigned long iova)
+static inline phys_addr_t iommu_iova_to_phys(struct iommu_domain *domain, u64 iova)
 {
 	return 0;
 }
-- 
1.7.4.1


