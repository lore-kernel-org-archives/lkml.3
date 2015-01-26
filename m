Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757713AbbAZXy6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 18:54:58 -0500
Received: from 8bytes.org ([81.169.241.247]:50856 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757385AbbAZXvv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 18:51:51 -0500
From: Joerg Roedel <joro@8bytes.org>
To: iommu@lists.linux-foundation.org
Cc: Will Deacon <will.deacon@arm.com>, Kukjin Kim <kgene@kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Heiko Stuebner <heiko@sntech.de>, Hiroshi Doyu <hdoyu@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-rockchip@lists.infradead.org,
        linux-tegra@vger.kernel.org, Joerg Roedel <joro@8bytes.org>,
        jroedel@suse.de
Subject: [PATCH 08/15] iommu/tegra-smmu: Make use of domain_alloc and domain_free
Date: Tue, 27 Jan 2015 00:51:38 +0100
Message-Id: <1422316305-19216-9-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422316305-19216-1-git-send-email-joro@8bytes.org>
References: <1422316305-19216-1-git-send-email-joro@8bytes.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Implement domain_alloc and domain_free iommu-ops as a
replacement for domain_init/domain_destroy.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 drivers/iommu/tegra-smmu.c | 41 +++++++++++++++++++++++------------------
 1 file changed, 23 insertions(+), 18 deletions(-)

diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c
index 6e134c7..f1bf84a 100644
--- a/drivers/iommu/tegra-smmu.c
+++ b/drivers/iommu/tegra-smmu.c
@@ -31,7 +31,7 @@ struct tegra_smmu {
 };
 
 struct tegra_smmu_as {
-	struct iommu_domain *domain;
+	struct iommu_domain domain;
 	struct tegra_smmu *smmu;
 	unsigned int use_count;
 	struct page *count;
@@ -40,6 +40,11 @@ struct tegra_smmu_as {
 	u32 attr;
 };
 
+static struct tegra_smmu_as *to_smmu_as(struct iommu_domain *dom)
+{
+	return container_of(dom, struct tegra_smmu_as, domain);
+}
+
 static inline void smmu_writel(struct tegra_smmu *smmu, u32 value,
 			       unsigned long offset)
 {
@@ -224,30 +229,32 @@ static bool tegra_smmu_capable(enum iommu_cap cap)
 	return false;
 }
 
-static int tegra_smmu_domain_init(struct iommu_domain *domain)
+static struct iommu_domain *tegra_smmu_domain_alloc(enum iommu_domain_type type)
 {
 	struct tegra_smmu_as *as;
 	unsigned int i;
 	uint32_t *pd;
 
+	if (type != IOMMU_DOMAIN_UNMANAGED)
+		return NULL;
+
 	as = kzalloc(sizeof(*as), GFP_KERNEL);
 	if (!as)
-		return -ENOMEM;
+		return NULL;
 
 	as->attr = SMMU_PD_READABLE | SMMU_PD_WRITABLE | SMMU_PD_NONSECURE;
-	as->domain = domain;
 
 	as->pd = alloc_page(GFP_KERNEL | __GFP_DMA);
 	if (!as->pd) {
 		kfree(as);
-		return -ENOMEM;
+		return NULL;
 	}
 
 	as->count = alloc_page(GFP_KERNEL);
 	if (!as->count) {
 		__free_page(as->pd);
 		kfree(as);
-		return -ENOMEM;
+		return NULL;
 	}
 
 	/* clear PDEs */
@@ -264,14 +271,12 @@ static int tegra_smmu_domain_init(struct iommu_domain *domain)
 	for (i = 0; i < SMMU_NUM_PDE; i++)
 		pd[i] = 0;
 
-	domain->priv = as;
-
-	return 0;
+	return &as->domain;
 }
 
-static void tegra_smmu_domain_destroy(struct iommu_domain *domain)
+static void tegra_smmu_domain_free(struct iommu_domain *domain)
 {
-	struct tegra_smmu_as *as = domain->priv;
+	struct tegra_smmu_as *as = to_smmu_as(domain);
 
 	/* TODO: free page directory and page tables */
 	ClearPageReserved(as->pd);
@@ -395,7 +400,7 @@ static int tegra_smmu_attach_dev(struct iommu_domain *domain,
 				 struct device *dev)
 {
 	struct tegra_smmu *smmu = dev->archdata.iommu;
-	struct tegra_smmu_as *as = domain->priv;
+	struct tegra_smmu_as *as = to_smmu_as(domain);
 	struct device_node *np = dev->of_node;
 	struct of_phandle_args args;
 	unsigned int index = 0;
@@ -428,7 +433,7 @@ static int tegra_smmu_attach_dev(struct iommu_domain *domain,
 
 static void tegra_smmu_detach_dev(struct iommu_domain *domain, struct device *dev)
 {
-	struct tegra_smmu_as *as = domain->priv;
+	struct tegra_smmu_as *as = to_smmu_as(domain);
 	struct device_node *np = dev->of_node;
 	struct tegra_smmu *smmu = as->smmu;
 	struct of_phandle_args args;
@@ -524,7 +529,7 @@ static void as_put_pte(struct tegra_smmu_as *as, dma_addr_t iova)
 static int tegra_smmu_map(struct iommu_domain *domain, unsigned long iova,
 			  phys_addr_t paddr, size_t size, int prot)
 {
-	struct tegra_smmu_as *as = domain->priv;
+	struct tegra_smmu_as *as = to_smmu_as(domain);
 	struct tegra_smmu *smmu = as->smmu;
 	unsigned long offset;
 	struct page *page;
@@ -548,7 +553,7 @@ static int tegra_smmu_map(struct iommu_domain *domain, unsigned long iova,
 static size_t tegra_smmu_unmap(struct iommu_domain *domain, unsigned long iova,
 			       size_t size)
 {
-	struct tegra_smmu_as *as = domain->priv;
+	struct tegra_smmu_as *as = to_smmu_as(domain);
 	struct tegra_smmu *smmu = as->smmu;
 	unsigned long offset;
 	struct page *page;
@@ -572,7 +577,7 @@ static size_t tegra_smmu_unmap(struct iommu_domain *domain, unsigned long iova,
 static phys_addr_t tegra_smmu_iova_to_phys(struct iommu_domain *domain,
 					   dma_addr_t iova)
 {
-	struct tegra_smmu_as *as = domain->priv;
+	struct tegra_smmu_as *as = to_smmu_as(domain);
 	struct page *page;
 	unsigned long pfn;
 	u32 *pte;
@@ -633,8 +638,8 @@ static void tegra_smmu_remove_device(struct device *dev)
 
 static const struct iommu_ops tegra_smmu_ops = {
 	.capable = tegra_smmu_capable,
-	.domain_init = tegra_smmu_domain_init,
-	.domain_destroy = tegra_smmu_domain_destroy,
+	.domain_alloc = tegra_smmu_domain_alloc,
+	.domain_free = tegra_smmu_domain_free,
 	.attach_dev = tegra_smmu_attach_dev,
 	.detach_dev = tegra_smmu_detach_dev,
 	.add_device = tegra_smmu_add_device,
-- 
1.8.4.5

