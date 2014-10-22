Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754563AbaJVPp2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 11:45:28 -0400
Received: from down.free-electrons.com ([37.187.137.238]:53981 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754476AbaJVPpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:45:22 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: dmaengine@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine@free-electrons.com>,
        lars@metafoo.de, Russell King <linux@arm.linux.org.uk>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v3 17/59] dmaengine: jz4740: Split device_control
Date: Wed, 22 Oct 2014 17:43:31 +0200
Message-Id: <1413992653-21963-18-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413992653-21963-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1413992653-21963-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split the device_control callback of the JZ4740 DMA driver to make use of the
newly introduced callbacks, that will eventually be used to retrieve slave
capabilities.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/dma/dma-jz4740.c | 20 +++-----------------
 1 file changed, 3 insertions(+), 17 deletions(-)

diff --git a/drivers/dma/dma-jz4740.c b/drivers/dma/dma-jz4740.c
index ae2ab14e64b3..c25fc0aa7776 100644
--- a/drivers/dma/dma-jz4740.c
+++ b/drivers/dma/dma-jz4740.c
@@ -210,7 +210,7 @@ static enum jz4740_dma_transfer_size jz4740_dma_maxburst(u32 maxburst)
 }
 
 static int jz4740_dma_slave_config(struct dma_chan *c,
-	const struct dma_slave_config *config)
+				   struct dma_slave_config *config)
 {
 	struct jz4740_dmaengine_chan *chan = to_jz4740_dma_chan(c);
 	struct jz4740_dma_dev *dmadev = jz4740_dma_chan_get_dev(chan);
@@ -290,21 +290,6 @@ static int jz4740_dma_terminate_all(struct dma_chan *c)
 	return 0;
 }
 
-static int jz4740_dma_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
-	unsigned long arg)
-{
-	struct dma_slave_config *config = (struct dma_slave_config *)arg;
-
-	switch (cmd) {
-	case DMA_SLAVE_CONFIG:
-		return jz4740_dma_slave_config(chan, config);
-	case DMA_TERMINATE_ALL:
-		return jz4740_dma_terminate_all(chan);
-	default:
-		return -ENOSYS;
-	}
-}
-
 static int jz4740_dma_start_transfer(struct jz4740_dmaengine_chan *chan)
 {
 	struct jz4740_dma_dev *dmadev = jz4740_dma_chan_get_dev(chan);
@@ -561,7 +546,8 @@ static int jz4740_dma_probe(struct platform_device *pdev)
 	dd->device_issue_pending = jz4740_dma_issue_pending;
 	dd->device_prep_slave_sg = jz4740_dma_prep_slave_sg;
 	dd->device_prep_dma_cyclic = jz4740_dma_prep_dma_cyclic;
-	dd->device_control = jz4740_dma_control;
+	dd->device_config = jz4740_dma_slave_config;
+	dd->device_terminate_all = jz4740_dma_terminate_all;
 	dd->dev = &pdev->dev;
 	dd->chancnt = JZ_DMA_NR_CHANS;
 	INIT_LIST_HEAD(&dd->channels);
-- 
2.1.1

