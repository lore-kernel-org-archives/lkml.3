Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757842AbbAZX4W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 18:56:22 -0500
Received: from 8bytes.org ([81.169.241.247]:50845 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757382AbbAZXvu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
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
Subject: [PATCH 09/15] iommu/tegra-gart: Make use of domain_alloc and domain_free
Date: Tue, 27 Jan 2015 00:51:39 +0100
Message-Id: <1422316305-19216-10-git-send-email-joro@8bytes.org>
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
 drivers/iommu/tegra-gart.c | 67 +++++++++++++++++++++++++++++++---------------
 1 file changed, 46 insertions(+), 21 deletions(-)

diff --git a/drivers/iommu/tegra-gart.c b/drivers/iommu/tegra-gart.c
index f722a0c..34ca333 100644
--- a/drivers/iommu/tegra-gart.c
+++ b/drivers/iommu/tegra-gart.c
@@ -63,11 +63,21 @@ struct gart_device {
 	struct device		*dev;
 };
 
+struct gart_domain {
+	struct iommu_domain domain;		/* generic domain handle */
+	struct gart_device *gart;		/* link to gart device   */
+};
+
 static struct gart_device *gart_handle; /* unique for a system */
 
 #define GART_PTE(_pfn)						\
 	(GART_ENTRY_PHYS_ADDR_VALID | ((_pfn) << PAGE_SHIFT))
 
+static struct gart_domain *to_gart_domain(struct iommu_domain *dom)
+{
+	return container_of(dom, struct gart_domain, domain);
+}
+
 /*
  * Any interaction between any block on PPSB and a block on APB or AHB
  * must have these read-back to ensure the APB/AHB bus transaction is
@@ -156,6 +166,7 @@ static inline bool gart_iova_range_valid(struct gart_device *gart,
 static int gart_iommu_attach_dev(struct iommu_domain *domain,
 				 struct device *dev)
 {
+	struct gart_domain *gart_domain = to_gart_domain(domain);
 	struct gart_device *gart;
 	struct gart_client *client, *c;
 	int err = 0;
@@ -163,7 +174,7 @@ static int gart_iommu_attach_dev(struct iommu_domain *domain,
 	gart = gart_handle;
 	if (!gart)
 		return -EINVAL;
-	domain->priv = gart;
+	gart_domain->gart = gart;
 
 	domain->geometry.aperture_start = gart->iovmm_base;
 	domain->geometry.aperture_end   = gart->iovmm_base +
@@ -198,7 +209,8 @@ fail:
 static void gart_iommu_detach_dev(struct iommu_domain *domain,
 				  struct device *dev)
 {
-	struct gart_device *gart = domain->priv;
+	struct gart_domain *gart_domain = to_gart_domain(domain);
+	struct gart_device *gart = gart_domain->gart;
 	struct gart_client *c;
 
 	spin_lock(&gart->client_lock);
@@ -216,33 +228,44 @@ out:
 	spin_unlock(&gart->client_lock);
 }
 
-static int gart_iommu_domain_init(struct iommu_domain *domain)
+static struct iommu_domain *gart_iommu_domain_alloc(enum iommu_domain_type type)
 {
-	return 0;
+	struct gart_domain *gart_domain;
+
+	if (type != IOMMU_DOMAIN_UNMANAGED)
+		return NULL;
+
+	gart_domain = kzalloc(sizeof(*gart_domain), GFP_KERNEL);
+	if (!gart_domain)
+		return NULL;
+
+	return &gart_domain->domain;
 }
 
-static void gart_iommu_domain_destroy(struct iommu_domain *domain)
+static void gart_iommu_domain_free(struct iommu_domain *domain)
 {
-	struct gart_device *gart = domain->priv;
-
-	if (!gart)
-		return;
+	struct gart_domain *gart_domain = to_gart_domain(domain);
+	struct gart_device *gart = gart_domain->gart;
 
-	spin_lock(&gart->client_lock);
-	if (!list_empty(&gart->client)) {
-		struct gart_client *c;
+	if (gart) {
+		spin_lock(&gart->client_lock);
+		if (!list_empty(&gart->client)) {
+			struct gart_client *c;
 
-		list_for_each_entry(c, &gart->client, list)
-			gart_iommu_detach_dev(domain, c->dev);
+			list_for_each_entry(c, &gart->client, list)
+				gart_iommu_detach_dev(domain, c->dev);
+		}
+		spin_unlock(&gart->client_lock);
 	}
-	spin_unlock(&gart->client_lock);
-	domain->priv = NULL;
+
+	kfree(gart_domain);
 }
 
 static int gart_iommu_map(struct iommu_domain *domain, unsigned long iova,
 			  phys_addr_t pa, size_t bytes, int prot)
 {
-	struct gart_device *gart = domain->priv;
+	struct gart_domain *gart_domain = to_gart_domain(domain);
+	struct gart_device *gart = gart_domain->gart;
 	unsigned long flags;
 	unsigned long pfn;
 
@@ -265,7 +288,8 @@ static int gart_iommu_map(struct iommu_domain *domain, unsigned long iova,
 static size_t gart_iommu_unmap(struct iommu_domain *domain, unsigned long iova,
 			       size_t bytes)
 {
-	struct gart_device *gart = domain->priv;
+	struct gart_domain *gart_domain = to_gart_domain(domain);
+	struct gart_device *gart = gart_domain->gart;
 	unsigned long flags;
 
 	if (!gart_iova_range_valid(gart, iova, bytes))
@@ -281,7 +305,8 @@ static size_t gart_iommu_unmap(struct iommu_domain *domain, unsigned long iova,
 static phys_addr_t gart_iommu_iova_to_phys(struct iommu_domain *domain,
 					   dma_addr_t iova)
 {
-	struct gart_device *gart = domain->priv;
+	struct gart_domain *gart_domain = to_gart_domain(domain);
+	struct gart_device *gart = gart_domain->gart;
 	unsigned long pte;
 	phys_addr_t pa;
 	unsigned long flags;
@@ -310,8 +335,8 @@ static bool gart_iommu_capable(enum iommu_cap cap)
 
 static const struct iommu_ops gart_iommu_ops = {
 	.capable	= gart_iommu_capable,
-	.domain_init	= gart_iommu_domain_init,
-	.domain_destroy	= gart_iommu_domain_destroy,
+	.domain_alloc	= gart_iommu_domain_alloc,
+	.domain_free	= gart_iommu_domain_free,
 	.attach_dev	= gart_iommu_attach_dev,
 	.detach_dev	= gart_iommu_detach_dev,
 	.map		= gart_iommu_map,
-- 
1.8.4.5

