Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935640Ab3DISkA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 14:40:00 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:64644 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935581Ab3DISj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 14:39:58 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>, Per Forlin <per.forlin@stericsson.com>
Subject: [PATCH 4/8] dmaengine: ste_dma40: Do not configure channels during an channel allocation
Date: Tue,  9 Apr 2013 19:39:39 +0100
Message-Id: <1365532783-27425-4-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1365532783-27425-1-git-send-email-lee.jones@linaro.org>
References: <1365532783-27425-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the DMA documentation allocating a channel and configuring
it are two separate actions. By removing the configuration code from the
channel allocation path we lighten the burden on the information required to
successfully allocate a channel.

Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>
Cc: Per Forlin <per.forlin@stericsson.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/dma/ste_dma40.c |   14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 2a0a9d4..9e423ad 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -2463,16 +2463,10 @@ static int d40_alloc_chan_resources(struct dma_chan *chan)
 	}
 
 	pm_runtime_get_sync(d40c->base->dev);
-	/* Fill in basic CFG register values */
-	d40_phy_cfg(&d40c->dma_cfg, &d40c->src_def_cfg,
-		    &d40c->dst_def_cfg, chan_is_logical(d40c));
 
 	d40_set_prio_realtime(d40c);
 
 	if (chan_is_logical(d40c)) {
-		d40_log_cfg(&d40c->dma_cfg,
-			    &d40c->log_def.lcsp1, &d40c->log_def.lcsp3);
-
 		if (d40c->dma_cfg.dir == STEDMA40_PERIPH_TO_MEM)
 			d40c->lcpa = d40c->base->lcpa_base +
 				d40c->dma_cfg.src_dev_type * D40_LCPA_CHAN_SIZE;
@@ -2487,14 +2481,6 @@ static int d40_alloc_chan_resources(struct dma_chan *chan)
 		 d40c->phy_chan->num,
 		 d40c->dma_cfg.use_fixed_channel ? ", fixed" : "");
 
-
-	/*
-	 * Only write channel configuration to the DMA if the physical
-	 * resource is free. In case of multiple logical channels
-	 * on the same physical resource, only the first write is necessary.
-	 */
-	if (is_free_phy)
-		d40_config_write(d40c);
 fail:
 	pm_runtime_mark_last_busy(d40c->base->dev);
 	pm_runtime_put_autosuspend(d40c->base->dev);
-- 
1.7.10.4

