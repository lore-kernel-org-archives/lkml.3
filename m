Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934868AbaGXJ5e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 05:57:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55135 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934747AbaGXJs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:48:58 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Axel Lin <axel.lin@ingics.com>, Guenter Roeck <linux@roeck-us.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 107/128] hwmon: (adm1031) Fix writes to limit registers
Date: Thu, 24 Jul 2014 10:45:56 +0100
Message-Id: <1406195177-8656-108-git-send-email-luis.henriques@canonical.com>
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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/hwmon/adm1031.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/hwmon/adm1031.c b/drivers/hwmon/adm1031.c
index 253ea396106d..bdceca0d7e22 100644
--- a/drivers/hwmon/adm1031.c
+++ b/drivers/hwmon/adm1031.c
@@ -365,6 +365,7 @@ set_auto_temp_min(struct device *dev, struct device_attribute *attr,
 	if (ret)
 		return ret;
 
+	val = clamp_val(val, 0, 127000);
 	mutex_lock(&data->update_lock);
 	data->auto_temp[nr] = AUTO_TEMP_MIN_TO_REG(val, data->auto_temp[nr]);
 	adm1031_write_value(client, ADM1031_REG_AUTO_TEMP(nr),
@@ -394,6 +395,7 @@ set_auto_temp_max(struct device *dev, struct device_attribute *attr,
 	if (ret)
 		return ret;
 
+	val = clamp_val(val, 0, 127000);
 	mutex_lock(&data->update_lock);
 	data->temp_max[nr] = AUTO_TEMP_MAX_TO_REG(val, data->auto_temp[nr],
 						  data->pwm[nr]);
@@ -696,7 +698,7 @@ static ssize_t set_temp_min(struct device *dev, struct device_attribute *attr,
 	if (ret)
 		return ret;
 
-	val = clamp_val(val, -55000, nr == 0 ? 127750 : 127875);
+	val = clamp_val(val, -55000, 127000);
 	mutex_lock(&data->update_lock);
 	data->temp_min[nr] = TEMP_TO_REG(val);
 	adm1031_write_value(client, ADM1031_REG_TEMP_MIN(nr),
@@ -717,7 +719,7 @@ static ssize_t set_temp_max(struct device *dev, struct device_attribute *attr,
 	if (ret)
 		return ret;
 
-	val = clamp_val(val, -55000, nr == 0 ? 127750 : 127875);
+	val = clamp_val(val, -55000, 127000);
 	mutex_lock(&data->update_lock);
 	data->temp_max[nr] = TEMP_TO_REG(val);
 	adm1031_write_value(client, ADM1031_REG_TEMP_MAX(nr),
@@ -738,7 +740,7 @@ static ssize_t set_temp_crit(struct device *dev, struct device_attribute *attr,
 	if (ret)
 		return ret;
 
-	val = clamp_val(val, -55000, nr == 0 ? 127750 : 127875);
+	val = clamp_val(val, -55000, 127000);
 	mutex_lock(&data->update_lock);
 	data->temp_crit[nr] = TEMP_TO_REG(val);
 	adm1031_write_value(client, ADM1031_REG_TEMP_CRIT(nr),
-- 
1.9.1

