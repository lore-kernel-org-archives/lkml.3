Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932887Ab3EOKEa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 06:04:30 -0400
Received: from mail-we0-f180.google.com ([74.125.82.180]:48805 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758468Ab3EOJwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 05:52:17 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        balbi@ti.com, linux-usb@vger.kernel.org, linux-crypto@vger.kernel.org,
        davem@davemloft.net, herbert@gondor.hengli.com.au,
        vinod.koul@intel.com
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 02/39] dmaengine: ste_dma40: Remove unnecessary call to d40_phy_cfg()
Date: Wed, 15 May 2013 10:51:25 +0100
Message-Id: <1368611522-9984-3-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
References: <1368611522-9984-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All configuration left in d40_phy_cfg() is runtime configurable and
there is already a call into it from d40_runtime_config(), so let's
rely on that.

Acked-by: Vinod Koul <vnod.koul@intel.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/dma/ste_dma40.c    |   14 +++---
 drivers/dma/ste_dma40_ll.c |  101 +++++++++++++++++++++-----------------------
 drivers/dma/ste_dma40_ll.h |    3 +-
 3 files changed, 58 insertions(+), 60 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 759293e..b7fe46b 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -2043,6 +2043,14 @@ static int d40_config_memcpy(struct d40_chan *d40c)
 	} else if (dma_has_cap(DMA_MEMCPY, cap) &&
 		   dma_has_cap(DMA_SLAVE, cap)) {
 		d40c->dma_cfg = dma40_memcpy_conf_phy;
+
+		/* Generate interrrupt at end of transfer or relink. */
+		d40c->dst_def_cfg |= BIT(D40_SREG_CFG_TIM_POS);
+
+		/* Generate interrupt on error. */
+		d40c->src_def_cfg |= BIT(D40_SREG_CFG_EIM_POS);
+		d40c->dst_def_cfg |= BIT(D40_SREG_CFG_EIM_POS);
+
 	} else {
 		chan_err(d40c, "No memcpy\n");
 		return -EINVAL;
@@ -2496,9 +2504,6 @@ static int d40_alloc_chan_resources(struct dma_chan *chan)
 	}
 
 	pm_runtime_get_sync(d40c->base->dev);
-	/* Fill in basic CFG register values */
-	d40_phy_cfg(&d40c->dma_cfg, &d40c->src_def_cfg,
-		    &d40c->dst_def_cfg, chan_is_logical(d40c));
 
 	d40_set_prio_realtime(d40c);
 
@@ -2862,8 +2867,7 @@ static int d40_set_runtime_config(struct dma_chan *chan,
 	if (chan_is_logical(d40c))
 		d40_log_cfg(cfg, &d40c->log_def.lcsp1, &d40c->log_def.lcsp3);
 	else
-		d40_phy_cfg(cfg, &d40c->src_def_cfg,
-			    &d40c->dst_def_cfg, false);
+		d40_phy_cfg(cfg, &d40c->src_def_cfg, &d40c->dst_def_cfg);
 
 	/* These settings will take precedence later */
 	d40c->runtime_addr = config_addr;
diff --git a/drivers/dma/ste_dma40_ll.c b/drivers/dma/ste_dma40_ll.c
index 435a223..ab5a2a7 100644
--- a/drivers/dma/ste_dma40_ll.c
+++ b/drivers/dma/ste_dma40_ll.c
@@ -50,63 +50,58 @@ void d40_log_cfg(struct stedma40_chan_cfg *cfg,
 
 }
 
-/* Sets up SRC and DST CFG register for both logical and physical channels */
-void d40_phy_cfg(struct stedma40_chan_cfg *cfg,
-		 u32 *src_cfg, u32 *dst_cfg, bool is_log)
+void d40_phy_cfg(struct stedma40_chan_cfg *cfg, u32 *src_cfg, u32 *dst_cfg)
 {
 	u32 src = 0;
 	u32 dst = 0;
 
-	if (!is_log) {
-		/* Physical channel */
-		if ((cfg->dir ==  STEDMA40_PERIPH_TO_MEM) ||
-		    (cfg->dir == STEDMA40_PERIPH_TO_PERIPH)) {
-			/* Set master port to 1 */
-			src |= 1 << D40_SREG_CFG_MST_POS;
-			src |= D40_TYPE_TO_EVENT(cfg->dev_type);
-
-			if (cfg->src_info.flow_ctrl == STEDMA40_NO_FLOW_CTRL)
-				src |= 1 << D40_SREG_CFG_PHY_TM_POS;
-			else
-				src |= 3 << D40_SREG_CFG_PHY_TM_POS;
-		}
-		if ((cfg->dir ==  STEDMA40_MEM_TO_PERIPH) ||
-		    (cfg->dir == STEDMA40_PERIPH_TO_PERIPH)) {
-			/* Set master port to 1 */
-			dst |= 1 << D40_SREG_CFG_MST_POS;
-			dst |= D40_TYPE_TO_EVENT(cfg->dev_type);
-
-			if (cfg->dst_info.flow_ctrl == STEDMA40_NO_FLOW_CTRL)
-				dst |= 1 << D40_SREG_CFG_PHY_TM_POS;
-			else
-				dst |= 3 << D40_SREG_CFG_PHY_TM_POS;
-		}
-		/* Interrupt on end of transfer for destination */
-		dst |= 1 << D40_SREG_CFG_TIM_POS;
-
-		/* Generate interrupt on error */
-		src |= 1 << D40_SREG_CFG_EIM_POS;
-		dst |= 1 << D40_SREG_CFG_EIM_POS;
-
-		/* PSIZE */
-		if (cfg->src_info.psize != STEDMA40_PSIZE_PHY_1) {
-			src |= 1 << D40_SREG_CFG_PHY_PEN_POS;
-			src |= cfg->src_info.psize << D40_SREG_CFG_PSIZE_POS;
-		}
-		if (cfg->dst_info.psize != STEDMA40_PSIZE_PHY_1) {
-			dst |= 1 << D40_SREG_CFG_PHY_PEN_POS;
-			dst |= cfg->dst_info.psize << D40_SREG_CFG_PSIZE_POS;
-		}
-
-		/* Element size */
-		src |= cfg->src_info.data_width << D40_SREG_CFG_ESIZE_POS;
-		dst |= cfg->dst_info.data_width << D40_SREG_CFG_ESIZE_POS;
-
-		/* Set the priority bit to high for the physical channel */
-		if (cfg->high_priority) {
-			src |= 1 << D40_SREG_CFG_PRI_POS;
-			dst |= 1 << D40_SREG_CFG_PRI_POS;
-		}
+	if ((cfg->dir ==  STEDMA40_PERIPH_TO_MEM) ||
+	    (cfg->dir == STEDMA40_PERIPH_TO_PERIPH)) {
+		/* Set master port to 1 */
+		src |= 1 << D40_SREG_CFG_MST_POS;
+		src |= D40_TYPE_TO_EVENT(cfg->dev_type);
+
+		if (cfg->src_info.flow_ctrl == STEDMA40_NO_FLOW_CTRL)
+			src |= 1 << D40_SREG_CFG_PHY_TM_POS;
+		else
+			src |= 3 << D40_SREG_CFG_PHY_TM_POS;
+	}
+	if ((cfg->dir ==  STEDMA40_MEM_TO_PERIPH) ||
+	    (cfg->dir == STEDMA40_PERIPH_TO_PERIPH)) {
+		/* Set master port to 1 */
+		dst |= 1 << D40_SREG_CFG_MST_POS;
+		dst |= D40_TYPE_TO_EVENT(cfg->dev_type);
+
+		if (cfg->dst_info.flow_ctrl == STEDMA40_NO_FLOW_CTRL)
+			dst |= 1 << D40_SREG_CFG_PHY_TM_POS;
+		else
+			dst |= 3 << D40_SREG_CFG_PHY_TM_POS;
+	}
+	/* Interrupt on end of transfer for destination */
+	dst |= 1 << D40_SREG_CFG_TIM_POS;
+
+	/* Generate interrupt on error */
+	src |= 1 << D40_SREG_CFG_EIM_POS;
+	dst |= 1 << D40_SREG_CFG_EIM_POS;
+
+	/* PSIZE */
+	if (cfg->src_info.psize != STEDMA40_PSIZE_PHY_1) {
+		src |= 1 << D40_SREG_CFG_PHY_PEN_POS;
+		src |= cfg->src_info.psize << D40_SREG_CFG_PSIZE_POS;
+	}
+	if (cfg->dst_info.psize != STEDMA40_PSIZE_PHY_1) {
+		dst |= 1 << D40_SREG_CFG_PHY_PEN_POS;
+		dst |= cfg->dst_info.psize << D40_SREG_CFG_PSIZE_POS;
+	}
+
+	/* Element size */
+	src |= cfg->src_info.data_width << D40_SREG_CFG_ESIZE_POS;
+	dst |= cfg->dst_info.data_width << D40_SREG_CFG_ESIZE_POS;
+
+	/* Set the priority bit to high for the physical channel */
+	if (cfg->high_priority) {
+		src |= 1 << D40_SREG_CFG_PRI_POS;
+		dst |= 1 << D40_SREG_CFG_PRI_POS;
 	}
 
 	if (cfg->src_info.big_endian)
diff --git a/drivers/dma/ste_dma40_ll.h b/drivers/dma/ste_dma40_ll.h
index fdde8ef..1b47312 100644
--- a/drivers/dma/ste_dma40_ll.h
+++ b/drivers/dma/ste_dma40_ll.h
@@ -432,8 +432,7 @@ enum d40_lli_flags {
 
 void d40_phy_cfg(struct stedma40_chan_cfg *cfg,
 		 u32 *src_cfg,
-		 u32 *dst_cfg,
-		 bool is_log);
+		 u32 *dst_cfg);
 
 void d40_log_cfg(struct stedma40_chan_cfg *cfg,
 		 u32 *lcsp1,
-- 
1.7.10.4

