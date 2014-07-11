Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162AbaGKCIW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 22:08:22 -0400
Received: from regular1.263xmail.com ([211.150.99.139]:47249 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771AbaGKCIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 22:08:20 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: addy.ke@rock-chips.com
X-FST-TO: broonie@kernel.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: addy.ke@rock-chips.com
X-UNIQUE-TAG: <d2d609849c846fcae2dcc5d7d3d5ff67>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
From: Addy Ke <addy.ke@rock-chips.com>
To: broonie@kernel.org, heiko@sntech.de, grant.likely@linaro.org,
        robh+dt@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        jogo@openwrt.org, olof@lixom.net, hj@rock-chips.com,
        kever.yang@rock-chips.com, xjq@rock-chips.com, huangtao@rock-chips.com,
        zyw@rock-chips.com, yzq@rock-chips.com, zhenfu.fang@rock-chips.com,
        cf@rock-chips.com, zhangqing@rock-chips.com, hl@rock-chips.com,
        wei.luo@rock-chips.com, Addy Ke <addy.ke@rockchip.com>
Subject: [PATCH 1/4] spi/rockchip: cleanup some coding issues and uncessary output
Date: Fri, 11 Jul 2014 10:07:56 +0800
Message-Id: <1405044476-6871-1-git-send-email-addy.ke@rock-chips.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1405044389-6800-1-git-send-email-addy.ke@rock-chips.com>
References: <1405044389-6800-1-git-send-email-addy.ke@rock-chips.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Addy Ke <addy.ke@rockchip.com>

Suggested-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Addy Ke <addy.ke@rockchip.com>
---
 drivers/spi/spi-rockchip.c | 41 +++++++++++++++++++++++------------------
 1 file changed, 23 insertions(+), 18 deletions(-)

diff --git a/drivers/spi/spi-rockchip.c b/drivers/spi/spi-rockchip.c
index 72fb287..8c24708 100644
--- a/drivers/spi/spi-rockchip.c
+++ b/drivers/spi/spi-rockchip.c
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2014, Fuzhou Rockchip Electronics Co., Ltd
- * Author: addy ke <addy.ke@rock-chips.com>
+ * Author: Addy Ke <addy.ke@rock-chips.com>
  *
  * This program is free software; you can redistribute it and/or modify it
  * under the terms and conditions of the GNU General Public License,
@@ -186,7 +186,7 @@ struct rockchip_spi {
 	void *rx_end;
 
 	u32 state;
-
+	/* protect state */
 	spinlock_t lock;
 
 	struct completion xfer_completion;
@@ -278,7 +278,7 @@ static void rockchip_spi_set_cs(struct spi_device *spi, bool enable)
 }
 
 static int rockchip_spi_prepare_message(struct spi_master *master,
-		struct spi_message *msg)
+					struct spi_message *msg)
 {
 	struct rockchip_spi *rs = spi_master_get_devdata(master);
 	struct spi_device *spi = msg->spi;
@@ -294,13 +294,19 @@ static int rockchip_spi_prepare_message(struct spi_master *master,
 }
 
 static int rockchip_spi_unprepare_message(struct spi_master *master,
-		struct spi_message *msg)
+					  struct spi_message *msg)
 {
 	unsigned long flags;
 	struct rockchip_spi *rs = spi_master_get_devdata(master);
 
 	spin_lock_irqsave(&rs->lock, flags);
 
+	/*
+	 * For DMA mode, we need terminate DMA channel and flush
+	 * fifo for the next transfer if DMA thansfer timeout.
+	 * unprepare_message() was called by core if transfer complete
+	 * or timeout. Maybe it is reasonable for error handling here.
+	 */
 	if (rs->use_dma) {
 		if (rs->state & RXBUSY) {
 			dmaengine_terminate_all(rs->dma_rx.ch);
@@ -344,7 +350,7 @@ static void rockchip_spi_pio_reader(struct rockchip_spi *rs)
 		else
 			*(u16 *)(rs->rx) = (u16)rxw;
 		rs->rx += rs->n_bytes;
-	};
+	}
 }
 
 static int rockchip_spi_pio_transfer(struct rockchip_spi *rs)
@@ -414,7 +420,8 @@ static int rockchip_spi_dma_transfer(struct rockchip_spi *rs)
 		rxconf.src_maxburst = rs->n_bytes;
 		dmaengine_slave_config(rs->dma_rx.ch, &rxconf);
 
-		rxdesc = dmaengine_prep_slave_sg(rs->dma_rx.ch,
+		rxdesc = dmaengine_prep_slave_sg(
+				rs->dma_rx.ch,
 				rs->rx_sg.sgl, rs->rx_sg.nents,
 				rs->dma_rx.direction, DMA_PREP_INTERRUPT);
 
@@ -429,7 +436,8 @@ static int rockchip_spi_dma_transfer(struct rockchip_spi *rs)
 		txconf.dst_maxburst = rs->n_bytes;
 		dmaengine_slave_config(rs->dma_tx.ch, &txconf);
 
-		txdesc = dmaengine_prep_slave_sg(rs->dma_tx.ch,
+		txdesc = dmaengine_prep_slave_sg(
+				rs->dma_tx.ch,
 				rs->tx_sg.sgl, rs->tx_sg.nents,
 				rs->dma_tx.direction, DMA_PREP_INTERRUPT);
 
@@ -495,13 +503,13 @@ static void rockchip_spi_config(struct rockchip_spi *rs)
 
 	spi_set_clk(rs, div);
 
-	dev_dbg(rs->dev, "cr0 0x%x, div %d\n",
-			cr0, div);
+	dev_dbg(rs->dev, "cr0 0x%x, div %d\n", cr0, div);
 
 	spi_enable_chip(rs, 1);
 }
 
-static int rockchip_spi_transfer_one(struct spi_master *master,
+static int rockchip_spi_transfer_one(
+		struct spi_master *master,
 		struct spi_device *spi,
 		struct spi_transfer *xfer)
 {
@@ -556,8 +564,8 @@ static int rockchip_spi_transfer_one(struct spi_master *master,
 }
 
 static bool rockchip_spi_can_dma(struct spi_master *master,
-		struct spi_device *spi,
-		struct spi_transfer *xfer)
+				 struct spi_device *spi,
+				 struct spi_transfer *xfer)
 {
 	struct rockchip_spi *rs = spi_master_get_devdata(master);
 
@@ -572,10 +580,9 @@ static int rockchip_spi_probe(struct platform_device *pdev)
 	struct resource *mem;
 
 	master = spi_alloc_master(&pdev->dev, sizeof(struct rockchip_spi));
-	if (!master) {
-		dev_err(&pdev->dev, "No memory for spi_master\n");
+	if (!master)
 		return -ENOMEM;
-	}
+
 	platform_set_drvdata(pdev, master);
 
 	rs = spi_master_get_devdata(master);
@@ -676,8 +683,6 @@ static int rockchip_spi_probe(struct platform_device *pdev)
 		goto err_register_master;
 	}
 
-	dev_info(&pdev->dev, "Rockchip SPI controller initialized\n");
-
 	return 0;
 
 err_register_master:
@@ -817,6 +822,6 @@ static struct platform_driver rockchip_spi_driver = {
 
 module_platform_driver(rockchip_spi_driver);
 
-MODULE_AUTHOR("addy ke <addy.ke@rock-chips.com>");
+MODULE_AUTHOR("Addy Ke <addy.ke@rock-chips.com>");
 MODULE_DESCRIPTION("ROCKCHIP SPI Controller Driver");
 MODULE_LICENSE("GPL v2");
-- 
1.8.3.2


