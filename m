Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757276Ab3E1VV0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 17:21:26 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59463 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756788Ab3E1VVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 17:21:20 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Joerg Roedel <joro@8bytes.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 07/78] iommu/amd: Workaround for ERBT1312
Date: Tue, 28 May 2013 14:19:16 -0700
Message-Id: <1369776027-17859-8-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1369776027-17859-1-git-send-email-kamal@canonical.com>
References: <1369776027-17859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joerg Roedel <joro@8bytes.org>

commit d3263bc29706e42f74d8800807c2dedf320d77f1 upstream.

Work around an IOMMU  hardware bug where clearing the
EVT_INT or PPR_INT bit in the status register may race with
the hardware trying to set it again. When not handled the
bit might not be cleared and we lose all future event or ppr
interrupts.

Reported-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Signed-off-by: Joerg Roedel <joro@8bytes.org>
[ kamal: backport to 3.8 ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/iommu/amd_iommu.c       | 31 ++++++++++++++++++++++++++-----
 drivers/iommu/amd_iommu_types.h |  1 +
 2 files changed, 27 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 4c867f4..6202782 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -700,11 +700,23 @@ retry:
 
 static void iommu_poll_events(struct amd_iommu *iommu)
 {
-	u32 head, tail;
+	u32 head, tail, status;
 	unsigned long flags;
 
 	spin_lock_irqsave(&iommu->lock, flags);
 
+	/* enable event interrupts again */
+	do {
+		/*
+		 * Workaround for Erratum ERBT1312
+		 * Clearing the EVT_INT bit may race in the hardware, so read
+		 * it again and make sure it was really cleared
+		 */
+		status = readl(iommu->mmio_base + MMIO_STATUS_OFFSET);
+		writel(MMIO_STATUS_EVT_INT_MASK,
+		       iommu->mmio_base + MMIO_STATUS_OFFSET);
+	} while (status & MMIO_STATUS_EVT_INT_MASK);
+
 	head = readl(iommu->mmio_base + MMIO_EVT_HEAD_OFFSET);
 	tail = readl(iommu->mmio_base + MMIO_EVT_TAIL_OFFSET);
 
@@ -741,16 +753,25 @@ static void iommu_handle_ppr_entry(struct amd_iommu *iommu, u64 *raw)
 static void iommu_poll_ppr_log(struct amd_iommu *iommu)
 {
 	unsigned long flags;
-	u32 head, tail;
+	u32 head, tail, status;
 
 	if (iommu->ppr_log == NULL)
 		return;
 
-	/* enable ppr interrupts again */
-	writel(MMIO_STATUS_PPR_INT_MASK, iommu->mmio_base + MMIO_STATUS_OFFSET);
-
 	spin_lock_irqsave(&iommu->lock, flags);
 
+	/* enable ppr interrupts again */
+	do {
+		/*
+		 * Workaround for Erratum ERBT1312
+		 * Clearing the PPR_INT bit may race in the hardware, so read
+		 * it again and make sure it was really cleared
+		 */
+		status = readl(iommu->mmio_base + MMIO_STATUS_OFFSET);
+		writel(MMIO_STATUS_PPR_INT_MASK,
+		       iommu->mmio_base + MMIO_STATUS_OFFSET);
+	} while (status & MMIO_STATUS_PPR_INT_MASK);
+
 	head = readl(iommu->mmio_base + MMIO_PPR_HEAD_OFFSET);
 	tail = readl(iommu->mmio_base + MMIO_PPR_TAIL_OFFSET);
 
diff --git a/drivers/iommu/amd_iommu_types.h b/drivers/iommu/amd_iommu_types.h
index e38ab43..083f98c 100644
--- a/drivers/iommu/amd_iommu_types.h
+++ b/drivers/iommu/amd_iommu_types.h
@@ -99,6 +99,7 @@
 #define PASID_MASK		0x000fffff
 
 /* MMIO status bits */
+#define MMIO_STATUS_EVT_INT_MASK	(1 << 1)
 #define MMIO_STATUS_COM_WAIT_INT_MASK	(1 << 2)
 #define MMIO_STATUS_PPR_INT_MASK	(1 << 6)
 
-- 
1.8.1.2

