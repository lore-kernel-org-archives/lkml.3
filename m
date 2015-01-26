Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757466AbbAZXwA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 18:52:00 -0500
Received: from 8bytes.org ([81.169.241.247]:50772 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757176AbbAZXvs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
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
Subject: [PATCH 02/15] iommu: Introduce iommu domain types
Date: Tue, 27 Jan 2015 00:51:32 +0100
Message-Id: <1422316305-19216-3-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422316305-19216-1-git-send-email-joro@8bytes.org>
References: <1422316305-19216-1-git-send-email-joro@8bytes.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

This allows to handle domains differently based on their
type in the future. An IOMMU driver can implement certain
optimizations for DMA-API domains for example.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 drivers/iommu/iommu.c |  5 +++--
 include/linux/iommu.h | 11 ++++++++++-
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 684efc0..ab24d77 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -909,14 +909,15 @@ struct iommu_domain *iommu_domain_alloc(struct bus_type *bus)
 	ops = bus->iommu_ops;
 
 	if (ops->domain_alloc)
-		domain = ops->domain_alloc();
+		domain = ops->domain_alloc(IOMMU_DOMAIN_UNMANAGED);
 	else
 		domain = kzalloc(sizeof(*domain), GFP_KERNEL);
 
 	if (!domain)
 		return NULL;
 
-	domain->ops = bus->iommu_ops;
+	domain->ops  = bus->iommu_ops;
+	domain->type = IOMMU_DOMAIN_UNMANAGED;
 
 	if (ops->domain_init && domain->ops->domain_init(domain))
 		goto out_free;
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 69d1d12..0b67f65 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -51,7 +51,16 @@ struct iommu_domain_geometry {
 	bool force_aperture;       /* DMA only allowed in mappable range? */
 };
 
+/* This are the possible domain-types */
+enum iommu_domain_type {
+	IOMMU_DOMAIN_DMA,	/* Domain used for DMA-API */
+	IOMMU_DOMAIN_IDENTITY,	/* Identity mapped domain  */
+	IOMMU_DOMAIN_UNMANAGED, /* Domain mappings are managed by a third party
+				   user (like KVM or VFIO) */
+};
+
 struct iommu_domain {
+	enum iommu_domain_type type;
 	const struct iommu_ops *ops;
 	void *priv;
 	iommu_fault_handler_t handler;
@@ -117,7 +126,7 @@ struct iommu_ops {
 	void (*domain_destroy)(struct iommu_domain *domain);
 
 	/* Domain allocation and freeing by the iommu driver */
-	struct iommu_domain *(*domain_alloc)(void);
+	struct iommu_domain *(*domain_alloc)(enum iommu_domain_type);
 	void (*domain_free)(struct iommu_domain *);
 
 	int (*attach_dev)(struct iommu_domain *domain, struct device *dev);
-- 
1.8.4.5

