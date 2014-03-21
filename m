Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965732AbaCUAHt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 20:07:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36900 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965607AbaCUAEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:04:54 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 3.13 129/149] can: flexcan: factor out transceiver {en,dis}able into seperate functions
Date: Thu, 20 Mar 2014 17:04:52 -0700
Message-Id: <20140321000441.427282218@linuxfoundation.org>
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

commit f003698e23f6f56a791774f14d0ac35d04872490 upstream.

This patch moves the transceiver enable and disable into seperate functions,
where the NULL pointer check is hidden.

Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/can/flexcan.c |   27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

--- a/drivers/net/can/flexcan.c
+++ b/drivers/net/can/flexcan.c
@@ -261,6 +261,22 @@ static inline void flexcan_write(u32 val
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
@@ -805,11 +821,9 @@ static int flexcan_chip_start(struct net
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
@@ -854,8 +868,7 @@ static void flexcan_chip_stop(struct net
 	flexcan_write(priv->reg_ctrl_default & ~FLEXCAN_CTRL_ERR_ALL,
 		      &regs->ctrl);
 
-	if (priv->reg_xceiver)
-		regulator_disable(priv->reg_xceiver);
+	flexcan_transceiver_disable(priv);
 	priv->can.state = CAN_STATE_STOPPED;
 
 	return;


