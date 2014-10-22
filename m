Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285AbaJVQAg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 12:00:36 -0400
Received: from down.free-electrons.com ([37.187.137.238]:54159 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754829AbaJVPpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:45:51 -0400
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: dmaengine@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine@free-electrons.com>,
        lars@metafoo.de, Russell King <linux@arm.linux.org.uk>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Barry Song <baohua@kernel.org>
Subject: [PATCH v3 40/59] dmaengine: sirf: Split device_control
Date: Wed, 22 Oct 2014 17:43:54 +0200
Message-Id: <1413992653-21963-41-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1413992653-21963-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1413992653-21963-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split the device_control callback of the SiRF Prima 2 DMA driver to make use
of the newly introduced callbacks, that will eventually be used to retrieve
slave capabilities.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/dma/sirf-dma.c | 43 +++++++++++++------------------------------
 1 file changed, 13 insertions(+), 30 deletions(-)

diff --git a/drivers/dma/sirf-dma.c b/drivers/dma/sirf-dma.c
index 149d7fddfa75..711c2bae9003 100644
--- a/drivers/dma/sirf-dma.c
+++ b/drivers/dma/sirf-dma.c
@@ -281,9 +281,10 @@ static dma_cookie_t sirfsoc_dma_tx_submit(struct dma_async_tx_descriptor *txd)
 	return cookie;
 }
 
-static int sirfsoc_dma_slave_config(struct sirfsoc_dma_chan *schan,
-	struct dma_slave_config *config)
+static int sirfsoc_dma_slave_config(struct dma_chan *chan,
+				    struct dma_slave_config *config)
 {
+	struct sirfsoc_dma_chan *schan = dma_chan_to_sirfsoc_dma_chan(chan);
 	unsigned long flags;
 
 	if ((config->src_addr_width != DMA_SLAVE_BUSWIDTH_4_BYTES) ||
@@ -297,8 +298,9 @@ static int sirfsoc_dma_slave_config(struct sirfsoc_dma_chan *schan,
 	return 0;
 }
 
-static int sirfsoc_dma_terminate_all(struct sirfsoc_dma_chan *schan)
+static int sirfsoc_dma_terminate_all(struct dma_chan *chan)
 {
+	struct sirfsoc_dma_chan *schan = dma_chan_to_sirfsoc_dma_chan(chan);
 	struct sirfsoc_dma *sdma = dma_chan_to_sirfsoc_dma(&schan->chan);
 	int cid = schan->chan.chan_id;
 	unsigned long flags;
@@ -327,8 +329,9 @@ static int sirfsoc_dma_terminate_all(struct sirfsoc_dma_chan *schan)
 	return 0;
 }
 
-static int sirfsoc_dma_pause_chan(struct sirfsoc_dma_chan *schan)
+static int sirfsoc_dma_pause_chan(struct dma_chan *chan)
 {
+	struct sirfsoc_dma_chan *schan = dma_chan_to_sirfsoc_dma_chan(chan);
 	struct sirfsoc_dma *sdma = dma_chan_to_sirfsoc_dma(&schan->chan);
 	int cid = schan->chan.chan_id;
 	unsigned long flags;
@@ -348,8 +351,9 @@ static int sirfsoc_dma_pause_chan(struct sirfsoc_dma_chan *schan)
 	return 0;
 }
 
-static int sirfsoc_dma_resume_chan(struct sirfsoc_dma_chan *schan)
+static int sirfsoc_dma_resume_chan(struct dma_chan *chan)
 {
+	struct sirfsoc_dma_chan *schan = dma_chan_to_sirfsoc_dma_chan(chan);
 	struct sirfsoc_dma *sdma = dma_chan_to_sirfsoc_dma(&schan->chan);
 	int cid = schan->chan.chan_id;
 	unsigned long flags;
@@ -369,30 +373,6 @@ static int sirfsoc_dma_resume_chan(struct sirfsoc_dma_chan *schan)
 	return 0;
 }
 
-static int sirfsoc_dma_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
-	unsigned long arg)
-{
-	struct dma_slave_config *config;
-	struct sirfsoc_dma_chan *schan = dma_chan_to_sirfsoc_dma_chan(chan);
-
-	switch (cmd) {
-	case DMA_PAUSE:
-		return sirfsoc_dma_pause_chan(schan);
-	case DMA_RESUME:
-		return sirfsoc_dma_resume_chan(schan);
-	case DMA_TERMINATE_ALL:
-		return sirfsoc_dma_terminate_all(schan);
-	case DMA_SLAVE_CONFIG:
-		config = (struct dma_slave_config *)arg;
-		return sirfsoc_dma_slave_config(schan, config);
-
-	default:
-		break;
-	}
-
-	return -ENOSYS;
-}
-
 /* Alloc channel resources */
 static int sirfsoc_dma_alloc_chan_resources(struct dma_chan *chan)
 {
@@ -740,7 +720,10 @@ static int sirfsoc_dma_probe(struct platform_device *op)
 	dma->device_alloc_chan_resources = sirfsoc_dma_alloc_chan_resources;
 	dma->device_free_chan_resources = sirfsoc_dma_free_chan_resources;
 	dma->device_issue_pending = sirfsoc_dma_issue_pending;
-	dma->device_control = sirfsoc_dma_control;
+	dma->device_config = sirfsoc_dma_slave_config;
+	dma->device_pause = sirfsoc_dma_pause_chan;
+	dma->device_resume = sirfsoc_dma_resume_chan;
+	dma->device_terminate_all = sirfsoc_dma_terminate_all;
 	dma->device_tx_status = sirfsoc_dma_tx_status;
 	dma->device_prep_interleaved_dma = sirfsoc_dma_prep_interleaved;
 	dma->device_prep_dma_cyclic = sirfsoc_dma_prep_cyclic;
-- 
2.1.1

