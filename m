Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434Ab3BDNUC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 08:20:02 -0500
Received: from 8bytes.org ([85.214.48.195]:33826 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755261Ab3BDNTF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 08:19:05 -0500
From: Joerg Roedel <joro@8bytes.org>
To: Sethi Varun-B16395 <B16395@freescale.com>, Stuart Yoder <b08248@gmail.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Joerg Roedel <joro@8bytes.org>
Subject: [PATCH 5/5] iommu: Add DOMAIN_ATTR_WINDOWS domain attribute
Date: Mon,  4 Feb 2013 14:18:43 +0100
Message-Id: <1359983924-28952-6-git-send-email-joro@8bytes.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359983924-28952-1-git-send-email-joro@8bytes.org>
References: <1359983924-28952-1-git-send-email-joro@8bytes.org>
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Mon Feb  4 14:19:04 2013
X-DSPAM-Confidence: 0.9996
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 510fb54822978170470689
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This attribute can be used to set and get the number of
subwindows on IOMMUs that are window-based.

Signed-off-by: Joerg Roedel <joro@8bytes.org>
---
 drivers/iommu/iommu.c |   33 ++++++++++++++++++++++++++++++---
 include/linux/iommu.h |    5 +++++
 2 files changed, 35 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
index 0fdb7db..66402f7 100644
--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -891,6 +891,7 @@ int iommu_domain_get_attr(struct iommu_domain *domain,
 	struct iommu_domain_geometry *geometry;
 	bool *paging;
 	int ret = 0;
+	u32 *count;
 
 	switch (attr) {
 	case DOMAIN_ATTR_GEOMETRY:
@@ -902,6 +903,15 @@ int iommu_domain_get_attr(struct iommu_domain *domain,
 		paging  = data;
 		*paging = (domain->ops->pgsize_bitmap != 0UL);
 		break;
+	case DOMAIN_ATTR_WINDOWS:
+		count = data;
+
+		if (domain->ops->domain_get_windows != NULL)
+			*count = domain->ops->domain_get_windows(domain);
+		else
+			ret = -ENODEV;
+
+		break;
 	default:
 		if (!domain->ops->domain_get_attr)
 			return -EINVAL;
@@ -916,9 +926,26 @@ EXPORT_SYMBOL_GPL(iommu_domain_get_attr);
 int iommu_domain_set_attr(struct iommu_domain *domain,
 			  enum iommu_attr attr, void *data)
 {
-	if (!domain->ops->domain_set_attr)
-		return -EINVAL;
+	int ret = 0;
+	u32 *count;
+
+	switch (attr) {
+	case DOMAIN_ATTR_WINDOWS:
+		count = data;
+
+		if (domain->ops->domain_set_windows != NULL)
+			ret = domain->ops->domain_set_windows(domain, *count);
+		else
+			ret = -ENODEV;
 
-	return domain->ops->domain_set_attr(domain, attr, data);
+		break;
+	default:
+		if (domain->ops->domain_set_attr == NULL)
+			return -EINVAL;
+
+		ret = domain->ops->domain_set_attr(domain, attr, data);
+	}
+
+	return ret;
 }
 EXPORT_SYMBOL_GPL(iommu_domain_set_attr);
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 0cba2d8..8330df1 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -60,6 +60,7 @@ struct iommu_domain {
 enum iommu_attr {
 	DOMAIN_ATTR_GEOMETRY,
 	DOMAIN_ATTR_PAGING,
+	DOMAIN_ATTR_WINDOWS,
 	DOMAIN_ATTR_MAX,
 };
 
@@ -106,6 +107,10 @@ struct iommu_ops {
 	int (*domain_window_enable)(struct iommu_domain *domain, u32 wnd_nr,
 				    phys_addr_t paddr, size_t size);
 	void (*domain_window_disable)(struct iommu_domain *domain, u32 wnd_nr);
+	/* Set the numer of window per domain */
+	int (*domain_set_windows)(struct iommu_domain *domain, u32 w_count);
+	/* Get the numer of window per domain */
+	u32 (*domain_get_windows)(struct iommu_domain *domain);
 
 	unsigned long pgsize_bitmap;
 };
-- 
1.7.9.5


