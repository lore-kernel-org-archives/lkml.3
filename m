Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957AbaDALQt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:16:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42235 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbaDALQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:16:43 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Marc Kleine-Budde <mkl@pengutronix.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 035/144] can: flexcan: fix transition from and to freeze mode in chip_{,un}freeze
Date: Tue,  1 Apr 2014 12:13:59 +0100
Message-Id: <1396350948-29910-36-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit b1aa1c7a2165b44ecce66286a3095cc6c7667d1c upstream.

This patch factors out freeze and unfreeze of the CAN core into seperate
functions. Experiments have shown that the transition from and to freeze mode
may take several microseconds, especially the time entering the freeze mode
depends on the current bitrate.

This patch adds a while loop which polls the Freeze Mode ACK bit (FRZ_ACK) that
indicates a successfull mode change. If the function runs into a timeout a
error value is returned.

Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/can/flexcan.c | 60 ++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 49 insertions(+), 11 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index d065715..bc30fd1 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -322,6 +322,44 @@ static int flexcan_chip_disable(struct flexcan_priv *priv)
 	return 0;
 }
 
+static int flexcan_chip_freeze(struct flexcan_priv *priv)
+{
+	struct flexcan_regs __iomem *regs = priv->base;
+	unsigned int timeout = 1000 * 1000 * 10 / priv->can.bittiming.bitrate;
+	u32 reg;
+
+	reg = flexcan_read(&regs->mcr);
+	reg |= FLEXCAN_MCR_HALT;
+	flexcan_write(reg, &regs->mcr);
+
+	while (timeout-- && !(flexcan_read(&regs->mcr) & FLEXCAN_MCR_FRZ_ACK))
+		usleep_range(100, 200);
+
+	if (!(flexcan_read(&regs->mcr) & FLEXCAN_MCR_FRZ_ACK))
+		return -ETIMEDOUT;
+
+	return 0;
+}
+
+static int flexcan_chip_unfreeze(struct flexcan_priv *priv)
+{
+	struct flexcan_regs __iomem *regs = priv->base;
+	unsigned int timeout = FLEXCAN_TIMEOUT_US / 10;
+	u32 reg;
+
+	reg = flexcan_read(&regs->mcr);
+	reg &= ~FLEXCAN_MCR_HALT;
+	flexcan_write(reg, &regs->mcr);
+
+	while (timeout-- && (flexcan_read(&regs->mcr) & FLEXCAN_MCR_FRZ_ACK))
+		usleep_range(10, 20);
+
+	if (flexcan_read(&regs->mcr) & FLEXCAN_MCR_FRZ_ACK)
+		return -ETIMEDOUT;
+
+	return 0;
+}
+
 static int flexcan_get_berr_counter(const struct net_device *dev,
 				    struct can_berr_counter *bec)
 {
@@ -753,7 +791,7 @@ static int flexcan_chip_start(struct net_device *dev)
 		netdev_err(dev, "Failed to softreset can module (mcr=0x%08x)\n",
 			   reg_mcr);
 		err = -ENODEV;
-		goto out;
+		goto out_chip_disable;
 	}
 
 	flexcan_set_bittiming(dev);
@@ -823,12 +861,12 @@ static int flexcan_chip_start(struct net_device *dev)
 
 	err = flexcan_transceiver_enable(priv);
 	if (err)
-		goto out;
+		goto out_chip_disable;
 
 	/* synchronize with the can bus */
-	reg_mcr = flexcan_read(&regs->mcr);
-	reg_mcr &= ~FLEXCAN_MCR_HALT;
-	flexcan_write(reg_mcr, &regs->mcr);
+	err = flexcan_chip_unfreeze(priv);
+	if (err)
+		goto out_transceiver_disable;
 
 	priv->can.state = CAN_STATE_ERROR_ACTIVE;
 
@@ -841,7 +879,9 @@ static int flexcan_chip_start(struct net_device *dev)
 
 	return 0;
 
- out:
+ out_transceiver_disable:
+	flexcan_transceiver_disable(priv);
+ out_chip_disable:
 	flexcan_chip_disable(priv);
 	return err;
 }
@@ -856,12 +896,10 @@ static void flexcan_chip_stop(struct net_device *dev)
 {
 	struct flexcan_priv *priv = netdev_priv(dev);
 	struct flexcan_regs __iomem *regs = priv->base;
-	u32 reg;
 
-	/* Disable + halt module */
-	reg = flexcan_read(&regs->mcr);
-	reg |= FLEXCAN_MCR_MDIS | FLEXCAN_MCR_HALT;
-	flexcan_write(reg, &regs->mcr);
+	/* freeze + disable module */
+	flexcan_chip_freeze(priv);
+	flexcan_chip_disable(priv);
 
 	/* Disable all interrupts */
 	flexcan_write(0, &regs->imask1);
-- 
1.9.1

