Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753115Ab3F1Szf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 14:55:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41732 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633Ab3F1Sza (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:55:30 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 030/105] iommu/amd: Re-enable IOMMU event log interrupt after handling.
Date: Fri, 28 Jun 2013 11:50:52 -0700
Message-Id: <1372445527-24414-31-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372445527-24414-1-git-send-email-kamal@canonical.com>
References: <1372445527-24414-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.4 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/iommu/amd_iommu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 6202782..409b171 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -703,6 +703,9 @@ static void iommu_poll_events(struct amd_iommu *iommu)
 	u32 head, tail, status;
 	unsigned long flags;
 
+	/* enable event interrupts again */
+	writel(MMIO_STATUS_EVT_INT_MASK, iommu->mmio_base + MMIO_STATUS_OFFSET);
+
 	spin_lock_irqsave(&iommu->lock, flags);
 
 	/* enable event interrupts again */
-- 
1.8.1.2

