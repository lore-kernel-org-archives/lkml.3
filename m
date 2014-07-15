Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964957AbaGOXPD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 19:15:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45334 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932930AbaGOXOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 19:14:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jean Delvare <jdelvare@suse.de>, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 3.15 18/84] hwmon: (emc2103) Clamp limits instead of bailing out
Date: Tue, 15 Jul 2014 16:17:15 -0700
Message-Id: <20140715231713.741959574@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.254.g50f84e3
In-Reply-To: <20140715231713.193785557@linuxfoundation.org>
References: <20140715231713.193785557@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

commit f6c2dd20108c35e30e2c1f3c6142d189451a626b upstream.

It is customary to clamp limits instead of bailing out with an error
if a configured limit is out of the range supported by the driver.
This simplifies limit configuration, since the user will not typically
know chip and/or driver specific limits.

Reviewed-by: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/emc2103.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

--- a/drivers/hwmon/emc2103.c
+++ b/drivers/hwmon/emc2103.c
@@ -250,9 +250,7 @@ static ssize_t set_temp_min(struct devic
 	if (result < 0)
 		return result;
 
-	val = DIV_ROUND_CLOSEST(val, 1000);
-	if ((val < -63) || (val > 127))
-		return -EINVAL;
+	val = clamp_val(DIV_ROUND_CLOSEST(val, 1000), -63, 127);
 
 	mutex_lock(&data->update_lock);
 	data->temp_min[nr] = val;
@@ -274,9 +272,7 @@ static ssize_t set_temp_max(struct devic
 	if (result < 0)
 		return result;
 
-	val = DIV_ROUND_CLOSEST(val, 1000);
-	if ((val < -63) || (val > 127))
-		return -EINVAL;
+	val = clamp_val(DIV_ROUND_CLOSEST(val, 1000), -63, 127);
 
 	mutex_lock(&data->update_lock);
 	data->temp_max[nr] = val;
@@ -390,15 +386,14 @@ static ssize_t set_fan_target(struct dev
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
 


