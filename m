Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594AbaKQNyc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 08:54:32 -0500
Received: from down.free-electrons.com ([37.187.137.238]:49102 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753366AbaKQNph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 08:45:37 -0500
From: Maxime Ripard <maxime.ripard@free-electrons.com>
To: Vinod Koul <vinod.koul@intel.com>, dmaengine@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= <antoine@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>, lars@metafoo.de,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: [PATCH v5 43/61] dmaengine: tegra20: Split device_control
Date: Mon, 17 Nov 2014 14:42:37 +0100
Message-Id: <1416231775-31252-44-git-send-email-maxime.ripard@free-electrons.com>
X-Mailer: git-send-email 2.1.1
In-Reply-To: <1416231775-31252-1-git-send-email-maxime.ripard@free-electrons.com>
References: <1416231775-31252-1-git-send-email-maxime.ripard@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split the device_control callback of the NVidia Tegra20 APB DMA driver to make
use of the newly introduced callbacks, that will eventually be used to retrieve
slave capabilities.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
---
 drivers/dma/tegra20-apb-dma.c | 22 ++--------------------
 1 file changed, 2 insertions(+), 20 deletions(-)

diff --git a/drivers/dma/tegra20-apb-dma.c b/drivers/dma/tegra20-apb-dma.c
index a6c0b3f68393..053b44f3aef9 100644
--- a/drivers/dma/tegra20-apb-dma.c
+++ b/drivers/dma/tegra20-apb-dma.c
@@ -827,25 +827,6 @@ static enum dma_status tegra_dma_tx_status(struct dma_chan *dc,
 	return ret;
 }
 
-static int tegra_dma_device_control(struct dma_chan *dc, enum dma_ctrl_cmd cmd,
-			unsigned long arg)
-{
-	switch (cmd) {
-	case DMA_SLAVE_CONFIG:
-		return tegra_dma_slave_config(dc,
-				(struct dma_slave_config *)arg);
-
-	case DMA_TERMINATE_ALL:
-		tegra_dma_terminate_all(dc);
-		return 0;
-
-	default:
-		break;
-	}
-
-	return -ENXIO;
-}
-
 static inline int get_bus_width(struct tegra_dma_channel *tdc,
 		enum dma_slave_buswidth slave_bw)
 {
@@ -1443,7 +1424,8 @@ static int tegra_dma_probe(struct platform_device *pdev)
 					tegra_dma_free_chan_resources;
 	tdma->dma_dev.device_prep_slave_sg = tegra_dma_prep_slave_sg;
 	tdma->dma_dev.device_prep_dma_cyclic = tegra_dma_prep_dma_cyclic;
-	tdma->dma_dev.device_control = tegra_dma_device_control;
+	tdma->dma_dev.device_config = tegra_dma_slave_config;
+	tdma->dma_dev.device_terminate_all = tegra_dma_terminate_all;
 	tdma->dma_dev.device_tx_status = tegra_dma_tx_status;
 	tdma->dma_dev.device_issue_pending = tegra_dma_issue_pending;
 
-- 
2.1.1

