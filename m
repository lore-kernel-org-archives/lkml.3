Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735Ab3DVFkp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 01:40:45 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:2558
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752630Ab3DVFkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 01:40:41 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzc8kzz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bhz2dh2a8h668h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
From: Varun Sethi <Varun.Sethi@freescale.com>
To: <joro@8bytes.org>, <iommu@lists.linux-foundation.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <galak@kernel.crashing.org>, <benh@kernel.crashing.org>,
        <stuart.yoder@freescale.com>, <scottwood@freescale.com>
CC: Varun Sethi <Varun.Sethi@freescale.com>
Subject: [PATCH 2/3 v13] iommu/fsl: Add additional iommu attributes required by the PAMU driver.
Date: Mon, 22 Apr 2013 11:01:55 +0530
Message-ID: <1366608716-1704-2-git-send-email-Varun.Sethi@freescale.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1366608716-1704-1-git-send-email-Varun.Sethi@freescale.com>
References: <1366608716-1704-1-git-send-email-Varun.Sethi@freescale.com>
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
v13 changes:
- created a new file include/linux/fsl_pamu_stash.h for stash
attributes.
v12 changes:
- Moved PAMU specifc stash ids and structures to PAMU header file.
- no change in v11.
- no change in v10.
 include/linux/fsl_pamu_stash.h |   39 +++++++++++++++++++++++++++++++++++++++
 include/linux/iommu.h          |   16 ++++++++++++++++
 2 files changed, 55 insertions(+), 0 deletions(-)
 create mode 100644 include/linux/fsl_pamu_stash.h

diff --git a/include/linux/fsl_pamu_stash.h b/include/linux/fsl_pamu_stash.h
new file mode 100644
index 0000000..caa1b21
--- /dev/null
+++ b/include/linux/fsl_pamu_stash.h
@@ -0,0 +1,39 @@
+/*
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License, version 2, as
+ * published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
+ *
+ * Copyright (C) 2013 Freescale Semiconductor, Inc.
+ *
+ */
+
+#ifndef __FSL_PAMU_STASH_H
+#define __FSL_PAMU_STASH_H
+
+/* cache stash targets */
+enum pamu_stash_target {
+	PAMU_ATTR_CACHE_L1 = 1,
+	PAMU_ATTR_CACHE_L2,
+	PAMU_ATTR_CACHE_L3,
+};
+
+/*
+ * This attribute allows configuring stashig specific parameters
+ * in the PAMU hardware.
+ */
+
+struct pamu_stash_attribute {
+	u32 	cpu;	/* cpu number */
+	u32 	cache;	/* cache to stash to: L1,L2,L3 */
+};
+
+#endif  /* __FSL_PAMU_STASH_H */
diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index 2727810..c5dc2b9 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -57,10 +57,26 @@ struct iommu_domain {
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


