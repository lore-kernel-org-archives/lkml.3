Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161127AbaGRNwm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:52:42 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17494 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1761196AbaGRNKU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:10:20 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Axel Lin <axel.lin@ingics.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 138/170] hwmon: (adm1031) Fix writes to limit registers
Date: Fri, 18 Jul 2014 14:12:23 +0200
Message-Id: <bf3b6fffb362959d90dde42e69e76fc1c53adedb.1405685481.git.jslaby@suse.cz>
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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
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
2.0.0

