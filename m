Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647AbaJVQBq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 12:01:46 -0400
Received: from down.free-electrons.com ([37.187.137.238]:54095 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754750AbaJVPpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:45:44 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: dmaengine@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine@free-electrons.com>,
        lars@metafoo.de, Russell King <linux@arm.linux.org.uk>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v3 33/59] dmaengine: nbpfaxi: Split device_control
Date: Wed, 22 Oct 2014 17:43:47 +0200
Message-Id: <1413992653-21963-34-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413992653-21963-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1413992653-21963-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split the device_control callback of the NBPF AXI DMA driver to make use
of the newly introduced callbacks, that will eventually be used to retrieve
slave capabilities.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/dma/nbpfaxi.c | 93 +++++++++++++++++++++++++--------------------------
 1 file changed, 46 insertions(+), 47 deletions(-)

diff --git a/drivers/dma/nbpfaxi.c b/drivers/dma/nbpfaxi.c
index b4a61ccbb443..a07698fc798f 100644
--- a/drivers/dma/nbpfaxi.c
+++ b/drivers/dma/nbpfaxi.c
@@ -565,13 +565,6 @@ static void nbpf_configure(struct nbpf_device *nbpf)
 	nbpf_write(nbpf, NBPF_CTRL, NBPF_CTRL_LVINT);
 }
 
-static void nbpf_pause(struct nbpf_channel *chan)
-{
-	nbpf_chan_write(chan, NBPF_CHAN_CTRL, NBPF_CHAN_CTRL_SETSUS);
-	/* See comment in nbpf_prep_one() */
-	nbpf_chan_write(chan, NBPF_CHAN_CTRL, NBPF_CHAN_CTRL_CLREN);
-}
-
 /*		Generic part			*/
 
 /* DMA ENGINE functions */
@@ -837,54 +830,58 @@ static void nbpf_chan_idle(struct nbpf_channel *chan)
 	}
 }
 
-static int nbpf_control(struct dma_chan *dchan, enum dma_ctrl_cmd cmd,
-			unsigned long arg)
+static int nbpf_pause(struct dma_chan *dchan)
 {
 	struct nbpf_channel *chan = nbpf_to_chan(dchan);
-	struct dma_slave_config *config;
 
-	dev_dbg(dchan->device->dev, "Entry %s(%d)\n", __func__, cmd);
+	dev_dbg(dchan->device->dev, "Entry %s\n", __func__);
 
-	switch (cmd) {
-	case DMA_TERMINATE_ALL:
-		dev_dbg(dchan->device->dev, "Terminating\n");
-		nbpf_chan_halt(chan);
-		nbpf_chan_idle(chan);
-		break;
+	chan->paused = true;
+	nbpf_chan_write(chan, NBPF_CHAN_CTRL, NBPF_CHAN_CTRL_SETSUS);
+	/* See comment in nbpf_prep_one() */
+	nbpf_chan_write(chan, NBPF_CHAN_CTRL, NBPF_CHAN_CTRL_CLREN);
 
-	case DMA_SLAVE_CONFIG:
-		if (!arg)
-			return -EINVAL;
-		config = (struct dma_slave_config *)arg;
+	return 0;
+}
 
-		/*
-		 * We could check config->slave_id to match chan->terminal here,
-		 * but with DT they would be coming from the same source, so
-		 * such a check would be superflous
-		 */
+static int nbpf_terminate_all(struct dma_chan *dchan)
+{
+	struct nbpf_channel *chan = nbpf_to_chan(dchan);
 
-		chan->slave_dst_addr = config->dst_addr;
-		chan->slave_dst_width = nbpf_xfer_size(chan->nbpf,
-						       config->dst_addr_width, 1);
-		chan->slave_dst_burst = nbpf_xfer_size(chan->nbpf,
-						       config->dst_addr_width,
-						       config->dst_maxburst);
-		chan->slave_src_addr = config->src_addr;
-		chan->slave_src_width = nbpf_xfer_size(chan->nbpf,
-						       config->src_addr_width, 1);
-		chan->slave_src_burst = nbpf_xfer_size(chan->nbpf,
-						       config->src_addr_width,
-						       config->src_maxburst);
-		break;
+	dev_dbg(dchan->device->dev, "Entry %s\n", __func__);
+	dev_dbg(dchan->device->dev, "Terminating\n");
 
-	case DMA_PAUSE:
-		chan->paused = true;
-		nbpf_pause(chan);
-		break;
+	nbpf_chan_halt(chan);
+	nbpf_chan_idle(chan);
 
-	default:
-		return -ENXIO;
-	}
+	return 0;
+}
+
+static int nbpf_config(struct dma_chan *dchan,
+		       struct dma_slave_config *config)
+{
+	struct nbpf_channel *chan = nbpf_to_chan(dchan);
+
+	dev_dbg(dchan->device->dev, "Entry %s\n", __func__);
+
+	/*
+	 * We could check config->slave_id to match chan->terminal here,
+	 * but with DT they would be coming from the same source, so
+	 * such a check would be superflous
+	 */
+
+	chan->slave_dst_addr = config->dst_addr;
+	chan->slave_dst_width = nbpf_xfer_size(chan->nbpf,
+					       config->dst_addr_width, 1);
+	chan->slave_dst_burst = nbpf_xfer_size(chan->nbpf,
+					       config->dst_addr_width,
+					       config->dst_maxburst);
+	chan->slave_src_addr = config->src_addr;
+	chan->slave_src_width = nbpf_xfer_size(chan->nbpf,
+					       config->src_addr_width, 1);
+	chan->slave_src_burst = nbpf_xfer_size(chan->nbpf,
+					       config->src_addr_width,
+					       config->src_maxburst);
 
 	return 0;
 }
@@ -1426,7 +1423,9 @@ static int nbpf_probe(struct platform_device *pdev)
 
 	/* Compulsory for DMA_SLAVE fields */
 	dma_dev->device_prep_slave_sg = nbpf_prep_slave_sg;
-	dma_dev->device_control = nbpf_control;
+	dma_dev->device_config = nbpf_config;
+	dma_dev->device_pause = nbpf_pause;
+	dma_dev->device_terminate_all = nbpf_terminate_all;
 
 	platform_set_drvdata(pdev, nbpf);
 
-- 
2.1.1

