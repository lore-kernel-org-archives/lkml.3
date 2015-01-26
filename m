Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757874AbbAZX42 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 18:56:28 -0500
Received: from 8bytes.org ([81.169.241.247]:50836 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757215AbbAZXvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 18:51:50 -0500
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
Subject: [PATCH 06/15] iommu/arm-smmu: Make use of domain_alloc and domain_free
Date: Tue, 27 Jan 2015 00:51:36 +0100
Message-Id: <1422316305-19216-7-git-send-email-joro@8bytes.org>
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
 drivers/iommu/arm-smmu.c | 46 +++++++++++++++++++++++++++-------------------
 1 file changed, 27 insertions(+), 19 deletions(-)

diff --git a/drivers/iommu/arm-smmu.c b/drivers/iommu/arm-smmu.c
index 6cd47b7..dd62669 100644
--- a/drivers/iommu/arm-smmu.c
+++ b/drivers/iommu/arm-smmu.c
@@ -415,6 +415,7 @@ struct arm_smmu_domain {
 	struct arm_smmu_cfg		cfg;
 	enum arm_smmu_domain_stage	stage;
 	spinlock_t			lock;
+	struct iommu_domain		domain;
 };
 
 static DEFINE_SPINLOCK(arm_smmu_devices_lock);
@@ -430,6 +431,11 @@ static struct arm_smmu_option_prop arm_smmu_options[] = {
 	{ 0, NULL},
 };
 
+static struct arm_smmu_domain *to_smmu_domain(struct iommu_domain *dom)
+{
+	return container_of(dom, struct arm_smmu_domain, domain);
+}
+
 static void parse_driver_options(struct arm_smmu_device *smmu)
 {
 	int i = 0;
@@ -641,7 +647,7 @@ static irqreturn_t arm_smmu_context_fault(int irq, void *dev)
 	u32 fsr, far, fsynr, resume;
 	unsigned long iova;
 	struct iommu_domain *domain = dev;
-	struct arm_smmu_domain *smmu_domain = domain->priv;
+	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
 	struct arm_smmu_cfg *cfg = &smmu_domain->cfg;
 	struct arm_smmu_device *smmu = smmu_domain->smmu;
 	void __iomem *cb_base;
@@ -906,7 +912,7 @@ static int arm_smmu_init_domain_context(struct iommu_domain *domain,
 {
 	int irq, start, ret = 0;
 	unsigned long flags;
-	struct arm_smmu_domain *smmu_domain = domain->priv;
+	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
 	struct arm_smmu_cfg *cfg = &smmu_domain->cfg;
 
 	spin_lock_irqsave(&smmu_domain->lock, flags);
@@ -990,7 +996,7 @@ out_unlock:
 
 static void arm_smmu_destroy_domain_context(struct iommu_domain *domain)
 {
-	struct arm_smmu_domain *smmu_domain = domain->priv;
+	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
 	struct arm_smmu_device *smmu = smmu_domain->smmu;
 	struct arm_smmu_cfg *cfg = &smmu_domain->cfg;
 	void __iomem *cb_base;
@@ -1012,11 +1018,13 @@ static void arm_smmu_destroy_domain_context(struct iommu_domain *domain)
 	__arm_smmu_free_bitmap(smmu->context_map, cfg->cbndx);
 }
 
-static int arm_smmu_domain_init(struct iommu_domain *domain)
+static struct iommu_domain *arm_smmu_domain_alloc(enum iommu_domain_type type)
 {
 	struct arm_smmu_domain *smmu_domain;
 	pgd_t *pgd;
 
+	if (type != IOMMU_DOMAIN_UNMANAGED)
+		return NULL;
 	/*
 	 * Allocate the domain and initialise some of its data structures.
 	 * We can't really do anything meaningful until we've added a
@@ -1024,7 +1032,7 @@ static int arm_smmu_domain_init(struct iommu_domain *domain)
 	 */
 	smmu_domain = kzalloc(sizeof(*smmu_domain), GFP_KERNEL);
 	if (!smmu_domain)
-		return -ENOMEM;
+		return NULL;
 
 	pgd = kcalloc(PTRS_PER_PGD, sizeof(pgd_t), GFP_KERNEL);
 	if (!pgd)
@@ -1032,12 +1040,12 @@ static int arm_smmu_domain_init(struct iommu_domain *domain)
 	smmu_domain->cfg.pgd = pgd;
 
 	spin_lock_init(&smmu_domain->lock);
-	domain->priv = smmu_domain;
-	return 0;
+
+	return &smmu_domain->domain;
 
 out_free_domain:
 	kfree(smmu_domain);
-	return -ENOMEM;
+	return NULL;
 }
 
 static void arm_smmu_free_ptes(pmd_t *pmd)
@@ -1103,9 +1111,9 @@ static void arm_smmu_free_pgtables(struct arm_smmu_domain *smmu_domain)
 	kfree(pgd_base);
 }
 
-static void arm_smmu_domain_destroy(struct iommu_domain *domain)
+static void arm_smmu_domain_free(struct iommu_domain *domain)
 {
-	struct arm_smmu_domain *smmu_domain = domain->priv;
+	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
 
 	/*
 	 * Free the domain resources. We assume that all devices have
@@ -1243,7 +1251,7 @@ static void arm_smmu_domain_remove_master(struct arm_smmu_domain *smmu_domain,
 static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 {
 	int ret;
-	struct arm_smmu_domain *smmu_domain = domain->priv;
+	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
 	struct arm_smmu_device *smmu, *dom_smmu;
 	struct arm_smmu_master_cfg *cfg;
 
@@ -1292,7 +1300,7 @@ static int arm_smmu_attach_dev(struct iommu_domain *domain, struct device *dev)
 
 static void arm_smmu_detach_dev(struct iommu_domain *domain, struct device *dev)
 {
-	struct arm_smmu_domain *smmu_domain = domain->priv;
+	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
 	struct arm_smmu_master_cfg *cfg;
 
 	cfg = find_smmu_master_cfg(dev);
@@ -1540,7 +1548,7 @@ out_unlock:
 static int arm_smmu_map(struct iommu_domain *domain, unsigned long iova,
 			phys_addr_t paddr, size_t size, int prot)
 {
-	struct arm_smmu_domain *smmu_domain = domain->priv;
+	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
 
 	if (!smmu_domain)
 		return -ENODEV;
@@ -1552,7 +1560,7 @@ static size_t arm_smmu_unmap(struct iommu_domain *domain, unsigned long iova,
 			     size_t size)
 {
 	int ret;
-	struct arm_smmu_domain *smmu_domain = domain->priv;
+	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
 
 	ret = arm_smmu_handle_mapping(smmu_domain, iova, 0, size, 0);
 	arm_smmu_tlb_inv_context(smmu_domain);
@@ -1566,7 +1574,7 @@ static phys_addr_t arm_smmu_iova_to_phys(struct iommu_domain *domain,
 	pud_t pud;
 	pmd_t pmd;
 	pte_t pte;
-	struct arm_smmu_domain *smmu_domain = domain->priv;
+	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
 	struct arm_smmu_cfg *cfg = &smmu_domain->cfg;
 
 	pgdp = cfg->pgd;
@@ -1684,7 +1692,7 @@ static void arm_smmu_remove_device(struct device *dev)
 static int arm_smmu_domain_get_attr(struct iommu_domain *domain,
 				    enum iommu_attr attr, void *data)
 {
-	struct arm_smmu_domain *smmu_domain = domain->priv;
+	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
 
 	switch (attr) {
 	case DOMAIN_ATTR_NESTING:
@@ -1698,7 +1706,7 @@ static int arm_smmu_domain_get_attr(struct iommu_domain *domain,
 static int arm_smmu_domain_set_attr(struct iommu_domain *domain,
 				    enum iommu_attr attr, void *data)
 {
-	struct arm_smmu_domain *smmu_domain = domain->priv;
+	struct arm_smmu_domain *smmu_domain = to_smmu_domain(domain);
 
 	switch (attr) {
 	case DOMAIN_ATTR_NESTING:
@@ -1717,8 +1725,8 @@ static int arm_smmu_domain_set_attr(struct iommu_domain *domain,
 
 static const struct iommu_ops arm_smmu_ops = {
 	.capable		= arm_smmu_capable,
-	.domain_init		= arm_smmu_domain_init,
-	.domain_destroy		= arm_smmu_domain_destroy,
+	.domain_alloc		= arm_smmu_domain_alloc,
+	.domain_free		= arm_smmu_domain_free,
 	.attach_dev		= arm_smmu_attach_dev,
 	.detach_dev		= arm_smmu_detach_dev,
 	.map			= arm_smmu_map,
-- 
1.8.4.5

