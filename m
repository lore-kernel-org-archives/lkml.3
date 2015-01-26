Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757514AbbAZXwr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 18:52:47 -0500
Received: from 8bytes.org ([81.169.241.247]:50834 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757405AbbAZXvw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
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
Subject: [PATCH 15/15] iommu: Remove domain_init and domain_free iommu_ops
Date: Tue, 27 Jan 2015 00:51:45 +0100
Message-Id: <1422316305-19216-16-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422316305-19216-1-git-send-email-joro@8bytes.org>
References: <1422316305-19216-1-git-send-email-joro@8bytes.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

All drivers have been converted to the new domain_alloc and
domain_free iommu-ops. So remove the old ones and get rid of
iommu_domain->priv too, as this is no longer needed when the
struct iommu_domain is embedded in the private structures of
the iommu drivers.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 drivers/iommu/iommu.c | 30 ++----------------------------
 include/linux/iommu.h |  3 ---
 2 files changed, 2 insertions(+), 31 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index ab24d77..e66cc08 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -900,51 +900,25 @@ EXPORT_SYMBOL_GPL(iommu_set_fault_handler);
 
 struct iommu_domain *iommu_domain_alloc(struct bus_type *bus)
 {
-	const struct iommu_ops *ops;
 	struct iommu_domain *domain;
 
 	if (bus == NULL || bus->iommu_ops == NULL)
 		return NULL;
 
-	ops = bus->iommu_ops;
-
-	if (ops->domain_alloc)
-		domain = ops->domain_alloc(IOMMU_DOMAIN_UNMANAGED);
-	else
-		domain = kzalloc(sizeof(*domain), GFP_KERNEL);
-
+	domain = bus->iommu_ops->domain_alloc(IOMMU_DOMAIN_UNMANAGED);
 	if (!domain)
 		return NULL;
 
 	domain->ops  = bus->iommu_ops;
 	domain->type = IOMMU_DOMAIN_UNMANAGED;
 
-	if (ops->domain_init && domain->ops->domain_init(domain))
-		goto out_free;
-
 	return domain;
-
-out_free:
-	if (ops->domain_free)
-		ops->domain_free(domain);
-	else
-		kfree(domain);
-
-	return NULL;
 }
 EXPORT_SYMBOL_GPL(iommu_domain_alloc);
 
 void iommu_domain_free(struct iommu_domain *domain)
 {
-	const struct iommu_ops *ops = domain->ops;
-
-	if (likely(ops->domain_destroy != NULL))
-		ops->domain_destroy(domain);
-
-	if (ops->domain_free)
-		ops->domain_free(domain);
-	else
-		kfree(domain);
+	domain->ops->domain_free(domain);
 }
 EXPORT_SYMBOL_GPL(iommu_domain_free);
 
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 0b67f65..2951dca 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -62,7 +62,6 @@ enum iommu_domain_type {
 struct iommu_domain {
 	enum iommu_domain_type type;
 	const struct iommu_ops *ops;
-	void *priv;
 	iommu_fault_handler_t handler;
 	void *handler_token;
 	struct iommu_domain_geometry geometry;
@@ -122,8 +121,6 @@ enum iommu_attr {
  */
 struct iommu_ops {
 	bool (*capable)(enum iommu_cap);
-	int (*domain_init)(struct iommu_domain *domain);
-	void (*domain_destroy)(struct iommu_domain *domain);
 
 	/* Domain allocation and freeing by the iommu driver */
 	struct iommu_domain *(*domain_alloc)(enum iommu_domain_type);
-- 
1.8.4.5

