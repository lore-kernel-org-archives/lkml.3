Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757605AbaHHUpY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:45:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40345 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757497AbaHHUpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:45:14 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Axel Lin <axel.lin@ingics.com>, Guenter Roeck <linux@roeck-us.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 173/259] hwmon: (smsc47m192) Fix temperature limit and vrm write operations
Date: Fri,  8 Aug 2014 13:39:56 -0700
Message-Id: <1407530482-4483-174-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/hwmon/smsc47m192.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/smsc47m192.c b/drivers/hwmon/smsc47m192.c
index efee4c5..34b9a60 100644
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
1.9.1

