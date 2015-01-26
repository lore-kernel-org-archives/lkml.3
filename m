Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757889AbbAZX4b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 18:56:31 -0500
Received: from 8bytes.org ([81.169.241.247]:50834 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757203AbbAZXvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
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
Subject: [PATCH 04/15] iommu/vt-d: Make use of domain_alloc and domain_free
Date: Tue, 27 Jan 2015 00:51:34 +0100
Message-Id: <1422316305-19216-5-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422316305-19216-1-git-send-email-joro@8bytes.org>
References: <1422316305-19216-1-git-send-email-joro@8bytes.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

Get rid of domain_init and domain_destroy and implement
domain_alloc/domain_free instead.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 drivers/iommu/intel-iommu.c | 48 ++++++++++++++++++++++++++-------------------
 1 file changed, 28 insertions(+), 20 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 40dfbc0..f3e979f 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -336,7 +336,7 @@ struct dmar_domain {
 	DECLARE_BITMAP(iommu_bmp, DMAR_UNITS_SUPPORTED);
 					/* bitmap of iommus this domain uses*/
 
-	struct list_head devices; 	/* all devices' list */
+	struct list_head devices;	/* all devices' list */
 	struct iova_domain iovad;	/* iova's that belong to this domain */
 
 	struct dma_pte	*pgd;		/* virtual address */
@@ -355,6 +355,9 @@ struct dmar_domain {
 					   2 == 1GiB, 3 == 512GiB, 4 == 1TiB */
 	spinlock_t	iommu_lock;	/* protect iommu set in domain */
 	u64		max_addr;	/* maximum mapped address */
+
+	struct iommu_domain domain;	/* generic domain data structure for
+					   iommu core */
 };
 
 /* PCI domain-device relationship */
@@ -446,6 +449,12 @@ static LIST_HEAD(device_domain_list);
 
 static const struct iommu_ops intel_iommu_ops;
 
+/* Convert generic 'struct iommu_domain to private struct dmar_domain */
+static struct dmar_domain *to_dmar_domain(struct iommu_domain *dom)
+{
+	return container_of(dom, struct dmar_domain, domain);
+}
+
 static int __init intel_iommu_setup(char *str)
 {
 	if (!str)
@@ -4363,44 +4372,45 @@ static int md_domain_init(struct dmar_domain *domain, int guest_width)
 	return 0;
 }
 
-static int intel_iommu_domain_init(struct iommu_domain *domain)
+static struct iommu_domain *intel_iommu_domain_alloc(enum iommu_domain_type type)
 {
 	struct dmar_domain *dmar_domain;
+	struct iommu_domain *domain;
+
+	if (type != IOMMU_DOMAIN_UNMANAGED)
+		return NULL;
 
 	dmar_domain = alloc_domain(DOMAIN_FLAG_VIRTUAL_MACHINE);
 	if (!dmar_domain) {
 		printk(KERN_ERR
 			"intel_iommu_domain_init: dmar_domain == NULL\n");
-		return -ENOMEM;
+		return NULL;
 	}
 	if (md_domain_init(dmar_domain, DEFAULT_DOMAIN_ADDRESS_WIDTH)) {
 		printk(KERN_ERR
 			"intel_iommu_domain_init() failed\n");
 		domain_exit(dmar_domain);
-		return -ENOMEM;
+		return NULL;
 	}
 	domain_update_iommu_cap(dmar_domain);
-	domain->priv = dmar_domain;
 
+	domain = &dmar_domain->domain;
 	domain->geometry.aperture_start = 0;
 	domain->geometry.aperture_end   = __DOMAIN_MAX_ADDR(dmar_domain->gaw);
 	domain->geometry.force_aperture = true;
 
-	return 0;
+	return domain;
 }
 
-static void intel_iommu_domain_destroy(struct iommu_domain *domain)
+static void intel_iommu_domain_free(struct iommu_domain *domain)
 {
-	struct dmar_domain *dmar_domain = domain->priv;
-
-	domain->priv = NULL;
-	domain_exit(dmar_domain);
+	domain_exit(to_dmar_domain(domain));
 }
 
 static int intel_iommu_attach_device(struct iommu_domain *domain,
 				     struct device *dev)
 {
-	struct dmar_domain *dmar_domain = domain->priv;
+	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
 	struct intel_iommu *iommu;
 	int addr_width;
 	u8 bus, devfn;
@@ -4465,16 +4475,14 @@ static int intel_iommu_attach_device(struct iommu_domain *domain,
 static void intel_iommu_detach_device(struct iommu_domain *domain,
 				      struct device *dev)
 {
-	struct dmar_domain *dmar_domain = domain->priv;
-
-	domain_remove_one_dev_info(dmar_domain, dev);
+	domain_remove_one_dev_info(to_dmar_domain(domain), dev);
 }
 
 static int intel_iommu_map(struct iommu_domain *domain,
 			   unsigned long iova, phys_addr_t hpa,
 			   size_t size, int iommu_prot)
 {
-	struct dmar_domain *dmar_domain = domain->priv;
+	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
 	u64 max_addr;
 	int prot = 0;
 	int ret;
@@ -4511,7 +4519,7 @@ static int intel_iommu_map(struct iommu_domain *domain,
 static size_t intel_iommu_unmap(struct iommu_domain *domain,
 				unsigned long iova, size_t size)
 {
-	struct dmar_domain *dmar_domain = domain->priv;
+	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
 	struct page *freelist = NULL;
 	struct intel_iommu *iommu;
 	unsigned long start_pfn, last_pfn;
@@ -4559,7 +4567,7 @@ static size_t intel_iommu_unmap(struct iommu_domain *domain,
 static phys_addr_t intel_iommu_iova_to_phys(struct iommu_domain *domain,
 					    dma_addr_t iova)
 {
-	struct dmar_domain *dmar_domain = domain->priv;
+	struct dmar_domain *dmar_domain = to_dmar_domain(domain);
 	struct dma_pte *pte;
 	int level = 0;
 	u64 phys = 0;
@@ -4618,8 +4626,8 @@ static void intel_iommu_remove_device(struct device *dev)
 
 static const struct iommu_ops intel_iommu_ops = {
 	.capable	= intel_iommu_capable,
-	.domain_init	= intel_iommu_domain_init,
-	.domain_destroy = intel_iommu_domain_destroy,
+	.domain_alloc	= intel_iommu_domain_alloc,
+	.domain_free	= intel_iommu_domain_free,
 	.attach_dev	= intel_iommu_attach_device,
 	.detach_dev	= intel_iommu_detach_device,
 	.map		= intel_iommu_map,
-- 
1.8.4.5

