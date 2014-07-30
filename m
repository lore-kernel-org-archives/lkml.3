Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827AbaG3MUQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:20:16 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:36798 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753040AbaG3MPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:15:34 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Axel Lin <axel.lin@ingics.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 89/94] hwmon: (smsc47m192) Fix temperature limit and vrm write operations
Date: Wed, 30 Jul 2014 14:15:18 +0200
Message-Id: <4ca87389ee7c016ce1339e937b7d0c270426a530.1406722270.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
References: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
In-Reply-To: <cover.1406722269.git.jslaby@suse.cz>
References: <cover.1406722269.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 043572d5444116b9d9ad8ae763cf069e7accbc30 upstream.

Temperature limit clamps are applied after converting the temperature
from milli-degrees C to degrees C, so either the clamp limit needs
to be specified in degrees C, not milli-degrees C, or clamping must
happen before converting to degrees C. Use the latter method to avoid
overflows.

vrm is an u8, so the written value needs to be limited to [0, 255].

Cc: Axel Lin <axel.lin@ingics.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/hwmon/smsc47m192.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/smsc47m192.c b/drivers/hwmon/smsc47m192.c
index efee4c59239f..34b9a601ad07 100644
--- a/drivers/hwmon/smsc47m192.c
+++ b/drivers/hwmon/smsc47m192.c
@@ -86,7 +86,7 @@ static inline u8 IN_TO_REG(unsigned long val, int n)
  */
 static inline s8 TEMP_TO_REG(int val)
 {
-	return clamp_val(SCALE(val, 1, 1000), -128000, 127000);
+	return SCALE(clamp_val(val, -128000, 127000), 1, 1000);
 }
 
 static inline int TEMP_FROM_REG(s8 val)
@@ -384,6 +384,8 @@ static ssize_t set_vrm(struct device *dev, struct device_attribute *attr,
 	err = kstrtoul(buf, 10, &val);
 	if (err)
 		return err;
+	if (val > 255)
+		return -EINVAL;
 
 	data->vrm = val;
 	return count;
-- 
2.0.1

