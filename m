Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965562AbaCUAEr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:04:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36827 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965474AbaCUAEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:04:37 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 3.13 126/149] can: flexcan: fix shutdown: first disable chip, then all interrupts
Date: Thu, 20 Mar 2014 17:04:49 -0700
Message-Id: <20140321000441.320323419@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000436.377902063@linuxfoundation.org>
References: <20140321000436.377902063@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit 5be93bdda64e85450598c6e97f79fb8f6acf30e0 upstream.

When shutting down the CAN interface (ifconfig canX down) during high CAN bus
loads, the CAN core might hang and freeze the whole CPU.

This patch fixes the shutdown sequence by first disabling the CAN core then
disabling all interrupts.

Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/can/flexcan.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -824,14 +824,16 @@ static void flexcan_chip_stop(struct net
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
 	if (priv->reg_xceiver)
 		regulator_disable(priv->reg_xceiver);
 	priv->can.state = CAN_STATE_STOPPED;


