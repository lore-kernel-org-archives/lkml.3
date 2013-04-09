Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935721Ab3DISkH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 14:40:07 -0400
Received: from mail-we0-f172.google.com ([74.125.82.172]:42690 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935655Ab3DISkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 14:40:04 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>, Per Forlin <per.forlin@stericsson.com>
Subject: [PATCH 6/8] dmaengine: ste_dma40: Move LCPA allocation and real-time config
Date: Tue,  9 Apr 2013 19:39:41 +0100
Message-Id: <1365532783-27425-6-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1365532783-27425-1-git-send-email-lee.jones@linaro.org>
References: <1365532783-27425-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are various pieces of configuration which do not need to happen
until after a channel is allocated. Here we move some of these so they're
dealt with when it's time to configure the channel, rather than allocate
it.

Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>
Cc: Per Forlin <per.forlin@stericsson.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/dma/ste_dma40.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 49d8c9d..c14db3e 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -2464,18 +2464,6 @@ static int d40_alloc_chan_resources(struct dma_chan *chan)
 
 	pm_runtime_get_sync(d40c->base->dev);
 
-	d40_set_prio_realtime(d40c);
-
-	if (chan_is_logical(d40c)) {
-		if (d40c->dma_cfg.dir == STEDMA40_PERIPH_TO_MEM)
-			d40c->lcpa = d40c->base->lcpa_base +
-				d40c->dma_cfg.src_dev_type * D40_LCPA_CHAN_SIZE;
-		else
-			d40c->lcpa = d40c->base->lcpa_base +
-				d40c->dma_cfg.dst_dev_type *
-				D40_LCPA_CHAN_SIZE + D40_LCPA_CHAN_DST_DELTA;
-	}
-
 	dev_dbg(chan2dev(d40c), "allocated %s channel (phy %d%s)\n",
 		 chan_is_logical(d40c) ? "logical" : "physical",
 		 d40c->phy_chan->num,
@@ -2814,6 +2802,18 @@ static int d40_set_runtime_config(struct dma_chan *chan,
 	d40_phy_cfg(cfg, &d40c->src_def_cfg, &d40c->dst_def_cfg,
 		    chan_is_logical(d40c));
 
+	d40_set_prio_realtime(d40c);
+
+	if (chan_is_logical(d40c)) {
+		if (cfg->dir == STEDMA40_PERIPH_TO_MEM)
+			d40c->lcpa = d40c->base->lcpa_base +
+				cfg->src_dev_type * D40_LCPA_CHAN_SIZE;
+		else
+			d40c->lcpa = d40c->base->lcpa_base +
+				cfg->dst_dev_type *
+				D40_LCPA_CHAN_SIZE + D40_LCPA_CHAN_DST_DELTA;
+	}
+
 	/* These settings will take precedence later */
 	d40c->runtime_addr = config_addr;
 	d40c->runtime_direction = config->direction;
-- 
1.7.10.4

