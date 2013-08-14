Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932693Ab3HNKlY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 06:41:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:34721 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932444Ab3HNKib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 06:38:31 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Curt Brune <curt@cumulusnetworks.com>, Guenter Roeck <linux@roeck-us.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 69/75] hwmon: (adt7470) Fix incorrect return code check
Date: Wed, 14 Aug 2013 11:36:58 +0100
Message-Id: <1376476624-10011-70-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
References: <1376476624-10011-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.19 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Curt Brune <curt@cumulusnetworks.com>

commit 93d783bcca69bfacc8dc739d8a050498402587b5 upstream.

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
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/hwmon/adt7470.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/adt7470.c b/drivers/hwmon/adt7470.c
index 54ec890..034085d 100644
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
1.8.3.2

