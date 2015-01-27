Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757582AbbA0AJZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 19:09:25 -0500
Received: from 8bytes.org ([81.169.241.247]:51320 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757408AbbA0AJQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 19:09:16 -0500
From: Joerg Roedel <joro@8bytes.org>
To: iommu@lists.linux-foundation.org
Cc: Will Deacon <will.deacon@arm.com>, Kukjin Kim <kgene@kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Heiko Stuebner <heiko@sntech.de>, Hiroshi Doyu <hdoyu@nvidia.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alex Williamson <alex.williamson@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Robin Murphy <robin.murphy@arm.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Joerg Roedel <joro@8bytes.org>, jroedel@suse.de
Subject: [PATCH 2/5] iommu: Allocate a default domain for iommu groups
Date: Tue, 27 Jan 2015 01:08:56 +0100
Message-Id: <1422317339-22620-3-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422317339-22620-1-git-send-email-joro@8bytes.org>
References: <1422317339-22620-1-git-send-email-joro@8bytes.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

The default domain will be used (if supported by the iommu
driver) when the devices in the iommu group are not attached
to any other domain.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 drivers/iommu/iommu.c | 26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 34636eb..8f33ddd3 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -76,6 +76,9 @@ struct iommu_group_attribute iommu_group_attr_##_name =		\
 #define to_iommu_group(_kobj)		\
 	container_of(_kobj, struct iommu_group, kobj)
 
+static struct iommu_domain *__iommu_domain_alloc(struct bus_type *bus,
+						 enum iommu_domain_type type);
+
 static ssize_t iommu_group_attr_show(struct kobject *kobj,
 				     struct attribute *__attr, char *buf)
 {
@@ -362,6 +365,17 @@ rename:
 
 	kobject_get(group->devices_kobj);
 
+	/*
+	 * Try to allocate a default domain for the group, if this
+	 * hasn't happened yet. This is not the best place to do that,
+	 * it should happen in iommu_group_alloc(). But we have no
+	 * iommu_ops there yet, so the allocation has to happen here for
+	 * now.
+	 */
+	if (group->default_domain == NULL)
+		group->default_domain = __iommu_domain_alloc(dev->bus,
+							     IOMMU_DOMAIN_DMA);
+
 	dev->iommu_group = group;
 
 	mutex_lock(&group->mutex);
@@ -899,22 +913,28 @@ void iommu_set_fault_handler(struct iommu_domain *domain,
 }
 EXPORT_SYMBOL_GPL(iommu_set_fault_handler);
 
-struct iommu_domain *iommu_domain_alloc(struct bus_type *bus)
+static struct iommu_domain *__iommu_domain_alloc(struct bus_type *bus,
+						 enum iommu_domain_type type)
 {
 	struct iommu_domain *domain;
 
 	if (bus == NULL || bus->iommu_ops == NULL)
 		return NULL;
 
-	domain = bus->iommu_ops->domain_alloc(IOMMU_DOMAIN_UNMANAGED);
+	domain = bus->iommu_ops->domain_alloc(type);
 	if (!domain)
 		return NULL;
 
 	domain->ops  = bus->iommu_ops;
-	domain->type = IOMMU_DOMAIN_UNMANAGED;
+	domain->type = type;
 
 	return domain;
 }
+
+struct iommu_domain *iommu_domain_alloc(struct bus_type *bus)
+{
+	return __iommu_domain_alloc(bus, IOMMU_DOMAIN_UNMANAGED);
+}
 EXPORT_SYMBOL_GPL(iommu_domain_alloc);
 
 void iommu_domain_free(struct iommu_domain *domain)
-- 
1.9.1

