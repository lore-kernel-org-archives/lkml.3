Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758854Ab3EOJz6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 05:55:58 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:42961 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932709Ab3EOJxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 05:53:08 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        balbi@ti.com, linux-usb@vger.kernel.org, linux-crypto@vger.kernel.org,
        davem@davemloft.net, herbert@gondor.hengli.com.au,
        vinod.koul@intel.com
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>,
        Dan Williams <djbw@fb.com>, Per Forlin <per.forlin@stericsson.com>,
        Rabin Vincent <rabin@rab.in>
Subject: [PATCH 31/39] dmaengine: ste_dma40: Replace ST-E's home-brew DMA direction defs with generic ones
Date: Wed, 15 May 2013 10:51:54 +0100
Message-Id: <1368611522-9984-32-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

STEDMA40_*_TO_* direction definitions are identical in all but name to
the pre-defined generic DMA_*_TO_* ones. Let's make things easy by not
duplicating such things.

Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>
Cc: Per Forlin <per.forlin@stericsson.com>
Cc: Rabin Vincent <rabin@rab.in>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/dma/ste_dma40.c    |   56 ++++++++++++++++++++++----------------------
 drivers/dma/ste_dma40_ll.c |   24 +++++++++----------
 2 files changed, 40 insertions(+), 40 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 08bc58a..483da16 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -78,7 +78,7 @@ static int dma40_memcpy_channels[] = {
 /* Default configuration for physcial memcpy */
 struct stedma40_chan_cfg dma40_memcpy_conf_phy = {
 	.mode = STEDMA40_MODE_PHYSICAL,
-	.dir = STEDMA40_MEM_TO_MEM,
+	.dir = DMA_MEM_TO_MEM,
 
 	.src_info.data_width = STEDMA40_BYTE_WIDTH,
 	.src_info.psize = STEDMA40_PSIZE_PHY_1,
@@ -92,7 +92,7 @@ struct stedma40_chan_cfg dma40_memcpy_conf_phy = {
 /* Default configuration for logical memcpy */
 struct stedma40_chan_cfg dma40_memcpy_conf_log = {
 	.mode = STEDMA40_MODE_LOGICAL,
-	.dir = STEDMA40_MEM_TO_MEM,
+	.dir = DMA_MEM_TO_MEM,
 
 	.src_info.data_width = STEDMA40_BYTE_WIDTH,
 	.src_info.psize = STEDMA40_PSIZE_LOG_1,
@@ -843,7 +843,7 @@ static void d40_log_lli_to_lcxa(struct d40_chan *chan, struct d40_desc *desc)
 		 * that uses linked lists.
 		 */
 		if (!(chan->phy_chan->use_soft_lli &&
-			chan->dma_cfg.dir == STEDMA40_PERIPH_TO_MEM))
+			chan->dma_cfg.dir == DMA_DEV_TO_MEM))
 			curr_lcla = d40_lcla_alloc_one(chan, desc);
 
 		first_lcla = curr_lcla;
@@ -1311,12 +1311,12 @@ static void d40_config_set_event(struct d40_chan *d40c,
 	u32 event = D40_TYPE_TO_EVENT(d40c->dma_cfg.dev_type);
 
 	/* Enable event line connected to device (or memcpy) */
-	if ((d40c->dma_cfg.dir ==  STEDMA40_PERIPH_TO_MEM) ||
-	    (d40c->dma_cfg.dir == STEDMA40_PERIPH_TO_PERIPH))
+	if ((d40c->dma_cfg.dir == DMA_DEV_TO_MEM) ||
+	    (d40c->dma_cfg.dir == DMA_DEV_TO_DEV))
 		__d40_config_set_event(d40c, event_type, event,
 				       D40_CHAN_REG_SSLNK);
 
-	if (d40c->dma_cfg.dir !=  STEDMA40_PERIPH_TO_MEM)
+	if (d40c->dma_cfg.dir !=  DMA_DEV_TO_MEM)
 		__d40_config_set_event(d40c, event_type, event,
 				       D40_CHAN_REG_SDLNK);
 }
@@ -1774,7 +1774,7 @@ static int d40_validate_conf(struct d40_chan *d40c,
 		res = -EINVAL;
 	}
 
-	if (conf->dir == STEDMA40_PERIPH_TO_PERIPH) {
+	if (conf->dir == DMA_DEV_TO_DEV) {
 		/*
 		 * DMAC HW supports it. Will be added to this driver,
 		 * in case any dma client requires it.
@@ -1905,11 +1905,11 @@ static int d40_allocate_channel(struct d40_chan *d40c, bool *first_phy_user)
 	phys = d40c->base->phy_res;
 	num_phy_chans = d40c->base->num_phy_chans;
 
-	if (d40c->dma_cfg.dir == STEDMA40_PERIPH_TO_MEM) {
+	if (d40c->dma_cfg.dir == DMA_DEV_TO_MEM) {
 		log_num = 2 * dev_type;
 		is_src = true;
-	} else if (d40c->dma_cfg.dir == STEDMA40_MEM_TO_PERIPH ||
-		   d40c->dma_cfg.dir == STEDMA40_MEM_TO_MEM) {
+	} else if (d40c->dma_cfg.dir == DMA_MEM_TO_DEV ||
+		   d40c->dma_cfg.dir == DMA_MEM_TO_MEM) {
 		/* dst event lines are used for logical memcpy */
 		log_num = 2 * dev_type + 1;
 		is_src = false;
@@ -1920,7 +1920,7 @@ static int d40_allocate_channel(struct d40_chan *d40c, bool *first_phy_user)
 	event_line = D40_TYPE_TO_EVENT(dev_type);
 
 	if (!is_log) {
-		if (d40c->dma_cfg.dir == STEDMA40_MEM_TO_MEM) {
+		if (d40c->dma_cfg.dir == DMA_MEM_TO_MEM) {
 			/* Find physical half channel */
 			if (d40c->dma_cfg.use_fixed_channel) {
 				i = d40c->dma_cfg.phy_channel;
@@ -2068,10 +2068,10 @@ static int d40_free_dma(struct d40_chan *d40c)
 		return -EINVAL;
 	}
 
-	if (d40c->dma_cfg.dir == STEDMA40_MEM_TO_PERIPH ||
-	    d40c->dma_cfg.dir == STEDMA40_MEM_TO_MEM)
+	if (d40c->dma_cfg.dir == DMA_MEM_TO_DEV ||
+	    d40c->dma_cfg.dir == DMA_MEM_TO_MEM)
 		is_src = false;
-	else if (d40c->dma_cfg.dir == STEDMA40_PERIPH_TO_MEM)
+	else if (d40c->dma_cfg.dir == DMA_DEV_TO_MEM)
 		is_src = true;
 	else {
 		chan_err(d40c, "Unknown direction\n");
@@ -2133,10 +2133,10 @@ static bool d40_is_paused(struct d40_chan *d40c)
 		goto _exit;
 	}
 
-	if (d40c->dma_cfg.dir == STEDMA40_MEM_TO_PERIPH ||
-	    d40c->dma_cfg.dir == STEDMA40_MEM_TO_MEM) {
+	if (d40c->dma_cfg.dir == DMA_MEM_TO_DEV ||
+	    d40c->dma_cfg.dir == DMA_MEM_TO_MEM) {
 		status = readl(chanbase + D40_CHAN_REG_SDLNK);
-	} else if (d40c->dma_cfg.dir == STEDMA40_PERIPH_TO_MEM) {
+	} else if (d40c->dma_cfg.dir == DMA_DEV_TO_MEM) {
 		status = readl(chanbase + D40_CHAN_REG_SSLNK);
 	} else {
 		chan_err(d40c, "Unknown direction\n");
@@ -2387,12 +2387,12 @@ static void d40_set_prio_realtime(struct d40_chan *d40c)
 	if (d40c->base->rev < 3)
 		return;
 
-	if ((d40c->dma_cfg.dir ==  STEDMA40_PERIPH_TO_MEM) ||
-	    (d40c->dma_cfg.dir == STEDMA40_PERIPH_TO_PERIPH))
+	if ((d40c->dma_cfg.dir ==  DMA_DEV_TO_MEM) ||
+	    (d40c->dma_cfg.dir == DMA_DEV_TO_DEV))
 		__d40_set_prio_rt(d40c, d40c->dma_cfg.dev_type, true);
 
-	if ((d40c->dma_cfg.dir ==  STEDMA40_MEM_TO_PERIPH) ||
-	    (d40c->dma_cfg.dir == STEDMA40_PERIPH_TO_PERIPH))
+	if ((d40c->dma_cfg.dir ==  DMA_MEM_TO_DEV) ||
+	    (d40c->dma_cfg.dir == DMA_DEV_TO_DEV))
 		__d40_set_prio_rt(d40c, d40c->dma_cfg.dev_type, false);
 }
 
@@ -2423,11 +2423,11 @@ static struct dma_chan *d40_xlate(struct of_phandle_args *dma_spec,
 
 	switch (D40_DT_FLAGS_DIR(flags)) {
 	case 0:
-		cfg.dir = STEDMA40_MEM_TO_PERIPH;
+		cfg.dir = DMA_MEM_TO_DEV;
 		cfg.dst_info.big_endian = D40_DT_FLAGS_BIG_ENDIAN(flags);
 		break;
 	case 1:
-		cfg.dir = STEDMA40_PERIPH_TO_MEM;
+		cfg.dir = DMA_DEV_TO_MEM;
 		cfg.src_info.big_endian = D40_DT_FLAGS_BIG_ENDIAN(flags);
 		break;
 	}
@@ -2473,7 +2473,7 @@ static int d40_alloc_chan_resources(struct dma_chan *chan)
 	d40_set_prio_realtime(d40c);
 
 	if (chan_is_logical(d40c)) {
-		if (d40c->dma_cfg.dir == STEDMA40_PERIPH_TO_MEM)
+		if (d40c->dma_cfg.dir == DMA_DEV_TO_MEM)
 			d40c->lcpa = d40c->base->lcpa_base +
 				d40c->dma_cfg.dev_type * D40_LCPA_CHAN_SIZE;
 		else
@@ -2746,12 +2746,12 @@ static int d40_set_runtime_config(struct dma_chan *chan,
 	if (config->direction == DMA_DEV_TO_MEM) {
 		config_addr = config->src_addr;
 
-		if (cfg->dir != STEDMA40_PERIPH_TO_MEM)
+		if (cfg->dir != DMA_DEV_TO_MEM)
 			dev_dbg(d40c->base->dev,
 				"channel was not configured for peripheral "
 				"to memory transfer (%d) overriding\n",
 				cfg->dir);
-		cfg->dir = STEDMA40_PERIPH_TO_MEM;
+		cfg->dir = DMA_DEV_TO_MEM;
 
 		/* Configure the memory side */
 		if (dst_addr_width == DMA_SLAVE_BUSWIDTH_UNDEFINED)
@@ -2762,12 +2762,12 @@ static int d40_set_runtime_config(struct dma_chan *chan,
 	} else if (config->direction == DMA_MEM_TO_DEV) {
 		config_addr = config->dst_addr;
 
-		if (cfg->dir != STEDMA40_MEM_TO_PERIPH)
+		if (cfg->dir != DMA_MEM_TO_DEV)
 			dev_dbg(d40c->base->dev,
 				"channel was not configured for memory "
 				"to peripheral transfer (%d) overriding\n",
 				cfg->dir);
-		cfg->dir = STEDMA40_MEM_TO_PERIPH;
+		cfg->dir = DMA_MEM_TO_DEV;
 
 		/* Configure the memory side */
 		if (src_addr_width == DMA_SLAVE_BUSWIDTH_UNDEFINED)
diff --git a/drivers/dma/ste_dma40_ll.c b/drivers/dma/ste_dma40_ll.c
index ab5a2a7..121c0ce 100644
--- a/drivers/dma/ste_dma40_ll.c
+++ b/drivers/dma/ste_dma40_ll.c
@@ -18,23 +18,23 @@ void d40_log_cfg(struct stedma40_chan_cfg *cfg,
 	u32 l1 = 0; /* src */
 
 	/* src is mem? -> increase address pos */
-	if (cfg->dir ==  STEDMA40_MEM_TO_PERIPH ||
-	    cfg->dir ==  STEDMA40_MEM_TO_MEM)
+	if (cfg->dir ==  DMA_MEM_TO_DEV ||
+	    cfg->dir ==  DMA_MEM_TO_MEM)
 		l1 |= 1 << D40_MEM_LCSP1_SCFG_INCR_POS;
 
 	/* dst is mem? -> increase address pos */
-	if (cfg->dir ==  STEDMA40_PERIPH_TO_MEM ||
-	    cfg->dir ==  STEDMA40_MEM_TO_MEM)
+	if (cfg->dir ==  DMA_DEV_TO_MEM ||
+	    cfg->dir ==  DMA_MEM_TO_MEM)
 		l3 |= 1 << D40_MEM_LCSP3_DCFG_INCR_POS;
 
 	/* src is hw? -> master port 1 */
-	if (cfg->dir ==  STEDMA40_PERIPH_TO_MEM ||
-	    cfg->dir ==  STEDMA40_PERIPH_TO_PERIPH)
+	if (cfg->dir ==  DMA_DEV_TO_MEM ||
+	    cfg->dir ==  DMA_DEV_TO_DEV)
 		l1 |= 1 << D40_MEM_LCSP1_SCFG_MST_POS;
 
 	/* dst is hw? -> master port 1 */
-	if (cfg->dir ==  STEDMA40_MEM_TO_PERIPH ||
-	    cfg->dir ==  STEDMA40_PERIPH_TO_PERIPH)
+	if (cfg->dir ==  DMA_MEM_TO_DEV ||
+	    cfg->dir ==  DMA_DEV_TO_DEV)
 		l3 |= 1 << D40_MEM_LCSP3_DCFG_MST_POS;
 
 	l3 |= 1 << D40_MEM_LCSP3_DCFG_EIM_POS;
@@ -55,8 +55,8 @@ void d40_phy_cfg(struct stedma40_chan_cfg *cfg, u32 *src_cfg, u32 *dst_cfg)
 	u32 src = 0;
 	u32 dst = 0;
 
-	if ((cfg->dir ==  STEDMA40_PERIPH_TO_MEM) ||
-	    (cfg->dir == STEDMA40_PERIPH_TO_PERIPH)) {
+	if ((cfg->dir == DMA_DEV_TO_MEM) ||
+	    (cfg->dir == DMA_DEV_TO_DEV)) {
 		/* Set master port to 1 */
 		src |= 1 << D40_SREG_CFG_MST_POS;
 		src |= D40_TYPE_TO_EVENT(cfg->dev_type);
@@ -66,8 +66,8 @@ void d40_phy_cfg(struct stedma40_chan_cfg *cfg, u32 *src_cfg, u32 *dst_cfg)
 		else
 			src |= 3 << D40_SREG_CFG_PHY_TM_POS;
 	}
-	if ((cfg->dir ==  STEDMA40_MEM_TO_PERIPH) ||
-	    (cfg->dir == STEDMA40_PERIPH_TO_PERIPH)) {
+	if ((cfg->dir == DMA_MEM_TO_DEV) ||
+	    (cfg->dir == DMA_DEV_TO_DEV)) {
 		/* Set master port to 1 */
 		dst |= 1 << D40_SREG_CFG_MST_POS;
 		dst |= D40_TYPE_TO_EVENT(cfg->dev_type);
-- 
1.7.10.4

