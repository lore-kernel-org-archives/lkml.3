Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757555AbbAZXww (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 18:52:52 -0500
Received: from 8bytes.org ([81.169.241.247]:50877 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757388AbbAZXvw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 18:51:52 -0500
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
Subject: [PATCH 13/15] iommu/rockchip: Make use of domain_alloc and domain_free
Date: Tue, 27 Jan 2015 00:51:43 +0100
Message-Id: <1422316305-19216-14-git-send-email-joro@8bytes.org>
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
 drivers/iommu/rockchip-iommu.c | 40 ++++++++++++++++++++++++----------------
 1 file changed, 24 insertions(+), 16 deletions(-)

diff --git a/drivers/iommu/rockchip-iommu.c b/drivers/iommu/rockchip-iommu.c
index 6a8b1ec..0646827 100644
--- a/drivers/iommu/rockchip-iommu.c
+++ b/drivers/iommu/rockchip-iommu.c
@@ -80,6 +80,8 @@ struct rk_iommu_domain {
 	u32 *dt; /* page directory table */
 	spinlock_t iommus_lock; /* lock for iommus list */
 	spinlock_t dt_lock; /* lock for modifying page directory table */
+
+	struct iommu_domain domain;
 };
 
 struct rk_iommu {
@@ -100,6 +102,11 @@ static inline void rk_table_flush(u32 *va, unsigned int count)
 	outer_flush_range(pa_start, pa_end);
 }
 
+static struct rk_iommu_domain *to_rk_domain(struct iommu_domain *dom)
+{
+	return container_of(dom, struct rk_iommu_domain, domain);
+}
+
 /**
  * Inspired by _wait_for in intel_drv.h
  * This is NOT safe for use in interrupt context.
@@ -503,7 +510,7 @@ static irqreturn_t rk_iommu_irq(int irq, void *dev_id)
 static phys_addr_t rk_iommu_iova_to_phys(struct iommu_domain *domain,
 					 dma_addr_t iova)
 {
-	struct rk_iommu_domain *rk_domain = domain->priv;
+	struct rk_iommu_domain *rk_domain = to_rk_domain(domain);
 	unsigned long flags;
 	phys_addr_t pt_phys, phys = 0;
 	u32 dte, pte;
@@ -639,7 +646,7 @@ unwind:
 static int rk_iommu_map(struct iommu_domain *domain, unsigned long _iova,
 			phys_addr_t paddr, size_t size, int prot)
 {
-	struct rk_iommu_domain *rk_domain = domain->priv;
+	struct rk_iommu_domain *rk_domain = to_rk_domain(domain);
 	unsigned long flags;
 	dma_addr_t iova = (dma_addr_t)_iova;
 	u32 *page_table, *pte_addr;
@@ -670,7 +677,7 @@ static int rk_iommu_map(struct iommu_domain *domain, unsigned long _iova,
 static size_t rk_iommu_unmap(struct iommu_domain *domain, unsigned long _iova,
 			     size_t size)
 {
-	struct rk_iommu_domain *rk_domain = domain->priv;
+	struct rk_iommu_domain *rk_domain = to_rk_domain(domain);
 	unsigned long flags;
 	dma_addr_t iova = (dma_addr_t)_iova;
 	phys_addr_t pt_phys;
@@ -726,7 +733,7 @@ static int rk_iommu_attach_device(struct iommu_domain *domain,
 				  struct device *dev)
 {
 	struct rk_iommu *iommu;
-	struct rk_iommu_domain *rk_domain = domain->priv;
+	struct rk_iommu_domain *rk_domain = to_rk_domain(domain);
 	unsigned long flags;
 	int ret;
 	phys_addr_t dte_addr;
@@ -778,7 +785,7 @@ static void rk_iommu_detach_device(struct iommu_domain *domain,
 				   struct device *dev)
 {
 	struct rk_iommu *iommu;
-	struct rk_iommu_domain *rk_domain = domain->priv;
+	struct rk_iommu_domain *rk_domain = to_rk_domain(domain);
 	unsigned long flags;
 
 	/* Allow 'virtual devices' (eg drm) to detach from domain */
@@ -804,13 +811,16 @@ static void rk_iommu_detach_device(struct iommu_domain *domain,
 	dev_info(dev, "Detached from iommu domain\n");
 }
 
-static int rk_iommu_domain_init(struct iommu_domain *domain)
+static struct iommu_domain *rk_iommu_domain_alloc(enum iommu_domain_type type)
 {
 	struct rk_iommu_domain *rk_domain;
 
+	if (type != IOMMU_DOMAIN_UNMANAGED)
+		return NULL;
+
 	rk_domain = kzalloc(sizeof(*rk_domain), GFP_KERNEL);
 	if (!rk_domain)
-		return -ENOMEM;
+		return NULL;
 
 	/*
 	 * rk32xx iommus use a 2 level pagetable.
@@ -827,17 +837,16 @@ static int rk_iommu_domain_init(struct iommu_domain *domain)
 	spin_lock_init(&rk_domain->dt_lock);
 	INIT_LIST_HEAD(&rk_domain->iommus);
 
-	domain->priv = rk_domain;
+	return &rk_domain->domain;
 
-	return 0;
 err_dt:
 	kfree(rk_domain);
-	return -ENOMEM;
+	return NULL;
 }
 
-static void rk_iommu_domain_destroy(struct iommu_domain *domain)
+static void rk_iommu_domain_free(struct iommu_domain *domain)
 {
-	struct rk_iommu_domain *rk_domain = domain->priv;
+	struct rk_iommu_domain *rk_domain = to_rk_domain(domain);
 	int i;
 
 	WARN_ON(!list_empty(&rk_domain->iommus));
@@ -852,8 +861,7 @@ static void rk_iommu_domain_destroy(struct iommu_domain *domain)
 	}
 
 	free_page((unsigned long)rk_domain->dt);
-	kfree(domain->priv);
-	domain->priv = NULL;
+	kfree(rk_domain);
 }
 
 static bool rk_iommu_is_dev_iommu_master(struct device *dev)
@@ -952,8 +960,8 @@ static void rk_iommu_remove_device(struct device *dev)
 }
 
 static const struct iommu_ops rk_iommu_ops = {
-	.domain_init = rk_iommu_domain_init,
-	.domain_destroy = rk_iommu_domain_destroy,
+	.domain_alloc = rk_iommu_domain_alloc,
+	.domain_free = rk_iommu_domain_free,
 	.attach_dev = rk_iommu_attach_device,
 	.detach_dev = rk_iommu_detach_device,
 	.map = rk_iommu_map,
-- 
1.8.4.5

