Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746AbbAVWoh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 17:44:37 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:35904 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581AbbAVWog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 17:44:36 -0500
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Jean Delvare <jdelvare@suse.de>, Guenter Roeck <linux@roeck-us.net>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] drivers/hwmon/ad7314.c: Do proper sign extension
Date: Thu, 22 Jan 2015 23:44:13 +0100
Message-Id: <1421966655-16188-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The comment above (data << 2) >> 2 explains what the intention is: To
use bit 13 of the 14-bit value data as the sign bit. However, this
doesn't work due to C's promotion rules. data has type s16, but data
<< 2 has type int. To get sign extension, that expression would have
to be cast back to an s16 before being shifted (at which point C's
promotion rules would then kick in again and promote the left operand
to int). As it stands, both expressions are no-ops for any value of
data.

Avoid these subtleties by using the existing API for
this. sign_extend32 works equally well for 8 and 16 bit types.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/hwmon/ad7314.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/ad7314.c b/drivers/hwmon/ad7314.c
index f4f9b219bf16..11955467fc0f 100644
--- a/drivers/hwmon/ad7314.c
+++ b/drivers/hwmon/ad7314.c
@@ -16,6 +16,7 @@
 #include <linux/err.h>
 #include <linux/hwmon.h>
 #include <linux/hwmon-sysfs.h>
+#include <linux/bitops.h>
 
 /*
  * AD7314 temperature masks
@@ -67,7 +68,7 @@ static ssize_t ad7314_show_temperature(struct device *dev,
 	switch (spi_get_device_id(chip->spi_dev)->driver_data) {
 	case ad7314:
 		data = (ret & AD7314_TEMP_MASK) >> AD7314_TEMP_SHIFT;
-		data = (data << 6) >> 6;
+		data = sign_extend32(data, 9);
 
 		return sprintf(buf, "%d\n", 250 * data);
 	case adt7301:
@@ -78,7 +79,7 @@ static ssize_t ad7314_show_temperature(struct device *dev,
 		 * register.  1lsb - 31.25 milli degrees centigrade
 		 */
 		data = ret & ADT7301_TEMP_MASK;
-		data = (data << 2) >> 2;
+		data = sign_extend32(data, 13);
 
 		return sprintf(buf, "%d\n",
 			       DIV_ROUND_CLOSEST(data * 3125, 100));
-- 
2.1.3

