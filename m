Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933443Ab3ECOeH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 10:34:07 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:46018 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933256Ab3ECOeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 10:34:03 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, Lee Jones <lee.jones@linaro.org>,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Per Forlin <per.forlin@stericsson.com>, Rabin Vincent <rabin@rab.in>
Subject: [PATCH 19/63] dmaengine: ste_dma40: Separate Logical Global Interrupt Mask (GIM) unmasking
Date: Fri,  3 May 2013 15:32:05 +0100
Message-Id: <1367591569-32197-20-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
References: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During the initial setup of a logical channel, it is necessary to unmask
the GIM in order to receive generated terminal count and error interrupts.
We're separating out this required code so it will be possible to move
the remaining code in d40_phy_cfg(), which is mostly runtime configuration
into the runtime_config() routine.

Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>
Cc: Per Forlin <per.forlin@stericsson.com>
Cc: Rabin Vincent <rabin@rab.in>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/dma/ste_dma40.c    |    4 ++++
 drivers/dma/ste_dma40_ll.c |    5 -----
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 091d6a5..6df1b01 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -2453,6 +2453,10 @@ static int d40_alloc_chan_resources(struct dma_chan *chan)
 			d40c->lcpa = d40c->base->lcpa_base +
 				d40c->dma_cfg.dev_type *
 				D40_LCPA_CHAN_SIZE + D40_LCPA_CHAN_DST_DELTA;
+
+		/* Unmask the Global Interrupt Mask. */
+		d40c->src_def_cfg |= BIT(D40_SREG_CFG_LOG_GIM_POS);
+		d40c->dst_def_cfg |= BIT(D40_SREG_CFG_LOG_GIM_POS);
 	}
 
 	dev_dbg(chan2dev(d40c), "allocated %s channel (phy %d%s)\n",
diff --git a/drivers/dma/ste_dma40_ll.c b/drivers/dma/ste_dma40_ll.c
index 5eb6c10..435a223 100644
--- a/drivers/dma/ste_dma40_ll.c
+++ b/drivers/dma/ste_dma40_ll.c
@@ -107,11 +107,6 @@ void d40_phy_cfg(struct stedma40_chan_cfg *cfg,
 			src |= 1 << D40_SREG_CFG_PRI_POS;
 			dst |= 1 << D40_SREG_CFG_PRI_POS;
 		}
-
-	} else {
-		/* Logical channel */
-		dst |= 1 << D40_SREG_CFG_LOG_GIM_POS;
-		src |= 1 << D40_SREG_CFG_LOG_GIM_POS;
 	}
 
 	if (cfg->src_info.big_endian)
-- 
1.7.10.4

