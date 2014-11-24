Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751277AbaKXWVH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 17:21:07 -0500
Received: from mail-lb0-f173.google.com ([209.85.217.173]:53572 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791AbaKXWVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 17:21:05 -0500
From: Alexander Kochetkov <al.kochet@gmail.com>
To: Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Felipe Balbi <balbi@ti.com>, Wolfram Sang <wsa@the-dreams.de>,
        Kevin Hilman <khilman@kernel.org>,
        Alexander Kochetkov <al.kochet@gmail.com>
Subject: [PATCH v2] omap: i2c: don't check bus state IP rev3.3 and earlier
Date: Tue, 25 Nov 2014 02:20:55 +0400
Message-Id: <1416867655-22232-1-git-send-email-al.kochet@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <20141124210809.GG2817@atomide.com>
References: <20141124210809.GG2817@atomide.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 903c3859f77f9b0aace551da03267ef7a211dbc4 ("i2c: omap: implement
workaround for handling invalid BB-bit values") introduce the error result
in boot test fault on OMAP3530 boards

The patch fix the error (disable i2c bus test for OMAP3530).

Signed-off-by: Alexander Kochetkov <al.kochet@gmail.com>
Fixes: 903c3859f77f9b0aace551da03267ef7a211dbc4
Reported-by: Kevin Hilman <khilman@kernel.org>
Tested-by: Tony Lindgren <tony@atomide.com>

---
 drivers/i2c/busses/i2c-omap.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
index 5d92d0e..4563200 100644
--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -344,8 +344,10 @@ static int omap_i2c_reset(struct omap_i2c_dev *dev)
 		/* SYSC register is cleared by the reset; rewrite it */
 		omap_i2c_write_reg(dev, OMAP_I2C_SYSC_REG, sysc);
 
-		/* Schedule I2C-bus monitoring on the next transfer */
-		dev->bb_valid = 0;
+		if (dev->rev > OMAP_I2C_REV_ON_3430_3530) {
+			/* Schedule I2C-bus monitoring on the next transfer */
+			dev->bb_valid = 0;
+		}
 	}
 
 	return 0;
@@ -460,7 +462,7 @@ static int omap_i2c_init(struct omap_i2c_dev *dev)
 	dev->scllstate = scll;
 	dev->sclhstate = sclh;
 
-	if (dev->rev < OMAP_I2C_OMAP1_REV_2) {
+	if (dev->rev <= OMAP_I2C_REV_ON_3430_3530) {
 		/* Not implemented */
 		dev->bb_valid = 1;
 	}
-- 
1.7.9.5

