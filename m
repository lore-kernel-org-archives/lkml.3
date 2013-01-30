Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757071Ab3A3VoJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 16:44:09 -0500
Received: from 8bytes.org ([85.214.48.195]:56855 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754035Ab3A3Vn5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 16:43:57 -0500
From: Joerg Roedel <joro@8bytes.org>
To: Sethi Varun-B16395 <B16395@freescale.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH 4/4] iommu: Add domain window handling functions
Date: Wed, 30 Jan 2013 22:43:48 +0100
Message-Id: <1359582228-21552-5-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359582228-21552-1-git-send-email-joro@8bytes.org>
References: <1359582228-21552-1-git-send-email-joro@8bytes.org>
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Wed Jan 30 22:43:56 2013
X-DSPAM-Confidence: 0.9995
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5109941c22971292320571
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the iommu_domain_wnd_enable() and iommu_domain_wnd_disable()
functions to the IOMMU-API. These functions will be used to
setup domains that are based on subwindows and not on
paging.

Signed-off-by: Joerg Roedel <joro@8bytes.org>
---
 drivers/iommu/iommu.c |   20 ++++++++++++++++++++
 include/linux/iommu.h |   18 ++++++++++++++++++
 2 files changed, 38 insertions(+)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index ab9dafd..55ae3bf 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -852,6 +852,26 @@ size_t iommu_unmap(struct iommu_domain *domain, unsigned long iova, size_t size)
 }
 EXPORT_SYMBOL_GPL(iommu_unmap);
 
+
+int iommu_domain_wnd_enable(struct iommu_domain *domain, u32 window,
+			    unsigned long offset, size_t size)
+{
+	if (unlikely(domain->ops->domain_wnd_enable == NULL))
+		return -ENODEV;
+
+	return domain->ops->domain_wnd_enable(domain, window, offset, size);
+}
+EXPORT_SYMBOL_GPL(iommu_domain_wnd_enable);
+
+void iommu_domain_wnd_disable(struct iommu_domain *domain, u32 window)
+{
+	if (unlikely(domain->ops->domain_wnd_disable == NULL))
+		return;
+
+	return domain->ops->domain_wnd_disable(domain, window);
+}
+EXPORT_SYMBOL_GPL(iommu_domain_wnd_disable);
+
 static int __init iommu_init(void)
 {
 	iommu_group_kset = kset_create_and_add("iommu_groups",
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 26066f5..f01657e 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -90,6 +90,9 @@ struct iommu_ops {
 		   phys_addr_t paddr, size_t size, int prot);
 	size_t (*unmap)(struct iommu_domain *domain, unsigned long iova,
 		     size_t size);
+	int (*domain_wnd_enable)(struct iommu_domain *domain, u32 window,
+				   unsigned long offset, size_t size);
+	void (*domain_wnd_disable)(struct iommu_domain *domain, u32 window);
 	phys_addr_t (*iova_to_phys)(struct iommu_domain *domain,
 				    unsigned long iova);
 	int (*domain_has_cap)(struct iommu_domain *domain,
@@ -123,6 +126,9 @@ extern int iommu_map(struct iommu_domain *domain, unsigned long iova,
 		     phys_addr_t paddr, size_t size, int prot);
 extern size_t iommu_unmap(struct iommu_domain *domain, unsigned long iova,
 		       size_t size);
+extern int iommu_domain_wnd_enable(struct iommu_domain *domain, u32 window,
+				   unsigned long offset, size_t size);
+extern void iommu_domain_wnd_disable(struct iommu_domain *domain, u32 window);
 extern phys_addr_t iommu_iova_to_phys(struct iommu_domain *domain,
 				      unsigned long iova);
 extern int iommu_domain_has_cap(struct iommu_domain *domain,
@@ -240,6 +246,18 @@ static inline int iommu_unmap(struct iommu_domain *domain, unsigned long iova,
 	return -ENODEV;
 }
 
+static inline int iommu_domain_wnd_enable(struct iommu_domain *domain,
+					  u32 window, unsigned long offset,
+					  size_t size)
+{
+	return -ENODEV;
+}
+
+static inline void iommu_domain_wnd_disable(struct iommu_domain *domain,
+					    u32 window)
+{
+}
+
 static inline phys_addr_t iommu_iova_to_phys(struct iommu_domain *domain,
 					     unsigned long iova)
 {
-- 
1.7.9.5


