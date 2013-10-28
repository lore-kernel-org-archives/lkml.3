Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757199Ab3J1Ove (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 10:51:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51331 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757089Ab3J1OuA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 10:50:00 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Marc Kleine-Budde <mkl@pengutronix.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 62/64] can: flexcan: fix flexcan_chip_start() on imx6
Date: Mon, 28 Oct 2013 14:48:21 +0000
Message-Id: <1382971703-17393-63-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1382971703-17393-1-git-send-email-luis.henriques@canonical.com>
References: <1382971703-17393-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.24 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/can/flexcan.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 81d4741..6a51f5c 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -668,7 +668,6 @@ static int flexcan_chip_start(struct net_device *dev)
 {
 	struct flexcan_priv *priv = netdev_priv(dev);
 	struct flexcan_regs __iomem *regs = priv->base;
-	unsigned int i;
 	int err;
 	u32 reg_mcr, reg_ctrl;
 
@@ -734,17 +733,6 @@ static int flexcan_chip_start(struct net_device *dev)
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
 	/* acceptance mask/acceptance code (accept everything) */
 	flexcan_write(0x0, &regs->rxgmask);
 	flexcan_write(0x0, &regs->rx14mask);
-- 
1.8.3.2

