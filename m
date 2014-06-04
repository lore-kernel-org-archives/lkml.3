Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411AbaFDXZt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 19:25:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41079 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754219AbaFDXYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 19:24:24 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Wolfram Sang <wsa@the-dreams.de>
Subject: [PATCH 3.10 093/103] i2c: rcar: bail out on zero length transfers
Date: Wed,  4 Jun 2014 16:25:56 -0700
Message-Id: <20140604232549.855619671@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140604232546.704156131@linuxfoundation.org>
References: <20140604232546.704156131@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

commit d7653964c590ba846aa11a8f6edf409773cbc492 upstream.

This hardware does not support zero length transfers. Instead, the
driver does one (random) byte transfers currently with undefined results
for the slaves. We now bail out.

Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Signed-off-by: Wolfram Sang <wsa@the-dreams.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/busses/i2c-rcar.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/i2c/busses/i2c-rcar.c
+++ b/drivers/i2c/busses/i2c-rcar.c
@@ -541,6 +541,12 @@ static int rcar_i2c_master_xfer(struct i
 
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
 
@@ -605,7 +611,8 @@ static int rcar_i2c_master_xfer(struct i
 
 static u32 rcar_i2c_func(struct i2c_adapter *adap)
 {
-	return I2C_FUNC_I2C | I2C_FUNC_SMBUS_EMUL;
+	/* This HW can't do SMBUS_QUICK and NOSTART */
+	return I2C_FUNC_I2C | (I2C_FUNC_SMBUS_EMUL & ~I2C_FUNC_SMBUS_QUICK);
 }
 
 static const struct i2c_algorithm rcar_i2c_algo = {


