Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246AbaLCOeR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 09:34:17 -0500
Received: from mail-la0-f48.google.com ([209.85.215.48]:46782 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753212AbaLCOeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 09:34:12 -0500
From: Alexander Kochetkov <al.kochet@gmail.com>
To: Kevin Hilman <khilman@kernel.org>, Tony Lindgren <tony@atomide.com>,
        Felipe Balbi <balbi@ti.com>, Wolfram Sang <wsa@the-dreams.de>,
        Alexander Kochetkov <al.kochet@gmail.com>
Cc: linux-omap@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC 3/5] i2c: omap: move STP generation logic into ISR thread
Date: Wed,  3 Dec 2014 18:34:00 +0400
Message-Id: <1417617242-16869-4-git-send-email-al.kochet@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1417617242-16869-1-git-send-email-al.kochet@gmail.com>
References: <1417617242-16869-1-git-send-email-al.kochet@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The main reason is to avoid CON register access by omap_i2c_xfer_msg()
function, after transfer was submitted to IP.

Also changed NACK logic to wait ARDY so we can be sure what STP has
been sent on back to back transfers.

Tested on dm3730 (Beagleboard XM C).

Signed-off-by: Alexander Kochetkov <al.kochet@gmail.com>
---
 drivers/i2c/busses/i2c-omap.c |   26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
index 8591c0c..9e0d359 100644
--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -725,12 +725,9 @@ static int omap_i2c_xfer_msg(struct i2c_adapter *adap,
 		return -EAGAIN;
 
 	if (dev->cmd_err & OMAP_I2C_STAT_NACK) {
+		/* NOTE: IP always send stop on NACK */
 		if (msg->flags & I2C_M_IGNORE_NAK)
 			return 0;
-
-		w = omap_i2c_read_reg(dev, OMAP_I2C_CON_REG);
-		w |= OMAP_I2C_CON_STP;
-		omap_i2c_write_reg(dev, OMAP_I2C_CON_REG, w);
 		return -EREMOTEIO;
 	}
 	return -EIO;
@@ -1022,8 +1019,24 @@ omap_i2c_isr_thread(int this_irq, void *dev_id)
 		}
 
 		if (stat & OMAP_I2C_STAT_NACK) {
-			err |= OMAP_I2C_STAT_NACK;
+			u16 con;
+
+			dev->cmd_err |= OMAP_I2C_STAT_NACK;
 			omap_i2c_ack_stat(dev, OMAP_I2C_STAT_NACK);
+
+			/*
+			 * According to the TRM, IP *always* send STP and reset
+			 * MST in NACK cases. But for NACK in the middle of
+			 * transfer IP doesn't do it. So, here is workaround.
+			 */
+			con = omap_i2c_read_reg(dev, OMAP_I2C_CON_REG);
+			if (con & OMAP_I2C_CON_MST) {
+				con |= OMAP_I2C_CON_STP;
+				omap_i2c_write_reg(dev, OMAP_I2C_CON_REG, con);
+			}
+
+			/* Wait for ARDY */
+			continue;
 		}
 
 		if (stat & OMAP_I2C_STAT_AL) {
@@ -1038,8 +1051,7 @@ omap_i2c_isr_thread(int this_irq, void *dev_id)
 		if (stat & OMAP_I2C_STAT_ARDY)
 			omap_i2c_ack_stat(dev, OMAP_I2C_STAT_ARDY);
 
-		if (stat & (OMAP_I2C_STAT_ARDY | OMAP_I2C_STAT_NACK |
-					OMAP_I2C_STAT_AL)) {
+		if (stat & (OMAP_I2C_STAT_ARDY | OMAP_I2C_STAT_AL)) {
 			/*
 			 * These are pending events not handled in time
 			 * due to ISR latency.
-- 
1.7.9.5

