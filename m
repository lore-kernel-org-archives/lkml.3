Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534AbaHDQ7O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 12:59:14 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56572 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752019AbaHDQt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:49:56 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Guenter Roeck" <linux@roeck-us.net>,
        "Jean Delvare" <jdelvare@suse.de>
Date: Mon, 04 Aug 2014 17:48:32 +0100
Message-ID: <lsq.1407170912.757421271@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 41/94] hwmon: (emc2103) Clamp limits instead of
 bailing out
In-Reply-To: <lsq.1407170911.107020799@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.62-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

commit f6c2dd20108c35e30e2c1f3c6142d189451a626b upstream.

It is customary to clamp limits instead of bailing out with an error
if a configured limit is out of the range supported by the driver.
This simplifies limit configuration, since the user will not typically
know chip and/or driver specific limits.

Reviewed-by: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hwmon/emc2103.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

--- a/drivers/hwmon/emc2103.c
+++ b/drivers/hwmon/emc2103.c
@@ -248,9 +248,7 @@ static ssize_t set_temp_min(struct devic
 	if (result < 0)
 		return -EINVAL;
 
-	val = DIV_ROUND_CLOSEST(val, 1000);
-	if ((val < -63) || (val > 127))
-		return -EINVAL;
+	val = clamp_val(DIV_ROUND_CLOSEST(val, 1000), -63, 127);
 
 	mutex_lock(&data->update_lock);
 	data->temp_min[nr] = val;
@@ -272,9 +270,7 @@ static ssize_t set_temp_max(struct devic
 	if (result < 0)
 		return -EINVAL;
 
-	val = DIV_ROUND_CLOSEST(val, 1000);
-	if ((val < -63) || (val > 127))
-		return -EINVAL;
+	val = clamp_val(DIV_ROUND_CLOSEST(val, 1000), -63, 127);
 
 	mutex_lock(&data->update_lock);
 	data->temp_max[nr] = val;
@@ -386,15 +382,14 @@ static ssize_t set_fan_target(struct dev
 {
 	struct emc2103_data *data = emc2103_update_device(dev);
 	struct i2c_client *client = to_i2c_client(dev);
-	long rpm_target;
+	unsigned long rpm_target;
 
-	int result = strict_strtol(buf, 10, &rpm_target);
+	int result = kstrtoul(buf, 10, &rpm_target);
 	if (result < 0)
 		return -EINVAL;
 
 	/* Datasheet states 16384 as maximum RPM target (table 3.2) */
-	if ((rpm_target < 0) || (rpm_target > 16384))
-		return -EINVAL;
+	rpm_target = clamp_val(rpm_target, 0, 16384);
 
 	mutex_lock(&data->update_lock);
 

