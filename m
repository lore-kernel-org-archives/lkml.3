Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399AbaFWVUT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 17:20:19 -0400
Received: from mail-ve0-f201.google.com ([209.85.128.201]:39980 "EHLO
	mail-ve0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754257AbaFWVUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 17:20:17 -0400
From: Doug Anderson <dianders@chromium.org>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: Lee Jones <lee.jones@linaro.org>, Dave Jones <davej@redhat.com>,
        rspangler@chromium.org, sjg@chromium.org,
        Doug Anderson <dianders@chromium.org>, sameo@linux.intel.com,
        wfrichar@chromium.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] i2c: cros_ec: Remove EC_I2C_FLAG_10BIT
Date: Mon, 23 Jun 2014 14:20:06 -0700
Message-Id: <1403558406-14519-1-git-send-email-dianders@chromium.org>
X-Mailer: git-send-email 2.0.0.526.g5318336
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In <https://lkml.org/lkml/2014/6/10/265> pointed out that the 10-bit
flag in the cros_ec_tunnel was useless.  It went into a 16-bit flags
field but was defined at (1 << 16).

Since we have no 10-bit i2c devices on the other side of the tunnel on
any known devices this was never a problem.  Until we do it makes
sense to remove this code.  On the EC side the code to handle this
flag was removed in <https://chromium-review.googlesource.com/204162>.

Reported-by: Dave Jones <davej@redhat.com>
Signed-off-by: Doug Anderson <dianders@chromium.org>
---
Note that this patch is based atop my current series of posts to
cleanup cros_ec.  It wouldn't be hard to apply it to the current ToT
if someone wants to land this before the others.

 drivers/i2c/busses/i2c-cros-ec-tunnel.c | 6 ++++--
 include/linux/mfd/cros_ec_commands.h    | 3 ---
 2 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/i2c/busses/i2c-cros-ec-tunnel.c b/drivers/i2c/busses/i2c-cros-ec-tunnel.c
index 05e033c..6d7d009 100644
--- a/drivers/i2c/busses/i2c-cros-ec-tunnel.c
+++ b/drivers/i2c/busses/i2c-cros-ec-tunnel.c
@@ -94,7 +94,7 @@ static int ec_i2c_construct_message(u8 *buf, const struct i2c_msg i2c_msgs[],
 		msg->addr_flags = i2c_msg->addr;
 
 		if (i2c_msg->flags & I2C_M_TEN)
-			msg->addr_flags |= EC_I2C_FLAG_10BIT;
+			return -EINVAL;
 
 		if (i2c_msg->flags & I2C_M_RD) {
 			msg->addr_flags |= EC_I2C_FLAG_READ;
@@ -218,7 +218,9 @@ static int ec_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg i2c_msgs[],
 		}
 	}
 
-	ec_i2c_construct_message(request, i2c_msgs, num, bus_num);
+	result = ec_i2c_construct_message(request, i2c_msgs, num, bus_num);
+	if (result)
+		goto exit;
 
 	msg.version = 0;
 	msg.command = EC_CMD_I2C_PASSTHRU;
diff --git a/include/linux/mfd/cros_ec_commands.h b/include/linux/mfd/cros_ec_commands.h
index 7853a64..a49cd41 100644
--- a/include/linux/mfd/cros_ec_commands.h
+++ b/include/linux/mfd/cros_ec_commands.h
@@ -1928,9 +1928,6 @@ struct ec_response_power_info {
 
 #define EC_CMD_I2C_PASSTHRU 0x9e
 
-/* Slave address is 10 (not 7) bit */
-#define EC_I2C_FLAG_10BIT	(1 << 16)
-
 /* Read data; if not present, message is a write */
 #define EC_I2C_FLAG_READ	(1 << 15)
 
-- 
2.0.0.526.g5318336

