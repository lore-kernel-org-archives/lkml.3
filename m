Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967216AbaFQWPi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 18:15:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54549 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966765AbaFQVvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:51:14 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Wolfram Sang <wsa@the-dreams.de>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 119/212] i2c: rcar: bail out on zero length transfers
Date: Tue, 17 Jun 2014 14:43:33 -0700
Message-Id: <1403041506-13646-120-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

commit d7653964c590ba846aa11a8f6edf409773cbc492 upstream.

This hardware does not support zero length transfers. Instead, the
driver does one (random) byte transfers currently with undefined results
for the slaves. We now bail out.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/i2c/busses/i2c-rcar.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-rcar.c b/drivers/i2c/busses/i2c-rcar.c
index 2c2fd7c..56de337 100644
--- a/drivers/i2c/busses/i2c-rcar.c
+++ b/drivers/i2c/busses/i2c-rcar.c
@@ -567,6 +567,12 @@ static int rcar_i2c_master_xfer(struct i2c_adapter *adap,
 
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
 
@@ -631,7 +637,8 @@ static int rcar_i2c_master_xfer(struct i2c_adapter *adap,
 
 static u32 rcar_i2c_func(struct i2c_adapter *adap)
 {
-	return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL;
+	/* This HW can't do SMBUS_QUICK and NOSTART */
+	return I2C_FUNC_I2C | (I2C_FUNC_SMBUS_EMUL & ~I2C_FUNC_SMBUS_QUICK);
 }
 
 static const struct i2c_algorithm rcar_i2c_algo = {
-- 
1.9.1

