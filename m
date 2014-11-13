Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932740AbaKML4Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 06:56:24 -0500
Received: from mail.kmu-office.ch ([178.209.48.109]:53796 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932329AbaKML4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 06:56:23 -0500
From: Stefan Agner <stefan@agner.ch>
To: vinod.koul@intel.com
Cc: jingchang.lu@freescale.com, dan.j.williams@intel.com,
        dmaengine@vger.kernel.org, shawn.guo@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de, Stefan Agner <stefan@agner.ch>
Subject: [PATCH] dmaengine: fsl-edma: fix calculation of remaining bytes
Date: Thu, 13 Nov 2014 12:56:02 +0100
Message-Id: <1415879762-12177-1-git-send-email-stefan@agner.ch>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the current transfer control descriptor (TCD) was not yet started,
the address will be the same as the initial address. Hence test if the
current address is less than or equal to the start address of each TCD.

Signed-off-by: Stefan Agner <stefan@agner.ch>
---
This bug was discovered during development on a AC97 capable SAI driver,
I don't think that this is currently a issue since only a few drivers
use DMA on Vybrid so far and don't use the remaining bytes information.

 drivers/dma/fsl-edma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/fsl-edma.c b/drivers/dma/fsl-edma.c
index 3c5711d..58c6fc7 100644
--- a/drivers/dma/fsl-edma.c
+++ b/drivers/dma/fsl-edma.c
@@ -386,7 +386,7 @@ static size_t fsl_edma_desc_residue(struct fsl_edma_chan *fsl_chan,
 					&(edesc->tcd[i].vtcd->daddr));
 
 		len -= size;
-		if (cur_addr > dma_addr && cur_addr < dma_addr + size) {
+		if (cur_addr >= dma_addr && cur_addr < dma_addr + size) {
 			len += dma_addr + size - cur_addr;
 			break;
 		}
-- 
2.1.3

