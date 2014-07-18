Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030903AbaGRNSy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:18:54 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17989 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1030582AbaGRNSu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:18:50 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 137/170] hwmon: (emc2103) Clamp limits instead of bailing out
Date: Fri, 18 Jul 2014 14:12:22 +0200
Message-Id: <cd4da31a80bd9e3b71a62af0029de98897f38171.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit f6c2dd20108c35e30e2c1f3c6142d189451a626b upstream.

It is customary to clamp limits instead of bailing out with an error
if a configured limit is out of the range supported by the driver.
This simplifies limit configuration, since the user will not typically
know chip and/or driver specific limits.

Reviewed-by: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/hwmon/emc2103.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/drivers/hwmon/emc2103.c b/drivers/hwmon/emc2103.c
index 2c137b26acb4..5790246a7e1d 100644
--- a/drivers/hwmon/emc2103.c
+++ b/drivers/hwmon/emc2103.c
@@ -250,9 +250,7 @@ static ssize_t set_temp_min(struct device *dev, struct device_attribute *da,
 	if (result < 0)
 		return result;
 
-	val = DIV_ROUND_CLOSEST(val, 1000);
-	if ((val < -63) || (val > 127))
-		return -EINVAL;
+	val = clamp_val(DIV_ROUND_CLOSEST(val, 1000), -63, 127);
 
 	mutex_lock(&data->update_lock);
 	data->temp_min[nr] = val;
@@ -274,9 +272,7 @@ static ssize_t set_temp_max(struct device *dev, struct device_attribute *da,
 	if (result < 0)
 		return result;
 
-	val = DIV_ROUND_CLOSEST(val, 1000);
-	if ((val < -63) || (val > 127))
-		return -EINVAL;
+	val = clamp_val(DIV_ROUND_CLOSEST(val, 1000), -63, 127);
 
 	mutex_lock(&data->update_lock);
 	data->temp_max[nr] = val;
@@ -390,15 +386,14 @@ static ssize_t set_fan_target(struct device *dev, struct device_attribute *da,
 {
 	struct emc2103_data *data = emc2103_update_device(dev);
 	struct i2c_client *client = to_i2c_client(dev);
-	long rpm_target;
+	unsigned long rpm_target;
 
-	int result = kstrtol(buf, 10, &rpm_target);
+	int result = kstrtoul(buf, 10, &rpm_target);
 	if (result < 0)
 		return result;
 
 	/* Datasheet states 16384 as maximum RPM target (table 3.2) */
-	if ((rpm_target < 0) || (rpm_target > 16384))
-		return -EINVAL;
+	rpm_target = clamp_val(rpm_target, 0, 16384);
 
 	mutex_lock(&data->update_lock);
 
-- 
2.0.0

