Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753694Ab3DVVcr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 17:32:47 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:3479
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752651Ab3DVVcp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 17:32:45 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bhz2dh668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
X-WSS-ID: 0MLOEID-02-1FB-02
X-M-MSG: 
From: <suravee.suthikulpanit@amd.com>
To: <iommu@lists.linux-foundation.org>, <joro@8bytes.org>
CC: <linux-kernel@vger.kernel.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
Subject: [PATCH 1/1 V2] iommu/AMD: Per-thread IOMMU Interrupt Handling
Date: Mon, 22 Apr 2013 16:32:34 -0500
Message-ID: <1366666354-4399-1-git-send-email-suravee.suthikulpanit@amd.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>

In the current interrupt handling scheme, there are as many threads as
the number of IOMMUs. Each thread is created and assigned to an IOMMU at
the time of registering interrupt handlers (request_threaded_irq).
When an IOMMU HW generates an interrupt, the irq handler (top half) wakes up
the corresponding thread to process event and PPR logs of all IOMMUs
starting from the 1st IOMMU.

In the system with multiple IOMMU,this handling scheme complicates the
synchronization of the IOMMU data structures and status registers as
there could be multiple threads competing for the same IOMMU while
the other IOMMU could be left unhandled.

To simplify, this patch is proposing a different interrupt handling scheme
by having each thread only managing interrupts of the corresponding IOMMU.
This can be achieved by passing the struct amd_iommu when registering the
interrupt handlers. This structure is unique for each IOMMU and can be used
by the bottom half thread to identify the IOMMU to be handled instead
of calling for_each_iommu.  Besides this also eliminate the needs to lock
the IOMMU for processing event and PPR logs.

Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
V2:
	- Re-create the patch from new code base.

 drivers/iommu/amd_iommu.c      |   82 ++++++++++++++++------------------------
 drivers/iommu/amd_iommu_init.c |    2 +-
 2 files changed, 34 insertions(+), 50 deletions(-)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 6e14ff6..9a706ca 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -700,22 +700,7 @@ retry:
 
 static void iommu_poll_events(struct amd_iommu *iommu)
 {
-	u32 head, tail, status;
-	unsigned long flags;
-
-	spin_lock_irqsave(&iommu->lock, flags);
-
-	/* enable event interrupts again */
-	do {
-		/*
-		 * Workaround for Erratum ERBT1312
-		 * Clearing the EVT_INT bit may race in the hardware, so read
-		 * it again and make sure it was really cleared
-		 */
-		status = readl(iommu->mmio_base + MMIO_STATUS_OFFSET);
-		writel(MMIO_STATUS_EVT_INT_MASK,
-		       iommu->mmio_base + MMIO_STATUS_OFFSET);
-	} while (status & MMIO_STATUS_EVT_INT_MASK);
+	u32 head, tail;
 
 	head = readl(iommu->mmio_base + MMIO_EVT_HEAD_OFFSET);
 	tail = readl(iommu->mmio_base + MMIO_EVT_TAIL_OFFSET);
@@ -726,8 +711,6 @@ static void iommu_poll_events(struct amd_iommu *iommu)
 	}
 
 	writel(head, iommu->mmio_base + MMIO_EVT_HEAD_OFFSET);
-
-	spin_unlock_irqrestore(&iommu->lock, flags);
 }
 
 static void iommu_handle_ppr_entry(struct amd_iommu *iommu, u64 *raw)
@@ -752,26 +735,11 @@ static void iommu_handle_ppr_entry(struct amd_iommu *iommu, u64 *raw)
 
 static void iommu_poll_ppr_log(struct amd_iommu *iommu)
 {
-	unsigned long flags;
-	u32 head, tail, status;
+	u32 head, tail;
 
 	if (iommu->ppr_log == NULL)
 		return;
 
-	spin_lock_irqsave(&iommu->lock, flags);
-
-	/* enable ppr interrupts again */
-	do {
-		/*
-		 * Workaround for Erratum ERBT1312
-		 * Clearing the PPR_INT bit may race in the hardware, so read
-		 * it again and make sure it was really cleared
-		 */
-		status = readl(iommu->mmio_base + MMIO_STATUS_OFFSET);
-		writel(MMIO_STATUS_PPR_INT_MASK,
-		       iommu->mmio_base + MMIO_STATUS_OFFSET);
-	} while (status & MMIO_STATUS_PPR_INT_MASK);
-
 	head = readl(iommu->mmio_base + MMIO_PPR_HEAD_OFFSET);
 	tail = readl(iommu->mmio_base + MMIO_PPR_TAIL_OFFSET);
 
@@ -807,34 +775,50 @@ static void iommu_poll_ppr_log(struct amd_iommu *iommu)
 		head = (head + PPR_ENTRY_SIZE) % PPR_LOG_SIZE;
 		writel(head, iommu->mmio_base + MMIO_PPR_HEAD_OFFSET);
 
-		/*
-		 * Release iommu->lock because ppr-handling might need to
-		 * re-acquire it
-		 */
-		spin_unlock_irqrestore(&iommu->lock, flags);
-
 		/* Handle PPR entry */
 		iommu_handle_ppr_entry(iommu, entry);
 
-		spin_lock_irqsave(&iommu->lock, flags);
-
 		/* Refresh ring-buffer information */
 		head = readl(iommu->mmio_base + MMIO_PPR_HEAD_OFFSET);
 		tail = readl(iommu->mmio_base + MMIO_PPR_TAIL_OFFSET);
 	}
-
-	spin_unlock_irqrestore(&iommu->lock, flags);
 }
 
 irqreturn_t amd_iommu_int_thread(int irq, void *data)
 {
-	struct amd_iommu *iommu;
+	struct amd_iommu *iommu = (struct amd_iommu *) data;
+	u32 status = readl(iommu->mmio_base + MMIO_STATUS_OFFSET);
 
-	for_each_iommu(iommu) {
-		iommu_poll_events(iommu);
-		iommu_poll_ppr_log(iommu);
-	}
+	while (status & (MMIO_STATUS_EVT_INT_MASK | MMIO_STATUS_PPR_INT_MASK)) {
+		/* Enable EVT and PPR interrupts again */
+		writel((MMIO_STATUS_EVT_INT_MASK | MMIO_STATUS_PPR_INT_MASK),
+			iommu->mmio_base + MMIO_STATUS_OFFSET);
 
+		if (status & MMIO_STATUS_EVT_INT_MASK) {
+			pr_devel("AMD-Vi: Processing IOMMU Event Log\n");
+			iommu_poll_events(iommu);
+		}
+
+		if (status & MMIO_STATUS_PPR_INT_MASK) {
+			pr_devel("AMD-Vi: Processing IOMMU PPR Log\n");
+			iommu_poll_ppr_log(iommu);
+		}
+
+		/*
+		 * Hardware bug: ERBT1312
+		 * When re-enabling interrupt (by writing 1
+		 * to clear the bit), the hardware might also try to set
+		 * the interrupt bit in the event status register.
+		 * In this scenario, the bit will be set, and disable
+		 * subsequent interrupts.
+		 *
+		 * Workaround: The IOMMU driver should read back the
+		 * status register and check if the interrupt bits are cleared.
+		 * If not, driver will need to go through the interrupt handler
+		 * again and re-clear the bits
+		 */
+		status = readl(iommu->mmio_base + MMIO_STATUS_OFFSET);
+	}
 	return IRQ_HANDLED;
 }
 
diff --git a/drivers/iommu/amd_iommu_init.c b/drivers/iommu/amd_iommu_init.c
index 9767941..3d3d6cd 100644
--- a/drivers/iommu/amd_iommu_init.c
+++ b/drivers/iommu/amd_iommu_init.c
@@ -1324,7 +1324,7 @@ static int iommu_setup_msi(struct amd_iommu *iommu)
 				 amd_iommu_int_handler,
 				 amd_iommu_int_thread,
 				 0, "AMD-Vi",
-				 iommu->dev);
+				 iommu);
 
 	if (r) {
 		pci_disable_msi(iommu->dev);
-- 
1.7.10.4


