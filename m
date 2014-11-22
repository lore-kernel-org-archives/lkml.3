Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419AbaKVTr4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 14:47:56 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:47901 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752515AbaKVTr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 14:47:26 -0500
From: Alexander Kochetkov <al.kochet@gmail.com>
To: linux-omap@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Wolfram Sang <wsa@the-dreams.de>, Tony Lindgren <tony@atomide.com>,
        Felipe Balbi <balbi@ti.com>, al.kochet@gmail.com
Subject: [PATCH v3 4/4] i2c: omap: add notes related to i2c multimaster mode
Date: Sat, 22 Nov 2014 23:47:14 +0400
Message-Id: <1416685634-5864-5-git-send-email-al.kochet@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1416685634-5864-1-git-send-email-al.kochet@gmail.com>
References: <1416518925-20679-1-git-send-email-al.kochet@gmail.com>
 <1416685634-5864-1-git-send-email-al.kochet@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No functional changes.

Signed-off-by: Alexander Kochetkov <al.kochet@gmail.com>
Reviewed-by: Felipe Balbi <balbi@ti.com>
---
 drivers/i2c/busses/i2c-omap.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
index e67b7d0..f276c0c 100644
--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -300,6 +300,12 @@ static void __omap_i2c_init(struct omap_i2c_dev *dev)
 	omap_i2c_write_reg(dev, OMAP_I2C_CON_REG, OMAP_I2C_CON_EN);
 
 	/*
+	 * NOTE: right after setting CON_EN, STAT_BB could be 0 while the
+	 * bus is busy. It will be changed to 1 on the next IP FCLK clock.
+	 * udelay(1) will be enough to fix that.
+	 */
+
+	/*
 	 * Don't write to this register if the IE state is 0 as it can
 	 * cause deadlock.
 	 */
@@ -660,7 +666,11 @@ static int omap_i2c_xfer_msg(struct i2c_adapter *adap,
 
 	if (!dev->b_hw && stop)
 		w |= OMAP_I2C_CON_STP;
-
+	/*
+	 * NOTE: STAT_BB bit could became 1 here if another master occupy
+	 * the bus. IP successfully complete transfer when the bus will be
+	 * free again (BB reset to 0).
+	 */
 	omap_i2c_write_reg(dev, OMAP_I2C_CON_REG, w);
 
 	/*
-- 
1.7.9.5

