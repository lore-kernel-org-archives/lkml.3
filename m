Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752462AbaFOUia (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 16:38:30 -0400
Received: from smtprelay0138.hostedemail.com ([216.40.44.138]:47778 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752411AbaFOUi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 16:38:26 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:800:960:973:988:989:1260:1345:1359:1437:1534:1541:1711:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3352:3865:3866:4321:5007:6119:6261:9592:10004:10026:10848:11026:11232:11473:11658:11914:12043:12296:12438:12517:12519:12555:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: bird55_6650696a3c03e
X-Filterd-Recvd-Size: 2561
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        dmaengine@vger.kernel.org
Subject: [PATCH -next 06/26] dma: Use dma_zalloc_coherent
Date: Sun, 15 Jun 2014 13:37:35 -0700
Message-Id: <a7ccdeb0ef1861b8f126002dfdbf51ed827478fd.1402863905.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1402863904.git.joe@perches.com>
References: <cover.1402863904.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the zeroing function instead of dma_alloc_coherent & memset(,0,)

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/dma/imx-sdma.c | 5 ++---
 drivers/dma/mxs-dma.c  | 8 +++-----
 2 files changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
index 1287146..4758725 100644
--- a/drivers/dma/imx-sdma.c
+++ b/drivers/dma/imx-sdma.c
@@ -904,14 +904,13 @@ static int sdma_request_channel(struct sdma_channel *sdmac)
 	int channel = sdmac->channel;
 	int ret = -EBUSY;
 
-	sdmac->bd = dma_alloc_coherent(NULL, PAGE_SIZE, &sdmac->bd_phys, GFP_KERNEL);
+	sdmac->bd = dma_zalloc_coherent(NULL, PAGE_SIZE, &sdmac->bd_phys,
+					GFP_KERNEL);
 	if (!sdmac->bd) {
 		ret = -ENOMEM;
 		goto out;
 	}
 
-	memset(sdmac->bd, 0, PAGE_SIZE);
-
 	sdma->channel_control[channel].base_bd_ptr = sdmac->bd_phys;
 	sdma->channel_control[channel].current_bd_ptr = sdmac->bd_phys;
 
diff --git a/drivers/dma/mxs-dma.c b/drivers/dma/mxs-dma.c
index ead4913..dc1dba7 100644
--- a/drivers/dma/mxs-dma.c
+++ b/drivers/dma/mxs-dma.c
@@ -413,16 +413,14 @@ static int mxs_dma_alloc_chan_resources(struct dma_chan *chan)
 	struct mxs_dma_engine *mxs_dma = mxs_chan->mxs_dma;
 	int ret;
 
-	mxs_chan->ccw = dma_alloc_coherent(mxs_dma->dma_device.dev,
-				CCW_BLOCK_SIZE, &mxs_chan->ccw_phys,
-				GFP_KERNEL);
+	mxs_chan->ccw = dma_zalloc_coherent(mxs_dma->dma_device.dev,
+					    CCW_BLOCK_SIZE,
+					    &mxs_chan->ccw_phys, GFP_KERNEL);
 	if (!mxs_chan->ccw) {
 		ret = -ENOMEM;
 		goto err_alloc;
 	}
 
-	memset(mxs_chan->ccw, 0, CCW_BLOCK_SIZE);
-
 	if (mxs_chan->chan_irq != NO_IRQ) {
 		ret = request_irq(mxs_chan->chan_irq, mxs_dma_int_handler,
 					0, "mxs-dma", mxs_dma);
-- 
1.8.1.2.459.gbcd45b4.dirty

