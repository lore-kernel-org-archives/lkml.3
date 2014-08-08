Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933284AbaHHVVs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 17:21:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40935 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932402AbaHHUvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:51:08 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Axel Lin <axel.lin@ingics.com>, Guenter Roeck <linux@roeck-us.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 065/259] hwmon: (adm1021) Fix cache problem when writing temperature limits
Date: Fri,  8 Aug 2014 13:38:08 -0700
Message-Id: <1407530482-4483-66-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Axel Lin <axel.lin@ingics.com>

commit c024044d4da2c9c3b32933b4235df1e409293b84 upstream.

The module test script for the adm1021 driver exposes a cache problem
when writing temperature limits. temp_min and temp_max are expected
to be stored in milli-degrees C but are stored in degrees C.

Reported-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Axel Lin <axel.lin@ingics.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/hwmon/adm1021.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/hwmon/adm1021.c b/drivers/hwmon/adm1021.c
index 29dd9f7..233b374 100644
--- a/drivers/hwmon/adm1021.c
+++ b/drivers/hwmon/adm1021.c
@@ -185,7 +185,7 @@ static ssize_t set_temp_max(struct device *dev,
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adm1021_data *data = i2c_get_clientdata(client);
 	long temp;
-	int err;
+	int reg_val, err;
 
 	err = kstrtol(buf, 10, &temp);
 	if (err)
@@ -193,10 +193,11 @@ static ssize_t set_temp_max(struct device *dev,
 	temp /= 1000;
 
 	mutex_lock(&data->update_lock);
-	data->temp_max[index] = clamp_val(temp, -128, 127);
+	reg_val = clamp_val(temp, -128, 127);
+	data->temp_max[index] = reg_val * 1000;
 	if (!read_only)
 		i2c_smbus_write_byte_data(client, ADM1021_REG_TOS_W(index),
-					  data->temp_max[index]);
+					  reg_val);
 	mutex_unlock(&data->update_lock);
 
 	return count;
@@ -210,7 +211,7 @@ static ssize_t set_temp_min(struct device *dev,
 	struct i2c_client *client = to_i2c_client(dev);
 	struct adm1021_data *data = i2c_get_clientdata(client);
 	long temp;
-	int err;
+	int reg_val, err;
 
 	err = kstrtol(buf, 10, &temp);
 	if (err)
@@ -218,10 +219,11 @@ static ssize_t set_temp_min(struct device *dev,
 	temp /= 1000;
 
 	mutex_lock(&data->update_lock);
-	data->temp_min[index] = clamp_val(temp, -128, 127);
+	reg_val = clamp_val(temp, -128, 127);
+	data->temp_min[index] = reg_val * 1000;
 	if (!read_only)
 		i2c_smbus_write_byte_data(client, ADM1021_REG_THYST_W(index),
-					  data->temp_min[index]);
+					  reg_val);
 	mutex_unlock(&data->update_lock);
 
 	return count;
-- 
1.9.1

