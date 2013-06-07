Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323Ab3FGSuI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 14:50:08 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:42900 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757165Ab3FGSuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 14:50:05 -0400
From: Grygorii Strashko <grygorii.strashko@ti.com>
To: Wolfram Sang <wsa@the-dreams.de>, Tony Lindgren <tony@atomide.com>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-i2c@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Kevin Hilman <khilman@linaro.org>
Subject: [PATCH 3/5] i2c: omap: handle all irqs befor unblocking omap_i2c_xfer_msg()
Date: Fri, 7 Jun 2013 21:46:06 +0300
Message-ID: <1370630768-4077-4-git-send-email-grygorii.strashko@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370630768-4077-1-git-send-email-grygorii.strashko@ti.com>
References: <1370630768-4077-1-git-send-email-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ARDY|NACK and ARDY|AL are set together in OMAP_I2C_STAT_REG, which will be
processed incorrectly now:
iterration 1:
- I2C irq triggered (ARDY|NACK)
- omap_i2c_isr_thread() will ask NACK, fill dev->cmd_err = OMAP_I2C_STAT_NACK
  and trigger "cmd_complete" completion.
- omap_i2c_xfer_msg() will be unblocked, hande NACK and finish its execution.
- omap_i2c_xfer() will finish

iteration 2:
- I2C irq triggered (ARDY)
- omap_i2c_isr_thread() will ask ARDY, trigger completion
  At this point dev->cmd_err == OMAP_I2C_STAT_NACK, "cmd_complete" is not
  initialized and omap_i2c_xfer() may be completed at all.

So, I2C driver is not ready for iteration 2.
Hence, fix it by asking NACK, AL and ARDY all togather in omap_i2c_isr_thread()
before unblocking omap_i2c_xfer_msg() execution.

This is the "old" I2C interrupt handler behavior which was changed by commit:
1d7afc95946487945cc7f5019b41255b72224b70 "i2c: omap: ack IRQ in parts".

CC: Kevin Hilman <khilman@linaro.org>
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/i2c/busses/i2c-omap.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
index 2dac598..46fb8a5 100644
--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -938,17 +938,15 @@ omap_i2c_isr_thread(int this_irq, void *dev_id)
 			break;
 		}
 
+		omap_i2c_ack_stat(dev, OMAP_I2C_STAT_NACK | OMAP_I2C_STAT_AL);
+
 		if (stat & OMAP_I2C_STAT_NACK) {
 			err |= OMAP_I2C_STAT_NACK;
-			omap_i2c_ack_stat(dev, OMAP_I2C_STAT_NACK);
-			break;
 		}
 
 		if (stat & OMAP_I2C_STAT_AL) {
 			dev_err(dev->dev, "Arbitration lost\n");
 			err |= OMAP_I2C_STAT_AL;
-			omap_i2c_ack_stat(dev, OMAP_I2C_STAT_AL);
-			break;
 		}
 
 		/*
-- 
1.7.9.5

