Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030277Ab3DRKSA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 06:18:00 -0400
Received: from mail-wi0-f179.google.com ([209.85.212.179]:61177 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967848Ab3DRKNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 06:13:07 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>, Per Forlin <per.forlin@stericsson.com>,
        Rabin Vincent <rabin@rab.in>
Subject: [PATCH 19/32] dmaengine: ste_dma40: Move more setup into the configuration routines
Date: Thu, 18 Apr 2013 11:12:01 +0100
Message-Id: <1366279934-30761-20-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The less configuration we can do during the allocation of a channel the
better. As this will mean the likelihood of requiring extra information
which isn't normally passed through the dma_request_channel() is lessened.

Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>
Cc: Per Forlin <per.forlin@stericsson.com>
Cc: Rabin Vincent <rabin@rab.in>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/dma/ste_dma40.c |   22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 04cc75f..28fe153 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -2440,16 +2440,6 @@ static int d40_alloc_chan_resources(struct dma_chan *chan)
 
 	d40_set_prio_realtime(d40c);
 
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
 	if (chan_is_logical(d40c))
 		d40_log_gim_unmask(&d40c->src_def_cfg, &d40c->dst_def_cfg);
 
@@ -2793,9 +2783,17 @@ static int d40_set_runtime_config(struct dma_chan *chan,
 		return ret;
 
 	/* Fill in register values */
-	if (chan_is_logical(d40c))
+	if (chan_is_logical(d40c)) {
+		if (d40c->dma_cfg.dir == STEDMA40_PERIPH_TO_MEM)
+			d40c->lcpa = d40c->base->lcpa_base +
+				d40c->dma_cfg.dev_type * D40_LCPA_CHAN_SIZE;
+		else
+			d40c->lcpa = d40c->base->lcpa_base +
+				d40c->dma_cfg.dev_type *
+				D40_LCPA_CHAN_SIZE + D40_LCPA_CHAN_DST_DELTA;
+
 		d40_log_cfg(cfg, &d40c->log_def.lcsp1, &d40c->log_def.lcsp3);
-	else
+	} else
 		d40_phy_cfg(cfg, &d40c->src_def_cfg, &d40c->dst_def_cfg);
 
 	/* These settings will take precedence later */
-- 
1.7.10.4

