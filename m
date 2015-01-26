Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757909AbbAZX5l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 18:57:41 -0500
Received: from 8bytes.org ([81.169.241.247]:50803 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757198AbbAZXvt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 18:51:49 -0500
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
Subject: [PATCH 05/15] iommu/omap: Make use of domain_alloc and domain_free
Date: Tue, 27 Jan 2015 00:51:35 +0100
Message-Id: <1422316305-19216-6-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422316305-19216-1-git-send-email-joro@8bytes.org>
References: <1422316305-19216-1-git-send-email-joro@8bytes.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Implement the new domain_alloc and domain_free call-backs
and remove the old domain_init/destroy ones.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 drivers/iommu/omap-iommu.c | 49 +++++++++++++++++++++++++++-------------------
 1 file changed, 29 insertions(+), 20 deletions(-)

diff --git a/drivers/iommu/omap-iommu.c b/drivers/iommu/omap-iommu.c
index f59f857..f10af50 100644
--- a/drivers/iommu/omap-iommu.c
+++ b/drivers/iommu/omap-iommu.c
@@ -59,6 +59,7 @@ struct omap_iommu_domain {
 	struct omap_iommu *iommu_dev;
 	struct device *dev;
 	spinlock_t lock;
+	struct iommu_domain domain;
 };
 
 #define MMU_LOCK_BASE_SHIFT	10
@@ -80,6 +81,15 @@ static struct platform_driver omap_iommu_driver;
 static struct kmem_cache *iopte_cachep;
 
 /**
+ * to_omap_domain - Get struct omap_iommu_domain from generic iommu_domain
+ * @dom:	generic iommu domain handle
+ **/
+static struct omap_iommu_domain *to_omap_domain(struct iommu_domain *dom)
+{
+	return container_of(dom, struct omap_iommu_domain, domain);
+}
+
+/**
  * omap_iommu_save_ctx - Save registers for pm off-mode support
  * @dev:	client device
  **/
@@ -901,7 +911,7 @@ static irqreturn_t iommu_fault_handler(int irq, void *data)
 	u32 *iopgd, *iopte;
 	struct omap_iommu *obj = data;
 	struct iommu_domain *domain = obj->domain;
-	struct omap_iommu_domain *omap_domain = domain->priv;
+	struct omap_iommu_domain *omap_domain = to_omap_domain(domain);
 
 	if (!omap_domain->iommu_dev)
 		return IRQ_NONE;
@@ -1113,7 +1123,7 @@ static u32 iotlb_init_entry(struct iotlb_entry *e, u32 da, u32 pa, int pgsz)
 static int omap_iommu_map(struct iommu_domain *domain, unsigned long da,
 			 phys_addr_t pa, size_t bytes, int prot)
 {
-	struct omap_iommu_domain *omap_domain = domain->priv;
+	struct omap_iommu_domain *omap_domain = to_omap_domain(domain);
 	struct omap_iommu *oiommu = omap_domain->iommu_dev;
 	struct device *dev = oiommu->dev;
 	struct iotlb_entry e;
@@ -1140,7 +1150,7 @@ static int omap_iommu_map(struct iommu_domain *domain, unsigned long da,
 static size_t omap_iommu_unmap(struct iommu_domain *domain, unsigned long da,
 			    size_t size)
 {
-	struct omap_iommu_domain *omap_domain = domain->priv;
+	struct omap_iommu_domain *omap_domain = to_omap_domain(domain);
 	struct omap_iommu *oiommu = omap_domain->iommu_dev;
 	struct device *dev = oiommu->dev;
 
@@ -1152,7 +1162,7 @@ static size_t omap_iommu_unmap(struct iommu_domain *domain, unsigned long da,
 static int
 omap_iommu_attach_dev(struct iommu_domain *domain, struct device *dev)
 {
-	struct omap_iommu_domain *omap_domain = domain->priv;
+	struct omap_iommu_domain *omap_domain = to_omap_domain(domain);
 	struct omap_iommu *oiommu;
 	struct omap_iommu_arch_data *arch_data = dev->archdata.iommu;
 	int ret = 0;
@@ -1212,17 +1222,20 @@ static void _omap_iommu_detach_dev(struct omap_iommu_domain *omap_domain,
 static void omap_iommu_detach_dev(struct iommu_domain *domain,
 				 struct device *dev)
 {
-	struct omap_iommu_domain *omap_domain = domain->priv;
+	struct omap_iommu_domain *omap_domain = to_omap_domain(domain);
 
 	spin_lock(&omap_domain->lock);
 	_omap_iommu_detach_dev(omap_domain, dev);
 	spin_unlock(&omap_domain->lock);
 }
 
-static int omap_iommu_domain_init(struct iommu_domain *domain)
+static struct iommu_domain *omap_iommu_domain_alloc(enum iommu_domain_type type)
 {
 	struct omap_iommu_domain *omap_domain;
 
+	if (type != IOMMU_DOMAIN_UNMANAGED)
+		return NULL;
+
 	omap_domain = kzalloc(sizeof(*omap_domain), GFP_KERNEL);
 	if (!omap_domain) {
 		pr_err("kzalloc failed\n");
@@ -1244,25 +1257,21 @@ static int omap_iommu_domain_init(struct iommu_domain *domain)
 	clean_dcache_area(omap_domain->pgtable, IOPGD_TABLE_SIZE);
 	spin_lock_init(&omap_domain->lock);
 
-	domain->priv = omap_domain;
+	omap_domain->domain.geometry.aperture_start = 0;
+	omap_domain->domain.geometry.aperture_end   = (1ULL << 32) - 1;
+	omap_domain->domain.geometry.force_aperture = true;
 
-	domain->geometry.aperture_start = 0;
-	domain->geometry.aperture_end   = (1ULL << 32) - 1;
-	domain->geometry.force_aperture = true;
-
-	return 0;
+	return &omap_domain->domain;
 
 fail_nomem:
 	kfree(omap_domain);
 out:
-	return -ENOMEM;
+	return NULL;
 }
 
-static void omap_iommu_domain_destroy(struct iommu_domain *domain)
+static void omap_iommu_domain_free(struct iommu_domain *domain)
 {
-	struct omap_iommu_domain *omap_domain = domain->priv;
-
-	domain->priv = NULL;
+	struct omap_iommu_domain *omap_domain = to_omap_domain(domain);
 
 	/*
 	 * An iommu device is still attached
@@ -1278,7 +1287,7 @@ static void omap_iommu_domain_destroy(struct iommu_domain *domain)
 static phys_addr_t omap_iommu_iova_to_phys(struct iommu_domain *domain,
 					  dma_addr_t da)
 {
-	struct omap_iommu_domain *omap_domain = domain->priv;
+	struct omap_iommu_domain *omap_domain = to_omap_domain(domain);
 	struct omap_iommu *oiommu = omap_domain->iommu_dev;
 	struct device *dev = oiommu->dev;
 	u32 *pgd, *pte;
@@ -1358,8 +1367,8 @@ static void omap_iommu_remove_device(struct device *dev)
 }
 
 static const struct iommu_ops omap_iommu_ops = {
-	.domain_init	= omap_iommu_domain_init,
-	.domain_destroy	= omap_iommu_domain_destroy,
+	.domain_alloc	= omap_iommu_domain_alloc,
+	.domain_free	= omap_iommu_domain_free,
 	.attach_dev	= omap_iommu_attach_dev,
 	.detach_dev	= omap_iommu_detach_dev,
 	.map		= omap_iommu_map,
-- 
1.8.4.5

