Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845Ab3GPJA1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 05:00:27 -0400
Received: from bosmailout15.eigbox.net ([66.96.189.15]:57921 "EHLO
	bosmailout15.eigbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753351Ab3GPJAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 05:00:24 -0400
X-Greylist: delayed 2375 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Jul 2013 05:00:24 EDT
X-Authority-Analysis: v=2.0 cv=bNyU0YCZ c=1 sm=1
 a=mze3Iowvsrioyt7kijtP+A==:17 a=bc2JKO6qiGsA:10 a=FB6NmUnAAagA:10
 a=B3vY_oGMVIEA:10 a=8nJEP1OIZ-IA:10 a=SX4JDKmJlWIA:10
 a=bJ0fqD8TFZgqkSadqForXVIPBlU=:19 a=-FMTLKQb-XPAEF5nkOAA:9 a=wPNLvfGTeEIA:10
 a=fIc3/5IyPUehxkj7BpkQ7Q==:117
X-EN-OrigOutIP: 10.20.18.6
X-EN-IMPSID: 0w7g1m00107rX7u01w7g0K
Message-ID: <51E50217.1000507@yahoo.es>
Date: Tue, 16 Jul 2013 16:19:35 +0800
From: Hein Tibosch <hein_tibosch@yahoo.es>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Vikram Pandita <vikram.pandita@ti.com>,
        Shubhrajyoti D <shubhrajyoti@ti.com>, Tony Lindgren <tony@atomide.com>
CC: linux-i2c <linux-i2c@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] i2c-omap: always send stop after nack
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-EN-UserInfo: 3946c951b80c12a8be5482963a0b1232:e0ae43bc192b431f8b69f09a37527cbc
X-EN-AuthUser: hein@htibosch.net
X-EN-OrigIP: 114.79.57.227
X-EN-OrigHost: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vikram,

On a OMAP4460, i2c-bus-3:

A driver (lm75) is causing many 'timeout waiting for bus ready' errors.
SDA remains high (as it should), but SCL remains low after a NACK.
The bus becomes _unusable for other clients_.

While probing, "lm75" writes a command, followed by a read + stop,
but the write command is NACK'd. The chip does accept other writes/reads,
it just refuses to ack invalid commands.

Can you tell me if the patch below would make any sense? Or is it the
responsibility of the client to reset the i2c_smbus?

In case of M_IGNORE_NAK there is no problem, a STOP will follow after the
last command.


Thanks, Hein

Signed-off-by: Hein Tibosch <hein_tibosch@yahoo.es>

---
 drivers/i2c/busses/i2c-omap.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
index e02f9e3..2f7a712 100644
--- a/drivers/i2c/busses/i2c-omap.c
+++ b/drivers/i2c/busses/i2c-omap.c
@@ -615,11 +615,9 @@ static int omap_i2c_xfer_msg(struct i2c_adapter *adap,
 	if (dev->cmd_err & OMAP_I2C_STAT_NACK) {
 		if (msg->flags & I2C_M_IGNORE_NAK)
 			return 0;
-		if (stop) {
-			w = omap_i2c_read_reg(dev, OMAP_I2C_CON_REG);
-			w |= OMAP_I2C_CON_STP;
-			omap_i2c_write_reg(dev, OMAP_I2C_CON_REG, w);
-		}
+		w = omap_i2c_read_reg(dev, OMAP_I2C_CON_REG);
+		w |= OMAP_I2C_CON_STP;
+		omap_i2c_write_reg(dev, OMAP_I2C_CON_REG, w);
 		return -EREMOTEIO;
 	}
 	return -EIO;
-- 
1.7.9.5


