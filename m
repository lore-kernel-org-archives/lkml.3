Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757434AbaKTKD2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 05:03:28 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:60070 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757318AbaKTKDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 05:03:24 -0500
From: Grygorii Strashko <grygorii.strashko@ti.com>
To: Wolfram Sang <wsa@the-dreams.de>
CC: <linux-i2c@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Sekhar Nori <nsekhar@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>
Subject: [PATCH 2/5] i2c: davinci: query STP always when NACK is received
Date: Thu, 20 Nov 2014 12:03:05 +0200
Message-ID: <1416477788-5544-3-git-send-email-grygorii.strashko@ti.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1416477788-5544-1-git-send-email-grygorii.strashko@ti.com>
References: <1416477788-5544-1-git-send-email-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to I2C specification the NACK should be handled as folowing:
"When SDA remains HIGH during this ninth clock pulse, this is defined as the Not
Acknowledge signal. The master can then gene rate either a STOP condition to
abort the transfer, or a repeated START condition to start a new transfer."
[http://www.nxp.com/documents/user_manual/UM10204.pdf]

The same is recomened by TI I2C wiki:
 http://processors.wiki.ti.com/index.php/I2C_Tips

Currently, the Davinci I2C driver interrupts I2C trunsfer in case of NACK, but
It queries Stop condition DAVINCI_I2C_MDR_REG.STP=1 only if NACK has been received
during the last message transmitting/recieving.
This may lead to Bus stuck in "Bus Busy" until I2C IP reset (idle/enable) if
during SMBus reading transaction the first I2C message is NACKed.

Hence, fix it by querying Stop condition (STP) always when NACK is received.

This patch fixes Davinci I2C in the same way it was done for OMAP I2C
commit cda2109a26eb ("i2c: omap: query STP always when NACK is received").

More info can be found at:
https://lkml.org/lkml/2013/7/16/159
http://patchwork.ozlabs.org/patch/249790/

CC: Sekhar Nori <nsekhar@ti.com>
CC: Kevin Hilman <khilman@deeprootsystems.com>
CC: Santosh Shilimkar <ssantosh@kernel.org>
CC: Murali Karicheri <m-karicheri2@ti.com>
Reported-by: Hein Tibosch <hein_tibosch@yahoo.es>
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
---
 drivers/i2c/busses/i2c-davinci.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/i2c/busses/i2c-davinci.c b/drivers/i2c/busses/i2c-davinci.c
index 9bbfb8f..2cef115 100644
--- a/drivers/i2c/busses/i2c-davinci.c
+++ b/drivers/i2c/busses/i2c-davinci.c
@@ -411,11 +411,9 @@ i2c_davinci_xfer_msg(struct i2c_adapter *adap, struct i2c_msg *msg, int stop)
 	if (dev->cmd_err & DAVINCI_I2C_STR_NACK) {
 		if (msg->flags & I2C_M_IGNORE_NAK)
 			return msg->len;
-		if (stop) {
-			w = davinci_i2c_read_reg(dev, DAVINCI_I2C_MDR_REG);
-			w |= DAVINCI_I2C_MDR_STP;
-			davinci_i2c_write_reg(dev, DAVINCI_I2C_MDR_REG, w);
-		}
+		w = davinci_i2c_read_reg(dev, DAVINCI_I2C_MDR_REG);
+		w |= DAVINCI_I2C_MDR_STP;
+		davinci_i2c_write_reg(dev, DAVINCI_I2C_MDR_REG, w);
 		return -EREMOTEIO;
 	}
 	return -EIO;
-- 
1.9.1

