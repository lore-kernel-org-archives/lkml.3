Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833AbaKQNuh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 08:50:37 -0500
Received: from down.free-electrons.com ([37.187.137.238]:49106 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753457AbaKQNpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 08:45:51 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Vinod Koul <vinod.koul@intel.com>, dmaengine@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>, lars@metafoo.de,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v5 13/61] dmaengine: at_xdmac: split device_control
Date: Mon, 17 Nov 2014 14:42:07 +0100
Message-Id: <1416231775-31252-14-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1416231775-31252-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1416231775-31252-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ludovic Desroches <ludovic.desroches@atmel.com>

Use newly introduced callbacks.

Signed-off-by: Ludovic Desroches <ludovic.desroches@atmel.com>
Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/dma/at_xdmac.c | 94 ++++++++++++++++++++++++++++++--------------------
 1 file changed, 57 insertions(+), 37 deletions(-)

diff --git a/drivers/dma/at_xdmac.c b/drivers/dma/at_xdmac.c
index bdc193cb82b7..9906e7cfbe37 100644
--- a/drivers/dma/at_xdmac.c
+++ b/drivers/dma/at_xdmac.c
@@ -1097,58 +1097,75 @@ static void at_xdmac_issue_pending(struct dma_chan *chan)
 	return;
 }
 
-static int at_xdmac_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
-			    unsigned long arg)
+static int at_xdmac_device_config(struct dma_chan *chan,
+				  struct dma_slave_config *config)
+{
+	struct at_xdmac_chan	*atchan = to_at_xdmac_chan(chan);
+	int ret;
+
+	dev_dbg(chan2dev(chan), "%s\n", __func__);
+
+	spin_lock_bh(&atchan->lock);
+	ret = at_xdmac_set_slave_config(chan, config);
+	spin_unlock_bh(&atchan->lock);
+
+	return ret;
+}
+
+static int at_xdmac_device_pause(struct dma_chan *chan)
 {
-	struct at_xdmac_desc	*desc, *_desc;
 	struct at_xdmac_chan	*atchan = to_at_xdmac_chan(chan);
 	struct at_xdmac		*atxdmac = to_at_xdmac(atchan->chan.device);
-	int			ret = 0;
 
-	dev_dbg(chan2dev(chan), "%s: cmd=%d\n", __func__, cmd);
+	dev_dbg(chan2dev(chan), "%s\n", __func__);
 
 	spin_lock_bh(&atchan->lock);
+	at_xdmac_write(atxdmac, AT_XDMAC_GRWS, atchan->mask);
+	set_bit(AT_XDMAC_CHAN_IS_PAUSED, &atchan->status);
+	spin_unlock_bh(&atchan->lock);
 
-	switch (cmd) {
-	case DMA_PAUSE:
-		at_xdmac_write(atxdmac, AT_XDMAC_GRWS, atchan->mask);
-		set_bit(AT_XDMAC_CHAN_IS_PAUSED, &atchan->status);
-		break;
+	return 0;
+}
 
-	case DMA_RESUME:
-		if (!at_xdmac_chan_is_paused(atchan))
-			break;
+static int at_xdmac_device_resume(struct dma_chan *chan)
+{
+	struct at_xdmac_chan	*atchan = to_at_xdmac_chan(chan);
+	struct at_xdmac		*atxdmac = to_at_xdmac(atchan->chan.device);
 
-		at_xdmac_write(atxdmac, AT_XDMAC_GRWR, atchan->mask);
-		clear_bit(AT_XDMAC_CHAN_IS_PAUSED, &atchan->status);
-		break;
+	dev_dbg(chan2dev(chan), "%s\n", __func__);
 
-	case DMA_TERMINATE_ALL:
-		at_xdmac_write(atxdmac, AT_XDMAC_GD, atchan->mask);
-		while (at_xdmac_read(atxdmac, AT_XDMAC_GS) & atchan->mask)
-			cpu_relax();
+	spin_lock_bh(&atchan->lock);
+	if (!at_xdmac_chan_is_paused(atchan))
+		return 0;
 
-		/* Cancel all pending transfers. */
-		list_for_each_entry_safe(desc, _desc, &atchan->xfers_list, xfer_node)
-			at_xdmac_remove_xfer(atchan, desc);
+	at_xdmac_write(atxdmac, AT_XDMAC_GRWR, atchan->mask);
+	clear_bit(AT_XDMAC_CHAN_IS_PAUSED, &atchan->status);
+	spin_unlock_bh(&atchan->lock);
+
+	return 0;
+}
+
+static int at_xdmac_device_terminate_all(struct dma_chan *chan)
+{
+	struct at_xdmac_desc	*desc, *_desc;
+	struct at_xdmac_chan	*atchan = to_at_xdmac_chan(chan);
+	struct at_xdmac		*atxdmac = to_at_xdmac(atchan->chan.device);
 
-		clear_bit(AT_XDMAC_CHAN_IS_CYCLIC, &atchan->status);
-		break;
+	dev_dbg(chan2dev(chan), "%s\n", __func__);
 
-	case DMA_SLAVE_CONFIG:
-		ret = at_xdmac_set_slave_config(chan,
-				(struct dma_slave_config *)arg);
-		break;
+	spin_lock_bh(&atchan->lock);
+	at_xdmac_write(atxdmac, AT_XDMAC_GD, atchan->mask);
+	while (at_xdmac_read(atxdmac, AT_XDMAC_GS) & atchan->mask)
+		cpu_relax();
 
-	default:
-		dev_err(chan2dev(chan),
-			"unmanaged or unknown dma control cmd: %d\n", cmd);
-		ret = -ENXIO;
-	}
+	/* Cancel all pending transfers. */
+	list_for_each_entry_safe(desc, _desc, &atchan->xfers_list, xfer_node)
+		at_xdmac_remove_xfer(atchan, desc);
 
+	clear_bit(AT_XDMAC_CHAN_IS_CYCLIC, &atchan->status);
 	spin_unlock_bh(&atchan->lock);
 
-	return ret;
+	return 0;
 }
 
 static int at_xdmac_alloc_chan_resources(struct dma_chan *chan)
@@ -1260,7 +1277,7 @@ static int atmel_xdmac_suspend(struct device *dev)
 
 		if (at_xdmac_chan_is_cyclic(atchan)) {
 			if (!at_xdmac_chan_is_paused(atchan))
-				at_xdmac_control(chan, DMA_PAUSE, 0);
+				at_xdmac_device_pause(chan);
 			atchan->save_cim = at_xdmac_chan_read(atchan, AT_XDMAC_CIM);
 			atchan->save_cnda = at_xdmac_chan_read(atchan, AT_XDMAC_CNDA);
 			atchan->save_cndc = at_xdmac_chan_read(atchan, AT_XDMAC_CNDC);
@@ -1392,7 +1409,10 @@ static int at_xdmac_probe(struct platform_device *pdev)
 	atxdmac->dma.device_prep_dma_cyclic		= at_xdmac_prep_dma_cyclic;
 	atxdmac->dma.device_prep_dma_memcpy		= at_xdmac_prep_dma_memcpy;
 	atxdmac->dma.device_prep_slave_sg		= at_xdmac_prep_slave_sg;
-	atxdmac->dma.device_control			= at_xdmac_control;
+	atxdmac->dma.device_config			= at_xdmac_device_config;
+	atxdmac->dma.device_pause			= at_xdmac_device_pause;
+	atxdmac->dma.device_resume			= at_xdmac_device_resume;
+	atxdmac->dma.device_terminate_all		= at_xdmac_device_terminate_all;
 	atxdmac->dma.chancnt				= nr_channels;
 	atxdmac->dma.device_slave_caps			= at_xdmac_device_slave_caps;
 
-- 
2.1.1

