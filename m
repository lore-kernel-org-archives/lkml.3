Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934893AbaGXJ4a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 05:56:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55149 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934780AbaGXJtC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:49:02 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Guenter Roeck <linux@roeck-us.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 110/128] hwmon: (emc2103) Clamp limits instead of bailing out
Date: Thu, 24 Jul 2014 10:45:59 +0100
Message-Id: <1406195177-8656-111-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
References: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

commit f6c2dd20108c35e30e2c1f3c6142d189451a626b upstream.

It is customary to clamp limits instead of bailing out with an error
if a configured limit is out of the range supported by the driver.
This simplifies limit configuration, since the user will not typically
know chip and/or driver specific limits.

Reviewed-by: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
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
1.9.1

