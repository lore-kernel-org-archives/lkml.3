Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991Ab3BRNBE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 08:01:04 -0500
Received: from [207.46.163.28] ([207.46.163.28]:58399 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751991Ab3BRNBB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 08:01:01 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzd799hzz1f42h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh2a8h668h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1155h)
From: Varun Sethi <Varun.Sethi@freescale.com>
To: <iommu@lists.linux-foundation.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <scottwood@freescale.com>,
        <joro@8bytes.org>, <stuart.yoder@freescale.com>
CC: Varun Sethi <Varun.Sethi@freescale.com>
Subject: [PATCH 5/6 v8] iommu/fsl: Add addtional attributes specific to the PAMU driver.
Date: Mon, 18 Feb 2013 18:22:18 +0530
Message-ID: <1361191939-21260-6-git-send-email-Varun.Sethi@freescale.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1361191939-21260-1-git-send-email-Varun.Sethi@freescale.com>
References: <1361191939-21260-1-git-send-email-Varun.Sethi@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added the following domain attributes for the FSL PAMU driver:
1. Added new iommu stash attribute, which allows setting of the
   LIODN specific stash id parameter through IOMMU API.
2. Added an attribute for enabling/disabling DMA to a particular
   memory window.
3. Added domain attribute to check for PAMUV1 specific constraints.


Signed-off-by: Varun Sethi <Varun.Sethi@freescale.com>
---
 include/linux/iommu.h |   33 +++++++++++++++++++++++++++++++++
 1 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 529987c..c44e38b 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -40,6 +40,23 @@ struct notifier_block;
 typedef int (*iommu_fault_handler_t)(struct iommu_domain *,
 			struct device *, unsigned long, int, void *);
 
+/* cache stash targets */
+#define IOMMU_ATTR_CACHE_L1 1
+#define IOMMU_ATTR_CACHE_L2 2
+#define IOMMU_ATTR_CACHE_L3 3
+
+/* This attribute corresponds to IOMMUs capable of generating
+ * a stash transaction. A stash transaction is typically a
+ * hardware initiated prefetch of data from memory to cache.
+ * This attribute allows configuring stashig specific parameters
+ * in the IOMMU hardware.
+ */
+
+struct iommu_stash_attribute {
+	u32 	cpu;	/* cpu number */
+	u32 	cache;	/* cache to stash to: L1,L2,L3 */
+};
+
 struct iommu_domain_geometry {
 	dma_addr_t aperture_start; /* First address that can be mapped    */
 	dma_addr_t aperture_end;   /* Last address that can be mapped     */
@@ -57,10 +74,26 @@ struct iommu_domain {
 #define IOMMU_CAP_CACHE_COHERENCY	0x1
 #define IOMMU_CAP_INTR_REMAP		0x2	/* isolates device intrs */
 
+/*
+ * Following constraints are specifc to PAMUV1:
+ *  -aperture must be power of 2, and naturally aligned
+ *  -number of windows must be power of 2, and address space size
+ *   of each window is determined by aperture size / # of windows
+ *  -the actual size of the mapped region of a window must be power
+ *   of 2 starting with 4KB and physical address must be naturally
+ *   aligned.
+ * DOMAIN_ATTR_FSL_PAMUV1 corresponds to the above mentioned contraints.
+ * The caller can invoke iommu_domain_get_attr to check if the underlying
+ * iommu implementation supports these constraints.
+ */
+
 enum iommu_attr {
 	DOMAIN_ATTR_GEOMETRY,
 	DOMAIN_ATTR_PAGING,
 	DOMAIN_ATTR_WINDOWS,
+	DOMAIN_ATTR_PAMU_STASH,
+	DOMAIN_ATTR_PAMU_ENABLE,
+	DOMAIN_ATTR_FSL_PAMUV1,
 	DOMAIN_ATTR_MAX,
 };
 
-- 
1.7.4.1


