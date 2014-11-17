Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754061AbaKQN6l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 08:58:41 -0500
Received: from down.free-electrons.com ([37.187.137.238]:48964 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753053AbaKQNpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 08:45:23 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Vinod Koul <vinod.koul@intel.com>, dmaengine@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>, lars@metafoo.de,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v5 29/61] dmaengine: moxart: Split device_control
Date: Mon, 17 Nov 2014 14:42:23 +0100
Message-Id: <1416231775-31252-30-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1416231775-31252-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1416231775-31252-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split the device_control callback of the Moxart DMA driver to make use of the
newly introduced callbacks, that will eventually be used to retrieve slave
capabilities.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/dma/moxart-dma.c | 25 ++-----------------------
 1 file changed, 2 insertions(+), 23 deletions(-)

diff --git a/drivers/dma/moxart-dma.c b/drivers/dma/moxart-dma.c
index 3258e484e4f6..35e1a3ab5fb8 100644
--- a/drivers/dma/moxart-dma.c
+++ b/drivers/dma/moxart-dma.c
@@ -263,28 +263,6 @@ static int moxart_slave_config(struct dma_chan *chan,
 	return 0;
 }
 
-static int moxart_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
-			  unsigned long arg)
-{
-	int ret = 0;
-
-	switch (cmd) {
-	case DMA_PAUSE:
-	case DMA_RESUME:
-		return -EINVAL;
-	case DMA_TERMINATE_ALL:
-		moxart_terminate_all(chan);
-		break;
-	case DMA_SLAVE_CONFIG:
-		ret = moxart_slave_config(chan, (struct dma_slave_config *)arg);
-		break;
-	default:
-		ret = -ENOSYS;
-	}
-
-	return ret;
-}
-
 static struct dma_async_tx_descriptor *moxart_prep_slave_sg(
 	struct dma_chan *chan, struct scatterlist *sgl,
 	unsigned int sg_len, enum dma_transfer_direction dir,
@@ -531,7 +509,8 @@ static void moxart_dma_init(struct dma_device *dma, struct device *dev)
 	dma->device_free_chan_resources		= moxart_free_chan_resources;
 	dma->device_issue_pending		= moxart_issue_pending;
 	dma->device_tx_status			= moxart_tx_status;
-	dma->device_control			= moxart_control;
+	dma->device_config			= moxart_slave_config;
+	dma->device_terminate_all		= moxart_terminate_all;
 	dma->dev				= dev;
 
 	INIT_LIST_HEAD(&dma->channels);
-- 
2.1.1

