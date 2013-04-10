Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936811Ab3DJWUv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 18:20:51 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:58064 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935691Ab3DJWTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 18:19:55 -0400
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: linux-sh@vger.kernel.org
Cc: Vinod Koul <vinod.koul@intel.com>, Magnus Damm <magnus.damm@gmail.com>,
        linux-kernel@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
Subject: [PATCH/RFC 5/6] mmc: sh_mmcif: add support for Device Tree DMA bindings
Date: Thu, 11 Apr 2013 00:19:48 +0200
Message-Id: <1365632389-2249-6-git-send-email-g.liakhovetski@gmx.de>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1365632389-2249-1-git-send-email-g.liakhovetski@gmx.de>
References: <1365632389-2249-1-git-send-email-g.liakhovetski@gmx.de>
X-Provags-ID: V02:K0:0pCtcr/Tyc15gsFX94cuwpSggrxc3EATpBDsKb+M4r3
 4E9g3DkS4kd3e2YtK8EpZ12vFWmmsasB5MlTW11ghYuVsXeKeP
 YJHjBA9XjNEYgrJoKTREbToc79LMmMOP/qJ4L7BuylTuJRq9dM
 JZCVjkwtZjWCLAOnYDhi1X92s8WJU37EwqXlKej6Ho5HSHBkOm
 gNUtnhkvPQ8moGeDwwXixTGFicaYFL6xg+BOVUyPQg1u4d+tJS
 UdlS3uJdAFlL6fTy3XUcadBqwjjYcvBXYbEOhdKI4xACuyDUHh
 lBO1UenlvL+Y4J5fo5v2h7vhtTkAg0i/fRZsCx8Xw9ZRaiJ7gL
 XTjnIrQF4/96AppFXPqEn/102n/TZRUAEHucVmKE+YG6ewnTXL
 lVUDKU9FNk2lw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To use DMA in the Device Tree case the driver has to be modified
to use suitable API to obtain DMA channels.

Signed-off-by: Guennadi Liakhovetski <g.liakhovetski+renesas@gmail.com>
---
 drivers/mmc/host/sh_mmcif.c |   29 ++++++++++++++++++-----------
 1 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/mmc/host/sh_mmcif.c b/drivers/mmc/host/sh_mmcif.c
index ba76a53..446d948 100644
--- a/drivers/mmc/host/sh_mmcif.c
+++ b/drivers/mmc/host/sh_mmcif.c
@@ -386,25 +386,30 @@ static void sh_mmcif_request_dma(struct sh_mmcif_host *host,
 
 	host->dma_active = false;
 
-	if (!pdata)
-		return;
-
-	if (pdata->slave_id_tx <= 0 || pdata->slave_id_rx <= 0)
-		return;
+	if (pdata) {
+		if (pdata->slave_id_tx <= 0 || pdata->slave_id_rx <= 0)
+			return;
+	} else {
+		if (!host->pd->dev.of_node)
+			return;
+	}
 
 	/* We can only either use DMA for both Tx and Rx or not use it at all */
 	dma_cap_zero(mask);
 	dma_cap_set(DMA_SLAVE, mask);
 
-	host->chan_tx = dma_request_channel(mask, shdma_chan_filter,
-					    (void *)pdata->slave_id_tx);
+	host->chan_tx = dma_request_slave_channel_compat(mask, shdma_chan_filter,
+				pdata ? (void *)pdata->slave_id_tx : NULL,
+				&host->pd->dev, "tx");
 	dev_dbg(&host->pd->dev, "%s: TX: got channel %p\n", __func__,
 		host->chan_tx);
 
 	if (!host->chan_tx)
 		return;
 
-	cfg.slave_id = pdata->slave_id_tx;
+	/* In the OF case the driver will get the slave ID from the DT */
+	if (pdata)
+		cfg.slave_id = pdata->slave_id_tx;
 	cfg.direction = DMA_MEM_TO_DEV;
 	cfg.dst_addr = res->start + MMCIF_CE_DATA;
 	cfg.src_addr = 0;
@@ -412,15 +417,17 @@ static void sh_mmcif_request_dma(struct sh_mmcif_host *host,
 	if (ret < 0)
 		goto ecfgtx;
 
-	host->chan_rx = dma_request_channel(mask, shdma_chan_filter,
-					    (void *)pdata->slave_id_rx);
+	host->chan_rx = dma_request_slave_channel_compat(mask, shdma_chan_filter,
+				pdata ? (void *)pdata->slave_id_rx : NULL,
+				&host->pd->dev, "rx");
 	dev_dbg(&host->pd->dev, "%s: RX: got channel %p\n", __func__,
 		host->chan_rx);
 
 	if (!host->chan_rx)
 		goto erqrx;
 
-	cfg.slave_id = pdata->slave_id_rx;
+	if (pdata)
+		cfg.slave_id = pdata->slave_id_rx;
 	cfg.direction = DMA_DEV_TO_MEM;
 	cfg.dst_addr = 0;
 	cfg.src_addr = res->start + MMCIF_CE_DATA;
-- 
1.7.2.5

