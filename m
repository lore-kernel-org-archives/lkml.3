Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754970AbaCaNuw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 09:50:52 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35562 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753540AbaCaNXk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 09:23:40 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Marc Kleine-Budde <mkl@pengutronix.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 13/71] can: flexcan: fix shutdown: first disable chip, then all interrupts
Date: Mon, 31 Mar 2014 14:22:19 +0100
Message-Id: <1396272197-13394-14-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396272197-13394-1-git-send-email-luis.henriques@canonical.com>
References: <1396272197-13394-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.33 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit 5be93bdda64e85450598c6e97f79fb8f6acf30e0 upstream.

When shutting down the CAN interface (ifconfig canX down) during high CAN bus
loads, the CAN core might hang and freeze the whole CPU.

This patch fixes the shutdown sequence by first disabling the CAN core then
disabling all interrupts.

Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/can/flexcan.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index 2bf507b..95109eb 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -779,14 +779,16 @@ static void flexcan_chip_stop(struct net_device *dev)
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
 
-- 
1.9.1

