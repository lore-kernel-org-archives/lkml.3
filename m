Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490AbbAZXwE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 18:52:04 -0500
Received: from 8bytes.org ([81.169.241.247]:50790 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753431AbbAZXvs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 18:51:48 -0500
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
Subject: [PATCH 03/15] iommu/amd: Make use of domain_alloc and domain_free
Date: Tue, 27 Jan 2015 00:51:33 +0100
Message-Id: <1422316305-19216-4-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422316305-19216-1-git-send-email-joro@8bytes.org>
References: <1422316305-19216-1-git-send-email-joro@8bytes.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Implement the new iommu-ops function pointers and remove the
obsolete domain_init and domain_destroy functions.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 drivers/iommu/amd_iommu.c       | 84 ++++++++++++++++++++++-------------------
 drivers/iommu/amd_iommu_types.h |  7 ++--
 2 files changed, 48 insertions(+), 43 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 9802485..dfcddf5 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -126,6 +126,11 @@ static int __init alloc_passthrough_domain(void);
  *
  ****************************************************************************/
 
+static struct protection_domain *to_pdomain(struct iommu_domain *dom)
+{
+	return container_of(dom, struct protection_domain, domain);
+}
+
 static struct iommu_dev_data *alloc_dev_data(u16 devid)
 {
 	struct iommu_dev_data *dev_data;
@@ -3236,42 +3241,45 @@ static int __init alloc_passthrough_domain(void)
 
 	return 0;
 }
-static int amd_iommu_domain_init(struct iommu_domain *dom)
+
+static struct iommu_domain *amd_iommu_domain_alloc(enum iommu_domain_type type)
 {
-	struct protection_domain *domain;
+	struct protection_domain *pdomain;
 
-	domain = protection_domain_alloc();
-	if (!domain)
-		goto out_free;
+	/* We only support unmanaged domains for now */
+	if (type != IOMMU_DOMAIN_UNMANAGED)
+		return NULL;
 
-	domain->mode    = PAGE_MODE_3_LEVEL;
-	domain->pt_root = (void *)get_zeroed_page(GFP_KERNEL);
-	if (!domain->pt_root)
+	pdomain = protection_domain_alloc();
+	if (!pdomain)
 		goto out_free;
 
-	domain->iommu_domain = dom;
-
-	dom->priv = domain;
+	pdomain->mode    = PAGE_MODE_3_LEVEL;
+	pdomain->pt_root = (void *)get_zeroed_page(GFP_KERNEL);
+	if (!pdomain->pt_root)
+		goto out_free;
 
-	dom->geometry.aperture_start = 0;
-	dom->geometry.aperture_end   = ~0ULL;
-	dom->geometry.force_aperture = true;
+	pdomain->domain.geometry.aperture_start = 0;
+	pdomain->domain.geometry.aperture_end   = ~0ULL;
+	pdomain->domain.geometry.force_aperture = true;
 
-	return 0;
+	return &pdomain->domain;
 
 out_free:
-	protection_domain_free(domain);
+	protection_domain_free(pdomain);
 
-	return -ENOMEM;
+	return NULL;
 }
 
-static void amd_iommu_domain_destroy(struct iommu_domain *dom)
+static void amd_iommu_domain_free(struct iommu_domain *dom)
 {
-	struct protection_domain *domain = dom->priv;
+	struct protection_domain *domain;
 
-	if (!domain)
+	if (!dom)
 		return;
 
+	domain = to_pdomain(dom);
+
 	if (domain->dev_cnt > 0)
 		cleanup_domain(domain);
 
@@ -3284,8 +3292,6 @@ static void amd_iommu_domain_destroy(struct iommu_domain *dom)
 		free_gcr3_table(domain);
 
 	protection_domain_free(domain);
-
-	dom->priv = NULL;
 }
 
 static void amd_iommu_detach_device(struct iommu_domain *dom,
@@ -3313,7 +3319,7 @@ static void amd_iommu_detach_device(struct iommu_domain *dom,
 static int amd_iommu_attach_device(struct iommu_domain *dom,
 				   struct device *dev)
 {
-	struct protection_domain *domain = dom->priv;
+	struct protection_domain *domain = to_pdomain(dom);
 	struct iommu_dev_data *dev_data;
 	struct amd_iommu *iommu;
 	int ret;
@@ -3340,7 +3346,7 @@ static int amd_iommu_attach_device(struct iommu_domain *dom,
 static int amd_iommu_map(struct iommu_domain *dom, unsigned long iova,
 			 phys_addr_t paddr, size_t page_size, int iommu_prot)
 {
-	struct protection_domain *domain = dom->priv;
+	struct protection_domain *domain = to_pdomain(dom);
 	int prot = 0;
 	int ret;
 
@@ -3362,7 +3368,7 @@ static int amd_iommu_map(struct iommu_domain *dom, unsigned long iova,
 static size_t amd_iommu_unmap(struct iommu_domain *dom, unsigned long iova,
 			   size_t page_size)
 {
-	struct protection_domain *domain = dom->priv;
+	struct protection_domain *domain = to_pdomain(dom);
 	size_t unmap_size;
 
 	if (domain->mode == PAGE_MODE_NONE)
@@ -3380,7 +3386,7 @@ static size_t amd_iommu_unmap(struct iommu_domain *dom, unsigned long iova,
 static phys_addr_t amd_iommu_iova_to_phys(struct iommu_domain *dom,
 					  dma_addr_t iova)
 {
-	struct protection_domain *domain = dom->priv;
+	struct protection_domain *domain = to_pdomain(dom);
 	unsigned long offset_mask;
 	phys_addr_t paddr;
 	u64 *pte, __pte;
@@ -3420,8 +3426,8 @@ static bool amd_iommu_capable(enum iommu_cap cap)
 
 static const struct iommu_ops amd_iommu_ops = {
 	.capable = amd_iommu_capable,
-	.domain_init = amd_iommu_domain_init,
-	.domain_destroy = amd_iommu_domain_destroy,
+	.domain_alloc = amd_iommu_domain_alloc,
+	.domain_free  = amd_iommu_domain_free,
 	.attach_dev = amd_iommu_attach_device,
 	.detach_dev = amd_iommu_detach_device,
 	.map = amd_iommu_map,
@@ -3483,7 +3489,7 @@ EXPORT_SYMBOL(amd_iommu_unregister_ppr_notifier);
 
 void amd_iommu_domain_direct_map(struct iommu_domain *dom)
 {
-	struct protection_domain *domain = dom->priv;
+	struct protection_domain *domain = to_pdomain(dom);
 	unsigned long flags;
 
 	spin_lock_irqsave(&domain->lock, flags);
@@ -3504,7 +3510,7 @@ EXPORT_SYMBOL(amd_iommu_domain_direct_map);
 
 int amd_iommu_domain_enable_v2(struct iommu_domain *dom, int pasids)
 {
-	struct protection_domain *domain = dom->priv;
+	struct protection_domain *domain = to_pdomain(dom);
 	unsigned long flags;
 	int levels, ret;
 
@@ -3616,7 +3622,7 @@ static int __amd_iommu_flush_page(struct protection_domain *domain, int pasid,
 int amd_iommu_flush_page(struct iommu_domain *dom, int pasid,
 			 u64 address)
 {
-	struct protection_domain *domain = dom->priv;
+	struct protection_domain *domain = to_pdomain(dom);
 	unsigned long flags;
 	int ret;
 
@@ -3638,7 +3644,7 @@ static int __amd_iommu_flush_tlb(struct protection_domain *domain, int pasid)
 
 int amd_iommu_flush_tlb(struct iommu_domain *dom, int pasid)
 {
-	struct protection_domain *domain = dom->priv;
+	struct protection_domain *domain = to_pdomain(dom);
 	unsigned long flags;
 	int ret;
 
@@ -3718,7 +3724,7 @@ static int __clear_gcr3(struct protection_domain *domain, int pasid)
 int amd_iommu_domain_set_gcr3(struct iommu_domain *dom, int pasid,
 			      unsigned long cr3)
 {
-	struct protection_domain *domain = dom->priv;
+	struct protection_domain *domain = to_pdomain(dom);
 	unsigned long flags;
 	int ret;
 
@@ -3732,7 +3738,7 @@ EXPORT_SYMBOL(amd_iommu_domain_set_gcr3);
 
 int amd_iommu_domain_clear_gcr3(struct iommu_domain *dom, int pasid)
 {
-	struct protection_domain *domain = dom->priv;
+	struct protection_domain *domain = to_pdomain(dom);
 	unsigned long flags;
 	int ret;
 
@@ -3765,17 +3771,17 @@ EXPORT_SYMBOL(amd_iommu_complete_ppr);
 
 struct iommu_domain *amd_iommu_get_v2_domain(struct pci_dev *pdev)
 {
-	struct protection_domain *domain;
+	struct protection_domain *pdomain;
 
-	domain = get_domain(&pdev->dev);
-	if (IS_ERR(domain))
+	pdomain = get_domain(&pdev->dev);
+	if (IS_ERR(pdomain))
 		return NULL;
 
 	/* Only return IOMMUv2 domains */
-	if (!(domain->flags & PD_IOMMUV2_MASK))
+	if (!(pdomain->flags & PD_IOMMUV2_MASK))
 		return NULL;
 
-	return domain->iommu_domain;
+	return &pdomain->domain;
 }
 EXPORT_SYMBOL(amd_iommu_get_v2_domain);
 
diff --git a/drivers/iommu/amd_iommu_types.h b/drivers/iommu/amd_iommu_types.h
index cec51a8..b029654 100644
--- a/drivers/iommu/amd_iommu_types.h
+++ b/drivers/iommu/amd_iommu_types.h
@@ -400,6 +400,8 @@ struct iommu_domain;
 struct protection_domain {
 	struct list_head list;  /* for list of all protection domains */
 	struct list_head dev_list; /* List of all devices in this domain */
+	struct iommu_domain domain; /* generic domain handle used by
+				       iommu core code */
 	spinlock_t lock;	/* mostly used to lock the page table*/
 	struct mutex api_lock;	/* protect page tables in the iommu-api path */
 	u16 id;			/* the domain id written to the device table */
@@ -411,10 +413,7 @@ struct protection_domain {
 	bool updated;		/* complete domain flush required */
 	unsigned dev_cnt;	/* devices assigned to this domain */
 	unsigned dev_iommu[MAX_IOMMUS]; /* per-IOMMU reference count */
-	void *priv;		/* private data */
-	struct iommu_domain *iommu_domain; /* Pointer to generic
-					      domain structure */
-
+	void *priv;             /* private data */
 };
 
 /*
-- 
1.8.4.5

