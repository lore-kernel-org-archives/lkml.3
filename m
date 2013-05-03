Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933590Ab3ECOoh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 10:44:37 -0400
Received: from mail-wi0-f169.google.com ([209.85.212.169]:36122 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933475Ab3ECOe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 10:34:28 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 31/63] dmaengine: ste_dma40: Only use addresses passed as configuration information
Date: Fri,  3 May 2013 15:32:17 +0100
Message-Id: <1367591569-32197-32-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
References: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Addresses are passed in from the client's driver via the invocation of
dmaengine_slave_config(), so there's no need to fetch them from platform
data too, hardwired or otherwise. This is a great step forward, as it
elevates a large burden from platform data in the way of a look-up
table.

Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/dma/ste_dma40.c |   51 ++++++++++-------------------------------------
 1 file changed, 11 insertions(+), 40 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index b77d508..3ff6ea4 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1760,22 +1760,6 @@ static int d40_validate_conf(struct d40_chan *d40c,
 		res = -EINVAL;
 	}
 
-	if (conf->dir == STEDMA40_MEM_TO_PERIPH &&
-	    d40c->base->plat_data->dev_tx[conf->dev_type] == 0 &&
-	    d40c->runtime_addr == 0) {
-		chan_err(d40c, "Invalid TX channel address (%d)\n",
-			 conf->dev_type);
-		res = -EINVAL;
-	}
-
-	if (conf->dir == STEDMA40_PERIPH_TO_MEM &&
-	    d40c->base->plat_data->dev_rx[conf->dev_type] == 0 &&
-	    d40c->runtime_addr == 0) {
-		chan_err(d40c, "Invalid RX channel address (%d)\n",
-			 conf->dev_type);
-		res = -EINVAL;
-	}
-
 	if (conf->dir == STEDMA40_PERIPH_TO_PERIPH) {
 		/*
 		 * DMAC HW supports it. Will be added to this driver,
@@ -2313,14 +2297,10 @@ d40_prep_sg(struct dma_chan *dchan, struct scatterlist *sg_src,
 	if (sg_next(&sg_src[sg_len - 1]) == sg_src)
 		desc->cyclic = true;
 
-	if (direction != DMA_TRANS_NONE) {
-		dma_addr_t dev_addr = d40_get_dev_addr(chan, direction);
-
-		if (direction == DMA_DEV_TO_MEM)
-			src_dev_addr = dev_addr;
-		else if (direction == DMA_MEM_TO_DEV)
-			dst_dev_addr = dev_addr;
-	}
+	if (direction == DMA_DEV_TO_MEM)
+		src_dev_addr = chan->runtime_addr;
+	else if (direction == DMA_MEM_TO_DEV)
+		dst_dev_addr = chan->runtime_addr;
 
 	if (chan_is_logical(chan))
 		ret = d40_prep_sg_log(chan, desc, sg_src, sg_dst,
@@ -2768,15 +2748,8 @@ static int d40_set_runtime_config(struct dma_chan *chan,
 	dst_maxburst = config->dst_maxburst;
 
 	if (config->direction == DMA_DEV_TO_MEM) {
-		dma_addr_t dev_addr_rx =
-			d40c->base->plat_data->dev_rx[cfg->dev_type];
-
 		config_addr = config->src_addr;
-		if (dev_addr_rx)
-			dev_dbg(d40c->base->dev,
-				"channel has a pre-wired RX address %08x "
-				"overriding with %08x\n",
-				dev_addr_rx, config_addr);
+
 		if (cfg->dir != STEDMA40_PERIPH_TO_MEM)
 			dev_dbg(d40c->base->dev,
 				"channel was not configured for peripheral "
@@ -2791,15 +2764,8 @@ static int d40_set_runtime_config(struct dma_chan *chan,
 			dst_maxburst = src_maxburst;
 
 	} else if (config->direction == DMA_MEM_TO_DEV) {
-		dma_addr_t dev_addr_tx =
-			d40c->base->plat_data->dev_tx[cfg->dev_type];
-
 		config_addr = config->dst_addr;
-		if (dev_addr_tx)
-			dev_dbg(d40c->base->dev,
-				"channel has a pre-wired TX address %08x "
-				"overriding with %08x\n",
-				dev_addr_tx, config_addr);
+
 		if (cfg->dir != STEDMA40_MEM_TO_PERIPH)
 			dev_dbg(d40c->base->dev,
 				"channel was not configured for memory "
@@ -2819,6 +2785,11 @@ static int d40_set_runtime_config(struct dma_chan *chan,
 		return -EINVAL;
 	}
 
+	if (config_addr <= 0) {
+		dev_err(d40c->base->dev, "no address supplied\n");
+		return -EINVAL;
+	}
+
 	if (src_maxburst * src_addr_width != dst_maxburst * dst_addr_width) {
 		dev_err(d40c->base->dev,
 			"src/dst width/maxburst mismatch: %d*%d != %d*%d\n",
-- 
1.7.10.4

