Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757989AbaGXKBE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 06:01:04 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55074 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934661AbaGXJsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:48:41 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Axel Lin <axel.lin@ingics.com>, Guenter Roeck <linux@roeck-us.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 095/128] hwmon: (adm1021) Fix cache problem when writing temperature limits
Date: Thu, 24 Jul 2014 10:45:44 +0100
Message-Id: <1406195177-8656-96-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
References: <1406195177-8656-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Axel Lin <axel.lin@ingics.com>

commit c024044d4da2c9c3b32933b4235df1e409293b84 upstream.

The module test script for the adm1021 driver exposes a cache problem
when writing temperature limits. temp_min and temp_max are expected
to be stored in milli-degrees C but are stored in degrees C.

Reported-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Axel Lin <axel.lin@ingics.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/hwmon/adm1021.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/drivers/hwmon/adm1021.c b/drivers/hwmon/adm1021.c
index 29dd9f746dfa..233b374334ed 100644
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

