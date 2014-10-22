Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754745AbaJVPpl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 11:45:41 -0400
Received: from down.free-electrons.com ([37.187.137.238]:54074 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754596AbaJVPpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:45:34 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: dmaengine@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine@free-electrons.com>,
        lars@metafoo.de, Russell King <linux@arm.linux.org.uk>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH v3 16/59] dmaengine: cppi41: Split device_control
Date: Wed, 22 Oct 2014 17:43:30 +0200
Message-Id: <1413992653-21963-17-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413992653-21963-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1413992653-21963-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split the device_control callback of the TI CPPI41 DMA driver to make use
of the newly introduced callbacks, that will eventually be used to retrieve
slave capabilities.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/dma/cppi41.c | 30 +-----------------------------
 1 file changed, 1 insertion(+), 29 deletions(-)

diff --git a/drivers/dma/cppi41.c b/drivers/dma/cppi41.c
index a58eec3b2cad..0f41b5b497db 100644
--- a/drivers/dma/cppi41.c
+++ b/drivers/dma/cppi41.c
@@ -524,12 +524,6 @@ static struct dma_async_tx_descriptor *cppi41_dma_prep_slave_sg(
 	return &c->txd;
 }
 
-static int cpp41_cfg_chan(struct cppi41_channel *c,
-		struct dma_slave_config *cfg)
-{
-	return 0;
-}
-
 static void cppi41_compute_td_desc(struct cppi41_desc *d)
 {
 	d->pd0 = DESC_TYPE_TEARD << DESC_TYPE;
@@ -642,28 +636,6 @@ static int cppi41_stop_chan(struct dma_chan *chan)
 	return 0;
 }
 
-static int cppi41_dma_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
-	unsigned long arg)
-{
-	struct cppi41_channel *c = to_cpp41_chan(chan);
-	int ret;
-
-	switch (cmd) {
-	case DMA_SLAVE_CONFIG:
-		ret = cpp41_cfg_chan(c, (struct dma_slave_config *) arg);
-		break;
-
-	case DMA_TERMINATE_ALL:
-		ret = cppi41_stop_chan(chan);
-		break;
-
-	default:
-		ret = -ENXIO;
-		break;
-	}
-	return ret;
-}
-
 static void cleanup_chans(struct cppi41_dd *cdd)
 {
 	while (!list_empty(&cdd->ddev.channels)) {
@@ -948,7 +920,7 @@ static int cppi41_dma_probe(struct platform_device *pdev)
 	cdd->ddev.device_tx_status = cppi41_dma_tx_status;
 	cdd->ddev.device_issue_pending = cppi41_dma_issue_pending;
 	cdd->ddev.device_prep_slave_sg = cppi41_dma_prep_slave_sg;
-	cdd->ddev.device_control = cppi41_dma_control;
+	cdd->ddev.device_terminate_all = cppi41_stop_chan;
 	cdd->ddev.dev = dev;
 	INIT_LIST_HEAD(&cdd->ddev.channels);
 	cpp41_dma_info.dma_cap = cdd->ddev.cap_mask;
-- 
2.1.1

