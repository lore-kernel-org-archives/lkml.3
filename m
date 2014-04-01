Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752262AbaDAMMX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 08:12:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42231 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844AbaDALQm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:16:42 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Marc Kleine-Budde <mkl@pengutronix.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 034/144] can: flexcan: factor out transceiver {en,dis}able into seperate functions
Date: Tue,  1 Apr 2014 12:13:58 +0100
Message-Id: <1396350948-29910-35-git-send-email-luis.henriques@canonical.com>
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

commit f003698e23f6f56a791774f14d0ac35d04872490 upstream.

This patch moves the transceiver enable and disable into seperate functions,
where the NULL pointer check is hidden.

Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/can/flexcan.c | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/drivers/net/can/flexcan.c b/drivers/net/can/flexcan.c
index c9ea959..d065715 100644
--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -261,6 +261,22 @@ static inline void flexcan_write(u32 val, void __iomem *addr)
 }
 #endif
 
+static inline int flexcan_transceiver_enable(const struct flexcan_priv *priv)
+{
+	if (!priv->reg_xceiver)
+		return 0;
+
+	return regulator_enable(priv->reg_xceiver);
+}
+
+static inline int flexcan_transceiver_disable(const struct flexcan_priv *priv)
+{
+	if (!priv->reg_xceiver)
+		return 0;
+
+	return regulator_disable(priv->reg_xceiver);
+}
+
 static inline int flexcan_has_and_handle_berr(const struct flexcan_priv *priv,
 					      u32 reg_esr)
 {
@@ -805,11 +821,9 @@ static int flexcan_chip_start(struct net_device *dev)
 	if (priv->devtype_data->features & FLEXCAN_HAS_V10_FEATURES)
 		flexcan_write(0x0, &regs->rxfgmask);
 
-	if (priv->reg_xceiver)	{
-		err = regulator_enable(priv->reg_xceiver);
-		if (err)
-			goto out;
-	}
+	err = flexcan_transceiver_enable(priv);
+	if (err)
+		goto out;
 
 	/* synchronize with the can bus */
 	reg_mcr = flexcan_read(&regs->mcr);
@@ -854,8 +868,7 @@ static void flexcan_chip_stop(struct net_device *dev)
 	flexcan_write(priv->reg_ctrl_default & ~FLEXCAN_CTRL_ERR_ALL,
 		      &regs->ctrl);
 
-	if (priv->reg_xceiver)
-		regulator_disable(priv->reg_xceiver);
+	flexcan_transceiver_disable(priv);
 	priv->can.state = CAN_STATE_STOPPED;
 
 	return;
-- 
1.9.1

