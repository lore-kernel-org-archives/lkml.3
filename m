Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758219AbaKTV3r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 16:29:47 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:49677 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758095AbaKTV3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 16:29:07 -0500
From: Alexander Kochetkov <al.kochet@gmail.com>
To: linux-omap@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, al.kochet@gmail.com
Cc: Wolfram Sang <wsa@the-dreams.de>, Tony Lindgren <tony@atomide.com>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 3/4] i2c: omap: don't reset controller if Arbitration Lost detected
Date: Fri, 21 Nov 2014 01:28:44 +0400
Message-Id: <1416518925-20679-4-git-send-email-al.kochet@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1416518925-20679-1-git-send-email-al.kochet@gmail.com>
References: <1416518925-20679-1-git-send-email-al.kochet@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arbitration Lost is a expected situation in a multimaster environment.
IP correctly detect it.

The only reason for reseting IP in the AL case is to be sure to
avoid advisory 1.94 (omap3) and errata i595 (omap4):
"I2C: After an Arbitration is Lost the Module Incorrectly Starts
the Next Transfer" with workaround: "The MST and STT bits inside
I2C_CON should be set to 1 at the same moment (avoid setting the
MST bit to 1 while STT = 0)."

The driver never writes MST and STT bits separately and doesn't
create condition for errata. So the reset is not necessary.

Tested on Beagleboard XM C.

Signed-off-by: Alexander Kochetkov <al.kochet@gmail.com>
---
 drivers/i2c/busses/i2c-omap.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
index 3ffb9c0..47103e7 100644
--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -707,13 +707,17 @@ static int omap_i2c_xfer_msg(struct i2c_adapter *adap,
 		return 0;
 
 	/* We have an error */
-	if (dev->cmd_err & (OMAP_I2C_STAT_AL | OMAP_I2C_STAT_ROVR |
+	if (dev->cmd_err & (OMAP_I2C_STAT_ROVR |
 			    OMAP_I2C_STAT_XUDF)) {
 		omap_i2c_reset(dev);
 		__omap_i2c_init(dev);
 		return -EIO;
 	}
 
+	if (dev->cmd_err & OMAP_I2C_STAT_AL) {
+		return -EIO;
+	}
+
 	if (dev->cmd_err & OMAP_I2C_STAT_NACK) {
 		if (msg->flags & I2C_M_IGNORE_NAK)
 			return 0;
-- 
1.7.9.5

