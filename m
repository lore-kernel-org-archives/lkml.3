Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757686AbbAZXyz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 18:54:55 -0500
Received: from 8bytes.org ([81.169.241.247]:50862 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757263AbbAZXvv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
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
Subject: [PATCH 07/15] iommu/exynos: Make use of domain_alloc and domain_free
Date: Tue, 27 Jan 2015 00:51:37 +0100
Message-Id: <1422316305-19216-8-git-send-email-joro@8bytes.org>
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
 drivers/iommu/exynos-iommu.c | 87 ++++++++++++++++++++++++--------------------
 1 file changed, 47 insertions(+), 40 deletions(-)

diff --git a/drivers/iommu/exynos-iommu.c b/drivers/iommu/exynos-iommu.c
index 7ce5273..d103cbf 100644
--- a/drivers/iommu/exynos-iommu.c
+++ b/drivers/iommu/exynos-iommu.c
@@ -200,6 +200,7 @@ struct exynos_iommu_domain {
 	short *lv2entcnt; /* free lv2 entry counter for each section */
 	spinlock_t lock; /* lock for this structure */
 	spinlock_t pgtablelock; /* lock for modifying page table @ pgtable */
+	struct iommu_domain domain; /* generic domain data structure */
 };
 
 struct sysmmu_drvdata {
@@ -214,6 +215,11 @@ struct sysmmu_drvdata {
 	phys_addr_t pgtable;
 };
 
+static struct exynos_iommu_domain *to_exynos_domain(struct iommu_domain *dom)
+{
+	return container_of(dom, struct exynos_iommu_domain, domain);
+}
+
 static bool set_sysmmu_active(struct sysmmu_drvdata *data)
 {
 	/* return true if the System MMU was not active previously
@@ -696,58 +702,60 @@ static inline void pgtable_flush(void *vastart, void *vaend)
 				virt_to_phys(vaend));
 }
 
-static int exynos_iommu_domain_init(struct iommu_domain *domain)
+static struct iommu_domain *exynos_iommu_domain_alloc(enum iommu_domain_type type)
 {
-	struct exynos_iommu_domain *priv;
+	struct exynos_iommu_domain *exynos_domain;
 	int i;
 
-	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
-	if (!priv)
-		return -ENOMEM;
+	if (type != IOMMU_DOMAIN_UNMANAGED)
+		return NULL;
+
+	exynos_domain = kzalloc(sizeof(*exynos_domain), GFP_KERNEL);
+	if (!exynos_domain)
+		return NULL;
 
-	priv->pgtable = (sysmmu_pte_t *)__get_free_pages(GFP_KERNEL, 2);
-	if (!priv->pgtable)
+	exynos_domain->pgtable = (sysmmu_pte_t *)__get_free_pages(GFP_KERNEL, 2);
+	if (!exynos_domain->pgtable)
 		goto err_pgtable;
 
-	priv->lv2entcnt = (short *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, 1);
-	if (!priv->lv2entcnt)
+	exynos_domain->lv2entcnt = (short *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, 1);
+	if (!exynos_domain->lv2entcnt)
 		goto err_counter;
 
 	/* Workaround for System MMU v3.3 to prevent caching 1MiB mapping */
 	for (i = 0; i < NUM_LV1ENTRIES; i += 8) {
-		priv->pgtable[i + 0] = ZERO_LV2LINK;
-		priv->pgtable[i + 1] = ZERO_LV2LINK;
-		priv->pgtable[i + 2] = ZERO_LV2LINK;
-		priv->pgtable[i + 3] = ZERO_LV2LINK;
-		priv->pgtable[i + 4] = ZERO_LV2LINK;
-		priv->pgtable[i + 5] = ZERO_LV2LINK;
-		priv->pgtable[i + 6] = ZERO_LV2LINK;
-		priv->pgtable[i + 7] = ZERO_LV2LINK;
+		exynos_domain->pgtable[i + 0] = ZERO_LV2LINK;
+		exynos_domain->pgtable[i + 1] = ZERO_LV2LINK;
+		exynos_domain->pgtable[i + 2] = ZERO_LV2LINK;
+		exynos_domain->pgtable[i + 3] = ZERO_LV2LINK;
+		exynos_domain->pgtable[i + 4] = ZERO_LV2LINK;
+		exynos_domain->pgtable[i + 5] = ZERO_LV2LINK;
+		exynos_domain->pgtable[i + 6] = ZERO_LV2LINK;
+		exynos_domain->pgtable[i + 7] = ZERO_LV2LINK;
 	}
 
-	pgtable_flush(priv->pgtable, priv->pgtable + NUM_LV1ENTRIES);
+	pgtable_flush(exynos_domain->pgtable, exynos_domain->pgtable + NUM_LV1ENTRIES);
 
-	spin_lock_init(&priv->lock);
-	spin_lock_init(&priv->pgtablelock);
-	INIT_LIST_HEAD(&priv->clients);
+	spin_lock_init(&exynos_domain->lock);
+	spin_lock_init(&exynos_domain->pgtablelock);
+	INIT_LIST_HEAD(&exynos_domain->clients);
 
-	domain->geometry.aperture_start = 0;
-	domain->geometry.aperture_end   = ~0UL;
-	domain->geometry.force_aperture = true;
+	exynos_domain->domain.geometry.aperture_start = 0;
+	exynos_domain->domain.geometry.aperture_end   = ~0UL;
+	exynos_domain->domain.geometry.force_aperture = true;
 
-	domain->priv = priv;
-	return 0;
+	return &exynos_domain->domain;
 
 err_counter:
-	free_pages((unsigned long)priv->pgtable, 2);
+	free_pages((unsigned long)exynos_domain->pgtable, 2);
 err_pgtable:
-	kfree(priv);
-	return -ENOMEM;
+	kfree(exynos_domain);
+	return NULL;
 }
 
-static void exynos_iommu_domain_destroy(struct iommu_domain *domain)
+static void exynos_iommu_domain_free(struct iommu_domain *domain)
 {
-	struct exynos_iommu_domain *priv = domain->priv;
+	struct exynos_iommu_domain *priv = to_exynos_domain(domain);
 	struct exynos_iommu_owner *owner;
 	unsigned long flags;
 	int i;
@@ -773,15 +781,14 @@ static void exynos_iommu_domain_destroy(struct iommu_domain *domain)
 
 	free_pages((unsigned long)priv->pgtable, 2);
 	free_pages((unsigned long)priv->lv2entcnt, 1);
-	kfree(domain->priv);
-	domain->priv = NULL;
+	kfree(priv);
 }
 
 static int exynos_iommu_attach_device(struct iommu_domain *domain,
 				   struct device *dev)
 {
 	struct exynos_iommu_owner *owner = dev->archdata.iommu;
-	struct exynos_iommu_domain *priv = domain->priv;
+	struct exynos_iommu_domain *priv = to_exynos_domain(domain);
 	phys_addr_t pagetable = virt_to_phys(priv->pgtable);
 	unsigned long flags;
 	int ret;
@@ -812,7 +819,7 @@ static void exynos_iommu_detach_device(struct iommu_domain *domain,
 				    struct device *dev)
 {
 	struct exynos_iommu_owner *owner;
-	struct exynos_iommu_domain *priv = domain->priv;
+	struct exynos_iommu_domain *priv = to_exynos_domain(domain);
 	phys_addr_t pagetable = virt_to_phys(priv->pgtable);
 	unsigned long flags;
 
@@ -988,7 +995,7 @@ static int lv2set_page(sysmmu_pte_t *pent, phys_addr_t paddr, size_t size,
 static int exynos_iommu_map(struct iommu_domain *domain, unsigned long l_iova,
 			 phys_addr_t paddr, size_t size, int prot)
 {
-	struct exynos_iommu_domain *priv = domain->priv;
+	struct exynos_iommu_domain *priv = to_exynos_domain(domain);
 	sysmmu_pte_t *entry;
 	sysmmu_iova_t iova = (sysmmu_iova_t)l_iova;
 	unsigned long flags;
@@ -1042,7 +1049,7 @@ static void exynos_iommu_tlb_invalidate_entry(struct exynos_iommu_domain *priv,
 static size_t exynos_iommu_unmap(struct iommu_domain *domain,
 					unsigned long l_iova, size_t size)
 {
-	struct exynos_iommu_domain *priv = domain->priv;
+	struct exynos_iommu_domain *priv = to_exynos_domain(domain);
 	sysmmu_iova_t iova = (sysmmu_iova_t)l_iova;
 	sysmmu_pte_t *ent;
 	size_t err_pgsize;
@@ -1119,7 +1126,7 @@ err:
 static phys_addr_t exynos_iommu_iova_to_phys(struct iommu_domain *domain,
 					  dma_addr_t iova)
 {
-	struct exynos_iommu_domain *priv = domain->priv;
+	struct exynos_iommu_domain *priv = to_exynos_domain(domain);
 	sysmmu_pte_t *entry;
 	unsigned long flags;
 	phys_addr_t phys = 0;
@@ -1171,8 +1178,8 @@ static void exynos_iommu_remove_device(struct device *dev)
 }
 
 static const struct iommu_ops exynos_iommu_ops = {
-	.domain_init = exynos_iommu_domain_init,
-	.domain_destroy = exynos_iommu_domain_destroy,
+	.domain_alloc = exynos_iommu_domain_alloc,
+	.domain_free = exynos_iommu_domain_free,
 	.attach_dev = exynos_iommu_attach_device,
 	.detach_dev = exynos_iommu_detach_device,
 	.map = exynos_iommu_map,
-- 
1.8.4.5

