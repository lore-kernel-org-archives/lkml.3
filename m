Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967546Ab3DRQ3D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 12:29:03 -0400
Received: from 8bytes.org ([85.214.48.195]:49173 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932522Ab3DRQ3A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 12:29:00 -0400
Date: Thu, 18 Apr 2013 18:28:57 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2 V2] iommu/amd: Add workaround for ERBT1312
Message-ID: <20130418162856.GA13891@8bytes.org>
References: <1366009666-44792-1-git-send-email-suravee.suthikulpanit@amd.com>
 <20130418160220.GA4153@8bytes.org>
 <51701B9F.10003@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51701B9F.10003@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Thu Apr 18 18:28:58 2013
X-DSPAM-Confidence: 0.9994
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 51701f4a23671595633157
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 11:13:19AM -0500, Suravee Suthikulanit wrote:
> This workaround is required for both event log and ppr log.  Your
> patch is only taking care of the event log.

Right, thanks for the notice. Here is the updated patch.

>From cebe04596989c4b9001e2c1571c4fb219ea37b99 Mon Sep 17 00:00:00 2001
From: Joerg Roedel <joro@8bytes.org>
Date: Thu, 18 Apr 2013 17:55:04 +0200
Subject: [PATCH] iommu/amd: Workaround for ERBT1312

Work around an IOMMU  hardware bug where clearing the
EVT_INT or PPR_INT bit in the status register may race with
the hardware trying to set it again. When not handled the
bit might not be cleared and we lose all future event or ppr
interrupts.

Reported-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Joerg Roedel <joro@8bytes.org>
---
 drivers/iommu/amd_iommu.c |   34 ++++++++++++++++++++++++++--------
 1 file changed, 26 insertions(+), 8 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index f42793d..27792f8 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -700,14 +700,23 @@ retry:
 
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
 
@@ -744,16 +753,25 @@ static void iommu_handle_ppr_entry(struct amd_iommu *iommu, u64 *raw)
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
1.7.9.5


