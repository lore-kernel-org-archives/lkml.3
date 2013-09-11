Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503Ab3IKFnx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 01:43:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:22176 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434Ab3IKE5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 00:57:11 -0400
X-Authority-Analysis: v=2.0 cv=V4T/IJbi c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=Tp_39xzQ4O4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=PKFiNyLHrtgA:10 a=CDq0vqnqAAAA:8 a=VwQbUJbxAAAA:8 a=_jlGtV7tAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=MsgQWG-0GjQA:10 a=L1RTw_NLzc0A:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130911042920.638727355@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 11 Sep 2013 00:29:57 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Curt Brune <curt@cumulusnetworks.com>, Guenter Roeck <linux@roeck-us.net>
Subject: [170/251] hwmon: (adt7470) Fix incorrect return code check
References: <20130911042707.738353451@goodmis.org>
Content-Disposition: inline; filename=0170-hwmon-adt7470-Fix-incorrect-return-code-check.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.9-rc1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Curt Brune <curt@cumulusnetworks.com>

[ Upstream commit 93d783bcca69bfacc8dc739d8a050498402587b5 ]

In adt7470_write_word_data(), which writes two bytes using
i2c_smbus_write_byte_data(), the return codes are incorrectly AND-ed
together when they should be OR-ed together.

The return code of i2c_smbus_write_byte_data() is zero for success.

The upshot is only the first byte was ever written to the hardware.
The 2nd byte was never written out.

I noticed that trying to set the fan speed limits was not working
correctly on my system.  Setting the fan speed limits is the only
code that uses adt7470_write_word_data().  After making the change
the limit settings work and the alarms work also.

Signed-off-by: Curt Brune <curt@cumulusnetworks.com>
Cc: stable@vger.kernel.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/hwmon/adt7470.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/adt7470.c b/drivers/hwmon/adt7470.c
index 54ec8905..034085d 100644
--- a/drivers/hwmon/adt7470.c
+++ b/drivers/hwmon/adt7470.c
@@ -215,7 +215,7 @@ static inline int adt7470_write_word_data(struct i2c_client *client, u8 reg,
 					  u16 value)
 {
 	return i2c_smbus_write_byte_data(client, reg, value & 0xFF)
-	       && i2c_smbus_write_byte_data(client, reg + 1, value >> 8);
+	       || i2c_smbus_write_byte_data(client, reg + 1, value >> 8);
 }
 
 static void adt7470_init_client(struct i2c_client *client)
-- 
1.7.10.4


