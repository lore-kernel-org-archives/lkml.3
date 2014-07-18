Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161329AbaGRNY2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:24:28 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:17944 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933858AbaGRNSH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:18:07 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Axel Lin <axel.lin@ingics.com>,
        Guenter Roeck <linux@roeck-us.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 140/170] hwmon: (adm1021) Fix cache problem when writing temperature limits
Date: Fri, 18 Jul 2014 14:12:25 +0200
Message-Id: <62fcc8ffc913bf3a218339cf57d13d76b59661db.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Axel Lin <axel.lin@ingics.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit c024044d4da2c9c3b32933b4235df1e409293b84 upstream.

The module test script for the adm1021 driver exposes a cache problem
when writing temperature limits. temp_min and temp_max are expected
to be stored in milli-degrees C but are stored in degrees C.

Reported-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Axel Lin <axel.lin@ingics.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
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
2.0.0

