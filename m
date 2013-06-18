Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136Ab3FRG5H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 02:57:07 -0400
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:33641 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752280Ab3FRG5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 02:57:05 -0400
From: Xiang Wang <wangxfdu@gmail.com>
To: Dan Williams <djbw@fb.com>, Vinod Koul <vinod.koul@intel.com>,
        <linux-kernel@vger.kernel.org>
CC: <wangxfdu@gmail.com>, <cxie4@marvell.com>, Xiang Wang <wangx@marvell.com>
Subject: [PATCH V3 2/2] dma: mmp_pdma: clear DRCMR when free a phy channel
Date: Tue, 18 Jun 2013 14:55:59 +0800
Message-ID: <1371538559-13185-3-git-send-email-wangxfdu@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1371538559-13185-1-git-send-email-wangxfdu@gmail.com>
References: <1371538559-13185-1-git-send-email-wangxfdu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiang Wang <wangx@marvell.com>

In mmp pdma, phy channels are allocated/freed dynamically.
The mapping from DMA request to DMA channel number in DRCMR
should be cleared when a phy channel is freed. Otherwise
conflicts will happen when:
1. A is using channel 2 and free it after finished, but A
still maps to channel 2 in DRCMR of A.
2. Now another one B gets channel 2. So B maps to channel 2
too in DRCMR of B.
In the datasheet, it is described that "Do not map two active
requests to the same channel since it produces unpredictable
results" and we can observe that during test.

Signed-off-by: Xiang Wang <wangx@marvell.com>
---
 drivers/dma/mmp_pdma.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/dma/mmp_pdma.c b/drivers/dma/mmp_pdma.c
index 226158d..2844eaf 100644
--- a/drivers/dma/mmp_pdma.c
+++ b/drivers/dma/mmp_pdma.c
@@ -252,10 +252,16 @@ static void mmp_pdma_free_phy(struct mmp_pdma_chan *pchan)
 {
 	struct mmp_pdma_device *pdev = to_mmp_pdma_dev(pchan->chan.device);
 	unsigned long flags;
+	u32 reg;
 
 	if (!pchan->phy)
 		return;
 
+	/* clear the channel mapping in DRCMR */
+	reg = pchan->phy->vchan->drcmr;
+	reg = ((reg < 64) ? 0x0100 : 0x1100) + ((reg & 0x3f) << 2);
+	writel(0, pchan->phy->base + reg);
+
 	spin_lock_irqsave(&pdev->phy_lock, flags);
 	pchan->phy->vchan = NULL;
 	pchan->phy = NULL;
-- 
1.7.5.4

