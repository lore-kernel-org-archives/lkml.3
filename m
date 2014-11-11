Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014AbaKKSkL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 13:40:11 -0500
Received: from down.free-electrons.com ([37.187.137.238]:53120 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751515AbaKKSkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 13:40:07 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Vinod Koul <vinod.koul@intel.com>, dmaengine@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Chen-Yu Tsai <wens@csie.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        stable@vger.kernel.org
Subject: [PATCH] dmaengine: sun6i: Fix memcpy operation
Date: Tue, 11 Nov 2014 19:35:52 +0100
Message-Id: <1415730952-1945-1-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The prep_memcpy call was not setting any meaningful burst and width because it
was relying on the dma_slave_config was not set already.

Rework the needed conversion functions, and hardcode the width and burst to
use.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: stable@vger.kernel.org
---

Hi Vinod,

This is a fix aimed at 3.18.

Thanks!
Maxime


 drivers/dma/sun6i-dma.c | 61 ++++++++++++++++++++++++-------------------------
 1 file changed, 30 insertions(+), 31 deletions(-)

diff --git a/drivers/dma/sun6i-dma.c b/drivers/dma/sun6i-dma.c
index 3aa10b328254..91292f5513ff 100644
--- a/drivers/dma/sun6i-dma.c
+++ b/drivers/dma/sun6i-dma.c
@@ -230,30 +230,25 @@ static inline void sun6i_dma_dump_chan_regs(struct sun6i_dma_dev *sdev,
 		readl(pchan->base + DMA_CHAN_CUR_PARA));
 }
 
-static inline int convert_burst(u32 maxburst, u8 *burst)
+static inline s8 convert_burst(u32 maxburst)
 {
 	switch (maxburst) {
 	case 1:
-		*burst = 0;
-		break;
+		return 0;
 	case 8:
-		*burst = 2;
-		break;
+		return 2;
 	default:
 		return -EINVAL;
 	}
-
-	return 0;
 }
 
-static inline int convert_buswidth(enum dma_slave_buswidth addr_width, u8 *width)
+static inline s8 convert_buswidth(enum dma_slave_buswidth addr_width)
 {
 	if ((addr_width < DMA_SLAVE_BUSWIDTH_1_BYTE) ||
 	    (addr_width > DMA_SLAVE_BUSWIDTH_4_BYTES))
 		return -EINVAL;
 
-	*width = addr_width >> 1;
-	return 0;
+	return addr_width >> 1;
 }
 
 static void *sun6i_dma_lli_add(struct sun6i_dma_lli *prev,
@@ -284,26 +279,25 @@ static inline int sun6i_dma_cfg_lli(struct sun6i_dma_lli *lli,
 				    struct dma_slave_config *config)
 {
 	u8 src_width, dst_width, src_burst, dst_burst;
-	int ret;
 
 	if (!config)
 		return -EINVAL;
 
-	ret = convert_burst(config->src_maxburst, &src_burst);
-	if (ret)
-		return ret;
+	src_burst = convert_burst(config->src_maxburst);
+	if (src_burst)
+		return src_burst;
 
-	ret = convert_burst(config->dst_maxburst, &dst_burst);
-	if (ret)
-		return ret;
+	dst_burst = convert_burst(config->dst_maxburst);
+	if (dst_burst)
+		return dst_burst;
 
-	ret = convert_buswidth(config->src_addr_width, &src_width);
-	if (ret)
-		return ret;
+	src_width = convert_buswidth(config->src_addr_width);
+	if (src_width)
+		return src_width;
 
-	ret = convert_buswidth(config->dst_addr_width, &dst_width);
-	if (ret)
-		return ret;
+	dst_width = convert_buswidth(config->dst_addr_width);
+	if (dst_width)
+		return dst_width;
 
 	lli->cfg = DMA_CHAN_CFG_SRC_BURST(src_burst) |
 		DMA_CHAN_CFG_SRC_WIDTH(src_width) |
@@ -542,11 +536,10 @@ static struct dma_async_tx_descriptor *sun6i_dma_prep_dma_memcpy(
 {
 	struct sun6i_dma_dev *sdev = to_sun6i_dma_dev(chan->device);
 	struct sun6i_vchan *vchan = to_sun6i_vchan(chan);
-	struct dma_slave_config *sconfig = &vchan->cfg;
 	struct sun6i_dma_lli *v_lli;
 	struct sun6i_desc *txd;
 	dma_addr_t p_lli;
-	int ret;
+	s8 burst, width;
 
 	dev_dbg(chan2dev(chan),
 		"%s; chan: %d, dest: %pad, src: %pad, len: %zu. flags: 0x%08lx\n",
@@ -565,14 +558,21 @@ static struct dma_async_tx_descriptor *sun6i_dma_prep_dma_memcpy(
 		goto err_txd_free;
 	}
 
-	ret = sun6i_dma_cfg_lli(v_lli, src, dest, len, sconfig);
-	if (ret)
-		goto err_dma_free;
+	v_lli->src = src;
+	v_lli->dst = dest;
+	v_lli->len = len;
+	v_lli->para = NORMAL_WAIT;
 
+	burst = convert_burst(8);
+	width = convert_buswidth(DMA_SLAVE_BUSWIDTH_4_BYTES);
 	v_lli->cfg |= DMA_CHAN_CFG_SRC_DRQ(DRQ_SDRAM) |
 		DMA_CHAN_CFG_DST_DRQ(DRQ_SDRAM) |
 		DMA_CHAN_CFG_DST_LINEAR_MODE |
-		DMA_CHAN_CFG_SRC_LINEAR_MODE;
+		DMA_CHAN_CFG_SRC_LINEAR_MODE |
+		DMA_CHAN_CFG_SRC_BURST(burst) |
+		DMA_CHAN_CFG_SRC_WIDTH(width) |
+		DMA_CHAN_CFG_DST_BURST(burst) |
+		DMA_CHAN_CFG_DST_WIDTH(width);
 
 	sun6i_dma_lli_add(NULL, v_lli, p_lli, txd);
 
@@ -580,8 +580,6 @@ static struct dma_async_tx_descriptor *sun6i_dma_prep_dma_memcpy(
 
 	return vchan_tx_prep(&vchan->vc, &txd->vd, flags);
 
-err_dma_free:
-	dma_pool_free(sdev->pool, v_lli, p_lli);
 err_txd_free:
 	kfree(txd);
 	return NULL;
@@ -915,6 +913,7 @@ static int sun6i_dma_probe(struct platform_device *pdev)
 	sdc->slave.device_prep_dma_memcpy	= sun6i_dma_prep_dma_memcpy;
 	sdc->slave.device_control		= sun6i_dma_control;
 	sdc->slave.chancnt			= NR_MAX_VCHANS;
+	sdc->slave.copy_align			= 4;
 
 	sdc->slave.dev = &pdev->dev;
 
-- 
2.1.1

