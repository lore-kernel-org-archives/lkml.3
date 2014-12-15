Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492AbaLOOei (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:34:38 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38974 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860AbaLOO3N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:29:13 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Grygorii Strashko <grygorii.strashko@ti.com>,
        Wolfram Sang <wsa@the-dreams.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 149/168] i2c: davinci: generate STP always when NACK is received
Date: Mon, 15 Dec 2014 14:26:43 +0000
Message-Id: <1418653622-21105-150-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Grygorii Strashko <grygorii.strashko@ti.com>

commit 9ea359f7314132cbcb5a502d2d8ef095be1f45e4 upstream.

According to I2C specification the NACK should be handled as follows:
"When SDA remains HIGH during this ninth clock pulse, this is defined as the Not
Acknowledge signal. The master can then generate either a STOP condition to
abort the transfer, or a repeated START condition to start a new transfer."
[I2C spec Rev. 6, 3.1.6: http://www.nxp.com/documents/user_manual/UM10204.pdf]

Currently the Davinci i2c driver interrupts the transfer on receipt of a
NACK but fails to send a STOP in some situations and so makes the bus
stuck until next I2C IP reset (idle/enable).

For example, the issue will happen during SMBus read transfer which
consists from two i2c messages write command/address and read data:

S Slave Address Wr A Command Code A Sr Slave Address Rd A D1..Dn A P
<--- write -----------------------> <--- read --------------------->

The I2C client device will send NACK if it can't recognize "Command Code"
and it's expected from I2C master to generate STP in this case.
But now, Davinci i2C driver will just exit with -EREMOTEIO and STP will
not be generated.

Hence, fix it by generating Stop condition (STP) always when NACK is received.

This patch fixes Davinci I2C in the same way it was done for OMAP I2C
commit cda2109a26eb ("i2c: omap: query STP always when NACK is received").

Reviewed-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Reported-by: Hein Tibosch <hein_tibosch@yahoo.es>
Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/i2c/busses/i2c-davinci.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/i2c/busses/i2c-davinci.c b/drivers/i2c/busses/i2c-davinci.c
index 389bc68c55ad..831b7df52fd5 100644
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
2.1.3

