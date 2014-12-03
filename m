Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305AbaLCOes (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 09:34:48 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:44835 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752704AbaLCOeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 09:34:13 -0500
From: Alexander Kochetkov <al.kochet@gmail.com>
To: Kevin Hilman <khilman@kernel.org>, Tony Lindgren <tony@atomide.com>,
        Felipe Balbi <balbi@ti.com>, Wolfram Sang <wsa@the-dreams.de>,
        Alexander Kochetkov <al.kochet@gmail.com>
Cc: linux-omap@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC 4/5] i2c: omap: reimpelement STP hack via 2-phases transfer
Date: Wed,  3 Dec 2014 18:34:01 +0400
Message-Id: <1417617242-16869-5-git-send-email-al.kochet@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1417617242-16869-1-git-send-email-al.kochet@gmail.com>
References: <1417617242-16869-1-git-send-email-al.kochet@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The main reason is to avoid CON register access by omap_i2c_xfer_msg()
function, after transfer was submitted to IP.

The change takes into account comment from the code:
"Don't write stt and stp together on some hardware."

That mean, what some hardware doesn't support "Full transfers",
transfers with STT and STP bits set together.

While this is doesn't correspond errata and TRM, assume it's true.
According to TRM, "Full transfer" could be expessed with "2 phases transfer":
first start with STT and STP bits set to 1 and 0, second with
0 and 1.

The change affects omap3530 and early boards.
Tested and simulated on omap3730 (Beagleboard XM C).

Signed-off-by: Alexander Kochetkov <al.kochet@gmail.com>
---
 drivers/i2c/busses/i2c-omap.c |   46 ++++++++++++++++++++---------------------
 1 file changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
index 9e0d359..66506db 100644
--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -213,6 +213,7 @@ struct omap_i2c_dev {
 						 * the I2C bus state
 						 */
 	unsigned		receiver:1;	/* true when we're in receiver mode */
+	unsigned		stop:1;		/* ISR send STP after xfer */
 	u16			iestate;	/* Saved interrupt register */
 	u16			pscstate;
 	u16			scllstate;
@@ -669,6 +670,11 @@ static int omap_i2c_xfer_msg(struct i2c_adapter *adap,
 	if (!dev->b_hw && stop)
 		w |= OMAP_I2C_CON_STP;
 	/*
+	 * Don't write stt and stp together on some hardware.
+	 */
+	dev->stop = (dev->b_hw && stop);
+
+	/*
 	 * NOTE: STAT_BB bit could became 1 here if another master occupy
 	 * the bus. IP successfully complete transfer when the bus will be
 	 * free again (BB reset to 0).
@@ -676,29 +682,6 @@ static int omap_i2c_xfer_msg(struct i2c_adapter *adap,
 	omap_i2c_write_reg(dev, OMAP_I2C_CON_REG, w);
 
 	/*
-	 * Don't write stt and stp together on some hardware.
-	 */
-	if (dev->b_hw && stop) {
-		unsigned long delay = jiffies + OMAP_I2C_TIMEOUT;
-		u16 con = omap_i2c_read_reg(dev, OMAP_I2C_CON_REG);
-		while (con & OMAP_I2C_CON_STT) {
-			con = omap_i2c_read_reg(dev, OMAP_I2C_CON_REG);
-
-			/* Let the user know if i2c is in a bad state */
-			if (time_after(jiffies, delay)) {
-				dev_err(dev->dev, "controller timed out "
-				"waiting for start condition to finish\n");
-				return -ETIMEDOUT;
-			}
-			cpu_relax();
-		}
-
-		w |= OMAP_I2C_CON_STP;
-		w &= ~OMAP_I2C_CON_STT;
-		omap_i2c_write_reg(dev, OMAP_I2C_CON_REG, w);
-	}
-
-	/*
 	 * REVISIT: We should abort the transfer on signals, but the bus goes
 	 * into arbitration and we're currently unable to recover from it.
 	 */
@@ -1021,6 +1004,7 @@ omap_i2c_isr_thread(int this_irq, void *dev_id)
 		if (stat & OMAP_I2C_STAT_NACK) {
 			u16 con;
 
+			dev->stop = 0;
 			dev->cmd_err |= OMAP_I2C_STAT_NACK;
 			omap_i2c_ack_stat(dev, OMAP_I2C_STAT_NACK);
 
@@ -1041,6 +1025,7 @@ omap_i2c_isr_thread(int this_irq, void *dev_id)
 
 		if (stat & OMAP_I2C_STAT_AL) {
 			dev_err(dev->dev, "Arbitration lost\n");
+			dev->stop = 0;
 			err |= OMAP_I2C_STAT_AL;
 			omap_i2c_ack_stat(dev, OMAP_I2C_STAT_AL);
 		}
@@ -1051,6 +1036,21 @@ omap_i2c_isr_thread(int this_irq, void *dev_id)
 		if (stat & OMAP_I2C_STAT_ARDY)
 			omap_i2c_ack_stat(dev, OMAP_I2C_STAT_ARDY);
 
+		if ((stat & OMAP_I2C_STAT_ARDY) && dev->stop) {
+			u16 con;
+			/* Second phase transfer with STT:STP=01 */
+			omap_i2c_ack_stat(dev, OMAP_I2C_STAT_ARDY);
+			dev->stop = 0;
+
+			con = omap_i2c_read_reg(dev, OMAP_I2C_CON_REG);
+			con |= OMAP_I2C_CON_STP;
+			con &= ~OMAP_I2C_CON_STT;
+			omap_i2c_write_reg(dev, OMAP_I2C_CON_REG, con);
+
+			/* Wait for the next ARDY */
+			continue;
+		}
+
 		if (stat & (OMAP_I2C_STAT_ARDY | OMAP_I2C_STAT_AL)) {
 			/*
 			 * These are pending events not handled in time
-- 
1.7.9.5

