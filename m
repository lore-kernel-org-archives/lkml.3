Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728AbaKUWwY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 17:52:24 -0500
Received: from mail-lb0-f173.google.com ([209.85.217.173]:48382 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751127AbaKUWwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 17:52:22 -0500
From: Alexander Kochetkov <al.kochet@gmail.com>
To: linux-omap@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Tony Lindgren <tony@atomide.com>,
        Felipe Balbi <balbi@ti.com>, al.kochet@gmail.com
Subject: [PATCH v2 3/4] i2c: omap: don't reset controller if Arbitration Lost detected
Date: Sat, 22 Nov 2014 02:51:47 +0400
Message-Id: <1416610307-3698-1-git-send-email-al.kochet@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1416518925-20679-4-git-send-email-al.kochet@gmail.com>
References: <1416518925-20679-4-git-send-email-al.kochet@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arbitration Lost is an expected situation in a multimaster
environment. I2C controller (IP) correctly detect and report AL.

The only one visible reason for reseting IP in the AL case is
to avoid advisory 1.94 (omap3) and errata i595 (omap4): "I2C:
After an Arbitration is Lost the Module Incorrectly Starts
the Next Transfer".

Errata workaround states: "The MST and STT bits inside I2C_CON
should be set to 1 at the same moment (avoid setting the MST bit
to 1 while STT = 0)." The driver never set MST and STT bits
separately and doesn't create condition for errata. So the reset
is not necessary.

Also corrected return value for AL to -EAGAIN.

Tested on Beagleboard XM C.

Signed-off-by: Alexander Kochetkov <al.kochet@gmail.com>
---

On 21.10.2014 21:11, Wolfram Sang <wsa@the-dreams.de> wrote:
> The errno for AL is -EAGAIN. Curly braces are not needed.

Thank you, Wolfram, fixed.

 drivers/i2c/busses/i2c-omap.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
index 3ffb9c0..02da567 100644
--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -707,13 +707,15 @@ static int omap_i2c_xfer_msg(struct i2c_adapter *adap,
 		return 0;
 
 	/* We have an error */
-	if (dev->cmd_err & (OMAP_I2C_STAT_AL | OMAP_I2C_STAT_ROVR |
-			    OMAP_I2C_STAT_XUDF)) {
+	if (dev->cmd_err & (OMAP_I2C_STAT_ROVR | OMAP_I2C_STAT_XUDF)) {
 		omap_i2c_reset(dev);
 		__omap_i2c_init(dev);
 		return -EIO;
 	}
 
+	if (dev->cmd_err & OMAP_I2C_STAT_AL)
+		return -EAGAIN;
+
 	if (dev->cmd_err & OMAP_I2C_STAT_NACK) {
 		if (msg->flags & I2C_M_IGNORE_NAK)
 			return 0;
-- 
1.7.9.5

