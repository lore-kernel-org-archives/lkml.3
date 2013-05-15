Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758551Ab3EOJzf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 05:55:35 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:57057 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932738Ab3EOJxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 05:53:13 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        balbi@ti.com, linux-usb@vger.kernel.org, linux-crypto@vger.kernel.org,
        davem@davemloft.net, herbert@gondor.hengli.com.au,
        vinod.koul@intel.com
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>,
        Dan Williams <djbw@fb.com>, Per Forlin <per.forlin@stericsson.com>,
        Rabin Vincent <rabin@rab.in>
Subject: [PATCH 34/39] dmaengine: ste_dma40: Convert data_width from register bit format to value
Date: Wed, 15 May 2013 10:51:57 +0100
Message-Id: <1368611522-9984-35-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a DMA client requests and configures a DMA channel, it requests
data_width in Bytes. The DMA40 driver then swiftly converts it over to
the necessary register bit value. Unfortunately, for any subsequent
calculations we have to shift '1' by the bit pattern (1 << data_width)
times to make any sense of it.

This patch flips the semantics on its head and only converts the value
to its respective register bit pattern when writing to registers. This
way we can use the true data_width (in Bytes) value.

Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>
Cc: Per Forlin <per.forlin@stericsson.com>
Cc: Rabin Vincent <rabin@rab.in>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/dma/ste_dma40.c                     |   63 +++++++++++----------------
 drivers/dma/ste_dma40_ll.c                  |   43 ++++++++++++------
 include/linux/platform_data/dma-ste-dma40.h |    9 +---
 sound/soc/ux500/ux500_pcm.c                 |   10 ++---
 4 files changed, 60 insertions(+), 65 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 483da16..76c255f 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -80,11 +80,11 @@ struct stedma40_chan_cfg dma40_memcpy_conf_phy = {
 	.mode = STEDMA40_MODE_PHYSICAL,
 	.dir = DMA_MEM_TO_MEM,
 
-	.src_info.data_width = STEDMA40_BYTE_WIDTH,
+	.src_info.data_width = DMA_SLAVE_BUSWIDTH_1_BYTE,
 	.src_info.psize = STEDMA40_PSIZE_PHY_1,
 	.src_info.flow_ctrl = STEDMA40_NO_FLOW_CTRL,
 
-	.dst_info.data_width = STEDMA40_BYTE_WIDTH,
+	.dst_info.data_width = DMA_SLAVE_BUSWIDTH_1_BYTE,
 	.dst_info.psize = STEDMA40_PSIZE_PHY_1,
 	.dst_info.flow_ctrl = STEDMA40_NO_FLOW_CTRL,
 };
@@ -94,11 +94,11 @@ struct stedma40_chan_cfg dma40_memcpy_conf_log = {
 	.mode = STEDMA40_MODE_LOGICAL,
 	.dir = DMA_MEM_TO_MEM,
 
-	.src_info.data_width = STEDMA40_BYTE_WIDTH,
+	.src_info.data_width = DMA_SLAVE_BUSWIDTH_1_BYTE,
 	.src_info.psize = STEDMA40_PSIZE_LOG_1,
 	.src_info.flow_ctrl = STEDMA40_NO_FLOW_CTRL,
 
-	.dst_info.data_width = STEDMA40_BYTE_WIDTH,
+	.dst_info.data_width = DMA_SLAVE_BUSWIDTH_1_BYTE,
 	.dst_info.psize = STEDMA40_PSIZE_LOG_1,
 	.dst_info.flow_ctrl = STEDMA40_NO_FLOW_CTRL,
 };
@@ -1005,20 +1005,21 @@ static int d40_psize_2_burst_size(bool is_log, int psize)
 
 /*
  * The dma only supports transmitting packages up to
- * STEDMA40_MAX_SEG_SIZE << data_width. Calculate the total number of
- * dma elements required to send the entire sg list
+ * STEDMA40_MAX_SEG_SIZE * data_width, where data_width is stored in Bytes.
+ *
+ * Calculate the total number of dma elements required to send the entire sg list.
  */
 static int d40_size_2_dmalen(int size, u32 data_width1, u32 data_width2)
 {
 	int dmalen;
 	u32 max_w = max(data_width1, data_width2);
 	u32 min_w = min(data_width1, data_width2);
-	u32 seg_max = ALIGN(STEDMA40_MAX_SEG_SIZE << min_w, 1 << max_w);
+	u32 seg_max = ALIGN(STEDMA40_MAX_SEG_SIZE * min_w, max_w);
 
 	if (seg_max > STEDMA40_MAX_SEG_SIZE)
-		seg_max -= (1 << max_w);
+		seg_max -= max_w;
 
-	if (!IS_ALIGNED(size, 1 << max_w))
+	if (!IS_ALIGNED(size, max_w))
 		return -EINVAL;
 
 	if (size <= seg_max)
@@ -1464,7 +1465,7 @@ static u32 d40_residue(struct d40_chan *d40c)
 			  >> D40_SREG_ELEM_PHY_ECNT_POS;
 	}
 
-	return num_elt * (1 << d40c->dma_cfg.dst_info.data_width);
+	return num_elt * d40c->dma_cfg.dst_info.data_width;
 }
 
 static bool d40_tx_is_linked(struct d40_chan *d40c)
@@ -1784,9 +1785,9 @@ static int d40_validate_conf(struct d40_chan *d40c,
 	}
 
 	if (d40_psize_2_burst_size(is_log, conf->src_info.psize) *
-	    (1 << conf->src_info.data_width) !=
+	    conf->src_info.data_width !=
 	    d40_psize_2_burst_size(is_log, conf->dst_info.psize) *
-	    (1 << conf->dst_info.data_width)) {
+	    conf->dst_info.data_width) {
 		/*
 		 * The DMAC hardware only supports
 		 * src (burst x width) == dst (burst x width)
@@ -2673,33 +2674,10 @@ static void d40_terminate_all(struct dma_chan *chan)
 static int
 dma40_config_to_halfchannel(struct d40_chan *d40c,
 			    struct stedma40_half_channel_info *info,
-			    enum dma_slave_buswidth width,
 			    u32 maxburst)
 {
-	enum stedma40_periph_data_width addr_width;
 	int psize;
 
-	switch (width) {
-	case DMA_SLAVE_BUSWIDTH_1_BYTE:
-		addr_width = STEDMA40_BYTE_WIDTH;
-		break;
-	case DMA_SLAVE_BUSWIDTH_2_BYTES:
-		addr_width = STEDMA40_HALFWORD_WIDTH;
-		break;
-	case DMA_SLAVE_BUSWIDTH_4_BYTES:
-		addr_width = STEDMA40_WORD_WIDTH;
-		break;
-	case DMA_SLAVE_BUSWIDTH_8_BYTES:
-		addr_width = STEDMA40_DOUBLEWORD_WIDTH;
-		break;
-	default:
-		dev_err(d40c->base->dev,
-			"illegal peripheral address width "
-			"requested (%d)\n",
-			width);
-		return -EINVAL;
-	}
-
 	if (chan_is_logical(d40c)) {
 		if (maxburst >= 16)
 			psize = STEDMA40_PSIZE_LOG_16;
@@ -2720,7 +2698,6 @@ dma40_config_to_halfchannel(struct d40_chan *d40c,
 			psize = STEDMA40_PSIZE_PHY_1;
 	}
 
-	info->data_width = addr_width;
 	info->psize = psize;
 	info->flow_ctrl = STEDMA40_NO_FLOW_CTRL;
 
@@ -2804,14 +2781,24 @@ static int d40_set_runtime_config(struct dma_chan *chan,
 		src_maxburst = dst_maxburst * dst_addr_width / src_addr_width;
 	}
 
+	/* Only valid widths are; 1, 2, 4 and 8. */
+	if (src_addr_width <= DMA_SLAVE_BUSWIDTH_UNDEFINED ||
+	    src_addr_width >  DMA_SLAVE_BUSWIDTH_8_BYTES   ||
+	    dst_addr_width <= DMA_SLAVE_BUSWIDTH_UNDEFINED ||
+	    dst_addr_width >  DMA_SLAVE_BUSWIDTH_8_BYTES   ||
+	    ((src_addr_width > 1) && (src_addr_width & 1)) ||
+	    ((dst_addr_width > 1) && (dst_addr_width & 1)))
+		return -EINVAL;
+
+	cfg->src_info.data_width = src_addr_width;
+	cfg->dst_info.data_width = dst_addr_width;
+
 	ret = dma40_config_to_halfchannel(d40c, &cfg->src_info,
-					  src_addr_width,
 					  src_maxburst);
 	if (ret)
 		return ret;
 
 	ret = dma40_config_to_halfchannel(d40c, &cfg->dst_info,
-					  dst_addr_width,
 					  dst_maxburst);
 	if (ret)
 		return ret;
diff --git a/drivers/dma/ste_dma40_ll.c b/drivers/dma/ste_dma40_ll.c
index 5ddd724..a035dfe 100644
--- a/drivers/dma/ste_dma40_ll.c
+++ b/drivers/dma/ste_dma40_ll.c
@@ -10,6 +10,18 @@
 
 #include "ste_dma40_ll.h"
 
+u8 d40_width_to_bits(enum dma_slave_buswidth width)
+{
+	if (width == DMA_SLAVE_BUSWIDTH_1_BYTE)
+		return STEDMA40_ESIZE_8_BIT;
+	else if (width == DMA_SLAVE_BUSWIDTH_2_BYTES)
+		return STEDMA40_ESIZE_16_BIT;
+	else if (width == DMA_SLAVE_BUSWIDTH_8_BYTES)
+		return STEDMA40_ESIZE_64_BIT;
+	else
+		return STEDMA40_ESIZE_32_BIT;
+}
+
 /* Sets up proper LCSP1 and LCSP3 register for a logical channel */
 void d40_log_cfg(struct stedma40_chan_cfg *cfg,
 		 u32 *lcsp1, u32 *lcsp3)
@@ -39,11 +51,13 @@ void d40_log_cfg(struct stedma40_chan_cfg *cfg,
 
 	l3 |= BIT(D40_MEM_LCSP3_DCFG_EIM_POS);
 	l3 |= cfg->dst_info.psize << D40_MEM_LCSP3_DCFG_PSIZE_POS;
-	l3 |= cfg->dst_info.data_width << D40_MEM_LCSP3_DCFG_ESIZE_POS;
+	l3 |= d40_width_to_bits(cfg->dst_info.data_width)
+		<< D40_MEM_LCSP3_DCFG_ESIZE_POS;
 
 	l1 |= BIT(D40_MEM_LCSP1_SCFG_EIM_POS);
 	l1 |= cfg->src_info.psize << D40_MEM_LCSP1_SCFG_PSIZE_POS;
-	l1 |= cfg->src_info.data_width << D40_MEM_LCSP1_SCFG_ESIZE_POS;
+	l1 |= d40_width_to_bits(cfg->src_info.data_width)
+		<< D40_MEM_LCSP1_SCFG_ESIZE_POS;
 
 	*lcsp1 = l1;
 	*lcsp3 = l3;
@@ -95,8 +109,10 @@ void d40_phy_cfg(struct stedma40_chan_cfg *cfg, u32 *src_cfg, u32 *dst_cfg)
 	}
 
 	/* Element size */
-	src |= cfg->src_info.data_width << D40_SREG_CFG_ESIZE_POS;
-	dst |= cfg->dst_info.data_width << D40_SREG_CFG_ESIZE_POS;
+	src |= d40_width_to_bits(cfg->src_info.data_width)
+		<< D40_SREG_CFG_ESIZE_POS;
+	dst |= d40_width_to_bits(cfg->dst_info.data_width)
+		<< D40_SREG_CFG_ESIZE_POS;
 
 	/* Set the priority bit to high for the physical channel */
 	if (cfg->high_priority) {
@@ -133,23 +149,22 @@ static int d40_phy_fill_lli(struct d40_phy_lli *lli,
 		num_elems = 2 << psize;
 
 	/* Must be aligned */
-	if (!IS_ALIGNED(data, 0x1 << data_width))
+	if (!IS_ALIGNED(data, data_width))
 		return -EINVAL;
 
 	/* Transfer size can't be smaller than (num_elms * elem_size) */
-	if (data_size < num_elems * (0x1 << data_width))
+	if (data_size < num_elems * data_width)
 		return -EINVAL;
 
 	/* The number of elements. IE now many chunks */
-	lli->reg_elt = (data_size >> data_width) << D40_SREG_ELEM_PHY_ECNT_POS;
+	lli->reg_elt = (data_size / data_width) << D40_SREG_ELEM_PHY_ECNT_POS;
 
 	/*
 	 * Distance to next element sized entry.
 	 * Usually the size of the element unless you want gaps.
 	 */
 	if (addr_inc)
-		lli->reg_elt |= (0x1 << data_width) <<
-			D40_SREG_ELEM_PHY_EIDX_POS;
+		lli->reg_elt |= data_width << D40_SREG_ELEM_PHY_EIDX_POS;
 
 	/* Where the data is */
 	lli->reg_ptr = data;
@@ -177,16 +192,16 @@ static int d40_seg_size(int size, int data_width1, int data_width2)
 {
 	u32 max_w = max(data_width1, data_width2);
 	u32 min_w = min(data_width1, data_width2);
-	u32 seg_max = ALIGN(STEDMA40_MAX_SEG_SIZE << min_w, 1 << max_w);
+	u32 seg_max = ALIGN(STEDMA40_MAX_SEG_SIZE * min_w, max_w);
 
 	if (seg_max > STEDMA40_MAX_SEG_SIZE)
-		seg_max -= (1 << max_w);
+		seg_max -= max_w;
 
 	if (size <= seg_max)
 		return size;
 
 	if (size <= 2 * seg_max)
-		return ALIGN(size / 2, 1 << max_w);
+		return ALIGN(size / 2, max_w);
 
 	return seg_max;
 }
@@ -352,10 +367,10 @@ static void d40_log_fill_lli(struct d40_log_lli *lli,
 	lli->lcsp13 = reg_cfg;
 
 	/* The number of elements to transfer */
-	lli->lcsp02 = ((data_size >> data_width) <<
+	lli->lcsp02 = ((data_size / data_width) <<
 		       D40_MEM_LCSP0_ECNT_POS) & D40_MEM_LCSP0_ECNT_MASK;
 
-	BUG_ON((data_size >> data_width) > STEDMA40_MAX_SEG_SIZE);
+	BUG_ON((data_size / data_width) > STEDMA40_MAX_SEG_SIZE);
 
 	/* 16 LSBs address of the current element */
 	lli->lcsp02 |= data & D40_MEM_LCSP0_SPTR_MASK;
diff --git a/include/linux/platform_data/dma-ste-dma40.h b/include/linux/platform_data/dma-ste-dma40.h
index 54ddca6..ceba6dc 100644
--- a/include/linux/platform_data/dma-ste-dma40.h
+++ b/include/linux/platform_data/dma-ste-dma40.h
@@ -70,13 +70,6 @@ enum stedma40_flow_ctrl {
 	STEDMA40_FLOW_CTRL,
 };
 
-enum stedma40_periph_data_width {
-	STEDMA40_BYTE_WIDTH = STEDMA40_ESIZE_8_BIT,
-	STEDMA40_HALFWORD_WIDTH = STEDMA40_ESIZE_16_BIT,
-	STEDMA40_WORD_WIDTH = STEDMA40_ESIZE_32_BIT,
-	STEDMA40_DOUBLEWORD_WIDTH = STEDMA40_ESIZE_64_BIT
-};
-
 /**
  * struct stedma40_half_channel_info - dst/src channel configuration
  *
@@ -87,7 +80,7 @@ enum stedma40_periph_data_width {
  */
 struct stedma40_half_channel_info {
 	bool big_endian;
-	enum stedma40_periph_data_width data_width;
+	enum dma_slave_buswidth data_width;
 	int psize;
 	enum stedma40_flow_ctrl flow_ctrl;
 };
diff --git a/sound/soc/ux500/ux500_pcm.c b/sound/soc/ux500/ux500_pcm.c
index b6e5ae2..31f9bbc 100644
--- a/sound/soc/ux500/ux500_pcm.c
+++ b/sound/soc/ux500/ux500_pcm.c
@@ -76,20 +76,20 @@ static struct dma_chan *ux500_pcm_request_chan(struct snd_soc_pcm_runtime *rtd,
 	dma_params = snd_soc_dai_get_dma_data(dai, substream);
 	dma_cfg = dma_params->dma_cfg;
 
-	mem_data_width = STEDMA40_HALFWORD_WIDTH;
+	mem_data_width = DMA_SLAVE_BUSWIDTH_2_BYTES;
 
 	switch (dma_params->data_size) {
 	case 32:
-		per_data_width = STEDMA40_WORD_WIDTH;
+		per_data_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
 		break;
 	case 16:
-		per_data_width = STEDMA40_HALFWORD_WIDTH;
+		per_data_width = DMA_SLAVE_BUSWIDTH_2_BYTES;
 		break;
 	case 8:
-		per_data_width = STEDMA40_BYTE_WIDTH;
+		per_data_width = DMA_SLAVE_BUSWIDTH_1_BYTE;
 		break;
 	default:
-		per_data_width = STEDMA40_WORD_WIDTH;
+		per_data_width = DMA_SLAVE_BUSWIDTH_4_BYTES;
 	}
 
 	if (substream->stream == SNDRV_PCM_STREAM_PLAYBACK) {
-- 
1.7.10.4

