Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754122Ab3JUIwM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 04:52:12 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39695 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753992Ab3JUIwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:52:05 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "=?UTF-8?Q?Lothar=20Wa=C3=9Fmann?=" <LW@KARO-electronics.de>,
        "Marc Kleine-Budde" <mkl@pengutronix.de>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.205668698@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 094/149] can: flexcan: fix flexcan_chip_start() on imx6
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/can/flexcan.c | 12 ------------
 1 file changed, 12 deletions(-)

--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -666,7 +666,6 @@ static int flexcan_chip_start(struct net
 {
 	struct flexcan_priv *priv = netdev_priv(dev);
 	struct flexcan_regs __iomem *regs = priv->base;
-	unsigned int i;
 	int err;
 	u32 reg_mcr, reg_ctrl;
 
@@ -732,17 +731,6 @@ static int flexcan_chip_start(struct net
 	dev_dbg(dev->dev.parent, "%s: writing ctrl=0x%08x", __func__, reg_ctrl);
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

