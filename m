Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933429Ab3GCSqg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 14:46:36 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3109 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933296Ab3GCSlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 14:41:08 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=gYKZRu7r_ywA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=vHe2XG41e0EA:10 a=zd2uoN0lAAAA:8 a=tA7aZXjiAAAA:8 a=3zHDPzwYzx5WMobmtToA:9 a=wu_e27o_rKQA:10 a=qM0ISud-tAQA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184053.025050975@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:39:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Joerg Roedel <joro@8bytes.org>
Subject: [051/141] iommu/amd: Re-enable IOMMU event log interrupt after handling.
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0051-iommu-amd-Re-enable-IOMMU-event-log-interrupt-after-.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

[ Upstream commit 925fe08bce38d1ff052fe2209b9e2b8d5fbb7f98 ]

Current driver does not clear the IOMMU event log interrupt bit
in the IOMMU status register after processing an interrupt.
This causes the IOMMU hardware to generate event log interrupt only once.
This has been observed in both IOMMU v1 and V2 hardware.
This patch clears the bit by writing 1 to bit 1 of the IOMMU
status register (MMIO Offset 2020h)

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Signed-off-by: Joerg Roedel <joro@8bytes.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/iommu/amd_iommu.c       |    3 +++
 drivers/iommu/amd_iommu_types.h |    1 +
 2 files changed, 4 insertions(+)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index c698cf6..195ec2e 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -601,6 +601,9 @@ static void iommu_poll_events(struct amd_iommu *iommu)
 	u32 head, tail;
 	unsigned long flags;
 
+	/* enable event interrupts again */
+	writel(MMIO_STATUS_EVT_INT_MASK, iommu->mmio_base + MMIO_STATUS_OFFSET);
+
 	spin_lock_irqsave(&iommu->lock, flags);
 
 	head = readl(iommu->mmio_base + MMIO_EVT_HEAD_OFFSET);
diff --git a/drivers/iommu/amd_iommu_types.h b/drivers/iommu/amd_iommu_types.h
index d0dab86..c6d556c 100644
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


