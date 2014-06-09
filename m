Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936413AbaFIJln (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 05:41:43 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59137 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755712AbaFIJ0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 05:26:24 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Wolfram Sang <wsa@the-dreams.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 130/146] i2c: rcar: bail out on zero length transfers
Date: Mon,  9 Jun 2014 10:51:05 +0200
Message-Id: <150864f49748bb66b7dda0cb9d5e036e745e088e.1402303821.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
References: <ebe219e45dcf94c1a34281167427cff4d742faef.1402303820.git.jslaby@suse.cz>
In-Reply-To: <cover.1402303820.git.jslaby@suse.cz>
References: <cover.1402303820.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit d7653964c590ba846aa11a8f6edf409773cbc492 upstream.

This hardware does not support zero length transfers. Instead, the
driver does one (random) byte transfers currently with undefined results
for the slaves. We now bail out.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/i2c/busses/i2c-rcar.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-rcar.c b/drivers/i2c/busses/i2c-rcar.c
index d2fe11da5e82..c8a42602205b 100644
--- a/drivers/i2c/busses/i2c-rcar.c
+++ b/drivers/i2c/busses/i2c-rcar.c
@@ -560,6 +560,12 @@ static int rcar_i2c_master_xfer(struct i2c_adapter *adap,
 
 	ret = -EINVAL;
 	for (i = 0; i < num; i++) {
+		/* This HW can't send STOP after address phase */
+		if (msgs[i].len == 0) {
+			ret = -EOPNOTSUPP;
+			break;
+		}
+
 		/*-------------- spin lock -----------------*/
 		spin_lock_irqsave(&priv->lock, flags);
 
@@ -624,7 +630,8 @@ static int rcar_i2c_master_xfer(struct i2c_adapter *adap,
 
 static u32 rcar_i2c_func(struct i2c_adapter *adap)
 {
-	return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL;
+	/* This HW can't do SMBUS_QUICK and NOSTART */
+	return I2C_FUNC_I2C | (I2C_FUNC_SMBUS_EMUL & ~I2C_FUNC_SMBUS_QUICK);
 }
 
 static const struct i2c_algorithm rcar_i2c_algo = {
-- 
1.9.3

