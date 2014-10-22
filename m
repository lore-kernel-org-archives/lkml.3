Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932694AbaJVQGz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 12:06:55 -0400
Received: from down.free-electrons.com ([37.187.137.238]:54002 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754493AbaJVPp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:45:26 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: dmaengine@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine@free-electrons.com>,
        lars@metafoo.de, Russell King <linux@arm.linux.org.uk>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v3 19/59] dmaengine: edma: Split device_control
Date: Wed, 22 Oct 2014 17:43:33 +0200
Message-Id: <1413992653-21963-20-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413992653-21963-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1413992653-21963-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split the device_control callback of the TI EDMA driver to make use of the
newly introduced callbacks, that will eventually be used to retrieve slave
capabilities.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/dma/edma.c | 50 +++++++++++++++-----------------------------------
 1 file changed, 15 insertions(+), 35 deletions(-)

diff --git a/drivers/dma/edma.c b/drivers/dma/edma.c
index 790054eef76c..56735a0aa3a8 100644
--- a/drivers/dma/edma.c
+++ b/drivers/dma/edma.c
@@ -244,8 +244,9 @@ static void edma_execute(struct edma_chan *echan)
 	}
 }
 
-static int edma_terminate_all(struct edma_chan *echan)
+static int edma_terminate_all(struct dma_chan *chan)
 {
+	struct edma_chan *echan = to_edma_chan(chan);
 	unsigned long flags;
 	LIST_HEAD(head);
 
@@ -273,9 +274,11 @@ static int edma_terminate_all(struct edma_chan *echan)
 	return 0;
 }
 
-static int edma_slave_config(struct edma_chan *echan,
+static int edma_slave_config(struct dma_chan *chan,
 	struct dma_slave_config *cfg)
 {
+	struct edma_chan *echan = to_edma_chan(chan);
+
 	if (cfg->src_addr_width == DMA_SLAVE_BUSWIDTH_8_BYTES ||
 	    cfg->dst_addr_width == DMA_SLAVE_BUSWIDTH_8_BYTES)
 		return -EINVAL;
@@ -285,8 +288,10 @@ static int edma_slave_config(struct edma_chan *echan,
 	return 0;
 }
 
-static int edma_dma_pause(struct edma_chan *echan)
+static int edma_dma_pause(struct dma_chan *chan)
 {
+	struct edma_chan *echan = to_edma_chan(chan);
+
 	/* Pause/Resume only allowed with cyclic mode */
 	if (!echan->edesc || !echan->edesc->cyclic)
 		return -EINVAL;
@@ -295,8 +300,10 @@ static int edma_dma_pause(struct edma_chan *echan)
 	return 0;
 }
 
-static int edma_dma_resume(struct edma_chan *echan)
+static int edma_dma_resume(struct dma_chan *chan)
 {
+	struct edma_chan *echan = to_edma_chan(chan);
+
 	/* Pause/Resume only allowed with cyclic mode */
 	if (!echan->edesc->cyclic)
 		return -EINVAL;
@@ -305,36 +312,6 @@ static int edma_dma_resume(struct edma_chan *echan)
 	return 0;
 }
 
-static int edma_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
-			unsigned long arg)
-{
-	int ret = 0;
-	struct dma_slave_config *config;
-	struct edma_chan *echan = to_edma_chan(chan);
-
-	switch (cmd) {
-	case DMA_TERMINATE_ALL:
-		edma_terminate_all(echan);
-		break;
-	case DMA_SLAVE_CONFIG:
-		config = (struct dma_slave_config *)arg;
-		ret = edma_slave_config(echan, config);
-		break;
-	case DMA_PAUSE:
-		ret = edma_dma_pause(echan);
-		break;
-
-	case DMA_RESUME:
-		ret = edma_dma_resume(echan);
-		break;
-
-	default:
-		ret = -ENOSYS;
-	}
-
-	return ret;
-}
-
 /*
  * A PaRAM set configuration abstraction used by other modes
  * @chan: Channel who's PaRAM set we're configuring
@@ -1017,7 +994,10 @@ static void edma_dma_init(struct edma_cc *ecc, struct dma_device *dma,
 	dma->device_free_chan_resources = edma_free_chan_resources;
 	dma->device_issue_pending = edma_issue_pending;
 	dma->device_tx_status = edma_tx_status;
-	dma->device_control = edma_control;
+	dma->device_config = edma_slave_config;
+	dma->device_pause = edma_dma_pause;
+	dma->device_resume = edma_dma_resume;
+	dma->device_terminate_all = edma_terminate_all;
 	dma->device_slave_caps = edma_dma_device_slave_caps;
 	dma->dev = dev;
 
-- 
2.1.1

