Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094Ab3C0XwG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 19:52:06 -0400
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:31105
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754996Ab3C0XwE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 19:52:04 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1f42h1fc6h1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
X-WSS-ID: 0MKCFMN-01-665-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <iommu@lists.linux-foundation.org>, <joro@8bytes.org>
CC: <linux-kernel@vger.kernel.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH 3/3] iommu/amd: Re-enable IOMMU event log interrupt after handling.
Date: Wed, 27 Mar 2013 18:51:52 -0500
Message-ID: <1364428312-2611-1-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

Current driver does not clear the IOMMU event log interrupt bit
in the IOMMU status register after processing an interrupt.
This causes the IOMMU hardware to generate event log interrupt only once.
This has been observed in both IOMMU v1 and V2 hardware.
This patch clears the bit by writing 1 to bit 1 of the IOMMU
status register (MMIO Offset 2020h)

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 drivers/iommu/amd_iommu.c       |    3 +++
 drivers/iommu/amd_iommu_types.h |    1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 30ac0cb..13a4f63 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -809,6 +809,9 @@ static void iommu_poll_events(struct amd_iommu *iommu)
 	u32 head, tail;
 	unsigned long flags;
 
+	/* enable event interrupts again */
+	writel(MMIO_STATUS_EVT_INT_MASK, iommu->mmio_base + MMIO_STATUS_OFFSET);
+
 	spin_lock_irqsave(&iommu->lock, flags);
 
 	head = readl(iommu->mmio_base + MMIO_EVT_HEAD_OFFSET);
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
1.7.10.4


