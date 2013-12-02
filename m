Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759484Ab3LBVOa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 16:14:30 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38406 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753962Ab3LBTM7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:12:59 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 3.10 026/173] can: flexcan: fix flexcan_chip_start() on imx6
Date: Mon,  2 Dec 2013 11:10:09 -0800
Message-Id: <20131202191145.802742057@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191142.873808297@linuxfoundation.org>
References: <20131202191142.873808297@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit 0d1862ea1a5bb876cf05555a7307080cb75bf379 upstream.

In the flexcan_chip_start() function first the flexcan core is going through
the soft reset sequence, then the RX FIFO is enabled.

With the hardware is put into FIFO mode, message buffers 1...7 are reserved by
the FIFO engine. The remaining message buffers are in reset default values.
This patch removes the bogus initialization of the message buffers, as it
causes an imprecise external abort on imx6.

Reported-by: Lothar Waßmann <LW@KARO-electronics.de>
Tested-by: Lothar Waßmann <LW@KARO-electronics.de>
[mkl: adjusted context for stable]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/flexcan.c |   12 ------------
 1 file changed, 12 deletions(-)

--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -711,7 +711,6 @@ static int flexcan_chip_start(struct net
 {
 	struct flexcan_priv *priv = netdev_priv(dev);
 	struct flexcan_regs __iomem *regs = priv->base;
-	unsigned int i;
 	int err;
 	u32 reg_mcr, reg_ctrl;
 
@@ -783,17 +782,6 @@ static int flexcan_chip_start(struct net
 	netdev_dbg(dev, "%s: writing ctrl=0x%08x", __func__, reg_ctrl);
 	flexcan_write(reg_ctrl, &regs->ctrl);
 
-	for (i = 0; i < ARRAY_SIZE(regs->cantxfg); i++) {
-		flexcan_write(0, &regs->cantxfg[i].can_ctrl);
-		flexcan_write(0, &regs->cantxfg[i].can_id);
-		flexcan_write(0, &regs->cantxfg[i].data[0]);
-		flexcan_write(0, &regs->cantxfg[i].data[1]);
-
-		/* put MB into rx queue */
-		flexcan_write(FLEXCAN_MB_CNT_CODE(0x4),
-			&regs->cantxfg[i].can_ctrl);
-	}
-
 	/* Abort any pending TX, mark Mailbox as INACTIVE */
 	flexcan_write(FLEXCAN_MB_CNT_CODE(0x4),
 		      &regs->cantxfg[FLEXCAN_TX_BUF_ID].can_ctrl);


