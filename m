Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755579AbaIKMgO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:36:14 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51697 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755480AbaIKMeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:34:09 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Guenter Roeck" <linux@roeck-us.net>,
        "Axel Lin" <axel.lin@ingics.com>, "Jean Delvare" <jdelvare@suse.de>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.434551488@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 018/131] hwmon: (smsc47m192) Fix temperature limit and
 vrm write operations
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

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
[bwh: Backported to 3.2:
 - Driver is not using clamp_val(); keep using SENSORS_LIMIT() for consistency
 - Driver is not using kstrtoul(); make the minimum change to set_vrm() so
   we can validate the value before assigning]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hwmon/smsc47m192.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/hwmon/smsc47m192.c
+++ b/drivers/hwmon/smsc47m192.c
@@ -84,7 +84,7 @@ static inline u8 IN_TO_REG(unsigned long
    REG: 1C/bit, two's complement */
 static inline s8 TEMP_TO_REG(int val)
 {
-	return SENSORS_LIMIT(SCALE(val, 1, 1000), -128000, 127000);
+	return SCALE(SENSORS_LIMIT(val, -128000, 127000), 1, 1000);
 }
 
 static inline int TEMP_FROM_REG(s8 val)
@@ -349,7 +349,13 @@ static ssize_t set_vrm(struct device *de
 		const char *buf, size_t count)
 {
 	struct smsc47m192_data *data = dev_get_drvdata(dev);
-	data->vrm = simple_strtoul(buf, NULL, 10);
+	unsigned long val;
+
+	val = simple_strtoul(buf, NULL, 10);
+	if (val > 255)
+		return -EINVAL;
+ 
+	data->vrm = val;
 	return count;
 }
 static DEVICE_ATTR(vrm, S_IRUGO | S_IWUSR, show_vrm, set_vrm);

