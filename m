Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932365Ab3FRMEX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 08:04:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56003 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755038Ab3FRLoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 07:44:18 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Joerg Roedel <joro@8bytes.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 27/93] iommu/amd: Workaround for ERBT1312
Date: Tue, 18 Jun 2013 12:42:35 +0100
Message-Id: <1371555821-12820-28-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
References: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.15 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/iommu/amd_iommu.c | 34 ++++++++++++++++++++++++++--------
 1 file changed, 26 insertions(+), 8 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 257ab08..d3be586 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -531,14 +531,23 @@ retry:
 
 static void iommu_poll_events(struct amd_iommu *iommu)
 {
-	u32 head, tail;
+	u32 head, tail, status;
 	unsigned long flags;
 
-	/* enable event interrupts again */
-	writel(MMIO_STATUS_EVT_INT_MASK, iommu->mmio_base + MMIO_STATUS_OFFSET);
-
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
 
@@ -575,16 +584,25 @@ static void iommu_handle_ppr_entry(struct amd_iommu *iommu, u64 *raw)
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
 
-- 
1.8.1.2

