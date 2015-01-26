Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757537AbbAZXwu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 18:52:50 -0500
Received: from 8bytes.org ([81.169.241.247]:50919 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757402AbbAZXvw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
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
Subject: [PATCH 12/15] iommu/ipmmu-vmsa: Make use of domain_alloc and domain_free
Date: Tue, 27 Jan 2015 00:51:42 +0100
Message-Id: <1422316305-19216-13-git-send-email-joro@8bytes.org>
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
 drivers/iommu/ipmmu-vmsa.c | 43 ++++++++++++++++++++++++-------------------
 1 file changed, 24 insertions(+), 19 deletions(-)

diff --git a/drivers/iommu/ipmmu-vmsa.c b/drivers/iommu/ipmmu-vmsa.c
index 7486931..12270e1 100644
--- a/drivers/iommu/ipmmu-vmsa.c
+++ b/drivers/iommu/ipmmu-vmsa.c
@@ -37,7 +37,7 @@ struct ipmmu_vmsa_device {
 
 struct ipmmu_vmsa_domain {
 	struct ipmmu_vmsa_device *mmu;
-	struct iommu_domain *io_domain;
+	struct iommu_domain io_domain;
 
 	unsigned int context_id;
 	spinlock_t lock;			/* Protects mappings */
@@ -52,6 +52,11 @@ struct ipmmu_vmsa_archdata {
 static DEFINE_SPINLOCK(ipmmu_devices_lock);
 static LIST_HEAD(ipmmu_devices);
 
+static struct ipmmu_vmsa_domain *to_vmsa_domain(struct iommu_domain *dom)
+{
+	return container_of(dom, struct ipmmu_vmsa_domain, io_domain);
+}
+
 #define TLB_LOOP_TIMEOUT		100	/* 100us */
 
 /* -----------------------------------------------------------------------------
@@ -435,7 +440,7 @@ static irqreturn_t ipmmu_domain_irq(struct ipmmu_vmsa_domain *domain)
 	 * TODO: We need to look up the faulty device based on the I/O VA. Use
 	 * the IOMMU device for now.
 	 */
-	if (!report_iommu_fault(domain->io_domain, mmu->dev, iova, 0))
+	if (!report_iommu_fault(&domain->io_domain, mmu->dev, iova, 0))
 		return IRQ_HANDLED;
 
 	dev_err_ratelimited(mmu->dev,
@@ -455,7 +460,7 @@ static irqreturn_t ipmmu_irq(int irq, void *dev)
 		return IRQ_NONE;
 
 	io_domain = mmu->mapping->domain;
-	domain = io_domain->priv;
+	domain = to_vmsa_domain(io_domain);
 
 	return ipmmu_domain_irq(domain);
 }
@@ -854,31 +859,31 @@ done:
  * IOMMU Operations
  */
 
-static int ipmmu_domain_init(struct iommu_domain *io_domain)
+static struct iommu_domain *ipmmu_domain_alloc(enum iommu_domain_type type)
 {
 	struct ipmmu_vmsa_domain *domain;
 
+	if (type != IOMMU_DOMAIN_UNMANAGED)
+		return NULL;
+
 	domain = kzalloc(sizeof(*domain), GFP_KERNEL);
 	if (!domain)
-		return -ENOMEM;
+		return NULL;
 
 	spin_lock_init(&domain->lock);
 
 	domain->pgd = kzalloc(IPMMU_PTRS_PER_PGD * sizeof(pgd_t), GFP_KERNEL);
 	if (!domain->pgd) {
 		kfree(domain);
-		return -ENOMEM;
+		return NULL;
 	}
 
-	io_domain->priv = domain;
-	domain->io_domain = io_domain;
-
-	return 0;
+	return &domain->io_domain;
 }
 
-static void ipmmu_domain_destroy(struct iommu_domain *io_domain)
+static void ipmmu_domain_free(struct iommu_domain *io_domain)
 {
-	struct ipmmu_vmsa_domain *domain = io_domain->priv;
+	struct ipmmu_vmsa_domain *domain = to_vmsa_domain(io_domain);
 
 	/*
 	 * Free the domain resources. We assume that all devices have already
@@ -894,7 +899,7 @@ static int ipmmu_attach_device(struct iommu_domain *io_domain,
 {
 	struct ipmmu_vmsa_archdata *archdata = dev->archdata.iommu;
 	struct ipmmu_vmsa_device *mmu = archdata->mmu;
-	struct ipmmu_vmsa_domain *domain = io_domain->priv;
+	struct ipmmu_vmsa_domain *domain = to_vmsa_domain(io_domain);
 	unsigned long flags;
 	int ret = 0;
 
@@ -933,7 +938,7 @@ static void ipmmu_detach_device(struct iommu_domain *io_domain,
 				struct device *dev)
 {
 	struct ipmmu_vmsa_archdata *archdata = dev->archdata.iommu;
-	struct ipmmu_vmsa_domain *domain = io_domain->priv;
+	struct ipmmu_vmsa_domain *domain = to_vmsa_domain(io_domain);
 
 	ipmmu_utlb_disable(domain, archdata->utlb);
 
@@ -945,7 +950,7 @@ static void ipmmu_detach_device(struct iommu_domain *io_domain,
 static int ipmmu_map(struct iommu_domain *io_domain, unsigned long iova,
 		     phys_addr_t paddr, size_t size, int prot)
 {
-	struct ipmmu_vmsa_domain *domain = io_domain->priv;
+	struct ipmmu_vmsa_domain *domain = to_vmsa_domain(io_domain);
 
 	if (!domain)
 		return -ENODEV;
@@ -956,7 +961,7 @@ static int ipmmu_map(struct iommu_domain *io_domain, unsigned long iova,
 static size_t ipmmu_unmap(struct iommu_domain *io_domain, unsigned long iova,
 			  size_t size)
 {
-	struct ipmmu_vmsa_domain *domain = io_domain->priv;
+	struct ipmmu_vmsa_domain *domain = to_vmsa_domain(io_domain);
 	int ret;
 
 	ret = ipmmu_clear_mapping(domain, iova, size);
@@ -966,7 +971,7 @@ static size_t ipmmu_unmap(struct iommu_domain *io_domain, unsigned long iova,
 static phys_addr_t ipmmu_iova_to_phys(struct iommu_domain *io_domain,
 				      dma_addr_t iova)
 {
-	struct ipmmu_vmsa_domain *domain = io_domain->priv;
+	struct ipmmu_vmsa_domain *domain = to_vmsa_domain(io_domain);
 	pgd_t pgd;
 	pud_t pud;
 	pmd_t pmd;
@@ -1121,8 +1126,8 @@ static void ipmmu_remove_device(struct device *dev)
 }
 
 static const struct iommu_ops ipmmu_ops = {
-	.domain_init = ipmmu_domain_init,
-	.domain_destroy = ipmmu_domain_destroy,
+	.domain_alloc = ipmmu_domain_alloc,
+	.domain_free = ipmmu_domain_free,
 	.attach_dev = ipmmu_attach_device,
 	.detach_dev = ipmmu_detach_device,
 	.map = ipmmu_map,
-- 
1.8.4.5

