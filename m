Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202AbaHDRCW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 13:02:22 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56545 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751996AbaHDQt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 12:49:56 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Jean Delvare" <jdelvare@suse.de>,
        "Axel Lin" <axel.lin@ingics.com>, "Guenter Roeck" <linux@roeck-us.net>
Date: Mon, 04 Aug 2014 17:48:32 +0100
Message-ID: <lsq.1407170912.508446849@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 38/94] hwmon: (adm1031) Fix writes to limit registers
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

commit 145e74a4e5022225adb84f4e5d4fff7938475c35 upstream.

Upper limit for write operations to temperature limit registers
was clamped to a fractional value. However, limit registers do
not support fractional values. As a result, upper limits of 127.5
degrees C or higher resulted in a rounded limit of 128 degrees C.
Since limit registers are signed, this was stored as -128 degrees C.
Clamp limits to (-55, +127) degrees C to solve the problem.

Value on writes to auto_temp[12]_min and auto_temp[12]_max were not
clamped at all, but masked. As a result, out-of-range writes resulted
in a more or less arbitrary limit. Clamp those attributes to (0, 127)
degrees C for more predictable results.

Cc: Axel Lin <axel.lin@ingics.com>
Reviewed-by: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
[bwh: Backported to 3.2:
 - Adjust context
 - Driver was using SENSORS_LIMIT(), which we can replace with clamp_val()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/hwmon/adm1031.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/hwmon/adm1031.c
+++ b/drivers/hwmon/adm1031.c
@@ -352,6 +352,7 @@ set_auto_temp_min(struct device *dev, st
 	int nr = to_sensor_dev_attr(attr)->index;
 	int val = simple_strtol(buf, NULL, 10);
 
+	val = clamp_val(val, 0, 127000);
 	mutex_lock(&data->update_lock);
 	data->auto_temp[nr] = AUTO_TEMP_MIN_TO_REG(val, data->auto_temp[nr]);
 	adm1031_write_value(client, ADM1031_REG_AUTO_TEMP(nr),
@@ -376,6 +377,7 @@ set_auto_temp_max(struct device *dev, st
 	int nr = to_sensor_dev_attr(attr)->index;
 	int val = simple_strtol(buf, NULL, 10);
 
+	val = clamp_val(val, 0, 127000);
 	mutex_lock(&data->update_lock);
 	data->temp_max[nr] = AUTO_TEMP_MAX_TO_REG(val, data->auto_temp[nr], data->pwm[nr]);
 	adm1031_write_value(client, ADM1031_REG_AUTO_TEMP(nr),
@@ -651,7 +653,7 @@ static ssize_t set_temp_min(struct devic
 	int val;
 
 	val = simple_strtol(buf, NULL, 10);
-	val = SENSORS_LIMIT(val, -55000, nr == 0 ? 127750 : 127875);
+	val = clamp_val(val, -55000, 127000);
 	mutex_lock(&data->update_lock);
 	data->temp_min[nr] = TEMP_TO_REG(val);
 	adm1031_write_value(client, ADM1031_REG_TEMP_MIN(nr),
@@ -668,7 +670,7 @@ static ssize_t set_temp_max(struct devic
 	int val;
 
 	val = simple_strtol(buf, NULL, 10);
-	val = SENSORS_LIMIT(val, -55000, nr == 0 ? 127750 : 127875);
+	val = clamp_val(val, -55000, 127000);
 	mutex_lock(&data->update_lock);
 	data->temp_max[nr] = TEMP_TO_REG(val);
 	adm1031_write_value(client, ADM1031_REG_TEMP_MAX(nr),
@@ -685,7 +687,7 @@ static ssize_t set_temp_crit(struct devi
 	int val;
 
 	val = simple_strtol(buf, NULL, 10);
-	val = SENSORS_LIMIT(val, -55000, nr == 0 ? 127750 : 127875);
+	val = clamp_val(val, -55000, 127000);
 	mutex_lock(&data->update_lock);
 	data->temp_crit[nr] = TEMP_TO_REG(val);
 	adm1031_write_value(client, ADM1031_REG_TEMP_CRIT(nr),

