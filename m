Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752332AbaGKCIo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 22:08:44 -0400
Received: from regular1.263xmail.com ([211.150.99.130]:38783 "EHLO
	regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771AbaGKCIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 22:08:42 -0400
X-263anti-spam: KSV:0;
X-MAIL-GRAY: 0
X-MAIL-DELIVERY: 1
X-ABS-CHECKED: 4
X-KSVirus-check: 0
X-RL-SENDER: addy.ke@rock-chips.com
X-FST-TO: broonie@kernel.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: addy.ke@rock-chips.com
X-UNIQUE-TAG: <6569b6fbde62c4260e32dad36a98b8fd>
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
Subject: [PATCH 2/4] spi/rockchip: call wait_for_idle() for the transfer to complete
Date: Fri, 11 Jul 2014 10:08:24 +0800
Message-Id: <1405044504-6917-1-git-send-email-addy.ke@rock-chips.com>
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
 drivers/spi/spi-rockchip.c | 24 +++++++++++++++++++-----
 1 file changed, 19 insertions(+), 5 deletions(-)

diff --git a/drivers/spi/spi-rockchip.c b/drivers/spi/spi-rockchip.c
index 8c24708..09c690c 100644
--- a/drivers/spi/spi-rockchip.c
+++ b/drivers/spi/spi-rockchip.c
@@ -214,6 +214,18 @@ static inline void flush_fifo(struct rockchip_spi *rs)
 		readl_relaxed(rs->regs + ROCKCHIP_SPI_RXDR);
 }
 
+static inline void wait_for_idle(struct rockchip_spi *rs)
+{
+	unsigned long timeout = jiffies + msecs_to_jiffies(5);
+
+	do {
+		if (!(readl_relaxed(rs->regs + ROCKCHIP_SPI_SR) & SR_BUSY))
+			return;
+	} while (time_before(jiffies, timeout));
+
+	dev_warn(rs->dev, "spi controller is in busy state!\n");
+}
+
 static u32 get_fifo_len(struct rockchip_spi *rs)
 {
 	u32 fifo;
@@ -371,6 +383,10 @@ static int rockchip_spi_pio_transfer(struct rockchip_spi *rs)
 		cpu_relax();
 	} while (remain);
 
+	/* If tx, wait until the FIFO data completely. */
+	if (rs->tx)
+		wait_for_idle(rs);
+
 	return 0;
 }
 
@@ -393,6 +409,9 @@ static void rockchip_spi_dma_txcb(void *data)
 	unsigned long flags;
 	struct rockchip_spi *rs = data;
 
+	/* Wait until the FIFO data completely. */
+	wait_for_idle(rs);
+
 	spin_lock_irqsave(&rs->lock, flags);
 
 	rs->state &= ~TXBUSY;
@@ -536,11 +555,6 @@ static int rockchip_spi_transfer_one(
 	rs->tx_sg = xfer->tx_sg;
 	rs->rx_sg = xfer->rx_sg;
 
-	/* Delay until the FIFO data completely */
-	if (xfer->tx_buf)
-		xfer->delay_usecs
-			= rs->fifo_len * rs->bpw * 1000000 / rs->speed;
-
 	if (rs->tx && rs->rx)
 		rs->tmode = CR0_XFM_TR;
 	else if (rs->tx)
-- 
1.8.3.2


