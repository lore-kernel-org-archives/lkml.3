Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109AbaIEKzm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 06:55:42 -0400
Received: from 8bytes.org ([81.169.241.247]:37758 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756872AbaIEKxK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 06:53:10 -0400
From: Joerg Roedel <joro@8bytes.org>
To: iommu@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 01/12] iommu: Introduce iommu_capable API function
Date: Fri,  5 Sep 2014 12:52:53 +0200
Message-Id: <1409914384-21191-2-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409914384-21191-1-git-send-email-joro@8bytes.org>
References: <1409914384-21191-1-git-send-email-joro@8bytes.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

This function will replace the current iommu_domain_has_cap
function and clean up the interface while at it.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
---
 drivers/iommu/iommu.c | 18 +++++++++++++++---
 include/linux/iommu.h |  7 +++++++
 2 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index ac4adb3..1bc882e 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -815,6 +815,15 @@ bool iommu_present(struct bus_type *bus)
 }
 EXPORT_SYMBOL_GPL(iommu_present);
 
+bool iommu_capable(struct bus_type *bus, enum iommu_cap cap)
+{
+	if (!bus->iommu_ops || !bus->iommu_ops->capable)
+		return false;
+
+	return bus->iommu_ops->capable(cap);
+}
+EXPORT_SYMBOL_GPL(iommu_capable);
+
 /**
  * iommu_set_fault_handler() - set a fault handler for an iommu domain
  * @domain: iommu domain
@@ -948,10 +957,13 @@ EXPORT_SYMBOL_GPL(iommu_iova_to_phys);
 int iommu_domain_has_cap(struct iommu_domain *domain,
 			 unsigned long cap)
 {
-	if (unlikely(domain->ops->domain_has_cap == NULL))
-		return 0;
+	if (domain->ops->domain_has_cap != NULL)
+		return domain->ops->domain_has_cap(domain, cap);
+
+	if (domain->ops->capable != NULL)
+		return domain->ops->capable(cap);
 
-	return domain->ops->domain_has_cap(domain, cap);
+	return 0;
 }
 EXPORT_SYMBOL_GPL(iommu_domain_has_cap);
 
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 20f9a52..d43146a 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -102,6 +102,7 @@ enum iommu_attr {
  * @pgsize_bitmap: bitmap of supported page sizes
  */
 struct iommu_ops {
+	bool (*capable)(enum iommu_cap);
 	int (*domain_init)(struct iommu_domain *domain);
 	void (*domain_destroy)(struct iommu_domain *domain);
 	int (*attach_dev)(struct iommu_domain *domain, struct device *dev);
@@ -142,6 +143,7 @@ struct iommu_ops {
 
 extern int bus_set_iommu(struct bus_type *bus, const struct iommu_ops *ops);
 extern bool iommu_present(struct bus_type *bus);
+extern bool iommu_capable(struct bus_type *bus, enum iommu_cap cap);
 extern struct iommu_domain *iommu_domain_alloc(struct bus_type *bus);
 extern struct iommu_group *iommu_group_get_by_id(int id);
 extern void iommu_domain_free(struct iommu_domain *domain);
@@ -250,6 +252,11 @@ static inline bool iommu_present(struct bus_type *bus)
 	return false;
 }
 
+static inline bool iommu_capable(struct bus_type *bus, enum iommu_cap cap)
+{
+	return false;
+}
+
 static inline struct iommu_domain *iommu_domain_alloc(struct bus_type *bus)
 {
 	return NULL;
-- 
1.9.1

