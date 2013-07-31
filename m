Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759116Ab3GaHSu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 03:18:50 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:37353 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759091Ab3GaHSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 03:18:47 -0400
From: Alexander Popov <a13xp0p0v88@gmail.com>
To: Gerhard Sittig <gsi@denx.de>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>, Lars-Peter Clausen <lars@metafoo.de>,
        Arnd Bergmann <arnd@arndb.de>, Anatolij Gustschin <agust@denx.de>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH RFC v3 1/5] dma: mpc512x: reorder mpc8308 specific instructions
Date: Wed, 31 Jul 2013 11:20:54 +0400
Message-Id: <1375255254-10955-1-git-send-email-a13xp0p0v88@gmail.com>
X-Mailer: git-send-email 1.7.11.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gerhard Sittig <gsi@denx.de>

Concentrate the test and the specific code for MPC8308
in the 'if' branch and handle MPC512x in the 'else' branch.

This modification only reorders instructions but doesn't change behaviour.

Signed-off-by: Alexander Popov <a13xp0p0v88@gmail.com>
---
 drivers/dma/mpc512x_dma.c | 42 +++++++++++++++++++++++++-----------------
 1 file changed, 25 insertions(+), 17 deletions(-)

diff --git a/drivers/dma/mpc512x_dma.c b/drivers/dma/mpc512x_dma.c
index 2d95673..b8881de 100644
--- a/drivers/dma/mpc512x_dma.c
+++ b/drivers/dma/mpc512x_dma.c
@@ -50,9 +50,17 @@
 #define MPC_DMA_DESCRIPTORS	64
 
 /* Macro definitions */
-#define MPC_DMA_CHANNELS	64
 #define MPC_DMA_TCD_OFFSET	0x1000
 
+/*
+ * Maximum channel counts for individual hardware variants
+ * and the maximum channel count over all supported controllers,
+ * used for data structure size
+ */
+#define MPC8308_DMACHAN_MAX	16
+#define MPC512x_DMACHAN_MAX	64
+#define MPC_DMA_CHANNELS	64
+
 /* Arbitration mode of group and channel */
 #define MPC_DMA_DMACR_EDCG	(1 << 31)
 #define MPC_DMA_DMACR_ERGA	(1 << 3)
@@ -716,10 +724,10 @@ static int mpc_dma_probe(struct platform_device *op)
 
 	dma = &mdma->dma;
 	dma->dev = dev;
-	if (!mdma->is_mpc8308)
-		dma->chancnt = MPC_DMA_CHANNELS;
+	if (mdma->is_mpc8308)
+		dma->chancnt = MPC8308_DMACHAN_MAX;
 	else
-		dma->chancnt = 16; /* MPC8308 DMA has only 16 channels */
+		dma->chancnt = MPC512x_DMACHAN_MAX;
 	dma->device_alloc_chan_resources = mpc_dma_alloc_chan_resources;
 	dma->device_free_chan_resources = mpc_dma_free_chan_resources;
 	dma->device_issue_pending = mpc_dma_issue_pending;
@@ -753,7 +761,19 @@ static int mpc_dma_probe(struct platform_device *op)
 	 * - Round-robin group arbitration,
 	 * - Round-robin channel arbitration.
 	 */
-	if (!mdma->is_mpc8308) {
+	if (mdma->is_mpc8308) {
+		/* MPC8308 has 16 channels and lacks some registers */
+		out_be32(&mdma->regs->dmacr, MPC_DMA_DMACR_ERCA);
+
+		/* enable snooping */
+		out_be32(&mdma->regs->dmagpor, MPC_DMA_DMAGPOR_SNOOP_ENABLE);
+		/* Disable error interrupts */
+		out_be32(&mdma->regs->dmaeeil, 0);
+
+		/* Clear interrupts status */
+		out_be32(&mdma->regs->dmaintl, 0xFFFF);
+		out_be32(&mdma->regs->dmaerrl, 0xFFFF);
+	} else {
 		out_be32(&mdma->regs->dmacr, MPC_DMA_DMACR_EDCG |
 					MPC_DMA_DMACR_ERGA | MPC_DMA_DMACR_ERCA);
 
@@ -774,18 +794,6 @@ static int mpc_dma_probe(struct platform_device *op)
 		/* Route interrupts to IPIC */
 		out_be32(&mdma->regs->dmaihsa, 0);
 		out_be32(&mdma->regs->dmailsa, 0);
-	} else {
-		/* MPC8308 has 16 channels and lacks some registers */
-		out_be32(&mdma->regs->dmacr, MPC_DMA_DMACR_ERCA);
-
-		/* enable snooping */
-		out_be32(&mdma->regs->dmagpor, MPC_DMA_DMAGPOR_SNOOP_ENABLE);
-		/* Disable error interrupts */
-		out_be32(&mdma->regs->dmaeeil, 0);
-
-		/* Clear interrupts status */
-		out_be32(&mdma->regs->dmaintl, 0xFFFF);
-		out_be32(&mdma->regs->dmaerrl, 0xFFFF);
 	}
 
 	/* Register DMA engine */
-- 
1.7.11.3

