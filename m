Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485Ab3BDNUF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 08:20:05 -0500
Received: from 8bytes.org ([85.214.48.195]:33824 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755236Ab3BDNTF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 08:19:05 -0500
From: Joerg Roedel <joro@8bytes.org>
To: Sethi Varun-B16395 <B16395@freescale.com>, Stuart Yoder <b08248@gmail.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH 4/5] iommu: Add domain window handling functions
Date: Mon,  4 Feb 2013 14:18:42 +0100
Message-Id: <1359983924-28952-5-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359983924-28952-1-git-send-email-joro@8bytes.org>
References: <1359983924-28952-1-git-send-email-joro@8bytes.org>
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Mon Feb  4 14:19:04 2013
X-DSPAM-Confidence: 0.9995
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 510fb54822971017040734
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the iommu_domain_window_enable() and iommu_domain_window_disable()
functions to the IOMMU-API. These functions will be used to setup
domains that are based on subwindows and not on paging.

Signed-off-by: Joerg Roedel <joro@8bytes.org>
---
 drivers/iommu/iommu.c |   20 ++++++++++++++++++++
 include/linux/iommu.h |   22 ++++++++++++++++++++++
 2 files changed, 42 insertions(+)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index ab9dafd..0fdb7db 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -852,6 +852,26 @@ size_t iommu_unmap(struct iommu_domain *domain, unsigned long iova, size_t size)
 }
 EXPORT_SYMBOL_GPL(iommu_unmap);
 
+
+int iommu_domain_window_enable(struct iommu_domain *domain, u32 wnd_nr,
+			       phys_addr_t paddr, size_t size)
+{
+	if (unlikely(domain->ops->domain_window_enable == NULL))
+		return -ENODEV;
+
+	return domain->ops->domain_window_enable(domain, wnd_nr, paddr, size);
+}
+EXPORT_SYMBOL_GPL(iommu_domain_window_enable);
+
+void iommu_domain_window_disable(struct iommu_domain *domain, u32 wnd_nr)
+{
+	if (unlikely(domain->ops->domain_window_disable == NULL))
+		return;
+
+	return domain->ops->domain_window_disable(domain, wnd_nr);
+}
+EXPORT_SYMBOL_GPL(iommu_domain_window_disable);
+
 static int __init iommu_init(void)
 {
 	iommu_group_kset = kset_create_and_add("iommu_groups",
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 26066f5..0cba2d8 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -101,6 +101,12 @@ struct iommu_ops {
 			       enum iommu_attr attr, void *data);
 	int (*domain_set_attr)(struct iommu_domain *domain,
 			       enum iommu_attr attr, void *data);
+
+	/* Window handling functions */
+	int (*domain_window_enable)(struct iommu_domain *domain, u32 wnd_nr,
+				    phys_addr_t paddr, size_t size);
+	void (*domain_window_disable)(struct iommu_domain *domain, u32 wnd_nr);
+
 	unsigned long pgsize_bitmap;
 };
 
@@ -158,6 +164,10 @@ extern int iommu_domain_get_attr(struct iommu_domain *domain, enum iommu_attr,
 extern int iommu_domain_set_attr(struct iommu_domain *domain, enum iommu_attr,
 				 void *data);
 
+/* Window handling function prototypes */
+extern int iommu_domain_window_enable(struct iommu_domain *domain, u32 wnd_nr,
+				      phys_addr_t offset, size_t size);
+extern void iommu_domain_window_disable(struct iommu_domain *domain, u32 wnd_nr);
 /**
  * report_iommu_fault() - report about an IOMMU fault to the IOMMU framework
  * @domain: the iommu domain where the fault has happened
@@ -240,6 +250,18 @@ static inline int iommu_unmap(struct iommu_domain *domain, unsigned long iova,
 	return -ENODEV;
 }
 
+static inline int iommu_domain_window_enable(struct iommu_domain *domain,
+					     u32 wnd_nr, phys_addr_t paddr,
+					     size_t size)
+{
+	return -ENODEV;
+}
+
+static inline void iommu_domain_window_disable(struct iommu_domain *domain,
+					       u32 wnd_nr)
+{
+}
+
 static inline phys_addr_t iommu_iova_to_phys(struct iommu_domain *domain,
 					     unsigned long iova)
 {
-- 
1.7.9.5


