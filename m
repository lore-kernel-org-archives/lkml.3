Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751911AbaIYHAZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 03:00:25 -0400
Received: from regular1.263xmail.com ([211.150.99.137]:34067 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbaIYHAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 03:00:23 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-KSVirus-check: 0
X-ABS-CHECKED: 4
X-RL-SENDER: addy.ke@rock-chips.com
X-FST-TO: broonie@kernel.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: addy.ke@rock-chips.com
X-UNIQUE-TAG: <f5674fc387f0697e1692624ca7442c88>
X-ATTACHMENT-NUM: 0
X-DNS-TYPE: 1
From: Addy Ke <addy.ke@rock-chips.com>
To: broonie@kernel.org, heiko@sntech.de, dianders@chromium.org,
        grant.likely@linaro.org, robh+dt@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, devicetree@vger.kernel.org,
        olof@lixom.net, hj@rock-chips.com, kever.yang@rock-chips.com,
        xjq@rock-chips.com, huangtao@rock-chips.com, zyw@rock-chips.com,
        yzq@rock-chips.com, zhenfu.fang@rock-chips.com, cf@rock-chips.com,
        zhangqing@rock-chips.com, hl@rock-chips.com, wei.luo@rock-chips.com,
        Addy Ke <addy.ke@rock-chips.com>
Subject: [PATCH] spi/rockchip: fix bug that cause the failture to read data in DMA mode
Date: Thu, 25 Sep 2014 14:59:41 +0800
Message-Id: <1411628381-4029-1-git-send-email-addy.ke@rock-chips.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In my test on RK3288-pinky board, if spi is enabled, it will begin to
read data from slave regardless of whether the DMA is ready. So we
need prepare DMA before spi is enable.

Signed-off-by: Addy Ke <addy.ke@rock-chips.com>
---
 drivers/spi/spi-rockchip.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/spi/spi-rockchip.c b/drivers/spi/spi-rockchip.c
index 3afc266..f96ea8a 100644
--- a/drivers/spi/spi-rockchip.c
+++ b/drivers/spi/spi-rockchip.c
@@ -415,7 +415,7 @@ static void rockchip_spi_dma_txcb(void *data)
 	spin_unlock_irqrestore(&rs->lock, flags);
 }
 
-static int rockchip_spi_dma_transfer(struct rockchip_spi *rs)
+static void rockchip_spi_prepare_dma(struct rockchip_spi *rs)
 {
 	unsigned long flags;
 	struct dma_slave_config rxconf, txconf;
@@ -474,8 +474,6 @@ static int rockchip_spi_dma_transfer(struct rockchip_spi *rs)
 		dmaengine_submit(txdesc);
 		dma_async_issue_pending(rs->dma_tx.ch);
 	}
-
-	return 1;
 }
 
 static void rockchip_spi_config(struct rockchip_spi *rs)
@@ -557,16 +555,17 @@ static int rockchip_spi_transfer_one(
 	else if (rs->rx)
 		rs->tmode = CR0_XFM_RO;
 
-	if (master->can_dma && master->can_dma(master, spi, xfer))
+	/* we need prepare dma before spi was enabled */
+	if (master->can_dma && master->can_dma(master, spi, xfer)) {
 		rs->use_dma = 1;
-	else
+		rockchip_spi_prepare_dma(rs);
+	} else {
 		rs->use_dma = 0;
+	}
 
 	rockchip_spi_config(rs);
 
-	if (rs->use_dma)
-		ret = rockchip_spi_dma_transfer(rs);
-	else
+	if (!rs->use_dma)
 		ret = rockchip_spi_pio_transfer(rs);
 
 	return ret;
-- 
1.8.3.2


