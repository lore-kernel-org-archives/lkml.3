Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247Ab3FRMEU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 08:04:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56005 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755351Ab3FRLoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 07:44:18 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Joerg Roedel <joro@8bytes.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 26/93] iommu/amd: Re-enable IOMMU event log interrupt after handling.
Date: Tue, 18 Jun 2013 12:42:34 +0100
Message-Id: <1371555821-12820-27-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
References: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

commit 925fe08bce38d1ff052fe2209b9e2b8d5fbb7f98 upstream.

Current driver does not clear the IOMMU event log interrupt bit
in the IOMMU status register after processing an interrupt.
This causes the IOMMU hardware to generate event log interrupt only once.
This has been observed in both IOMMU v1 and V2 hardware.
This patch clears the bit by writing 1 to bit 1 of the IOMMU
status register (MMIO Offset 2020h)

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Signed-off-by: Joerg Roedel <joro@8bytes.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/iommu/amd_iommu.c       | 3 +++
 drivers/iommu/amd_iommu_types.h | 1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 33fee0a..257ab08 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -534,6 +534,9 @@ static void iommu_poll_events(struct amd_iommu *iommu)
 	u32 head, tail;
 	unsigned long flags;
 
+	/* enable event interrupts again */
+	writel(MMIO_STATUS_EVT_INT_MASK, iommu->mmio_base + MMIO_STATUS_OFFSET);
+
 	spin_lock_irqsave(&iommu->lock, flags);
 
 	head = readl(iommu->mmio_base + MMIO_EVT_HEAD_OFFSET);
diff --git a/drivers/iommu/amd_iommu_types.h b/drivers/iommu/amd_iommu_types.h
index c1b1d48..f9addfd 100644
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

