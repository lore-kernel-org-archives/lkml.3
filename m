Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222AbaC3Xrn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 19:47:43 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37332 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754803AbaC3Xny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 19:43:54 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Marc Kleine-Budde" <mkl@pengutronix.de>
Date: Mon, 31 Mar 2014 00:23:35 +0100
Message-ID: <lsq.1396221815.145685826@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 155/200] can: flexcan: fix shutdown: first disable
 chip, then all interrupts
In-Reply-To: <lsq.1396221814.369444335@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.56-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit 5be93bdda64e85450598c6e97f79fb8f6acf30e0 upstream.

When shutting down the CAN interface (ifconfig canX down) during high CAN bus
loads, the CAN core might hang and freeze the whole CPU.

This patch fixes the shutdown sequence by first disabling the CAN core then
disabling all interrupts.

Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/can/flexcan.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -777,14 +777,16 @@ static void flexcan_chip_stop(struct net
 	struct flexcan_regs __iomem *regs = priv->base;
 	u32 reg;
 
-	/* Disable all interrupts */
-	flexcan_write(0, &regs->imask1);
-
 	/* Disable + halt module */
 	reg = flexcan_read(&regs->mcr);
 	reg |= FLEXCAN_MCR_MDIS | FLEXCAN_MCR_HALT;
 	flexcan_write(reg, &regs->mcr);
 
+	/* Disable all interrupts */
+	flexcan_write(0, &regs->imask1);
+	flexcan_write(priv->reg_ctrl_default & ~FLEXCAN_CTRL_ERR_ALL,
+		      &regs->ctrl);
+
 	flexcan_transceiver_switch(priv, 0);
 	priv->can.state = CAN_STATE_STOPPED;
 

